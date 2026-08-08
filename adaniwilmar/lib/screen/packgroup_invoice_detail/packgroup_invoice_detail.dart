import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/models/invoice_detail_response.dart';
import 'package:adaniwilmar/screen/packgroup_invoice_detail/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class PackGroupInvoiceDetailScreen extends StatelessWidget {
  PackGroupInvoiceDetailScreen(
      {required this.id,
      required this.isBulkPack,
      this.isPendingSauda = false,
      Key? key})
      : super(key: key);
  int id = 0;
  bool isPendingSauda = false;
  bool isBulkPack = false;
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => PackGroupInvoiceDetailScreen(
              id: 0,
              isBulkPack: false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackGroupInvoiceDetailBloc()
        ..add(LoadPackGroupInvoiceDetailScreen(
            userId: Constants.AUTH_USERID,
            id: id,
            isBulkPack: isBulkPack,
            isPendingSauda: isPendingSauda)),
      child: PackGroupInvoiceDetail(id: id, isBulkPack: isBulkPack),
    );
  }
}

class PackGroupInvoiceDetail extends StatefulWidget {
  PackGroupInvoiceDetail({required this.id, required this.isBulkPack, Key? key})
      : super(key: key);
  int id = 0;
  bool isBulkPack = false;
  @override
  State<PackGroupInvoiceDetail> createState() => _PackGroupInvoiceDetailState();
}

class _PackGroupInvoiceDetailState extends State<PackGroupInvoiceDetail>
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
  InvoiceDetail invoice = InvoiceDetail();
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
    return BlocListener<PackGroupInvoiceDetailBloc,
            PackGroupInvoiceDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            invoice = state.invoiceResponse;
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
            title: "Sales Detail",
            backArrow: true,
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
                margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                child: Column(
                  children: [
                    CurveBorderBox(
                      boxofWidget: SizedBox(
                        height: screenHeight * 0.970,
                        width: screenWidth,
                        child: Column(
                          children: [
                            CurveBorderBox(
                                boxLRPadding: 0,
                                boxBOTPadding: 0,
                                boxBgColor: const Color(0xFFFFFBF7),
                                boxShadowColor: const Color(0xFFFFFFFF),
                                boxofWidget: SizedBox(
                                  height: screenHeight * 0.12,
                                  width: screenWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(children: <Widget>[
                                        SizedBox(
                                          width: screenWidth * 0.45,
                                          child: ListTile(
                                            title: CommonText(
                                                name: "Invoice Number",
                                                fontSize: Constant.fontSize14,
                                                fontColor:
                                                    Constant.colorDullGray77),
                                            subtitle: CommonText(
                                                name: invoice.invoiceNumber
                                                        .toString() ??
                                                    "",
                                                fontSize: Constant.fontSize14,
                                                fontColor: Constant.colorBlack,
                                                fontWeight:
                                                    Constant.fontWeight600),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.45,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            title: CommonText(
                                                name: "Invoice Date",
                                                fontSize: Constant.fontSize14,
                                                fontColor:
                                                    Constant.colorDullGray77),
                                            subtitle: CommonText(
                                                name: invoice
                                                            .invoiceDate !=
                                                        null
                                                    ? DateTimeUtils()
                                                        .dateToServerToDateFormat(
                                                            invoice
                                                                .invoiceDate!,
                                                            DateTimeUtils
                                                                .YYYY_MM_DD_Format,
                                                            DateTimeUtils
                                                                .DD_MMM_YYYY_Format)
                                                    : "",
                                                fontSize: Constant.fontSize14,
                                                fontColor: Constant.colorBlack,
                                                fontWeight:
                                                    Constant.fontWeight600),
                                          ),
                                        ),
                                      ])
                                    ],
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ListTile(
                                  dense: true,
                                  title: CommonText(
                                      name: "Total Invoice Quantity",
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorDullGray77),
                                  subtitle: CommonText(
                                      name: (invoice.invoiceQuantity == null
                                          ? "0.00"
                                          : invoice.invoiceQuantity!
                                              .toStringAsFixed(2)),
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600),
                                )),
                            Row(children: <Widget>[
                              SizedBox(
                                width: screenWidth * 0.45,
                                child: ListTile(
                                  dense: true,
                                  title: CommonText(
                                      name: "Total Invoice Value",
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorDullGray77),
                                  subtitle: CommonText(
                                      name: (invoice.totalInvoiceValue == null
                                          ? "0.00"
                                          : invoice.totalInvoiceValue!
                                              .toStringAsFixed(2)),
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.45,
                                child: ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  title: CommonText(
                                      name: "Pending Invoice Value",
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorDullGray77),
                                  subtitle: CommonText(
                                      name: "Rs." +
                                          (invoice.pendingInvoiceValue == null
                                              ? "0.00"
                                              : invoice.pendingInvoiceValue!
                                                  .toStringAsFixed(2)),
                                      fontSize: Constant.fontSize14,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600),
                                ),
                              ),
                            ]),
                            Container(
                                width: screenWidth,
                                height: screenHeight * 0.55,
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 20),
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: invoice.invoiceSKUDetails !=
                                              null
                                          ? invoice.invoiceSKUDetails!.length
                                          : 0,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: screenHeight * 0.15,
                                          width: screenWidth,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFECECEC),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              topRight: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0),
                                              bottomRight:
                                                  Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: CommonText(
                                                  name: invoice
                                                      .invoiceSKUDetails![index]
                                                      .sku,
                                                  fontColor:
                                                      Constant.colorBlack,
                                                  fontSize: Constant.fontSize14,
                                                ),
                                                subtitle: CommonText(
                                                  name: "(" +
                                                      invoice
                                                          .invoiceSKUDetails![
                                                              index]
                                                          .quantity!
                                                          .toStringAsFixed(2) +
                                                      " MT)",
                                                  fontColor: Constant.colorRed,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                ),
                                                trailing: CommonText(
                                                  name: invoice
                                                      .invoiceSKUDetails![index]
                                                      .quantityInCase!
                                                      .toStringAsFixed(2),
                                                  fontSize: Constant.fontSize14,
                                                  fontColor:
                                                      Constant.colorOrange,
                                                  fontWeight:
                                                      Constant.fontWeight500,
                                                ),
                                              ),
                                              Visibility(
                                                  visible: index <
                                                      invoice.invoiceSKUDetails!
                                                              .length -
                                                          1,
                                                  child: const BorderBottom()),
                                            ],
                                          ),
                                        );
                                      }),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                BlocProvider.of<PackGroupInvoiceDetailBloc>(ct).add(
                    LoadPackGroupInvoiceDetailScreen(
                        userId: Constants.AUTH_USERID,
                        id: widget.id,
                        isBulkPack: widget.isBulkPack));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
