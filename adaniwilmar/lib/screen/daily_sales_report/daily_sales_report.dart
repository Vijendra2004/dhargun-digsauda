import 'package:adaniwilmar/models/today_activity_list.dart';
import 'package:adaniwilmar/screen/daily_sales_report/bloc/bloc.dart';
import 'package:adaniwilmar/screen/daily_sales_report/daily_sales_report_menu.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class DailySalesReportScreen extends StatelessWidget {
  const DailySalesReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailySalesReportBloc()
        ..add(LoadDailySalesReportScreen(
          userId: Constants.AUTH_USERID,
          serverTime: ""
        )),
      child: const DailySalesReport(),
    );
  }
}

class DailySalesReport extends StatefulWidget {
  const DailySalesReport({Key? key}) : super(key: key);

  @override
  State<DailySalesReport> createState() => _DailySalesReportState();
}

class _DailySalesReportState extends State<DailySalesReport> {
  int selected = 0 - 1;
  List<TodayActivity> activityList = [];
  String serverDateTime="";
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<DailySalesReportBloc, DailySalesReportState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            activityList = state.activityList;
            serverDateTime=state.serverDate;
            setState(() {});
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: "Today Activities", backArrow: true),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 70, right: 8, left: 8),
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  child: CurveBorderBox(
                      boxLRPadding: 8,
                      boxTOPPadding: 0,
                      boxBOTPadding: 0,
                      boxofWidget: SizedBox(
                          height: screenHeight,
                          width: screenWidth,
                          child:
                          SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.09,
                    padding: const EdgeInsets.only(
                        left: 12, top: 12, right: 12, bottom: 12),
                    color: Constant.colorDullOrange,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  name: "Date",
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorDullGray77,
                                ),
                                const SizedBox(height: 6.0),
                                CommonText(
                                  name: serverDateTime,
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: screenHeight * 0.750,
                      width: screenWidth,
                      child: SingleChildScrollView(
                          child: ListView.builder(
                              key: const Key('builder 1'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: activityList.length,
                              itemBuilder: (context, index) {
                                return InkWell(onTap:(){
                                  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DailySalesReportMenuScreen(
                                                  dealerId: int.parse(activityList[index].dealerId!),
                                                  id:activityList[index].id!,
                                                  mtpId: activityList[index].mtpId!,
                                                )),
                                      );
                                },child:Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(25.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x25000000),
                                          offset: Offset(
                                            2.0,
                                            1.0,
                                          ),
                                          blurRadius: 3.0,
                                          spreadRadius: 2.0,
                                        ),
                                        //BoxShadow
                                      ],
                                    ),
                                    child:Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 12,
                                        right: 12,
                                        bottom: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        HeadingSix(
                                          headingSix:
                                          activityList[index].dealer,
                                          heaingSize: Constant.fontSize13,
                                          headingWeight:
                                          Constant.fontWeight500,
                                          headingColor:
                                          Constant.colorBlack,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    CommonText(
                                                      name: "Head Quarters",
                                                      fontSize: Constant
                                                          .fontSize12,
                                                      fontColor: Constant
                                                          .colorDullGray77,
                                                    ),
                                                    const SizedBox(
                                                        height: 6.0),
                                                    CommonText(
                                                      name: activityList[
                                                      index]
                                                          .headquarters,
                                                      fontSize: Constant
                                                          .fontSize12,
                                                      fontColor: Constant
                                                          .colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    CommonText(
                                                      name: "Town Name",
                                                      fontSize: Constant
                                                          .fontSize12,
                                                      fontColor: Constant
                                                          .colorDullGray77,
                                                    ),
                                                    const SizedBox(
                                                        height: 6.0),
                                                    CommonText(
                                                      name: activityList[index]
                                                          .town,
                                                      fontSize: Constant
                                                          .fontSize12,
                                                      fontColor: Constant
                                                          .colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    CommonText(
                                                      name: "Travel To",
                                                      fontSize: Constant
                                                          .fontSize12,
                                                      fontColor: Constant
                                                          .colorDullGray77,
                                                    ),
                                                    const SizedBox(
                                                        height: 6.0),
                                                    CommonText(
                                                      name: activityList[index].travelTo,
                                                      fontSize: Constant
                                                          .fontSize12,
                                                      fontColor: Constant
                                                          .colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const BorderBottom(
                                      bordeSize: 0.8,
                                      bottomColor: Color(0xFFE6EBF8)),
                                ])));
                              }))),
                ],
              ))))),
              progressBar
            ],
          ),
        ));
  }
}
