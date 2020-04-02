import 'package:intl/intl.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';
import 'package:metakinisi/shared/SharedPreferencesProvider.dart';

class ProfileService {
  static String profileName = "profileName";
  static String profileStreet = "profileStreet";
  static String profileArea = "profileArea";
  static String totalNumberOfMessages = "profileArea";
//static String profileName = "profileName";

  ProfileViewModel getProfile() {
    var profileName = SharedPreferencesProvider.get('profileName');
    if (profileName == null) return null;
    var vm = new ProfileViewModel();
    vm.name = SharedPreferencesProvider.get('profileName');
    vm.street = SharedPreferencesProvider.get('profileStreet');
    vm.area = SharedPreferencesProvider.get('profileArea');

    return vm;
  }

  Future saveProfile(ProfileViewModel vm) async {
    SharedPreferencesProvider.saveString('profileName', vm.name);
    SharedPreferencesProvider.saveString('profileStreet', vm.street);
    SharedPreferencesProvider.saveString('profileArea', vm.area);
  }

  Future deleteProfile() async {
    await SharedPreferencesProvider.remove('profileName');
    await SharedPreferencesProvider.remove('profileStreet');
    await SharedPreferencesProvider.remove('profileArea');
  }

  // Increases daily and overall counter as well
  Future increaseSmsCounter() async {
    await _increaseDailySms();
    await _increaseTotalNumberOfSms();
  }

  int getMessagesNumberOfTheDay() {
    var key = _getTodayDateString();
    return _parseStoredIntNumber(key);
  }

  int getTotalMessagesNumber() {
    return _parseStoredIntNumber(totalNumberOfMessages);
  }

  Future _increaseDailySms() async {
    var key = _getTodayDateString();
    var alreadySentMessages = getMessagesNumberOfTheDay();
    await SharedPreferencesProvider.saveString(
        key, (alreadySentMessages + 1).toString());
  }

  Future _increaseTotalNumberOfSms() async {
    var alreadySentMessages = _parseStoredIntNumber(totalNumberOfMessages);
    await SharedPreferencesProvider.saveString(
        totalNumberOfMessages, (alreadySentMessages + 1).toString());
  }

  int _parseStoredIntNumber(String key) {
    var number = SharedPreferencesProvider.get(key);
    if (number != null) {
      try {
        return int.parse(number);
      } catch (error) {
        return 0;
      }
    }
    return 0;
  }

  String _getTodayDateString() {
    var now = new DateTime.now();
    //var formatter = new DateFormat('yyyy-MM-dd');
    var formatter = new DateFormat('yyyyMMdd');
    String formatted = formatter.format(now);
    return formatted;
  }
}
