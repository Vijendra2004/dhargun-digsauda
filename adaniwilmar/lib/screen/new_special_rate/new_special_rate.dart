import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/new_special_rate/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda/sauda_screen.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class NewSpecialRateScreen extends StatelessWidget {
  const NewSpecialRateScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const NewSpecialRateScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewSpecialRateBloc()
        // ..add(LoadNewSpecialRateScreen(userId: Constants.AUTH_USERID))
        ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
        // ..add(LoadOilType()),
      child: NewSpecialRateForm(),
    );
  }
}

class NewSpecialRateForm extends StatefulWidget {
  NewSpecialRateForm({Key? key}) : super(key: key);
  int? selectedDiscountType = 0;
  @override
  State<NewSpecialRateForm> createState() => _NewSpecialRateFormState();
}

class _NewSpecialRateFormState extends State<NewSpecialRateForm> {
  List<DistributorList> distributorList = [];
  List<SKUPricing> skuList = [];
  List<SKUPricing> popupSkuList = [];
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<IncoTermList> incoTerms = [];
  List<PlanDepotList> plants = [];
  List<DailyRate> dailyRates = [];
  List<OilType> oilTypes = [];
  List<BrokerList> brokerList = [];
  DealerSaudaDetail saudaDetail = DealerSaudaDetail();
  final TextEditingController _releasedratecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _requestedratecontroller = TextEditingController();

  final TextEditingController _preleasedratecontroller = TextEditingController();
  final TextEditingController _pquantitycontroller = TextEditingController();
  final TextEditingController _prequestedratecontroller = TextEditingController();

  SKUPricing? selectedSKU;
  DistributorList? selectedDistributor;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  IncoTermList? selectedIncoTerms;
  PlanDepotList? selectedPlant;
  OilType? selectedOilType;
  BrokerList? selectedBroker;
  List<SpecialRateApproval> specialRateSku = [];
  double itemRate=0;
  double itemRatePopup=0;
  double itemMaxDiscount=0;
  double itemMaxPremium=0;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0;
  double screenHeight = 0;
  String fromDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = "";
  double rate = 0;
  double finalRate = 0;
  static String _displayStringForOption(DistributorList option) =>
      option.employeeName!;
  static String _displayStringForSkuOption(SKUPricing option) =>
      option.skuName!;
  static String _displayStringForOilTypeOption(OilType option) =>
      option.name!;

  final TextEditingController _pfromdatecontroller = TextEditingController();
  final TextEditingController _ptodatecontroller = TextEditingController();
  TextEditingController? _skunamecontroller;
  TextEditingController? _distributorcontroller;
  TextEditingController? _oiltypecontroller;

  TextEditingController? _popupskunamecontroller;
  TextEditingController? _popupoiltypecontroller;

  SKUPricing? pSelectedSKU;
  OilType? pSelectedOilType;
  int? pSelectedDiscountType = 1;
  late final GlobalKey<FormFieldState> _skuKey=GlobalKey();
  int selectedEditIndex=-1;
  ProgressBarHandler? _handler;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
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
    return BlocListener<NewSpecialRateBloc, NewSpecialRateState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            selectedDistributor=null;
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            setState(() {

            });
          }
          if (state is OnLoadDealerSaudaDetail) {
            selectedSKU = null;
            _skunamecontroller!.text="";
            pSelectedSKU=null;
            saudaDetail = state.dealerSaudaDetail;
            selectedIncoTerms = null;
            incoTerms = state.dealerSaudaDetail.incoTermList!;
            selectedPlant = null;
            plants = state.dealerSaudaDetail.plantDepotListNew!;
            selectedBroker = null;
            brokerList = state.dealerSaudaDetail.brokerList!;
            if (state.dealerSaudaDetail.saudaValidityPeriod != null) {
              toDate = DateTimeUtils().dateToStringFormat(
                  DateTime.now().add(Duration(
                      days: state.dealerSaudaDetail.saudaValidityPeriod!)),
                  DateTimeUtils.DD_MM_YYYY_Format);
            }
            _pfromdatecontroller.text = fromDate;
            _ptodatecontroller.text = toDate;
            setState(() {});
          }
          if (state is OnLoadSKUDetails) {
            if(state.isPopup){
              pSelectedSKU=null;
              popupSkuList = state.skuList;
            }else {
              selectedSKU = null;
              _skunamecontroller!.text="";
              skuList = state.skuList;
            }
            setState(() {});
          }

          if (state is OnLoadDistributionChannel) {
            selectedDistrChannel=null;
            distrChannels = state.distributionChannel;
            setState(() {});
          }
          // if (state is OnLoadIncoTerms) {
          //   incoTerms = state.incoTerms;
          //   setState(() {});
          // }
          if (state is OnLoadVerticalList) {
            selectedVertical=null;
            pSelectedOilType=null;
            selectedOilType=null;
            selectedDistributor=null;
            _distributorcontroller!.text="";
            _oiltypecontroller!.text="";
            verticals = state.verticalList;
            setState(() {});
          }
          // if (state is OnLoadPlant) {
          //   selectedPlant=null;
          //   plants = state.plantList;
          //   setState(() {});
          // }
          if (state is OnLoadOilType) {
            pSelectedOilType=null;
            selectedOilType=null;
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if(state is OnSaveSpecialRate){
              showSuccessDlg(context, "Request Confirmed", "Success",successText: state.response);
          }
          if(state is OnFailure){
            showSuccessDlg(context, "Error", "Error",successText: state.error);
          }
          if (state is OnRateChange) {
            if(state.change){
              itemRatePopup = pSelectedSKU!.price!;
            }else {
              itemRate = selectedSKU!.price!;
            }
            setState(() {});
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: SafeArea(child:Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
              title: "New Special Rate",
              backArrow: true,
              listOfActions: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if(selectedIncoTerms==null){
                        showSuccessDlg(context, "Error", "Error",successText: "Select IncoTerms from the list");
                        return;
                      }
                      if(selectedOilType==null){
                        showSuccessDlg(context, "Error", "Error",successText: "Select OilType from the list");
                        return;
                      }
                      if(selectedPlant==null){
                        showSuccessDlg(context, "Error", "Error",successText: "Select Plant from the list");
                        return;
                      }
                      if(selectedSKU==null){
                        showSuccessDlg(context, "Error", "Error",successText: "Select SKU from the list");
                        return;
                      }
                      if(_quantitycontroller.text.toString()==""){
                        showSuccessDlg(context, "Error", "Error",successText: "Enter Sauda Quantity");
                        return;
                      }
                      if(_requestedratecontroller.text.toString()==""){
                        showSuccessDlg(context, "Error", "Error",successText: "Enter Requested Price");
                        return;
                      }
                      if(specialRateSku.isEmpty){
                        SpecialRateApproval order = SpecialRateApproval();
                        order.salesOrganizationId=selectedSalesOrg!.id!;
                        order.distributionChannelId=selectedDistrChannel!.id!;
                        order.divisionId=selectedVertical!.id!;
                        order.incotermsId = selectedIncoTerms!.id;
                        order.skuId = selectedSKU!.skuId;
                        order.skuName = selectedSKU!.skuName;
                        order.oilTypeId = selectedOilType!.id;
                        order.plantId = selectedPlant!.id;
                        order.quantity =
                            double.parse(_quantitycontroller.text.toString());
                        order.finalPrice = selectedSKU!.price!;
                        order.pricingId = selectedSKU!.pricingId;
                        order.specialPrice = double.parse(_requestedratecontroller.text.toString());
                        order.userId=selectedDistributor!.id!;
                        order.loginUserId=Constants.AUTH_USERID;
                        specialRateSku.add(order);
                        setState(() {

                        });
                      }
                      itemRatePopup=0;
                      pSelectedSKU=null;
                      pSelectedOilType=null;
                      _preleasedratecontroller.text="";
                      _prequestedratecontroller.text="";
                      _pquantitycontroller.text="";
                      selectedEditIndex=-1;
                      showCustomAlertDialog(context, contBody(), 'Add Item',
                          dialogActionButton(),
                          hideCancelBtn: true);
                    },
                    icon: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(30))),
                        padding: const EdgeInsets.all(2),
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
              GestureDetector(child:Container(
                  margin: const EdgeInsets.only(top: 60,left: 8,right: 8),
                  height: screenHeight*0.950,
                  child:SingleChildScrollView(
                    controller: _controller,
                      child:
                  CurveBorderBox(
                      boxLRPadding: 11,
                      boxofWidget: SingleChildScrollView(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: CommonDropdownButtonFormField<SalesOrganization>(
                                      value: selectedSalesOrg,
                                      label: "Sales Organization",
                                      onChanged: (SalesOrganization? newValue) {
                                        setState(() {
                                          selectedSalesOrg = newValue!;
                                        });
                                        BlocProvider.of<NewSpecialRateBloc>(context).add(
                                            LoadDistributionChannel(
                                                id: selectedSalesOrg!.id!));
                                      },
                                      items: salesOrgList
                                          .map<DropdownMenuItem<SalesOrganization>>(
                                              (value) {
                                            return DropdownMenuItem<SalesOrganization>(
                                              value: value,
                                              child: Text(value.salesOrganizationName!),
                                            );
                                          }).toList(),
                                    ));
                              }),
                              const SizedBox(height: 16),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    //height: 70,
                                    child: CommonDropdownButtonFormField<DistributionChannel>(
                                      value: selectedDistrChannel,
                                      label: "Distribution Channel",
                                      onChanged: (DistributionChannel? newValue) {
                                        setState(() {
                                          selectedDistrChannel = newValue!;
                                        });
                                        BlocProvider.of<NewSpecialRateBloc>(context).add(
                                            LoadVerticalList(
                                                distributionId:
                                                selectedDistrChannel!.id!));
                                      },
                                      items: distrChannels
                                          .map<DropdownMenuItem<DistributionChannel>>(
                                              (value) {
                                            return DropdownMenuItem<DistributionChannel>(
                                              value: value,
                                              child: Text(value.distributionChannelName!),
                                            );
                                          }).toList(),
                                    ));
                              }),
                              const SizedBox(height: 16.0),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    //height: 70,
                                    child: CommonDropdownButtonFormField<Vertical>(
                                      value: selectedVertical,
                                      label: "Division",
                                      onChanged: (Vertical? newValue) {
                                        setState(() {
                                          selectedVertical = newValue!;
                                        });
                                        BlocProvider.of<NewSpecialRateBloc>(context).add(LoadNewSpecialRateScreen(userId: Constants.AUTH_USERID,
                                            salesOrganizationId: selectedSalesOrg!.id!,
                                            distributionChannelId: selectedDistrChannel!.id!,
                                            divisonId: selectedVertical!.id!));
                                        BlocProvider.of<NewSpecialRateBloc>(context).add(LoadOilType(userId: Constants.AUTH_USERID,
                                            salesOrganizationId: selectedSalesOrg!.id!,
                                            distributionChannelId: selectedDistrChannel!.id!,
                                            divisonId: selectedVertical!.id!));
                                      },
                                      items: verticals
                                          .map<DropdownMenuItem<Vertical>>((value) {
                                        return DropdownMenuItem<Vertical>(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                    ));
                              }),
                              const SizedBox(height: 16),
                              // StatefulBuilder(builder:
                              //     (BuildContext context, StateSetter setState) {
                              //   return SizedBox(
                              //       width: double.infinity,
                              //       // height: 70,
                              //       child: CommonDropdownButtonFormField<DistributorList>(
                              //         isExpanded: true,
                              //         value: selectedDistributor,
                              //         icon: const Align(
                              //             alignment: Alignment.topRight,
                              //             child: Icon(
                              //               Icons.keyboard_arrow_down,
                              //               size: 24,
                              //             )),
                              //         elevation: 16,
                              //         style: const TextStyle(color: Colors.black),
                              //         decoration: InputDecoration(
                              //             contentPadding: const EdgeInsets.symmetric(
                              //                 horizontal: 12.0, vertical: 0.0),
                              //             focusedBorder: OutlineInputBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(
                              //                         borderRadiusTLBR),
                              //                     topRight: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomLeft: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomRight: Radius.circular(
                              //                         borderRadiusTLBR)),
                              //                 borderSide: BorderSide(
                              //                     color: borderColor!, width: 1.0)),
                              //             border: OutlineInputBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(
                              //                         borderRadiusTLBR),
                              //                     topRight: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomLeft: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomRight:
                              //                     Radius.circular(borderRadiusTLBR)),
                              //                 borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              //             filled: true,
                              //             // hintStyle: TextStyle(color: Colors.grey[800]),
                              //             labelText: "Distributor",
                              //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                              //             fillColor: fillColor),
                              //         onChanged: (DistributorList? newValue) {
                              //           setState(() {
                              //             selectedDistributor = newValue!;
                              //           });
                              //           BlocProvider.of<NewSpecialRateBloc>(context).add(
                              //               LoadDealerSaudaDetail(
                              //                   id: selectedDistributor!.id!,
                              //                   saudaBookingTypeId: selectedDistributor!
                              //                       .saudaBookingTypeId!,
                              //                   salesOrganizationId: selectedSalesOrg!.id!,
                              //                   distributionChannelId: selectedDistrChannel!.id!,
                              //                   divisionId: selectedVertical!.id!));
                              //         },
                              //         items: distributorList
                              //             .map<DropdownMenuItem<DistributorList>>(
                              //                 (value) {
                              //               return DropdownMenuItem<DistributorList>(
                              //                 value: value,
                              //                 child: Text(value.employeeName!,overflow: TextOverflow.visible),
                              //               );
                              //             }).toList(),
                              //       ));
                              // }),
                              CustomAutocomplete<DistributorList>(
                                fieldViewBuilder: (
                                    BuildContext context,
                                    TextEditingController fieldTextEditingController,
                                    FocusNode fieldFocusNode,
                                    VoidCallback onFieldSubmitted
                                    ) {
                                  _distributorcontroller=fieldTextEditingController;
                                  return TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    decoration:InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 10.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    borderRadiusTLBR),
                                                topRight: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomLeft: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomRight: Radius.circular(
                                                    borderRadiusTLBR)),
                                            borderSide: BorderSide(
                                                color: borderColor!, width: 1.0)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    borderRadiusTLBR),
                                                topRight: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomLeft: Radius.circular(borderRadiusTRBL),
                                                bottomRight: Radius.circular(borderRadiusTLBR)),
                                            borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                        filled: true,
                                        // hintStyle: TextStyle(color: Colors.grey[800]),
                                        labelText: "Distributor Name",
                                        labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                        fillColor: fillColor),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    // style: const TextStyle(fontWeight: FontWeight.normal),
                                  );
                                },
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<DistributorList>.empty();
                                  }
                                  return distributorList.where((DistributorList option) {
                                    return option.employeeName
                                        .toString().toLowerCase()
                                        .contains(textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (DistributorList selection) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    setState(() {
                                      selectedDistributor = selection;
                                    });
                                    BlocProvider.of<NewSpecialRateBloc>(context).add(
                                        LoadDealerSaudaDetail(
                                            id: selectedDistributor!.id!,
                                            saudaBookingTypeId: selectedDistributor!
                                                .saudaBookingTypeId!,
                                            salesOrganizationId: selectedSalesOrg!.id!,
                                            distributionChannelId: selectedDistrChannel!.id!,
                                            divisionId: selectedVertical!.id!));

                                },
                              ),
                              const SizedBox(height: 16),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    //height: 70,
                                    child: CommonDropdownButtonFormField<BrokerList>(
                                      value: selectedBroker,
                                      label: "Broker",
                                      onChanged: (BrokerList? newValue) {
                                        setState(() {
                                          selectedBroker = newValue!;
                                        });
                                      },
                                      items: brokerList
                                          .map<DropdownMenuItem<BrokerList>>((value) {
                                        return DropdownMenuItem<BrokerList>(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                    ));
                              }),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CurveBox(
                                      boxSize: 2,
                                      miniusValue: 27,
                                      boxHeight: 76,
                                      boxColor: Constant.saudaLETBoxColor1,
                                      headingTxt: Constant.saudaLETBox1Txt1,
                                      subHeading: (saudaDetail.availableSaudaLimit != null
                                          ? saudaDetail.availableSaudaLimit.toString()
                                          : "0")+" MT",
                                      headingFontSize: Constant.fontSize13,
                                      subHeadingFontSize: Constant.fontSize14,
                                      subhHadingFontWeight: FontWeight.w600),
                                  const SizedBox(width: 13),
                                  CurveBox(
                                      boxSize: 2,
                                      miniusValue: 30,
                                      boxHeight: 76,
                                      boxColor: Constant.saudaLETBoxColor2,
                                      headingTxt: Constant.saudaLETBox2Txt2,
                                      subHeading: (saudaDetail.totalSaudaLimit != null
                                          ? saudaDetail.totalSaudaLimit.toString()
                                          : "0")+" MT",
                                      headingFontSize: Constant.fontSize13,
                                      subHeadingFontSize: Constant.fontSize16,
                                      subhHadingFontWeight: FontWeight.w600)
                                ],
                              ),
                              const SizedBox(height: 16),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    //height: 70,
                                    child: CommonDropdownButtonFormField<IncoTermList>(
                                      value: selectedIncoTerms,
                                      label: "Incoterm",
                                      onChanged: (IncoTermList? newValue) {
                                        setState(() {
                                          selectedIncoTerms = newValue!;
                                        });
                                      },
                                      items: incoTerms
                                          .map<DropdownMenuItem<IncoTermList>>((value) {
                                        return DropdownMenuItem<IncoTermList>(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                    ));
                              }),
                              const SizedBox(height: 16.0),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    //height: 70,
                                    child: CommonDropdownButtonFormField<PlanDepotList>(
                                      value: selectedPlant,
                                      label: "Plant",
                                      onChanged: (PlanDepotList? newValue) {
                                        setState(() {
                                          selectedPlant = newValue!;
                                        });
                                      },
                                      items: plants
                                          .map<DropdownMenuItem<PlanDepotList>>(
                                              (value) {
                                            return DropdownMenuItem<PlanDepotList>(
                                              value: value,
                                              child: Text(value.name!),
                                            );
                                          }).toList(),
                                    ));
                              }),
                              const SizedBox(height: 16.0),
                              // StatefulBuilder(builder:
                              //     (BuildContext context, StateSetter setState) {
                              //   return SizedBox(
                              //       width: double.infinity,
                              //       //height: 70,
                              //       child: CommonDropdownButtonFormField<OilType>(
                              //         isExpanded: true,
                              //         value: selectedOilType,
                              //         icon: const Align(
                              //             alignment: Alignment.topRight,
                              //             child: Icon(
                              //               Icons.keyboard_arrow_down,
                              //               size: 16,
                              //             )),
                              //         elevation: 16,
                              //         style: const TextStyle(color: Colors.black),
                              //         decoration: InputDecoration(
                              //             contentPadding: const EdgeInsets.symmetric(
                              //                 horizontal: 10.0, vertical: 0.0),
                              //             focusedBorder: OutlineInputBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(
                              //                         borderRadiusTLBR),
                              //                     topRight: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomLeft: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomRight: Radius.circular(
                              //                         borderRadiusTLBR)),
                              //                 borderSide: BorderSide(
                              //                     color: borderColor!, width: 1.0)),
                              //             border: OutlineInputBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(
                              //                         borderRadiusTLBR),
                              //                     topRight: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomLeft: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomRight:
                              //                     Radius.circular(borderRadiusTLBR)),
                              //                 borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              //             filled: true,
                              //             // hintStyle: TextStyle(color: Colors.grey[800]),
                              //             labelText: "Oil Type",
                              //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                              //             fillColor: fillColor),
                              //         onChanged: (OilType? newValue) {
                              //           setState(() {
                              //             selectedOilType = newValue!;
                              //           });
                              //           BlocProvider.of<NewSpecialRateBloc>(context).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
                              //               .saudaBookingTypeId!,oilTypeId: selectedOilType!.id!));
                              //         },
                              //         items: oilTypes
                              //             .map<DropdownMenuItem<OilType>>((value) {
                              //           return DropdownMenuItem<OilType>(
                              //             value: value,
                              //             child: Text(value.name!),
                              //           );
                              //         }).toList(),
                              //       ));
                              // }),
                              CustomAutocomplete<OilType>(
                                fieldViewBuilder: (
                                    BuildContext context,
                                    TextEditingController fieldTextEditingController,
                                    FocusNode fieldFocusNode,
                                    VoidCallback onFieldSubmitted
                                    ) {
                                  _oiltypecontroller=fieldTextEditingController;
                                  return TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    decoration:InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 0.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    borderRadiusTLBR),
                                                topRight: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomLeft: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomRight: Radius.circular(
                                                    borderRadiusTLBR)),
                                            borderSide: BorderSide(
                                                color: borderColor!, width: 1.0)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    borderRadiusTLBR),
                                                topRight: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomLeft: Radius.circular(borderRadiusTRBL),
                                                bottomRight: Radius.circular(borderRadiusTLBR)),
                                            borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                        filled: true,
                                        // hintStyle: TextStyle(color: Colors.grey[800]),
                                        labelText: "Oil Type",
                                        labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                        fillColor: fillColor),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    // style: const TextStyle(fontWeight: FontWeight.normal),
                                  );
                                },
                                displayStringForOption: _displayStringForOilTypeOption,
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<OilType>.empty();
                                  }
                                  return oilTypes.where((OilType option) {
                                    return option.name
                                        .toString().toLowerCase()
                                        .contains(textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (OilType selection) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    selectedOilType = selection;
                                  });
                                  BlocProvider.of<NewSpecialRateBloc>(context).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
                                      .saudaBookingTypeId!,oilTypeId: selectedOilType!.id!));
                                },
                              ),
                              const SizedBox(height: 16.0),
                              // StatefulBuilder(builder:
                              //     (BuildContext context, StateSetter setState) {
                              //   return SizedBox(
                              //       width: double.infinity,
                              //       //height: 70,
                              //       child: CommonDropdownButtonFormField<SKUPricing>(
                              //         isExpanded: true,
                              //         value: selectedSKU,
                              //         icon: const Align(
                              //             alignment: Alignment.topRight,
                              //             child: Icon(
                              //               Icons.keyboard_arrow_down,
                              //               size: 16,
                              //             )),
                              //         elevation: 16,
                              //         style: const TextStyle(color: Colors.black),
                              //         decoration: InputDecoration(
                              //             contentPadding: const EdgeInsets.symmetric(
                              //                 horizontal: 10.0, vertical: 0.0),
                              //             focusedBorder: OutlineInputBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(
                              //                         borderRadiusTLBR),
                              //                     topRight: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomLeft: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomRight: Radius.circular(
                              //                         borderRadiusTLBR)),
                              //                 borderSide: BorderSide(
                              //                     color: borderColor!, width: 1.0)),
                              //             border: OutlineInputBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(
                              //                         borderRadiusTLBR),
                              //                     topRight: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomLeft: Radius.circular(
                              //                         borderRadiusTRBL),
                              //                     bottomRight:
                              //                     Radius.circular(borderRadiusTLBR)),
                              //                 borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              //             filled: true,
                              //             // hintStyle: TextStyle(color: Colors.grey[800]),
                              //             labelText: "SKU Name",
                              //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                              //             fillColor: fillColor),
                              //         onChanged: (SKUPricing? newValue) {
                              //           selectedSKU = newValue!;
                              //           _releasedratecontroller.text=selectedSKU!.price!.toStringAsFixed(2);
                              //           setState(() {
                              //           });
                              //         },
                              //         items: skuList
                              //             .map<DropdownMenuItem<SKUPricing>>((value) {
                              //           return DropdownMenuItem<SKUPricing>(
                              //             value: value,
                              //             child: Text(value.skuName!,overflow: TextOverflow.visible),
                              //           );
                              //         }).toList(),
                              //       ));
                              // }),
                              CustomAutocomplete<SKUPricing>(
                                fieldViewBuilder: (
                                    BuildContext context,
                                    TextEditingController fieldTextEditingController,
                                    FocusNode fieldFocusNode,
                                    VoidCallback onFieldSubmitted
                                    ) {
                                  _skunamecontroller=fieldTextEditingController;
                                  return TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    decoration:InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 0.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    borderRadiusTLBR),
                                                topRight: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomLeft: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomRight: Radius.circular(
                                                    borderRadiusTLBR)),
                                            borderSide: BorderSide(
                                                color: borderColor!, width: 1.0)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    borderRadiusTLBR),
                                                topRight: Radius.circular(
                                                    borderRadiusTRBL),
                                                bottomLeft: Radius.circular(borderRadiusTRBL),
                                                bottomRight: Radius.circular(borderRadiusTLBR)),
                                            borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                        filled: true,
                                        // hintStyle: TextStyle(color: Colors.grey[800]),
                                        labelText: "SKU Name",
                                        labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                        fillColor: fillColor),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    // style: const TextStyle(fontWeight: FontWeight.normal),
                                  );
                                },
                                displayStringForOption: _displayStringForSkuOption,
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<SKUPricing>.empty();
                                  }
                                  return skuList.where((SKUPricing option) {
                                    return option.skuName
                                        .toString().toLowerCase()
                                        .contains(textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (SKUPricing selection) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    selectedSKU = selection;
                                    _releasedratecontroller.text=selectedSKU!.price!.toStringAsFixed(2);
                                    setState(() {
                                    });
                                },
                              ),
                              const SizedBox(height: 16),
                              CommonTextFormField(
                                labeltxt: "Released Rate",
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
                                controllerTxt: _releasedratecontroller,
                                enabled: false,
                              ),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                  labeltxt: "Sauda Quantity",
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
                                  labeltxt: "Requested Price",
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
                                  controllerTxt: _requestedratecontroller,
                                  keyborType: TextInputType.number,
                                  onChanged: (String? value) {
                                    setState(() {});
                                  }),
                              const SizedBox(height: 16),
                              const SizedBox(height: 16),
                              ListView.builder(
                                  key: const Key('builder1'), //attention
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: specialRateSku.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12, top: 9, bottom: 9),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xFFDEDEDE)),
                                          color: const Color(0xFFffffff),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(5.0),
                                            bottomLeft: Radius.circular(5.0),
                                            bottomRight: Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: const [
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      // CommonText(
                                                      //   name: "Sauda No:",
                                                      //   fontColor:
                                                      //       Constant.colorDullGray77,
                                                      //   fontSize: Constant.fontSize10,
                                                      // ),
                                                      // CommonText(
                                                      //   name: "New",
                                                      //   fontColor: Constant.colorBlack,
                                                      //   fontSize: Constant.fontSize12,
                                                      //   fontWeight:
                                                      //       Constant.fontWeight600,
                                                      // ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          padding: EdgeInsets.zero,
                                                          constraints: const BoxConstraints(),
                                                          icon: Icon(
                                                            Icons.delete,
                                                            size: 20,
                                                            color: Constant.colorRed,
                                                          ),
                                                          onPressed: () {
                                                            specialRateSku.removeAt(index);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: Color(0xFFD5D5D5),
                                                        width: 0.8,
                                                      ),
                                                    )),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8,
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Expanded(
                                                                      child:CommonText(
                                                                        name: specialRateSku[index]
                                                                            .skuName,
                                                                        fontSize:
                                                                        Constant.fontSize12,
                                                                        fontWeight: Constant
                                                                            .fontWeight600,
                                                                      )),
                                                                  Expanded(
                                                                      child:CommonText(
                                                                        name: " ",
                                                                        fontSize:
                                                                        Constant.fontSize12,
                                                                        fontColor:
                                                                        Constant.colorRed,
                                                                        fontWeight: Constant
                                                                            .fontWeight600,
                                                                      )),
                                                                ],
                                                              )),
                                                          Align(
                                                            alignment:
                                                            Alignment.topRight,
                                                            child: CommonText(
                                                              name: specialRateSku[index]
                                                                  .quantity!
                                                                  .toStringAsFixed(2)
                                                              ,
                                                              fontSize:
                                                              Constant.fontSize12,
                                                              fontColor:
                                                              Constant.colorOrange,
                                                              fontWeight: Constant
                                                                  .fontWeight600,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  CommonText(
                                                                    name: specialRateSku[index]
                                                                        .finalPrice!.toStringAsFixed(2),
                                                                    fontSize:
                                                                    Constant.fontSize11,
                                                                    fontColor:
                                                                    Constant.colorBlack,
                                                                    fontWeight: Constant
                                                                        .fontWeight500,
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 2.0),
                                                                  CommonText(
                                                                    name: "Rs. " +
                                                                        specialRateSku[index]
                                                                            .specialPrice!
                                                                            .toStringAsFixed(2) ,
                                                                    fontSize:
                                                                    Constant.fontSize10,
                                                                    fontColor: Constant
                                                                        .colorDullGray77,
                                                                  ),
                                                                ],
                                                              )),
                                                          Align(
                                                            alignment:
                                                            Alignment.topRight,
                                                            child: CommonText(
                                                              name: "Rs." +
                                                                  (specialRateSku[index]
                                                                      .specialPrice! *
                                                                      specialRateSku[
                                                                      index]
                                                                          .quantity!)
                                                                      .toStringAsFixed(2),
                                                              fontSize:
                                                              Constant.fontSize13,
                                                              fontColor:
                                                              Constant.colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ));
                                  }),
                            ],
                          ))))),onTap:(){
                FocusScope.of(context).requestFocus(new FocusNode());
              }),
              progressBar
            ],
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 16, bottom: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth / 1 - 67,
                    child: CommonButton(
                      buttonName: Constant.saudaLEButtonTxt2,
                      buttonNameSize: Constant.fontSize13,
                      buttonNameColor: Constant.pricbuttonTxtColor,
                      buttonColor: Constant.pricbuttonColor,
                      buttonHeight: 48,
                      buttonRadiusTL: Constant.pricbuttonRadiusTL,
                      buttonRadiusBL: Constant.pricbutRadiusBL,
                      buttonBorder: Colors.transparent,
                      buttonNameWeight: Constant.fontWeight500,
                      buttonFunction: () {
                        showConfirmDlg(context, "Confirm Sauda Request",
                            "Confirm Request");
                      },
                    ),
                  ),
                ],
              )),
        )));
  }
//popup
  void showCustomAlertDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    // set up the button

    // show the dialog
    // var mainContext=context;
    if(selectedEditIndex==-1) {
      popupSkuList = [];
    }
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        SKUPricing? pSelectedItem=pSelectedSKU;
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
              height: 450.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //       padding: const EdgeInsets.only(top:10),
                    //       width: double.infinity,
                    //       height: 70,
                    //       child: CommonDropdownButtonFormField<OilType>(
                    //         isExpanded: true,
                    //         value: pSelectedOilType,
                    //         icon: const Align(
                    //             alignment: Alignment.topRight,
                    //             child: Icon(
                    //               Icons.keyboard_arrow_down,
                    //               size: 16,
                    //             )),
                    //         elevation: 16,
                    //         style: const TextStyle(color: Colors.black),
                    //         decoration: InputDecoration(
                    //             contentPadding: const EdgeInsets.symmetric(
                    //                 horizontal: 10.0, vertical: 0.0),
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.only(
                    //                     topLeft:
                    //                         Radius.circular(borderRadiusTLBR),
                    //                     topRight:
                    //                         Radius.circular(borderRadiusTRBL),
                    //                     bottomLeft:
                    //                         Radius.circular(borderRadiusTRBL),
                    //                     bottomRight:
                    //                         Radius.circular(borderRadiusTLBR)),
                    //                 borderSide: BorderSide(
                    //                     color: borderColor!, width: 1.0)),
                    //             border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.only(
                    //                     topLeft:
                    //                         Radius.circular(borderRadiusTLBR),
                    //                     topRight:
                    //                         Radius.circular(borderRadiusTRBL),
                    //                     bottomLeft:
                    //                         Radius.circular(borderRadiusTRBL),
                    //                     bottomRight:
                    //                         Radius.circular(borderRadiusTLBR)),
                    //                 borderSide: BorderSide(
                    //                     color: borderColor!, width: 1.0)),
                    //             enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.only(
                    //                     topLeft:
                    //                         Radius.circular(borderRadiusTLBR),
                    //                     topRight:
                    //                         Radius.circular(borderRadiusTRBL),
                    //                     bottomLeft:
                    //                         Radius.circular(borderRadiusTRBL),
                    //                     bottomRight:
                    //                         Radius.circular(borderRadiusTLBR)),
                    //                 borderSide:
                    //                     BorderSide(color: borderColor!, width: 1.0)),
                    //             filled: true,
                    //             // hintStyle: TextStyle(color: Colors.grey[800]),
                    //             labelText: "Oil Type",
                    //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                    //             fillColor: fillColor),
                    //         onChanged: (OilType? newValue) async{
                    //           pSelectedItem=null;
                    //           pSelectedSKU=null;
                    //           pSelectedOilType = newValue!;
                    //           // BlocProvider.of<NewSpecialRateBloc>(mainContext).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
                    //           //     .saudaBookingTypeId!,oilTypeId: pSelectedOilType!.id!,popup: true));
                    //           Meta metaSkuList = await ServiceRepository().getFinalPriceSkuNameListForMobile(
                    //               selectedDistributor!.id!,Constants.AUTH_USERID,selectedDistributor!
                    //                   .saudaBookingTypeId!,selectedPlant!.id!,pSelectedOilType!.id!);
                    //           popupSkuList = [];
                    //           if (metaSkuList.statusCode == 200) {
                    //             jsonDecode(
                    //                 metaSkuList.statusMsg)['response']
                    //                 .forEach((f) => popupSkuList.add(SKUPricing.fromJson(f)));
                    //           }
                    //           setState(() {
                    //
                    //           });
                    //         },
                    //         items: oilTypes
                    //             .map<DropdownMenuItem<OilType>>((value) {
                    //           return DropdownMenuItem<OilType>(
                    //             value: value,
                    //             child: Text(value.name!),
                    //           );
                    //         }).toList(),
                    //       )),
                    CustomAutocomplete<OilType>(
                      fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted
                          ) {
                        _popupoiltypecontroller=fieldTextEditingController;
                        if (pSelectedOilType!=null) {
                          _popupoiltypecontroller!.text = pSelectedOilType!.name!;
                        }
                        return TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration:InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 0.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          borderRadiusTLBR),
                                      topRight: Radius.circular(
                                          borderRadiusTRBL),
                                      bottomLeft: Radius.circular(
                                          borderRadiusTRBL),
                                      bottomRight: Radius.circular(
                                          borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          borderRadiusTLBR),
                                      topRight: Radius.circular(
                                          borderRadiusTRBL),
                                      bottomLeft: Radius.circular(borderRadiusTRBL),
                                      bottomRight: Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              filled: true,
                              // hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "Oil Type",
                              labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                              fillColor: fillColor),
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          // style: const TextStyle(fontWeight: FontWeight.normal),
                        );
                      },
                      optionsMaxWidth: MediaQuery.of(context).size.width*0.74,
                      displayStringForOption: _displayStringForOilTypeOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<OilType>.empty();
                        }
                        return oilTypes.where((OilType option) {
                          return option.name
                              .toString().toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (OilType selection) async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        pSelectedItem=null;
                        pSelectedSKU=null;
                        pSelectedOilType = selection;
                        // BlocProvider.of<NewSpecialRateBloc>(mainContext).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
                        //     .saudaBookingTypeId!,oilTypeId: pSelectedOilType!.id!,popup: true));
                        Meta metaSkuList = await ServiceRepository().getFinalPriceSkuNameListForMobile(
                            selectedDistributor!.id!,Constants.AUTH_USERID,selectedDistributor!
                                .saudaBookingTypeId!,selectedPlant!.id!,pSelectedOilType!.id!);
                        popupSkuList = [];
                        if (metaSkuList.statusCode == 200) {
                          jsonDecode(
                              metaSkuList.statusMsg)['response']
                              .forEach((f) => popupSkuList.add(SKUPricing.fromJson(f)));
                        }
                        setState(() {

                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // SizedBox(
                    //     width: double.infinity,
                    //     // height: 70,
                    //     child: CommonDropdownButtonFormField<SKUPricing>(
                    //       key:_skuKey,
                    //       isExpanded: true,
                    //       value: pSelectedItem,
                    //       icon: const Align(
                    //           alignment: Alignment.topRight,
                    //           child: Icon(
                    //             Icons.keyboard_arrow_down,
                    //             size: 16,
                    //           )),
                    //       elevation: 16,
                    //       style: const TextStyle(color: Colors.black),
                    //       decoration: InputDecoration(
                    //           contentPadding: const EdgeInsets.symmetric(
                    //               horizontal: 10.0, vertical: 0.0),
                    //           focusedBorder: OutlineInputBorder(
                    //               borderRadius: BorderRadius.only(
                    //                   topLeft:
                    //                   Radius.circular(borderRadiusTLBR),
                    //                   topRight:
                    //                   Radius.circular(borderRadiusTRBL),
                    //                   bottomLeft:
                    //                   Radius.circular(borderRadiusTRBL),
                    //                   bottomRight:
                    //                   Radius.circular(borderRadiusTLBR)),
                    //               borderSide: BorderSide(
                    //                   color: borderColor!, width: 1.0)),
                    //           border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.only(
                    //                   topLeft:
                    //                   Radius.circular(borderRadiusTLBR),
                    //                   topRight:
                    //                   Radius.circular(borderRadiusTRBL),
                    //                   bottomLeft:
                    //                   Radius.circular(borderRadiusTRBL),
                    //                   bottomRight:
                    //                   Radius.circular(borderRadiusTLBR)),
                    //               borderSide: BorderSide(
                    //                   color: borderColor!, width: 1.0)),
                    //           enabledBorder: OutlineInputBorder(
                    //               borderRadius: BorderRadius.only(
                    //                   topLeft:
                    //                   Radius.circular(borderRadiusTLBR),
                    //                   topRight:
                    //                   Radius.circular(borderRadiusTRBL),
                    //                   bottomLeft:
                    //                   Radius.circular(borderRadiusTRBL),
                    //                   bottomRight:
                    //                   Radius.circular(borderRadiusTLBR)),
                    //               borderSide:
                    //               BorderSide(color: borderColor!, width: 1.0)),
                    //           filled: true,
                    //           // hintStyle: TextStyle(color: Colors.grey[800]),
                    //           labelText: "SKU Name",
                    //           labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                    //           fillColor: fillColor),
                    //       onChanged: (SKUPricing? newValue) {
                    //         pSelectedItem=newValue!;
                    //         pSelectedSKU=newValue!;
                    //         // BlocProvider.of<NewSpecialRateBloc>(context).add(ChangeRate(popup: true));
                    //         _preleasedratecontroller.text=selectedSKU!.price!.toStringAsFixed(2);
                    //       },
                    //       items: popupSkuList
                    //           .map<DropdownMenuItem<SKUPricing>>((value) {
                    //         return DropdownMenuItem<SKUPricing>(
                    //           value: value,
                    //           child: Text(value.skuName!,overflow: TextOverflow.visible),
                    //         );
                    //       }).toList(),
                    //     )),
                    CustomAutocomplete<SKUPricing>(
                      fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted
                          ) {
                        _popupskunamecontroller=fieldTextEditingController;
                        if(pSelectedSKU!=null){
                          _popupskunamecontroller!.text= pSelectedSKU!.skuName!;
                        }
                        return TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration:InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 0.0),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          borderRadiusTLBR),
                                      topRight: Radius.circular(
                                          borderRadiusTRBL),
                                      bottomLeft: Radius.circular(
                                          borderRadiusTRBL),
                                      bottomRight: Radius.circular(
                                          borderRadiusTLBR)),
                                  borderSide: BorderSide(
                                      color: borderColor!, width: 1.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          borderRadiusTLBR),
                                      topRight: Radius.circular(
                                          borderRadiusTRBL),
                                      bottomLeft: Radius.circular(borderRadiusTRBL),
                                      bottomRight: Radius.circular(borderRadiusTLBR)),
                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                              filled: true,
                              // hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "SKU Name",
                              labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                              fillColor: fillColor),
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          // style: const TextStyle(fontWeight: FontWeight.normal),
                        );
                      },
                      optionsMaxWidth: MediaQuery.of(context).size.width*0.74,
                      displayStringForOption: _displayStringForSkuOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<SKUPricing>.empty();
                        }
                        return popupSkuList.where((SKUPricing option) {
                          return option.skuName
                              .toString().toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (SKUPricing selection) {
                        FocusManager.instance.primaryFocus?.unfocus();
                          pSelectedItem=selection;
                          pSelectedSKU=selection;
                          // BlocProvider.of<NewSpecialRateBloc>(context).add(ChangeRate(popup: true));
                          _preleasedratecontroller.text=selectedSKU!.price!.toStringAsFixed(2);
                      },
                    ),
                    const SizedBox(height: 16),
                    CommonTextFormField(
                      labeltxt: "Released Rate",
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
                      controllerTxt: _preleasedratecontroller,
                      enabled: false,
                    ),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Sauda Quantity",
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
                        controllerTxt: _pquantitycontroller,
                        keyborType: TextInputType.number,
                        onChanged: (String? value) {
                          setState(() {});
                        }),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Requested Price",
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
                        controllerTxt: _prequestedratecontroller,
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
      content: const Text("Confirm Special Rate Request"),
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
                buttonHeight: 48,
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
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  if(selectedSalesOrg==null){
                    showSuccessDlg(context, "Error", "Error",successText: "Select Sales Organization from the list",closeScreen: true);
                    return;
                  }
                  if(selectedDistrChannel==null){
                    showSuccessDlg(context, "Error", "Error",successText: "Select Distribution Channel from the list",closeScreen: true);
                    return;
                  }
                  if(selectedVertical==null){
                    showSuccessDlg(context, "Error", "Error",successText: "Select Division from the list",closeScreen: true);
                    return;
                  }
                  if(selectedDistributor==null){
                    showSuccessDlg(context, "Error", "Error",successText: "Select Distributor from the list",closeScreen: true);
                    return;
                  }
                  if(selectedIncoTerms==null){
                    showSuccessDlg(context, "Error", "Error",successText: "Select Incoterms from the list");
                    return;
                  }
                  if(selectedPlant==null){
                    showSuccessDlg(context, "Error", "Error",successText: "Select Plant from the list");
                    return;
                  }
                  if(specialRateSku.isEmpty){
                    if(selectedOilType==null){
                      showSuccessDlg(context, "Error", "Error",successText: "Select Oil Type from the list");
                      return;
                    }
                    if(selectedSKU==null){
                      showSuccessDlg(context, "Error", "Error",successText: "Select SKU from the list");
                      return;
                    }
                    if(_quantitycontroller.text.toString()==""){
                      showSuccessDlg(context, "Error", "Error",successText: "Enter Quantity");
                      return;
                    }
                    if(_requestedratecontroller.text.toString()==""){
                      showSuccessDlg(context, "Error", "Error",successText: "Enter Requested Rate");
                      return;
                    }
                    SpecialRateApproval order = SpecialRateApproval();
                    order.salesOrganizationId=selectedSalesOrg!.id!;
                    order.distributionChannelId=selectedDistrChannel!.id!;
                    order.divisionId=selectedVertical!.id!;
                    order.incotermsId = selectedIncoTerms!.id;
                    order.skuId = selectedSKU!.skuId;
                    order.skuName = selectedSKU!.skuName;
                    order.oilTypeId = selectedOilType!.id;
                    order.plantId = selectedPlant!.id;
                    order.quantity =
                        double.parse(_quantitycontroller.text.toString());
                    order.finalPrice = selectedSKU!.price!;
                    order.pricingId = selectedSKU!.pricingId;
                    order.specialPrice = double.parse(_requestedratecontroller.text.toString());
                    order.userId=selectedDistributor!.id!;
                    order.loginUserId=Constants.AUTH_USERID;
                    specialRateSku.add(order);
                  }
                  SpecialRateRequest request = SpecialRateRequest();
                  request.bDOId = Constants.AUTH_USERID;
                  request.specialRateApprovals=specialRateSku;
                  BlocProvider.of<NewSpecialRateBloc>(context)
                      .add(SaveSpecialRate(request: request));
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
                _scrollDown();
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
                if(pSelectedSKU==null){
                  showSuccessDlg(context, "Error", "Error",successText: "Select SKU from the list");
                  return;
                }
                if(pSelectedOilType==null){
                  showSuccessDlg(context, "Error", "Error",successText: "Select Oil Type from the list");
                  return;
                }
                if(_prequestedratecontroller.text.toString()==""){
                  showSuccessDlg(context, "Error", "Error",successText: "Enter Requested Price");
                  return;
                }
                if(_pquantitycontroller.text.toString()==""){
                  showSuccessDlg(context, "Error", "Error",successText: "Enter Sauda Quantity");
                  return;
                }
                SpecialRateApproval order = SpecialRateApproval();
                order.salesOrganizationId=selectedSalesOrg!.id!;
                order.distributionChannelId=selectedDistrChannel!.id!;
                order.divisionId=selectedVertical!.id!;
                order.incotermsId = selectedIncoTerms!.id;
                order.skuId = selectedSKU!.skuId;
                order.skuName = selectedSKU!.skuName;
                order.oilTypeId = selectedOilType!.id;
                order.plantId = selectedPlant!.id;
                order.quantity =
                    double.parse(_pquantitycontroller.text.toString());
                order.finalPrice = selectedSKU!.price!;
                order.pricingId = selectedSKU!.pricingId;
                order.specialPrice = double.parse(_prequestedratecontroller.text.toString());
                order.userId=selectedDistributor!.id!;
                order.loginUserId=Constants.AUTH_USERID;
                specialRateSku.add(order);
                Navigator.pop(context);
                FocusManager.instance.primaryFocus?.unfocus();
                _scrollDown();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  contBody() {}
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _releasedratecontroller.dispose();
    _quantitycontroller.dispose();
    super.dispose();
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white,bool? closeScreen=false}) {
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
      content:  Container(
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
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  Navigator.pop(context);
                  if(closeScreen!) {
                    Navigator.pop(context);
                  }
                  if(title=="Error"){
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpecialRateApprovalScreen()),
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
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }
}
