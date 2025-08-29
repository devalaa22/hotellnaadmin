import 'package:flutter/material.dart';

import 'package:edarhalfnadig/shared/shared.dart';

class BaseAlertDialog extends StatelessWidget {
  final Color? yesColor;
  final Color? noColor;

  final String? title;
  final String? content;
  final String? yes;
  final String? no;
  final void Function()? yesOnPressed;
  final void Function()? noOnPressed;

  const BaseAlertDialog({
    super.key,
    this.yesColor = Colors.red,
    this.noColor = Colors.green,
    required this.title,
    required this.content,
    required this.yes,
    required this.no,
    required this.yesOnPressed,
    required this.noOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content!,
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actionsPadding: const EdgeInsets.only(bottom: 8.0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        defaultButton(context: context,
            height: 30,
            width: 80,
            color: yesColor,
            function: () {
              yesOnPressed!();
            },
            text: "$yes"),
        defaultButton(context: context,
            height: 30,
            width: 80,
            color: noColor,
            function: () {
              noOnPressed!();
            },
            text: "$no"),
      ],
    );
  }
}
