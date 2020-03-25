import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';

part 'create_profile_event.dart';
part 'create_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  @override
  EditProfileState get initialState => EditProfileInitial();
  final profileService = new ProfileService();

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is SaveProfileEvent) {
      yield* _mapSaveProfileEventToState(event);
    }
    if (event is LoadProfileEvent) {
      yield* _mapLoadProfileEventToState(event);
    }
  }

  Stream<EditProfileState> _mapSaveProfileEventToState(
      SaveProfileEvent event) async* {
    await profileService.saveProfile(event.profile);
    yield new ProfileSaved();
  }

  Stream<EditProfileState> _mapLoadProfileEventToState(
      LoadProfileEvent event) async* {
    var profile = profileService.getProfile();
    yield new ProfileViewLoaded(profile);
  }
}
