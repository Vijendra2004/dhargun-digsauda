import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String? name;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;

  const CommonText(
      {Key? key, this.fontColor, this.fontSize, this.name, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Flexible (child: Text('Some text here'))
    return Text(
      name!,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
