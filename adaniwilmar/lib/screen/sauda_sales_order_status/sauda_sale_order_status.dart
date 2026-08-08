import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/models/lifting_response.dart';
import 'package:adaniwilmar/screen/sauda_sales_order_status/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class SaudaSalesOrderStatusScreen extends StatelessWidget {
  const SaudaSalesOrderStatusScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const SaudaSalesOrderStatusScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaSalesOrderStatusBloc()
        ..add(LoadSaudaSalesOrderStatusScreen(
            userId: Constants.AUTH_USERID, bdoId: Constants.AUTH_ROLEID == Constants.ZHMANAGER || Constants.AUTH_ROLEID == Constants.DEALER ? 0 : Constants.AUTH_USERID, statusId: 2))
        ..add(LoadSaudaSalesOrderStatusScreen(
            userId: Constants.AUTH_USERID, bdoId: Constants.AUTH_ROLEID == Constants.ZHMANAGER || Constants.AUTH_ROLEID == Constants.DEALER ? 0 : Constants.AUTH_USERID, statusId: 1)),
      child: const SaudaSalesOrderStatus(),
    );
  }
}

class SaudaSalesOrderStatus extends StatefulWidget {
  const SaudaSalesOrderStatus({Key? key}) : super(key: key);

  @override
  State<SaudaSalesOrderStatus> createState() => _SaudaSalesOrderStatusState();
}

class _SaudaSalesOrderStatusState extends State<SaudaSalesOrderStatus> with TickerProviderStateMixin {
  List<LiftingResponse> liftingResponse = [];
  List<LiftingResponse> searchLiftingResponse = [];
  List<LiftingResponse> liftingInProgressResponse = [];
  List<LiftingResponse> searchliftingInProgressResponse = [];

  List<DealerLiftingResponse> dealerLiftingResponse = [];
  List<DealerLiftingResponse> searchDealerLiftingResponse = [];
  List<DealerLiftingResponse> dealerLiftingInProgressResponse = [];
  List<DealerLiftingResponse> searchDealerLiftingInProgressResponse = [];

  ProgressBarHandler? _handler;
  BdoList? selectedBdo;
  StateTraderFilterWidget? tradeFilter;
  TabController? tabController;

  Color? indicatorColor;
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  int confirmed = 0;
  int inProgress = 0;

  final TextEditingController _searchQueryController = TextEditingController();
  final TextEditingController _searchInProgressQueryController = TextEditingController();

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;

  @override
  void initState() {
    // TODO: implement initState

    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          const BoxDecoration(color: Colors.amber);
          indicatorColor = colors[tabController!.index];
        });
      });
    indicatorColor = colors[0];
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        selectedBdo = value;
        _searchQueryController.text = "";
        _searchInProgressQueryController.text = "";
        BlocProvider.of<SaudaSalesOrderStatusBloc>(context).add(LoadSaudaSalesOrderStatusScreen(userId: Constants.AUTH_USERID, bdoId: selectedBdo!.id!, statusId: 2));
        BlocProvider.of<SaudaSalesOrderStatusBloc>(context).add(LoadSaudaSalesOrderStatusScreen(userId: Constants.AUTH_USERID, bdoId: selectedBdo!.id!, statusId: 1));
      },
      onLoad: (var value) {
        _searchQueryController.text = "";
        _searchInProgressQueryController.text = "";
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<SaudaSalesOrderStatusBloc, SaudaSalesOrderStatusState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            if (state.statusId == 1) {
              liftingInProgressResponse = state.liftingResponse;
              searchliftingInProgressResponse = state.liftingResponse;
              inProgress = liftingInProgressResponse.length;
            } else {
              liftingResponse = state.liftingResponse;
              searchLiftingResponse = state.liftingResponse;
              confirmed = liftingResponse.length;
            }
            getCounts();
            setState(() {});
          }
          if (state is OnLoadDealerSuccess) {
            if (state.statusId == 1) {
              dealerLiftingInProgressResponse = state.liftingResponse;
              searchDealerLiftingInProgressResponse = state.liftingResponse;
              inProgress = dealerLiftingInProgressResponse.length;
            } else {
              dealerLiftingResponse = state.liftingResponse;
              searchDealerLiftingResponse = state.liftingResponse;
              confirmed = dealerLiftingResponse.length;
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
          floatingActionButton: FloatingButton(
              buttonBgColor: Constant.colorRed,
              buttonIcon: Constant.saudaIcPlus,
              navigationFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewSalesOrderScreen()),
                );
              },
              buttoniconSize: 20),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: "Sales Order Status", backArrow: true),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
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
                                indicator: tabController!.index == 0
                                    ? const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ))
                                    : tabController!.index == 1
                                        ? const BoxDecoration(
                                            color: Colors.amber,
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
                                                confirmed.toString(),
                                                style: TextStyle(fontSize: Constant.fontSize22, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Confirmed",
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.08,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              inProgress.toString(),
                                              style: TextStyle(fontSize: Constant.fontSize22, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "In-progress",
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
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    tradeFilter != null ? tradeFilter! : const Visibility(visible: false, child: Text("State Trade")),
                                    const SizedBox(height: 10),
                                    Visibility(
                                      visible: (searchLiftingResponse.isNotEmpty || searchDealerLiftingResponse.isNotEmpty),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: SizedBox(
                                          height: 55,
                                          child: TextField(
                                            controller: _searchQueryController,
                                            onChanged: (query) => updateSearchQuery(query),
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons.clear),
                                                  onPressed: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    updateSearchQuery("");
                                                    _searchQueryController.text = "";
                                                  },
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 12.0, vertical: 0.0),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight:
                                                        Radius.circular(borderRadiusTLBR)),
                                                    borderSide:
                                                    BorderSide(color: borderColor!, width: 1.5)),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight:
                                                        Radius.circular(borderRadiusTLBR)),
                                                    borderSide:
                                                    BorderSide(color: borderColor!, width: 1.0)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight:
                                                        Radius.circular(borderRadiusTLBR)),
                                                    borderSide:
                                                    BorderSide(color: borderColor!, width: 1.0)),
                                                filled: true,
                                                // hintStyle: TextStyle(color: Colors.grey[800]),
                                                labelText: (Constants.AUTH_ROLEID == Constants.DEALER) ?  "Search Lifting No" : "Search Distributor",
                                                labelStyle: TextStyle(
                                                    color: labelTxtCol, fontSize: labelTxtSize),
                                                fillColor: fillColor),

                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(visible: Constants.AUTH_ROLEID != Constants.DEALER, child: const SizedBox(height: 10)),
                                    const SizedBox(height: 10),
                                    Visibility(
                                        visible: Constants.AUTH_ROLEID != Constants.DEALER,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Distributor", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack)),
                                            Text("Indent Nos", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack))
                                          ],
                                        )),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Constants.AUTH_ROLEID == Constants.DEALER
                                          ? Column(
                                              children: [
                                                Container(
                                                  color: const Color(0xFFECECEC),
                                                  padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 80,
                                                        child: CommonText(
                                                          name: "Lifting No",
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorBlack,
                                                          fontWeight: Constant.fontWeight500,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: CommonText(
                                                          name: "Req Date",
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorBlack,
                                                          fontWeight: Constant.fontWeight500,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: CommonText(
                                                          name: "Req Qty",
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorBlack,
                                                          fontWeight: Constant.fontWeight500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: const EdgeInsets.all(0),
                                                    physics: const ClampingScrollPhysics(),
                                                    itemCount: dealerLiftingResponse.length,
                                                    itemBuilder: (context, index) {
                                                      return MaterialButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => SalesOrderDetailPageScreen(id: dealerLiftingResponse[index].liftingRequestId!)),
                                                          );
                                                        },
                                                        child: Container(
                                                          color: const Color(0xFFFAFAFA),
                                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 80,
                                                                child: CommonText(
                                                                  name: dealerLiftingResponse[index].liftingRequestNumber != null ? dealerLiftingResponse[index].liftingRequestNumber : "",
                                                                  fontSize: Constant.fontSize12,
                                                                  fontColor: Constant.colorBlack,
                                                                  fontWeight: Constant.fontWeight600,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: CommonText(
                                                                  name: DateTimeUtils().dateToServerToDateFormat(
                                                                      dealerLiftingResponse[index].liftingRequestdate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format),
                                                                  fontSize: Constant.fontSize12,
                                                                  fontColor: Constant.colorBlack,
                                                                  fontWeight: Constant.fontWeight500,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: CommonText(
                                                                  name: dealerLiftingResponse[index].requestedQuantity!.toStringAsFixed(2),
                                                                  fontSize: Constant.fontSize12,
                                                                  fontColor: Constant.colorBlack,
                                                                  fontWeight: Constant.fontWeight500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }))
                                              ],
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(0),
                                              physics: const ClampingScrollPhysics(),
                                              itemCount: liftingResponse.length,
                                              itemBuilder: (context, index) {
                                                return MaterialButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => SalesOrderDetailScreen(
                                                                dealerId: liftingResponse[index].dealerId!,
                                                                statusId: 2,
                                                              )),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(bottom: 16),
                                                        padding: const EdgeInsets.only(
                                                          right: 14,
                                                          top: 14,
                                                          bottom: 14,
                                                        ),
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
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: 3,
                                                              height: 20,
                                                              color: Constant.callToCcolor1,
                                                              margin: const EdgeInsets.only(top: 3),
                                                            ),
                                                            const SizedBox(width: 20),
                                                            Expanded(
                                                                child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                CommonText(
                                                                  name: liftingResponse[index].dealer,
                                                                  fontSize: Constant.fontSize13,
                                                                  fontColor: Constant.colorBlack,
                                                                  fontWeight: Constant.fontWeight500,
                                                                ),
                                                              ],
                                                            )),
                                                            Align(
                                                              alignment: Alignment.topRight,
                                                              child: CommonText(
                                                                name: liftingResponse[index].totalLiftingCount.toString(),
                                                                fontSize: Constant.fontSize18,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight600,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    tradeFilter != null ? tradeFilter! : const Visibility(visible: false, child: Text("State Trade")),
                                    const SizedBox(height: 10),
                                    Visibility(
                                      visible: (searchDealerLiftingInProgressResponse.isNotEmpty || searchliftingInProgressResponse.isNotEmpty),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8, left: 8),
                                        child: SizedBox(
                                          height: 55,
                                          child: TextField(
                                            controller: _searchInProgressQueryController,
                                            onChanged: (query) => updateSearchQueryInProgress(query),
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons.clear),
                                                  onPressed: () {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    updateSearchQueryInProgress("");
                                                    _searchInProgressQueryController.text = "";
                                                  },
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 12.0, vertical: 0.0),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight:
                                                        Radius.circular(borderRadiusTLBR)),
                                                    borderSide:
                                                    BorderSide(color: borderColor!, width: 1.5)),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight:
                                                        Radius.circular(borderRadiusTLBR)),
                                                    borderSide:
                                                    BorderSide(color: borderColor!, width: 1.0)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight:
                                                        Radius.circular(borderRadiusTLBR)),
                                                    borderSide:
                                                    BorderSide(color: borderColor!, width: 1.0)),
                                                filled: true,
                                                // hintStyle: TextStyle(color: Colors.grey[800]),
                                                labelText: (Constants.AUTH_ROLEID == Constants.DEALER) ?  "Search Lifting No" : "Search Distributor",
                                                labelStyle: TextStyle(
                                                    color: labelTxtCol, fontSize: labelTxtSize),
                                                fillColor: fillColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Visibility(visible: Constants.AUTH_ROLEID != Constants.DEALER, child: const SizedBox(height: 10)),
                                    Visibility(
                                        visible: Constants.AUTH_ROLEID != Constants.DEALER,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Distributor", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack)),
                                            Text("Indent Nos", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack))
                                          ],
                                        )),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Constants.AUTH_ROLEID == Constants.DEALER
                                          ?  Column(children: [
                                            Container(
                                              color: const Color(0xFFECECEC),
                                              padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: CommonText(
                                                      name: "Lifting No",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: CommonText(
                                                      name: "Req Date",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: CommonText(
                                                      name: "Req Qty",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                           Expanded(child:  ListView.builder(
                                               shrinkWrap: true,
                                               padding: const EdgeInsets.all(0),
                                               physics: const ClampingScrollPhysics(),
                                               itemCount: dealerLiftingInProgressResponse.length,
                                               itemBuilder: (context, index) {
                                                 return MaterialButton(
                                                   padding: EdgeInsets.zero,
                                                   onPressed: () {
                                                     Navigator.push(
                                                       context,
                                                       MaterialPageRoute(builder: (context) => SalesOrderDetailPageScreen(id: dealerLiftingInProgressResponse[index].liftingRequestId!)),
                                                     );
                                                   },
                                                   child: Container(
                                                     color: const Color(0xFFFAFAFA),
                                                     padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                                     child: Row(
                                                       children: [
                                                         SizedBox(
                                                           width: 80,
                                                           child: CommonText(
                                                             name: dealerLiftingInProgressResponse[index].liftingRequestNumber != null
                                                                 ? dealerLiftingInProgressResponse[index].liftingRequestNumber
                                                                 : "",
                                                             fontSize: Constant.fontSize12,
                                                             fontColor: Constant.colorBlack,
                                                             fontWeight: Constant.fontWeight600,
                                                           ),
                                                         ),
                                                         Expanded(
                                                           flex: 2,
                                                           child: CommonText(
                                                             name: DateTimeUtils().dateToServerToDateFormat(
                                                                 dealerLiftingInProgressResponse[index].liftingRequestdate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format),
                                                             fontSize: Constant.fontSize12,
                                                             fontColor: Constant.colorBlack,
                                                             fontWeight: Constant.fontWeight500,
                                                           ),
                                                         ),
                                                         Expanded(
                                                           flex: 2,
                                                           child: CommonText(
                                                             name: dealerLiftingInProgressResponse[index].requestedQuantity!.toStringAsFixed(2),
                                                             fontSize: Constant.fontSize12,
                                                             fontColor: Constant.colorBlack,
                                                             fontWeight: Constant.fontWeight500,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 );
                                               }))
                                            ],
                                            )
                                          : SizedBox(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets.all(0),
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: liftingInProgressResponse.length,
                                                  itemBuilder: (context, index) {
                                                    return MaterialButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => SalesOrderDetailScreen(
                                                                    dealerId: liftingInProgressResponse[index].dealerId!,
                                                                    statusId: 1,
                                                                  )),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin: const EdgeInsets.only(bottom: 16),
                                                            padding: const EdgeInsets.only(
                                                              right: 14,
                                                              top: 14,
                                                              bottom: 14,
                                                            ),
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
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  width: 3,
                                                                  height: 20,
                                                                  color: Constant.callToCcolor1,
                                                                  margin: const EdgeInsets.only(top: 3),
                                                                ),
                                                                const SizedBox(width: 20),
                                                                Expanded(
                                                                    child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    CommonText(
                                                                      name: liftingInProgressResponse[index].dealer,
                                                                      fontSize: Constant.fontSize13,
                                                                      fontColor: Constant.colorBlack,
                                                                      fontWeight: Constant.fontWeight500,
                                                                    ),
                                                                  ],
                                                                )),
                                                                Align(
                                                                  alignment: Alignment.topRight,
                                                                  child: CommonText(
                                                                    name: liftingInProgressResponse[index].totalLiftingCount.toString(),
                                                                    fontSize: Constant.fontSize18,
                                                                    fontColor: Constant.colorBlack,
                                                                    fontWeight: Constant.fontWeight600,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                ),
                              ],
                            ),
                          )),
                        ],
                      )),
              ),
              progressBar
            ],
          ),
        )));
  }

  void updateSearchQuery(String newQuery) {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      var searchItem = searchDealer(newQuery);
      setState(() {
        dealerLiftingResponse = searchItem;
      });
    } else {
      var searchItem = searchLifting(newQuery);
      setState(() {
        liftingResponse = searchItem;
      });
    }
  }

  List<LiftingResponse> searchLifting(String input) {
    return searchLiftingResponse.where((e) => e.dealer!.toLowerCase().contains(input.toLowerCase())).toList();
  }

  List<DealerLiftingResponse> searchDealer(String input) {
    return searchDealerLiftingResponse.where((e) => e.liftingRequestNumber!.toLowerCase().contains(input.toLowerCase())).toList();
  }

  void updateSearchQueryInProgress(String newQuery) {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      var searchItem = searchDealerIn(newQuery);
      setState(() {
        dealerLiftingInProgressResponse = searchItem;
      });
    } else {
      var searchItem = searchLiftingIn(newQuery);
      setState(() {
        liftingInProgressResponse = searchItem;
      });
    }
  }

  List<LiftingResponse> searchLiftingIn(String input) {
    return searchliftingInProgressResponse.where((e) => e.dealer!.toLowerCase().contains(input.toLowerCase())).toList();
  }

  List<DealerLiftingResponse> searchDealerIn(String input) {
    return searchDealerLiftingInProgressResponse.where((e) => e.liftingRequestNumber!.toLowerCase().contains(input.toLowerCase())).toList();
  }

  void getCounts() {
    confirmed = 0;
    inProgress = 0;
    for (LiftingResponse d in liftingResponse) {
      if (d.totalLiftingCount != null) {
        confirmed = confirmed + d.totalLiftingCount!;
      }
    }
    for (LiftingResponse d in liftingInProgressResponse) {
      if (d.totalLiftingCount != null) {
        inProgress = inProgress + d.totalLiftingCount!;
      }
    }
  }
}
