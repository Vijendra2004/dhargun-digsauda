import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/overall_response.dart';
import 'package:adaniwilmar/models/statistics_response.dart';
import 'package:adaniwilmar/models/ticker_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:adaniwilmar/repo/splash_repository.dart';
import 'package:adaniwilmar/screen/customer_ledger/customerLedgerNH.dart';
import 'package:adaniwilmar/screen/customer_ledger/customerLedgerStateTrader.dart';
import 'package:adaniwilmar/screen/customer_ledger/customerLedgerZH.dart';
import 'package:adaniwilmar/screen/homebloc/bloc.dart';
import 'package:adaniwilmar/screen/pending_sauda/pending_sauda.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/screen/special_rate_approval_manager/specialrate_approval_manger.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/screen/today_rate/today_rate.dart';
import 'package:adaniwilmar/screen/track_order/track_order_screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:adaniwilmar/widget/widget.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';

import '../config/constant.dart';
import '../gmcore/network/GMLogger.dart';
import '../models/list_of_menu_item_model.dart';
import '../utils/utils.dart';
import '../widget/ModalRoundedProgressBar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => HomeScreen());
  }

  HomeBloc? hmBloc = null;
  BuildContext? ctx;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(LoadHomeScreen(userId: Constants.AUTH_USERID, roleId: Constants.AUTH_ROLEID));
    BlocProvider.of<HomeBloc>(context).add(LoadUserStatistics(userId: Constants.AUTH_USERID, roleId: Constants.AUTH_ROLEID, selectedMethod: "MTD"));
    return const Home();
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => HomeScreen());
  }

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> with TickerProviderStateMixin {
  List<charts.Series<OverallWeekWiseAchievements, String>> seriesList = [];
  List<charts.Series<OverallChartData, String>> overallSeriesList = [];
  List<charts.Series<OverallWeekWiseAchievements, String>> salesSeriesList = [];
  List<charts.Series<OverallChartData, String>> overallSalesSeriesList = [];
  String overAll = "";
  String target = "";
  String overAllPerc = "";

  String overSalesAll = "";
  String salesTarget = "";
  String salesOverAllPerc = "";

  String selectedMethod = "MTD";
  StatisticsResponse? statistics = StatisticsResponse();
  DistributorList? selectedDistributor;
  BdoList? selectedBdo;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  List<DistributorList> distributorList = [];
  List<TickerList> tickerList = [];
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  ProgressBarHandler? _handler;
  StateTraderFilterWidget? tradeFilter;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  String tickerText = "";
  TextEditingController? _distributorcontroller;

  static String _displayStringForOption(DistributorList option) => option.employeeName!;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);
    SplashRepository().userAnalyticsEventLog();
    indicatorColor = colors[0];

    tradeFilter = StateTraderFilterWidget(
      selectedBDO: selectedBdo,
      resultFunction: (var value) {
        selectedBdo = value;
        refreshData();
        setState(() {});
      },
    );
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void refreshData() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      if (selectedMethod == "MTD") {
        BlocProvider.of<HomeBloc>(context).add(LoadHomeScreen(
            userId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : Constants.AUTH_USERID,
            roleId: selectedBdo != null && selectedBdo!.id != 0 ? Constants.SALE : Constants.AUTH_ROLEID));
      } else {
        BlocProvider.of<HomeBloc>(context).add(LoadOverallData(
            userId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : Constants.AUTH_USERID,
            selectedMethod: selectedMethod,
            roleId: selectedBdo != null && selectedBdo!.id != 0 ? Constants.SALE : Constants.AUTH_ROLEID));
      }
      BlocProvider.of<HomeBloc>(context).add(LoadUserStatistics(
          userId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : Constants.AUTH_USERID,
          selectedMethod: selectedMethod,
          roleId: selectedBdo != null && selectedBdo!.id != 0 ? Constants.SALE : Constants.AUTH_ROLEID));
    } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      if (selectedMethod == "MTD") {
        BlocProvider.of<HomeBloc>(context).add(LoadHomeScreen(
            userId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : Constants.AUTH_USERID,
            zhId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : 0,
            roleId: selectedBdo != null && selectedBdo!.id != 0 ? Constants.ZHMANAGER : Constants.AUTH_ROLEID));
      } else {
        BlocProvider.of<HomeBloc>(context).add(LoadOverallData(
            userId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : Constants.AUTH_USERID,
            selectedMethod: selectedMethod,
            zhId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : 0,
            roleId: selectedBdo != null && selectedBdo!.id != 0 ? Constants.ZHMANAGER : Constants.AUTH_ROLEID));
      }
      BlocProvider.of<HomeBloc>(context).add(LoadUserStatistics(
          userId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : Constants.AUTH_USERID,
          selectedMethod: selectedMethod,
          zhId: selectedBdo != null && selectedBdo!.id != 0 ? selectedBdo!.id! : 0,
          roleId: selectedBdo != null && selectedBdo!.id != 0 ? Constants.ZHMANAGER : Constants.AUTH_ROLEID));
    } else {
      if (selectedMethod == "MTD") {
        BlocProvider.of<HomeBloc>(context).add(LoadHomeScreen(
            userId: (selectedDistributor == null || selectedDistributor!.id == 0) ? Constants.AUTH_USERID : selectedDistributor!.id!,
            roleId: selectedDistributor != null && selectedDistributor!.id != 0 ? Constants.DEALER : Constants.AUTH_ROLEID));
      } else {
        BlocProvider.of<HomeBloc>(context).add(LoadOverallData(
            userId: (selectedDistributor == null || selectedDistributor!.id == 0) ? Constants.AUTH_USERID : selectedDistributor!.id!,
            selectedMethod: selectedMethod,
            roleId: selectedDistributor != null && selectedDistributor!.id != 0 ? Constants.DEALER : Constants.AUTH_ROLEID));
      }
      BlocProvider.of<HomeBloc>(context).add(LoadUserStatistics(
          userId: (selectedDistributor == null || selectedDistributor!.id == 0) ? Constants.AUTH_USERID : selectedDistributor!.id!,
          selectedMethod: selectedMethod,
          roleId: selectedDistributor != null && selectedDistributor!.id != 0 ? Constants.DEALER : Constants.AUTH_ROLEID));
    }
  }

  Widget marqueeWidget() {
    if (tickerList != null && tickerList.length > 0) {
      return Container(
          padding: EdgeInsets.only(top: 5),
          height: 30,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Marquee(
            key: Key("marquee"),
            text: tickerText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: Constant.fontSize20, color: Utils().hexToColor(tickerList.first.colorCode ?? "#267d3c")),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: MediaQuery.of(context).size.width * 0.98,
          ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    Widget homeGraphs = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        marqueeWidget(),
        Visibility(
            visible: (Constants.AUTH_ROLEID == Constants.SALE),
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 70,
                  child:
                      // CommonDropdownButtonFormField<DistributorList>(
                      //   isExpanded: true,
                      //   value: selectedDistributor,
                      //   icon: const Align(
                      //       alignment: Alignment.topRight,
                      //       child: Icon(
                      //         Icons.arrow_drop_down,
                      //         size: 24,
                      //       )),
                      //   elevation: 16,
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: Constant.fontWeight600),
                      //   decoration: InputDecoration(
                      //       contentPadding: const EdgeInsets.symmetric(
                      //           horizontal: 12.0, vertical: 0.0),
                      //       focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(borderRadiusTLBR),
                      //               topRight: Radius.circular(borderRadiusTRBL),
                      //               bottomLeft: Radius.circular(borderRadiusTRBL),
                      //               bottomRight: Radius.circular(borderRadiusTLBR)),
                      //           borderSide:
                      //               BorderSide(color: borderColor!, width: 1.5)),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(borderRadiusTLBR),
                      //               topRight: Radius.circular(borderRadiusTRBL),
                      //               bottomLeft: Radius.circular(borderRadiusTRBL),
                      //               bottomRight: Radius.circular(borderRadiusTLBR)),
                      //           borderSide:
                      //               BorderSide(color: borderColor!, width: 1.0)),
                      //       enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(borderRadiusTLBR),
                      //               topRight: Radius.circular(borderRadiusTRBL),
                      //               bottomLeft: Radius.circular(borderRadiusTRBL),
                      //               bottomRight: Radius.circular(borderRadiusTLBR)),
                      //           borderSide:
                      //               BorderSide(color: borderColor!, width: 1.0)),
                      //       filled: true,
                      //       // hintStyle: TextStyle(color: Colors.grey[800]),
                      //       labelText: labelTxt,
                      //       labelStyle: TextStyle(
                      //           color: labelTxtCol, fontSize: labelTxtSize),
                      //       fillColor: fillColor),
                      //   onChanged: (DistributorList? newValue) {
                      //     setState(() {
                      //       selectedDistributor = newValue!;
                      //     });
                      //     refreshData();
                      //   },
                      //   items: distributorList
                      //       .map<DropdownMenuItem<DistributorList>>((value) {
                      //     return DropdownMenuItem<DistributorList>(
                      //       value: value,
                      //       child: Text(value.employeeName!,
                      //           overflow: TextOverflow.visible),
                      //     );
                      //   }).toList(),
                      // )
                      CustomAutocomplete<DistributorList>(
                    fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                      _distributorcontroller = fieldTextEditingController;
                      return TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(borderRadiusTLBR),
                                    topRight: Radius.circular(borderRadiusTRBL),
                                    bottomLeft: Radius.circular(borderRadiusTRBL),
                                    bottomRight: Radius.circular(borderRadiusTLBR)),
                                borderSide: BorderSide(color: borderColor!, width: 1.0)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(borderRadiusTLBR),
                                    topRight: Radius.circular(borderRadiusTRBL),
                                    bottomLeft: Radius.circular(borderRadiusTRBL),
                                    bottomRight: Radius.circular(borderRadiusTLBR)),
                                borderSide: BorderSide(color: borderColor!, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(borderRadiusTLBR),
                                    topRight: Radius.circular(borderRadiusTRBL),
                                    bottomLeft: Radius.circular(borderRadiusTRBL),
                                    bottomRight: Radius.circular(borderRadiusTLBR)),
                                borderSide: BorderSide(color: borderColor!, width: 1.0)),
                            filled: true,

                            // hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Distributor Name",
                            labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                            fillColor: fillColor),
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        // style: const TextStyle(fontWeight: FontWeight.normal),
                      );
                    },
                    displayStringForOption: _displayStringForOption,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<DistributorList>.empty();
                      }
                      return distributorList.where((DistributorList option) {
                        return option.employeeName.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (DistributorList selection) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        selectedDistributor = selection;
                      });
                      refreshData();
                    },
                  ));
            })),
        Visibility(visible: (Constants.AUTH_ROLEID != Constants.SALE && Constants.AUTH_ROLEID != Constants.DEALER), child: tradeFilter != null ? tradeFilter! : const Text("State Trader")),
        Container(
          height: screenHeight * 0.49,
          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0))),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(1.0),
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0))),
                child: TabBar(
                    controller: tabController,
                    physics: NeverScrollableScrollPhysics(),
                    indicatorColor: Colors.grey,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
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
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorWeight: 2,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.09,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sauda",
                              style: TextStyle(color: tabController?.index == 0 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.08,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sales",
                              style: TextStyle(color: tabController?.index == 1 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE5E5E5FF)))),
                    child: TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Padding(padding: const EdgeInsets.only(right: 4), child: Text("Overall", style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack))),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.19,
                                            child: Text(overAll + " MT", style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.homeBoxPendingOrange))),
                                        Visibility(
                                            visible: false,
                                            child: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.16,
                                                child: Text("(" + overAllPerc + ")", style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorDullGray77)))),
                                      ]),
                                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Padding(padding: const EdgeInsets.only(top: 2, right: 4), child: Text("Target", style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack))),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 2, right: 2),
                                            child: Text(target + " MT", style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.homeBoxPendingOrange))),
                                      ])
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Constant.homeBoxPendingOrange!, width: 1),
                                              color: selectedMethod == "MTD" ? Constant.homeBoxPendingOrange : Colors.white,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(0.0),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight: Radius.circular(0),
                                              ),
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                child: InkWell(
                                                    onTap: () {
                                                      selectedMethod = "MTD";
                                                      refreshData();
                                                      // print("Screen Height" +
                                                      //     screenHeight
                                                      //         .toString() +
                                                      //     "\Top Padding Height" +
                                                      //     (MediaQuery.of(
                                                      //                 context)
                                                      //             .padding
                                                      //             .top)
                                                      //         .toString());
                                                      setState(() {});
                                                    },
                                                    child: Text("MTD",
                                                        style: TextStyle(
                                                            fontSize: Constant.fontSize10,
                                                            fontWeight: Constant.fontWeight500,
                                                            color: selectedMethod == "MTD" ? Colors.white : Constant.homeBoxPendingOrange))))),
                                        Container(
                                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Constant.homeBoxPendingOrange!, width: 1),
                                              color: selectedMethod == "QTD" ? Constant.homeBoxPendingOrange : Colors.white,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(0.0),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight: Radius.circular(0),
                                              ),
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                child: InkWell(
                                                    onTap: () {
                                                      selectedMethod = "QTD";
                                                      refreshData();
                                                      setState(() {});
                                                    },
                                                    child: Text("QTD",
                                                        style: TextStyle(
                                                            fontSize: Constant.fontSize10,
                                                            fontWeight: Constant.fontWeight500,
                                                            color: selectedMethod == "QTD" ? Colors.white : Constant.homeBoxPendingOrange))))),
                                        Container(
                                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Constant.homeBoxPendingOrange!, width: 1),
                                              color: selectedMethod == "YTD" ? Constant.homeBoxPendingOrange : Colors.white,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(0.0),
                                                bottomLeft: Radius.circular(0.0),
                                                bottomRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                child: InkWell(
                                                    onTap: () {
                                                      selectedMethod = "YTD";
                                                      refreshData();
                                                      setState(() {});
                                                    },
                                                    child: Text("YTD",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: Constant.fontSize10, fontWeight: Constant.fontWeight500, color: selectedMethod == "YTD" ? Colors.white : Colors.orange)))))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  height: screenHeight * 0.30,
                                  margin: const EdgeInsets.only(top: 4),
                                  width: double.infinity,
                                  child: seriesList.isNotEmpty
                                      ? charts.BarChart(
                                          seriesList,
                                          animate: false,
                                          barRendererDecorator: charts.BarLabelDecorator(
                                              labelPosition: charts.BarLabelPosition.outside,
                                              insideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9),
                                              outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9)),
                                          // defaultRenderer:
                                          //     charts.BarRendererConfig(
                                          //   maxBarWidthPx: 20,
                                          // ),
                                          behaviors: [
                                            charts.SlidingViewport(),
                                            charts.PanAndZoomBehavior(),
                                            charts.SeriesLegend(
                                              position: charts.BehaviorPosition.bottom,
                                              outsideJustification: charts.OutsideJustification.start,
                                              horizontalFirst: false,
                                              desiredMaxRows: 1,
                                              cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0, top: 10.0),
                                              entryTextStyle: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 14),
                                            )
                                          ],
                                          domainAxis: charts.OrdinalAxisSpec(
                                              viewport: charts.OrdinalViewport("Week 1", 2),
                                              renderSpec: charts.SmallTickRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle: charts.TextStyleSpec(
                                                      fontSize: 12, // size in Pts.
                                                      color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                  // Change the line colors to match text color.
                                                  lineStyle: charts.LineStyleSpec(thickness: 1, color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),

                                          /// Assign a custom style for the measure axis.
                                          primaryMeasureAxis: charts.NumericAxisSpec(
                                              tickFormatterSpec: charts.BasicNumericTickFormatterSpec((measure) {
                                                return Utils().convertToK(measure!.toDouble());
                                              }),
                                              renderSpec: charts.GridlineRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle: charts.TextStyleSpec(
                                                      fontSize: 12,
                                                      // size in Pts.
                                                      color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                  // Change the line colors to match text color.
                                                  lineStyle: charts.LineStyleSpec(thickness: 1, color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),
                                          barGroupingType: charts.BarGroupingType.grouped,
                                        )
                                      : overallSeriesList.isNotEmpty
                                          ? charts.BarChart(
                                              overallSeriesList,
                                              animate: false,
                                              barRendererDecorator: charts.BarLabelDecorator(
                                                  labelPosition: charts.BarLabelPosition.outside,
                                                  insideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.white), fontFamily: 'Aganè', fontSize: 9),
                                                  outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9)),
                                              // defaultRenderer:
                                              //     charts.BarRendererConfig(
                                              //   maxBarWidthPx: 10,
                                              // ),
                                              behaviors: [
                                                charts.SlidingViewport(),
                                                charts.PanAndZoomBehavior(),
                                                charts.SeriesLegend(
                                                  position: charts.BehaviorPosition.bottom,
                                                  outsideJustification: charts.OutsideJustification.start,
                                                  horizontalFirst: false,
                                                  desiredMaxRows: 1,
                                                  cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0, top: 10.0),
                                                  entryTextStyle: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 14),
                                                )
                                              ],
                                              domainAxis: charts.OrdinalAxisSpec(
                                                  viewport: charts.OrdinalViewport("Quarter-1", 2),
                                                  renderSpec: charts.SmallTickRendererSpec(

                                                      // Tick and Label styling here.
                                                      labelStyle: charts.TextStyleSpec(
                                                          fontSize: 12, // size in Pts.
                                                          color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                      // Change the line colors to match text color.
                                                      lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),

                                              /// Assign a custom style for the measure axis.
                                              primaryMeasureAxis: charts.NumericAxisSpec(
                                                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec((measure) {
                                                    return Utils().convertToK(measure!.toDouble());
                                                  }),
                                                  renderSpec: charts.GridlineRendererSpec(

                                                      // Tick and Label styling here.
                                                      labelStyle: charts.TextStyleSpec(
                                                          fontSize: 12, // size in Pts.
                                                          color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                      // Change the line colors to match text color.
                                                      lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),
                                              barGroupingType: charts.BarGroupingType.grouped,
                                            )
                                          : const Text("No Data Available")),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Text("Overall", style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.colorBlack))),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child:
                                                Text(overSalesAll + " MT", style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.homeBoxPendingOrange))),
                                        Visibility(
                                            visible: false,
                                            child: Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Text("(" + salesOverAllPerc + ")",
                                                    style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.colorDullGray77))))
                                      ]),
                                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Text("Target", style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.colorBlack))),
                                        Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child:
                                                Text(salesTarget + " MT", style: TextStyle(fontSize: Constant.fontSize12, fontWeight: Constant.fontWeight500, color: Constant.homeBoxPendingOrange))),
                                      ])
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Constant.homeBoxPendingOrange!, width: 1),
                                            color: selectedMethod == "MTD" ? Constant.homeBoxPendingOrange : Colors.white,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(0),
                                            ),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: InkWell(
                                                  onTap: () {
                                                    selectedMethod = "MTD";
                                                    refreshData();
                                                    setState(() {});
                                                  },
                                                  child: Text("MTD",
                                                      style: TextStyle(
                                                          fontSize: Constant.fontSize10,
                                                          fontWeight: Constant.fontWeight500,
                                                          color: selectedMethod == "MTD" ? Colors.white : Constant.homeBoxPendingOrange))))),
                                      Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Constant.homeBoxPendingOrange!, width: 1),
                                            color: selectedMethod == "QTD" ? Constant.homeBoxPendingOrange : Colors.white,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(0),
                                            ),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: InkWell(
                                                  onTap: () {
                                                    selectedMethod = "QTD";
                                                    refreshData();
                                                    setState(() {});
                                                  },
                                                  child: Text("QTD",
                                                      style: TextStyle(
                                                          fontSize: Constant.fontSize10,
                                                          fontWeight: Constant.fontWeight500,
                                                          color: selectedMethod == "QTD" ? Colors.white : Constant.homeBoxPendingOrange))))),
                                      Container(
                                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Constant.homeBoxPendingOrange!, width: 1),
                                            color: selectedMethod == "YTD" ? Constant.homeBoxPendingOrange : Colors.white,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: InkWell(
                                                  onTap: () {
                                                    selectedMethod = "YTD";
                                                    refreshData();
                                                    setState(() {});
                                                  },
                                                  child: Text("YTD",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: Constant.fontSize10, fontWeight: Constant.fontWeight500, color: selectedMethod == "YTD" ? Colors.white : Colors.orange)))))
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  height: screenHeight * 0.30,
                                  margin: const EdgeInsets.only(top: 4),
                                  width: double.infinity,
                                  child: salesSeriesList.isNotEmpty
                                      ? charts.BarChart(
                                          salesSeriesList,
                                          animate: false,
                                          barRendererDecorator: charts.BarLabelDecorator(
                                              labelPosition: charts.BarLabelPosition.outside,
                                              insideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9),
                                              outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9)),
                                          // defaultRenderer:
                                          //     charts.BarRendererConfig(
                                          //   maxBarWidthPx: 10,
                                          // ),
                                          behaviors: [
                                            charts.SlidingViewport(),
                                            charts.PanAndZoomBehavior(),
                                            charts.SeriesLegend(
                                              position: charts.BehaviorPosition.bottom,
                                              outsideJustification: charts.OutsideJustification.start,
                                              horizontalFirst: false,
                                              desiredMaxRows: 1,
                                              cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0, top: 10.0),
                                              entryTextStyle: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 14),
                                            )
                                          ],
                                          domainAxis: charts.OrdinalAxisSpec(
                                              viewport: charts.OrdinalViewport("Week 1", 2),
                                              renderSpec: charts.SmallTickRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle: charts.TextStyleSpec(
                                                      fontSize: 13, // size in Pts.
                                                      color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                  // Change the line colors to match text color.
                                                  lineStyle: charts.LineStyleSpec(thickness: 1, color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),

                                          /// Assign a custom style for the measure axis.
                                          primaryMeasureAxis: charts.NumericAxisSpec(
                                              tickFormatterSpec: charts.BasicNumericTickFormatterSpec((measure) {
                                                return Utils().convertToK(measure!.toDouble());
                                              }),
                                              renderSpec: charts.GridlineRendererSpec(

                                                  // Tick and Label styling here.
                                                  labelStyle: charts.TextStyleSpec(
                                                      fontSize: 13,
                                                      // size in Pts.
                                                      color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                  // Change the line colors to match text color.
                                                  lineStyle: charts.LineStyleSpec(thickness: 1, color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),
                                          barGroupingType: charts.BarGroupingType.grouped,
                                        )
                                      : overallSalesSeriesList.isNotEmpty
                                          ? charts.BarChart(
                                              overallSalesSeriesList,
                                              animate: false,
                                              barRendererDecorator: charts.BarLabelDecorator(
                                                  labelPosition: charts.BarLabelPosition.outside,
                                                  insideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9),
                                                  outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9)),
                                              // defaultRenderer:
                                              //     charts.BarRendererConfig(
                                              //   maxBarWidthPx: 10,
                                              // ),
                                              behaviors: [
                                                charts.SlidingViewport(),
                                                charts.PanAndZoomBehavior(),
                                                charts.SeriesLegend(
                                                  position: charts.BehaviorPosition.bottom,
                                                  outsideJustification: charts.OutsideJustification.start,
                                                  horizontalFirst: false,
                                                  desiredMaxRows: 1,
                                                  cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0, top: 10.0),
                                                  entryTextStyle: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 14),
                                                )
                                              ],
                                              domainAxis: charts.OrdinalAxisSpec(
                                                  viewport: charts.OrdinalViewport("", 2),
                                                  renderSpec: charts.SmallTickRendererSpec(

                                                      // Tick and Label styling here.
                                                      labelStyle: charts.TextStyleSpec(
                                                          fontSize: 13, // size in Pts.
                                                          color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                      // Change the line colors to match text color.
                                                      lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),

                                              /// Assign a custom style for the measure axis.
                                              primaryMeasureAxis: charts.NumericAxisSpec(
                                                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec((measure) {
                                                    return Utils().convertToK(measure!.toDouble());
                                                  }),
                                                  renderSpec: charts.GridlineRendererSpec(

                                                      // Tick and Label styling here.
                                                      labelStyle: charts.TextStyleSpec(
                                                          fontSize: 13, // size in Pts.
                                                          color: charts.ColorUtil.fromDartColor(Colors.black)),

                                                      // Change the line colors to match text color.
                                                      lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(Constant.chartLineColor!)))),
                                              barGroupingType: charts.BarGroupingType.grouped,
                                            )
                                          : const Text("No Data Available")),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
    // Widget customTabBar = Container(
    //   child: ,
    // );
    Widget boxOfNav = Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSix(
              headingSix: "Expired & Near Expired "
              // +
              // (statistics?.pendingSaudaQuantity == null
              // ? ""
              // : statistics?.pendingSaudaQuantity!
              // .toString())!+" MT"
              ,
              heaingSize: Constant.headingSix,
              headingWeight: Constant.fontWeight600,
              headingColor: Constant.colorBlack,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             PendingSaudaScreen()));
                    },
                    child: CurveBox1(
                      boxSize: 2,
                      miniusValue: 29,
                      boxHeight: 72,
                      boxColor: Constant.homeBoxPendingRed,
                      headingTxt: statistics?.aboveOutstandingSaudaQuantity == null ? "-" : statistics?.aboveOutstandingSaudaQuantity.toString(),
                      subHeading: "Expired",
                      boxIcon: Constant.homePendingImg1,
                      txtSpan: " MT",
                      headingFontSize: Constant.fontSize18,
                      subHeadingFontSize: Constant.fontSize12,
                      headingFontWeight: FontWeight.w600,
                    )),
                const SizedBox(width: 13),
                InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             PendingSaudaScreen()));
                    },
                    child: CurveBox1(
                      boxSize: 2,
                      boxIcon: Constant.homePendingImg2,
                      miniusValue: 29,
                      boxHeight: 72,
                      boxColor: Constant.homeBoxPendingOrange,
                      headingTxt: statistics?.belowOutstandingSaudaQuantity == null ? "-" : statistics?.belowOutstandingSaudaQuantity.toString(),
                      subHeading: "Near Expired",
                      txtSpan: " MT",
                      headingFontSize: Constant.fontSize18,
                      subHeadingFontSize: Constant.fontSize12,
                      headingFontWeight: FontWeight.w600,
                    ))
              ],
            ),
            const SizedBox(height: 20),
            // const BorderBottom(),
            const DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 3.0,
              dashColor: Color(0xFFA1A1A1),
              dashRadius: 0.0,
              dashGapLength: 3.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            )
          ],
        ),
        Visibility(
            visible: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                HeadingSix(
                  headingSix: Constant.homeTitle2,
                  heaingSize: Constant.headingSix,
                  headingWeight: Constant.fontWeight600,
                  headingColor: Constant.colorBlack,
                ),
                const SizedBox(height: 15),
                Visibility(
                    visible: true, //(Constants.AUTH_ROLEID == Constants.SALE),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TodayRateScreen()));
                            },
                            child: CurveBox(
                              boxSize: 2,
                              miniusValue: 29,
                              boxHeight: 72,
                              boxColor: Constant.homeBoxTodayColor1,
                              boxIcon: Constant.homeTodayImg1,
                              headingTxt: "Today's Rate",
                              subHeading: "",
                              headingFontSize: Constant.fontSize18,
                              subHeadingFontSize: Constant.fontSize0,
                              headingFontWeight: FontWeight.w600,
                            )),
                        const SizedBox(width: 13),
                        // CurveBox(
                        //   boxSize: 2,
                        //   miniusValue: 29,
                        //   boxHeight: 60,
                        //   boxIcon: Constant.homeTodayImg2,
                        //   boxColor: Constant.homeBoxTodayColor2,
                        //   headingTxt: "Today's Plan",
                        //   subHeading: "",
                        //   headingFontSize: Constant.fontSize15,
                        //   subHeadingFontSize: Constant.fontSize0,
                        //   headingFontWeight: FontWeight.w600,
                        // )
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PendingSaudaScreen()));
                            },
                            child: CurveBox1(
                              boxSize: 2,
                              boxIcon: Constant.homePendingImg2,
                              miniusValue: 29,
                              boxHeight: 72,
                              boxColor: Constant.homeBoxTodayColor2,
                              headingTxt: (statistics?.pendingSaudaQuantity == null ? "" : statistics?.pendingSaudaQuantity!.toString())!,
                              subHeading: "Pending Sauda",
                              txtSpan: " MT",
                              headingFontSize: Constant.fontSize18,
                              subHeadingFontSize: Constant.fontSize12,
                              headingFontWeight: FontWeight.w600,
                            ))
                      ],
                    )),
                // Visibility(
                //     visible: (Constants.AUTH_ROLEID == Constants.NHMANAGER ||
                //         Constants.AUTH_ROLEID == Constants.ZHMANAGER ||
                //         Constants.AUTH_ROLEID == Constants.DEALER),
                //     child: Row(
                //       children: [
                //         InkWell(
                //             onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) =>
                //                           const TodayRateScreen()));
                //             },
                //             child: CurveBox(
                //               boxSize: 1,
                //               miniusValue: 58,
                //               boxHeight: 60,
                //               boxColor: Constant.homeBoxTodayColor1,
                //               boxIcon: Constant.homeTodayImg1,
                //               headingTxt: "Today's Rate",
                //               subHeading: "",
                //               headingFontSize: Constant.fontSize15,
                //               subHeadingFontSize: Constant.fontSize0,
                //               headingFontWeight: FontWeight.w600,
                //             )),
                //       ],
                //     )),
                const SizedBox(height: 20),
                const DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 3.0,
                  dashColor: Color(0xFFA1A1A1),
                  dashRadius: 0.0,
                  dashGapLength: 3.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
              ],
            )),
        Visibility(
            visible: (Constants.AUTH_ROLEID != Constants.NHMANAGER),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                HeadingSix(
                  headingSix: Constant.homeTitle3,
                  heaingSize: Constant.headingSix,
                  headingWeight: Constant.fontWeight600,
                  headingColor: Constant.colorBlack,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OverDueScreen()));
                        },
                        child: CurveBox(
                            boxSize: 2,
                            miniusValue: 29,
                            boxHeight: 76,
                            boxColor: Constant.homeBoxDueColor1,
                            headingTxt: "Over Due",
                            subHeading: (statistics?.totalOverDue == null ? "-" : "₹ " + (statistics?.totalOverDue?.toStringAsFixed(2)).toString()),
                            headingFontSize: Constant.fontSize14,
                            subHeadingFontSize: Constant.fontSize16,
                            subhHadingFontWeight: FontWeight.w600)),
                    const SizedBox(width: 13),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OverDueScreen()));
                        },
                        child: CurveBox(
                            boxSize: 2,
                            miniusValue: 29,
                            boxHeight: 76,
                            boxColor: Constant.homeBoxPendingOrange,
                            headingTxt: "Tomorrow Due",
                            subHeading: (statistics?.totalDueForTomorrow == null ? "-" : "₹ " + (statistics?.totalDueForTomorrow?.toStringAsFixed(2)).toString()),
                            headingFontSize: Constant.fontSize14,
                            subHeadingFontSize: Constant.fontSize16,
                            subhHadingFontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBox(height: 5),
              ],
            )),
      ],
    );

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );

    return BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is OnSuccess) {
            // seriesList = [];
            // salesSeriesList = [];
            overallSeriesList.clear();
            overallSalesSeriesList.clear();
            // setState(() {
            //
            // });
            seriesList = _createChartData(state.response);
            salesSeriesList = _createSalesChartData(state.salesResponse);
            tickerList = state.tickerList;
            for (TickerList t in tickerList) {
              tickerText = tickerText + " " + t.content!;
            }
            GMLogger.v("series " + seriesList.toString());
            setState(() {});
          }
          if (state is onLastAliveTimeSuccess) {
            setState(() {});
          }

          if (state is OnOverallSuccess) {
            // overallSeriesList = [];
            // overallSalesSeriesList = [];
            seriesList.clear();
            salesSeriesList.clear();
            // setState(() {
            //
            // });
            overallSeriesList = _createOverallChartData(state.response, false);
            overallSalesSeriesList = _createOverallChartData(state.salesResponse, true);
            GMLogger.v("series1 " + overallSeriesList.toString());
            setState(() {});
          }
          if (state is OnStatisticsSuccess) {
            setState(() {
              statistics = state.response;
              distributorList = state.distributorList;
              if (selectedDistributor != null) {
                selectedDistributor = distributorList.where((element) => element.id == selectedDistributor!.id!).first;
              } else {
                selectedDistributor = distributorList[0];
              }
            });
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
          if (state is NotifyScreenState) {
            GMLogger.v("NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
            setState(() {});
          }
        },
        child: SafeArea(
          child: Scaffold(
            primary: false,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: HomeAppbar(),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurveOuterBox(boxLRPadding: 1, boxTBPadding: 0, boxofWidget: homeGraphs),
                        CurveOuterBox(boxofWidget: boxOfNav),
                        Container(
                            margin: const EdgeInsets.all(8),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ListOFMenuItemModel.category.length,
                                itemBuilder: (context, index) {
                                  return (index == 3) || (index == 4) ||
                                          (Constants.NHMANAGER == Constants.AUTH_ROLEID && index == 1) ||
                                          (Constants.DEALER == Constants.AUTH_ROLEID && index == 2)
                                      ? const Visibility(visible: false, child: Text(""))
                                      : InkWell(
                                          onTap: () {
                                            // var link;
                                            if (0 == index) {
                                              if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const CustomerLedgerNH()),
                                                );
                                              } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => CustomerLedgerZH(selectedCustomerLedgerId: Constants.AUTH_USERID)),
                                                );
                                              } else if (Constants.AUTH_ROLEID == Constants.SALE) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => CustomerLedgerStateTrader(selectedCustomerLedgerId: Constants.AUTH_USERID)),
                                                );
                                              } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => CustomerLedger(selectedCustomerLedgerId: Constants.AUTH_DEALER_CODE)),
                                                );
                                              }
                                            } else if (1 == index) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => CallToCustomer()),
                                              );
                                            } else if (2 == index) {
                                              if (Constants.AUTH_ROLEID == Constants.SALE || Constants.AUTH_ROLEID == Constants.DEALER) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => SpecialRateApprovalScreen(
                                                            distributor: selectedDistributor!,
                                                          )),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const SpecialRateApprovalManagerScreen()),
                                                );
                                              }
                                            }
                                            else if (3 == index) {

                                            } else if (4 == index) {

                                            }
                                            else if (5 == index) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => TrackOrderScreenStateless()),
                                              );
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            height: 67.0,
                                            // padding: const EdgeInsets.all(16),
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
                                                  color: Color(0x18000000),
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
                                            child: SizedBox(
                                                width: MediaQuery.of(context).size.width,
                                                child: ListTile(
                                                  title: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        index == 1 && Constants.AUTH_ROLEID == Constants.DEALER ? "Call to State Trader" : ListOFMenuItemModel.category[index].name,
                                                        style: TextStyle(fontFamily: 'Aganè', fontSize: Constant.fontSize16),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 5),
                                                        child: ListOFMenuItemModel.category[index].round == true
                                                            ? Container(
                                                                width: 30.0,
                                                                height: 30.0,
                                                                decoration: BoxDecoration(
                                                                  color: Constant.colorRed,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Center(
                                                                  child: Text(statistics!.totalSpecialRateApproval != null ? statistics!.totalSpecialRateApproval!.toStringAsFixed(0) : "0",
                                                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Constant.colorWhite, fontSize: Constant.fontSize13)),
                                                                ))
                                                            : Container(
                                                                width: 30.0,
                                                                height: 30.0,
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                  trailing: SizedBox(
                                                    height: 15,
                                                    width: 24,
                                                    child: Constant.rightArow,
                                                  ),
                                                ) //BoxDecoration
                                                ),
                                          ));
                                })),
                      ],
                    ),
                  ),
                ),
                progressBar
              ],
            ),
            // bottomNavigationBar: CustomNavBar(
            //   selectedIndex: 1,
            // )
          ),
        ));
  }

  List<charts.Series<OverallWeekWiseAchievements, String>> _createChartData(WeeklyResponse response) {
    target = Utils().convertToK(response.totalTarget!);
    overAll = Utils().convertToK(response.overallSauda!);
    double perc = 0;
    if (response.totalTarget! > 0) {
      perc = response.overallSauda! / response.totalTarget! * 100;
    } else if (response.overallSauda! > 0) {
      perc = 100;
    }
    overAllPerc = Utils().convertToK(perc);
    return [
      charts.Series<OverallWeekWiseAchievements, String>(
          id: 'Target',
          domainFn: (OverallWeekWiseAchievements sales, _) => sales.week!,
          measureFn: (OverallWeekWiseAchievements sales, _) => sales.target!,
          data: response.overallWeekWiseAchievements!,
          colorFn: (OverallWeekWiseAchievements sales, _) => charts.ColorUtil.fromDartColor(Constant.chartBlueColor!),
          labelAccessorFn: (OverallWeekWiseAchievements sales, _) => Utils().convertToK(sales.target!)),
      charts.Series<OverallWeekWiseAchievements, String>(
          id: 'Achievement',
          domainFn: (OverallWeekWiseAchievements sales, _) => sales.week!,
          measureFn: (OverallWeekWiseAchievements sales, _) => sales.achievement!,
          data: response.overallWeekWiseAchievements!,
          colorFn: (OverallWeekWiseAchievements sales, _) => charts.ColorUtil.fromDartColor(Constant.chartGreenColor!),
          labelAccessorFn: (OverallWeekWiseAchievements sales, _) => Utils().convertToK(sales.achievement!)),
    ];
  }

  List<charts.Series<OverallWeekWiseAchievements, String>> _createSalesChartData(WeeklySalesResponse response) {
    salesTarget = Utils().convertToK(response.totalTarget!);
    // double overall = 0.0;
    // for (OverallWeekWiseAchievements o
    //     in response.overallWeekWiseAchievements!) {
    //   OverallWeekWiseAchievements n = OverallWeekWiseAchievements();
    //   n.week = o.week;
    //   n.achievement = response.totalTarget;
    //   n.weekId = 0;
    //   overall = overall + o.achievement!;
    //   targetData.add(n);
    // }
    overSalesAll = Utils().convertToK(response.overallSales!);
    double perc = 0;
    if (response.totalTarget! > 0) {
      perc = response.overallSales! / response.totalTarget! * 100;
    } else if (response.overallSales! > 0) {
      perc = 100;
    }
    salesOverAllPerc = Utils().convertToK(perc);
    return [
      charts.Series<OverallWeekWiseAchievements, String>(
        id: 'Target',
        domainFn: (OverallWeekWiseAchievements sales, _) => sales.week!,
        measureFn: (OverallWeekWiseAchievements sales, _) => sales.target!,
        data: response.overallWeekWiseAchievements!,
        colorFn: (OverallWeekWiseAchievements sales, _) => charts.ColorUtil.fromDartColor(Constant.chartBlueColor!),
        labelAccessorFn: (OverallWeekWiseAchievements sales, _) => Utils().convertToK(sales.target!),
      ),
      charts.Series<OverallWeekWiseAchievements, String>(
        id: 'Achievement',
        domainFn: (OverallWeekWiseAchievements sales, _) => sales.week!,
        measureFn: (OverallWeekWiseAchievements sales, _) => sales.achievement!,
        data: response.overallWeekWiseAchievements!,
        colorFn: (OverallWeekWiseAchievements sales, _) => charts.ColorUtil.fromDartColor(Constant.chartGreenColor!),
        labelAccessorFn: (OverallWeekWiseAchievements sales, _) => Utils().convertToK(sales.achievement!),
      ),
    ];
  }

  List<charts.Series<OverallChartData, String>> _createOverallChartData(OverallDashboard response, bool isSales) {
    List<OverallChartData>? targetData = [];
    List<OverallChartData>? overallChartData = [];
    double overall = 0.0;
    double totalTarget = 0.0;
    if (selectedMethod == "YTD") {
      OverallChartData n = OverallChartData();
      n.monthId = 1;
      n.month = "Quarter-1";
      n.achievement = response.quarter1!.totalTarget;
      targetData.add(n);
      OverallChartData nn = OverallChartData();
      nn.monthId = 1;
      nn.month = "Quarter-1";
      if (response.quarter1!.overallSauda != null) {
        nn.achievement = response.quarter1!.overallSauda!;
      } else if (response.quarter1!.overallSales != null) {
        nn.achievement = response.quarter1!.overallSales!;
      }
      overallChartData.add(nn);
      totalTarget = totalTarget + response.quarter1!.totalTarget!;
      if (response.quarter1!.overallSauda != null) {
        overall = overall + response.quarter1!.overallSauda!;
      } else if (response.quarter1!.overallSales != null) {
        overall = overall + response.quarter1!.overallSales!;
      }

      n = OverallChartData();
      n.monthId = 2;
      n.month = "Quarter-2";
      n.achievement = response.quarter2!.totalTarget;
      targetData.add(n);
      nn = OverallChartData();
      nn.monthId = 2;
      nn.month = "Quarter-2";
      if (response.quarter2!.overallSauda != null) {
        nn.achievement = response.quarter2!.overallSauda!;
      } else if (response.quarter2!.overallSales != null) {
        nn.achievement = response.quarter2!.overallSales!;
      }
      overallChartData.add(nn);
      totalTarget = totalTarget + response.quarter2!.totalTarget!;
      if (response.quarter2!.overallSauda != null) {
        overall = overall + response.quarter2!.overallSauda!;
      } else if (response.quarter2!.overallSales != null) {
        overall = overall + response.quarter2!.overallSales!;
      }

      n = OverallChartData();
      n.monthId = 3;
      n.month = "Quarter-3";
      n.achievement = response.quarter3!.totalTarget;
      targetData.add(n);
      nn = OverallChartData();
      nn.monthId = 3;
      nn.month = "Quarter-3";
      if (response.quarter3!.overallSauda != null) {
        nn.achievement = response.quarter3!.overallSauda!;
      } else if (response.quarter3!.overallSales != null) {
        nn.achievement = response.quarter3!.overallSales!;
      }
      overallChartData.add(nn);
      totalTarget = totalTarget + response.quarter3!.totalTarget!;
      if (response.quarter3!.overallSauda != null) {
        overall = overall + response.quarter3!.overallSauda!;
      } else if (response.quarter3!.overallSales != null) {
        overall = overall + response.quarter3!.overallSales!;
      }

      n = OverallChartData();
      n.monthId = 4;
      n.month = "Quarter-4";
      n.achievement = response.quarter4!.totalTarget;
      targetData.add(n);
      nn = OverallChartData();
      nn.monthId = 4;
      nn.month = "Quarter-4";
      if (response.quarter4!.overallSauda != null) {
        nn.achievement = response.quarter4!.overallSauda!;
      } else if (response.quarter4!.overallSales != null) {
        nn.achievement = response.quarter4!.overallSales!;
      }
      overallChartData.add(nn);
      totalTarget = totalTarget + response.quarter4!.totalTarget!;
      if (response.quarter4!.overallSauda != null) {
        overall = overall + response.quarter4!.overallSauda!;
      } else if (response.quarter4!.overallSales != null) {
        overall = overall + response.quarter4!.overallSales!;
      }
    } else {
      if (response.saudaList != null) {
        for (OverallResponse o in response.saudaList!) {
          OverallChartData n = OverallChartData();
          n.monthId = o.monthId;
          n.month = o.month;
          n.achievement = o.totalTarget;
          targetData.add(n);
          double achievement = o.overallSauda != null ? o.overallSauda! : 0;
          // for (AchievmentDetailsDto d in o.achievmentDetailsDto!) {
          //   achievement = achievement + d.achievment!;
          // }
          // if (kDebugMode) {
          //   print(achievement);
          // }
          OverallChartData nn = OverallChartData();
          nn.monthId = o.monthId;
          nn.month = o.month;
          nn.achievement = achievement;
          overallChartData.add(nn);
          totalTarget = totalTarget + o.totalTarget!;
          overall = overall + achievement;
        }
      } else {
        for (OverallResponse o in response.salesList!) {
          OverallChartData n = OverallChartData();
          n.monthId = o.monthId;
          n.month = o.month;
          n.achievement = o.totalTarget;
          targetData.add(n);
          double achievement = o.overallSales != null ? o.overallSales! : 0;
          // for (AchievmentDetailsDto d in o.achievmentDetailsDto!) {
          //   achievement = achievement + d.achievment!;
          // }
          // if (kDebugMode) {
          //   print(achievement);
          // }
          OverallChartData nn = OverallChartData();
          nn.monthId = o.monthId;
          nn.month = o.month;
          nn.achievement = achievement;
          overallChartData.add(nn);
          totalTarget = totalTarget + o.totalTarget!;
          overall = overall + achievement;
        }
      }
    }
    if (!isSales) {
      target = Utils().convertToK(response.totalTarget!);
      overAll = Utils().convertToK(response.overallSauda!);
    } else {
      salesTarget = Utils().convertToK(response.totalTarget!);
      if (response.overallSauda != null) {
        overSalesAll = Utils().convertToK(response.overallSauda!);
      } else if (response.overallSales != null) {
        overSalesAll = Utils().convertToK(response.overallSales!);
      }
    }
    double perc = 0;
    if (response.overallSauda != null) {
      if (response.totalTarget! > 0) {
        perc = response.overallSauda! / response.totalTarget! * 100;
      } else if (response.overallSauda! > 0) {
        perc = 100;
      }
    } else if (response.overallSales != null) {
      if (response.totalTarget! > 0) {
        perc = response.overallSales! / response.totalTarget! * 100;
      } else if (response.overallSales! > 0) {
        perc = 100;
      }
    }
    if (!isSales) {
      overAllPerc = Utils().convertToK(perc);
    } else {
      salesOverAllPerc = Utils().convertToK(perc);
    }
    // print(overallChartData);
    return [
      charts.Series<OverallChartData, String>(
        id: 'Target',
        domainFn: (OverallChartData sales, _) => sales.month!.toString(),
        measureFn: (OverallChartData sales, _) => sales.achievement!,
        data: targetData,
        colorFn: (OverallChartData sales, _) => charts.ColorUtil.fromDartColor(Constant.chartBlueColor!),
        labelAccessorFn: (OverallChartData sales, _) => Utils().convertToK(sales.achievement!),
      ),
      charts.Series<OverallChartData, String>(
        id: 'Achievement',
        domainFn: (OverallChartData sales, _) => sales.month!.toString(),
        measureFn: (OverallChartData sales, _) => sales.achievement!,
        data: overallChartData,
        colorFn: (OverallChartData sales, _) => charts.ColorUtil.fromDartColor(Constant.chartGreenColor!),
        labelAccessorFn: (OverallChartData sales, _) => Utils().convertToK(sales.achievement!),
      ),
    ];
  }
}
