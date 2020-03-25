import 'package:flutter/material.dart';

class AppRoot extends InheritedWidget {
  const AppRoot({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AppRoot of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppRoot);
  }
}