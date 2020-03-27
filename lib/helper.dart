
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class Helper {
  static BuildContext _currentContext;

  static Color getStandardThemeColor() {
    return Color.fromRGBO(25, 94, 230, 1);
  }

  static TextStyle getStandardTextStyle() {
    return new TextStyle(fontSize: 15);
  }

  static void storeCurrentcontext(BuildContext context) {
    _currentContext = context;
  }

  static BuildContext getCurrentcontext() {
    return _currentContext;
  }

  static TextStyle getCustomFont(int color, double fontSize, String fontName) {
    return new TextStyle(
        // set color of text
        color: Color(color),
        // set the font family as defined in pubspec.yaml
        fontFamily: fontName,
        // set the font weight
        fontWeight: FontWeight.w400,
        // set the font size
        fontSize: fontSize);
  }


  static TextStyle getIntroTextStyle() {
    return TextStyle(fontSize: 20, color: Colors.white, height: 1.7);
  }

  static TextStyle getIntroTitleTextStyle() {
    return TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: Colors.white,
        height: 1.7,
        letterSpacing: 0.9);
  }
}

// String _translate(String key, BuildContext context) {
//   return AppLocalizations.of(context).tr(key);
// }
