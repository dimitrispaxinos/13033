import 'package:metakinisi/shared/categoryStatistics.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/shared/smsStatistics.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';

class SendSmsViewModel {
  int movingCode;
  String reasonText;
  bool smsSend;
  SmsStatistics smsStatistics;
  ProfileViewModel profile;

  SendSmsViewModel(this.smsStatistics) {
    smsSend = false;
   // var ps = new ProfileService();

    // smsStatistics = smsStatistics ??
    //     new SmsStatistics(
    //         ps.getTodayDateString(), new List<CategoryStatistics>());
    // smsStatistics.addStatistics();
  }
}
