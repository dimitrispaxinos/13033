part of 'sendsms_bloc.dart';

@immutable
abstract class SendsmsState {
  final SendSmsViewModel viewModel;

  SendsmsState(this.viewModel);
}

class SendsmsInitial extends SendsmsState {
  SendsmsInitial(SendSmsViewModel viewModel) : super(viewModel);
}

class MovingCodeAdded extends SendsmsState {
  MovingCodeAdded(SendSmsViewModel viewModel) : super(viewModel);
}

class MovingCodeRemoved extends SendsmsState {
  MovingCodeRemoved(SendSmsViewModel viewModel) : super(viewModel);
}

