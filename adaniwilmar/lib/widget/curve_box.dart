import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurveBox extends StatelessWidget {
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
  final num? boxSize;
  final num? miniusValue;
  final SvgPicture? spamIcon;
  final double? iconWidth;
  final double? iconHeight;
  final Color? headingTxtColor;
  final double? paddingRight;
  final double? paddingLeft;
  final Color? subHeadingTextColor;

  const CurveBox(
      {Key? key,
      required this.boxColor,
      this.headingTxt = "",
      this.subHeading,
      this.txtSpan = "",
      this.boxHeight,
      this.headingFontSize,
      this.subhHadingFontWeight,
      this.subHeadingFontSize,
      this.headingFontWeight,
      this.boxIcon,
      this.boxSize,
      this.miniusValue,
      this.spamIcon,
      this.iconWidth = 24,
      this.iconHeight = 24,
      this.headingTxtColor = Colors.white,
      this.paddingRight = 8.0,
      this.paddingLeft = 8.0,
      this.subHeadingTextColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / boxSize! - miniusValue!,
      child: Container(
          height: boxHeight,
          margin: const EdgeInsets.only(bottom: 0),
          padding: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              left: paddingLeft ?? 8,
              right: paddingRight ?? 8),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              title: (txtSpan != "")
                  ? Row(
                      children: [
                        (spamIcon != null)
                            ? Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: SizedBox(
                                    width: iconWidth,
                                    height: iconHeight,
                                    child: spamIcon))
                            : Visibility(visible: false, child: Text("")),
                        Text(headingTxt!,
                            softWrap: true,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: headingTxtColor,
                                      fontWeight: headingFontWeight,
                                      fontSize: headingFontSize,
                                    )),
                        Text(txtSpan!,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.white)),
                      ],
                    )
                  : Text(headingTxt!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: headingTxtColor,
                            fontWeight: headingFontWeight,
                            fontSize: 14,
                          )),
              subtitle: (subHeading != '')
                  ? Text(
                      subHeading!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: subHeadingTextColor,
                            fontSize: subHeadingFontSize,
                            fontWeight: subhHadingFontWeight,
                          ),
                    )
                  : null,
              trailing: (boxIcon != null)
                  ? SizedBox(
                      width: iconWidth, height: iconHeight, child: boxIcon)
                  : null)),
    );
  }
}

class CurveBox1 extends StatelessWidget {
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
  final num? boxSize;
  final num? miniusValue;
  final SvgPicture? spamIcon;
  final double? iconWidth;
  final double? iconHeight;
  final Color? headingTxtColor;
  final double? paddingRight;
  final double? paddingLeft;
  final Color? subHeadingTextColor;

  const CurveBox1(
      {Key? key,
      required this.boxColor,
      this.headingTxt = "",
      this.subHeading,
      this.txtSpan = "",
      this.boxHeight,
      this.headingFontSize,
      this.subhHadingFontWeight,
      this.subHeadingFontSize,
      this.headingFontWeight,
      this.boxIcon,
      this.boxSize,
      this.miniusValue,
      this.spamIcon,
      this.iconWidth = 24,
      this.iconHeight = 24,
      this.headingTxtColor = Colors.white,
      this.paddingRight = 8.0,
      this.paddingLeft = 8.0,
      this.subHeadingTextColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / boxSize! - miniusValue!,
      child: Container(
          height: boxHeight,
          margin: const EdgeInsets.only(bottom: 0),
          padding: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              left: paddingLeft ?? 8,
              right: paddingRight ?? 8),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              title: Text(headingTxt! + txtSpan!,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: headingTxtColor,
                        fontWeight: headingFontWeight,
                        fontSize: headingFontSize,
                      )),
              subtitle: (subHeading != '')
                  ? Text(
                      subHeading!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: subHeadingTextColor,
                            fontSize: subHeadingFontSize,
                            fontWeight: subhHadingFontWeight,
                          ),
                    )
                  : null,
              trailing: (boxIcon != null)
                  ? SizedBox(
                      width: iconWidth, height: iconHeight, child: boxIcon)
                  : null)),
    );
  }
}

class CurveBox2 extends StatelessWidget {
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
  final num? boxSize;
  final num? miniusValue;
  final SvgPicture? spamIcon;
  final double? iconWidth;
  final double? iconHeight;
  final Color? headingTxtColor;
  final double? paddingRight;
  final double? paddingLeft;
  final Color? subHeadingTextColor;

  const CurveBox2(
      {Key? key,
      required this.boxColor,
      this.headingTxt = "",
      this.subHeading,
      this.txtSpan = "",
      this.boxHeight,
      this.headingFontSize,
      this.subhHadingFontWeight,
      this.subHeadingFontSize,
      this.headingFontWeight,
      this.boxIcon,
      this.boxSize,
      this.miniusValue,
      this.spamIcon,
      this.iconWidth = 24,
      this.iconHeight = 24,
      this.headingTxtColor = Colors.white,
      this.paddingRight = 8.0,
      this.paddingLeft = 8.0,
      this.subHeadingTextColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / boxSize! - miniusValue!,
      child: Container(
          height: boxHeight,
          margin: const EdgeInsets.only(bottom: 0),
          padding: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              left: paddingLeft ?? 8,
              right: paddingRight ?? 8),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 18, width: 18, child: spamIcon),
                SizedBox(width: 10),
                Expanded(
                    child: Text(headingTxt! + txtSpan!,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: headingTxtColor,
                              fontWeight: headingFontWeight,
                              fontSize: headingFontSize,
                            )))
              ],
            ),
            subtitle: (subHeading != '')
                ? Text(
                    subHeading!,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: subHeadingTextColor,
                          fontSize: subHeadingFontSize,
                          fontWeight: subhHadingFontWeight,
                        ),
                  )
                : null,
          )),
    );
  }
}
