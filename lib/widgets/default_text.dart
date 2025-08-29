import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefaultText extends StatelessWidget {
  DefaultText({
    super.key,
    this.isHedline6 = false,
    this.isCenter = false,
    this.isStart = false,
    this.h1size = 20,
    this.h2size = 16,
    this.color,
    required this.text,
  });

  double h1size;
  double h2size;
  bool isHedline6;
  Color? color;
  bool isCenter;
  bool isStart;
  String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '' : text,
      textDirection: TextDirection.rtl,
      overflow: TextOverflow.ellipsis,
      textAlign: isCenter
          ? TextAlign.center
          : isStart
              ? TextAlign.start
              : TextAlign.end,
      style: isHedline6
          ? TextStyle(
              color: color,
              fontSize: h1size,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            )
          : TextStyle(
              color: color,
              fontSize: h2size,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w200,
            ),
    );
  }
}
