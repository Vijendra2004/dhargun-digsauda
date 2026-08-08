import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/screen/sale_order_details.dart/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class SalesOrderDetailScreen extends StatelessWidget {
  SalesOrderDetailScreen(
      {required this.dealerId, required this.statusId, Key? key})
      : super(key: key);
  int dealerId = 0;
  int statusId = 0;
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SalesOrderDetailScreen(
              dealerId: 0,
              statusId: 1,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesOrderDetailBloc()
        ..add(LoadSalesOrderDetailScreen(
            userId: Constants.AUTH_USERID,
            dealerId: dealerId,
            statusId: statusId,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now()
                    .add(const Duration(days: Constants.REPORT_START_DAY)),
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format), isFilter: false)),
      //Initially set isFilter to false, after apply filter is set to true
      child: SalesOrderDetail(
        dealerId: dealerId,
        statusId: statusId,
      ),
    );
  }
}

class SalesOrderDetail extends StatefulWidget {
  SalesOrderDetail({required this.dealerId, required this.statusId, Key? key})
      : super(key: key);
  int dealerId = 0;
  int statusId = 0;
  @override
  State<SalesOrderDetail> createState() => _SalesOrderDetailState();
}

class _SalesOrderDetailState extends State<SalesOrderDetail>
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    _fromdatecontroller.text = fromDate;
    _todatecontroller.text = toDate;
    return BlocListener<SalesOrderDetailBloc, SalesOrderDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            liftingResponse = state.dealerLiftingResponse;
            setState(() {});
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Sales Order Status",
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
                margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                child: CurveBorderBox(
                  boxTOPPadding: 16.0,
                  boxofWidget: Column(
                    children: [
                      Container(
                        color: const Color(0xFFECECEC),
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 12, bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: CommonText(
                                name: "Lifting No",
                                fontSize: Constant.fontSize12,
                                fontColor: Constant.colorBlack,
                                fontWeight: Constant.fontWeight500,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CommonText(
                                name: "Req Date",
                                fontSize: Constant.fontSize12,
                                fontColor: Constant.colorBlack,
                                fontWeight: Constant.fontWeight500,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CommonText(
                                name: "Req Qty",
                                fontSize: Constant.fontSize12,
                                fontColor: Constant.colorBlack,
                                fontWeight: Constant.fontWeight500,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CommonText(
                                name: "",
                                fontSize: Constant.fontSize12,
                                fontColor: Constant.colorBlack,
                                fontWeight: Constant.fontWeight500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(right: 8, left: 8, bottom: 8),
                          height: screenHeight * 0.875,
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              physics: const ClampingScrollPhysics(),
                              itemCount: liftingResponse.length,
                              itemBuilder: (context, index) {
                                return MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SalesOrderDetailPageScreen(
                                                  id: liftingResponse[index]
                                                      .liftingRequestId!)),
                                    );
                                  },
                                  child: Container(
                                    color: const Color(0xFFFAFAFA),
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 12, bottom: 12),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: CommonText(
                                            name: liftingResponse[index]
                                                        .liftingRequestNumber !=
                                                    null
                                                ? liftingResponse[index]
                                                    .liftingRequestNumber
                                                : "",
                                            fontSize: Constant.fontSize12,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight600,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: CommonText(
                                            name: DateTimeUtils()
                                                .dateToServerToDateFormat(
                                                    liftingResponse[index]
                                                        .liftingRequestdate!,
                                                    DateTimeUtils
                                                        .YYYY_MM_DD_Format,
                                                    DateTimeUtils
                                                        .DD_MMM_YYYY_Format),
                                            fontSize: Constant.fontSize12,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: CommonText(
                                            name: liftingResponse[index]
                                                .requestedQuantity!
                                                .toStringAsFixed(2),
                                            fontSize: Constant.fontSize12,
                                            fontColor: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child:Visibility(visible:liftingResponse[index]
                                                  .isCreatedBy!,child: Image.asset("assets/images/note.png",height: 16,width: 16,)),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                ),
              )
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
                // insetPadding: EdgeInsets.only(left: 20, right: 20),
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
            DateTimeUtils.YYYY_MM_DD_Format)).add(const Duration(days: Constants.REPORT_MAX_DAY)));
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
              buttonHeight: 40,
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
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                BlocProvider.of<SalesOrderDetailBloc>(ct).add(
                    LoadSalesOrderDetailScreen(
                        userId: Constants.AUTH_USERID,
                        dealerId: widget.dealerId,
                        statusId: widget.statusId,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format), isFilter: true));
                //Initially set isFilter to false, after apply filter is set to true.
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
