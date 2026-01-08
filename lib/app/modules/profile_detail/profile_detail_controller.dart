import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

import '../../core/services/session_service.dart';
import '../../data/models/user_profile.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/app_snackbar.dart';

class ProfileDetailController extends GetxController {
  ProfileDetailController({
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _userRepository = userRepository ?? Get.find<UserRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final UserRepository _userRepository;
  final SessionService _sessionService;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();

  final selectedGender = RxnString();
  final isSaving = false.obs;
  final isLoading = false.obs;

  late String email;
  UserProfile? _initialProfile;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _initialProfile = _parseProfile(args['profile']);

    email = (args['email']?.toString() ??
            _initialProfile?.email ??
            _sessionService.email ??
            '')
        .trim();

    if (email.isEmpty) {
      throw ArgumentError('Email profil tidak ditemukan.');
    }

    emailController.text = email;

    _applyProfile(_initialProfile ?? _buildFromCache());

    if (_initialProfile == null) {
      fetchProfile();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    dateController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    final token = _sessionService.token;
    if (token == null || token.isEmpty) {
      return;
    }

    isLoading.value = true;
    try {
      final profile = await _userRepository.fetchProfile(token: token);
      _initialProfile = profile;
      _applyProfile(profile);
    } catch (error) {
      debugPrint('Gagal memuat profil detail: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final initial = _parseDateFromField(dateController.text) ??
        DateTime(DateTime.now().year - 18, 1, 1);

    final selected = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: initial,
      firstDate: DateTime(1960),
      lastDate: DateTime(DateTime.now().year - 5, 12, 31),
      dateFormat: 'dd-MMMM-yyyy',
      locale: DateTimePickerLocale.id,
      looping: true,
    );

    if (selected != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(selected);
    }
  }

  Future<void> save(BuildContext context) async {
    if (isSaving.value) {
      return;
    }

    final name = nameController.text.trim();
    final genderValue = selectedGender.value;
    final dateText = dateController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.show(context, 'Nama tidak boleh kosong');
      return;
    }

    if (genderValue == null || genderValue.isEmpty) {
      AppSnackbar.show(context, 'Pilih gender terlebih dahulu');
      return;
    }

    if (dateText.isEmpty) {
      AppSnackbar.show(context, 'Tanggal lahir harus diisi');
      return;
    }

    DateTime? date;
    try {
      date = DateFormat('dd/MM/yyyy').parse(dateText);
    } catch (_) {
      AppSnackbar.show(context, 'Format tanggal tidak valid');
      return;
    }

    final payload = <String, dynamic>{
      'email': email,
      'name': name,
      'gender': genderValue,
      'date_of_birth': DateFormat('yyyy-MM-dd').format(date),
    };

    isSaving.value = true;
    try {
      final updated = await _userRepository.updateProfile(
        email: email,
        payload: payload,
        token: _sessionService.token,
      );

      await _sessionService.saveProfile({
        'name': updated.name ?? name,
        'gender': _normalizeGender(updated.gender ?? genderValue),
        'work': updated.work ?? '',
        'date_of_birth':
            updated.dateOfBirth ?? DateFormat('yyyy-MM-dd').format(date),
      });

      AppSnackbar.show(context, 'Profil berhasil diperbarui');
      Get.back(result: updated);
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
    } catch (error) {
      AppSnackbar.show(context, 'Gagal memperbarui profil.');
      debugPrint('Gagal memperbarui profil: $error');
    } finally {
      isSaving.value = false;
    }
  }

  void selectGender(String value) {
    selectedGender.value = value;
  }

  void _applyProfile(UserProfile? profile) {
    if (profile == null) {
      return;
    }

    nameController.text = profile.name?.trim() ?? '';
    emailController.text = profile.email;
    selectedGender.value = _normalizeGender(profile.gender);
    dateController.text = _formatDateForField(profile.dateOfBirth);
  }

  UserProfile? _parseProfile(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return UserProfile.fromJson(raw);
    }
    return null;
  }

  UserProfile _buildFromCache() {
    final cached = _sessionService.loadProfile();
    return UserProfile(
      email: email,
      name: cached['name']?.toString(),
      gender: cached['gender']?.toString(),
      work: cached['work']?.toString(),
      dateOfBirth: cached['date_of_birth']?.toString(),
      height: cached['height'] is double
          ? cached['height'] as double
          : double.tryParse(cached['height']?.toString() ?? ''),
      weight: cached['weight'] is double
          ? cached['weight'] as double
          : double.tryParse(cached['weight']?.toString() ?? ''),
    );
  }

  String? _normalizeGender(String? gender) {
    if (gender == null) return null;
    final lower = gender.toLowerCase();
    if (lower == 'female' || gender == '0') {
      return '0';
    }
    if (lower == 'male' || gender == '1') {
      return '1';
    }
    return gender;
  }

  String _formatDateForField(String? raw) {
    if (raw == null || raw.isEmpty) {
      return '';
    }

    try {
      final parsed = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (_) {
      return raw;
    }
  }

  DateTime? _parseDateFromField(String text) {
    if (text.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yyyy').parse(text);
    } catch (_) {
      return null;
    }
  }
}
