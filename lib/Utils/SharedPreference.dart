import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences prefs;
  static String token = 'token';
  static String loginData = 'loginData';

  static addStringToSF(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getStringValuesSF(String key) async {
    prefs = await SharedPreferences.getInstance();
    return (prefs.getString(key) != null)?prefs.getString(key):'';
  }

  static Future removeValues(String key) async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future containsKey(String key) async{
    prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
