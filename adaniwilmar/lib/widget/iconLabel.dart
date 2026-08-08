// ignore: file_names
import 'package:flutter/material.dart';

import '../config/constant.dart';

class IconLabel extends StatelessWidget {
  final double? borLRpadd;
  final double? borTBpadd;
  final double? borTLRadius;
  final double? borTRRadius;
  final double? borBLRadius;
  final double? borBRRadius;
  final String labelTxt;
  final double? labelTxtFtSz;
  final Color? labelTxtFtCol;
  final FontWeight? labelTxtFtWei;
  final Image? labelIc;
  const IconLabel(
      {Key? key,
      this.borTLRadius,
      this.borTRRadius,
      this.borBLRadius,
      this.borBRRadius,
      this.labelTxt = "",
      this.labelTxtFtSz,
      this.labelTxtFtCol,
      this.labelTxtFtWei,
      this.labelIc,
      this.borLRpadd,
      this.borTBpadd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: borLRpadd!,
          right: borLRpadd!,
          top: borTBpadd!,
          bottom: borTBpadd!),
      decoration: BoxDecoration(
        color: Constant.booSauStacolor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borTLRadius!),
          topRight: Radius.circular(borTRRadius!),
          bottomLeft: Radius.circular(borBLRadius!),
          bottomRight: Radius.circular(borBRRadius!),
        ),
      ),
      child: Row(
        children: [
          labelIc!,
          Text(
            labelTxt,
            style: TextStyle(
                fontSize: labelTxtFtSz,
                color: labelTxtFtCol,
                fontWeight: labelTxtFtWei),
          )
        ],
      ),
    );
  }
}
