import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/credit_limit_exposure_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/screen/credit_limit_exposure/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../../widget/widget.dart';

class CreditLimitExposureScreen extends StatelessWidget {
  const CreditLimitExposureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreditLimitExposureBloc()
        ..add(LoadCreditLimitExposureSalesScreen(
          userId: Constants.AUTH_USERID,
          bdoIds: Constants.AUTH_ROLEID == Constants.DEALER
              ? []
              : [Constants.AUTH_USERID],
          dealerIds: Constants.AUTH_ROLEID == Constants.DEALER
              ? [Constants.AUTH_USERID]
              : [],
          creditId: 0,
        ))
        ..add(LoadCreditLimitExposureList(userId: Constants.AUTH_USERID)),
      child: const CreditLimitExp(),
    );
  }
}

class CreditLimitExp extends StatefulWidget {
  const CreditLimitExp({Key? key}) : super(key: key);

  @override
  State<CreditLimitExp> createState() => _CreditLimitExposureState();
}

class _CreditLimitExposureState extends State<CreditLimitExp>
    with TickerProviderStateMixin {
  List<DistributorList> distributorList = [];
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        selectedBdo = value;

        BlocProvider.of<CreditLimitExposureBloc>(context)
            .add(LoadCreditLimitExposureSalesScreen(
          userId: Constants.AUTH_USERID,
          bdoIds: selectedBdo!.id == 0 ? [] : [selectedBdo!.id!],
          dealerIds: dealerIds,
          creditId: 0,
        ));
      },
      onLoad: (var value) {},
    );
    indicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  List<CreditLimitExposure> creditLimits = [];
  List<CreditLimitExposure> creditExposures = [];
  ProgressBarHandler? _handler;
  double screenWidth = 0;
  double screenHeight = 0;

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  List<int> dealerIds = [];
  BdoList? selectedBdo;
  StateTraderFilterWidget? tradeFilter;

  @override
  Widget build(BuildContext context) {
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
    return BlocListener<CreditLimitExposureBloc, CreditLimitExposureState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            creditLimits = state.creditLimits;
            creditExposures = state.creditExposure;
            setState(() {});
          }
          if (state is OnLoadCreditLimitExposure) {
            distributorList = state.distributorList;
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
          appBar: CustomAppBar(
            title: "Credit Limit & Exposure",
            backArrow: true,
            listOfActions: Row(
              children: [
                Visibility(visible:Constants.DEALER!=Constants.AUTH_ROLEID,child: IconButton(
                  onPressed: () {
                    _showMultiSelect(context);
                  },
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(7),
                      child: Constant.filterIc,
                    ),
                  ),
                )),
              ],
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
                  height: screenHeight * 0.98,
                  width: screenWidth,
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                      boxLRPadding: 0,
                      boxTOPPadding: 0,
                      boxBOTPadding: 0,
                      boxofWidget:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Container(
                            margin: const EdgeInsets.all(2),
                            child: Column(
                              children: [
                                Container(
                                    padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        tradeFilter != null
                                            ? tradeFilter!
                                            : const Visibility(
                                            visible: false,
                                            child: Text("State Trade")),
                                      ],
                                    )),
                                Container(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: TabBar (
                                      controller: tabController,
                                      tabAlignment: TabAlignment.start,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      isScrollable: true,
                                      padding: EdgeInsets.zero,
                                      indicatorPadding: EdgeInsets.zero,
                                      labelPadding: EdgeInsets.zero,
                                      indicatorWeight: 2,
                                      indicator: tabController == 1
                                          ? const BoxDecoration(
                                        color: Color(0xFFF68C33),
                                      )
                                          : tabController == 2
                                          ? const BoxDecoration(color: Colors.green)
                                          : const BoxDecoration(
                                        color: Color(0xFFF68C33),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      tabs: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width / 2.09,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "Credit Limit",
                                                      style: TextStyle(
                                                          color: tabController?.index == 0
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Constant.fontSize14,
                                                          fontWeight: Constant.fontWeight600),
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width / 2.08,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child:Center(
                                                    child: Text(
                                                      "Credit Exposure",
                                                      style: TextStyle(
                                                          color: tabController?.index == 1
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Constant.fontSize14,
                                                          fontWeight: Constant.fontWeight600),
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                                Expanded(
                                  //height: screenHeight-174,
                                  //width: screenWidth,
                                    child: TabBarView(
                                      controller: tabController,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: ListView.builder(
                                              key: const Key(
                                                  'builder1'), //attention
                                              padding: EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                              const ClampingScrollPhysics(),
                                              itemCount: creditLimits.length,
                                              itemBuilder: (context, index) {
                                                return Container(

                                                  margin: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xFFDEDEDE)),
                                                    borderRadius:
                                                    const BorderRadius
                                                        .only(
                                                      topLeft:
                                                      Radius.circular(
                                                          25.0),
                                                      topRight:
                                                      Radius.circular(
                                                          5.0),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          5.0),
                                                      bottomRight:
                                                      Radius.circular(
                                                          25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      MaterialButton(
                                                        padding:
                                                        EdgeInsets.zero,
                                                        onPressed: () {
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (context) => SaudaNumber()));
                                                        },
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12,
                                                                right: 12,
                                                                top: 14,
                                                                bottom:
                                                                14),
                                                            decoration:
                                                            const BoxDecoration(
                                                              color: Color(
                                                                  0xFFF5F5F5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    25.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    0.0),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  creditLimits[
                                                                  index]
                                                                      .dealerName!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      Constant
                                                                          .fontSize14,
                                                                      color: Constant
                                                                          .colorBlack,
                                                                      fontWeight:
                                                                      Constant.fontWeight600),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                    4),
                                                              ],
                                                            )),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            left: 12,
                                                            right: 12,
                                                            bottom: 12),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 3),
                                                            // Container(
                                                            //   decoration: const BoxDecoration(
                                                            //       border: Border(
                                                            //           bottom: BorderSide(
                                                            //               color:
                                                            //                   Color(0xFFBDBDBD),
                                                            //               width: 0.8))),
                                                            //   padding:
                                                            //       const EdgeInsets
                                                            //               .only(
                                                            //           bottom:
                                                            //               12),
                                                            //   child: Row(
                                                            //     children: [
                                                            //       CommonText(
                                                            //         name:
                                                            //             "Credit A/c No :",
                                                            //         fontSize:
                                                            //             Constant
                                                            //                 .fontSize13,
                                                            //         fontColor:
                                                            //             Constant
                                                            //                 .colorDullGray77,
                                                            //         fontWeight:
                                                            //             Constant
                                                            //                 .fontWeight500,
                                                            //       ),
                                                            //       Expanded(
                                                            //           child:
                                                            //               CommonText(
                                                            //         name: creditLimits[
                                                            //                 index]
                                                            //             .creditAccountNumber!,
                                                            //         fontSize:
                                                            //             Constant
                                                            //                 .fontSize12,
                                                            //         fontColor:
                                                            //             Constant
                                                            //                 .colorBlack,
                                                            //         fontWeight:
                                                            //             Constant
                                                            //                 .fontWeight600,
                                                            //       )),
                                                            //     ],
                                                            //   ),
                                                            // ),
                                                            // const SizedBox(
                                                            //     height: 16),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                  Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    child:
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CommonText(
                                                                          name:
                                                                          "Credit Limit\n(Lacs)",
                                                                          fontSize:
                                                                          Constant.fontSize13,
                                                                          fontColor:
                                                                          Constant.colorDullGray77,
                                                                          fontWeight:
                                                                          Constant.fontWeight500,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 6.0),
                                                                        CommonText(
                                                                          name:
                                                                          creditLimits[index].creditLimit!.toStringAsFixed(2),
                                                                          fontSize:
                                                                          Constant.fontSize12,
                                                                          fontColor:
                                                                          Constant.colorBlack,
                                                                          fontWeight:
                                                                          Constant.fontWeight600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                  Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    child:
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CommonText(
                                                                          name:
                                                                          "Credit Exposure\n(Lacs)",
                                                                          fontSize:
                                                                          Constant.fontSize13,
                                                                          fontColor:
                                                                          Constant.colorDullGray77,
                                                                          fontWeight:
                                                                          Constant.fontWeight500,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 6.0),
                                                                        CommonText(
                                                                          name:
                                                                          creditLimits[index].creditExposure!.toStringAsFixed(2),
                                                                          fontSize:
                                                                          Constant.fontSize12,
                                                                          fontColor:
                                                                          Constant.colorOrange,
                                                                          fontWeight:
                                                                          Constant.fontWeight600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                  Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    child:
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CommonText(
                                                                          name:
                                                                          "Available Limit\n(Lacs)",
                                                                          fontSize:
                                                                          Constant.fontSize13,
                                                                          fontColor:
                                                                          Constant.colorDullGray77,
                                                                          fontWeight:
                                                                          Constant.fontWeight500,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 6.0),
                                                                        CommonText(
                                                                          name:
                                                                          creditLimits[index].availableCreditLimit!.toStringAsFixed(2),
                                                                          fontSize:
                                                                          Constant.fontSize12,
                                                                          fontColor:
                                                                          Constant.colorBlack,
                                                                          fontWeight:
                                                                          Constant.fontWeight600,
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
                                                  ),
                                                );
                                              }),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: ListView.builder(
                                              key: const Key(
                                                  'builder2'), //attention
                                              padding:
                                              const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                              const ClampingScrollPhysics(),
                                              itemCount:
                                              creditExposures.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5, bottom: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xFFDEDEDE)),
                                                    borderRadius:
                                                    const BorderRadius
                                                        .only(
                                                      topLeft:
                                                      Radius.circular(
                                                          25.0),
                                                      topRight:
                                                      Radius.circular(
                                                          5.0),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          5.0),
                                                      bottomRight:
                                                      Radius.circular(
                                                          25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      MaterialButton(
                                                        padding:
                                                        EdgeInsets.zero,
                                                        onPressed: () {
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (context) => SaudaNumber()));
                                                        },
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12,
                                                                right: 12,
                                                                top: 14,
                                                                bottom:
                                                                14),
                                                            decoration:
                                                            const BoxDecoration(
                                                              color: Color(
                                                                  0xFFF5F5F5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    25.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    0.0),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  creditExposures[
                                                                  index]
                                                                      .dealerName!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      Constant
                                                                          .fontSize14,
                                                                      color: Constant
                                                                          .colorBlack,
                                                                      fontWeight:
                                                                      Constant.fontWeight600),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                    4),
                                                                Text(
                                                                  creditExposures[
                                                                  index]
                                                                      .dealerCode!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      Constant
                                                                          .fontSize14,
                                                                      color: Constant
                                                                          .colorBlack,
                                                                      fontWeight:
                                                                      Constant.fontWeight600),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            left: 12,
                                                            right: 12,
                                                            bottom: 12),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 3),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                  Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    child:
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CommonText(
                                                                          name:
                                                                          "Gross Exposure\n(Lacs)",
                                                                          fontSize:
                                                                          Constant.fontSize13,
                                                                          fontColor:
                                                                          Constant.colorDullGray77,
                                                                          fontWeight:
                                                                          Constant.fontWeight500,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 6.0),
                                                                        CommonText(
                                                                          name:
                                                                          creditExposures[index].grossExposure!.toStringAsFixed(2),
                                                                          fontSize:
                                                                          Constant.fontSize12,
                                                                          fontColor:
                                                                          Constant.colorBlack,
                                                                          fontWeight:
                                                                          Constant.fontWeight600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                  Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    child:
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CommonText(
                                                                          name:
                                                                          "Open Exposure\n(Lacs)",
                                                                          fontSize:
                                                                          Constant.fontSize13,
                                                                          fontColor:
                                                                          Constant.colorDullGray77,
                                                                          fontWeight:
                                                                          Constant.fontWeight500,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 6.0),
                                                                        CommonText(
                                                                          name:
                                                                          creditExposures[index].openExposure!.toStringAsFixed(2),
                                                                          fontSize:
                                                                          Constant.fontSize12,
                                                                          fontColor:
                                                                          Constant.colorOrange,
                                                                          fontWeight:
                                                                          Constant.fontWeight600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                  Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                    child:
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        CommonText(
                                                                          name:
                                                                          "Total Payable\n(Lacs)",
                                                                          fontSize:
                                                                          Constant.fontSize13,
                                                                          fontColor:
                                                                          Constant.colorDullGray77,
                                                                          fontWeight:
                                                                          Constant.fontWeight500,
                                                                        ),
                                                                        const SizedBox(
                                                                            height: 6.0),
                                                                        CommonText(
                                                                          name:
                                                                          creditExposures[index].totalReceivable!.toStringAsFixed(2),
                                                                          fontSize:
                                                                          Constant.fontSize12,
                                                                          fontColor:
                                                                          Constant.colorOrange,
                                                                          fontWeight:
                                                                          Constant.fontWeight600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ))
                        ],
                      ))),
              progressBar
            ],
          ),
        )));
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<DistributorList>(
          searchable: true,
          items: distributorList
              .map((dist) =>
                  MultiSelectItem<DistributorList>(dist, dist.employeeName!))
              .toList(),
          initialValue: const [],
          onConfirm: (List<DistributorList> values) {
            dealerIds.clear();
            for (DistributorList d in values) {
              dealerIds.add(d.id!);
            }
            BlocProvider.of<CreditLimitExposureBloc>(context)
                .add(LoadCreditLimitExposureSalesScreen(
              userId: Constants.AUTH_USERID,
              bdoIds: [Constants.AUTH_USERID],
              dealerIds: dealerIds,
              creditId: 0,
            ));
          },
        );
      },
    );
  }
}
