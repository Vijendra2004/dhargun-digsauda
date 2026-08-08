import 'package:flutter/material.dart';

class CommonLabel extends StatelessWidget {
  final Color? bgColor;
  final String? name;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? icondata;
  final Icon? imageic;
  final bool? imagetrue;
  final double? labelRadiusBig;
  final double? labelRadiusSmall;
  final Color? iconColor;
  final double? iconSize;
  final double? paddingTop;
  final double? paddingBottom;
  const CommonLabel(
      {Key? key,
      this.bgColor,
      this.fontColor,
      this.fontSize,
      this.fontWeight,
      this.name,
      this.icondata,
      this.imageic,
      this.imagetrue = false,
      this.iconColor,
      this.iconSize,
      this.paddingTop = 2,
      this.paddingBottom = 2,
      this.labelRadiusBig = 9.0,
      this.labelRadiusSmall = 1.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 6, right: 9, top: paddingTop!, bottom: paddingBottom!),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(labelRadiusBig!),
          topRight: Radius.circular(labelRadiusSmall!),
          bottomLeft: Radius.circular(labelRadiusSmall!),
          bottomRight: Radius.circular(labelRadiusBig!),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            child: imagetrue == true
                ? SizedBox(width: 16, height: 16, child: imageic)
                : icondata != null
                    ? Icon(
                        icondata!,
                        color: iconColor,
                        size: iconSize,
                      )
                    : Container(),
          ),
          Text(
            name!,
            style: TextStyle(
                fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
          )
        ],
      ),
    );
  }
}
