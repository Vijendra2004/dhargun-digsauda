import 'package:flutter/material.dart';

class CustomTextFromField extends StatelessWidget {
  final String? textLabl;
  final Image? sufIcon;
  final TextEditingController controller;
  final bool password;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextInputType? keyborType;
  final bool? passWorCircle;
  final int? maxLength;

  const CustomTextFromField({
    Key? key,
    this.textLabl,
    this.sufIcon,
    required this.controller,
    this.fontWeight,
    this.fontSize,
    this.keyborType,
    this.maxLength = null,
    this.password = false,
    this.passWorCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: TextFormField(
        keyboardType: keyborType,
        controller: controller,
        obscureText: password,
        maxLength: maxLength,
        style: TextStyle(
            fontSize: fontSize, color: Colors.black, fontWeight: fontWeight),
        decoration: InputDecoration(
          suffixIcon: Container(
              width: 10,
              height: 10,
              padding: const EdgeInsets.all(14),
              child: sufIcon),
          labelText: textLabl,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xFFB1B1B1), width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
            ),
            borderSide: BorderSide(color: Color(0xFFB1B1B1), width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
            ),
            borderSide: BorderSide(color: Color(0xFFB1B1B1), width: 1),
          ),
          hintStyle: const TextStyle(color: Colors.black),
          enabled: true,
        ),
      ),
    );
  }
}
