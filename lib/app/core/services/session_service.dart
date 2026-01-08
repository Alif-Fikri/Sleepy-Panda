import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends GetxService {
  SharedPreferences? _prefs;

  Future<SessionService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get token => _prefs?.getString('token');

  Future<void> saveToken(String token) async {
    await _prefs?.setString('token', token);
  }

  Future<void> saveEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  String? get email => _prefs?.getString('email');

  Future<void> saveProfile(Map<String, dynamic> data) async {
    if (_prefs == null) return;
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value == null) {
        await _prefs!.remove(key);
      }
    }
  }

  Map<String, dynamic> loadProfile() {
    if (_prefs == null) return {};
    return {
      'name': _prefs!.getString('name'),
      'gender': _prefs!.getString('gender'),
      'work': _prefs!.getString('work'),
      'date_of_birth': _prefs!.getString('date_of_birth'),
      'height': _prefs!.getDouble('height'),
      'weight': _prefs!.getDouble('weight'),
    };
  }

  Future<void> saveProfileImagePath(String email, String path) async {
    if (email.isEmpty) return;
    await _prefs?.setString('${email}_profile_image', path);
  }

  String? getProfileImagePath(String email) {
    if (email.isEmpty) return null;
    return _prefs?.getString('${email}_profile_image');
  }

  Future<void> removeProfileImagePath(String email) async {
    if (email.isEmpty) return;
    await _prefs?.remove('${email}_profile_image');
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
