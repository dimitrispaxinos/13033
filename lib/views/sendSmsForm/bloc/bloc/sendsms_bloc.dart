import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:meta/meta.dart';
import 'package:metakinisi/shared/amplitudeLogProvider.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

part 'sendsms_event.dart';
part 'sendsms_state.dart';

class SendsmsBloc extends Bloc<SendsmsEvent, SendsmsState> {
  @override
  ProfileService profileService = new ProfileService();
  SendsmsState get initialState => SendsmsInitial(new SendSmsViewModel(null));

  @override
  Stream<SendsmsState> mapEventToState(
    SendsmsEvent event,
  ) async* {
    event.viewModel.profile = profileService.getProfile();
    event.viewModel.smsStatistics = profileService.getStatisticsOfTheDay();

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
    } else if (event is CreateSmsEvent) {
      await _goToSmsApp(event);
      yield new MovingCodeRemoved(event.viewModel);
    }
  }

  Future _goToSmsApp(CreateSmsEvent event) async {
    var profile = profileService.getProfile();

    await profileService.increaseSmsCounter(event.viewModel.movingCode);

    event.viewModel.smsStatistics = profileService.getStatisticsOfTheDay();

    String message = event.viewModel.movingCode.toString() +
        ' ' +
        profile.name +
        ' ' +
        profile.street +
        ' ' +
        profile.area;

    var recipients = new List<String>();
    recipients.add('13033');

    try {
      await sendSMS(message: message, recipients: recipients);
    } catch (error) {}

    AmplitudeLogProvider.logUserCreatedSms(event.viewModel.movingCode);
  }
}
