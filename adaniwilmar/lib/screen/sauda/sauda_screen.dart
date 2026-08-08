import 'dart:convert';

import 'package:adaniwilmar/config/constant.dart';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/models/overall_response.dart';
import 'package:adaniwilmar/models/pending_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_slab.dart';
import 'package:adaniwilmar/screen/allocation/allocation.dart';
import 'package:adaniwilmar/screen/pending_sauda/bloc/bloc.dart';
import 'package:adaniwilmar/screen/pending_sauda/pending_sauda.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaList/SaudaListScreen.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaModApproval/SaudaModApprovalScreen.dart';
import 'package:adaniwilmar/screen/sauda_modifications/sauda_modification_creation.dart';
import 'package:adaniwilmar/screen/sauda_restrictions/sauda_list/sauda_restriction_screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:logger/logger.dart';

import '../../models/bdo_list_response.dart';
import '../../widget/widget.dart';
import '../discount/sauda_discount.dart';
import '../screen.dart';
import '../state_trader_filter/state_trader_filter.dart';

class SaudaScreen extends StatelessWidget with WidgetsBindingObserver {
  static const String routeName = '/sauda';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const SaudaScreen());
  }

  const SaudaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingSaudaBloc()
        ..add(LoadPendingSaudaChart(userId: Constants.AUTH_USERID, bdoIds: [Constants.AUTH_USERID], dealerIds: const [], creditId: 0, roleId: Constants.AUTH_ROLEID))
        ..add(LoadPendingSaudaList(userId: Constants.AUTH_USERID)),
      child: const SaudaHome(),
    );
  }
}

class SaudaHome extends StatefulWidget {
  const SaudaHome({Key? key}) : super(key: key);

  @override
  State<SaudaHome> createState() => _SaudaHomeState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;

class _SaudaHomeState extends State<SaudaHome> {
  List<PendingSauda> pendingSaudaList = [];
  List<PendingSaudaSlab> saudaSlabs = [];
  List<OverallChartData> chartData = [];
  List<charts.Series<OverallChartData, String>> overallSeriesList = [];
  StateTraderFilterWidget? tradeFilter;
  ProgressBarHandler? _handler;
  BdoList? selectedBdo;
  bool isActive = false;
  var log = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tradeFilter = StateTraderFilterWidget(
      selectedBDO: selectedBdo,
      resultFunction: (var value) {
        selectedBdo = value;
        refreshData();
        setState(() {});
      },
    );
  }


  void refreshData() {
    if (selectedBdo != null && selectedBdo!.id == 0) {
      BlocProvider.of<PendingSaudaBloc>(context)
          .add(LoadPendingSaudaChart(userId: Constants.AUTH_USERID, bdoIds: [Constants.AUTH_USERID], dealerIds: const [], creditId: 0, roleId: Constants.AUTH_ROLEID));
    } else {
      if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
        BlocProvider.of<PendingSaudaBloc>(context).add(LoadPendingSaudaChart(userId: selectedBdo!.id!, bdoIds: [], dealerIds: const [], creditId: 0, roleId: Constants.SALE));
      } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
        BlocProvider.of<PendingSaudaBloc>(context).add(LoadPendingSaudaChart(userId: selectedBdo!.id!, bdoIds: [], dealerIds: const [], creditId: 0, roleId: Constants.ZHMANAGER));
      }
    }
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

    Widget boxOfGraph = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: HeadingSix(headingSix: "Pending", heaingSize: Constant.fontSize14),
        ),
        Visibility(visible: (Constants.AUTH_ROLEID != Constants.SALE), child: tradeFilter != null ? tradeFilter! : const Text("State Trader")),
        SizedBox(
            height: 200,
            width: double.infinity,
            child: overallSeriesList.isNotEmpty
                ? charts.BarChart(
                    overallSeriesList,
                    animate: false,
                    barRendererDecorator: charts.BarLabelDecorator(
                        labelPosition: charts.BarLabelPosition.outside,
                        insideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9),
                        outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.black), fontFamily: 'Aganè', fontSize: 9)),
                    // defaultRenderer: charts.BarRendererConfig(
                    //   maxBarWidthPx: 30,
                    // ),
                    behaviors: const [],
                    selectionModels: [
                      charts.SelectionModelConfig(
                        type: charts.SelectionModelType.info,
                        changedListener: _onSelectionChanged,
                      )
                    ],
                    domainAxis: charts.OrdinalAxisSpec(
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
                : const Text("No Data Available")),
      ],
    );
    return BlocListener<PendingSaudaBloc, PendingSaudaState>(
        listener: (context, state) {
          if (state is OnLoadChartSuccess) {
            pendingSaudaList = state.pendingSauda;
            saudaSlabs = state.pendingSaudaSlabs;
            getSaudaDaysList();
            overallSeriesList = _createChartData();
            setState(() {});
          }
          if (state is GetSaudaBooking) {
            isActive = state.saudaBookingStatus.isActive!;
            setState(() {});
          }

          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        //
        child: FocusDetector(
          onFocusGained: () {
            BlocProvider.of<PendingSaudaBloc>(context).add(GetSaudaCreationStatus(userId: Constants.AUTH_USERID));
          },
          child: SafeArea(
              child: Scaffold(
            primary: false,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(title: "Sauda"),
            floatingActionButton: Visibility(
                visible: ((Constants.AUTH_ROLEID != Constants.NHMANAGER) && isActive),
                child: FloatingButton(
                    buttonBgColor: Constant.colorRed,
                    buttonIcon: Constant.saudaIcPlus,
                    navigationFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewSauduScreen()),
                      );
                    },
                    buttoniconSize: 20)),
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
                          CurveOuterBox(boxofWidget: boxOfGraph),
                          Container(
                            padding: EdgeInsets.only(top: Constant.containerWrapper!, left: Constant.containerWrapper!, right: Constant.containerWrapper!),
                            child: GridView.count(
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 16,
                                childAspectRatio: 01.50,
                                crossAxisCount: 2,
                                children: getRoleMenus()),
                          ),
                        ],
                      ),
                    )),
                progressBar
              ],
            ),
            // bottomNavigationBar: CustomNavBar(
            //   selectedIndex: 2,
            // )
          )),
        ));
  }

  void getSaudaDaysList() {
    chartData.clear();
    for (int i = 0; i < saudaSlabs.length; i++) {
      String slabName = "";
      if (i == 3) {
        slabName = ">" + (saudaSlabs[i].fromValue! - 1).toString();
      } else if (i == 2) {
        slabName = (saudaSlabs[i].fromValue!).toString() + "-" + (saudaSlabs[i].toValue!).toString();
      } else if (i == 1) {
        slabName = (saudaSlabs[i].fromValue!).toString() + "-" + (saudaSlabs[i].toValue!).toString();
      } else {
        slabName = (saudaSlabs[i].fromValue!).toString() + "-" + (saudaSlabs[i].toValue!).toString();
      }
      OverallChartData c1 = OverallChartData(achievement: 0, categoryName: slabName);
      chartData.add(c1);
    }
    for (int i = 0; i < saudaSlabs.length; i++) {
      for (PendingSauda s in pendingSaudaList) {
        if (s.biddingDate != null) {
          int days = daysBetween(DateTimeUtils().stringToDate(s.biddingDate!, DateTimeUtils.YYYY_MM_DD_Format), DateTime.now());
          if (i == 3 && days >= saudaSlabs[i].fromValue!) {
            chartData[3].achievement = chartData[3].achievement! + s.bidQuantity!;
          } else if (i == 2 && days >= saudaSlabs[i].fromValue! && days <= saudaSlabs[i].toValue!) {
            chartData[2].achievement = chartData[2].achievement! + s.bidQuantity!;
          } else if (i == 1 && days >= saudaSlabs[i].fromValue! && days <= saudaSlabs[i].toValue!) {
            chartData[1].achievement = chartData[1].achievement! + s.bidQuantity!;
          } else if (i == 0 && days <= saudaSlabs[i].toValue!) {
            chartData[0].achievement = chartData[0].achievement! + s.bidQuantity!;
          }
        }
      }
    }
    GMLogger.v(jsonEncode(chartData));
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  List<charts.Series<OverallChartData, String>> _createChartData() {
    return [
      charts.Series<OverallChartData, String>(
          id: 'Pending Sauda',
          domainFn: (OverallChartData sales, _) => sales.categoryName!,
          measureFn: (OverallChartData sales, _) => sales.achievement!,
          labelAccessorFn: (OverallChartData sales, _) => Utils().convertToK(sales.achievement!),
          data: chartData,
          colorFn: (OverallChartData sales, _) => charts.ColorUtil.fromDartColor(sales.categoryName == "<21"
              ? Constant.chartGreenColor!
              : sales.categoryName == "21-25"
                  ? Constant.chartBlueColor!
                  : sales.categoryName == "26-30"
                      ? Colors.brown
                      : Constant.chartOrangeColor!))
    ];
  }

  List<Widget> getRoleMenus() {
    List<Widget> menuWidgets = [];
    if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
      menuWidgets.add(InkWell(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SaudaExtensionScreen()),
            );
          },
          child: SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.4,
            child: CurveBoxOptTwo(
              boxHeight: Constant.saudaBoxHeight,
              boxColor: Constant.saudacolor2,
              boxIcon: Constant.sauduImage2,
              subHeading: "Sauda Extension",
              subHeadingFontSize: Constant.fontSize14,
              subhHadingFontWeight: Constant.fontWeight500,
            ),
          )));
    }

    if (Constants.AUTH_ROLEID != Constants.NHMANAGER && Constants.AUTH_ROLEID != Constants.DEALER) {
      menuWidgets.add(InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaudaListScreen()),
          );
        },
        child: CurveBoxOptTwo(
          boxHeight: Constant.saudaBoxHeight,
          boxColor: Constant.saudacolorRestriction,
          boxIcon: Constant.sauduDiscount,
          subHeading: "Sauda Modification",
          subHeadingFontSize: Constant.fontSize15,
          subhHadingFontWeight: Constant.fontWeight500,
        ),
      ));
    }

    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      menuWidgets.add(InkWell(
        onTap: () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaudaApprovalScreen()),
          );
        },
        child: SizedBox(
          height: screenHeight * 0.25,
          width: screenWidth * 0.4,
          child: CurveBoxOptTwo(
            boxHeight: Constant.saudaBoxHeight,
            boxColor: Constant.saudacolor7,
            boxIcon: Constant.sauduImage7,
            subHeading: "Sauda Approval",
            subHeadingFontSize: Constant.fontSize14,
            subhHadingFontWeight: Constant.fontWeight500,
          ),
        ),
      ));
    }

    if (Constants.AUTH_ROLEID == Constants.NHMANAGER || Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      menuWidgets.add(InkWell(
        onTap: () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaudaModApprovalScreen()),
          );
        },
        child: SizedBox(
          height: screenHeight * 0.25,
          width: screenWidth * 0.4,
          child: CurveBoxOptTwo(
            boxHeight: Constant.saudaBoxHeight,
            boxColor: Constant.saudacolor7,
            boxIcon: Constant.sauduImage7,
            subHeading: "Sauda Modification Approval",
            subHeadingFontSize: Constant.fontSize14,
            subhHadingFontWeight: Constant.fontWeight500,
          ),
        ),
      ));
    }

    if(Constants.AUTH_ROLEID != Constants.NHMANAGER){
      menuWidgets.add(InkWell(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SaudaBookedStatusScreen()),
            );
          },
          child: SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.4,
            child: CurveBoxOptTwo(
              boxHeight: Constant.saudaBoxHeight,
              boxColor: Constant.saudacolor3,
              boxIcon: Constant.sauduImage3,
              subHeading: "Booked Sauda",
              subHeadingFontSize: Constant.fontSize14,
              subhHadingFontWeight: Constant.fontWeight500,
            ),
          )));
    }

    if (Constants.AUTH_ROLEID == Constants.SALE) {
      menuWidgets.add(InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SaudaPriceDiscoveryScreen()),
            );
          },
          child: SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.4,
            child: CurveBoxOptTwo(
              boxHeight: Constant.saudaBoxHeight,
              boxColor: Constant.saudacolor4,
              boxIcon: Constant.sauduImage4,
              subHeading: "Price Discovery",
              subHeadingFontSize: Constant.fontSize14,
              subhHadingFontWeight: Constant.fontWeight500,
            ),
          )));
    }
    if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
      menuWidgets.add(InkWell(
          onTap: () {
            // Navigator.pop(context);
            if (Constants.AUTH_ROLEID != Constants.DEALER) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SaudaLimitEnhancementScreen()),
              );
            }
          },
          child: SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.4,
            child: CurveBoxOptTwo(
              boxHeight: Constant.saudaBoxHeight,
              boxColor: Constant.saudacolor5,
              boxIcon: Constant.sauduImage5,
              subHeading: "Limit Enhance",
              subHeadingFontSize: Constant.fontSize14,
              subhHadingFontWeight: Constant.fontWeight500,
            ),
          )));
      menuWidgets.add(InkWell(
          onTap: () {
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SaudaSalesOrderStatusScreen()),
            );
          },
          child: SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.4,
            child: CurveBoxOptTwo(
              boxHeight: Constant.saudaBoxHeight,
              boxColor: Constant.saudacolor6,
              boxIcon: Constant.sauduImage6,
              subHeading: "Sales Order",
              subHeadingFontSize: Constant.fontSize14,
              subhHadingFontWeight: Constant.fontWeight500,
            ),
          )));
    }

    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      menuWidgets.add(InkWell(
        onTap: () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllocationScreen()),
          );
        },
        child: CurveBoxOptTwo(
          boxHeight: Constant.saudaBoxHeight,
          boxColor: Constant.saudacolor5,
          boxIcon: Constant.sauduImage5,
          subHeading: "Allocation",
          subHeadingFontSize: Constant.fontSize15,
          subhHadingFontWeight: Constant.fontWeight500,
        ),
      ));
    }

    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      menuWidgets.add(InkWell(
        onTap: () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiscountScreen()),
          );
        },
        child: CurveBoxOptTwo(
          boxHeight: Constant.saudaBoxHeight,
          boxColor: Constant.saudacolorDiscount,
          boxIcon: Constant.sauduDiscount,
          subHeading: "Sauda Discount",
          subHeadingFontSize: Constant.fontSize15,
          subhHadingFontWeight: Constant.fontWeight500,
        ),
      ));
    }
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      menuWidgets.add(InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaudaRestrictionScreen()),
          );
        },
        child: CurveBoxOptTwo(
          boxHeight: Constant.saudaBoxHeight,
          boxColor: Constant.saudacolorRestriction,
          boxIcon: Constant.sauduDiscount,
          subHeading: "Sauda Restriction",
          subHeadingFontSize: Constant.fontSize15,
          subhHadingFontWeight: Constant.fontWeight500,
        ),
      ));
    }




    return menuWidgets;
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PendingSaudaScreen(
                  categoryName: selectedDatum.first.datum.categoryName,
                )),
      );
    }
  }
}
