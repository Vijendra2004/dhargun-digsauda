import 'dart:io';

import 'package:adaniwilmar/models/dealer_visit_request.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/screen/daily_sales_report/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class WholesalerVisitScreen extends StatelessWidget {
  int dealerId;
  int id;
  int mtpId;
  WholesalerVisitScreen(
      {required this.dealerId, required this.id, required this.mtpId, Key? key})
      : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => WholesalerVisitScreen(
              dealerId: 0,
              id: 0,
              mtpId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailySalesReportBloc()
        // ..add(LoadOilType(
        //     userId: Constants.AUTH_USERID,
        //     salesOrganizationId: 0,
        //     distributionChannelId: 0,
        //     divisonId: 0)),
        // ..add(LoadWholesalerVisitScreen(
        //     userId: Constants.AUTH_USERID))
        //   ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
        ..add(LoadOilType(
            userId: Constants.AUTH_USERID,
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisonId: 0)),
      child: WholesalerVisit(
        dealerId: dealerId,
        mtpId: mtpId,
        id: id,
      ),
    );
  }
}

class WholesalerVisit extends StatefulWidget {
  int dealerId;
  int id;
  int mtpId;

  WholesalerVisit(
      {required this.dealerId, required this.id, required this.mtpId, Key? key})
      : super(key: key);

  @override
  State<WholesalerVisit> createState() => _WholesalerVisitState();
}

class _WholesalerVisitState extends State<WholesalerVisit> {
  List<SaudaList> saudaList = [];
  List<OilType> oilTypeList = [];
  List<OilTypeSkuList> skuList = [];
  List<WholesalerVisitCompetitorUIModel> competitorModel = [];
  List<WholesalerVisitSecondarySalesSkuModel>? skus = [];
  FocusNode myFocusNode = FocusNode();
  int selected = 0 - 1;
  int ssselected = 0 - 1;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int currentIndex = 0;
  final TextEditingController? _wholesalercontroller = TextEditingController();

  final TextEditingController? _productnamecontroller = TextEditingController();
  final TextEditingController? _ratecontroller = TextEditingController();
  final TextEditingController? _quantitycontroller = TextEditingController();

  TextEditingController? _ssoiltypenamecontroller = TextEditingController();
  TextEditingController? _ssskunamecontroller = TextEditingController();
  final TextEditingController? _ssratecontroller = TextEditingController();
  final TextEditingController? _ssquantitycontroller = TextEditingController();

  static String _displayStringForOption(OilType option) => option.name!;
  OilType? selectedOilType;

  static String _displaySkuStringForOption(OilTypeSkuList option) =>
      option.skuName!;
  OilTypeSkuList? selectedSku;

  int selectedEditIndex = -1;
  int selectedSSEditIndex = -1;
  int currentMainIndex = 0;

  final ImagePicker _picker = ImagePicker();
  ProgressBarHandler? _handler;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
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
          if (state is OnLoadOilType) {
            oilTypeList = state.oilTypes;
            addNewSKU();
            setState(() {});
          }
          if (state is OnLoadSKUDetails) {
            skuList = state.skuList;
            if (selectedSku != null) {
              if (skuList.where(
                      (element) => element.skuId == selectedSku!.skuId) !=
                  null) {
                selectedSku = skuList
                    .where((element) => element.skuId == selectedSku!.skuId!)
                    .first;
              }
            }
            setState(() {});
          }
          if (state is OnSavePriceDiscovery) {
            showSuccessDlg(context, "Dealer Visit", "Success",
                successText: state.response);
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
              title: "Wholesaler Visit",
              backArrow: true,
              listOfActions: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      addNewSKU();
                    },
                    icon: SizedBox(
                      width: 28.0,
                      height: 28.0,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        padding: const EdgeInsets.all(1),
                        child: Icon(Constant.saudaIcPlus),
                      ),
                    ),
                  ),
                ],
              )),
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
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                      boxLRPadding: 0,
                      boxTOPPadding: 0,
                      boxBOTPadding: 0,
                      boxHeight: screenHeight,
                      boxofWidget: SingleChildScrollView(
                          child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: CommonTextFormField(
                                  labeltxt: "Wholesaler Name",
                                  labeltxtColor: Constant.textFormFieldColor,
                                  labeltxtSize: Constant.textFormFieldSize,
                                  labeltxtFontWeight:
                                      Constant.textFormFieldSizeFontW,
                                  focuBorColor: Constant.textFormFocuBorCol,
                                  focuBorWid: Constant.textFormFocuBorWid,
                                  enaBorColor: Constant.textFormEnaBorCol,
                                  enaBorWid: Constant.textFormEnaBorWid,
                                  borderRadiusTL:
                                      Constant.textFormborderRadiusTL,
                                  borderRadiusBR:
                                      Constant.textFormborderRadiusBR,
                                  contentPadHor: Constant.textFormcontentPadHor,
                                  contentPadHVer:
                                      Constant.textFormcontentPadHVer,
                                  controllerTxt: _wholesalercontroller,
                                  keyborType: TextInputType.text,
                                  onChanged: (String? value) {
                                    setState(() {});
                                  })),
                          CurveOuterBox(
                              boxLRPadding: 10,
                              boxTBPadding: 4,
                              boxofWidget: Theme(
                                data: theme,
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  key: Key("ss".toString()),
                                  initiallyExpanded: ssselected == 0,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 34,
                                        color: Constant.callToCcolor1,
                                        margin: const EdgeInsets.only(top: 3),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: CommonText(
                                                name: "Secondary Sales",
                                                fontSize: Constant.fontSize15,
                                                fontColor: Constant.colorBlack,
                                              ))),
                                    ],
                                  ),
                                  children: [
                                    ListView.builder(
                                        key:
                                            const Key('builder_ss'), //attention
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: skus!.length,
                                        itemBuilder: (context, ind) {
                                          return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: CurveOuterBox(
                                                boxBorderColor:
                                                    const Color(0xFFE7E7E7),
                                                boxShadowColor:
                                                    const Color(0xFFFFFFFF),
                                                boxBorderWidth: 0,
                                                boxLRPadding: 0,
                                                boxTBPadding: 0,
                                                boxBRRadius: 5,
                                                boxofWidget: Column(
                                                  children: [
                                                    Visibility(
                                                        visible: true,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    selectedSSEditIndex =
                                                                        ind;
                                                                    selectedOilType =
                                                                        oilTypeList
                                                                            .where(
                                                                              (element) => element.id == skus![ind].oilType!.id,
                                                                            )
                                                                            .first;
                                                                    selectedSku =
                                                                        skus![ind]
                                                                            .oilTypeSkuList;
                                                                    BlocProvider.of<DailySalesReportBloc>(context).add(LoadSKUDetails(
                                                                        oilTypeId:
                                                                            selectedOilType!
                                                                                .id!,
                                                                        currentIndex:
                                                                            0,
                                                                        userId:
                                                                            Constants.AUTH_USERID));
                                                                    _ssquantitycontroller!
                                                                        .text = skus![
                                                                            ind]
                                                                        .quantity!
                                                                        .toString();
                                                                    _ssratecontroller!
                                                                        .text = skus![
                                                                            ind]
                                                                        .rate!
                                                                        .toString();
                                                                    showCustomSecondarySalesDialog(
                                                                        context,
                                                                        "Product",
                                                                        "Product",
                                                                        dialogSSActionButton());
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: SizedBox(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child: Icon(
                                                                            Icons
                                                                                .edit,
                                                                            color:
                                                                                Constant.colorGray45)),
                                                                  )),
                                                              InkWell(
                                                                  onTap: () {
                                                                    skus!.removeAt(
                                                                        ind);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: SizedBox(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child: Icon(
                                                                            Icons
                                                                                .delete,
                                                                            color:
                                                                                Constant.colorGray45)),
                                                                  ))
                                                            ])),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                          child:
                                                                              CommonText(
                                                                        name: skus![ind]
                                                                            .oilType!
                                                                            .name,
                                                                        fontColor:
                                                                            Constant.colorBlack,
                                                                        fontSize:
                                                                            Constant.fontSize10,
                                                                        fontWeight:
                                                                            Constant.fontWeight600,
                                                                      )),
                                                                      const SizedBox(
                                                                          width:
                                                                              6),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                          child:
                                                                              CommonText(
                                                                        name: skus![ind]
                                                                            .oilTypeSkuList!
                                                                            .skuName,
                                                                        fontColor:
                                                                            Constant.colorBlack,
                                                                        fontSize:
                                                                            Constant.fontSize10,
                                                                        fontWeight:
                                                                            Constant.fontWeight600,
                                                                      )),
                                                                      const SizedBox(
                                                                          width:
                                                                              6),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    CommonText(
                                                                  name: "Rs." +
                                                                      skus![ind]
                                                                          .rate!
                                                                          .toStringAsFixed(
                                                                              2) +
                                                                      " ",
                                                                  fontSize: Constant
                                                                      .fontSize11,
                                                                  fontColor:
                                                                      Constant
                                                                          .colorOrange,
                                                                  fontWeight:
                                                                      Constant
                                                                          .fontWeight500,
                                                                ))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CommonText(
                                                                      name: "Qty:" +
                                                                          skus![ind]
                                                                              .quantity!
                                                                              .toStringAsFixed(2),
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize11,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              border: Border(
                                                        top: BorderSide(
                                                          color:
                                                              Color(0xFFD5D5D5),
                                                          width: 0.8,
                                                        ),
                                                      )),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Visibility(
                                                        visible: ind <
                                                            skus!.length - 1,
                                                        child:
                                                            const BorderBottom())
                                                  ],
                                                ),
                                              ));
                                        }),
                                    const SizedBox(height: 16),
                                    Row(children: [
                                      IconButton(
                                        onPressed: () {
                                          selectedSSEditIndex = -1;
                                          selectedSku = null;
                                          selectedOilType = null;
                                          _ssquantitycontroller!.text = "";
                                          _ssratecontroller!.text = "";
                                          showCustomSecondarySalesDialog(
                                              context,
                                              "Product",
                                              "Product",
                                              dialogSSActionButton());
                                          setState(() {});
                                        },
                                        icon: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))),
                                            padding: const EdgeInsets.all(7),
                                            child: Icon(Constant.saudaIcPlus),
                                          ),
                                        ),
                                      ),
                                      const Text("Add Sale")
                                    ]),
                                  ],
                                  onExpansionChanged: ((newState) {
                                    if (newState) {
                                      setState(() {
                                        ssselected = 0;
                                      });
                                    } else {
                                      setState(() {
                                        ssselected = -1;
                                      });
                                    }
                                  }),
                                ),
                              )),
                          const SizedBox(
                            height: 16,
                          ),
                          CurveOuterBox(
                              boxLRPadding: 8,
                              boxTBPadding: 4,
                              boxofWidget: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ListView.builder(
                                        key: const Key('builder1'), //attention
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: competitorModel.length,
                                        itemBuilder: (context, index) {
                                          return CurveOuterBox(
                                              boxLRPadding: 10,
                                              boxTBPadding: 4,
                                              boxofWidget: Theme(
                                                data: theme,
                                                child: ExpansionTile(
                                                  tilePadding: EdgeInsets.zero,
                                                  key: Key(index.toString()),
                                                  initiallyExpanded:
                                                      index == selected,
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 3,
                                                        height: 34,
                                                        color: Constant
                                                            .callToCcolor1,
                                                        margin: const EdgeInsets
                                                            .only(top: 3),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: CommonText(
                                                                name: "Competitor " +
                                                                    (index + 1)
                                                                        .toString(),
                                                                fontSize: Constant
                                                                    .fontSize15,
                                                                fontColor: Constant
                                                                    .colorBlack,
                                                              ))),
                                                      Visibility(
                                                          visible: index > 0,
                                                          child: InkWell(
                                                              onTap: () {
                                                                competitorModel
                                                                    .removeAt(
                                                                        index);
                                                                setState(() {});
                                                              },
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: SizedBox(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child: Icon(
                                                                            Icons
                                                                                .delete,
                                                                            color:
                                                                                Constant.colorGray45)),
                                                                  ))))
                                                    ],
                                                  ),
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text("")),
                                                        CommonTextFormField(
                                                            labeltxt:
                                                                "Competitor Name",
                                                            labeltxtColor: Constant
                                                                .textFormFieldColor,
                                                            labeltxtSize: Constant
                                                                .textFormFieldSize,
                                                            labeltxtFontWeight:
                                                                Constant
                                                                    .textFormFieldSizeFontW,
                                                            focuBorColor: Constant
                                                                .textFormFocuBorCol,
                                                            focuBorWid: Constant
                                                                .textFormFocuBorWid,
                                                            enaBorColor: Constant
                                                                .textFormEnaBorCol,
                                                            enaBorWid: Constant
                                                                .textFormEnaBorWid,
                                                            borderRadiusTL: Constant
                                                                .textFormborderRadiusTL,
                                                            borderRadiusBR: Constant
                                                                .textFormborderRadiusBR,
                                                            contentPadHor: Constant
                                                                .textFormcontentPadHor,
                                                            contentPadHVer: Constant
                                                                .textFormcontentPadHVer,
                                                            controllerTxt:
                                                                competitorModel[
                                                                        index]
                                                                    .competitorName,
                                                            keyborType:
                                                                TextInputType
                                                                    .text,
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {});
                                                            }),
                                                        const SizedBox(
                                                            height: 16.0),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    CommonText(
                                                      name: "Products",
                                                      fontSize:
                                                          Constant.fontSize13,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                    ),
                                                    const BorderBottom(),
                                                    const SizedBox(height: 16),
                                                    ListView.builder(
                                                        key: Key('builder_' +
                                                            index
                                                                .toString()), //attention
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            competitorModel[
                                                                    index]
                                                                .products!
                                                                .length,
                                                        itemBuilder:
                                                            (context, ind) {
                                                          return ListTile(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              title:
                                                                  CurveOuterBox(
                                                                boxBorderColor:
                                                                    const Color(
                                                                        0xFFE7E7E7),
                                                                boxShadowColor:
                                                                    const Color(
                                                                        0xFFFFFFFF),
                                                                boxBorderWidth:
                                                                    0,
                                                                boxLRPadding: 0,
                                                                boxTBPadding: 0,
                                                                boxBRRadius: 5,
                                                                boxofWidget:
                                                                    Column(
                                                                  children: [
                                                                    Visibility(
                                                                        visible:
                                                                            true,
                                                                        child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    selectedEditIndex = ind;
                                                                                    _productnamecontroller!.text = competitorModel[index].products![ind].productName!;
                                                                                    _quantitycontroller!.text = competitorModel[index].products![ind].quantity!.toString();
                                                                                    _ratecontroller!.text = competitorModel[index].products![ind].rate!.toString();
                                                                                    showCustomAlertDialog(context, "Product", "Product", dialogActionButton());
                                                                                    setState(() {});
                                                                                  },
                                                                                  child: Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: SizedBox(width: 25, height: 25, child: Icon(Icons.edit, color: Constant.colorGray45)),
                                                                                  )),
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    competitorModel[index].products!.removeAt(ind);
                                                                                    setState(() {});
                                                                                  },
                                                                                  child: Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: SizedBox(width: 25, height: 25, child: Icon(Icons.delete, color: Constant.colorGray45)),
                                                                                  ))
                                                                            ])),
                                                                    Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  const SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Expanded(
                                                                                          child: CommonText(
                                                                                        name: competitorModel[index].products![ind].productName,
                                                                                        fontColor: Constant.colorBlack,
                                                                                        fontSize: Constant.fontSize10,
                                                                                        fontWeight: Constant.fontWeight600,
                                                                                      )),
                                                                                      const SizedBox(width: 6),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                                alignment: Alignment.centerRight,
                                                                                child: CommonText(
                                                                                  name: "Rs." + competitorModel[index].products![ind].rate!.toStringAsFixed(2) + " ",
                                                                                  fontSize: Constant.fontSize11,
                                                                                  fontColor: Constant.colorOrange,
                                                                                  fontWeight: Constant.fontWeight500,
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                6),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    CommonText(
                                                                                      name: "Qty:" + competitorModel[index].products![ind].quantity!.toStringAsFixed(2),
                                                                                      fontSize: Constant.fontSize11,
                                                                                      fontColor: Constant.colorBlack,
                                                                                      fontWeight: Constant.fontWeight500,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            12),
                                                                    Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              border: Border(
                                                                        top:
                                                                            BorderSide(
                                                                          color:
                                                                              Color(0xFFD5D5D5),
                                                                          width:
                                                                              0.8,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            16.0),
                                                                    Visibility(
                                                                        visible: ind <
                                                                            competitorModel[index].products!.length -
                                                                                1,
                                                                        child:
                                                                            const BorderBottom())
                                                                  ],
                                                                ),
                                                              ));
                                                        }),
                                                    const SizedBox(height: 16),
                                                    Row(children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          currentMainIndex =
                                                              index;
                                                          showCustomAlertDialog(
                                                              context,
                                                              "Product",
                                                              "Product",
                                                              dialogActionButton());
                                                          setState(() {});
                                                        },
                                                        icon: SizedBox(
                                                          width: 30.0,
                                                          height: 30.0,
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7),
                                                            child: Icon(Constant
                                                                .saudaIcPlus),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                          "Add another product")
                                                    ]),
                                                    const SizedBox(height: 8),
                                                    CommonTextFormField(
                                                      maxLine: 4,
                                                      labeltxt: "Remarks",
                                                      labeltxtColor: Constant
                                                          .textFormFieldColor,
                                                      labeltxtSize: Constant
                                                          .textFormFieldSize,
                                                      labeltxtFontWeight: Constant
                                                          .textFormFieldSizeFontW,
                                                      focuBorColor: Constant
                                                          .textFormFocuBorCol,
                                                      focuBorWid: Constant
                                                          .textFormFocuBorWid,
                                                      enaBorColor: Constant
                                                          .textFormEnaBorCol,
                                                      enaBorWid: Constant
                                                          .textFormEnaBorWid,
                                                      borderRadiusTL: Constant
                                                          .textFormborderRadiusTL,
                                                      borderRadiusBR: Constant
                                                          .textFormborderRadiusBR,
                                                      contentPadHor: Constant
                                                          .textFormcontentPadHor,
                                                      contentPadHVer: Constant
                                                          .textFormcontentPadHVer,
                                                      controllerTxt:
                                                          competitorModel[index]
                                                              .competitorRemarks,
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: InkWell(
                                                            onTap: () async {
                                                              XFile?
                                                                  pickedFile =
                                                                  await _picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                              if (pickedFile !=
                                                                  null) {
                                                                FileList f =
                                                                    FileList();
                                                                f.filePath =
                                                                    pickedFile
                                                                        .path;
                                                                f.fileName =
                                                                    pickedFile
                                                                        .name;
                                                                f.id = 1;
                                                                f.fileExtention =
                                                                    pickedFile
                                                                        .name
                                                                        .substring(
                                                                            pickedFile.name.lastIndexOf(".") +
                                                                                1);
                                                                competitorModel[
                                                                        index]
                                                                    .fileList!
                                                                    .add(f);
                                                                setState(() {});
                                                              }
                                                            },
                                                            child: CommonText(
                                                              name:
                                                                  "Attach a file",
                                                              fontSize: Constant
                                                                  .fontSize13,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                            ))),
                                                    ListView.builder(
                                                      key: Key('builderfile_' +
                                                          index
                                                              .toString()), //attention
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int idx) {
                                                        return Stack(children: [
                                                          InkWell(
                                                              onTap: () {
                                                                competitorModel[
                                                                        index]
                                                                    .fileList!
                                                                    .removeAt(
                                                                        idx);
                                                                setState(() {});
                                                              },
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: SizedBox(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child: Icon(
                                                                            Icons
                                                                                .delete,
                                                                            color:
                                                                                Constant.colorGray45)),
                                                                  ))),
                                                          SizedBox(
                                                              height: 200,
                                                              width: 200,
                                                              child: Image.file(File(
                                                                  competitorModel[
                                                                          index]
                                                                      .fileList![
                                                                          idx]
                                                                      .filePath!)))
                                                        ]);
                                                      },
                                                      itemCount:
                                                          competitorModel[index]
                                                              .fileList!
                                                              .length,
                                                    )
                                                  ],
                                                  onExpansionChanged:
                                                      ((newState) {
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
                                        }),
                                    Row(children: [
                                      IconButton(
                                        onPressed: () {
                                          addNewSKU();
                                          setState(() {});
                                        },
                                        icon: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))),
                                            padding: const EdgeInsets.all(7),
                                            child: Icon(Constant.saudaIcPlus),
                                          ),
                                        ),
                                      ),
                                      const Text("Add Competitor")
                                    ]),
                                  ])),
                          // CurveOuterBox(boxofWidget: listOfForm),
                        ],
                      )))),
              progressBar
            ],
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: screenWidth / 2.2,
                      child: CommonButton(
                        buttonName: "Confirm Request",
                        buttonNameSize: Constant.pricbuttonNameSize,
                        buttonNameColor: Constant.pricbuttonTxtColor,
                        buttonColor: Constant.pricbuttonColor,
                        buttonHeight: Constant.pricbuttonHeight,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Colors.transparent,
                        buttonFunction: () {
                          showConfirmDlg(
                              context,
                              "Confirm Wholesaler Visit Request",
                              "Confirm Request");
                          setState(() {});
                        },
                      ))
                ],
              )),
        )));
  }

  void showCustomAlertDialog(
    BuildContext context,
    messageValue,
    title,
    footerbutton, {
    bool? hideCancelBtn = false,
    String? successText = 'OK',
    Color? titleColor = Colors.white,
  }) {
    // set up the button

    // show the dialog
    // var mainContext=context;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // double itemRatePopup=0;
        return StatefulBuilder(builder: (ctx1, setState) {
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
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 250.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextFormField(
                      labeltxt: "Product Name",
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
                      controllerTxt: _productnamecontroller,
                      enabled: true,
                    ),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Quantity",
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
                        onChanged: (String? value) {
                          setState(() {});
                        }),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Price",
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
                        controllerTxt: _ratecontroller,
                        keyborType: TextInputType.number,
                        onChanged: (String? value) {
                          setState(() {});
                        }),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
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

  Widget dialogActionButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 2 - 67,
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
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: screenWidth / 2 - 67,
            child: CommonButton(
              buttonName: "Save",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                if (_productnamecontroller!.text.toString() == "") {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Enter Product Name");
                  return;
                }
                if (_quantitycontroller!.text.toString() == "") {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Enter Quantity");
                  return;
                }
                if (_ratecontroller!.text.toString() == "") {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Enter Rate");
                  return;
                }
                if (selectedEditIndex == -1) {
                  WholesalerVisitProductModel p = WholesalerVisitProductModel();
                  p.productName = _productnamecontroller!.text.toString();
                  p.quantity =
                      double.parse(_quantitycontroller!.text.toString());
                  p.rate = double.parse(_ratecontroller!.text.toString());
                  competitorModel[currentMainIndex].products!.add(p);
                } else {
                  competitorModel[currentMainIndex]
                      .products![selectedEditIndex]
                      .productName = _productnamecontroller!.text.toString();
                  competitorModel[currentMainIndex]
                          .products![selectedEditIndex]
                          .quantity =
                      double.parse(_quantitycontroller!.text.toString());
                  competitorModel[currentMainIndex]
                      .products![selectedEditIndex]
                      .rate = double.parse(_ratecontroller!.text.toString());
                }
                Navigator.pop(context);
                selectedEditIndex = -1;
                _productnamecontroller!.text = "";
                _quantitycontroller!.text = "";
                _ratecontroller!.text = "";
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void showCustomSecondarySalesDialog(
    BuildContext context,
    messageValue,
    title,
    footerbutton, {
    bool? hideCancelBtn = false,
    String? successText = 'OK',
    Color? titleColor = Colors.white,
  }) {
    // set up the button

    // show the dialog
    // var mainContext=context;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // double itemRatePopup=0;
        return StatefulBuilder(builder: (ctx1, setState) {
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
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 350.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAutocomplete<OilType>(
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        _ssoiltypenamecontroller = fieldTextEditingController;
                        if (selectedOilType != null) {
                          _ssoiltypenamecontroller!.text =
                              selectedOilType!.name!;
                        }
                        return TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 0.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(borderRadiusTLBR),
                                      topRight:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomLeft:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomRight:
                                          Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(borderRadiusTLBR),
                                      topRight:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomLeft:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomRight:
                                          Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(borderRadiusTLBR),
                                      topRight:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomLeft:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomRight:
                                          Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              filled: true,
                              // hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "Oil Type",
                              labelStyle: TextStyle(
                                  color: labelTxtCol, fontSize: labelTxtSize),
                              fillColor: fillColor),
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          // style: const TextStyle(fontWeight: FontWeight.normal),
                        );
                      },
                      displayStringForOption: _displayStringForOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<OilType>.empty();
                        }
                        return oilTypeList.where((OilType option) {
                          return option.name
                              .toString()
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (OilType selection) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          selectedOilType = selection;
                        });
                        BlocProvider.of<DailySalesReportBloc>(context).add(
                            LoadSKUDetails(
                                oilTypeId: selectedOilType!.id!,
                                currentIndex: 0,
                                userId: Constants.AUTH_USERID));
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CustomAutocomplete<OilTypeSkuList>(
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        _ssskunamecontroller = fieldTextEditingController;
                        if (selectedSku != null) {
                          _ssskunamecontroller!.text =
                              selectedSku!.skuName!.toString();
                        }
                        return TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 0.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(borderRadiusTLBR),
                                      topRight:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomLeft:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomRight:
                                          Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(borderRadiusTLBR),
                                      topRight:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomLeft:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomRight:
                                          Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(borderRadiusTLBR),
                                      topRight:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomLeft:
                                          Radius.circular(borderRadiusTRBL),
                                      bottomRight:
                                          Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              filled: true,
                              // hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "SKU Name",
                              labelStyle: TextStyle(
                                  color: labelTxtCol, fontSize: labelTxtSize),
                              fillColor: fillColor),
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          // style: const TextStyle(fontWeight: FontWeight.normal),
                        );
                      },
                      displayStringForOption: _displaySkuStringForOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<OilTypeSkuList>.empty();
                        }
                        return skuList.where((OilTypeSkuList option) {
                          return option.skuName
                              .toString()
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (OilTypeSkuList selection) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          selectedSku = selection;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Quantity",
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
                        controllerTxt: _ssquantitycontroller,
                        keyborType: TextInputType.number,
                        onChanged: (String? value) {
                          setState(() {});
                        }),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Price",
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
                        controllerTxt: _ssratecontroller,
                        keyborType: TextInputType.number,
                        onChanged: (String? value) {
                          setState(() {});
                        }),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
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

  Widget dialogSSActionButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 2 - 67,
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
                selectedSSEditIndex = -1;
                selectedOilType = null;
                selectedSku = null;
                _ssquantitycontroller!.text = "";
                _ssratecontroller!.text = "";
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: screenWidth / 2 - 67,
            child: CommonButton(
              buttonName: "Save",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                if (selectedOilType == null) {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Select Oil Type");
                  return;
                }
                if (selectedSku == null) {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Select SKU");
                  return;
                }
                if (_ssquantitycontroller!.text.toString() == "") {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Enter Quantity");
                  return;
                }
                if (_ssratecontroller!.text.toString() == "") {
                  showSuccessDlg(context, "Error", "Error",
                      successText: "Enter Rate");
                  return;
                }
                if (selectedSSEditIndex == -1) {
                  WholesalerVisitSecondarySalesSkuModel p =
                      WholesalerVisitSecondarySalesSkuModel();
                  p.oilType = selectedOilType;
                  p.oilTypeSkuList = selectedSku;
                  p.quantity =
                      double.parse(_ssquantitycontroller!.text.toString());
                  p.rate = double.parse(_ssratecontroller!.text.toString());
                  skus!.add(p);
                } else {
                  skus![selectedSSEditIndex].oilType = selectedOilType;
                  skus![selectedSSEditIndex].oilTypeSkuList = selectedSku;
                  skus![selectedSSEditIndex].quantity =
                      double.parse(_ssquantitycontroller!.text.toString());
                  skus![selectedSSEditIndex].rate =
                      double.parse(_ssratecontroller!.text.toString());
                }
                Navigator.pop(context);
                selectedSSEditIndex = -1;
                selectedOilType = null;
                selectedSku = null;
                _ssquantitycontroller!.text = "";
                _ssratecontroller!.text = "";
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white,
      bool? closeScreen = false}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
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
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error"
                        ? const Icon(Icons.error_outlined,
                            size: 70, color: Colors.red)
                        : const Icon(Icons.check_circle_sharp,
                            size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title,
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  const SizedBox(height: 20),
                  const BorderBottom(bordeSize: 1)
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
                  Navigator.pop(context);
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

  void showConfirmDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
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

      // content: const Text("Confirm Price Discovery Request?"),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Icon(Icons.error_outlined,
                        size: 54, color: Constant.homeBoxPendingOrange),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Confirm Dealer Visit?',
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child:
                        Text('Are you sure you want to confirm dealer visit?',
                            style: TextStyle(
                              fontSize: Constant.fontSize14,
                            )),
                  ),
                  const SizedBox(height: 20),
                  const BorderBottom(bordeSize: 1)
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
                buttonName: "Cancel",
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.textFormFieldColor,
                buttonColor: Colors.white,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.black,
                buttonNameWeight: Constant.fontWeight500,
                buttonFunction: () {
                  Navigator.pop(context);
                }),
            CommonButton(
                buttonName: "Submit",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  if (_wholesalercontroller!.text.toString() == "") {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Enter Wholesaler name");
                    return;
                  }
                  WholesalerVisitRequest request = WholesalerVisitRequest();
                  request.bdoCompetitorAddDto = [];
                  request.wholeSellerSalesDetailDto = [];
                  request.createdBy = Constants.AUTH_USERID;
                  request.dealerId = widget.dealerId;
                  request.wholeSellerId = 0;
                  int i = 1;
                  for (WholesalerVisitCompetitorUIModel m in competitorModel) {
                    if (m.products!.isEmpty) {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Add SKU details for Competitor " + i.toString());
                      return;
                    }
                    if (m.fileList == null) {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Select File for Competitor " + i.toString());
                      return;
                    }
                    if (m.competitorName.text.toString() == "") {
                      showSuccessDlg(context, "Error", "Error",
                          successText: "Enter Competitor Name for Competitor " +
                              i.toString());
                      return;
                    }
                    BdoCompetitorAddDto comp = BdoCompetitorAddDto();
                    comp.fileList = m.fileList!;
                    comp.name = m.competitorName.text.toString();
                    comp.dealerId = widget.dealerId;
                    comp.remarks = m.competitorRemarks.text.toString();
                    comp.bdoCompetitorSkuDetails = [];
                    comp.userType = 1;
                    comp.isActive = true;
                    comp.competitorHeaderName =
                        "Competitor - " + (i).toString();
                    for (WholesalerVisitProductModel cm in m.products!) {
                      BdoCompetitorSkuDetails d = BdoCompetitorSkuDetails();
                      d.skuName = cm.productName;
                      d.price = cm.rate.toString();
                      d.quanityPerMt = cm.quantity.toString();
                      d.createdBy = Constants.AUTH_USERID;
                      comp.bdoCompetitorSkuDetails!.add(d);
                    }
                    request.bdoCompetitorAddDto!.add(comp);
                    i++;
                  }
                  for (WholesalerVisitSecondarySalesSkuModel s in skus!) {
                    WholeSellerSalesDetailDto ss = WholeSellerSalesDetailDto();
                    ss.skuName = s.oilTypeSkuList!.skuName;
                    ss.skuId = s.oilTypeSkuList!.skuId;
                    ss.oilType = s.oilType!.name;
                    ss.oilTypeId = s.oilType!.id;
                    ss.price = s.rate;
                    ss.quantityPerMt = s.quantity!.toInt();
                    request.wholeSellerSalesDetailDto!.add(ss);
                  }
                  BlocProvider.of<DailySalesReportBloc>(context)
                      .add(SaveWholesalerVisit(request: request));
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

  contBody() {}
  void addNewSKU() {
    WholesalerVisitCompetitorUIModel model = WholesalerVisitCompetitorUIModel();
    // WholesalerVisitProductModel cm = WholesalerVisitProductModel();
    model.products = [];
    model.fileList = [];
    // model.products!.add(cm);
    competitorModel.add(model);
    setState(() {});
  }
}

class WholesalerVisitCompetitorUIModel {
  TextEditingController competitorName = TextEditingController();
  TextEditingController competitorRemarks = TextEditingController();
  List<WholesalerVisitProductModel>? products;
  List<FileList>? fileList;
}

class WholesalerVisitProductModel {
  String? productName;
  double? quantity;
  double? rate;
}

class WholesalerVisitSecondarySalesSkuModel {
  OilType? oilType;
  OilTypeSkuList? oilTypeSkuList;
  double? quantity;
  double? rate;
}
