import 'package:flutter/material.dart';
import '../config/constant.dart';

class SaudaApproWidExt extends StatefulWidget {
  final String? textHeading;
  final double? textHeadingFs;
  final FontWeight? textHeadingFw;
  final Color? textHeadingFCol;
  final String? subHeading;
  final double? subHeadingFs;
  final Color? subHeadingFColor;
  final Color? bgHeading;
  final String? thridHeading;
  final double? thridHeadingFs;
  final Color? thridHeadingFCol;
  final String? thridHeadingDark;
  final double? thridHeadingDarkFs;
  final Color? thridHeadingDarkFCol;
  final FontWeight? thridHeadingDarkFW;
  final String? txtCol1Heading1;
  final double? txtCol1HeadingFs;
  final Color? txtCol1HeadingCol;
  final Color? txtCol1HeadingOraCol;
  final String? txtCol1SubHeading1;
  final double? txtCol1SubHeadingFs;
  final Color? txtCol1SubHeadingCol;
  final FontWeight? txtCol1SubHeadingFw;
  final String? txtCol2SubHeading1;
  final String? txtCol3SubHeading1;
  final String? txtCol2Heading1;
  final String? txtCol3Heading1;
  final String? iconImg;

  SaudaApproWidExt(
      {Key? key,
      this.textHeading,
      this.textHeadingFs,
      this.textHeadingFCol,
      this.textHeadingFw,
      this.bgHeading,
      this.subHeading,
      this.subHeadingFs,
      this.subHeadingFColor,
      this.thridHeading,
      this.thridHeadingFCol,
      this.thridHeadingFs,
      this.thridHeadingDark,
      this.thridHeadingDarkFCol,
      this.thridHeadingDarkFs,
      this.thridHeadingDarkFW,
      this.txtCol1Heading1,
      this.txtCol1HeadingCol,
      this.txtCol1HeadingFs,
      this.txtCol1HeadingOraCol,
      this.txtCol1SubHeading1,
      this.txtCol1SubHeadingCol,
      this.txtCol1SubHeadingFs,
      this.txtCol1SubHeadingFw,
      this.txtCol2SubHeading1,
      this.txtCol3SubHeading1,
      this.txtCol2Heading1,
      this.txtCol3Heading1,
      this.iconImg})
      : super(key: key);
  int? selectedDiscountType = 1;
  // @override
  @override
  State<SaudaApproWidExt> createState() => SaudaApproWidExtState();
}

class SaudaApproWidExtState extends State<SaudaApproWidExt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.textHeading!,
                            style: TextStyle(
                              fontSize: widget.textHeadingFs,
                              color: widget.textHeadingFCol!,
                              fontWeight: widget.textHeadingFw,
                            ),
                          ),
                          widget.iconImg == ""
                              ? Container()
                              : Row(
                                  children: [
                                    Image.asset(widget.iconImg!,
                                        width: 12.0, height: 13.0),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      widget.subHeading!,
                                      style: TextStyle(
                                          fontSize: widget.subHeadingFs,
                                          color: widget.subHeadingFColor),
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Checkbox(
                          onChanged: (bool? value) {
                            // widget.saudaList!.isApproved = value;
                            setState(() {});
                          },
                          value: true,
                        ))
                  ],
                ),
              ],
            )),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Booking No :",
                    style: TextStyle(
                        fontSize: widget.thridHeadingFs,
                        color: widget.thridHeadingFCol),
                  )),
                  Expanded(
                      child: Text("TEST",
                          style: TextStyle(
                              fontSize: widget.thridHeadingDarkFs,
                              color: widget.thridHeadingDarkFCol,
                              fontWeight: Constant.fontWeight500)))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    widget.thridHeading!,
                    style: TextStyle(
                        fontSize: widget.thridHeadingFs,
                        color: widget.thridHeadingFCol),
                  )),
                  Expanded(
                      child: Text(widget.thridHeadingDark!,
                          style: TextStyle(
                              fontSize: widget.thridHeadingDarkFs,
                              color: widget.thridHeadingDarkFCol,
                              fontWeight: Constant.fontWeight500)))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.8, color: Color(0x13000000)),
                      ),
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.txtCol1Heading1!,
                            style: TextStyle(
                              fontSize: widget.txtCol1HeadingFs,
                              color: widget.txtCol1HeadingCol,
                            ),
                          ),
                          Text(
                            widget.txtCol1SubHeading1!,
                            style: TextStyle(
                                fontSize: widget.txtCol1SubHeadingFs,
                                color: widget.txtCol1SubHeadingCol,
                                fontWeight: widget.txtCol1SubHeadingFw),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.txtCol2Heading1!,
                            style: TextStyle(
                              fontSize: widget.txtCol1HeadingFs,
                              color: widget.txtCol1HeadingCol,
                            ),
                          ),
                          Text(
                            widget.txtCol2SubHeading1!,
                            style: TextStyle(
                                fontSize: widget.txtCol1SubHeadingFs,
                                color: widget.txtCol1SubHeadingCol,
                                fontWeight: Constant.fontWeight600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.txtCol3Heading1!,
                            style: TextStyle(
                              fontSize: widget.txtCol1HeadingFs,
                              color: widget.txtCol1HeadingCol,
                            ),
                          ),
                          Text(
                            widget.txtCol3SubHeading1!,
                            style: TextStyle(
                                fontSize: widget.txtCol1SubHeadingFs,
                                color: widget.txtCol1SubHeadingCol,
                                fontWeight: Constant.fontWeight600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
