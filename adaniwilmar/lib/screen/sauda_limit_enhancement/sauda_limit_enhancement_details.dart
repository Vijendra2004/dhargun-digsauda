import 'package:adaniwilmar/models/limit_enhancement_history.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SaudaLimitEnhancementDetailScreen extends StatelessWidget {
  LimitEnhancementHistory limitRequest = LimitEnhancementHistory();
  int historyIndex = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  SaudaLimitEnhancementDetailScreen(
      {required this.historyIndex, required this.limitRequest, Key? key})
      : super(key: key);
  static const String routeName = '/';
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
        title: "Request Detail",
        backArrow: true,
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
              width: screenWidth,
              margin: EdgeInsets.only(top: 60, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: screenHeight * 0.840,
                      width: screenWidth,
                      child: CurveBorderBox(
                        boxLRPadding: 0,
                        boxofWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CurveOuterBox(
                                boxBgColor: const Color(0xFFFFFBF7),
                                boxShadowColor: const Color(0xFFFFFFFF),
                                boxofWidget: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name: "Distributor Name",
                                                  fontSize: Constant.fontSize13,
                                                  fontColor:
                                                      Constant.colorDullGray77,
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                CommonText(
                                                  name:
                                                      limitRequest.dealerName ??
                                                          "",
                                                  fontSize: Constant.fontSize12,
                                                  fontColor:
                                                      Constant.colorBlack,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: CommonLabel(
                                                bgColor: limitRequest
                                                            .saudahistory![
                                                                historyIndex]
                                                            .status ==
                                                        "Pending"
                                                    ? Constant.colorYellow
                                                    : Constant.booSauStacolor,
                                                name: limitRequest
                                                        .saudahistory![
                                                            historyIndex]
                                                        .status ??
                                                    "",
                                                fontSize: Constant.fontSize11,
                                                fontColor: Constant.colorWhite,
                                                imageic: Constant.checkIc,
                                                imagetrue: true,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 16),
                            Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  top: BorderSide(
                                    color: Color(0xFFD5D5D5),
                                    width: 0.8,
                                  ),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 12, right: 12, bottom: 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              name: "Request Date",
                                              fontSize: Constant.fontSize12,
                                              fontColor:
                                                  Constant.colorDullGray77),
                                          const SizedBox(height: 4),
                                          CommonText(
                                              name: limitRequest
                                                          .saudahistory![
                                                              historyIndex]
                                                          .requestDate !=
                                                      null
                                                  ? DateTimeUtils()
                                                      .dateToServerToDateFormat(
                                                          limitRequest
                                                              .saudahistory![
                                                                  historyIndex]
                                                              .requestDate!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MMM_YYYY_Format)
                                                  : "",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              name: "Limit Request No",
                                              fontSize: Constant.fontSize12,
                                              fontColor:
                                                  Constant.colorDullGray77),
                                          const SizedBox(height: 4),
                                          CommonText(
                                              name: limitRequest
                                                          .saudahistory![
                                                              historyIndex]
                                                          .limitRequestNo !=
                                                      null
                                                  ? limitRequest
                                                      .saudahistory![
                                                          historyIndex]
                                                      .limitRequestNo!
                                                  : "",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                        ],
                                      )),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 12, right: 12, bottom: 0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                          name: "Requested Qty Limit",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77),
                                      const SizedBox(height: 4),
                                      CommonText(
                                          name: limitRequest
                                              .saudahistory![historyIndex]
                                              .requestQuantityLimit!
                                              .toStringAsFixed(2),
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorBlack,
                                          fontWeight: Constant.fontWeight500),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    name: "Remarks",
                                    fontSize: Constant.fontSize12,
                                    fontColor: Constant.colorBlack,
                                    fontWeight: Constant.fontWeight600,
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                      height: 100,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xFFDEDEDE)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: limitRequest
                                                    .saudahistory![historyIndex]
                                                    .remarks ??
                                                "",
                                            fontSize: Constant.fontSize11,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ))
        ],
      ),
    ));
  }
}
