import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/services/session_service.dart';
import '../../data/models/user_profile.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/app_snackbar.dart';

class ProfileController extends GetxController {
  ProfileController({
    UserRepository? userRepository,
    AuthRepository? authRepository,
    SessionService? sessionService,
    ImagePicker? imagePicker,
  })  : _userRepository = userRepository ?? Get.find<UserRepository>(),
        _authRepository = authRepository ?? Get.find<AuthRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>(),
        _imagePicker = imagePicker ?? ImagePicker();

  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final SessionService _sessionService;
  final ImagePicker _imagePicker;

  final profile = Rxn<UserProfile>();
  final isLoading = false.obs;
  final isLoggingOut = false.obs;
  final avatarPath = RxnString();

  String get email => profile.value?.email.isNotEmpty == true
      ? profile.value!.email
      : (_sessionService.email ?? '');

  String get displayName {
    final name = profile.value?.name?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return 'Pengguna Sleepy';
  }

  String get displayEmail => email;

  String get displayGender {
    final gender = profile.value?.gender?.toLowerCase();
    if (gender == '0' || gender == 'female') {
      return 'Perempuan';
    }
    if (gender == '1' || gender == 'male') {
      return 'Pria';
    }
    return '-';
  }

  String get displayDateOfBirth {
    final dob = profile.value?.dateOfBirth;
    if (dob == null || dob.isEmpty) {
      return '-';
    }
    try {
      final parsed = DateTime.parse(dob);
      return DateFormat('dd MMMM yyyy', 'id').format(parsed);
    } catch (_) {
      return dob;
    }
  }

  String get displayWork {
    final work = profile.value?.work;
    if (work == null || work.isEmpty) {
      return '-';
    }
    return work;
  }

  @override
  void onInit() {
    super.onInit();
    _loadCachedProfile();
    _loadCachedAvatar();
  }

  @override
  void onReady() {
    super.onReady();
    fetchProfile(forceLoading: true);
  }

  Future<void> fetchProfile({bool forceLoading = false}) async {
    final token = _sessionService.token;
    if (token == null || token.isEmpty) {
      return;
    }

    if (forceLoading) {
      isLoading.value = true;
    }

    try {
      final result = await _userRepository.fetchProfile(token: token);
      profile.value = result;
      await _sessionService.saveProfile({
        'name': result.name ?? '',
        'gender': _normalizeGenderForStorage(result.gender),
        'work': result.work ?? '',
        'date_of_birth': result.dateOfBirth ?? '',
        if (result.height != null) 'height': result.height,
        if (result.weight != null) 'weight': result.weight,
      });
    } catch (error) {
      debugPrint('Failed to fetch profile: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile(forceLoading: false);
  }

  Future<void> pickAvatar(BuildContext context) async {
    final currentEmail = email;
    if (currentEmail.isEmpty) {
      AppSnackbar.show(context, 'Email tidak ditemukan.');
      return;
    }

    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        return;
      }

      avatarPath.value = picked.path;
      await _sessionService.saveProfileImagePath(currentEmail, picked.path);
    } catch (error) {
      debugPrint('Failed to pick avatar: $error');
      AppSnackbar.show(context, 'Gagal mengambil gambar profil.');
    }
  }

  Future<void> openProfileDetail() async {
    final currentProfile = profile.value ??
        UserProfile(
          email: email,
          name: displayName,
          gender: profile.value?.gender,
          work: profile.value?.work,
          dateOfBirth: profile.value?.dateOfBirth,
        );

    final result = await Get.toNamed(
      AppRoutes.profileDetail,
      arguments: {
        'profile': currentProfile.toJson(),
      },
    );

    if (result is UserProfile) {
      profile.value = result;
      await _sessionService.saveProfile({
        'name': result.name ?? '',
        'gender': _normalizeGenderForStorage(result.gender),
        'work': result.work ?? '',
        'date_of_birth': result.dateOfBirth ?? '',
        if (result.height != null) 'height': result.height,
        if (result.weight != null) 'weight': result.weight,
      });
      profile.refresh();
    }
  }

  void openFeedback() {
    Get.toNamed(AppRoutes.feedback);
  }

  void openTerms(BuildContext context) {
    AppSnackbar.show(context, 'Syarat & Ketentuan akan tersedia segera.');
  }

  Future<void> confirmLogout(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF272E49),
        title: const Text(
          'Keluar dari akun',
          style: TextStyle(color: Colors.white, fontFamily: 'Urbanist'),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar?',
          style: TextStyle(color: Colors.white70, fontFamily: 'Urbanist'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    if (isLoggingOut.value) {
      return;
    }

    isLoggingOut.value = true;
    final token = _sessionService.token;
    final currentEmail = _sessionService.email ?? '';
    String? errorMessage;
    try {
      if (token != null && token.isNotEmpty) {
        await _authRepository.logout(token);
      }
    } on ApiClientException catch (error) {
      errorMessage = error.message;
      debugPrint('Failed to logout remotely: $error');
    } catch (error) {
      errorMessage = 'Gagal keluar dari server';
      debugPrint('Failed to logout remotely: $error');
    } finally {
      try {
        if (currentEmail.isNotEmpty) {
          await _sessionService.removeProfileImagePath(currentEmail);
        }
        await _sessionService.clear();
      } finally {
        isLoggingOut.value = false;
        Get.offAllNamed(AppRoutes.login);
        Get.rawSnackbar(
          message: errorMessage ?? 'Berhasil logout',
          backgroundColor:
              errorMessage == null ? const Color(0xFF00ADB5) : Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  void _loadCachedProfile() {
    final storedEmail = _sessionService.email ?? '';
    final cached = _sessionService.loadProfile();
    if (storedEmail.isEmpty && cached.isEmpty) {
      return;
    }

    profile.value = UserProfile(
      email: storedEmail,
      name: (cached['name']?.toString().trim().isNotEmpty ?? false)
          ? cached['name'].toString()
          : null,
      gender: cached['gender']?.toString(),
      work: cached['work']?.toString(),
      dateOfBirth: cached['date_of_birth']?.toString(),
      height: _tryParseDouble(cached['height']),
      weight: _tryParseDouble(cached['weight']),
    );
  }

  void _loadCachedAvatar() {
    final storedEmail = _sessionService.email ?? '';
    if (storedEmail.isEmpty) {
      return;
    }
    final cachedPath = _sessionService.getProfileImagePath(storedEmail);
    if (cachedPath != null &&
        cachedPath.isNotEmpty &&
        File(cachedPath).existsSync()) {
      avatarPath.value = cachedPath;
    }
  }

  String _normalizeGenderForStorage(String? gender) {
    if (gender == null) return '';
    final lower = gender.toLowerCase();
    if (lower == 'female' || gender == '0') {
      return '0';
    }
    if (lower == 'male' || gender == '1') {
      return '1';
    }
    return gender;
  }

  double? _tryParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
