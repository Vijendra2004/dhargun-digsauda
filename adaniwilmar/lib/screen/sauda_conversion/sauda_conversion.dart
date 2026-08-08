import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../models/modals.dart';
import '../../widget/widget.dart';

class SaudaConversion extends StatefulWidget {
  const SaudaConversion({Key? key}) : super(key: key);

  @override
  State<SaudaConversion> createState() => _SaudaConversionState();
}

class _SaudaConversionState extends State<SaudaConversion> {
  List<Item> data = [
    Item(expandedValue: "Header", headerValue: "Body", isExpanded: false),
    Item(expandedValue: "Header 2", headerValue: "Body 2", isExpanded: false),
    Item(expandedValue: "Header 3", headerValue: "Body 3", isExpanded: false),
  ];
  int selected = 0 - 1;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      primary: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Sauda Conversion", backArrow: true),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Container(
              child: Constant.bgImgGlobal,
            ),
          ),
          SingleChildScrollView(
              child: Column(
            children: [
              Container(height: Constant.containerTopWrapper),
              CurveOuterBox(
                  boxofWidget: SaudaWidget(
                      saudaDetails: const [],
                      headFontSz: Constant.fontSize15,
                      headFontCol: Constant.colorBlack,
                      headFontWei: Constant.fontWeight600,
                      subFontSz: Constant.fontSize12,
                      subFontCol: Constant.colorLightGray,
                      otherWidget: const SaudaConversionWid(),
                      //subFontWei: 12,
                      sbIcon: Constant.sCIcon1,
                      sbIconColor: Constant.colorOrange,
                      sbIconSize: Constant.fontSize14)),
            ],
          ))
        ],
      ),
    );
  }
}
