import 'package:adaniwilmar/models/sauda_extension_list.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SaudaNumber extends StatefulWidget {
  SaudaBookedSaudaWithExtensionDetails sauda;
  bool isApproved = false;
  SaudaNumber({required this.sauda, required this.isApproved, Key? key})
      : super(key: key);

  @override
  State<SaudaNumber> createState() => _SaudaNumberState();
}

class _SaudaNumberState extends State<SaudaNumber> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      primary: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Sauda Number " + widget.sauda.saudaNumber!,
        backArrow: true,
        listOfActions: Row(
          children: const [],
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Container(
              child: Constant.bgImgGlobal,
            ),
          ),
          Container(
            height: screenHeight,
            margin: EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
                child: Column(
              children: [
                CurveOuterBox(
                  boxLRPadding: 0,
                  boxTBPadding: 0,
                  boxofWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CurveOuterBox(
                          boxBgColor: const Color(0xFFFFFBF7),
                          boxShadowColor: Colors.transparent,
                          boxofWidget: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Distributor Name",
                                            fontSize: Constant.fontSize13,
                                            fontColor: Constant.colorDullGray77,
                                          ),
                                          CommonText(
                                            name: widget.sauda.dealerName ?? "",
                                            fontSize: Constant.fontSize13,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonLabel(
                                          labelRadiusBig: 2,
                                          labelRadiusSmall: 2,
                                          bgColor: widget.isApproved
                                              ? Constant.statusCompletedColor
                                              : Constant.homeBoxTodayColor2,
                                          name: widget.isApproved
                                              ? "Approved"
                                              : "Pending",
                                          fontSize: Constant.fontSize11,
                                          fontColor: widget.isApproved
                                              ? Constant.colorWhite
                                              : Constant.colorBlack,
                                          fontWeight: Constant.fontWeight500,
                                          // imageic: Constant.icon22,
                                          imagetrue: true,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Sauda From Date",
                                      fontSize: Constant.fontSize11,
                                      fontColor: Constant.colorDullGray77,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                    const SizedBox(height: 3.0),
                                    CommonText(
                                      name: DateTimeUtils()
                                          .dateToServerToDateFormat(
                                              widget.sauda.saudaValidFromDate!,
                                              DateTimeUtils.YYYY_MM_DD_Format,
                                              DateTimeUtils.DD_MM_YYYY_Format),
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Sauda Quantity",
                                      fontSize: Constant.fontSize11,
                                      fontColor: Constant.colorDullGray77,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                    const SizedBox(height: 3.0),
                                    CommonText(
                                      name: widget.sauda.saudaQuantityCase
                                              .toString() +
                                          " Case(s)",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Pending Quantity",
                                      fontSize: Constant.fontSize11,
                                      fontColor: Constant.colorDullGray77,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                    const SizedBox(height: 3.0),
                                    CommonText(
                                      name: widget.sauda.pendingQuantityCase
                                              .toString() +
                                          " Case(s)",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Base Rate",
                                      fontSize: Constant.fontSize11,
                                      fontColor: Constant.colorDullGray77,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                    const SizedBox(height: 3.0),
                                    CommonText(
                                      name: "Rs. " +
                                          widget.sauda.basicRate.toString(),
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Booked SKU",
                                      fontSize: Constant.fontSize11,
                                      fontColor: Constant.colorDullGray77,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                    const SizedBox(height: 3.0),
                                    CommonText(
                                      name: widget.sauda.bookedSku.toString(),
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            const SizedBox(height: 24.0)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
          )
        ],
      ),
      // bottomNavigationBar: CustomNavBar()
    ));
  }
}
