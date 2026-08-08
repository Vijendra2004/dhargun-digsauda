import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/screen/pcp/bloc/bloc.dart';
import 'package:adaniwilmar/screen/pcp/pcp_detail_view.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/bdo_list_response.dart';
import '../../widget/widget.dart';
import '../state_trader_filter/state_trader_filter.dart';

class PcpScreen extends StatelessWidget {
  const PcpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PcpBloc()..add(LoadPcpScreen(userId: Constants.AUTH_USERID, id: 2)),
      child: const Pcp(),
    );
  }
}

class Pcp extends StatefulWidget {
  const Pcp({Key? key}) : super(key: key);

  @override
  State<Pcp> createState() => _PcpScreenState();
}

class _PcpScreenState extends State<Pcp> {
  double screenWidth = 0;
  double screenHeight = 0;
  List<TotalPCPByUsersViewDto> pcpList = [];
  List<PCPManagerList> pcpManagerList = [];
  ProgressBarHandler? _handler;

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  StateTraderFilterWidget? tradeFilter;
  BdoList? selectedBdo;
  void initState() {
    // TODO: implement initState
    super.initState();

    tradeFilter = StateTraderFilterWidget(
      selectedBDO: selectedBdo,
      resultFunction: (var value) {
        selectedBdo = value;
        // refreshData();
        setState(() {});
      },
    );
  }

  void refreshData() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
    } else {}
  }

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
    return BlocListener<PcpBloc, PcpState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
              pcpManagerList = state.pcpList;
            } else {
              pcpList = state.totalPcpList;
            }
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
              title: "Total PCP",
              backArrow: true,
              listOfActions: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // showCustomFilterDialog(context, "Filter", "Filter",
                      //     dialogActionButtonFilter());
                    },
                    icon: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        padding: const EdgeInsets.all(7),
                        child: Constant.bellIconNot,
                      ),
                    ),
                  ),
                ],
              )),
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
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                      boxTOPPadding: 14,
                      boxLRPadding: 8,
                      boxofWidget: SingleChildScrollView(
                        child: Column(children: [
                          Visibility(
                              visible:
                                  (Constants.AUTH_ROLEID != Constants.SALE),
                              child: tradeFilter != null
                                  ? tradeFilter!
                                  : const Text("State Trader")),
                          Constants.AUTH_ROLEID == Constants.ZHMANAGER
                              ? ListView.builder(
                                  key: const Key('builder1'), //attention
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pcpManagerList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xFFDEDEDE)),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          MaterialButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PcpViewScreen(
                                                            pjpId:
                                                                pcpManagerList[
                                                                        index]
                                                                    .pjpId!,
                                                          )));
                                            },
                                            child: Container(
                                                width: screenWidth,
                                                padding: const EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    top: 9,
                                                    bottom: 9),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF5F5F5),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25.0),
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      pcpManagerList[index]
                                                          .pjpNumber!,
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize13,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight600),
                                                    ),
                                                    Text(
                                                      pcpManagerList[index]
                                                          .status!,
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize11,
                                                          color: Constant
                                                              .colorGray75),
                                                    )
                                                  ],
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 3),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CommonText(
                                                            name: "From Date",
                                                            fontSize: Constant
                                                                .fontSize10,
                                                            fontColor: Constant
                                                                .colorDullGray77,
                                                            fontWeight: Constant
                                                                .fontWeight500,
                                                          ),
                                                          CommonText(
                                                            name: DateTimeUtils().dateToServerToDateFormat(
                                                                pcpManagerList[
                                                                        index]
                                                                    .effectiveFrom!,
                                                                DateTimeUtils
                                                                    .YYYY_MM_DD_Format,
                                                                DateTimeUtils
                                                                    .DD_MMM_YYYY_Format),
                                                            fontSize: Constant
                                                                .fontSize10,
                                                            fontColor: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight600,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CommonText(
                                                            name: "To Date",
                                                            fontSize: Constant
                                                                .fontSize10,
                                                            fontColor: Constant
                                                                .colorDullGray77,
                                                            fontWeight: Constant
                                                                .fontWeight500,
                                                          ),
                                                          CommonText(
                                                            name: DateTimeUtils().dateToServerToDateFormat(
                                                                pcpManagerList[
                                                                        index]
                                                                    .effectiveTo!,
                                                                DateTimeUtils
                                                                    .YYYY_MM_DD_Format,
                                                                DateTimeUtils
                                                                    .DD_MMM_YYYY_Format),
                                                            fontSize: Constant
                                                                .fontSize10,
                                                            fontColor: Constant
                                                                .colorOrange,
                                                            fontWeight: Constant
                                                                .fontWeight600,
                                                          ),
                                                        ],
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
                                  })
                              : ListView.builder(
                                  key: const Key('builder1'), //attention
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pcpList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xFFDEDEDE)),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              topRight: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0),
                                              bottomRight:
                                                  Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => SaudaNumber()));
                                                },
                                                child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            right: 12,
                                                            top: 9,
                                                            bottom: 9),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF5F5F5),
                                                      borderRadius:
                                                          BorderRadius.only(
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
                                                                0.0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          pcpList[index]
                                                                  .dealers! +
                                                              "SS",
                                                          style: TextStyle(
                                                              fontSize: Constant
                                                                  .fontSize13,
                                                              color: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight600),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                                width: 12.0,
                                                                height: 12.0,
                                                                child: Constant
                                                                    .locatoinIc),
                                                            const SizedBox(
                                                                width: 4.0),
                                                            Text(
                                                              pcpList[index]
                                                                  .city!,
                                                              style: TextStyle(
                                                                  fontSize: Constant
                                                                      .fontSize11,
                                                                  color: Constant
                                                                      .colorGray75),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 12),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 3),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonText(
                                                                  name:
                                                                      "No. Of Dealers",
                                                                  fontSize: Constant
                                                                      .fontSize10,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorDullGray77,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight500,
                                                                ),
                                                                CommonText(
                                                                  name: pcpList[
                                                                          index]
                                                                      .noOfDealers!
                                                                      .toString(),
                                                                  fontSize: Constant
                                                                      .fontSize10,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorBlack,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight600,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonText(
                                                                  name:
                                                                      "No. Of Visits",
                                                                  fontSize: Constant
                                                                      .fontSize10,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorDullGray77,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight500,
                                                                ),
                                                                CommonText(
                                                                  name: pcpList[
                                                                          index]
                                                                      .noOfVisit!
                                                                      .toStringAsFixed(
                                                                          1),
                                                                  fontSize: Constant
                                                                      .fontSize10,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorOrange,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight600,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonText(
                                                                  name:
                                                                      "No. Of No Visit",
                                                                  fontSize: Constant
                                                                      .fontSize10,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorDullGray77,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight500,
                                                                ),
                                                                CommonText(
                                                                  name: pcpList[
                                                                          index]
                                                                      .hqVisitCount!
                                                                      .toStringAsFixed(
                                                                          1),
                                                                  fontSize: Constant
                                                                      .fontSize10,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorBlack,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight600,
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
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    );
                                  })
                        ]),
                      ))),
              progressBar
            ],
          ),
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CommonButton(
          //       buttonName: Constant.pricButtonName,
          //       buttonNameSize: Constant.pricbuttonNameSize,
          //       buttonNameColor: Constant.pricbuttonTxtColor,
          //       buttonColor: Constant.pricbuttonColor,
          //       buttonHeight: Constant.pricbuttonHeight,
          //       buttonRadiusTL: Constant.pricbuttonRadiusTL,
          //       buttonRadiusBL: Constant.pricbutRadiusBL,
          //       buttonBorder: Colors.transparent),
          // ),
        )));
  }
}
