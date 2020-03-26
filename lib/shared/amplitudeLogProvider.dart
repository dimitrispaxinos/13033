import 'package:amplitude_flutter/amplitude_flutter.dart';

class AmplitudeLogProvider {
  static final AmplitudeFlutter analytics =      
      AmplitudeFlutter('74ca33e75a51ed07873a75ac4a43179f');
  static final Identify identify = Identify();

  static String _usedStoredAddress = "user_stored_address";
  static String _usedCreatedSms = "user_created_sms";
  static String _userLoggedIn = "user_logged_in";

  static Future<AmplitudeFlutter> getAmplitudeAsync() async {
    return analytics;
  }

// add this event
  static Future<void> logUserLogin() async {
    Identify().add('login_count', 1);
    await analytics.logEvent(name: _userLoggedIn);
  }

  static Future<void> logUserStoredAddress() async {
    await analytics.logEvent(name: _usedStoredAddress);
  }

  static Future<void> logUserCreatedSms(int reasonCode) async {
    await analytics.logEvent(name: _usedCreatedSms, properties: {
      'event_properties': {'reason_code': reasonCode}
    });
  }
}
