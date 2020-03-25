part of 'create_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class CreateCreateProfileEvent extends EditProfileEvent {}

class LoadProfileEvent extends EditProfileEvent {
  // final ProfileViewModel profile;

  // LoadProfileEvent(this.profile);
}

class SaveProfileEvent extends EditProfileEvent {
  final ProfileViewModel profile;

  SaveProfileEvent (this.profile);
}
