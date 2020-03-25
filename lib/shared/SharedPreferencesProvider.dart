import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static String createAlertButtonShowCase = "createAlertButtonShowCase";
  static String createAlertViewShowCase = "createAlertViewShowCase";

  static String matchingAdsViewDeleteAdSwowCase =
      "matchingAdsViewDeleteAdSwowCase";
  static String matchingAdsViewNewAdSwowCase = "matchingAdsViewNewAdSwowCase";
  static String introScreenShow = "introScreenShow";
  static SharedPreferences preferences;

  static dynamic get(String key) {
    return preferences.get(key);
  }

  static Future saveString(String key, String value) async {
    await preferences.setString(key, value);
  }

  static Future remove(String key) async {
    await preferences.remove(key);
  }

  static Future<SharedPreferences> loadAndGetPrefs() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    return preferences;
  }
}
