import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:adaniwilmar/screen/gamificationDashboard/bloc/bloc.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constant.dart';
import '../../models/gamification_model.dart';
import '../../models/gamification_tblview.dart';
import '../../utils/constant.dart';
import '../../widget/widget.dart';

class GamificationDashboardScreen extends StatelessWidget {
  const GamificationDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GamificationDashboardBloc()
        ..add(LoadGamificationDashboardData(
            dealerCode: Constants.AUTH_DEALER_CODE)),
      // ..add(LoadOverallData(userId: Constants.AUTH_USERID, dealerId: 0, statusId: 1))
      child: const GamificationDashboardData(),
    );
  }
}

class GamificationDashboardData extends StatefulWidget {
  const GamificationDashboardData({Key? key}) : super(key: key);

  @override
  State<GamificationDashboardData> createState() =>
      _GamificationDashboardDataState();
}

class _GamificationDashboardDataState extends State<GamificationDashboardData> {
  int selected = 0 - 1;
  List<SecondarySalesFortheDayViewDto> secondarySalesList = [];
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool isRural = false;
  bool iSROIUrban = false;
  bool isDiamondActive = false;

  List<GamificationDynamicModel> dynamicValues = [];
  List<GamificationDynamicModel> dynamicListValues = [];

  @override
  Widget build(BuildContext context) {
    final EmployeeDataSource _roiUrban = EmployeeDataSource(productCategory: [
      ProductCategory(
          "All Oils including Vanaspati", "6", "3", "4", "3", "-", "-"),
      ProductCategory("Olien Raag/Alpha", "-", "-", "2", "2", "-", "-"),
      ProductCategory(
          "All Foods CP + Rice (CP+BP)", "6", "-", "-", "-", "3*", "-"),
      ProductCategory("NBR", "4", "-", "-", "-", "2", "-"),
      ProductCategory(
          "Any New Product in F&F CP", "6", "-", "-", "-", "3", "-"),
      ProductCategory("Bakery Premium", "-", "-", "-", "-", "-", "8"),
      ProductCategory("Bakery Popular", "-", "-", "-", "-", "-", "3"),
      ProductCategory("Fryola", "-", "-", "-", "-", "-", "3"),
      ProductCategory("Lauric", "-", "-", "-", "-", "-", "8"),
    ]);

    final EmployeeDataSource _rual = EmployeeDataSource(productCategory: [
      ProductCategory(
          "All Oils including Vanaspati", "8", "3", "4", "3", "-", "-"),
      ProductCategory("Olien Raag/Alpha", "-", "-", "2", "2", "-", "-"),
      ProductCategory(
          "All Foods CP + Rice (CP+BP)", "8", "-", "-", "-", "4*", "-"),
      ProductCategory("NBR", "4", "-", "-", "-", "2", "-"),
      ProductCategory(
          "Any New Product in F&F CP", "6", "-", "-", "-", "3", "-"),
      ProductCategory("Bakery Premium", "-", "-", "-", "-", "-", "8"),
      ProductCategory("Bakery Popular", "-", "-", "-", "-", "-", "3"),
      ProductCategory("Fryola", "-", "-", "-", "-", "-", "3"),
      ProductCategory("Lauric", "-", "-", "-", "-", "-", "8"),
    ]);

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
    return BlocListener<GamificationDashboardBloc, GamificationDashboardState>(
        listener: (context, state) {
          if (state is OnLoadGamificationDashboardDataSuccess) {
            if (state.response.labelListDto != null) {
              List<LabelListDto>? labelListDto =
                  state.response.labelListDto ?? [];
              if (labelListDto.isNotEmpty) {
                List<GamificationDynamicModel>? dynamicValue =
                    labelListDto[0].dynamicValues ?? [];
                if (dynamicValue.isNotEmpty) {
                  dynamicValues = dynamicValue;
                }
                if (labelListDto[0].dynamicListValues!.isNotEmpty) {
                  dynamicListValues = labelListDto[0].dynamicListValues!;
                }
              }
            }

            if (state.response.gamificationDashboardDto != null) {
              List<GamificationDashboardDto>? gamificationDashboard =
                  state.response.gamificationDashboardDto ?? [];
              if (gamificationDashboard.isNotEmpty) {
                isDiamondActive = gamificationDashboard[0].isDiamond ?? false;
              }
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
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Udaan Dashboard",
            backArrow: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                Container(
                  height: screenHeight,
                  margin: const EdgeInsets.only(top: 64),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: CurveOuterBox(
                        boxLRPadding: 0,
                        boxTBPadding: 0,
                        boxofWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(5)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Color(0xffFFF3D5),
                                    Color(0xffFFEFF0)
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, top: 16),
                                            child: Text(
                                              "Distributor Name",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff757575),
                                                  fontFamily: 'Aganè'),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, top: 7, bottom: 10),
                                            child: Text(
                                              Constants.AUTH_USER_NAME,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontFamily: 'Aganè'),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: isDiamondActive,
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                        "assets/images/diamond.gif",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dynamicValues.isNotEmpty
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: Constant.containerWrapper!,
                                            right: Constant.containerWrapper!),
                                        child: GridView.count(
                                            padding: const EdgeInsets.all(0),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            crossAxisSpacing: 20,
                                            crossAxisCount: 2,
                                            childAspectRatio: 2.7,
                                            children: getDynamicFields()))
                                    : const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Center(
                                          child: Text(
                                            "No Data Found",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )),
                              ],
                            ),
                            Visibility(
                              visible: dynamicListValues.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Constant.containerWrapper!,
                                    right: Constant.containerWrapper!),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: getDynamicListItem()),
                              ),
                            ),

                            // Commented due to client requirement
                           /* const Padding(
                              padding: EdgeInsets.only(bottom: 2, top: 8),
                              child: DashLineView(
                                fillRate: 0.7,
                                dashColor: Colors.grey,
                              ),
                            ),*/
                            /* const Padding(
                                padding: EdgeInsets.only(
                                    left: 12, top: 18, right: 5, bottom: 10),
                                child: Text(
                                  "Point Structure",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Aganè',
                                      fontWeight: FontWeight.w600),
                                )),
                            CurveOuterBox(
                                boxLRPadding: 0,
                                boxTBPadding: 0,
                                boxofWidget: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isRural = !isRural;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isRural = !isRural;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              "Rural/South/MP/Mah",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    child: Icon(
                                                      isRural
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color:
                                                          Constant.colorBlack,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        isRural = !isRural;
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  isRural = !isRural;
                                                });
                                              },
                                            ),
                                            Visibility(
                                                visible: isRural,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    // SizedBox(height: 500, child: tbView(_rual))
                                                    tbView(_rual)
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CurveOuterBox(
                                boxLRPadding: 0,
                                boxTBPadding: 0,
                                boxofWidget: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            iSROIUrban = !iSROIUrban;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        iSROIUrban =
                                                            !iSROIUrban;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: "ROI Urban",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    child: Icon(
                                                      iSROIUrban
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color:
                                                          Constant.colorBlack,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        iSROIUrban =
                                                            !iSROIUrban;
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  iSROIUrban = !iSROIUrban;
                                                });
                                              },
                                            ),
                                            Visibility(
                                                visible: iSROIUrban,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    //  tbView(_roiUrban)
                                                    //SizedBox(height: 500, child: tbView(_roiUrban))
                                                    tbView(_roiUrban)
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),*/
                          ],
                        )),
                  ),
                ),
                progressBar
              ],
            ),
          ),
        ));
  }

  List<Widget> getDynamicFields() {
    List<Widget> menuWidgets = [];
    for (int i = 0; i < dynamicValues.length; i++) {
      menuWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10, right: 5),
                  child: Text(
                    dynamicValues[i].label ?? "",
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff757575),
                        fontFamily: 'Aganè'),
                  )),
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 5),
                    child: Text(
                      dynamicValues[i].label!.contains('Total')
                          ? "₹ ${dynamicValues[i].value ?? ""}"
                          : dynamicValues[i].value ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: dynamicValues[i].label == "Points Earned"
                              ? const Color(0xff00974C)
                              : Colors.black,
                          fontFamily: 'Aganè',
                          fontWeight: FontWeight.w600),
                    ))),
          ],
        ),
      );
    }
    return menuWidgets;
  }

  List<Widget> getDynamicListItem() {
    List<Widget> menuWidgets = [];
    for (int i = 0; i < dynamicListValues.length; i++) {
      bool isHypeText = false;
      String value = dynamicListValues[i].value ?? "";
      if (value.isNotEmpty) {
        isHypeText = isValidUrl(value);
      }
      menuWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 12, top: 10, right: 5),
                child: Text(
                  dynamicListValues[i].label ?? "",
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff757575),
                      fontFamily: 'Aganè'),
                )),
            isHypeText
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, top: 0, bottom: 0),
                    child: TextButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(value);
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: Text(value),
                    ))
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 15, bottom: 10),
                    child: Text(
                      dynamicListValues[i].value ?? "",
                      style: TextStyle(
                          fontSize: 14,
                          color: dynamicListValues[i].label == "Points Earned"
                              ? const Color(0xff00974C)
                              : Colors.black,
                          fontFamily: 'Aganè',
                          fontWeight: FontWeight.w600),
                    )),
          ],
        ),
      );
    }
    return menuWidgets;
    // }
  }

  _launchURL(String value) async {
    final Uri url = Uri.parse('$value');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  bool isValidUrl(String url) {
    try {
      // Try to parse the string as a URI
      final uri = Uri.parse(url);
      // Check if the scheme is valid (e.g., http, https)
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      // If parsing fails, it's not a valid URL
      return false;
    }
  }

  Widget tbView(DataGridSource source) {
    double productNameWidth = 125;
    double clWidth = screenWidth - productNameWidth;
    clWidth = clWidth - 50;
    clWidth = clWidth / 6;

    return Padding(
      padding: const EdgeInsets.only(right: 0, left: 4),
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
            gridLineStrokeWidth: 0,
            gridLineColor: const Color(0xff9E9E9E),
            frozenPaneLineColor: const Color(0xff9E9E9E),
            frozenPaneElevation: 0.0,
            frozenPaneLineWidth: 0.0),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(scrollbars: false),
          child: SfDataGrid(
              showVerticalScrollbar: false,
              showHorizontalScrollbar: false,
              gridLinesVisibility: GridLinesVisibility.both,
              source: source,
              columns: <GridColumn>[
                GridColumn(
                  columnName: "productName",
                  width: productNameWidth,
                  label: Container(
                    color: const Color(0xffDBEBFF),
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const Text('Product Category',
                        overflow: TextOverflow.visible),
                  ),
                ),
                GridColumn(
                  width: clWidth,
                  columnName: 'line1',
                  label: Container(
                    color: const Color(0xffFFE29E),
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                        quarterTurns: -1,
                        child: Text('Line 1',
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
                GridColumn(
                  width: clWidth,
                  columnName: 'L2',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xffFFE29E),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                      quarterTurns: -1,
                      child: Text('L2',
                          style: TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
                GridColumn(
                  width: clWidth,
                  columnName: 'L3',
                  label: Container(
                    color: const Color(0xffFFE29E),
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                        quarterTurns: -1,
                        child: Text('L3',
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
                GridColumn(
                  width: clWidth,
                  columnName: 'l3B',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xffFFE29E),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                        quarterTurns: -1,
                        child: Text('L3B',
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
                GridColumn(
                  width: clWidth,
                  columnName: 'foodBP',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xffFFE29E),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                        quarterTurns: -1,
                        child: Text('Food BP',
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
                GridColumn(
                  columnWidthMode: ColumnWidthMode.lastColumnFill,
                  width: clWidth,
                  columnName: 'bakery',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xffFFE29E),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                        quarterTurns: -1,
                        child: Text('Bakery',
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

/*  Widget tableDraw() {
    return Container(
        child: Row(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.yellow),
          height: 120,
          width: 120,
          child: Text('Initial Data'),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                height: 120,
                width: 120,
                child: Text('Initial Data'),
              ),
              const Divider(
                thickness: 1,
                // color: Colors.grey,
              ),
            ],
          ),
        )
      ],
    ));
  }*/
}

class DashLineView extends StatelessWidget {
  final double dashHeight;
  final double dashWith;
  final Color dashColor;
  final double fillRate; // [0, 1] totalDashSpace/totalSpace
  final Axis direction;

  const DashLineView(
      {Key? key,
      this.dashHeight = 1,
      this.dashWith = 8,
      this.dashColor = Colors.black,
      this.fillRate = 0.5,
      this.direction = Axis.horizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dCount = (boxSize * fillRate / dashWith).floor();
        return Flex(
          children: List.generate(dCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWith : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWith,
              child: DecoratedBox(
                decoration: BoxDecoration(color: dashColor),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
        );
      },
    );
  }
}
