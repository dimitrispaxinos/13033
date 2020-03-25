part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class AppStarted extends MainEvent {
  @override
  String toString() => 'AppStarted';
}


