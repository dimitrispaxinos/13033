import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metakinisi/shared/SharedPreferencesProvider.dart';
import 'package:metakinisi/shared/profileService.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
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
    }

    // TODO: implement mapEventToState
  }
}
