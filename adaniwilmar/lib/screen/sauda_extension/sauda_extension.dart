import 'package:adaniwilmar/models/sauda_extension_list.dart';
import 'package:adaniwilmar/screen/sauda_extension/bloc/bloc.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaExtensionScreen extends StatelessWidget {
  const SaudaExtensionScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const SaudaExtensionScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaExtensionBloc()
        ..add(LoadSaudaExtensionScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format))),
      child: const SaudaExtension(),
    );
  }
}

class SaudaExtension extends StatefulWidget {
  const SaudaExtension({Key? key}) : super(key: key);

  @override
  State<SaudaExtension> createState() => _SaudaExtensionState();
}

class _SaudaExtensionState extends State<SaudaExtension> with TickerProviderStateMixin {
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;

  BookedSaudha saudaDetails = BookedSaudha(pendingList: [], approvedList: []);
  DealerBookedSaudha dealerSaudaDetails = DealerBookedSaudha(pendingList: [], approvedList: []);
  int pendingCount = 0;
  int approvedCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      _handleTabNavigation();
    });
    indicatorColor = colors[0];
  }

  void _handleTabNavigation() {
    setState(() {});
  }

  String fromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  final GlobalKey _dialogKey = GlobalKey();
  ProgressBarHandler? _handler;

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
    return BlocListener<SaudaExtensionBloc, SaudaExtensionState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            saudaDetails = state.bookedSaudha;
            pendingCount = state.bookedSaudha.pendingList!.length;
            approvedCount = state.bookedSaudha.approvedList!.length;
            setState(() {});
          }
          if (state is OnDealerLoadSuccess) {
            dealerSaudaDetails = state.bookedSaudha;
            pendingCount = state.bookedSaudha.pendingList!.length;
            approvedCount = state.bookedSaudha.approvedList!.length;
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
            title: "Sauda Extension",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showCustomFilterDialog(context, "Filter Date", "Filter Date", dialogActionButtonFilter());
                  },
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
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
              Container(height: screenHeight * 0.980, margin: EdgeInsets.only(top: 60, left: 8, right: 8), child: CurveBorderBox(boxLRPadding: 0, boxofWidget: tabmenuOfExt())),
              progressBar
            ],
          ),
          floatingActionButton: Visibility(
              visible: Constants.AUTH_ROLEID != Constants.DEALER,
              child: FloatingButton(
                  buttonBgColor: Constant.colorRed,
                  buttonIcon: Constant.saudaIcPlus,
                  navigationFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SaudaExtensionDetailScreen()),
                    );
                  },
                  buttoniconSize: 20)),
        )));
  }

  Widget tabmenuOfExt() {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.all(1),
      width: screenWidth,
      height: screenHeight * 0.925,
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: TabBar(
                controller: tabController,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                indicatorWeight: 2,
                indicator: tabController!.index == 1
                    ? const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(25.0),
                        ))
                    : tabController!.index == 0
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
                      padding: const EdgeInsets.only(left: 20, top: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: CommonText(name: pendingCount.toString(), fontSize: Constant.fontSize22, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                          Expanded(
                            child: CommonText(name: "Pending Request", fontSize: Constant.fontSize14, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.08,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CommonText(
                                  name: approvedCount.toString(),
                                  fontSize: Constant.fontSize22,
                                  fontColor: tabController!.index == 1 ? Constant.colorWhite : Constant.colorBlack,
                                  fontWeight: Constant.fontWeight600),
                            ),
                            Expanded(
                              child: CommonText(
                                  name: "Approved Request",
                                  fontSize: Constant.fontSize14,
                                  fontColor: tabController!.index == 1 ? Constant.colorWhite : Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500),
                            ),
                          ],
                        ),
                      )),
                ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TabBarView(
                controller: tabController,
                children: [
                  SaudaWidget(
                      saudaDetails: saudaDetails.pendingList!,
                      dealerSaudaDetails: dealerSaudaDetails.pendingList!,
                      isApproved: false,
                      headFontSz: Constant.fontSize13,
                      headFontCol: Constant.colorBlack,
                      headFontWei: Constant.fontWeight600,
                      subFontSz: Constant.fontSize12,
                      subFontCol: Constant.colorLightGray,
                      //subFontWei: 12,
                      sbIcon: Constant.sCIcon1,
                      sbIconColor: Constant.colorOrange,
                      sbIconSize: Constant.fontSize14),
                  SaudaWidget(
                      saudaDetails: saudaDetails.approvedList!,
                      dealerSaudaDetails: dealerSaudaDetails.approvedList!,
                      isApproved: true,
                      headFontSz: Constant.fontSize13,
                      headFontCol: Constant.colorBlack,
                      headFontWei: Constant.fontWeight600,
                      subFontSz: Constant.fontSize12,
                      subFontCol: Constant.colorLightGray,
                      // otherWidget: SaudaExtensionWid(sauda: SaudaBookedSaudaWithExtensionDetails(),),
                      //subFontWei: 12,
                      sbIcon: Constant.sCIcon1,
                      sbIconColor: Constant.colorOrange,
                      sbIconSize: Constant.fontSize14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomFilterDialog(BuildContext context, messageValue, title, footerbutton, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
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
                    )),
                content: Container(height: 150, width: double.infinity, padding: const EdgeInsets.only(left: 10, right: 10, top: 20), child: getDialogContent()),
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
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(selected.add(Duration(days: Constants.REPORT_MAX_DAY)), DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _todatecontroller.text.toString() == ""
          ? DateTime.now().add(const Duration(days: Constants.REPORT_MAX_DAY + Constants.REPORT_START_DAY))
          : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
      firstDate: _fromdatecontroller.text.toString() == ""
          ? DateTime.now()
          : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
      lastDate: _fromdatecontroller.text.toString() == ""
          ? DateTime.now().add(const Duration(days: Constants.REPORT_MAX_DAY))
          : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format))
              .add(const Duration(days: Constants.REPORT_MAX_DAY)),
    );
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
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
      BorderBottom(bordeSize: 1, bottomColor: Colors.grey[200])
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
                BlocProvider.of<SaudaExtensionBloc>(ct).add(LoadSaudaExtensionScreen(
                    userId: Constants.AUTH_USERID,
                    fromDate: DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                    toDate: DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
