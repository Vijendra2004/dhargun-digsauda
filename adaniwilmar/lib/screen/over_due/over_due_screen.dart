import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/screen/over_due/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class OverDueScreen extends StatelessWidget {
  const OverDueScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const OverDueScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverDueBloc()
        ..add(LoadOverDueScreen(userId: Constants.AUTH_USERID))
        ..add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: 0, statusId: 1))
        ..add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: 0, statusId: 2)),
      child: const OverDue(),
    );
  }
}

class OverDue extends StatefulWidget {
  const OverDue({Key? key}) : super(key: key);

  @override
  State<OverDue> createState() => _OverDueScreenState();
}

class _OverDueScreenState extends State<OverDue> with TickerProviderStateMixin {
  TabController? tabController;
  Color? indicatorColor;
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  DistributorList? selectedDistributor;
  BdoList? selectedBdo;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  List<DistributorList> distributorList = [];
  DueForTomorrowList dueForTomorrowList = DueForTomorrowList();
  DueForTomorrowList dueForTomorrowListOverDue = DueForTomorrowList();
  int pendingDue = 0;
  int overDue = 0;
  List<DueDetail> pendingDues = [];
  List<DueDetail> overDues = [];
  StateTraderFilterWidget? tradeFilter;
  double screenWidth = 0;
  double screenHeight = 0;
  int selectedTab = 0;
  ProgressBarHandler? _handler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() async {
        setState(() {
          selectedTab = tabController!.index;
          // const BoxDecoration(color: Colors.amber);
          // indicatorColor = colors[tabController!.index];
        });
      });
    indicatorColor = colors[0];
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        BdoList sel = value;
        if (sel!.id != (selectedBdo == null ? 0 : selectedBdo!.id!)) {
          selectedBdo = value;
          BlocProvider.of<OverDueBloc>(context).add(LoadOverDueScreen(userId: Constants.AUTH_USERID, bdoId: selectedBdo!.id!));
        }
      },
      onLoad: (var value) {
        BdoList sel = value;
        if (sel!.id != (selectedBdo == null ? 0 : selectedBdo!.id!)) {
          selectedBdo = value;
          BlocProvider.of<OverDueBloc>(context).add(LoadOverDueScreen(userId: Constants.AUTH_USERID, bdoId: selectedBdo!.id!));
        }
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );

    return BlocListener<OverDueBloc, OverDueState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            selectedDistributor = null;
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnOverallSuccess) {
            if (state.statusId == 1) {
              dueForTomorrowList = state.response;
              if (state.response.overAndPendingDueWithDealerDetails != null) {
                pendingDues = state.response.overAndPendingDueWithDealerDetails!;
              } else {
                pendingDues = [];
              }
            } else {
              dueForTomorrowListOverDue = state.response;
              if (state.response.overAndPendingDueWithDealerDetails != null) {
                overDues = state.response.overAndPendingDueWithDealerDetails!;
              } else {
                overDues = [];
              }
            }
            setState(() {
              getPendingDues();
            });
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
          appBar: const CustomAppBar(title: "Due's", backArrow: true),
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
                    boxofWidget: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          child: TabBar (
                              controller: tabController,
                              tabAlignment: TabAlignment.start,
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              padding: EdgeInsets.zero,
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.zero,
                              indicatorWeight: 2,
                              indicator: selectedTab == 0
                                  ? const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(25.0),
                                  ))
                                  : selectedTab == 1
                                  ? const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(25.0),
                                  ))
                                  : const BoxDecoration(color: Colors.amber),
                              tabs: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2.09,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              pendingDue.toString(),
                                              style: TextStyle(fontSize: Constant.fontSize22, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Pending Due",
                                              style: TextStyle(
                                                fontSize: Constant.fontSize14,
                                                color: Constant.colorBlack,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2.08,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            overDue.toString(),
                                            style: TextStyle(fontSize: Constant.fontSize22, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Overdue",
                                            style: TextStyle(
                                              fontSize: Constant.fontSize14,
                                              color: Constant.colorBlack,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  tradeFilter != null ? tradeFilter! : const Visibility(visible: false, child: Text("State Trade")),
                                  Visibility(visible: Constants.AUTH_ROLEID != Constants.DEALER, child: const SizedBox(height: 10)),
                                  Visibility(
                                      visible: Constants.AUTH_ROLEID != Constants.DEALER,
                                      child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                        return Container(
                                            padding: const EdgeInsets.only(left: 8, right: 8),
                                            width: screenWidth,
                                            height: screenHeight * 0.1,
                                            child: CommonDropdownButtonFormField<DistributorList>(
                                              value: selectedDistributor,
                                              label: labelTxt,
                                              onChanged: (DistributorList? newValue) {
                                                setState(() {
                                                  selectedDistributor = newValue!;
                                                });
                                                BlocProvider.of<OverDueBloc>(context).add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!, statusId: 2));
                                                BlocProvider.of<OverDueBloc>(context).add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!, statusId: 1));
                                              },
                                              items: distributorList.map<DropdownMenuItem<DistributorList>>((value) {
                                                return DropdownMenuItem<DistributorList>(
                                                  value: value,
                                                  child: Text(
                                                    value.employeeName!,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                );
                                              }).toList(),
                                            ));
                                      })),
                                  totalPendingAmount(),
                                  SizedBox(
                                    height: Constants.AUTH_ROLEID == Constants.SALE ? screenHeight * 0.60 : screenHeight * 0.50,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: pendingDues.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                                            child: Column(children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                      child: CommonText(
                                                    name: pendingDues[index].dealerName,
                                                    fontSize: Constant.fontSize14,
                                                    fontColor: Constant.colorBlack,
                                                    fontWeight: Constant.fontWeight600,
                                                  )),
                                                  CommonText(
                                                    name: "Rs." + pendingDues[index].pendingDue!.toStringAsFixed(2),
                                                    fontSize: Constant.fontSize16,
                                                    fontColor: pendingDues[index].pendingDue! > 0 ? Constant.colorGreencc : Constant.colorBtn,
                                                    fontWeight: Constant.fontWeight600,
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                  visible: (Constants.AUTH_ROLEID == Constants.ZHMANAGER || Constants.AUTH_ROLEID == Constants.SALE),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Column(children: <Widget>[
                                                        CommonText(
                                                          name: "Reference No",
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorLightGray,
                                                        ),
                                                        CommonText(
                                                          name: pendingDues[index].referenceNo,
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorBlack,
                                                        )
                                                      ]),
                                                      Column(children: <Widget>[
                                                        CommonText(
                                                          name: "Due Date",
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorLightGray,
                                                        ),
                                                        CommonText(
                                                          name: pendingDues[index].dueDate,
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorBlack,
                                                        )
                                                      ])
                                                    ],
                                                  ))
                                            ])

                                            // child: ListTile(
                                            //   dense: true,
                                            //   contentPadding:
                                            //       EdgeInsets.all(0),
                                            //   title: CommonText(
                                            //     name: pendingDues[index]
                                            //         .dealerName,
                                            //     fontSize: Constant.fontSize14,
                                            //     fontColor:
                                            //         Constant.colorBlack,
                                            //     fontWeight:
                                            //         Constant.fontWeight600,
                                            //   ),
                                            //   subtitle: CommonText(
                                            //     name: pendingDues[index]
                                            //         .dealerCode,
                                            //     fontSize: Constant.fontSize12,
                                            //     fontColor:
                                            //         Constant.colorLightGray,
                                            //   ),
                                            //   trailing: CommonText(
                                            //     name: "Rs." +
                                            //         pendingDues[index]
                                            //             .pendingDue!
                                            //             .toStringAsFixed(2),
                                            //     fontSize: Constant.fontSize16,
                                            //     fontColor:
                                            //         Constant.colorBlack,
                                            //     fontWeight:
                                            //         Constant.fontWeight600,
                                            //   ),
                                            // )
                                            );
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 4),
                                  tradeFilter != null ? tradeFilter! : const Visibility(visible: false, child: Text("State Trade")),
                                  Visibility(visible: Constants.AUTH_ROLEID != Constants.DEALER, child: const SizedBox(height: 10)),
                                  Visibility(
                                      visible: Constants.AUTH_ROLEID != Constants.DEALER,
                                      child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                        return Container(
                                            padding: const EdgeInsets.only(left: 8, right: 8),
                                            width: screenWidth,
                                            height: screenHeight * 0.1,
                                            child: CommonDropdownButtonFormField<DistributorList>(
                                              value: selectedDistributor,
                                              label: labelTxt,
                                              onChanged: (DistributorList? newValue) {
                                                setState(() {
                                                  selectedDistributor = newValue!;
                                                });
                                                BlocProvider.of<OverDueBloc>(context).add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!, statusId: 1));
                                                BlocProvider.of<OverDueBloc>(context).add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!, statusId: 2));
                                              },
                                              items: distributorList.map<DropdownMenuItem<DistributorList>>((value) {
                                                return DropdownMenuItem<DistributorList>(
                                                  value: value,
                                                  child: Text(
                                                    value.employeeName!,
                                                    overflow: TextOverflow.visible,
                                                  ),
                                                );
                                              }).toList(),
                                            ));
                                      })),
                                  totalOverDueAmount(),
                                  SizedBox(
                                    height: Constants.AUTH_ROLEID == Constants.SALE ? screenHeight * 0.60 : screenHeight * 0.50,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: overDues.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                                          child: Column(children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                    child: CommonText(
                                                  name: overDues[index].dealerName,
                                                  fontSize: Constant.fontSize14,
                                                  fontColor: Constant.colorBlack,
                                                  fontWeight: Constant.fontWeight600,
                                                )),
                                                CommonText(
                                                  name: "Rs." + overDues[index].overDue!.toStringAsFixed(2),
                                                  fontSize: Constant.fontSize16,
                                                  fontColor: overDues[index].overDue! > 0 ? Constant.colorGreencc : Constant.colorBtn,
                                                  fontWeight: Constant.fontWeight600,
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                                visible: (Constants.AUTH_ROLEID == Constants.SALE || Constants.AUTH_ROLEID == Constants.ZHMANAGER),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Column(children: <Widget>[
                                                      CommonText(
                                                        name: "Reference No",
                                                        fontSize: Constant.fontSize12,
                                                        fontColor: Constant.colorLightGray,
                                                      ),
                                                      CommonText(
                                                        name: overDues[index].referenceNo,
                                                        fontSize: Constant.fontSize12,
                                                        fontColor: Constant.colorBlack,
                                                      )
                                                    ]),
                                                    Column(children: <Widget>[
                                                      CommonText(
                                                        name: "Due Date",
                                                        fontSize: Constant.fontSize12,
                                                        fontColor: Constant.colorLightGray,
                                                      ),
                                                      CommonText(
                                                        name: overDues[index].dueDate,
                                                        fontSize: Constant.fontSize12,
                                                        fontColor: Constant.colorBlack,
                                                      )
                                                    ])
                                                  ],
                                                ))
                                          ]),
                                          // child: ListTile(
                                          //   dense: true,
                                          //   contentPadding: EdgeInsets.all(0),
                                          //   title: CommonText(
                                          //     name:
                                          //         overDues[index].dealerName,
                                          //     fontSize: Constant.fontSize14,
                                          //     fontColor: Constant.colorBlack,
                                          //     fontWeight:
                                          //         Constant.fontWeight600,
                                          //   ),
                                          //   subtitle: CommonText(
                                          //     name:
                                          //         overDues[index].dealerCode,
                                          //     fontSize: Constant.fontSize12,
                                          //     fontColor:
                                          //         Constant.colorLightGray,
                                          //   ),
                                          //   trailing: CommonText(
                                          //     name: "Rs." +
                                          //         overDues[index]
                                          //             .overDue!
                                          //             .toStringAsFixed(2),
                                          //     fontSize: Constant.fontSize16,
                                          //     fontColor: Constant.colorBlack,
                                          //     fontWeight:
                                          //         Constant.fontWeight600,
                                          //   ),
                                          // ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  )),
              progressBar
            ],
          ),
          // bottomNavigationBar: CustomNavBar()
        )));
  }

  // Widget tabMenu() {
  //   return Column(
  //     children: [
  //       Container(
  //         color: Colors.transparent,
  //         margin: const EdgeInsets.all(1),
  //         width: MediaQuery.of(context).size.width,
  //         child: TabBar(
  //             indicator: tabController!.index == 0
  //                 ? const BoxDecoration(
  //                     color: Colors.amber,
  //                     borderRadius: const BorderRadius.only(
  //                       topLeft: Radius.circular(25.0),
  //                       topRight: Radius.circular(5.0),
  //                       bottomLeft: Radius.circular(5.0),
  //                       bottomRight: Radius.circular(25.0),
  //                     ))
  //                 : tabController!.index == 1
  //                     ? const BoxDecoration(
  //                         color: Colors.red,
  //                         borderRadius: const BorderRadius.only(
  //                           topLeft: Radius.circular(25.0),
  //                           topRight: Radius.circular(5.0),
  //                           bottomLeft: Radius.circular(5.0),
  //                           bottomRight: Radius.circular(25.0),
  //                         ))
  //                     : const BoxDecoration(color: Colors.amber),
  //             controller: tabController,
  //             isScrollable: false,
  //             // indicatorWeight: 20,
  //             tabs: [
  //               Tab(
  //                 child: SizedBox(
  //                   width: MediaQuery.of(context).size.width / 2.8,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         pendingDue.toString(),
  //                         style: TextStyle(
  //                             fontSize: Constant.fontSize22,
  //                             color: Constant.colorBlack,
  //                             fontWeight: Constant.fontWeight600),
  //                       ),
  //                       Text(
  //                         "Pending Due",
  //                         style: TextStyle(
  //                           fontSize: Constant.fontSize14,
  //                           color: Constant.colorBlack,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Tab(
  //                 child: SizedBox(
  //                   width: MediaQuery.of(context).size.width / 2.8,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         overDue.toString(),
  //                         style: TextStyle(
  //                             fontSize: Constant.fontSize22,
  //                             color: Constant.colorBlack,
  //                             fontWeight: Constant.fontWeight600),
  //                       ),
  //                       Text(
  //                         "Overdue",
  //                         style: TextStyle(
  //                           fontSize: Constant.fontSize14,
  //                           color: Constant.colorBlack,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ]),
  //       ),
  //       Expanded(
  //           child: Padding(
  //         padding: const EdgeInsets.only(left: 8, right: 8),
  //         child: TabBarView(
  //           controller: tabController,
  //           children: [
  //             Column(
  //               children: [
  //                 tradeFilter != null
  //                     ? tradeFilter!
  //                     : const Visibility(
  //                         visible: false, child: Text("State Trade")),
  //                 Visibility(
  //                     visible: Constants.AUTH_ROLEID != Constants.DEALER,
  //                     child: const SizedBox(height: 10)),
  //                 Visibility(
  //                     visible: Constants.AUTH_ROLEID != Constants.DEALER,
  //                     child: StatefulBuilder(builder:
  //                         (BuildContext context, StateSetter setState) {
  //                       return Container(
  //                           padding: const EdgeInsets.only(left: 8, right: 8),
  //                           width: double.infinity,
  //                           height: 70,
  //                           child: CommonDropdownButtonFormField<DistributorList>(
  //                             isExpanded: true,
  //                             value: selectedDistributor,
  //                             icon: const Align(
  //                                 alignment: Alignment.topRight,
  //                                 child: Icon(
  //                                   Icons.keyboard_arrow_down_sharp,
  //                                   size: 24,
  //                                 )),
  //                             elevation: 16,
  //                             style: const TextStyle(color: Colors.black),
  //                             decoration: InputDecoration(
  //                                 contentPadding: const EdgeInsets.symmetric(
  //                                     horizontal: 10.0, vertical: 0.0),
  //                                 focusedBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft:
  //                                             Radius.circular(borderRadiusTLBR),
  //                                         topRight:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomLeft:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomRight: Radius.circular(
  //                                             borderRadiusTLBR)),
  //                                     borderSide: BorderSide(
  //                                         color: borderColor!, width: 1.0)),
  //                                 border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft:
  //                                             Radius.circular(borderRadiusTLBR),
  //                                         topRight:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomLeft:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomRight: Radius.circular(
  //                                             borderRadiusTLBR)),
  //                                     borderSide: BorderSide(
  //                                         color: borderColor!, width: 1.0)),
  //                                 enabledBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft:
  //                                             Radius.circular(borderRadiusTLBR),
  //                                         topRight:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomLeft: Radius.circular(borderRadiusTRBL),
  //                                         bottomRight: Radius.circular(borderRadiusTLBR)),
  //                                     borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //                                 filled: true,
  //                                 // hintStyle: TextStyle(color: Colors.grey[800]),
  //                                 labelText: labelTxt,
  //                                 labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
  //                                 fillColor: fillColor),
  //                             onChanged: (DistributorList? newValue) {
  //                               setState(() {
  //                                 selectedDistributor = newValue!;
  //                               });
  //                               BlocProvider.of<OverDueBloc>(context).add(
  //                                   LoadOverallData(
  //                                       userId: Constants.AUTH_USERID,
  //                                       dealerId: selectedDistributor!.id!));
  //                             },
  //                             items: distributorList
  //                                 .map<DropdownMenuItem<DistributorList>>(
  //                                     (value) {
  //                               return DropdownMenuItem<DistributorList>(
  //                                 value: value,
  //                                 child: Text(
  //                                   value.employeeName!,
  //                                   overflow: TextOverflow.visible,
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ));
  //                     })),
  //                 totalPendingAmount(),
  //                 SizedBox(
  //                   height: screenHeight,
  //                   child: SingleChildScrollView(
  //                     child: ListView.builder(
  //                       shrinkWrap: true,
  //                       padding: const EdgeInsets.all(0),
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemCount: pendingDues.length,
  //                       itemBuilder: (context, index) {
  //                         return Container(
  //                             padding: const EdgeInsets.only(
  //                                 top: 2, bottom: 2, left: 8, right: 8),
  //                             child: ListTile(
  //                               dense: true,
  //                               contentPadding: EdgeInsets.all(0),
  //                               title: CommonText(
  //                                 name: pendingDues[index].dealerName,
  //                                 fontSize: Constant.fontSize14,
  //                                 fontColor: Constant.colorBlack,
  //                                 fontWeight: Constant.fontWeight600,
  //                               ),
  //                               subtitle: CommonText(
  //                                 name: pendingDues[index].dealerCode,
  //                                 fontSize: Constant.fontSize12,
  //                                 fontColor: Constant.colorLightGray,
  //                               ),
  //                               trailing: CommonText(
  //                                 name: "Rs." +
  //                                     pendingDues[index]
  //                                         .pendingDue!
  //                                         .toStringAsFixed(2),
  //                                 fontSize: Constant.fontSize16,
  //                                 fontColor: Constant.colorBlack,
  //                                 fontWeight: Constant.fontWeight600,
  //                               ),
  //                             ));
  //                       },
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 const SizedBox(height: 10),
  //                 tradeFilter != null
  //                     ? tradeFilter!
  //                     : const Visibility(
  //                         visible: false, child: Text("State Trade")),
  //                 Visibility(
  //                     visible: Constants.AUTH_ROLEID != Constants.DEALER,
  //                     child: const SizedBox(height: 10)),
  //                 Visibility(
  //                     visible: Constants.AUTH_ROLEID != Constants.DEALER,
  //                     child: StatefulBuilder(builder:
  //                         (BuildContext context, StateSetter setState) {
  //                       return SizedBox(
  //                           width: double.infinity,
  //                           height: 70,
  //                           child: CommonDropdownButtonFormField<DistributorList>(
  //                             isExpanded: true,
  //                             value: selectedDistributor,
  //                             icon: const Align(
  //                                 alignment: Alignment.topRight,
  //                                 child: Icon(
  //                                   Icons.keyboard_arrow_down,
  //                                   size: 16,
  //                                 )),
  //                             elevation: 16,
  //                             style: const TextStyle(color: Colors.black),
  //                             decoration: InputDecoration(
  //                                 contentPadding: const EdgeInsets.symmetric(
  //                                     horizontal: 10.0, vertical: 0.0),
  //                                 focusedBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft:
  //                                             Radius.circular(borderRadiusTLBR),
  //                                         topRight:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomLeft:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomRight: Radius.circular(
  //                                             borderRadiusTLBR)),
  //                                     borderSide: BorderSide(
  //                                         color: borderColor!, width: 1.0)),
  //                                 border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft:
  //                                             Radius.circular(borderRadiusTLBR),
  //                                         topRight:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomLeft:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomRight: Radius.circular(
  //                                             borderRadiusTLBR)),
  //                                     borderSide: BorderSide(
  //                                         color: borderColor!, width: 1.0)),
  //                                 enabledBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft:
  //                                             Radius.circular(borderRadiusTLBR),
  //                                         topRight:
  //                                             Radius.circular(borderRadiusTRBL),
  //                                         bottomLeft: Radius.circular(borderRadiusTRBL),
  //                                         bottomRight: Radius.circular(borderRadiusTLBR)),
  //                                     borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //                                 filled: true,
  //                                 // hintStyle: TextStyle(color: Colors.grey[800]),
  //                                 labelText: labelTxt,
  //                                 labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
  //                                 fillColor: fillColor),
  //                             onChanged: (DistributorList? newValue) {
  //                               setState(() {
  //                                 selectedDistributor = newValue!;
  //                               });
  //                               BlocProvider.of<OverDueBloc>(context).add(
  //                                   LoadOverallData(
  //                                       userId: Constants.AUTH_USERID,
  //                                       dealerId: selectedDistributor!.id!));
  //                             },
  //                             items: distributorList
  //                                 .map<DropdownMenuItem<DistributorList>>(
  //                                     (value) {
  //                               return DropdownMenuItem<DistributorList>(
  //                                 value: value,
  //                                 child: Text(
  //                                   value.employeeName!,
  //                                   overflow: TextOverflow.visible,
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ));
  //                     })),
  //                 totalOverDueAmount(),
  //                 Container(
  //                   height: screenHeight - 225,
  //                   color: Colors.red,
  //                   child: SingleChildScrollView(
  //                     child: ListView.builder(
  //                       shrinkWrap: true,
  //                       padding: const EdgeInsets.all(0),
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       itemCount: overDues.length,
  //                       itemBuilder: (context, index) {
  //                         return Container(
  //                           padding: const EdgeInsets.only(
  //                               top: 2, bottom: 2, left: 8, right: 8),
  //                           child: ListTile(
  //                             dense: true,
  //                             contentPadding: EdgeInsets.all(0),
  //                             title: CommonText(
  //                               name: overDues[index].dealerName,
  //                               fontSize: Constant.fontSize14,
  //                               fontColor: Constant.colorBlack,
  //                               fontWeight: Constant.fontWeight600,
  //                             ),
  //                             subtitle: CommonText(
  //                               name: overDues[index].dealerCode,
  //                               fontSize: Constant.fontSize12,
  //                               fontColor: Constant.colorLightGray,
  //                             ),
  //                             trailing: CommonText(
  //                               name: "Rs." +
  //                                   overDues[index].overDue!.toStringAsFixed(2),
  //                               fontSize: Constant.fontSize16,
  //                               fontColor: Constant.colorBlack,
  //                               fontWeight: Constant.fontWeight600,
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //       )),
  //     ],
  //   );
  // }

  Widget totalPendingAmount() {
    return Container(
      color: Constant.colorDullYellow,
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            name: "Total Amount",
            fontSize: Constant.fontSize12,
            fontColor: Constant.colorBlack,
          ),
          CommonText(
            name: "Rs. " + (dueForTomorrowList.totalBookedValuePendingDue != null ? dueForTomorrowList.totalBookedValuePendingDue.toString() : ""),
            fontSize: Constant.fontSize16,
            fontColor: Constant.colorBlack,
            fontWeight: Constant.fontWeight500,
          ),
        ],
      ),
    );
  }

  Widget totalOverDueAmount() {
    return Container(
      color: Constant.colorDullYellow,
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            name: "Total Amount",
            fontSize: Constant.fontSize12,
            fontColor: Constant.colorBlack,
          ),
          CommonText(
            name: "Rs. " + (dueForTomorrowListOverDue.totalBookedValueOverDue != null ? dueForTomorrowListOverDue.totalBookedValueOverDue.toString() : ""),
            fontSize: Constant.fontSize16,
            fontColor: Constant.colorBlack,
            fontWeight: Constant.fontWeight500,
          ),
        ],
      ),
    );
  }

  void getPendingDues() {
    pendingDue = pendingDues.length;
    overDue = overDues.length;
    // pendingDues.clear();
    // overDues.clear();
    // for (DueDetail d
    //     in dueForTomorrowList.overAndPendingDueWithDealerDetails!) {
    //   if (d.overDue != null && d.overDue! > 0) {
    //     overDue++;
    //     overDues.add(d);
    //   }
    //   if (d.pendingDue != null && d.pendingDue! > 0) {
    //     pendingDue++;
    //     pendingDues.add(d);
    //   }
    // }
  }
}
