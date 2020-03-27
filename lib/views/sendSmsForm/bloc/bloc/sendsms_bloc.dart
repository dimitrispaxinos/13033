import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

part 'sendsms_event.dart';
part 'sendsms_state.dart';

class SendsmsBloc extends Bloc<SendsmsEvent, SendsmsState> {
  @override
  SendsmsState get initialState => SendsmsInitial(new SendSmsViewModel());
  ProfileService profileService = new ProfileService();

  @override
  Stream<SendsmsState> mapEventToState(
    SendsmsEvent event,
  ) async* {
    event.viewModel.profile = profileService.getProfile();

    if (event is AddMovingCodeEvent) {
      yield new MovingCodeAdded(event.viewModel);
    } else if (event is RemoveMovingCodeEvent) {
      event.viewModel.movingCode = null;
      event.viewModel.reasonText = null;
      yield new MovingCodeRemoved(event.viewModel);
    } else if (event is OpenEmailEvent) {
      var emailUrl = 'mailto:dpaxinos@gmail.com?subject=13303 Feedback';

      if (await canLaunch(emailUrl)) await launch(emailUrl);
      yield new MovingCodeRemoved(event.viewModel);
    }
  }
}
