import 'package:metakinisi/viewModels/profileViewModel.dart';

class SendSmsViewModel{
  int movingCode;
  String reasonText;
  bool smsSend;
  ProfileViewModel profile;
  SendSmsViewModel(){
    smsSend = false;
  }
}