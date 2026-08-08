import 'package:adaniwilmar/models/support_list_response.dart';
import 'package:adaniwilmar/screen/support/bloc/bloc.dart';
import 'package:adaniwilmar/screen/support/new_support_form.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SupportScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()
        ..add(LoadSupportScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now().add(Duration(days: Constants.REPORT_START_DAY)),
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            raisedBy: 5,
            queryFrom: 2,
            statusId: 1)),
      child: Support(),
    );
  }
}

class Support extends StatefulWidget {
  Support({Key? key}) : super(key: key);
  int? selectedDiscountType = 1;
  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  List<SupportList> supportList = [];
  TextEditingController _fromdatecontroller = new TextEditingController();
  TextEditingController _todatecontroller = new TextEditingController();
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  String fromDate = DateTimeUtils().dateToStringFormat(
      DateTime.now().add(Duration(days: -30)), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final GlobalKey _dialogKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    _fromdatecontroller.text = fromDate;
    _todatecontroller.text = toDate;
    return BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            supportList = state.supportData;
            setState(() {});
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Support",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showCustomFilterDialog(context, "Filter", "Filter",
                        dialogActionButtonFilter());
                  },
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(7),
                      child: Constant.filterIc,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingButton(
              buttonBgColor: Constant.colorRed,
              buttonIcon: Constant.saudaIcPlus,
              navigationFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewSupportScreen()),
                );
              },
              buttoniconSize: 20),
          body: Stack(
            // overflow: Overflow.visible,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  height: screenHeight,
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.980,
                        width: screenWidth,
                        child: CurveBorderBox(
                          boxofWidget: Column(
                            children: [
                              CurveBorderBox(
                                  boxLRPadding: 0,
                                  boxBgColor: const Color(0xFFFFFBF7),
                                  boxShadowColor: const Color(0xFFFFFFFF),
                                  boxofWidget: Container(
                                      padding: const EdgeInsets.only(
                                          top: 14, left: 8, right: 8),
                                      height: screenHeight * 0.08,
                                      width: screenWidth,
                                      child: CommonText(
                                        name: "Support status report as on " +
                                            toDate,
                                        fontSize: Constant.fontSize12,
                                        fontColor: Constant.colorBlack,
                                        fontWeight: Constant.fontWeight400,
                                      ))),
                              SizedBox(
                                height: screenHeight * 0.880,
                                width: screenWidth,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                      key: Key('builder 1'), //attention
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: supportList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Color(0xFFDEDEDE)),
                                                  borderRadius:
                                                      const BorderRadius.only(
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
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12,
                                                                  right: 12,
                                                                  top: 14,
                                                                  bottom: 14),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFF5F5F5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      25.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          0.0),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Issue ID : " +
                                                                          supportList[index]
                                                                              .id
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          fontSize: Constant
                                                                              .fontSize13,
                                                                          color: Constant
                                                                              .colorBlack,
                                                                          fontWeight:
                                                                              Constant.fontWeight600),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    child:
                                                                        CommonLabel(
                                                                      labelRadiusBig:
                                                                          3,
                                                                      bgColor:
                                                                          Constant
                                                                              .colorLightGreen,
                                                                      name: supportList[
                                                                              index]
                                                                          .status,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorWhite,
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize10,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                            ],
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              left: 12,
                                                              right: 12,
                                                              bottom: 12),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 3),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            decoration: const BoxDecoration(
                                                                border: Border(
                                                                    bottom: BorderSide(
                                                                        color: Color(
                                                                            0xFFBDBDBD),
                                                                        width:
                                                                            0.8))),
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 12),
                                                            child: CommonText(
                                                              name: supportList[
                                                                          index]
                                                                      .feature! +
                                                                  " " +
                                                                  supportList[
                                                                          index]
                                                                      .component!,
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CommonText(
                                                                        name:
                                                                            "Impact",
                                                                        fontSize:
                                                                            Constant.fontSize12,
                                                                        fontColor:
                                                                            Constant.colorDullGray77,
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              6.0),
                                                                      CommonText(
                                                                        name: supportList[index]
                                                                            .impact!,
                                                                        fontSize:
                                                                            Constant.fontSize12,
                                                                        fontColor:
                                                                            Constant.colorBlack,
                                                                        fontWeight:
                                                                            Constant.fontWeight500,
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
                                              const SizedBox(height: 16.0),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      )
                    ],
                  )))
            ],
          ),
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
        double finalRate = 0;
        double rate = 0;
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
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
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

  Widget dialogActionButtonFilter() {
    var ct = context;
    return SizedBox(
      // width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(width: 9),
          Container(
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
          Container(
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
                BlocProvider.of<SupportBloc>(ct).add(LoadSupportScreen(
                    userId: Constants.AUTH_USERID,
                    fromDate: DateTimeUtils().dateToServerToDateFormat(
                        _fromdatecontroller.text.toString(),
                        DateTimeUtils.DD_MM_YYYY_Format,
                        DateTimeUtils.YYYY_MM_DD_Format),
                    toDate: DateTimeUtils().dateToServerToDateFormat(
                        _todatecontroller.text.toString(),
                        DateTimeUtils.DD_MM_YYYY_Format,
                        DateTimeUtils.YYYY_MM_DD_Format),
                    queryFrom: 5,
                    raisedBy: 2,
                    statusId: 1));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget getDialogContent() {
  //   var ctx = context;
  //   return Column(mainAxisSize: MainAxisSize.min, children: [
  //     Row(
  //       children: [
  //         Expanded(
  //           child: InkWell(
  //               onTap: () {
  //                 _selectFromDate(context);
  //               },
  //               child: CommonTextFormField(
  //                 labeltxt: "From",
  //                 labeltxtColor: Constant.textFormFieldColor,
  //                 labeltxtSize: Constant.textFormFieldSize,
  //                 labeltxtFontWeight: Constant.textFormFieldSizeFontW,
  //                 focuBorColor: Constant.textFormFocuBorCol,
  //                 focuBorWid: Constant.textFormFocuBorWid,
  //                 enaBorColor: Constant.textFormEnaBorCol,
  //                 enaBorWid: Constant.textFormEnaBorWid,
  //                 borderRadiusTL: Constant.textFormborderRadiusTL,
  //                 borderRadiusBR: Constant.textFormborderRadiusBR,
  //                 contentPadHor: Constant.textFormcontentPadHor,
  //                 contentPadHVer: Constant.textFormcontentPadHVer,
  //                 controllerTxt: _fromdatecontroller,
  //                 enabled: false,
  //                 calIcon: true,
  //               )),
  //         ),
  //         SizedBox(width: 16.0),
  //         Expanded(
  //           child: InkWell(
  //               onTap: () {
  //                 _selectToDate(context);
  //               },
  //               child: CommonTextFormField(
  //                 labeltxt: "To",
  //                 labeltxtColor: Constant.textFormFieldColor,
  //                 labeltxtSize: Constant.textFormFieldSize,
  //                 labeltxtFontWeight: Constant.textFormFieldSizeFontW,
  //                 focuBorColor: Constant.textFormFocuBorCol,
  //                 focuBorWid: Constant.textFormFocuBorWid,
  //                 enaBorColor: Constant.textFormEnaBorCol,
  //                 enaBorWid: Constant.textFormEnaBorWid,
  //                 borderRadiusTL: Constant.textFormborderRadiusTL,
  //                 borderRadiusBR: Constant.textFormborderRadiusBR,
  //                 contentPadHor: Constant.textFormcontentPadHor,
  //                 contentPadHVer: Constant.textFormcontentPadHVer,
  //                 controllerTxt: _todatecontroller,
  //                 enabled: false,
  //                 calIcon: true,
  //               )),
  //         ),
  //       ],
  //     ),
  //     const SizedBox(height: 16),
  //     BorderBottom(bottomColor: Colors.black12, bordeSize: 1)
  //   ]);
  // }
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
        firstDate: DateTime.now().add(Duration(days: -365)),
        lastDate: DateTime.now());
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
        firstDate: _todatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        lastDate: DateTime.now());
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }
}
