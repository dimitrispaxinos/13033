
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:showcaseview/showcase.dart';

class Helper {
  static BuildContext _currentContext;

  // static Future<String> getCurrentUserEmail() async {
  //   var user = await getCurrentUser();
  //   return user.email;
  // }


  // static String formatDateTime(DateTime date) {
  //   if (date == null) return "";

  //   var formatter = new DateFormat('dd/MM/yyyy kk:mm a');
  //   String formattedTime = formatter.format(date);
  //   return formattedTime;
  // }

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

  // static Showcase buildShowCase(
  //     BuildContext context,
  //     GlobalKey showCaseKey,
  //     String titleTranslationTag,
  //     String descriptionTranslationTag,
  //     Widget child) {
  //   return _buildShowCaseBase(context, showCaseKey, titleTranslationTag,
  //       descriptionTranslationTag, null, child);
  // }

  // static Showcase buildCircularShowCase(
  //     BuildContext context,
  //     GlobalKey showCaseKey,
  //     String titleTranslationTag,
  //     String descriptionTranslationTag,
  //     Widget child) {
  //   return _buildShowCaseBase(context, showCaseKey, titleTranslationTag,
  //       descriptionTranslationTag, CircleBorder(), child);
  // }

  // static Showcase _buildShowCaseBase(
  //     BuildContext context,
  //     GlobalKey showCaseKey,
  //     String titleTranslationTag,
  //     String descriptionTranslationTag,
  //     ShapeBorder shapeBorder,
  //     Widget child) {
  //   var showCase = Showcase(
  //       key: showCaseKey,
  //       title: _translate(titleTranslationTag, context),
  //       description: _translate(descriptionTranslationTag, context),
  //       showcaseBackgroundColor: Helper.getStandardThemeColor(),
  //       shapeBorder: shapeBorder,
  //       disableAnimation: true,
  //       //animationDuration: Duration(milliseconds: 0),
  //       descTextStyle: new TextStyle(fontSize: 13, color: Colors.white),
  //       titleTextStyle: new TextStyle(
  //           fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
  //       child: child);
  //   return showCase;
  // }

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
