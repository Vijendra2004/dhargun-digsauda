import 'package:flutter/material.dart';

class CurveBorderBox extends StatelessWidget {
  final Widget? boxofWidget;
  final double boxLRPadding;
  final double boxTOPPadding;
  final double boxBOTPadding;
  final double boxHeight;
  final Color boxShadowColor;
  final Color boxBorderColor;
  final double boxBorderWidth;
  final double boxBRRadius;
  final double boxTRRadius;
  final double boxBLRadius;
  final double boxTLRadius;
  final Color boxBgColor;
  const CurveBorderBox(
      {Key? key,
      this.boxofWidget,
      this.boxShadowColor = const Color(0x25000000),
      this.boxBorderColor = const Color(0xFFFFFFFF),
      this.boxBRRadius = 25,
        this.boxBLRadius=0,
        this.boxTLRadius=25,
        this.boxTRRadius=0,
      this.boxBorderWidth = 0,
      this.boxLRPadding = 0,
      this.boxTOPPadding = 0,
      this.boxBOTPadding = 0,
      this.boxHeight = 0,
      this.boxBgColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: EdgeInsets.only(
          left: boxLRPadding,
          right: boxLRPadding,
          top: boxTOPPadding,
          bottom: boxBOTPadding),
      decoration: BoxDecoration(
        border: Border.all(color: boxBorderColor, width: boxBorderWidth),
        color: boxBgColor,
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(boxTLRadius),
          topRight: Radius.circular(boxTRRadius),
          bottomLeft:  Radius.circular(boxBLRadius),
          bottomRight: Radius.circular(boxBRRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor,
            offset: const Offset(
              2.0,
              1.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 2.0,
          ),
          //BoxShadow
        ],
      ),
      child: boxofWidget,
    );
  }
}
