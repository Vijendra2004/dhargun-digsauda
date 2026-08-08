import 'package:flutter/material.dart';

class BorderBottom extends StatelessWidget {
  final Color? bottomColor;
  final double? bordeSize;
  const BorderBottom(
      {Key? key,
      this.bordeSize = 1.8,
      this.bottomColor = const Color(0x44A1A1A1)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: bottomColor!, width: bordeSize!),
        ),
      ),
    );
  }
}
