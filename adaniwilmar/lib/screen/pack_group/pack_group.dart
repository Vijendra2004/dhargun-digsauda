import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/pack_group_list.dart';
import 'package:adaniwilmar/models/packgroupwise_sales_response.dart';
import 'package:adaniwilmar/screen/pack_group/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';
import '../packgroup_sales_detail/packgroup_sales_detail.dart';

class PackGroupScreen extends StatelessWidget {
  const PackGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackGroupBloc()
        ..add(LoadPackGroupSalesScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now()
                    .add(const Duration(days: Constants.REPORT_START_DAY)),
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            packGroupId: 0))
        ..add(LoadPackGroupList(userId: Constants.AUTH_USERID)),
      child: const PackGroup(),
    );
  }
}

class PackGroup extends StatefulWidget {
  const PackGroup({Key? key}) : super(key: key);

  @override
  State<PackGroup> createState() => _PackGroupScreenState();
}

class _PackGroupScreenState extends State<PackGroup> {
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
  double targetPercentage = 0;
  double achievedPercentage = 0;
  List<PackGroupList> packGroups = [];
  PackGroupList? selectedPackGroup;
  BdoList? selectedBdo;
  List<PackGroupwiseSales> salesList = [];
  ProgressBarHandler? _handler;

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  StateTraderFilterWidget? tradeFilter;

  @override
  void initState() {
    // TODO: implement initState
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        selectedBdo = value;
        BlocProvider.of<PackGroupBloc>(context).add(LoadPackGroupSalesScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToServerToDateFormat(
                fromDate,
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToServerToDateFormat(
                toDate,
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format),
            packGroupId: 0,
            bdoId: selectedBdo!.id!));
      },
      onLoad: (var value) {},
    );
    super.initState();
  }

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
    return BlocListener<PackGroupBloc, PackGroupState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            salesList = state.packGroupwiseSales;
            setState(() {});
          }
          if (state is OnLoadPackGroup) {
            packGroups = state.packGroups;
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
                height: screenHeight * 0.98,
                margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                child: CurveBorderBox(
                    boxLRPadding: 0,
                    boxTOPPadding: 20,
                    boxofWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tradeFilter != null
                            ? tradeFilter!
                            : const Visibility(
                                visible: false, child: Text("State Trade")),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        Row(
                          children: [
                            Container(
                                width: 3,
                                height: 40,
                                color: Constant.colorOrange),
                            const SizedBox(width: 4),
                            Text(
                              "Billed Parties",
                              style: TextStyle(
                                  fontSize: Constant.fontSize15,
                                  fontWeight: Constant.fontWeight600),
                            ),
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter setState) {
                                  return SizedBox(
                                      width: double.infinity,
                                      // height: 70,
                                      child: CommonDropdownButtonFormField<PackGroupList>(
                                        label: "Pack Group",
                                        value: packGroups.contains(selectedPackGroup) ? selectedPackGroup : null,
                                        onChanged: (PackGroupList? newValue) {
                                          if (newValue == null) return;

                                          setState(() {
                                            selectedPackGroup = newValue;
                                          });

                                          context.read<PackGroupBloc>().add(
                                                LoadPackGroupSalesScreen(
                                                  userId: Constants.AUTH_USERID,
                                                  fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.YYYY_MM_DD_Format),
                                                  toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
                                                  packGroupId: newValue.id!,
                                                ),
                                              );
                                        },
                                        items: packGroups.map((value) {
                                          return DropdownMenuItem<PackGroupList>(
                                            value: value,
                                            child: Text(value.name!),
                                          );
                                        }).toList(),
                                      ));
                                }),
                                const SizedBox(
                                  height: 16,
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       padding: const EdgeInsets.only(
                                //           left: 6, right: 9, top: 4, bottom: 2),
                                //       decoration: BoxDecoration(
                                //         color: Constant.colorOfGray,
                                //         borderRadius: const BorderRadius.only(
                                //           topLeft: Radius.circular(12),
                                //           topRight: Radius.circular(12),
                                //           bottomLeft: Radius.circular(12),
                                //           bottomRight: Radius.circular(12),
                                //         ),
                                //       ),
                                //       child: Container(
                                //           child: Row(
                                //             children: [
                                //               Row(
                                //                 crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //                 mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //                 children: [
                                //                   Text(
                                //                     "Popular",
                                //                     style: TextStyle(
                                //                       fontSize: Constant.fontSize11,
                                //                       color: Constant.colorBlack,
                                //                     ),
                                //                   ),
                                //                   SizedBox(
                                //                     width: 9,
                                //                   ),
                                //                   SizedBox(
                                //                     width: 7,
                                //                     height: 4,
                                //                     child: MaterialButton(
                                //                         padding: EdgeInsets.zero,
                                //                         child: Icon(
                                //                           Icons.cancel,
                                //                           size: 12,
                                //                           color:
                                //                           Constant.pricDisBocolor,
                                //                         ),
                                //                         onPressed: () {}),
                                //                   )
                                //                 ],
                                //               ),
                                //             ],
                                //           )),
                                //     ),
                                //     SizedBox(width: 9.0),
                                //     Container(
                                //       padding: const EdgeInsets.only(
                                //           left: 6, right: 9, top: 4, bottom: 2),
                                //       decoration: BoxDecoration(
                                //         color: Constant.colorOfGray,
                                //         borderRadius: const BorderRadius.only(
                                //           topLeft: Radius.circular(12),
                                //           topRight: Radius.circular(12),
                                //           bottomLeft: Radius.circular(12),
                                //           bottomRight: Radius.circular(12),
                                //         ),
                                //       ),
                                //       child: Container(
                                //           child: Row(
                                //             children: [
                                //               Row(
                                //                 crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //                 mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //                 children: [
                                //                   Text(
                                //                     "Popular",
                                //                     style: TextStyle(
                                //                       fontSize: Constant.fontSize11,
                                //                       color: Constant.colorBlack,
                                //                     ),
                                //                   ),
                                //                   SizedBox(
                                //                     width: 9,
                                //                   ),
                                //                   SizedBox(
                                //                     width: 7,
                                //                     height: 4,
                                //                     child: MaterialButton(
                                //                         padding: EdgeInsets.zero,
                                //                         child: Icon(
                                //                           Icons.cancel,
                                //                           size: 12,
                                //                           color:
                                //                           Constant.pricDisBocolor,
                                //                         ),
                                //                         onPressed: () {}),
                                //                   )
                                //                 ],
                                //               ),
                                //             ],
                                //           )),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(height: 12.0)
                              ],
                            )),
                        Expanded(
                          child: SizedBox(
                            width: screenWidth,
                            child: SingleChildScrollView(
                                child: (salesList.isNotEmpty) ? ListView.builder(
                                    key: const Key('builder1'), //attention
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: salesList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color:
                                                        const Color(0xFFDEDEDE)),
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
                                              child: Column(
                                                children: [
                                                  MaterialButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PackGroupDetailDetailScreen(
                                                                    dealerId: salesList[
                                                                            index]
                                                                        .dealerId!,
                                                                    fromDate: DateTimeUtils().dateToServerToDateFormat(
                                                                        _fromdatecontroller
                                                                            .text
                                                                            .toString(),
                                                                        DateTimeUtils
                                                                            .DD_MM_YYYY_Format,
                                                                        DateTimeUtils
                                                                            .YYYY_MM_DD_Format),
                                                                    toDate: DateTimeUtils().dateToServerToDateFormat(
                                                                        _todatecontroller
                                                                            .text
                                                                            .toString(),
                                                                        DateTimeUtils
                                                                            .DD_MM_YYYY_Format,
                                                                        DateTimeUtils
                                                                            .YYYY_MM_DD_Format),
                                                                    packGroupId: selectedPackGroup ==
                                                                            null
                                                                        ? 0
                                                                        : selectedPackGroup!
                                                                            .id!,
                                                                  )));
                                                    },
                                                    child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 12,
                                                                right: 12,
                                                                top: 14,
                                                                bottom: 14),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFF5F5F5),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    25.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    5.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              salesList[index]
                                                                  .dealer!,
                                                              style: TextStyle(
                                                                  fontSize: Constant
                                                                      .fontSize14,
                                                                  color: Constant
                                                                      .colorBlack,
                                                                  fontWeight: Constant
                                                                      .fontWeight600),
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
                                                        const SizedBox(height: 3),
                                                        Container(
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
                                                          child: Row(
                                                            children: [
                                                              CommonText(
                                                                name:
                                                                    "Town Name :",
                                                                fontSize: Constant
                                                                    .fontSize13,
                                                                fontColor: Constant
                                                                    .colorDullGray77,
                                                                fontWeight: Constant
                                                                    .fontWeight500,
                                                              ),
                                                              CommonText(
                                                                name: salesList[index]
                                                                            .townName ==
                                                                        null
                                                                    ? ""
                                                                    : salesList[
                                                                            index]
                                                                        .townName!,
                                                                fontSize: Constant
                                                                    .fontSize12,
                                                                fontColor: Constant
                                                                    .colorBlack,
                                                                fontWeight: Constant
                                                                    .fontWeight600,
                                                              ),
                                                            ],
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
                                                                          "Sales Target",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize13,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorDullGray77,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500,
                                                                    ),
                                                                    CommonText(
                                                                      name: salesList[index]
                                                                              .target!
                                                                              .toStringAsFixed(2) +
                                                                          " MT ",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight600,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
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
                                                                          "Actual Sales",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize10,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorDullGray77,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500,
                                                                    ),
                                                                    CommonText(
                                                                      name: salesList[index]
                                                                              .achievement!
                                                                              .toStringAsFixed(2) +
                                                                          " MT ",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize10,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight600,
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
                                          ],
                                        ),
                                      );
                                    }) : const Center(child: Text("No data found"))),
                          ),
                        )
                      ],
                    )),
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
      ),
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
          const SizedBox(width: 9),
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
          const SizedBox(width: 16),
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
                fromDate = _fromdatecontroller.text.toString();
                toDate = _todatecontroller.text.toString();
                BlocProvider.of<PackGroupBloc>(ct).add(LoadPackGroupSalesScreen(
                    userId: Constants.AUTH_USERID,
                    fromDate: DateTimeUtils().dateToServerToDateFormat(
                        _fromdatecontroller.text.toString(),
                        DateTimeUtils.DD_MM_YYYY_Format,
                        DateTimeUtils.YYYY_MM_DD_Format),
                    toDate: DateTimeUtils().dateToServerToDateFormat(
                        _todatecontroller.text.toString(),
                        DateTimeUtils.DD_MM_YYYY_Format,
                        DateTimeUtils.YYYY_MM_DD_Format),
                    packGroupId: selectedPackGroup == null
                        ? 0
                        : selectedPackGroup!.id!));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
