import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:metakinisi/root.dart';
import 'package:metakinisi/shared/SharedPreferencesProvider.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';
import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:metakinisi/views/createProfile/profile_View.dart';
import 'package:metakinisi/views/main/bloc/bloc/main_bloc.dart';
import 'package:metakinisi/views/sendSmsForm/sendSmsForm.dart';
import 'SimpleBlocDelegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferencesProvider.loadAndGetPrefs().then((value) {
    BlocSupervisor.delegate = SimpleBlocDelegate();
    BlocSupervisor.delegate = SimpleBlocDelegate();

    Widget initialBloc = BlocProvider<MainBloc>(
      bloc: MainBloc()..dispatch(AppStarted()),
      child: MyApp(),
    );

    var appRoot = new AppRoot(child: initialBloc);

    runApp(appRoot);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sms Μετακίνησης',
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
        accentColor: Colors.orange,
        // is not restarted.
        primarySwatch: Colors.blue,

        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(
              fontSize: 17.0, fontFamily: 'Hind', color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 18.0, fontFamily: 'Hind', color: Colors.white),
          //new TextStyle(fontSize: 18.0, color: Colors.white
        ),
      ),
      home: BlocBuilder<MainEvent, MainState>(
        bloc: BlocProvider.of<MainBloc>(context),
        builder: (BuildContext context, MainState state) {
          if (state is ProfileDoesNotExistState || state is LoadProfileState) {
            return new ProfileView(profile: new ProfileViewModel());
          }

          if (state is LoadProfileState) {
            var service = new ProfileService();
            return new ProfileView(profile: service.getProfile());
          }
          var profileService = new ProfileService();
          var dailyStats = profileService.getStatisticsOfTheDay();

          return new SendSmsView(viewModel: new SendSmsViewModel(dailyStats));
        },
      ),
    );
  }
}
