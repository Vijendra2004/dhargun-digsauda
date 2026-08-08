import 'package:adaniwilmar/models/dealer_invoice_response.dart';
import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/screen/packgroup_invoice_detail/packgroup_invoice_detail.dart';
import 'package:adaniwilmar/screen/packgroup_sales_detail/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class PackGroupDetailDetailScreen extends StatelessWidget {
  PackGroupDetailDetailScreen(
      {required this.dealerId,
      required this.fromDate,
      required this.toDate,
      required this.packGroupId,
      Key? key})
      : super(key: key);
  int dealerId = 0;
  String fromDate = "";
  String toDate = "";
  int packGroupId = 0;
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => PackGroupDetailDetailScreen(
              dealerId: 0,
              fromDate: "",
              toDate: "",
              packGroupId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackGroupDetailDetailBloc()
        ..add(LoadPackGroupDetailDetailScreen(
            userId: Constants.AUTH_USERID,
            dealerId: dealerId,
            statusId: 2,
            fromDate: fromDate,
            toDate: toDate,
            packGroupId: packGroupId)),
      child: PackGroupDetailDetail(
        dealerId: dealerId,
        fromDate: fromDate,
        toDate: toDate,
        packGroupId: packGroupId,
      ),
    );
  }
}

class PackGroupDetailDetail extends StatefulWidget {
  PackGroupDetailDetail(
      {required this.dealerId,
      required this.fromDate,
      required this.toDate,
      required this.packGroupId,
      Key? key})
      : super(key: key);
  int dealerId = 0;
  int packGroupId = 0;
  String fromDate = "";
  String toDate = "";
  @override
  State<PackGroupDetailDetail> createState() => _PackGroupDetailDetailState();
}

class _PackGroupDetailDetailState extends State<PackGroupDetailDetail>
    with TickerProviderStateMixin {
  List<DealerLiftingResponse> liftingResponse = [];
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
  DealerInvoices invoices = DealerInvoices();
  ProgressBarHandler? _handler;
  int selected = 0 - 1;
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
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return BlocListener<PackGroupDetailDetailBloc, PackGroupDetailDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            invoices = state.dealerInvoiceResponse;
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
            title: "Pack Group",
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
                  boxTOPPadding: 0,
                  boxLRPadding: 0,
                  boxofWidget: Column(
                    children: [
                      CurveBorderBox(
                          boxBgColor: const Color(0xFFFFFBF7),
                          boxShadowColor: const Color(0xFFFFFFFF),
                          boxofWidget: Container(
                            height: screenHeight * 0.07,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 12, right: 8, left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: invoices.dealer ?? "",
                                            fontSize: Constant.fontSize12,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CommonText(
                                      name: "Town Name :",
                                      fontSize: Constant.fontSize13,
                                      fontColor: Constant.colorDullGray77,
                                    ),
                                    CommonText(
                                      name: invoices.townName ?? "",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 16),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                  name: "Total Quantity",
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorDullGray77),
                              const SizedBox(height: 4),
                              CommonText(
                                  name: (invoices.totalQuantity == null
                                      ? "0.00"
                                      : invoices.totalQuantity!
                                          .toStringAsFixed(2)),
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500),
                              const SizedBox(height: 16),
                            ],
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                  name: "Total Invoice Value",
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorDullGray77),
                              const SizedBox(height: 4),
                              CommonText(
                                  name: "Rs." +
                                      (invoices.totalBookedInvoiceValue == null
                                          ? "0.00"
                                          : invoices.totalBookedInvoiceValue!
                                              .toStringAsFixed(2)),
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500),
                              const SizedBox(height: 16),
                            ],
                          )
                        ]),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            width: screenWidth,
                            child: (invoices.dashboardSalesDetails != null && invoices.dashboardSalesDetails!.isNotEmpty) ? ListView.builder(
                                key: Key(
                                    'builderpc'), //attention
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: invoices.dashboardSalesDetails != null
                                    ? invoices.dashboardSalesDetails!.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  return CurveOuterBox(
                                      boxLRPadding: 0,
                                      boxTBPadding: 7,
                                      boxofWidget: Theme(
                                        data: theme,
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.only(right: 15),
                                          key: Key(index.toString()),
                                          initiallyExpanded: index == selected,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 22,
                                                color: Constant.callToCcolor1,
                                                margin:
                                                    const EdgeInsets.only(top: 3),
                                              ),
                                              const SizedBox(width: 16),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    name: '#' +
                                                        invoices
                                                            .dashboardSalesDetails![
                                                                index]
                                                            .invoiceNumber!,
                                                    fontColor:
                                                        Constant.colorBlack,
                                                    fontSize: Constant.fontSize14,
                                                    fontWeight:
                                                        Constant.fontWeight600,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          children: [
                                            Container(
                                              color: const Color(0xFFECECEC),
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 12,
                                                  bottom: 12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: CommonText(
                                                      name: "Date ",
                                                      fontSize:
                                                          Constant.fontSize12,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight:
                                                          Constant.fontWeight500,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: CommonText(
                                                      name: "Total Qty",
                                                      fontSize:
                                                          Constant.fontSize12,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight:
                                                          Constant.fontWeight500,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: CommonText(
                                                      name: "Invoice Value(Rs.)",
                                                      fontSize:
                                                          Constant.fontSize12,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight:
                                                          Constant.fontWeight500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.all(0),
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemCount: invoices
                                                    .dashboardSalesDetails![index]
                                                    .invoiceList!
                                                    .length,
                                                itemBuilder: (context, ind) {
                                                  return MaterialButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PackGroupInvoiceDetailScreen(
                                                                    id: invoices
                                                                        .dashboardSalesDetails![
                                                                            index]
                                                                        .invoiceList![
                                                                            ind]
                                                                        .invoiceId!,
                                                                    isBulkPack:
                                                                        invoices
                                                                            .isBulkPack!)),
                                                      );
                                                    },
                                                    child: Container(
                                                      color:
                                                          const Color(0xFFFAFAFA),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 12,
                                                              bottom: 12),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: CommonText(
                                                              name: DateTimeUtils().dateToServerToDateFormat(
                                                                  invoices
                                                                      .dashboardSalesDetails![
                                                                          index]
                                                                      .invoiceList![
                                                                          ind]
                                                                      .invoiceDate!,
                                                                  DateTimeUtils
                                                                      .YYYY_MM_DD_Format,
                                                                  DateTimeUtils
                                                                      .DD_MM_YYYY_Format),
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: CommonText(
                                                              name: invoices
                                                                  .dashboardSalesDetails![
                                                                      index]
                                                                  .invoiceList![
                                                                      ind]
                                                                  .invoiceQuantity!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: CommonText(
                                                              name: invoices
                                                                  .dashboardSalesDetails![
                                                                      index]
                                                                  .invoiceList![
                                                                      ind]
                                                                  .invoiceValue!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                          ],
                                          onExpansionChanged: ((newState) {
                                            if (newState) {
                                              setState(() {
                                                selected = index;
                                              });
                                            } else {
                                              setState(() {
                                                selected = -1;
                                              });
                                            }
                                          }),
                                        ),
                                      ));
                                }):const Center(child: Text("No data found"),),),)
                    ],
                  ),
                ),
              ),
              progressBar,
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
                insetPadding: const EdgeInsets.only(left: 20, right: 20),
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
                  padding: const EdgeInsets.all(16),
                  child: Text(title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: Constant.fontSize15,
                        fontWeight: Constant.fontWeight500,
                      )),
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
                  labeltxt: "From",
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
      width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 3,
            child: CommonButton(
              buttonName: "Cancel",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.saudaLETTxtColor,
              buttonColor: Constant.saudaLETbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: screenWidth / 3,
            child: CommonButton(
              buttonName: "Apply",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                BlocProvider.of<PackGroupDetailDetailBloc>(ct).add(
                    LoadPackGroupDetailDetailScreen(
                        userId: Constants.AUTH_USERID,
                        dealerId: widget.dealerId,
                        statusId: 2,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        packGroupId: widget.packGroupId));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
