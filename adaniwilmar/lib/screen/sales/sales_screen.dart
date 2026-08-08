import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/config/constant.dart';
import 'package:adaniwilmar/models/credit_limit_total.dart';
import 'package:adaniwilmar/screen/sales/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../gmcore/network/GMLogger.dart';
import '../../utils/utils.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({Key? key}) : super(key: key);
  static const String routeName = '/sales';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const SalesScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesBloc()
        ..add(LoadSalesScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            isBulkPack: false,
            selectedMethod: "MTD")),
      //This is called inside the LoadSalesScreen bloc
      /*..add(LoadSalesChart(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now()
                    .add(const Duration(days: Constants.REPORT_START_DAY)),
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            isBulkPack: false,
            selectedMethod: "MTD")),*/
      child: const Sales(),
    );
  }
}

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<Sales> {
  String fromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;
  double targetPercentage = 0;
  double achievedPercentage = 0;
  CreditLimitTotal creditLimitTotal = CreditLimitTotal();
  int selectedFilterType = 1;
  String overAll = "100";
  String target = "90";
  String overAllPerc = "80%";
  String selectedMethod = "MTD";
  List<charts.Series<SalesChart, String>> seriesList = [];
  List<charts.TickSpec<num>> tickSpecs = [charts.TickSpec<num>(0), charts.TickSpec<num>(10), charts.TickSpec<num>(20), charts.TickSpec<num>(30), charts.TickSpec<num>(40), charts.TickSpec<num>(50)];
  SalesChartResponse salesChartData = SalesChartResponse(salesList: [], totalTarget: 0, overallSales: 0);
  DealerSalesChartResponse dealerSalesData = DealerSalesChartResponse(salesList: [], totalTarget: 0, overallSales: 0);
  List<DealerSalesChart> dealerSales = [];
  ProgressBarHandler? _handler;
  List<SalesChart>? targetData = [];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    _fromdatecontroller.text = fromDate;
    _todatecontroller.text = toDate;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );

    Widget salesGraphs = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //HeadingSix(headingSix: "Planned Vs Deviated Days"),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Visibility(
                  visible: Constants.AUTH_ROLEID != Constants.DEALER,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Filter Type",
                        style: TextStyle(fontSize: Constant.fontSize14, fontWeight: FontWeight.w600),
                      ))),
              Visibility(
                  visible: Constants.AUTH_ROLEID != Constants.DEALER,
                  child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Expanded(
                          child: Theme(
                              data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.black,
                                  disabledColor: Colors.grey,
                                  // toggleableActiveColor: Colors.red
                              ),
                              child: RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Oil Type', style: TextStyle(fontSize: Constant.fontSize14)),
                                value: 1,
                                groupValue: selectedFilterType,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedFilterType = value!;
                                  });
                                  setParentState();
                                },
                              ))),
                      Expanded(
                          child: Theme(
                              data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.green[900],
                                  disabledColor: Colors.green[900],
                                  // toggleableActiveColor: Colors.green[900]
                              ),
                              child: RadioListTile<int>(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  Constants.AUTH_ROLEID == Constants.ZHMANAGER
                                      ? 'State Trader'
                                      : Constants.AUTH_ROLEID == Constants.NHMANAGER
                                          ? 'Zonal Trader'
                                          : 'Distributor',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: 2,
                                groupValue: selectedFilterType,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedFilterType = value!;
                                  });
                                  setParentState();
                                },
                              ))),
                    ]);
                  })),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: Wrap(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: const EdgeInsets.only(right: 2), child: Text("Overall", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack))),
                                Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Text(overAll + " MT", style: TextStyle(fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600, color: Constant.homeBoxPendingOrange))),
                                Visibility(
                                    visible: false,
                                    child: Padding(
                                        padding: const EdgeInsets.only(right: 2),
                                        child: Text("(" + overAllPerc + ")", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorDullGray77))))
                              ])),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: Wrap(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: const EdgeInsets.only(top: 2, right: 4), child: Text("Target", style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack))),
                                Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(target + " MT", style: TextStyle(fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight500, color: Constant.homeBoxPendingOrange))),
                              ]))
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.372,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                                        setParentState();
                                        setState(() {});
                                      },
                                      child: Text("MTD",
                                          style: TextStyle(
                                              fontSize: Constant.fontSize10, fontWeight: Constant.fontWeight500, color: selectedMethod == "MTD" ? Colors.white : Constant.homeBoxPendingOrange))))),
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
                                        setParentState();
                                        setState(() {});
                                      },
                                      child: Text("QTD",
                                          style: TextStyle(
                                              fontSize: Constant.fontSize10, fontWeight: Constant.fontWeight500, color: selectedMethod == "QTD" ? Colors.white : Constant.homeBoxPendingOrange))))),
                          Visibility(
                              visible: true,
                              child: Container(
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
                                            setParentState();
                                            setState(() {});
                                          },
                                          child: Text("YTD",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: Constant.fontSize10, fontWeight: Constant.fontWeight500, color: selectedMethod == "YTD" ? Colors.white : Colors.orange))))))
                        ],
                      )),
                ],
              ),
              SizedBox(height: 5),
              selectedFilterType == 1
                  ? SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: seriesList.isNotEmpty
                          ?
                      charts.BarChart
                        (
                              seriesList,
                              animate: false,
                              barRendererDecorator: new charts.BarLabelDecorator(
                                  labelPosition: charts.BarLabelPosition.outside,
                                  insideLabelStyleSpec: new charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9),
                                  outsideLabelStyleSpec: new charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9)),
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
                                  viewport: charts.OrdinalViewport(targetData != null && targetData!.length > 0 ? targetData![0].oilType! : "", 2),
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
                                  tickProviderSpec: new charts.StaticNumericTickProviderSpec(tickSpecs),
                                  // tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                                  //     desiredTickCount: 6,
                                  //     zeroBound: true
                                  // ),

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
                          : const Text("No Data Available"))
                  : CurveBorderBox(
                      boxBRRadius: 8,
                      boxTRRadius: 8,
                      boxBLRadius: 8,
                      boxTLRadius: 8,
                      boxofWidget: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                color: const Color(0xFFECECEC),
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CommonText(
                                        name: Constants.AUTH_ROLEID == Constants.ZHMANAGER
                                            ? 'State Trader'
                                            : Constants.AUTH_ROLEID == Constants.NHMANAGER
                                                ? "Zonal Trader"
                                                : "Distributor Name",
                                        fontSize: Constant.fontSize12,
                                        fontColor: Constant.colorBlack,
                                        fontWeight: Constant.fontWeight500,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CommonText(
                                        name: "Target",
                                        fontSize: Constant.fontSize12,
                                        fontColor: Constant.colorBlack,
                                        fontWeight: Constant.fontWeight500,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CommonText(
                                        name: "Achievement",
                                        fontSize: Constant.fontSize12,
                                        fontColor: Constant.colorBlack,
                                        fontWeight: Constant.fontWeight500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: dealerSales.length,
                                      itemBuilder: (context, index) {
                                        return MaterialButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          child: Container(
                                            color: const Color(0xFFFAFAFA),
                                            padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: CommonText(
                                                    name: dealerSales[index].dealer != null ? dealerSales[index].dealer : "",
                                                    fontSize: Constant.fontSize12,
                                                    fontColor: Constant.colorBlack,
                                                    fontWeight: Constant.fontWeight600,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(children: [
                                                    CommonText(
                                                      name: dealerSales[index].totalTarget!.toStringAsFixed(2),
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                    CommonText(
                                                      name: " MT",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorGray45,
                                                      fontWeight: Constant.fontWeight500,
                                                    )
                                                  ]),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(children: [
                                                    CommonText(
                                                      name: dealerSales[index].totalAchievment!.toStringAsFixed(2),
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                    CommonText(
                                                      name: " MT",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorGray45,
                                                      fontWeight: Constant.fontWeight500,
                                                    )
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                            ],
                          ))),
            ],
          ),
        )
      ],
    );
    Widget boxofNav = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSix(
          headingSix: Constant.salesTitle1,
          heaingSize: Constant.headingSix,
          headingWeight: Constant.fontWeight500,
          headingColor: Constant.colorBlack,
        ),
        const SizedBox(height: 8),
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PackGroupScreen()),
            );
          },
          child: CurveBox(
            boxSize: 1,
            boxIcon: Constant.salesImage1,
            miniusValue: 29,
            boxHeight: 66,
            boxColor: Constant.salescolor1,
            headingTxt: "Pack Group",
            subHeading: "",
            headingFontSize: Constant.fontSize16,
            subHeadingFontSize: Constant.fontSize0,
            headingFontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 13),
        Visibility(
            visible: (Constants.AUTH_ROLEID == Constants.SALE || Constants.AUTH_ROLEID == Constants.ZHMANAGER),
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourPerformanceScreen()),
                );
              },
              child: CurveBox(
                boxSize: 1,
                boxIcon: Constant.salesImage3,
                miniusValue: 29,
                boxHeight: 66,
                boxColor: Constant.salescolor3,
                headingTxt: " Your Performance",
                subHeading: "",
                headingFontSize: Constant.fontSize16,
                subHeadingFontSize: Constant.fontSize0,
                headingFontWeight: FontWeight.w400,
              ),
            ))
      ],
    );
    Widget boxofNavTwo = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: HeadingSix(
                headingSix: Constant.salesTitle2,
                heaingSize: Constant.headingSix,
                headingWeight: Constant.fontWeight500,
                headingColor: Constant.colorBlack,
              ),
            ),
            Visibility(
                visible: Constants.AUTH_ROLEID != Constants.DEALER,
                child: Align(
                  alignment: Alignment.topRight,
                  child: CommonLabel(
                    paddingTop: 7,
                    paddingBottom: 7,
                    bgColor: Constant.colorRed,
                    name: creditLimitTotal.dealersCount != null ? creditLimitTotal.dealersCount.toString() + " Dealers" : "0 Dealers",
                    fontSize: 13,
                    fontWeight: Constant.fontWeight600,
                    fontColor: Constant.colorWhite,
                  ),
                ))
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreditLimitExposureScreen()),
                );
              },
              child: CurveBox2(
                boxSize: 2,
                miniusValue: 29,
                boxIcon: Constant.rupeeSymbol,
                boxHeight: 85,
                boxColor: Constant.salescolor1,
                headingTxt: creditLimitTotal.totalCreditLimit != null ? creditLimitTotal.totalCreditLimit!.toStringAsFixed(2) + " Lacs" : "",
                subHeading: "Total Credit Limit",
                txtSpan: "",
                spamIcon: Constant.salesImage4,
                headingFontSize: Constant.fontSize15,
                subHeadingFontSize: Constant.fontSize13,
                headingFontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 13),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreditLimitExposureScreen()),
                );
              },
              child: CurveBox2(
                boxSize: 2,
                miniusValue: 29,
                boxHeight: 85,
                boxColor: Constant.salescolor2,
                boxIcon: Constant.rupeeSymbol,
                headingTxt: creditLimitTotal.totalCreditExposure != null ? creditLimitTotal.totalCreditExposure!.toStringAsFixed(2) + " Lacs" : "",
                subHeading: "Credit Exposure",
                txtSpan: "",
                spamIcon: Constant.salesImage4,
                headingFontSize: Constant.fontSize15,
                subHeadingFontSize: Constant.fontSize13,
                headingFontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
    Widget boxofNavOneDealer = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: HeadingSix(
                headingSix: "Sales Analysis",
                heaingSize: Constant.headingSix,
                headingWeight: Constant.fontWeight500,
                headingColor: Constant.colorBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PackGroupScreen()),
            );
          },
          child: CurveBox(
            boxSize: 1,
            boxIcon: Constant.salesImage1,
            miniusValue: 29,
            boxHeight: 66,
            boxColor: Constant.salescolor1,
            headingTxt: "Pack Group",
            subHeading: "",
            headingFontSize: Constant.fontSize16,
            subHeadingFontSize: Constant.fontSize0,
            headingFontWeight: FontWeight.w400,
          ),
        ),
        // Row(
        //   children: [
        //     MaterialButton(
        //       padding: EdgeInsets.zero,
        //       onPressed: () {
        //         // Navigator.push(
        //         //   context,
        //         //   MaterialPageRoute(
        //         //       builder: (context) => const CreditLimitExposureScreen()),
        //         // );
        //       },
        //       child: CurveBox(
        //         boxSize: 2,
        //         miniusValue: 29,
        //         boxIcon: Constant.rupeeSymbol,
        //         boxHeight: 66,
        //         boxColor: Constant.salescolor1,
        //         headingTxt: "0.00",
        //         subHeading: "Bulk Pack",
        //         txtSpan: "MT",
        //         spamIcon: Constant.salesImage4,
        //         headingFontSize: Constant.fontSize16,
        //         subHeadingFontSize: Constant.fontSize13,
        //         headingFontWeight: FontWeight.w600,
        //       ),
        //     ),
        //     const SizedBox(width: 13),
        //     MaterialButton(
        //       padding: EdgeInsets.zero,
        //       onPressed: () {
        //         // Navigator.push(
        //         //   context,
        //         //   MaterialPageRoute(
        //         //       builder: (context) => const CreditLimitExposureScreen()),
        //         // );
        //       },
        //       child: CurveBox(
        //         boxSize: 2,
        //         miniusValue: 29,
        //         boxHeight: 66,
        //         boxColor: Constant.salescolor2,
        //         boxIcon: Constant.rupeeSymbol,
        //         headingTxt: "0.00",
        //         subHeading: "Custom Back",
        //         txtSpan: " MT",
        //         spamIcon: Constant.salesImage4,
        //         headingFontSize: Constant.fontSize16,
        //         subHeadingFontSize: Constant.fontSize13,
        //         headingFontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
    return BlocListener<SalesBloc, SalesState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            creditLimitTotal = state.creditLimitTotal;
            setState(() {});
          }
          if (state is OnLoadChartSuccess) {
            salesChartData = state.salesChartData;
            seriesList = _createSalesChartData();
            setState(() {});
          }
          if (state is OnLoadDealerSalesSuccess) {
            dealerSalesData = state.salesChartData;
            dealerSales = dealerSalesData.salesList!;
            double targets = state.salesChartData.totalTarget!;
            double ach = state.salesChartData.overallSales!;
            overAll = Utils().convertToK(ach);
            target = Utils().convertToK(targets);
            double perc = 0;
            if (targets > 0) {
              perc = ach / targets * 100;
            } else if (ach > 0) {
              perc = 100;
            }
            overAllPerc = perc.toStringAsFixed(2);
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
          appBar: const CustomAppBar(title: "Sales"),
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
                      CurveOuterBox(boxofWidget: salesGraphs),
                      CurveOuterBox(boxofWidget: Constants.DEALER == Constants.AUTH_ROLEID ? boxofNavOneDealer : boxofNav),
                      Visibility(visible: Constants.NHMANAGER != Constants.AUTH_ROLEID, child: CurveOuterBox(boxofWidget: boxofNavTwo)),
                    ],
                  ))),
              progressBar
            ],
          ),
        ));
  }

  List<charts.Series<SalesChart, String>> _createSalesChartData() {
    targetData = [];
    double targets = salesChartData.totalTarget!;
    double ach = salesChartData.overallSales!;
    for (SalesChart o in salesChartData.salesList!) {
      // targets = targets + o.totalTarget!;
      // ach = ach + o.totalAchievment!;
      if (targetData!.where((element) => element.oilTypeId == o.oilTypeId).isEmpty) {
        if (targetData!.where((element) => element.oilType == o.oilType).isNotEmpty) {
          o.oilType = o.oilType! + "-" + o.oilTypeId.toString();
        }
        targetData!.add(o);
      } else {
        SalesChart c = targetData!.where((element) => element.oilTypeId == o.oilTypeId).first;
        c.totalAchievment = c.totalAchievment! + o.totalAchievment!;
        c.totalTarget = c.totalTarget! + o.totalTarget!;
      }
    }
    overAll = Utils().convertToK(ach);
    target = Utils().convertToK(targets);
    double perc = 0;
    if (targets > 0) {
      perc = ach / targets * 100;
    } else if (ach > 0) {
      perc = 100;
    }
    overAllPerc = perc.toStringAsFixed(2);
    GMLogger.v(jsonEncode(targetData!));
    double max = 0;
    for (SalesChart target in targetData!) {
      if (target.totalAchievment! > max) {
        max = target.totalAchievment!;
      }
      if (target.totalTarget! > max) {
        max = target.totalTarget!;
      }
    }
    if (max > 50) {
      if (max % 80 > 0) {
        max = max + (80 - (max % 100));
      }
      tickSpecs = [
        charts.TickSpec<num>(0),
        charts.TickSpec<num>(max * 20 / 100),
        charts.TickSpec<num>(max * 40 / 100),
        charts.TickSpec<num>(max * 60 / 100),
        charts.TickSpec<num>(max * 80 / 100),
        charts.TickSpec<num>(max),
      ];
    }
    return [
      charts.Series<SalesChart, String>(
          id: 'Target',
          domainFn: (SalesChart sales, _) => sales.oilType == null ? "" : sales.oilType!,
          measureFn: (SalesChart sales, _) => sales.totalTarget!,
          data: targetData!,
          colorFn: (SalesChart sales, _) => charts.ColorUtil.fromDartColor(Constant.chartBlueColor!),
          labelAccessorFn: (SalesChart sales, _) => Utils().convertToK(sales.totalTarget!)),
      charts.Series<SalesChart, String>(
          id: 'Achievement',
          domainFn: (SalesChart sales, _) => sales.oilType == null ? "" : sales.oilType!,
          measureFn: (SalesChart sales, _) => sales.totalAchievment!,
          data: targetData!,
          colorFn: (SalesChart sales, _) => charts.ColorUtil.fromDartColor(Constant.chartGreenColor!),
          labelAccessorFn: (SalesChart sales, _) => Utils().convertToK(sales.totalAchievment!)),
    ];
  }

  void setParentState() {
    if (selectedFilterType == 1) {
      BlocProvider.of<SalesBloc>(context).add(LoadSalesScreen(
          userId: Constants.AUTH_USERID,
          fromDate: DateTimeUtils().dateToServerToDateFormat(fromDate, DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
          toDate: DateTimeUtils().dateToServerToDateFormat(toDate, DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
          isBulkPack: false,
          selectedMethod: selectedMethod));
      //This is called inside the LoadSalesScreen bloc
      /*BlocProvider.of<SalesBloc>(context).add(LoadSalesChart(
          userId: Constants.AUTH_USERID,
          fromDate: DateTimeUtils().dateToServerToDateFormat(fromDate,
              DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
          toDate: DateTimeUtils().dateToServerToDateFormat(toDate,
              DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
          isBulkPack: false,
          selectedMethod: selectedMethod));*/
    } else {
      BlocProvider.of<SalesBloc>(context).add(LoadDealerSales(
          userId: Constants.AUTH_USERID,
          fromDate: DateTimeUtils().dateToServerToDateFormat(fromDate, DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
          toDate: DateTimeUtils().dateToServerToDateFormat(toDate, DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
          isBulkPack: false,
          selectedMethod: selectedMethod));
    }
    setState(() {});
  }
}
