import 'dart:async';

import 'package:metakinisi/shared/amplitudeLogProvider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metakinisi/shared/SharedPreferencesProvider.dart';
import 'package:metakinisi/shared/profileService.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() {
    AmplitudeLogProvider.logUserLogin();
  }

  final profileService = new ProfileService();
  @override
  MainState get initialState => MainInitial();

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    await SharedPreferencesProvider.loadAndGetPrefs();
    // profileService.deleteProfile();

    var profile = profileService.getProfile();

    if (profile == null) {
      yield ProfileDoesNotExistState();
    } else {
      if (event is LoadCreatedProfile) {
        yield LoadProfileState();
      } else {
        yield ProfileExistsState();
      }
    }
  }
}
