import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurveBoxOptTwo extends StatelessWidget {
  final Color? boxColor;
  final String? headingTxt;
  final double? boxHeight;
  final String? subHeading;
  final SvgPicture? boxIcon;
  final String? txtSpan;
  final double? headingFontSize;
  final double? subHeadingFontSize;
  final FontWeight? headingFontWeight;
  final FontWeight? subhHadingFontWeight;
  const CurveBoxOptTwo({
    Key? key,
    required this.boxColor,
    this.headingTxt,
    this.subHeading,
    this.txtSpan,
    this.boxHeight,
    this.headingFontSize,
    this.subhHadingFontWeight,
    this.subHeadingFontSize,
    this.headingFontWeight,
    this.boxIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth / 2 - 34,
      child: Container(
        height: boxHeight,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(""),
                ),
                Container(child: boxIcon)
              ],
            ),
            const SizedBox(height: 5,),
            Expanded(
              child: Text(
                subHeading!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontSize: subHeadingFontSize,
                  fontWeight: subhHadingFontWeight,
                  height: 1.3,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
