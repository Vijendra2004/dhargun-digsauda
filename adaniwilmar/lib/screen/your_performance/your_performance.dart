import 'package:adaniwilmar/models/your_sales_performance_response.dart';
import 'package:adaniwilmar/screen/your_performance/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class YourPerformanceScreen extends StatelessWidget {
  const YourPerformanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => YourPerformanceBloc()
        ..add(LoadYourPerformanceScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now()
                    .add(const Duration(days: Constants.REPORT_START_DAY)),
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            roleId: Constants.AUTH_ROLEID,
            isShowDealer: false)),
      child: const YourPerformanceDetail(),
    );
  }
}

class YourPerformanceDetail extends StatefulWidget {
  const YourPerformanceDetail({Key? key}) : super(key: key);

  @override
  State<YourPerformanceDetail> createState() => _YourPerformanceState();
}

class _YourPerformanceState extends State<YourPerformanceDetail> {
  String fromDate = DateTimeUtils().dateToStringFormat(
      DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)),
      DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;
  final GlobalKey _dialogKey = GlobalKey();
  YourSalesPerformance performance = YourSalesPerformance();
  List<YourSalesPerformance> rankingList = [];
  double targetPercentage = 0;
  double achievedPercentage = 0;
  ProgressBarHandler? _handler;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    _fromdatecontroller.text = fromDate;
    _todatecontroller.text = toDate;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<YourPerformanceBloc, YourPerformanceState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            performance = state.salesPerformance;
            targetPercentage = 1;
            if (performance.userTarget! > 0) {
              achievedPercentage =
                  performance.userAchievment! / (performance.userTarget!);
            }else{
              achievedPercentage=100;
            }
            rankingList = state.rankingList;
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
            title: "Your Performance",
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
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  height: screenHeight * 0.98,
                  width: screenWidth,
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: Column(
                    children: [
                      CurveBorderBox(
                        boxofWidget: Container(
                          height: screenHeight * 0.98,
                          width: screenWidth,
                          margin: const EdgeInsets.only(left: 0, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sales Person Name",
                                          style: TextStyle(
                                            fontSize: Constant.fontSize12,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          performance.username ?? "",
                                          style: TextStyle(
                                              fontSize: Constant.fontSize13,
                                              color: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight600),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sales Person ID",
                                          style: TextStyle(
                                            fontSize: Constant.fontSize12,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          performance.usercode ?? "",
                                          style: TextStyle(
                                              fontSize: Constant.fontSize13,
                                              color: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8,left:8),
                                //  height: screenHeight * 0.30,
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xFFDEDEDE)),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth,
                                        height: screenHeight * 0.12,
                                        decoration: const BoxDecoration(
                                          // color: Color(0xFFFFF5E0),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(5.0),
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(0.0),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              width: screenWidth,
                                              // height: screenHeight * 0.10,
                                              child: Image.asset(
                                                "assets/images/performance_bg.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12, right: 20),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Your Performance",
                                                        style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize13,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Text(
                                                        performance.userAchievment ==
                                                                null
                                                            ? ""
                                                            : performance
                                                                .userAchievment!
                                                                .toStringAsFixed(
                                                                    2)+" MT",
                                                        style: TextStyle(
                                                            fontSize: Constant
                                                                .fontSize22,
                                                            color: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight600),
                                                      ),
                                                    ]),
                                              ),
                                            )
                                          ],
                                        )),
                                    Container(
                                      color: Constant.colorWhite,
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24, top: 24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              name: "Target",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                            Container(
                                                // margin: EdgeInsets.symmetric(vertical: 20),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.55,
                                                height: 5,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    child: LinearProgressIndicator(
                                                  value: targetPercentage,
                                                  color: Colors.orangeAccent,
                                                  backgroundColor: Colors.grey,
                                                ))),
                                            const SizedBox(width: 4),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: CommonText(
                                                    name: performance
                                                                .userTarget !=
                                                            null
                                                        ? performance
                                                            .userTarget!
                                                            .toStringAsFixed(2)+" MT "
                                                        : "",
                                                    fontSize:
                                                        Constant.fontSize12,
                                                    fontColor:
                                                        Constant.colorBlack,
                                                    fontWeight:
                                                        Constant.fontWeight500))
                                          ]),
                                          const SizedBox(height: 12),
                                          CommonText(
                                              name: "Achieved",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                          const SizedBox(height: 12),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                             Container(
                                                  // margin: EdgeInsets.symmetric(vertical: 20),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.55,
                                                  height: 5,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    child: LinearProgressIndicator(
                                                value: achievedPercentage,
                                                color: Constant.saudacolor2,
                                                backgroundColor: Colors.grey,
                                              ))),

                                            const SizedBox(width: 4),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: CommonText(
                                                    name: performance
                                                                .userAchievment !=
                                                            null
                                                        ? performance
                                                            .userAchievment!
                                                            .toStringAsFixed(2)+" MT"
                                                        : "",
                                                    fontSize:
                                                        Constant.fontSize12,
                                                    fontColor:
                                                        Constant.colorBlack,
                                                    fontWeight:
                                                        Constant.fontWeight500))
                                          ]),
                                        ],
                                      ),
                                    ),
                                    // const SizedBox(height: 12.0)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(children:[
                                Container(
                                  width: 3,
                                  height: 22,
                                  color: Constant.callToCcolor1,
                                  margin:
                                  const EdgeInsets.only(top: 3,left:0),
                                ),
                                SizedBox(width: 10,),
                                Padding(
                                  padding: EdgeInsets.only(top:5),
                                    child:Text(
                                "Ranking List",
                                style: TextStyle(
                                    fontSize: Constant.fontSize16,
                                    color: Constant.colorBlack,
                                    fontWeight: Constant.fontWeight600),
                              ))]),
                              const SizedBox(height: 8.0),
                              Container(
                                  margin: const EdgeInsets.only(left:8),
                                padding: EdgeInsets.zero,
                                width: screenWidth,
                                height: screenHeight * 0.45,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xFFDEDEDE)),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                                child: ListView.builder(
                                    key: const Key('builder1'), //attention
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: rankingList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Constants.AUTH_USERID == rankingList[index].userId
                                                  ? Colors.grey[400]
                                                  : Colors.white,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(25.0),
                                                topRight: Radius.circular(5.0),
                                                bottomLeft:
                                                    Radius.circular(5.0),
                                                bottomRight:
                                                    Radius.circular(25.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10),
                                            child: Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 14,
                                                  backgroundImage: AssetImage(
                                                      "assets/images/user_ic.png"),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Expanded(
                                                    child: CommonText(
                                                        name: rankingList[index]
                                                                .username!,
                                                        fontSize:
                                                            Constant.fontSize13,
                                                        fontColor: Constant
                                                            .colorBlack)),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: CommonText(
                                                      name: "#" +
                                                          rankingList[index]
                                                              .rank!
                                                              .toString(),
                                                      fontSize:
                                                          Constant.fontSize13,
                                                      fontColor:
                                                          Constant.colorBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              progressBar
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
                      constraints: const BoxConstraints(),
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
                  labeltxt: "To",
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
      const BorderBottom(bordeSize: 1, bottomColor: Colors.black12),
      const SizedBox(height: 10),
    ]);
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
                BlocProvider.of<YourPerformanceBloc>(ct).add(
                    LoadYourPerformanceScreen(
                        userId: Constants.AUTH_USERID,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        roleId: Constants.AUTH_ROLEID,
                        isShowDealer: false));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
