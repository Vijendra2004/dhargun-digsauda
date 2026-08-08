import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/screen/quantity_allocation/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class QuantityAllocationScreen extends StatelessWidget {
  const QuantityAllocationScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const QuantityAllocationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuantityAllocationBloc()
        ..add(LoadOilType())
        ..add(LoadQuantityAllocationRequest(userId: Constants.AUTH_USERID)),
      child: const QualityAllocation(),
    );
  }
}

class QualityAllocation extends StatefulWidget {
  const QualityAllocation({Key? key}) : super(key: key);

  @override
  State<QualityAllocation> createState() => _QualityAllocationState();
}

class _QualityAllocationState extends State<QualityAllocation>
    with TickerProviderStateMixin {
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  List<OilType> oilTypes = [];
  OilType? selectedOilType;
  List<DailySFQuantityAllocation> quantityAllocations = [];
  List<QuantityRequestList> quantityManagerAllocations = [];
  List<SpecialtyFatQuantityRequestsList> quantityRequestList = [];
  List<SpecialtyFatQuantityRequestsList> quantityManagerRequestList = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Oil Type";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  TextEditingController _quantitycontroller = TextEditingController();
  get handleOk => null;
  int selectedTab = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);

    indicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget contBody() {
    return const Text("jai");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var ctx = context;
    void showCustomAlertDialog(BuildContext context, messageValue, title,
        handleOk, Null Function() param4,
        {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white,
        String type = "",
        double givenQty = 0,
        double availableQty = 0,
        int specialityLimitId = 0,
        int oilTypeId = 0,
        int skuId = 0}) {
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
        title: Container(
          decoration: BoxDecoration(
            color: Constant.colorOrange,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
          ),
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
              )),
        ),
        content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Type",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      type,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        SizedBox(
                          height: 10,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Given Qty",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              givenQty.toString() + "MT",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ))
                      ]),
                      Visibility(
                          visible: Constants.AUTH_ROLEID != Constants.SALE,
                          child: Column(children: [
                            SizedBox(
                              height: 10,
                            ),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Available Qty",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  availableQty.toString() + "MT",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ))
                          ]))
                    ]),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CommonTextFormField(
                      labeltxt: "Required Quantity(MT)",
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
                      controllerTxt: _quantitycontroller,
                      keyborType: TextInputType.number,
                      inputFormatter: [
                        new FilteringTextInputFormatter.deny(RegExp("[\\-]"))
                      ],
                    ))
              ],
            )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonButton(
                  buttonName: "Cancel",
                  buttonNameSize: Constant.pricbuttonNameSize,
                  buttonNameColor: Constant.textFormFieldColor,
                  buttonColor: Colors.white,
                  buttonHeight: Constant.pricbuttonHeight,
                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                  buttonRadiusBL: Constant.pricbutRadiusBL,
                  buttonBorder: Colors.black,
                  buttonFunction: () {
                    Navigator.pop(ctx);
                  }),
              CommonButton(
                  buttonName: "Submit",
                  buttonNameSize: Constant.pricbuttonNameSize,
                  buttonNameColor: Constant.pricbuttonTxtColor,
                  buttonColor: Constant.pricbuttonColor,
                  buttonHeight: Constant.pricbuttonHeight,
                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                  buttonRadiusBL: Constant.pricbutRadiusBL,
                  buttonBorder: Colors.transparent,
                  buttonFunction: () {
                    if (_quantitycontroller.text.toString() == "") {
                      return;
                    }
                    BlocProvider.of<QuantityAllocationBloc>(ctx).add(
                        SaveQuantityRequest(
                            userId: Constants.AUTH_USERID,
                            oilTypeId: oilTypeId,
                            specialtyLimitId: specialityLimitId,
                            skuId: skuId,
                            quantity: double.parse(
                                _quantitycontroller.text.toString())));
                  })
            ],
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<QuantityAllocationBloc, QuantityAllocationState>(
        listener: (context, state) {
          if (state is OnLoadOilType) {
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnOverallSuccess) {
            quantityAllocations = state.response;
            setState(() {});
          }
          if (state is OnOverallManagerSuccess) {
            quantityManagerAllocations = state.response;
            setState(() {});
          }
          if (state is OnQuantityAllocationRequestSuccess) {
            quantityRequestList = state.quantityRequestList;
            quantityManagerRequestList = state.quantityManagerRequestList;
            setState(() {});
          }
          if (state is OnSaveSuccess) {
            showSuccessDlg(context, "Quantity Request", "Quantity Request",
                successText: "Request Confirmed");
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
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
            title: "Quantity Allocation",
            backArrow: true,
          ),
          body: Stack(
            clipBehavior: Clip.hardEdge,
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
                  child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: CurveBorderBox(
                          boxLRPadding: 0,
                          boxofWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.all(1),
                                child: TabBar(
                                    indicator: tabController == 1
                                        ? const BoxDecoration(
                                            color: Color(0xFFF68C33),
                                          )
                                        : tabController == 2
                                            ? const BoxDecoration(
                                                color: Colors.green)
                                            : const BoxDecoration(
                                                color: Color(0xFFF68C33),
                                                borderRadius: BorderRadius.only(
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
                                    controller: tabController,
                                    isScrollable: false,
                                    tabs: [
                                      Tab(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.8,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Quantity Request",
                                              style: TextStyle(
                                                  color:
                                                      tabController?.index == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.8,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Request Status",
                                              style: TextStyle(
                                                  color:
                                                      tabController?.index == 1
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              Container(
                                height: screenHeight * 0.900,
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 16),
                                      padding: const EdgeInsets.only(
                                        right: 14,
                                        top: 14,
                                        bottom: 14,
                                      ),
                                      // decoration: const BoxDecoration(
                                      //   color: Colors.white,
                                      //   borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(25.0),
                                      //     topRight: Radius.circular(5.0),
                                      //     bottomLeft: Radius.circular(5.0),
                                      //     bottomRight: Radius.circular(25.0),
                                      //   ),
                                      //   boxShadow: [
                                      //     BoxShadow(
                                      //       color: Color(0x25000000),
                                      //       offset: Offset(
                                      //         2.0,
                                      //         1.0,
                                      //       ),
                                      //       blurRadius: 3.0,
                                      //       spreadRadius: 2.0,
                                      //     ),
                                      //     //BoxShadow
                                      //   ],
                                      // ),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonDropdownButtonFormField<OilType>(
                                              value: oilTypes.contains(selectedOilType) ? selectedOilType : null,
                                              label: "Oil Type",
                                              onChanged: (OilType? newValue) {
                                                if (newValue == null) return;
                                                setState(() {
                                                  selectedOilType = newValue;
                                                });
                                                BlocProvider.of<
                                                            QuantityAllocationBloc>(
                                                        context)
                                                    .add(LoadOverallData(
                                                  userId: Constants.AUTH_USERID,
                                                  oilTypeId: newValue.id!,
                                                ));
                                              },
                                              items: oilTypes.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value.name!),
                                                );
                                              }).toList(),
                                            ),
                                            Container(
                                                height: screenHeight * 0.700,
                                                child: Constants.AUTH_ROLEID ==
                                                        Constants.SALE
                                                    ? ListView.builder(
                                                        shrinkWrap: true,
                                                        padding: const EdgeInsets
                                                            .only(top: 0),
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount:
                                                            quantityAllocations
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 16),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 14,
                                                              top: 14,
                                                              bottom: 14,
                                                            ),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        25.0),
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                      0x25000000),
                                                                  offset:
                                                                      Offset(
                                                                    2.0,
                                                                    1.0,
                                                                  ),
                                                                  blurRadius:
                                                                      3.0,
                                                                  spreadRadius:
                                                                      2.0,
                                                                ),
                                                                //BoxShadow
                                                              ],
                                                            ),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showCustomAlertDialog(
                                                                      context,
                                                                      "",
                                                                      "Request",
                                                                      {},
                                                                      () {},
                                                                      type: quantityAllocations[
                                                                              index]
                                                                          .skuName!,
                                                                      givenQty:
                                                                          quantityAllocations[index]
                                                                              .quantity!,
                                                                      skuId: quantityAllocations[
                                                                              index]
                                                                          .skuId!,
                                                                      oilTypeId: selectedOilType !=
                                                                              null
                                                                          ? selectedOilType!
                                                                              .id!
                                                                          : 0,
                                                                      specialityLimitId:
                                                                          0);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      width: 3,
                                                                      height:
                                                                          34,
                                                                      color: Constant
                                                                          .callToCcolor1,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              3),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            20),
                                                                    Expanded(
                                                                      child:
                                                                          CommonText(
                                                                        name: quantityAllocations[index]
                                                                            .skuName,
                                                                        fontSize:
                                                                            Constant.fontSize15,
                                                                        fontColor:
                                                                            Constant.colorBlack,
                                                                        fontWeight:
                                                                            Constant.fontWeight500,
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          CommonText(
                                                                        name: quantityAllocations[index].quantity.toString() +
                                                                            "MT",
                                                                        fontSize:
                                                                            Constant.fontSize15,
                                                                        fontColor:
                                                                            Constant.colorBlack,
                                                                        fontWeight:
                                                                            Constant.fontWeight600,
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          );
                                                        })
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0),
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount:
                                                            quantityManagerAllocations
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                              onTap: () {
                                                                showCustomAlertDialog(
                                                                    context,
                                                                    "",
                                                                    "Request",
                                                                    {},
                                                                    () {},
                                                                    type: quantityManagerAllocations[
                                                                            index]
                                                                        .skuName!,
                                                                    givenQty:
                                                                        quantityManagerAllocations[index]
                                                                            .quantityLimit!,
                                                                    skuId: quantityManagerAllocations[
                                                                            index]
                                                                        .skuId!,
                                                                    availableQty:
                                                                        quantityManagerAllocations[index]
                                                                            .remainingQuantity!,
                                                                    specialityLimitId:
                                                                        quantityManagerAllocations[index]
                                                                            .id!,
                                                                    oilTypeId: quantityManagerAllocations[
                                                                            index]
                                                                        .oilTypeId!);
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              12,
                                                                          right:
                                                                              12,
                                                                          top:
                                                                              9,
                                                                          bottom:
                                                                              9),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xFFF5F5F5),
                                                                        borderRadius:
                                                                            BorderRadius.only(
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
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                quantityManagerAllocations[index].oilTypeName ?? "",
                                                                                style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                        ],
                                                                      )),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        bottom:
                                                                            12),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Type",
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack),
                                                                            ),
                                                                            Text(
                                                                              quantityManagerAllocations[index].skuName!,
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            )
                                                                          ],
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                            decoration: const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(width: 0.8, color: Color(0x13000000)),
                                                                          ),
                                                                        )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        bottom:
                                                                            12),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Valid From",
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack),
                                                                            ),
                                                                            Text(
                                                                              DateTimeUtils().dateToServerToDateFormat(quantityManagerAllocations[index].validFrom!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MM_YYYY_Format),
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            )
                                                                          ],
                                                                        )),
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Valid To",
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack),
                                                                            ),
                                                                            Text(
                                                                              DateTimeUtils().dateToServerToDateFormat(quantityManagerAllocations[index].validTo!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MM_YYYY_Format),
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            )
                                                                          ],
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                            decoration: const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(width: 0.8, color: Color(0x13000000)),
                                                                          ),
                                                                        )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        bottom:
                                                                            12),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Given Qty",
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack),
                                                                            ),
                                                                            Text(
                                                                              quantityManagerAllocations[index].quantityLimit!.toStringAsFixed(2),
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            )
                                                                          ],
                                                                        )),
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Available Qty",
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack),
                                                                            ),
                                                                            Text(
                                                                              quantityManagerAllocations[index].remainingQuantity.toString() + "MT",
                                                                              style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            )
                                                                          ],
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ));
                                                        })),
                                          ]),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        child: Column(children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Visibility(
                                              visible: Constants.SALE !=
                                                  Constants.AUTH_ROLEID,
                                              child: Row(children: [
                                                InkWell(
                                                    onTap: () {
                                                      selectedTab = 0;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: selectedTab ==
                                                                  0
                                                              ? Color(
                                                                  0xFFF68C33)
                                                              : Color(
                                                                  0xFFFFFFFF),
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
                                                                    25.0),
                                                          ),
                                                        ),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.1,
                                                          child: const Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "User Qty",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ))),
                                                InkWell(
                                                    onTap: () {
                                                      selectedTab = 1;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: selectedTab ==
                                                                  1
                                                              ? Color(
                                                                  0xFFF68C33)
                                                              : Color(
                                                                  0xFFFFFFFF),
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
                                                                    25.0),
                                                          ),
                                                        ),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              Constants.AUTH_ROLEID ==
                                                                      Constants
                                                                          .ZHMANAGER
                                                                  ? "State Trader Qty"
                                                                  : "NH Qty",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ))),
                                              ])),
                                          Container(
                                              height: Constants.SALE !=
                                                      Constants.AUTH_ROLEID
                                                  ? screenHeight * 0.700
                                                  : screenHeight * 0.825,
                                              child: selectedTab == 0
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          quantityRequestList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            Constants.SALE !=
                                                                    Constants
                                                                        .AUTH_ROLEID
                                                                ? Container(
                                                                    width: double
                                                                        .infinity,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 9,
                                                                        bottom:
                                                                            9),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF5F5F5),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
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
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              quantityRequestList[index].userName ?? "",
                                                                              style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              CommonLabel(
                                                                                bgColor: Constant.booSauStacolor,
                                                                                name: quantityRequestList[index].status!,
                                                                                fontSize: Constant.fontSize11,
                                                                                fontColor: Constant.colorWhite,
                                                                                imageic: Constant.checkIc,
                                                                                imagetrue: true,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ))
                                                                : Container(
                                                                    width: double
                                                                        .infinity,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 9,
                                                                        bottom:
                                                                            9),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF5F5F5),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
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
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              quantityRequestList[index].oilTypeName!,
                                                                              style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              CommonLabel(
                                                                                bgColor: Constant.booSauStacolor,
                                                                                name: quantityRequestList[index].status!,
                                                                                fontSize: Constant.fontSize11,
                                                                                fontColor: Constant.colorWhite,
                                                                                imageic: Constant.checkIc,
                                                                                imagetrue: true,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )),
                                                            Constants.SALE !=
                                                                    Constants
                                                                        .AUTH_ROLEID
                                                                ? Container(
                                                                    width: double
                                                                        .infinity,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 2,
                                                                        bottom:
                                                                            2),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              quantityRequestList[index].oilTypeName!,
                                                                              style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                      ],
                                                                    ))
                                                                : Visibility(
                                                                    visible:
                                                                        false,
                                                                    child: Text(
                                                                        "")),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Type",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack),
                                                                      ),
                                                                      Text(
                                                                        quantityRequestList[index]
                                                                            .skuName!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack,
                                                                            fontWeight: Constant.fontWeight500),
                                                                      )
                                                                    ],
                                                                  )),
                                                                  Expanded(
                                                                      child:
                                                                          Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Quantity",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack),
                                                                      ),
                                                                      Text(
                                                                        quantityRequestList[index].quantity.toString() +
                                                                            "MT",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack,
                                                                            fontWeight: Constant.fontWeight500),
                                                                      )
                                                                    ],
                                                                  )),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      })
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          quantityManagerRequestList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 9,
                                                                        bottom:
                                                                            9),
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
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            25.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          quantityManagerRequestList[index].userName ??
                                                                              "",
                                                                          style: TextStyle(
                                                                              fontSize: Constant.fontSize14,
                                                                              color: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          CommonLabel(
                                                                            bgColor:
                                                                                Constant.booSauStacolor,
                                                                            name:
                                                                                quantityManagerRequestList[index].status!,
                                                                            fontSize:
                                                                                Constant.fontSize11,
                                                                            fontColor:
                                                                                Constant.colorWhite,
                                                                            imageic:
                                                                                Constant.checkIc,
                                                                            imagetrue:
                                                                                true,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 2,
                                                                        bottom:
                                                                            2),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          quantityManagerRequestList[index]
                                                                              .oilTypeName!,
                                                                          style: TextStyle(
                                                                              fontSize: Constant.fontSize14,
                                                                              color: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ],
                                                                )),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Type",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack),
                                                                      ),
                                                                      Text(
                                                                        quantityManagerRequestList[index]
                                                                            .skuName!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack,
                                                                            fontWeight: Constant.fontWeight500),
                                                                      )
                                                                    ],
                                                                  )),
                                                                  Expanded(
                                                                      child:
                                                                          Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Quantity",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack),
                                                                      ),
                                                                      Text(
                                                                        quantityManagerRequestList[index].quantity.toString() +
                                                                            "MT",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            color: Constant.colorBlack,
                                                                            fontWeight: Constant.fontWeight500),
                                                                      )
                                                                    ],
                                                                  )),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      })),
                                        ])),
                                  ],
                                ),
                              ),
                            ],
                          )))),
              progressBar
            ],
          ),
        )));
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
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
      title: Container(
        decoration: BoxDecoration(
          color: Constant.colorOrange,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
            )),
      ),
      content: Text(successText!),
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
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  Navigator.pop(context);
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context, true);
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
