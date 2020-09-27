import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeStyle {
  var toolBarTitleTheme = AppBarTheme(
    textTheme: TextTheme(
      headline1: TextStyle(
          color: Colors.white,
          fontFamily: "NotoSansKR",
          fontWeight: FontWeight.bold,
          fontSize: 24),
    ),
    color: Colors.green,
  );

  get theme {
    return ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.white,
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Colors.black, fontFamily: "NotoSansKR", fontSize: 18),
            bodyText2: TextStyle(
                color: Colors.black, fontFamily: "NotoSansKR", fontSize: 16),
            headline2: TextStyle(
                color: Colors.white, fontFamily: "NotoSansKR", fontSize: 18),
            subtitle1: TextStyle(
                color: Colors.black,
                fontFamily: "AveriaLibre",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
            subtitle2: TextStyle(
                color: Colors.black, fontFamily: "NotoSansKR", fontSize: 18),
            headline1: TextStyle(
                color: Colors.black,
                fontFamily: "NotoSansKR",
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        appBarTheme: toolBarTitleTheme);
  }

  get cupertinoTheme {
    return CupertinoThemeData(
      primaryColor: Colors.green,
          textTheme: CupertinoTextThemeData(
          )
    );
  }

}
