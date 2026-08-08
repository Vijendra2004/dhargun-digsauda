import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String? buttonName;
  final double? buttonNameSize;
  final Color? buttonNameColor;
  final Color? buttonColor;
  final double? buttonHeight;
  final double? buttonRadiusTL;
  final double? buttonRadiusBL;
  final Color? buttonBorder;
  final Function? buttonFunction;
  final FontWeight? buttonNameWeight;
  const CommonButton(
      {Key? key,
      this.buttonName,
      this.buttonColor,
      this.buttonHeight,
      this.buttonRadiusTL,
      this.buttonRadiusBL,
      this.buttonNameColor,
      this.buttonNameSize,
      this.buttonBorder,
      this.buttonFunction,
      this.buttonNameWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: buttonHeight ?? 45,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: buttonBorder ?? Colors.transparent),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(buttonRadiusTL ?? 15.0),
              topRight: Radius.circular(buttonRadiusBL ?? 5.0),
              bottomLeft: Radius.circular(buttonRadiusBL ?? 5.0),
              bottomRight: Radius.circular(buttonRadiusTL ?? 15.0))),
      onPressed: () {
        if (buttonFunction != null) {
          buttonFunction!();
        }
      },
      child: Text(
        buttonName ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: buttonNameSize ?? 14.0,
            color: buttonNameColor ?? Colors.black,
            fontWeight: buttonNameWeight),
      ),
      color: buttonColor ?? Colors.blue,
    );
  }
}
