part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}


class ProfileDoesNotExistState extends MainState {  }

class ProfileExistsState extends MainState {  }
class LoadProfileState extends MainState {  }