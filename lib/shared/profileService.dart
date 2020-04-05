import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:metakinisi/shared/categoryStatistics.dart';
import 'package:metakinisi/shared/smsStatistics.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';
import 'package:metakinisi/shared/SharedPreferencesProvider.dart';

class ProfileService {
  static String profileName = "profileName";
  static String profileStreet = "profileStreet";
  static String profileArea = "profileArea";
  static String totalNumberOfMessages = "totalNumberOfMessages";
  static String statisticsKey = "statistics";

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

  SmsStatistics getStatisticsOfTheDay() {
    return getStatistics(getTodayDateString());
  }

  SmsStatistics getStatistics(String date) {
    date = getTodayDateString();

    var statsString = SharedPreferencesProvider.get(statisticsKey + date);
    if (statsString == null) {
      var newStats = new SmsStatistics(date, new List<CategoryStatistics>());
      newStats.addStatistics();
      return newStats;
    }

    var map = jsonDecode(statsString);
    var stats = SmsStatistics.fromJson(map);
    return stats;
  }

  Future saveStatistics(SmsStatistics stats) async {
    //JsonConverter<>.
    var statsJson = stats.toJson(); //.toString();
    var statsString = jsonEncode(statsJson);
    await SharedPreferencesProvider.saveString(
        statisticsKey + stats.date, statsString);
  }

  // Increases daily and overall counter as well
  Future increaseSmsCounter(int category) async {
    await _increaseDailySms(category);
    await _increaseTotalNumberOfSms();
  }

  int getMessagesNumberOfTheDay() {
    var key = getTodayDateString();
    return _parseStoredIntNumber(key);
  }

  int getTotalMessagesNumber() {
    return _parseStoredIntNumber(totalNumberOfMessages);
  }

  Future _increaseDailySms(int category) async {
    var stats = getStatisticsOfTheDay();
    stats = stats ?? new SmsStatistics(getTodayDateString(), null);

    stats.allCategoryStatistics[category - 1].numberOfMessages =
        stats.allCategoryStatistics[category - 1].numberOfMessages + 1;

    await saveStatistics(stats);
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

  String getTodayDateString() {
    var now = new DateTime.now();
    //var formatter = new DateFormat('yyyy-MM-dd');
    var formatter = new DateFormat('yyyyMMdd');
    String formatted = formatter.format(now);
    return formatted;
  }
}
