import 'package:adaniwilmar/models/deviation_response.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class DeviationDetails extends StatelessWidget {
  DeviationResponse deviationResponse = DeviationResponse();
  DeviationDetails({required this.deviationResponse, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      primary: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Deviation Detail", backArrow: true),
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
                boxLRPadding: 0,
                boxTBPadding: 0,
                boxofWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurveOuterBox(
                        boxBgColor: const Color(0xFFFFFBF7),
                        boxShadowColor: const Color(0xFFFFFFFF),
                        boxofWidget: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
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
                                          name: "Visitor",
                                          fontSize: Constant.fontSize11,
                                          fontColor: Constant.colorDullGray77,
                                          fontWeight: Constant.fontWeight500,
                                        ),
                                        CommonText(
                                          name: deviationResponse.dealer!,
                                          fontSize: Constant.fontSize10,
                                          fontColor: Constant.colorBlack,
                                          fontWeight: Constant.fontWeight600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: CommonLabel(
                                        labelRadiusBig: 2.0,
                                        bgColor: Constant.booSauStacolor,
                                        name: deviationResponse.status!,
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
                    Container(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 16),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Town",
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorDullGray77,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                          CommonText(
                                            name: deviationResponse.town!,
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Planned Date",
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorDullGray77,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                          CommonText(
                                            name: deviationResponse.actualDate!,
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Deviation Date",
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorDullGray77,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                          CommonText(
                                            name:
                                                deviationResponse.revisedDate!,
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Reason",
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorDullGray77,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                          CommonText(
                                            name: deviationResponse.reason!,
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Remarks",
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorDullGray77,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                          CommonText(
                                            name: "",
                                            fontSize: Constant.fontSize10,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }
}
