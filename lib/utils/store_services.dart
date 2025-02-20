import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _isLoggedInKey = "isLoggedIn";


  static Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }
}
