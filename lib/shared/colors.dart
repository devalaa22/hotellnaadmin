import 'package:edarhalfnadig/cubit/cubit.dart';
import 'package:flutter/material.dart'; 

Color white=Colors.white;
Color black=Colors.black;
Color grey100=Colors.grey.shade100; 
Color red=Colors.red; 

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

MaterialColor mainColor = buildMaterialColor(const Color(0xFF4e186a));
MaterialColor subColor = buildMaterialColor(const Color(0xFF2bb673));
Color? mainAndSubColor(context) {
  return AppCubit.get(context).isDark ? mainColor : subColor;
}
