import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/screen/stp/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constant.dart';
import '../../models/stp_model.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class StpScreen extends StatelessWidget {
  const StpScreen({Key? key}) : super(key: key);
  static const String routeName = '/stp';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const StpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StpBloc()
        ..add(LoadStpScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now()
                    .add(const Duration(days: Constants.REPORT_START_DAY)),
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            financialYearId: 2)),
      child: const Stp(),
    );
  }
}

class Stp extends StatefulWidget {
  const Stp({Key? key}) : super(key: key);

  @override
  State<Stp> createState() => _StpScreenState();
}

class _StpScreenState extends State<Stp> {
  List<SalesTourPlanChartViewDto> chartData = [];
  List<charts.Series<SalesTourPlanChartViewDto, String>> seriesList = [];
  ProgressBarHandler? _handler;
  String fromDate = DateTimeUtils().dateToStringFormat(
      DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)),
      DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  final GlobalKey _dialogKey = GlobalKey();
  double screenWidth = 0;
  double screenHeight = 0;
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
    Widget boxes = Column(
      children: [
        Row(
          children: [
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PcpScreen()));
              },
              child: CurveBox(
                boxSize: 2,
                boxHeight: 60,
                miniusValue: 30,
                boxColor: const Color(0xff00A7D4),
                headingTxt: "View PCP",
                paddingLeft: 16,
                paddingRight: 16,
                boxIcon: SvgPicture.asset(
                  "assets/images/pcp.svg",
                  width: 45,
                  height: 45,
                ),
                subHeading: "",
                headingFontSize: 15.0,
                subHeadingFontSize: 0.0,
                headingFontWeight: FontWeight.w700,
              ),
            ),
            Visibility(
                visible: Constants.NHMANAGER != Constants.AUTH_ROLEID,
                child: const SizedBox(width: 13)),
            Visibility(
                visible: Constants.NHMANAGER != Constants.AUTH_ROLEID,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MtpScreen()));
                  },
                  child: CurveBox(
                    boxHeight: 60,
                    headingTxtColor: Constant.colorBlack,
                    boxSize: 2,
                    miniusValue: 30,
                    paddingLeft: 16,
                    paddingRight: 16,
                    boxColor: const Color(0xffF5BD3A),
                    headingTxt: "MTP",
                    boxIcon: SvgPicture.asset(
                      "assets/images/mtp.svg",
                      width: 40,
                      height: 40,
                    ),
                    subHeading: "",
                    headingFontSize: 15.0,
                    subHeadingFontSize: 0.0,
                    headingFontWeight: FontWeight.w700,
                  ),
                )),
          ],
        ),
        Visibility(
            visible: Constants.SALE == Constants.AUTH_ROLEID,
            child: const SizedBox(height: 12)),
        Visibility(
            visible: false,//Constants.SALE == Constants.AUTH_ROLEID,
            child: CurveBox(
              boxHeight: 60,
              boxSize: 1,
              miniusValue: 48,
              boxColor: const Color(0xff00974C),
              headingTxt: "Holidays",
              paddingLeft: 16,
              paddingRight: 16,
              boxIcon: SvgPicture.asset(
                "assets/images/holiday.svg",
                width: 30,
                height: 30,
              ),
              subHeading: "",
              headingFontSize: 15.0,
              subHeadingFontSize: 0.0,
              headingFontWeight: FontWeight.w700,
            )),
      ],
    );
    return BlocListener<StpBloc, StpState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            chartData = state.chartData;
            seriesList = _createChartData();
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
            title: "Sales Tour Plan",
            backArrow: false,
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
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(7),
                      child: Constant.bellIconNot,
                    ),
                  ),
                ),
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
                  margin: EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurveOuterBox(
                            boxofWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeadingSix(
                                    headingSix: "Planned Vs Deviated Days",
                                    heaingSize: Constant.fontSize16),
                                IconButton(
                                  onPressed: () {
                                    showCustomFilterDialog(context, "Filter",
                                        "Filter", dialogActionButtonFilter());
                                  },
                                  icon: SizedBox(
                                    width: 30.0,
                                    height: 30.0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      padding: const EdgeInsets.all(7),
                                      child: Constant.filterIc,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: seriesList.isNotEmpty
                                    ? charts.BarChart(
                                        seriesList,
                                        animate: false,
                                        defaultRenderer:
                                            charts.BarRendererConfig(
                                          maxBarWidthPx: 10,
                                        ),
                                        behaviors: [
                                          charts.SeriesLegend(
                                            position:
                                                charts.BehaviorPosition.bottom,
                                            outsideJustification: charts
                                                .OutsideJustification.start,
                                            horizontalFirst: false,
                                            desiredMaxRows: 1,
                                            cellPadding: const EdgeInsets.only(
                                                right: 4.0,
                                                bottom: 4.0,
                                                top: 10.0),
                                            entryTextStyle:
                                                charts.TextStyleSpec(
                                                    color: charts.ColorUtil
                                                        .fromDartColor(
                                                            Colors.black),
                                                    fontFamily: 'Aganè',
                                                    fontSize: 14),
                                          )
                                        ],
                                        domainAxis: charts.OrdinalAxisSpec(
                                            renderSpec:
                                                charts.SmallTickRendererSpec(

                                                    // Tick and Label styling here.
                                                    labelStyle:
                                                        charts.TextStyleSpec(
                                                            fontSize:
                                                                13, // size in Pts.
                                                            color: charts
                                                                    .ColorUtil
                                                                .fromDartColor(
                                                                    Colors
                                                                        .black)),

                                                    // Change the line colors to match text color.
                                                    lineStyle: charts.LineStyleSpec(
                                                        thickness: 1,
                                                        color: charts.ColorUtil
                                                            .fromDartColor(Constant
                                                                .chartLineColor!)))),

                                        /// Assign a custom style for the measure axis.
                                        primaryMeasureAxis:
                                            charts.NumericAxisSpec(
                                                renderSpec:
                                                    charts.GridlineRendererSpec(

                                                        // Tick and Label styling here.
                                                        labelStyle: charts
                                                            .TextStyleSpec(
                                                                fontSize: 13,
                                                                // size in Pts.
                                                                color: charts
                                                                        .ColorUtil
                                                                    .fromDartColor(
                                                                        Colors
                                                                            .black)),

                                                        // Change the line colors to match text color.
                                                        lineStyle: charts.LineStyleSpec(
                                                            thickness: 1,
                                                            color: charts
                                                                    .ColorUtil
                                                                .fromDartColor(
                                                                    Constant
                                                                        .chartLineColor!)))),
                                        barGroupingType:
                                            charts.BarGroupingType.grouped,
                                      )
                                    : const Text("No Data Available"))
                          ],
                        )),
                        Visibility(
                            visible:
                                Constants.AUTH_ROLEID != Constants.NHMANAGER,
                            child: CurveOuterBox(boxofWidget: boxes)),
                        Container(
                            padding: EdgeInsets.only(
                                top: Constant.containerWrapper!,
                                left: Constant.containerWrapper!,
                                right: Constant.containerWrapper!),
                            child:
                                StpListOfMenu(listmenuItem: StpModel.stpData))
                        //
                      ],
                    ),
                  )),
              progressBar
            ],
          ),
          // bottomNavigationBar: CustomNavBar(
          //   selectedIndex: 4,
          // )
        )));
  }

  void showCustomFilterDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
            key: _dialogKey,
            builder: (context, setState) {
              return AlertDialog(
                // insetPadding: const EdgeInsets.only(left: 20, right: 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                titlePadding: const EdgeInsets.all(0),
                contentPadding: EdgeInsets.zero,
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Constant.colorOrange,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: Constant.fontSize15,
                          fontWeight: Constant.fontWeight500,
                        )),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Constant.colorWhite,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                content: Container(
                    height: 170,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: getDialogContent()),
                actions: [
                  Row(
                    children: [footerbutton],
                  )
                ],
              );
            });
      },
    );
  }

  Widget getDialogContent() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectFromDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "From Date",
                  labeltxtColor: Constant.textFormFieldColor,
                  labeltxtSize: Constant.textFormFieldSize,
                  labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                  focuBorColor: Constant.textFormFocuBorCol,
                  focuBorWid: Constant.textFormFocuBorWid,
                  enaBorColor: Constant.textFormEnaBorCol,
                  enaBorWid: Constant.textFormEnaBorWid,
                  borderRadiusTL: Constant.textFormborderRadiusTL,
                  borderRadiusBR: Constant.textFormborderRadiusBR,
                  contentPadHor: Constant.textFormcontentPadHor,
                  contentPadHVer: Constant.textFormcontentPadHVer,
                  controllerTxt: _fromdatecontroller,
                  enabled: false,
                  calIcon: true,
                )),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectToDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "To Date",
                  labeltxtColor: Constant.textFormFieldColor,
                  labeltxtSize: Constant.textFormFieldSize,
                  labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                  focuBorColor: Constant.textFormFocuBorCol,
                  focuBorWid: Constant.textFormFocuBorWid,
                  enaBorColor: Constant.textFormEnaBorCol,
                  enaBorWid: Constant.textFormEnaBorWid,
                  borderRadiusTL: Constant.textFormborderRadiusTL,
                  borderRadiusBR: Constant.textFormborderRadiusBR,
                  contentPadHor: Constant.textFormcontentPadHor,
                  contentPadHVer: Constant.textFormcontentPadHVer,
                  controllerTxt: _todatecontroller,
                  enabled: false,
                  calIcon: true,
                )),
          ),
        ],
      ),
      const SizedBox(height: 16),
      BorderBottom(
        bordeSize: 1,
        bottomColor: Colors.black12,
      )
    ]);
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _todatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  Widget dialogActionButtonFilter() {
    var ct = context;
    return SizedBox(
      // width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Cancel",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.saudaLETTxtColor,
              buttonColor: Constant.saudaLETbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Apply",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                fromDate = _fromdatecontroller.text.toString();
                toDate = _todatecontroller.text.toString();
                // BlocProvider.of<PackGroupBloc>(ct).add(LoadPackGroupSalesScreen(
                //     userId: Constants.AUTH_USERID,
                //     fromDate: DateTimeUtils().dateToServerToDateFormat(
                //         _fromdatecontroller.text.toString(),
                //         DateTimeUtils.DD_MM_YYYY_Format,
                //         DateTimeUtils.YYYY_MM_DD_Format),
                //     toDate: DateTimeUtils().dateToServerToDateFormat(
                //         _todatecontroller.text.toString(),
                //         DateTimeUtils.DD_MM_YYYY_Format,
                //         DateTimeUtils.YYYY_MM_DD_Format),
                //     packGroupId: selectedPackGroup == null
                //         ? 0
                //         : selectedPackGroup!.id!));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<SalesTourPlanChartViewDto, String>> _createChartData() {
    return [
      charts.Series<SalesTourPlanChartViewDto, String>(
          id: 'Planned',
          domainFn: (SalesTourPlanChartViewDto sales, _) =>
              sales.plannedVisit.toString(),
          measureFn: (SalesTourPlanChartViewDto sales, _) => sales.plannedVisit,
          data: chartData,
          colorFn: (SalesTourPlanChartViewDto sales, _) =>
              charts.ColorUtil.fromDartColor(Constant.chartBlueColor!)),
      charts.Series<SalesTourPlanChartViewDto, String>(
          id: 'Actual',
          domainFn: (SalesTourPlanChartViewDto sales, _) =>
              sales.actualVisit.toString(),
          measureFn: (SalesTourPlanChartViewDto sales, _) => sales.actualVisit,
          data: chartData,
          colorFn: (SalesTourPlanChartViewDto sales, _) =>
              charts.ColorUtil.fromDartColor(Constant.chartGreenColor!)),
      charts.Series<SalesTourPlanChartViewDto, String>(
          id: 'Deviate',
          domainFn: (SalesTourPlanChartViewDto sales, _) =>
              sales.deviatedVisit.toString(),
          measureFn: (SalesTourPlanChartViewDto sales, _) =>
              sales.deviatedVisit,
          data: chartData,
          colorFn: (SalesTourPlanChartViewDto sales, _) =>
              charts.ColorUtil.fromDartColor(Constant.chartOrangeColor!)),
    ];
  }
}
