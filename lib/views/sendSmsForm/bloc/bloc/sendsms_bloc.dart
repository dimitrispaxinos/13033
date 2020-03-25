import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metakinisi/viewModels/sendSmsViewModel.dart';

part 'sendsms_event.dart';
part 'sendsms_state.dart';

class SendsmsBloc extends Bloc<SendsmsEvent, SendsmsState> {
  @override
  SendsmsState get initialState => SendsmsInitial(new SendSmsViewModel());

  @override
  Stream<SendsmsState> mapEventToState(
    SendsmsEvent event,
  ) async* {
    if (event is AddMovingCodeEvent) {
      yield new MovingCodeAdded(event.viewModel);
    }

    if (event is RemoveMovingCodeEvent) {
      event.viewModel.movingCode = null;
      event.viewModel.reasonText = null;
      yield new MovingCodeRemoved(event.viewModel);
    }
  }
}
