import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/booked_sauda_response.dart';
import 'package:adaniwilmar/screen/sauda_booked_status/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/booked_sauda_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaBookedStatusScreen extends StatelessWidget {
  const SaudaBookedStatusScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaBookedStatusScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaBookedStatusBloc()
        ..add(
          LoadSaudaBookedStatusScreen(
              userId: Constants.AUTH_USERID,
              fromDate: DateTimeUtils().dateToStringFormat(
                  DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
              toDate: DateTimeUtils().dateToStringFormat(
                  DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format)),
        ),
      child: const SaudaBookedStatus(),
    );
  }
}

class SaudaBookedStatus extends StatefulWidget {
  // SaudaBookedSaudaWithExtensionDetails sauda;
  const SaudaBookedStatus({Key? key}) : super(key: key);

  @override
  State<SaudaBookedStatus> createState() => _SaudaBookedStatusState();
}

class _SaudaBookedStatusState extends State<SaudaBookedStatus> {
  List<SaudaBookedStatusDealerDetail> saudaDetails = [];
  List<BookedSaudaResponse> dealerSaudaDetails = [];
  String fromDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  ProgressBarHandler? _handler;
  double screenWidth = 0;
  double screenHeight = 0;
  final GlobalKey _dialogKey = GlobalKey();
  BdoList? selectedBdo;
  StateTraderFilterWidget? tradeFilter;

  @override
  void initState() {
    // TODO: implement initState
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        selectedBdo = value;
        BlocProvider.of<SaudaBookedStatusBloc>(context).add(
            LoadSaudaBookedStatusScreen(
                userId: Constants.AUTH_USERID,
                bdoId: selectedBdo!.id!,
                fromDate: DateTimeUtils().dateToServerToDateFormat(
                    fromDate,
                    DateTimeUtils.DD_MM_YYYY_Format,
                    DateTimeUtils.YYYY_MM_DD_Format),
                toDate: DateTimeUtils().dateToServerToDateFormat(
                    toDate,
                    DateTimeUtils.DD_MM_YYYY_Format,
                    DateTimeUtils.YYYY_MM_DD_Format)));
      },
      onLoad: (var value) {},
    );
    super.initState();
  }
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return BlocListener<SaudaBookedStatusBloc, SaudaBookedStatusState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            saudaDetails = state.bookedSaudhas;
            setState(() {});
          }
          if (state is OnDealerLoadSuccess) {
            dealerSaudaDetails = state.bookedSaudhas;
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
              key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Booked Sauda Status",
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
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                      boxofWidget: Column(children: [
                    tradeFilter != null
                        ? tradeFilter!
                        : const Visibility(
                            visible: false, child: Text("State Trade")),
                    Container(
                      height: Constants.AUTH_ROLEID == Constants.ZHMANAGER
                          ? screenHeight * 0.815
                          : screenHeight * 0.865,
                      child:
                          (saudaDetails == null || saudaDetails.length == 0) &&
                                  (dealerSaudaDetails == null ||
                                      dealerSaudaDetails.length == 0)
                              ? Align(
                                  alignment: Alignment.center,
                                  child: CurveOuterBox(
                                      boxTBPadding: 30,
                                      boxofWidget: Text("No records found")))
                              : SaudaBookedStatusWidget(
                                  headFontSz: Constant.fontSize15,
                                  headFontCol: Constant.colorBlack,
                                  headFontWei: Constant.fontWeight600,
                                  subFontSz: Constant.fontSize16,
                                  subFontCol: Constant.colorLightGray,
                                  bookedSaudas: saudaDetails,
                                  dealerSaudaDetails: dealerSaudaDetails,
                                  sbIcon: Constant.sCIcon1,
                                  sbIconColor: Constant.colorOrange,
                                  sbIconSize: Constant.fontSize14),
                    )
                  ]))),
              progressBar
            ],
          ),
        )));
    // return Scaffold(
    //   primary: false,
    //   extendBodyBehindAppBar: true,
    //   backgroundColor: Colors.white,
    //   appBar: const CustomAppBar(title: "Booked Sauda Status", backArrow: true),
    //   body: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       Positioned(
    //         child: Container(
    //           child: Constant.bgImgGlobal,
    //         ),
    //       ),
    //       SingleChildScrollView(
    //           child: Column(
    //         children: [
    //           Container(height: Constant.containerTopWrapper),
    //           CurveOuterBox(
    //               boxofWidget: SaudaWidget(
    //                   headFontSz: Constant.fontSize15,
    //                   headFontCol: Constant.colorBlack,
    //                   headFontWei: Constant.fontWeight600,
    //                   subFontSz: Constant.fontSize12,
    //                   subFontCol: Constant.colorLightGray,
    //                   otherWidget: SaudaBookedStatusWid(),
    //                   //subFontWei: 12,
    //                   sbIcon: Constant.sCIcon1,
    //                   sbIconColor: Constant.colorOrange,
    //                   sbIconSize: Constant.fontSize14)),
    //         ],
    //       ))
    //     ],
    //   ),
    // );
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
                    height: 150,
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
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now());
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      _todatecontroller.text=DateTimeUtils()
          .dateToStringFormat(selected.add(Duration(days:Constants.REPORT_MAX_DAY)), DateTimeUtils.DD_MM_YYYY_Format);

    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _todatecontroller.text.toString() == ""
            ? DateTime.now().add(const Duration(days: Constants.REPORT_MAX_DAY+Constants.REPORT_START_DAY))
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        lastDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now().add(const Duration(days: Constants.REPORT_MAX_DAY))
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _fromdatecontroller.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)).add(const Duration(days: Constants.REPORT_MAX_DAY)),
    );
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
                  calIcon: true,
                  enabled: false,
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
                BlocProvider.of<SaudaBookedStatusBloc>(ct).add(
                    LoadSaudaBookedStatusScreen(
                        userId: Constants.AUTH_USERID,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format)));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
