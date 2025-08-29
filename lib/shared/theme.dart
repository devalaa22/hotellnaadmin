import 'package:edarhalfnadig/shared/colors.dart';
import 'package:flutter/material.dart';

const double h1size = 24;
const double h2size = 16;

ThemeData lightMode() => ThemeData(
    fontFamily: 'Ibm',
    cardColor: subColor.withOpacity(0.8),
    colorSchemeSeed: subColor,
    dividerColor: subColor,
    canvasColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: h1size,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: h2size,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w200,
      ),
    ),
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(color: Colors.white));

ThemeData darkMode() => ThemeData(
    fontFamily: 'Ibm',
    colorSchemeSeed: mainColor,
    canvasColor: Colors.white,
    dividerColor: mainColor,
    cardColor: Colors.white60.withOpacity(0.5),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: h1size,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: h2size,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w200,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black87));
