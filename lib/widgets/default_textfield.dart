import 'package:edarhalfnadig/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class DefaultTextField extends StatelessWidget {
  DefaultTextField({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.isValidName = false,
    this.isValidNumber = false,
    this.isValidEmail = false,
    required this.type,
    this.onSubmit,
    required this.text,
    required this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.onChanged,
    this.suffixFunction,
    this.textForUnValid = 'هذا الحقل المطلوب',
  });
  TextEditingController controller;
  bool isPassword;
  bool isValidNumber;
  bool isValidName;
  bool isValidEmail;
  TextInputType type;
  Function? onSubmit;
  String text;
  IconData prefix;
  int? maxLines;
  IconData? suffix;
  Function? suffixFunction;
  final void Function(String)? onChanged;
  final String? textForUnValid;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        maxLines: maxLines,
        onTap: () {
          if (controller.selection ==
              TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length - 1))) {
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
        },
        textDirection: TextDirection.rtl,
        onChanged: onChanged,
        controller: controller,
        inputFormatters: isValidNumber == true
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        validator: (value) {
          if (value!.isEmpty) {
            return textForUnValid;
          }
          if (isValidName &&
              RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
            return 'أدخل الاسم صحيح';
          }
          if (isValidEmail == true &&
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value) ==
                  false) {
            return 'أدخل إيميل صحيح';
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit!(value);
          }
        },
        obscureText: isPassword ? true : false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            labelText: text,
            labelStyle: Theme.of(context).textTheme.displayMedium,
            prefixIcon: Icon(
              prefix,
              color: mainAndSubColor(context),
            ),
            suffixIcon: suffixFunction == null
                ? null
                : IconButton(
                    onPressed: () {
                      suffixFunction!();
                    },
                    icon: Icon(
                      suffix,
                      color: mainAndSubColor(context),
                    ),
                  ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: mainAndSubColor(context)!))),
      ),
    );
  }
}
