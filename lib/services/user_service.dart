import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _nameKey = 'user_name';
  static const String _baselinePssKey = 'baseline_pss';
  static const String _ageKey = 'user_age';
  static const String _genderKey = 'user_gender';

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  Future<int?> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_ageKey);
  }

  Future<void> saveAge(int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_ageKey, age);
  }

  Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_genderKey);
  }

  Future<void> saveGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender);
  }

  Future<double?> getBaselinePss() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_baselinePssKey);
  }

  Future<void> saveBaselinePss(double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_baselinePssKey, score);
  }
} 