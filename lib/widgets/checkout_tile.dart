import 'package:flutter/material.dart';

class CheckoutDetailTile extends StatelessWidget {
  const CheckoutDetailTile({
    super.key,
    required this.text,
    required this.icon,
    this.color,
  });

  final String text;
  final Color? color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      title: Text(
        text,
        style: TextStyle(color: color),
        textDirection: TextDirection.rtl,
      ),
      trailing: Icon(
        icon,
        color: color,
      ),
    );
  }
}
