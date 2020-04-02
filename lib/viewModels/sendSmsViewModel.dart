import 'package:metakinisi/viewModels/profileViewModel.dart';

class SendSmsViewModel {
  int movingCode;
  String reasonText;
  bool smsSend;
  int numberOfSentMessages;
  ProfileViewModel profile;

  SendSmsViewModel(int msgNumber){
  //SendSmsViewModel() {
    smsSend = false;
    numberOfSentMessages = msgNumber;
  }
}
