part of 'sendsms_bloc.dart';

@immutable
abstract class SendsmsEvent {
  final SendSmsViewModel viewModel;

  SendsmsEvent(this.viewModel);
}

class AddMovingCodeEvent extends SendsmsEvent {
  AddMovingCodeEvent(SendSmsViewModel viewModel) : super(viewModel);
}


class RemoveMovingCodeEvent extends SendsmsEvent {
  RemoveMovingCodeEvent(SendSmsViewModel viewModel) : super(viewModel);
}

