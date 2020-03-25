part of 'create_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}


class ProfileViewLoading extends EditProfileState {
  ProfileViewLoading() : super();

  @override
  String toString() => 'ProfileViewLoading';
}

class ProfileViewLoaded extends EditProfileState {
  final ProfileViewModel profile;

  ProfileViewLoaded(this.profile);

  @override
  String toString() => 'ProfileViewLoaded';
}

class ProfileSaved extends EditProfileState {  
  @override
  String toString() => 'ProfileSaved';
}