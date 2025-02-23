import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save Data
  Future<void> saveData({required String key, required dynamic value}) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else {
      throw Exception("Unsupported data type");
    }
  }

  /// Retrieve Data
  dynamic getData({required String key}) {
    return _prefs.get(key);
  }

  /// Remove Data
  Future<void> removeData({required String key}) async {
    await _prefs.remove(key);
  }

  /// Clear All Data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
