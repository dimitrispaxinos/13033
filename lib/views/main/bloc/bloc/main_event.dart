part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class AppStarted extends MainEvent {
  @override
  String toString() => 'AppStarted';
}

class ProfileCreated extends MainEvent {
  @override
  String toString() => 'ProfileCreated';
}


class LoadCreatedProfile extends MainEvent {
  @override
  String toString() => 'LoadCreatedProfile';
}

class ShareApplication extends MainEvent {
  @override
  String toString() => 'ShareApplication';
}