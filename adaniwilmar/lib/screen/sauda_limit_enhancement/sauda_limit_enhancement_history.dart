import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_history.dart';
import 'package:adaniwilmar/screen/sauda_limit_enhancement/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda_limit_enhancement/sauda_limit_enhancement_details.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaLimitEnhancementHistoryScreen extends StatelessWidget {
  const SaudaLimitEnhancementHistoryScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaLimitEnhancementHistoryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaLimitEnhancementBloc()
        ..add(LoadSaudaLimitEnhancementHistoryScreen(
          userId: Constants.AUTH_USERID,
          id: Constants.AUTH_USERID,
        )),
      child: const SaudaLimitEnhancementHistory(),
    );
  }
}

class SaudaLimitEnhancementHistory extends StatefulWidget {
  const SaudaLimitEnhancementHistory({Key? key}) : super(key: key);

  @override
  State<SaudaLimitEnhancementHistory> createState() =>
      _SaudaLimitEnhancementHistoryState();
}

class _SaudaLimitEnhancementHistoryState
    extends State<SaudaLimitEnhancementHistory> with TickerProviderStateMixin {
  List<LimitEnhancementHistory> limitRequests = [];
  List<Saudahistory> dealerLimitRequests = [];
  List<BdoList> bdoList = [];
  BdoList? selectedBdo;
  ProgressBarHandler? _handler;
  double screenWidth = 0;
  double screenHeight = 0;
  int selected = 0 - 1;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  @override
  void initState() {
    // TODO: implement initState
    if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      BlocProvider.of<SaudaLimitEnhancementBloc>(context)
          .add(LoadBDO(userId: Constants.AUTH_USERID, showAll: true));
    }
    super.initState();
  }

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
    return BlocListener<SaudaLimitEnhancementBloc, SaudaLimitEnhancementState>(
        listener: (context, state) {
          if (state is OnLoadHistorySuccess) {
            limitRequests = state.limitRequests;
            setState(() {});
          }
          if (state is OnLoadBDO) {
            selectedBdo = null;
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnLoadDealerHistorySuccess) {
            dealerLimitRequests = state.limitRequests;
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
          appBar: const CustomAppBar(title: "Request History", backArrow: true),
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
                      boxofWidget: Constants.AUTH_ROLEID == Constants.DEALER
                          ? ListView.builder(
                              key: const Key('builder1'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: dealerLimitRequests.length,
                              itemBuilder: (context, ind) {
                                return ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: CurveOuterBox(
                                      boxBorderColor: const Color(0xFFE7E7E7),
                                      boxShadowColor: const Color(0xFFFFFFFF),
                                      boxBorderWidth: 0,
                                      boxLRPadding: 0,
                                      boxTBPadding: 0,
                                      boxBRRadius: 5,
                                      boxofWidget: Column(
                                        children: [
                                          MaterialButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SaudaLimitEnhancementDetailScreen(
                                                        historyIndex: ind,
                                                        limitRequest: LimitEnhancementHistory(
                                                            dealerId: Constants
                                                                .AUTH_USERID,
                                                            dealerName: Constants
                                                                .AUTH_USER_NAME,
                                                            saudahistory:
                                                                dealerLimitRequests))),
                                              );
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    top: 9,
                                                    bottom: 9),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25.0),
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(25.0),
                                                  ),
                                                ),
                                                child: Column(
                                                  // mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      color: Colors.white,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CommonText(
                                                                name: "Limit Request No: " +
                                                                    dealerLimitRequests[
                                                                            ind]
                                                                        .limitRequestNo!
                                                                        .toString(),
                                                                fontSize: Constant
                                                                    .fontSize13,
                                                                fontColor: Constant
                                                                    .colorBlack,
                                                                fontWeight: Constant
                                                                    .fontWeight500,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    SizedBox(
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.40,
                                                                child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                          Icons
                                                                              .calendar_month,
                                                                          size:
                                                                              13,
                                                                          color:
                                                                              Colors.orange),
                                                                      const SizedBox(
                                                                          width:
                                                                              4.0),
                                                                      Text(
                                                                        dealerLimitRequests[ind].requestDate !=
                                                                                null
                                                                            ? DateTimeUtils().dateToServerToDateFormat(
                                                                                dealerLimitRequests[ind].requestDate!,
                                                                                DateTimeUtils.YYYY_MM_DD_Format,
                                                                                DateTimeUtils.DD_MM_YYYY_Format)
                                                                            : "",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize13,
                                                                            color: Constant.colorGray45,
                                                                            fontWeight: Constant.fontWeight500),
                                                                      )
                                                                    ])),
                                                            SizedBox(
                                                                // width: MediaQuery.of(
                                                                //             context)
                                                                //         .size
                                                                //         .width *
                                                                //     0.20,
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        CommonLabel(
                                                                      bgColor: dealerLimitRequests[ind].statusId == 1
                                                                          ? Constant
                                                                              .colorYellow
                                                                          : Constant
                                                                              .booSauStacolor,
                                                                      name: dealerLimitRequests[ind].status ==
                                                                              null
                                                                          ? "Pending"
                                                                          : dealerLimitRequests[ind]
                                                                              .status!,
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize11,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorWhite,
                                                                      imageic:
                                                                          Constant
                                                                              .checkIc,
                                                                      imagetrue:
                                                                          false,
                                                                    )))
                                                          ],
                                                        ))
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ));
                              })
                          : Column(children: [
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                    Constants.ZHMANAGER,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 10, bottom: 10),
                                    child: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return SizedBox(
                                          width: double.infinity,
                                          // height: 70,
                                          child:
                                              CommonDropdownButtonFormField<BdoList>(
                                            label: "State Trader",
                                            value: selectedBdo,
                                            onChanged: (BdoList? newValue) {
                                              setState(() {
                                                selectedBdo = newValue!;
                                              });
                                              BlocProvider.of<
                                                          SaudaLimitEnhancementBloc>(
                                                      context)
                                                  .add(LoadSaudaLimitEnhancementHistoryScreen(
                                                      userId:
                                                          selectedBdo!.id != 0
                                                              ? selectedBdo!.id!
                                                              : Constants
                                                                  .AUTH_USERID,
                                                      id: selectedBdo!.id != 0
                                                          ? selectedBdo!.id!
                                                          : Constants
                                                              .AUTH_USERID));
                                            },
                                            items: bdoList
                                                .map<DropdownMenuItem<BdoList>>(
                                                    (value) {
                                              return DropdownMenuItem<BdoList>(
                                                value: value,
                                                child: Text(value.name!),
                                              );
                                            }).toList(),
                                          ));
                                    })),
                              ),
                              Container(
                                  height: Constants.AUTH_ROLEID ==
                                          Constants.ZHMANAGER
                                      ? screenHeight * 0.790
                                      : screenHeight * 0.925,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: ClampingScrollPhysics(),
                                      itemCount: limitRequests.length,
                                      itemBuilder: (context, index) {
                                        return CurveOuterBox(
                                            boxLRPadding: 8,
                                            boxTBPadding: 10,
                                            boxofWidget: Theme(
                                              data: theme,
                                              child: ExpansionTile(
                                                tilePadding: EdgeInsets.zero,
                                                key: Key(index.toString()),
                                                initiallyExpanded:
                                                    index == selected,
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      // mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonText(
                                                                  name: limitRequests[
                                                                          index]
                                                                      .dealerName,
                                                                  fontSize: Constant
                                                                      .fontSize13,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorBlack,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight500,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                children: [
                                                  ListView.builder(
                                                      key: const Key(
                                                          'builder1'), //attention
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          limitRequests[index]
                                                              .saudahistory!
                                                              .length,
                                                      itemBuilder:
                                                          (context, ind) {
                                                        return ListTile(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            title:
                                                                CurveOuterBox(
                                                                    boxBorderColor:
                                                                        const Color(
                                                                            0xFFE7E7E7),
                                                                    boxShadowColor:
                                                                        const Color(
                                                                            0xFFFFFFFF),
                                                                    boxBorderWidth:
                                                                        0,
                                                                    boxLRPadding:
                                                                        0,
                                                                    boxTBPadding:
                                                                        0,
                                                                    boxBRRadius:
                                                                        5,
                                                                    boxofWidget:
                                                                        SizedBox(
                                                                      height:
                                                                          45,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => SaudaLimitEnhancementDetailScreen(historyIndex: ind, limitRequest: limitRequests[index])),
                                                                          );
                                                                        },
                                                                        child:
                                                                            ListTile(
                                                                          dense:
                                                                              true,
                                                                          title:
                                                                              Row(
                                                                            children: [
                                                                              const Icon(Icons.calendar_month, size: 13, color: Colors.orange),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Text(
                                                                                  limitRequests[index].saudahistory![ind].requestDate != null ? DateTimeUtils().dateToServerToDateFormat(limitRequests[index].saudahistory![ind].requestDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MM_YYYY_Format) : "",
                                                                                  style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorGray45, fontWeight: Constant.fontWeight500),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          trailing: Container(
                                                                              width: 75,
                                                                              height: 20,
                                                                              child: CommonLabel(
                                                                                bgColor: limitRequests[index].saudahistory![ind].statusId == 1 ? Constant.colorYellow : Constant.booSauStacolor,
                                                                                name: limitRequests[index].saudahistory![ind].status == null ? "Pending" : limitRequests[index].saudahistory![ind].status!,
                                                                                fontSize: Constant.fontSize11,
                                                                                fontColor: Constant.colorWhite,
                                                                                imageic: Constant.checkIc,
                                                                                imagetrue: false,
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    )));
                                                      }),
                                                ],
                                                onExpansionChanged:
                                                    ((newState) {
                                                  if (newState) {
                                                    setState(() {
                                                      selected = index;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      selected = -1;
                                                    });
                                                  }
                                                }),
                                              ),
                                            ));
                                      }))
                            ]))),
              progressBar
            ],
          ),
        )));
  }
}
