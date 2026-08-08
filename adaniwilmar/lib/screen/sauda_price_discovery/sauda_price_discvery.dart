import 'package:adaniwilmar/models/competitor_list.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/price_discovery_request.dart';
import 'package:adaniwilmar/screen/sauda/sauda_screen.dart';
import 'package:adaniwilmar/screen/sauda_price_discovery/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SaudaPriceDiscoveryScreen extends StatelessWidget {
  const SaudaPriceDiscoveryScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaPriceDiscoveryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaPriceDiscoveryBloc()
        ..add(LoadOilType(
            userId: Constants.AUTH_USERID,
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisonId: 0))
        ..add(LoadSaudaPriceDiscoveryScreen(
            userId: Constants.AUTH_USERID,
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisonId: 0)),
      //   ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
      // ..add(LoadOilType()),
      child: const SaudaPriceDiscovery(),
    );
  }
}

class SaudaPriceDiscovery extends StatefulWidget {
  const SaudaPriceDiscovery({Key? key}) : super(key: key);

  @override
  State<SaudaPriceDiscovery> createState() => _SaudaPriceDiscoveryState();
}

class _SaudaPriceDiscoveryState extends State<SaudaPriceDiscovery> {
  List<CompetitorList> competitorList = [];
  List<OilType> oilTypeList = [];
  List<PriceDiscoveryUIModel> skuModel = [];
  FocusNode myFocusNode = FocusNode();
  Widget listOfForm = Column(
    children: [
      HeadingSix(
        headingSix: Constant.homeTitle1,
        heaingSize: Constant.headingSix,
        headingWeight: Constant.fontWeight600,
        headingColor: Constant.colorBlack,
      ),
      const SizedBox(height: 16),
      CommonDropDown(
          itemsList: const ["Palm"],
          borderRadiusTLBR: 10.0,
          borderRadiusTRBL: 5.0,
          borderColor: Constant.pricDisBocolor,
          labelTxt: Constant.pricDisTitle1,
          txtLabe: "Palm",
          fillColor: Constant.pricFIledCOl,
          labelTxtCol: Constant.pricTxtCOl,
          labelTxtSize: Constant.pricTxtCOlSize),
      const SizedBox(height: 16.0),
      CommonTextFormField(
        labeltxt: Constant.pricSkuName,
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
      ),
      const SizedBox(height: 16.0),
      CommonDropDown(
          itemsList: const ["222"],
          borderRadiusTLBR: 10.0,
          borderRadiusTRBL: 5.0,
          borderColor: Constant.pricDisBocolor,
          labelTxt: Constant.pricDisTitle2,
          txtLabe: "222",
          fillColor: Constant.pricFIledCOl,
          labelTxtCol: Constant.pricTxtCOl,
          labelTxtSize: Constant.pricTxtCOlSize),
      const SizedBox(height: 16.0),
      CommonDropDown(
          itemsList: const ["586"],
          borderRadiusTLBR: 10.0,
          borderRadiusTRBL: 5.0,
          borderColor: Constant.pricDisBocolor,
          labelTxt: Constant.pricDisTitle3,
          txtLabe: "586",
          fillColor: Constant.pricFIledCOl,
          labelTxtCol: Constant.pricTxtCOl,
          labelTxtSize: Constant.pricTxtCOlSize),
      const SizedBox(height: 16.0),
      CommonDropDown(
          itemsList: const ["580"],
          borderRadiusTLBR: 10.0,
          borderRadiusTRBL: 5.0,
          borderColor: Constant.pricDisBocolor,
          labelTxt: Constant.pricDisTitle4,
          txtLabe: "580",
          fillColor: Constant.pricFIledCOl,
          labelTxtCol: Constant.pricTxtCOl,
          labelTxtSize: Constant.pricTxtCOlSize),
      const SizedBox(height: 16.0),
      CommonDropDown(
          itemsList: const ["AWL"],
          borderRadiusTLBR: 10.0,
          borderRadiusTRBL: 5.0,
          borderColor: Constant.pricDisBocolor,
          labelTxt: Constant.pricDisTitle5,
          txtLabe: "AWL",
          fillColor: Constant.pricFIledCOl,
          labelTxtCol: Constant.pricTxtCOl,
          labelTxtSize: Constant.pricTxtCOlSize),
      const SizedBox(height: 16.0),
      CommonDropDown(
          itemsList: const ["AWL"],
          borderRadiusTLBR: 10.0,
          borderRadiusTRBL: 5.0,
          borderColor: Constant.pricDisBocolor,
          labelTxt: Constant.pricDisTitle6,
          txtLabe: "AWL",
          fillColor: Constant.pricFIledCOl,
          labelTxtCol: Constant.pricTxtCOl,
          labelTxtSize: Constant.pricTxtCOlSize),
    ],
  );
  int selected = 0 - 1;
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

    return BlocListener<SaudaPriceDiscoveryBloc, SaudaPriceDiscoveryState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            competitorList = state.competitorList;
            addNewSKU();
            setState(() {});
          }
          // if (state is OnLoadSalesOrganization) {
          //   salesOrgList = state.salesOrganization;
          //   setState(() {
          //
          //   });
          // }
          // if (state is OnLoadDealerSaudaDetail) {
          //   selectedSKU = null;
          //   pSelectedSKU=null;
          //   saudaDetail = state.dealerSaudaDetail;
          //   selectedIncoTerms = null;
          //   incoTerms = state.dealerSaudaDetail.incoTermList!;
          //   selectedPlant = null;
          //   plants = state.dealerSaudaDetail.plantDepotListNew!;
          //   selectedBroker = null;
          //   brokerList = state.dealerSaudaDetail.brokerList!;
          //   if (state.dealerSaudaDetail.saudaValidityPeriod != null) {
          //     toDate = DateTimeUtils().dateToStringFormat(
          //         DateTime.now().add(Duration(
          //             days: state.dealerSaudaDetail.saudaValidityPeriod!)),
          //         DateTimeUtils.DD_MM_YYYY_Format);
          //   }
          //   _fromdatecontroller.text = fromDate;
          //   _todatecontroller.text = toDate;
          //   _pfromdatecontroller.text = fromDate;
          //   _ptodatecontroller.text = toDate;
          //   setState(() {});
          // }
          if (state is OnLoadSKUDetails) {
            skuModel[state.currentIndex].sku = null;
            skuModel[state.currentIndex].skuList = state.skuList;
            setState(() {});
          }
          //
          // if (state is OnLoadDistributionChannel) {
          //   selectedDistrChannel=null;
          //   distrChannels = state.distributionChannel;
          //   setState(() {});
          // }
          // // if (state is OnLoadIncoTerms) {
          // //   incoTerms = state.incoTerms;
          // //   setState(() {});
          // // }
          // if (state is OnLoadVerticalList) {
          //   selectedVertical=null;
          //   pSelectedOilType=null;
          //   selectedOilType=null;
          //   selectedDistributor=null;
          //   verticals = state.verticalList;
          //   setState(() {});
          // }
          // // if (state is OnLoadPlant) {
          // //   selectedPlant=null;
          // //   plants = state.plantList;
          // //   setState(() {});
          // // }
          if (state is OnLoadOilType) {
            oilTypeList = state.oilTypes;
            setState(() {});
          }
          if (state is OnSavePriceDiscovery) {
            showSuccessDlg(context, "Price Discovery", "Success",
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
          // if (state is OnRateChange) {
          //   if(state.change){
          //     itemRatePopup = pSelectedSKU!.price!;
          //   }else {
          //     itemRate = selectedSKU!.price!;
          //   }
          //   setState(() {});
          // }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
              title: "Price Discovery",
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
              GestureDetector(
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(height: Constant.containerTopWrapper),
                      CurveOuterBox(
                          boxLRPadding: 8,
                          boxTBPadding: 4,
                          boxofWidget: ListView.builder(
                              key: const Key('builder1'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: skuModel.length,
                              itemBuilder: (context, index) {
                                return CurveOuterBox(
                                    boxLRPadding: 10,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.zero,
                                        key: Key(index.toString()),
                                        initiallyExpanded: index == selected,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 34,
                                              color: Constant.callToCcolor1,
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: CommonText(
                                                      name: "SKU " +
                                                          (index + 1)
                                                              .toString(),
                                                      fontSize:
                                                          Constant.fontSize15,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                    ))),
                                            Visibility(
                                                visible: index > 0,
                                                child: InkWell(
                                                    onTap: () {
                                                      skuModel.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: SizedBox(
                                                              width: 25,
                                                              height: 25,
                                                              child: Icon(
                                                                  Icons.delete,
                                                                  color: Constant
                                                                      .colorGray45)),
                                                        ))))
                                          ],
                                        ),
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text("")),
                                              StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return SizedBox(
                                                    width: double.infinity,
                                                    //height: 70,
                                                    child:
                                                        CommonDropdownButtonFormField<OilType>(
                                                      value: skuModel[index].oilType,
                                                      label: "Oil Type",
                                                      onChanged:
                                                          (OilType? newValue) {
                                                        setState(() {
                                                          skuModel[index]
                                                                  .oilType =
                                                              newValue!;
                                                        });
                                                        BlocProvider.of<
                                                                    SaudaPriceDiscoveryBloc>(
                                                                context)
                                                            .add(LoadSKUDetails(
                                                                userId:
                                                                    Constants
                                                                         .AUTH_USERID,
                                                                oilTypeId:
                                                                    skuModel[
                                                                            index]
                                                                        .oilType!
                                                                        .id!,
                                                                currentIndex:
                                                                    index));
                                                      },
                                                      items: oilTypeList.map<
                                                              DropdownMenuItem<
                                                                  OilType>>(
                                                          (value) {
                                                        return DropdownMenuItem<
                                                            OilType>(
                                                          value: value,
                                                          child:
                                                              Text(value.name!),
                                                        );
                                                      }).toList(),
                                                    ));
                                              }),
                                              const SizedBox(height: 16.0),
                                              SizedBox(
                                                  width: double.infinity,
                                                  //height: 70,
                                                  child:
                                                      CommonDropdownButtonFormField<OilTypeSkuList>(
                                                    value: skuModel[index].sku,
                                                    label: "SKU Name",
                                                    onChanged: (OilTypeSkuList?
                                                        newValue) {
                                                      skuModel[index].sku =
                                                          newValue!;
                                                      setState(() {});
                                                    },
                                                    items: skuModel[index]
                                                        .skuList!
                                                        .map<
                                                                DropdownMenuItem<
                                                                    OilTypeSkuList>>(
                                                            (value) {
                                                      return DropdownMenuItem<
                                                          OilTypeSkuList>(
                                                        value: value,
                                                        child: Text(
                                                            value.skuName!,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible),
                                                      );
                                                    }).toList(),
                                                  )),
                                              // StatefulBuilder(builder:
                                              //     (BuildContext context, StateSetter setState) {
                                              //   return
                                              // }),
                                              const SizedBox(height: 16),
                                              CommonTextFormField(
                                                  labeltxt: "Adani Quantity",
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
                                                  controllerTxt: skuModel[index]
                                                      .workableQuantity,
                                                  keyborType:
                                                      TextInputType.number,
                                                  onChanged: (String? value) {
                                                    setState(() {});
                                                  }),
                                              const SizedBox(height: 16.0),
                                              CommonTextFormField(
                                                  labeltxt: "Adani Price",
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
                                                      skuModel[index].price,
                                                  keyborType:
                                                      TextInputType.number,
                                                  onChanged: (String? value) {
                                                    setState(() {});
                                                  }),
                                              const SizedBox(height: 16),
                                              CommonTextFormField(
                                                  labeltxt: "Workable Price",
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
                                                  controllerTxt: skuModel[index]
                                                      .workbalePrice,
                                                  keyborType:
                                                      TextInputType.number,
                                                  onChanged: (String? value) {
                                                    setState(() {});
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          CommonText(
                                            name: "Competitors",
                                            fontSize: Constant.fontSize13,
                                            fontColor: Constant.colorBlack,
                                          ),
                                          const BorderBottom(),
                                          const SizedBox(height: 16),
                                          ListView.builder(
                                              key: Key('builder_' +
                                                  index.toString()), //attention
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: skuModel[index]
                                                  .competitors!
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.all(0),
                                                    title: CurveOuterBox(
                                                      boxBorderColor:
                                                          const Color(
                                                              0xFFE7E7E7),
                                                      boxShadowColor:
                                                          const Color(
                                                              0xFFFFFFFF),
                                                      boxBorderWidth: 0,
                                                      boxLRPadding: 0,
                                                      boxTBPadding: 0,
                                                      boxBRRadius: 5,
                                                      boxofWidget: Column(
                                                        children: [
                                                          Visibility(
                                                              visible: ind > 0,
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    skuModel[
                                                                            index]
                                                                        .competitors!
                                                                        .removeAt(
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
                                                                  ))),
                                                          StatefulBuilder(builder:
                                                              (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                //height: 70,
                                                                child: CommonDropdownButtonFormField<
                                                                    CompetitorList>(
                                                                  value: skuModel[
                                                                          index]
                                                                      .competitors![
                                                                          ind]
                                                                      .competitor,
                                                                  label: "Competitor",
                                                                  onChanged:
                                                                      (CompetitorList?
                                                                          newValue) {
                                                                    skuModel[
                                                                            index]
                                                                        .competitors![
                                                                            ind]
                                                                        .competitor = newValue!;
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  items: competitorList.map<
                                                                          DropdownMenuItem<
                                                                              CompetitorList>>(
                                                                      (value) {
                                                                    return DropdownMenuItem<
                                                                        CompetitorList>(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value
                                                                              .name!,
                                                                          overflow:
                                                                              TextOverflow.visible),
                                                                    );
                                                                  }).toList(),
                                                                ));
                                                          }),
                                                          const SizedBox(
                                                              height: 16),
                                                          CommonTextFormField(
                                                              labeltxt:
                                                                  "Workable Price",
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
                                                              borderRadiusTL:
                                                                  Constant
                                                                      .textFormborderRadiusTL,
                                                              borderRadiusBR:
                                                                  Constant
                                                                      .textFormborderRadiusBR,
                                                              contentPadHor:
                                                                  Constant
                                                                      .textFormcontentPadHor,
                                                              contentPadHVer:
                                                                  Constant
                                                                      .textFormcontentPadHVer,
                                                              controllerTxt: skuModel[
                                                                      index]
                                                                  .competitors![
                                                                      ind]
                                                                  .marketOperatingPrice,
                                                              keyborType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {});
                                                              }),
                                                          const SizedBox(
                                                              height: 16.0),
                                                          CommonTextFormField(
                                                              labeltxt:
                                                                  "Sauda Rate",
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
                                                              borderRadiusTL:
                                                                  Constant
                                                                      .textFormborderRadiusTL,
                                                              borderRadiusBR:
                                                                  Constant
                                                                      .textFormborderRadiusBR,
                                                              contentPadHor:
                                                                  Constant
                                                                      .textFormcontentPadHor,
                                                              contentPadHVer:
                                                                  Constant
                                                                      .textFormcontentPadHVer,
                                                              controllerTxt:
                                                                  skuModel[
                                                                          index]
                                                                      .competitors![
                                                                          ind]
                                                                      .saudaRate,
                                                              keyborType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {});
                                                              }),
                                                          const SizedBox(
                                                              height: 16.0),
                                                          Visibility(
                                                              visible: ind <
                                                                  skuModel[index]
                                                                          .competitors!
                                                                          .length -
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
                                                PriceDiscoveryCompetitorModel
                                                    cm =
                                                    PriceDiscoveryCompetitorModel();
                                                skuModel[index]
                                                    .competitors!
                                                    .add(cm);
                                                setState(() {});
                                              },
                                              icon: SizedBox(
                                                width: 30.0,
                                                height: 30.0,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                  padding:
                                                      const EdgeInsets.all(7),
                                                  child: Icon(
                                                      Constant.saudaIcPlus),
                                                ),
                                              ),
                                            ),
                                            const Text("Add another competitor")
                                          ]),
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
                              })),
                      // CurveOuterBox(boxofWidget: listOfForm),
                    ],
                  )),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }),
              progressBar
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonButton(
              buttonName: Constant.pricButtonName,
              buttonNameSize: Constant.pricbuttonNameSize,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: Constant.pricbuttonHeight,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                showConfirmDlg(context, "Confirm Price Discovery Request",
                    "Confirm Request");
              },
            ),
          ),
        )));
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white,
      bool? closeScreen = false}) {
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
      content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error"
                        ? Icon(Icons.error_outlined,
                            size: 70, color: Colors.red)
                        : Icon(Icons.check_circle_sharp,
                            size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title,
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  SizedBox(height: 20),
                  BorderBottom(bordeSize: 1)
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SaudaScreen()),
                  );
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
      content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Icon(Icons.error_outlined,
                        size: 54, color: Constant.homeBoxPendingOrange),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Confirm Price Discovery Request?',
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        'Are you sure you want to confirm price discovery request?',
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  SizedBox(height: 20),
                  BorderBottom(bordeSize: 1)
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
                  PriceDiscoveryRequest request = PriceDiscoveryRequest();
                  request.competitorAnalysisList = [];
                  int i = 1;
                  for (PriceDiscoveryUIModel m in skuModel) {
                    if (m.competitors!.isEmpty) {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Add competitor details for SKU " + i.toString());
                      return;
                    }
                    if (m.sku == null) {
                      showSuccessDlg(context, "Error", "Error",
                          successText: "Select SKU in SKU " + i.toString());
                      return;
                    }
                    if (m.oilType == null) {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Select Oil Type in SKU " + i.toString());
                      return;
                    }
                    if (m.workbalePrice.text.toString() == "") {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Enter Workable Price in SKU " + i.toString());
                      return;
                    }
                    if (m.price.text.toString() == "") {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Enter Adani Price in SKU " + i.toString());
                      return;
                    }
                    if (m.workableQuantity.text.toString() == "") {
                      showSuccessDlg(context, "Error", "Error",
                          successText:
                              "Enter Adani Quantity in SKU " + i.toString());
                      return;
                    }
                    for (PriceDiscoveryCompetitorModel cm in m.competitors!) {
                      if (cm.competitor == null) {
                        showSuccessDlg(context, "Error", "Error",
                            successText:
                                "Select Competitor in SKU " + i.toString());
                        return;
                      }
                      if (cm.saudaRate.text.toString() == "") {
                        showSuccessDlg(context, "Error", "Error",
                            successText:
                                "Enter Sauda Rate in SKU " + i.toString());
                        return;
                      }
                      if (cm.marketOperatingPrice.text.toString() == "") {
                        showSuccessDlg(context, "Error", "Error",
                            successText:
                                "Enter Workable Price in SKU " + i.toString());
                        return;
                      }
                    }
                    CompetitorAnalysisList comp = CompetitorAnalysisList();
                    comp.loginUserId = Constants.AUTH_USERID;
                    comp.skuId = m.sku!.skuId!;
                    comp.oilTypeId = m.oilType!.id!;
                    comp.workableQuantity =
                        double.parse(m.workableQuantity.text.toString());
                    comp.emamiPrice = double.parse(m.price.text.toString());
                    comp.workablePrice =
                        double.parse(m.workbalePrice.text.toString());
                    comp.competitorAnalysisDetailsList = [];
                    for (PriceDiscoveryCompetitorModel cm in m.competitors!) {
                      CompetitorAnalysisDetailsList d =
                          CompetitorAnalysisDetailsList();
                      d.competitorId = cm.competitor!.competitorId;
                      d.competitorName = cm.competitor!.name;
                      d.marketOperatingPrice =
                          double.parse(cm.marketOperatingPrice.text.toString());
                      d.saudaRate = double.parse(cm.saudaRate.text.toString());
                      comp.competitorAnalysisDetailsList!.add(d);
                    }
                    request.competitorAnalysisList!.add(comp);
                    i++;
                  }
                  BlocProvider.of<SaudaPriceDiscoveryBloc>(context)
                      .add(SavePriceDiscovery(request: request));
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
    PriceDiscoveryUIModel model = PriceDiscoveryUIModel();
    model.skuList = [];
    model.competitors = [];
    PriceDiscoveryCompetitorModel cm = PriceDiscoveryCompetitorModel();
    model.competitors!.add(cm);
    skuModel.add(model);
    setState(() {});
  }
}

class PriceDiscoveryUIModel {
  List<PriceDiscoveryCompetitorModel>? competitors;
  OilType? oilType;
  OilTypeSkuList? sku;
  List<OilTypeSkuList>? skuList;
  TextEditingController price = TextEditingController();
  TextEditingController workableQuantity = TextEditingController();
  TextEditingController workbalePrice = TextEditingController();
}

class PriceDiscoveryCompetitorModel {
  CompetitorList? competitor;
  TextEditingController marketOperatingPrice = TextEditingController();
  TextEditingController saudaRate = TextEditingController();
}
