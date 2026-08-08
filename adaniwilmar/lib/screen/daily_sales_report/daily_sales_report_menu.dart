import 'package:adaniwilmar/screen/daily_sales_report/bloc/bloc.dart';
import 'package:adaniwilmar/screen/daily_sales_report/dealer_visit.dart';
import 'package:adaniwilmar/screen/daily_sales_report/perspective_dealer_visit.dart';
import 'package:adaniwilmar/screen/daily_sales_report/wholesaler_visit.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class DailySalesReportMenuScreen extends StatelessWidget {
  int dealerId;
  int id;
  int mtpId;
  DailySalesReportMenuScreen({required this.dealerId,required this.id,required this.mtpId,Key? key}) : super(key: key);
  static const String routeName = '/stp';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => DailySalesReportMenuScreen(dealerId: 0,mtpId: 0,id: 0,));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailySalesReportBloc(),
      child: DailySalesReportMenu(dealerId: dealerId,id: id,mtpId: mtpId,),
    );
  }
}

class DailySalesReportMenu extends StatefulWidget {
  int dealerId;
  int id;
  int mtpId;

  DailySalesReportMenu({required this.dealerId,required this.id,required this.mtpId,Key? key}) : super(key: key);

  @override
  State<DailySalesReportMenu> createState() => _DailySalesReportMenuScreenState();
}

class _DailySalesReportMenuScreenState extends State<DailySalesReportMenu> {
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
  final TextEditingController _remarkscontroller = TextEditingController();
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
    return BlocListener<DailySalesReportBloc, DailySalesReportState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
          if (state is OnSavePriceDiscovery) {
            showSuccessDlg(context, "Dealer Visit", "Success",
                successText: state.response);
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Today Activities",
            backArrow: true,
            listOfActions: Row(
              children: [
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
                height: screenHeight,
                width: screenWidth,
                margin: EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Container(
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DealerVisitScreen(
                                                  dealerId: widget.dealerId,
                                                  id:widget.id,
                                                  mtpId: widget.mtpId,
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 20,
                                                color: Constant.callToCcolor1,
                                                margin:
                                                const EdgeInsets.only(top: 3),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText(
                                                        name: "Dealer Visit",
                                                        fontSize: Constant.fontSize13,
                                                        fontColor: Constant.colorBlack,
                                                        fontWeight:
                                                        Constant.fontWeight500,
                                                      ),
                                                    ],
                                                  )),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 24,
                                                  color: Constant.colorGray45,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WholesalerVisitScreen(
                                                  dealerId: widget.dealerId,
                                                  id:widget.id,
                                                  mtpId: widget.mtpId,
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText(
                                                        name: "Wholesaler Visit",
                                                        fontSize: Constant.fontSize13,
                                                        fontColor: Constant.colorBlack,
                                                        fontWeight: Constant.fontWeight500,
                                                      ),
                                                    ],
                                                  )),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 24,
                                                  color: Constant.colorGray45,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PerspectiveDealerVisitScreen(
                                                  dealerId: widget.dealerId,
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      CommonText(
                                                        name: "Perspective Dealer Visit",
                                                        fontSize: Constant.fontSize13,
                                                        fontColor: Constant.colorBlack,
                                                        fontWeight: Constant.fontWeight500,
                                                      ),
                                                    ],
                                                  )),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 24,
                                                  color: Constant.colorGray45,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CommonTextFormField(
                                  maxLine: 4,
                                  labeltxt: "Remarks",
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
                                  controllerTxt: _remarkscontroller,
                                ),
                              ],
                            ))
                      ],
                    )),
              ),
              progressBar
            ],
          ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonButton(
                    buttonName: "Submit",
                    buttonNameSize: Constant.pricbuttonNameSize,
                    buttonNameColor: Constant.pricbuttonTxtColor,
                    buttonColor: Constant.pricbuttonColor,
                    buttonHeight: Constant.pricbuttonHeight,
                    buttonRadiusTL: Constant.pricbuttonRadiusTL,
                    buttonRadiusBL: Constant.pricbutRadiusBL,
                    buttonBorder: Colors.transparent,
                    buttonFunction: () {
                      if(_remarkscontroller.text.toString()==""){
                        showSuccessDlg(context, "Error", "Error",
                            successText:
                            "Enter Remarks");
                        return;
                      }
                      BlocProvider.of<DailySalesReportBloc>(context)
                          .add(SubmitDailySalesReport(userId: Constants.AUTH_USERID,mtpId: widget.id,remarks: _remarkscontroller.text.toString()));
                    },
                  ),
                )
          // bottomNavigationBar: CustomNavBar(
          //   selectedIndex: 4,
          // )
        )));
  }
  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white,
        bool? closeScreen = false}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      // title: Container(
      //   decoration: BoxDecoration(
      //     color: Constant.colorOrange,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(25.0),
      //       topRight: Radius.circular(5.0),
      //       bottomLeft: Radius.circular(0.0),
      //       bottomRight: Radius.circular(0.0),
      //     ),
      //   ),
      //   padding: const EdgeInsets.only(top: 12, bottom: 12),
      //   child: Text(title,
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         color: titleColor,
      //       )),
      // ),
      content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error"
                        ? Icon(Icons.error_outlined,
                        size: 70, color: Colors.red)
                        : Icon(Icons.check_circle_sharp,
                        size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title,
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  SizedBox(height: 20),
                  BorderBottom(bordeSize: 1)
                ],
              ),
            ]),
          ])),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
                buttonName: "Ok",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  Navigator.pop(context);
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  // Navigator.pop(context);
                })
          ],
        )
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return alert;
          });
        });
  }
}
