import 'package:flutter/material.dart';

class CurveOuterBox extends StatelessWidget {
  final Widget? boxofWidget;
  final double boxLRPadding;
  final double boxTBPadding;
  final Color boxShadowColor;
  final Color boxBorderColor;
  final double boxBorderWidth;
  final double boxBRRadius;
  final Color boxBgColor;
  const CurveOuterBox(
      {Key? key,
      this.boxofWidget,
      this.boxShadowColor = const Color(0x25000000),
      this.boxBorderColor = const Color(0xFFFFFFFF),
      this.boxBRRadius = 25,
      this.boxBorderWidth = 0,
      this.boxLRPadding = 14,
      this.boxTBPadding = 14,
      this.boxBgColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.only(
          left: boxLRPadding,
          right: boxLRPadding,
          top: boxTBPadding,
          bottom: boxTBPadding),
      decoration: BoxDecoration(
        border: Border.all(color: boxBorderColor, width: boxBorderWidth),
        color: boxBgColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(5.0),
          bottomLeft: const Radius.circular(5.0),
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
