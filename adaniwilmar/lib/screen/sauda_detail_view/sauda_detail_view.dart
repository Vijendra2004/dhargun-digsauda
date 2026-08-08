import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/screen/sauda_detail_view/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaDetailViewScreen extends StatelessWidget {
  int saudaId = 0;

  SaudaDetailViewScreen({required this.saudaId, Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SaudaDetailViewScreen(
              saudaId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaDetailViewBloc()..add(LoadSaudaDetailViewScreen(userId: Constants.AUTH_USERID, saudaId: saudaId)),
      child: SaudaDetailView(),
    );
  }
}

double screenWidth = 0;
double screenHeight = 0;

class SaudaDetailView extends StatefulWidget {
  SaudaDetailView({Key? key}) : super(key: key);

  @override
  State<SaudaDetailView> createState() => _SaudaDetailViewState();
}

class _SaudaDetailViewState extends State<SaudaDetailView> {
  SaudaDetailResponse saudaDetailResponse = SaudaDetailResponse();
  double totalPrice = 0;
  ProgressBarHandler? _handler;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<SaudaDetailViewBloc, SaudaDetailViewState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            saudaDetailResponse = state.saudaDetailResponse;
            for (SaudaOrderDetail d in saudaDetailResponse.saudaOrders!) {
              totalPrice = totalPrice + d.bidPrice!;
            }
            GMLogger.v(jsonEncode(saudaDetailResponse));
            setState(() {});
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Sauda Details",
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
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                      boxLRPadding: 0,
                      boxBOTPadding: 0,
                      boxofWidget: SizedBox(
                        height: screenHeight * 0.945,
                        width: screenWidth,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth,
                                height: screenHeight * 0.1,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFFBF7),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                ),
                                child: ListTile(
                                  dense: false,
                                  title: CommonText(
                                    name: "Distributor Name",
                                    fontSize: Constant.fontSize14,
                                    fontColor: Constant.colorDullGray77,
                                  ),
                                  subtitle: CommonText(
                                    name: saudaDetailResponse.dealerName ?? "",
                                    fontSize: Constant.fontSize14,
                                    fontColor: Constant.colorBlack,
                                    fontWeight: Constant.fontWeight600,
                                  ),
                                ),
                              ),
                              Container(
                                  height: screenHeight * 0.10,
                                  padding: const EdgeInsets.only(left: 2),
                                  child: ListTile(
                                    title: CommonText(
                                      name: "Broker Name",
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorDullGray77,
                                    ),
                                    subtitle: CommonText(
                                      name: saudaDetailResponse.brokerName ?? "",
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600,
                                    ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  height: screenHeight * 0.21,
                                  width: screenWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.4,
                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              title: CommonText(name: "Sauda No", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                              subtitle: CommonText(
                                                  name: saudaDetailResponse.saudaNumber ?? "", fontSize: Constant.fontSize14, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.45,
                                            child: ListTile(
                                              dense: true,
                                              title: CommonText(name: "Sauda Booked Date", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                              subtitle: CommonText(
                                                  name: saudaDetailResponse.saudaDate != null
                                                      ? DateTimeUtils().dateToServerToDateFormat(saudaDetailResponse.saudaDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format)
                                                      : "",
                                                  fontSize: Constant.fontSize14,
                                                  fontColor: Constant.colorBlack,
                                                  fontWeight: Constant.fontWeight600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.all(0),
                                        title: CommonText(name: "Total Quantity", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                        subtitle: CommonText(
                                            name: saudaDetailResponse.totalQuantityInMT != null ? saudaDetailResponse.totalQuantityInMT!.toString() : "",
                                            fontSize: Constant.fontSize14,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600),
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 0, left: 8, right: 8),
                                // height: screenHeight * 0.40,
                                width: screenWidth,
                                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                  color: const Color(0xFFffffff),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                                child: Column(children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: saudaDetailResponse.saudaOrders != null ? saudaDetailResponse.saudaOrders!.length : 0,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.4,
                                                child: CommonText(
                                                  name: saudaDetailResponse.saudaOrders![index].skuName,
                                                  fontColor: Constant.colorBlack,
                                                  fontSize: Constant.fontSize12,
                                                  fontWeight: Constant.fontWeight600,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.2,
                                                  child: CommonText(
                                                    name: "(" + saudaDetailResponse.saudaOrders![index].bidQuantity.toString() + " MT)",
                                                    fontColor: Constant.colorRed,
                                                    fontSize: Constant.fontSize12,
                                                    fontWeight: Constant.fontWeight600,
                                                  )),
                                              SizedBox(
                                                height: 20,
                                                width: screenWidth * 0.2,
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: CommonText(
                                                    name: saudaDetailResponse.saudaOrders![index].bidQuantityCases!.toStringAsFixed(2) + " ",
                                                    fontSize: Constant.fontSize12,
                                                    fontColor: Constant.colorOrange,
                                                    fontWeight: Constant.fontWeight600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: const EdgeInsets.all(0),
                                            title: CommonText(
                                              name: saudaDetailResponse.saudaOrders![index].plantName ?? "",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                            ),
                                            subtitle: CommonText(
                                              name: "Rs." + saudaDetailResponse.saudaOrders![index].bidPricePerCase!.toStringAsFixed(2),
                                              fontSize: Constant.fontSize11,
                                              fontColor: Constant.colorDullGray77,
                                            ),
                                            trailing: CommonText(
                                              name: "Rs." + (saudaDetailResponse.saudaOrders![index].bidPrice!).toStringAsFixed(2),
                                              fontSize: Constant.fontSize16,
                                              fontColor: Constant.colorBlack,
                                              fontWeight: Constant.fontWeight600,
                                            ),
                                          ),
                                          const DottedLine(
                                            direction: Axis.horizontal,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 2.0,
                                            dashColor: Colors.black,
                                            dashRadius: 0.0,
                                            dashGapLength: 2.0,
                                            dashGapColor: Colors.transparent,
                                            dashGapRadius: 0.0,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14, bottom: 14),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CommonText(
                                          name: "Basic Value",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(width: 24),
                                        CommonText(
                                          name: "Rs. " + totalPrice.toStringAsFixed(2),
                                          fontSize: Constant.fontSize16,
                                          fontColor: Constant.colorGreencc,
                                          fontWeight: Constant.fontWeight600,
                                        ),
                                        // Expanded(child: Container()),
                                      ],
                                    ),
                                  ),
                                  BorderBottom(bordeSize: 0.9, bottomColor: Constant.colorGray45),
                                ]),
                              ),
                              Visibility(
                                  visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "",
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, top: 8),
                                    child: CommonText(
                                      name: "Remarks",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600,
                                    ),
                                  )),
                              Visibility(visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "", child: const SizedBox(height: 8)),
                              Visibility(
                                visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "",
                                child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          name: saudaDetailResponse.remarks ?? "",
                                          fontSize: Constant.fontSize11,
                                          fontColor: Constant.colorBlack,
                                          fontWeight: Constant.fontWeight500,
                                        ),
                                      ],
                                    )),
                              ),
                              Visibility(visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "", child: const SizedBox(height: 16)),
                              Padding(
                                padding: const EdgeInsets.only(left: 0, right: 0, top: 14),
                                child: CurveOuterBox(
                                    boxLRPadding: 0,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 4),
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.zero,
                                          key: Key("dispatch".toString()),
                                          initiallyExpanded: true,
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 22,
                                                color: Constant.callToCcolor1,
                                                margin: const EdgeInsets.only(top: 3),
                                              ),
                                              const SizedBox(width: 16),
                                              CommonText(
                                                name: "Dispatch Status",
                                                fontColor: Constant.colorBlack,
                                                fontSize: Constant.fontSize16,
                                                fontWeight: Constant.fontWeight600,
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: screenWidth * 0.24,
                                                  height: screenHeight * 0.08,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFF0F7E1),
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25.0),
                                                      topRight: Radius.circular(5.0),
                                                      bottomLeft: Radius.circular(5.0),
                                                      bottomRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ListTile(
                                                        dense: true,
                                                        horizontalTitleGap: 0,
                                                        minVerticalPadding: 0,
                                                        contentPadding: const EdgeInsets.all(4),
                                                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                        leading: SizedBox(
                                                          height: 15,
                                                          width: 25,
                                                          child: Constant.completedico,
                                                        ),
                                                        title: Padding(
                                                          padding: const EdgeInsets.only(left: 0),
                                                          child: CommonText(
                                                            name:
                                                                saudaDetailResponse != null && saudaDetailResponse.liftingDetails != null && saudaDetailResponse.liftingDetails!.completedQuantity != null
                                                                    ? saudaDetailResponse.liftingDetails!.completedQuantity!.toStringAsFixed(2) + " MT"
                                                                    : "0",
                                                            fontColor: Constant.colorBlack,
                                                            fontSize: Constant.fontSize14,
                                                            fontWeight: Constant.fontWeight600,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: CommonText(
                                                          name: "Completed",
                                                          fontColor: Constant.colorBlack,
                                                          fontSize: Constant.fontSize11,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: screenWidth * 0.24,
                                                  height: screenHeight * 0.08,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFF7EEE1),
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25.0),
                                                      topRight: Radius.circular(5.0),
                                                      bottomLeft: Radius.circular(5.0),
                                                      bottomRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ListTile(
                                                        dense: true,
                                                        horizontalTitleGap: 0,
                                                        minVerticalPadding: 0,
                                                        contentPadding: const EdgeInsets.all(4),
                                                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                        leading: SizedBox(
                                                          height: 15,
                                                          width: 25,
                                                          child: Constant.inprogressico,
                                                        ),
                                                        title: Padding(
                                                          padding: const EdgeInsets.only(left: 0),
                                                          child: CommonText(
                                                            name: saudaDetailResponse != null &&
                                                                    saudaDetailResponse.liftingDetails != null &&
                                                                    saudaDetailResponse.liftingDetails!.inprogressQuantity != null
                                                                ? saudaDetailResponse.liftingDetails!.inprogressQuantity!.toStringAsFixed(2) + " MT"
                                                                : "0",
                                                            fontColor: Constant.colorBlack,
                                                            fontSize: Constant.fontSize14,
                                                            fontWeight: Constant.fontWeight600,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: CommonText(
                                                          name: "In Progress",
                                                          fontColor: Constant.colorBlack,
                                                          fontSize: Constant.fontSize11,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: screenWidth * 0.24,
                                                  height: screenHeight * 0.08,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFF9E8E9),
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(25.0),
                                                      topRight: Radius.circular(5.0),
                                                      bottomLeft: Radius.circular(5.0),
                                                      bottomRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ListTile(
                                                        dense: true,
                                                        horizontalTitleGap: 0,
                                                        minVerticalPadding: 0,
                                                        contentPadding: const EdgeInsets.all(4),
                                                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                        leading: SizedBox(
                                                          height: 15,
                                                          width: 25,
                                                          child: Constant.pendingico,
                                                        ),
                                                        title: Padding(
                                                          padding: const EdgeInsets.only(left: 0),
                                                          child: CommonText(
                                                            name: saudaDetailResponse != null && saudaDetailResponse.liftingDetails != null && saudaDetailResponse.liftingDetails!.pendingQuantity != null
                                                                ? saudaDetailResponse.liftingDetails!.pendingQuantity!.toStringAsFixed(2) + " MT"
                                                                : "0",
                                                            fontColor: Constant.colorBlack,
                                                            fontSize: Constant.fontSize14,
                                                            fontWeight: Constant.fontWeight600,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: CommonText(
                                                          name: "Pending",
                                                          fontColor: Constant.colorBlack,
                                                          fontSize: Constant.fontSize11,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                            ListView.builder(
                                                key: const Key('builder 1'),
                                                //attention
                                                padding: const EdgeInsets.all(0),
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: saudaDetailResponse != null && saudaDetailResponse.liftingDetails != null && saudaDetailResponse.liftingDetails!.liftedSkus != null
                                                    ? saudaDetailResponse.liftingDetails!.liftedSkus!.length
                                                    : 0,
                                                itemBuilder: (context, ind) {
                                                  return Column(children: [
                                                    Container(
                                                      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ListTile(
                                                            dense: true,
                                                            contentPadding: const EdgeInsets.all(0),
                                                            leading: Constant.truckico,
                                                            title: HeadingSix(
                                                              headingSix: saudaDetailResponse.liftingDetails!.liftedSkus![ind].skuName,
                                                              heaingSize: Constant.fontSize14,
                                                              headingWeight: Constant.fontWeight600,
                                                              headingColor: Constant.colorBlack,
                                                            ),
                                                            subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                              CommonText(
                                                                name: saudaDetailResponse.liftingDetails!.liftedSkus![ind].bidQuantity!.toStringAsFixed(2),
                                                                fontSize: Constant.fontSize14,
                                                                fontColor: Constant.colorBlack,
                                                              ),
                                                              CommonText(
                                                                name: DateTimeUtils().dateToServerToDateFormat(saudaDetailResponse.liftingDetails!.liftedSkus![ind].liftedDate!,
                                                                    DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format),
                                                                fontSize: Constant.fontSize14,
                                                                fontColor: Constant.colorDullGray77,
                                                              ),
                                                            ]),
                                                          ),
                                                          const DottedLine(
                                                            direction: Axis.horizontal,
                                                            lineLength: double.infinity,
                                                            lineThickness: 1.0,
                                                            dashLength: 2.0,
                                                            dashColor: Colors.black,
                                                            dashRadius: 0.0,
                                                            dashGapLength: 2.0,
                                                            dashGapColor: Colors.transparent,
                                                            dashGapRadius: 0.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // const BorderBottom(
                                                    //     bordeSize: 0.8,
                                                    //     bottomColor:
                                                    //         Color(0xFFE6EBF8)),
                                                  ]);
                                                })
                                          ],
                                          onExpansionChanged: ((newState) {
                                            // if (newState)
                                            //   setState(() {
                                            //     selected = index;
                                            //   });
                                            // else
                                            //   setState(() {
                                            //     selected = -1;
                                            //   });
                                          }),
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ))),
              progressBar
            ],
          ),
        )));
  }
}
