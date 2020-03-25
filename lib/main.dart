import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:metakinisi/root.dart';
import 'package:metakinisi/shared/profileService.dart';
import 'package:metakinisi/viewModels/profileViewModel.dart';
import 'package:metakinisi/viewModels/sendSmsViewModel.dart';
import 'package:metakinisi/views/createProfile/profile_View.dart';
import 'package:metakinisi/views/main/bloc/bloc/main_bloc.dart';
import 'package:metakinisi/views/sendSmsForm/sendSmsForm.dart';
import 'SimpleBlocDelegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  Widget initialBloc = BlocProvider<MainBloc>(
    bloc: MainBloc()..dispatch(AppStarted()),
    child: MyApp(),
  );

  var appRoot = new AppRoot(child: initialBloc);

  runApp(appRoot);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sms Μετακίνησης',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<MainEvent, MainState>(
        bloc: BlocProvider.of<MainBloc>(context),
        builder: (BuildContext context, MainState state) {
          //var service = new ProfileService();
          if (state is ProfileDoesNotExistState) {
            return new ProfileView(profile: new ProfileViewModel());
          }
          return new SendSmsView(viewModel: new SendSmsViewModel());

          // if (state is AuthenticationAuthenticated) {
          //   return new BlocProvider<LoggedInShellBloc>(
          //     bloc: LoggedInShellBloc(),
          //     child: RootPage(auth),
          //   );
          // }
          // if (state is IntroViewPlaying) {
          //   return new IntroView();
          // }
          // if (state is AuthenticationUnauthenticated) {
          //   // For testing only
          //   //return new IntroView();
          //   return new LoginPage(userRepository: auth);
          // }
          // if (state is AuthenticationLoading) {
          //   return new LoadingIndicator();
          // }
        },
      ),
    );
  }
}
