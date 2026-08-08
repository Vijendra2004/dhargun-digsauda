import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/new_sauda_request.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda/sauda_screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class NewSauduScreen extends StatelessWidget {
  const NewSauduScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const NewSauduScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewSaudaBloc()
        // ..add(LoadNewSaudaScreen(userId: Constants.AUTH_USERID))
        ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
        // ..add(LoadOilType()),
      child: NewSauduForm(),
    );
  }
}

class NewSauduForm extends StatefulWidget {
  NewSauduForm({Key? key}) : super(key: key);
  int? selectedDiscountType = 0;
  @override
  State<NewSauduForm> createState() => _NewSauduFormState();
}

class _NewSauduFormState extends State<NewSauduForm> {
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
  final TextEditingController _discountcontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  SKUPricing? selectedSKU;
  DistributorList? selectedDistributor;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  IncoTermList? selectedIncoTerms;
  PlanDepotList? selectedPlant;
  OilType? selectedOilType;
  BrokerList? selectedBroker;
  List<SaudaOrders> saudaOrders = [];
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

  final TextEditingController _pdiscountcontroller = TextEditingController();
  final TextEditingController _pquantitycontroller = TextEditingController();
  final TextEditingController _pfromdatecontroller = TextEditingController();
  final TextEditingController _ptodatecontroller = TextEditingController();
  SKUPricing? pSelectedSKU;
  OilType? pSelectedOilType;
  int? pSelectedDiscountType = 1;
  late final GlobalKey<FormFieldState> _skuKey=GlobalKey();
  int selectedEditIndex=-1;
  ProgressBarHandler? _handler;
  String discountLabel="Discount Amount (Max :0.00)";

  @override
  Widget build(BuildContext context) {
    var cx=context;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<NewSaudaBloc, NewSaudaState>(
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
            _fromdatecontroller.text = fromDate;
            _todatecontroller.text = toDate;
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
          if(state is OnSaveSauda){
              showSuccessDlg(context, "Request Confirmed", "Success",successText: "Sauda Request Confirmed");
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
            GMLogger.v(discountLabel);
            setState(() {});
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
              title: "New Sauda",
              backArrow: true,
              listOfActions: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if(selectedIncoTerms==null){
                        showSuccessDlg(context, "Error", "Error",successText: "Select Incoterms from the list");
                        return;
                      }
                      if(selectedOilType==null){
                        showSuccessDlg(context, "Error", "Error",successText: "Select Oil Type from the list");
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
                      // if(_discountcontroller.text.toString()==""){
                      //   showSuccessDlg(context, "Error", "Error",successText: "Enter Discount Amount");
                      //   return;
                      // }
                      if(_quantitycontroller.text.toString()==""){
                        showSuccessDlg(context, "Error", "Error",successText: "Enter Quantity");
                        return;
                      }
                      if(saudaOrders.isEmpty){
                        SaudaOrders order = SaudaOrders();
                        order.incoTerms = selectedIncoTerms!.name;
                        order.incotermsId = selectedIncoTerms!.id;
                        order.skuName = selectedSKU!.skuName;
                        order.skuId = selectedSKU!.skuId;
                        order.oilTypeId = selectedOilType!.id;
                        order.plantId = selectedPlant!.id;
                        order.bidQuantity =
                            int.parse(_quantitycontroller.text.toString());
                        order.discountTypeId = widget.selectedDiscountType;
                        order.plantDepot = selectedPlant!.name;
                        order.pricingId = selectedSKU!.pricingId;
                        order.uomName=selectedSKU!.uom;
                        if(_fromdatecontroller.text.toString()!="") {
                          order.saudaValidFromDate =
                              DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(),DateTimeUtils.DD_MM_YYYY_Format,DateTimeUtils.YYYY_MM_DD_Format);
                        }else{
                          order.saudaValidFromDate ="";
                        }
                        if(_todatecontroller.text.toString()!="") {
                          order.saudaValidToDate = DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(),DateTimeUtils.DD_MM_YYYY_Format,DateTimeUtils.YYYY_MM_DD_Format);
                        }else{
                          order.saudaValidToDate ="";
                        }
                        order.discountAmountPerCase =0;
                        order.discountAmount =0;
                        if(_discountcontroller.text.toString()!="") {
                          order.discountAmountPerCase =
                              double.parse(_discountcontroller.text.toString());
                        }
                        double finalPrice = 0;
                        if (selectedSKU!.price! > 0) {
                          if (widget.selectedDiscountType == 1) {
                            finalPrice =
                                selectedSKU!.price! - order.discountAmountPerCase!;
                          } else {
                            finalPrice =
                                selectedSKU!.price! + order.discountAmountPerCase!;
                          }
                        }
                        if(_discountcontroller.text.toString()!="") {
                          order.discountAmount =
                              double.parse(_discountcontroller.text.toString()) *
                                  order.bidQuantity!;
                        }
                        order.quotedPrice = finalPrice;
                        order.statusId=1;
                        saudaOrders.add(order);
                        setState(() {

                        });
                      }
                      itemRatePopup=0;
                      pSelectedSKU=null;
                      pSelectedOilType=null;
                      pSelectedDiscountType=1;
                      _pdiscountcontroller.text="";
                      _pquantitycontroller.text="";
                      selectedEditIndex=-1;
                      showCustomAlertDialog(context, contBody(), 'Add Sauda',
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
                        padding: const EdgeInsets.all(7),
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
        SafeArea(child:SingleChildScrollView(child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(height: Constant.containerTopWrapper),
                  CurveOuterBox(
                      boxofWidget:  SizedBox(
                          // height: MediaQuery.of(context).size.height - 215,
                         // height:double.infinity,
                          child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      CommonDropdownButtonFormField<SalesOrganization>(
                        value: salesOrgList.contains(selectedSalesOrg) ? selectedSalesOrg : null,
                        label: "Sales Organization",
                        onChanged: (SalesOrganization? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedSalesOrg = newValue;
                          });
                          BlocProvider.of<NewSaudaBloc>(context).add(
                              LoadDistributionChannel(
                                  id: newValue.id!));
                        },
                        items: salesOrgList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.salesOrganizationName!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CommonDropdownButtonFormField<DistributionChannel>(
                        value: distrChannels.contains(selectedDistrChannel) ? selectedDistrChannel : null,
                        label: "Distribution Channel",
                        onChanged: (DistributionChannel? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedDistrChannel = newValue;
                          });
                          BlocProvider.of<NewSaudaBloc>(context).add(
                              LoadVerticalList(
                                  distributionId: newValue.id!));
                        },
                        items: distrChannels.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.distributionChannelName!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      CommonDropdownButtonFormField<Vertical>(
                        value: verticals.contains(selectedVertical) ? selectedVertical : null,
                        label: "Division",
                        onChanged: (Vertical? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedVertical = newValue;
                          });
                          BlocProvider.of<NewSaudaBloc>(context).add(LoadNewSaudaScreen(
                              userId: Constants.AUTH_USERID,
                              salesOrganizationId: selectedSalesOrg!.id!,
                              distributionChannelId: selectedDistrChannel!.id!,
                              divisonId: newValue.id!));
                          BlocProvider.of<NewSaudaBloc>(context).add(LoadOilType(
                              userId: Constants.AUTH_USERID,
                              salesOrganizationId: selectedSalesOrg!.id!,
                              distributionChannelId: selectedDistrChannel!.id!,
                              divisonId: newValue.id!));
                        },
                        items: verticals.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CommonDropdownButtonFormField<DistributorList>(
                        value: distributorList.contains(selectedDistributor) ? selectedDistributor : null,
                        label: "Distributor",
                        onChanged: (DistributorList? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedDistributor = newValue;
                          });
                          BlocProvider.of<NewSaudaBloc>(context).add(
                              LoadDealerSaudaDetail(
                                  id: newValue.id!,
                                  saudaBookingTypeId: newValue
                                      .saudaBookingTypeId!,
                                  salesOrganizationId: selectedSalesOrg!.id!,
                                  distributionChannelId: selectedDistrChannel!.id!,
                                  divisionId: selectedVertical!.id!));
                        },
                        items: distributorList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.employeeName!, overflow: TextOverflow.visible),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CommonDropdownButtonFormField<BrokerList>(
                        value: brokerList.contains(selectedBroker) ? selectedBroker : null,
                        label: "Broker",
                        onChanged: (BrokerList? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedBroker = newValue;
                          });
                        },
                        items: brokerList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
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
                              subHeading: saudaDetail.availableSaudaLimit != null
                                  ? saudaDetail.availableSaudaLimit.toString()
                                  : "0",
                              headingFontSize: Constant.fontSize13,
                              subHeadingFontSize: Constant.fontSize16,
                              subhHadingFontWeight: FontWeight.w600),
                          const SizedBox(width: 13),
                          CurveBox(
                              boxSize: 2,
                              miniusValue: 30,
                              boxHeight: 76,
                              boxColor: Constant.saudaLETBoxColor2,
                              headingTxt: Constant.saudaLETBox2Txt2,
                              subHeading: saudaDetail.totalSaudaLimit != null
                                  ? saudaDetail.totalSaudaLimit.toString()
                                  : "0",
                              headingFontSize: Constant.fontSize13,
                              subHeadingFontSize: Constant.fontSize16,
                              subhHadingFontWeight: FontWeight.w600)
                        ],
                      ),
                      const SizedBox(height: 16),
                      CommonDropdownButtonFormField<IncoTermList>(
                        value: incoTerms.contains(selectedIncoTerms) ? selectedIncoTerms : null,
                        label: "Incoterm",
                        onChanged: (IncoTermList? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedIncoTerms = newValue;
                          });
                        },
                        items: incoTerms.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      CommonDropdownButtonFormField<PlanDepotList>(
                        value: plants.contains(selectedPlant) ? selectedPlant : null,
                        label: "Plant",
                        onChanged: (PlanDepotList? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedPlant = newValue;
                          });
                        },
                        items: plants.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      CommonDropdownButtonFormField<OilType>(
                        value: oilTypes.contains(selectedOilType) ? selectedOilType : null,
                        label: "Oil Type",
                        onChanged: (OilType? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedOilType = newValue;
                          });
                          BlocProvider.of<NewSaudaBloc>(context).add(LoadSKUDetails(
                              userId: Constants.AUTH_USERID,
                              dealerId: selectedDistributor!.id!,
                              plantId: selectedPlant!.id!,
                              saudaBookingTypeId: selectedDistributor!.saudaBookingTypeId!,
                              oilTypeId: newValue.id!));
                        },
                        items: oilTypes.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      CommonDropdownButtonFormField<SKUPricing>(
                        value: skuList.contains(selectedSKU) ? selectedSKU : null,
                        label: "SKU Name",
                        onChanged: (SKUPricing? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            selectedSKU = newValue;
                          });
                          BlocProvider.of<NewSaudaBloc>(context)
                              .add(const ChangeRate(popup: false));
                        },
                        items: skuList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.skuName!, overflow: TextOverflow.visible),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    name: "Rate",
                                    fontColor: Constant.colorDullGray77,
                                    fontSize: Constant.fontSize10,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      CommonText(
                                        name: "Rs." + (itemRate.toStringAsFixed(2)),
                                        fontColor: Constant.colorBlack,
                                        fontSize: Constant.fontSize15,
                                        fontWeight: Constant.fontWeight500,
                                      ),
                                      CommonText(
                                        name: "",
                                        fontColor: Constant.colorDullGray77,
                                        fontSize: Constant.fontSize10,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Select Type",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      StatefulBuilder(builder:
                          (BuildContext ctx, StateSetter setState) {
                        return Container(
                            margin: const EdgeInsets.only(right:100),
                            child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Expanded(
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      // toggleableActiveColor: Colors.green[900]
                                  ),
                                  child: RadioListTile<int>(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Discount',
                                        style: TextStyle(fontSize: 12)),
                                    value: 1,
                                    groupValue: widget.selectedDiscountType,
                                    onChanged: (int? value) {
                                      setState(() {
                                        widget.selectedDiscountType = value!;
                                        if(selectedSKU!=null) {
                                          if (widget.selectedDiscountType ==
                                              1) {
                                            _discountcontroller.text =
                                                selectedSKU!
                                                    .employeeSkuDiscount!
                                                    .toStringAsFixed(2);
                                            itemMaxDiscount=selectedSKU!.employeeSkuDiscount!;
                                            discountLabel="Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")";
                                          } else {
                                            _discountcontroller.text =
                                                selectedSKU!.employeeSkuPremium!
                                                    .toStringAsFixed(2);
                                            discountLabel="Premium";
                                          }
                                        }
                                      });
                                      BlocProvider.of<NewSaudaBloc>(cx).add(const ChangeRate(popup: false));
                                    },
                                  ))),
                          Expanded(
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.green[900],
                                      disabledColor: Colors.green[900],
                                      // toggleableActiveColor: Colors.green[900]
                                  ),
                                  child: RadioListTile<int>(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text(
                                      'Premium',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: 2,
                                    groupValue: widget.selectedDiscountType,
                                    onChanged: (int? value) {
                                      setState(() {
                                        widget.selectedDiscountType = value!;
                                        if(selectedSKU!=null) {
                                          if (widget.selectedDiscountType ==
                                              1) {
                                            _discountcontroller.text =
                                                selectedSKU!
                                                    .employeeSkuDiscount!
                                                    .toStringAsFixed(2);
                                            itemMaxDiscount=selectedSKU!.employeeSkuDiscount!;
                                            discountLabel="Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")";
                                          } else {
                                            _discountcontroller.text =
                                                selectedSKU!.employeeSkuPremium!
                                                    .toStringAsFixed(2);
                                            itemMaxDiscount=0;
                                            discountLabel="Premium";
                                          }
                                        }
                                      });
                                      BlocProvider.of<NewSaudaBloc>(cx).add(const ChangeRate(popup: false));
                                    },
                                  ))),
                        ]));
                      }),
                      const SizedBox(height: 16.0),
                      // CommonTextFormField(
                      //     labeltxt: discountLabel,//"Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")",
                      //     labeltxtColor: Constant.textFormFieldColor,
                      //     labeltxtSize: Constant.textFormFieldSize,
                      //     labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                      //     focuBorColor: Constant.textFormFocuBorCol,
                      //     focuBorWid: Constant.textFormFocuBorWid,
                      //     enaBorColor: Constant.textFormEnaBorCol,
                      //     enaBorWid: Constant.textFormEnaBorWid,
                      //     borderRadiusTL: Constant.textFormborderRadiusTL,
                      //     borderRadiusBR: Constant.textFormborderRadiusBR,
                      //     contentPadHor: Constant.textFormcontentPadHor,
                      //     contentPadHVer: Constant.textFormcontentPadHVer,
                      //     controllerTxt: _discountcontroller,
                      //     keyborType: TextInputType.number,
                      //     ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _discountcontroller,
                        maxLines: 1,
                        enabled: true,
                        onChanged: (String? value) {
                          if (selectedSKU!=null && _discountcontroller.text.toString()!="") {
                            if (widget.selectedDiscountType == 1) {
                              if(selectedSKU!=null && double.parse(
                                  _discountcontroller.text.toString())>selectedSKU!.employeeSkuDiscount!){
                                // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+selectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                _discountcontroller.text=selectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                              }
                            } else {
                              // if(selectedSKU!=null && double.parse(
                              //     _discountcontroller.text.toString())>selectedSKU!.employeeSkuPremium!){
                              //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+selectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                              //   _discountcontroller.text=selectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                              // }
                            }
                          }
                          calculatePrice();
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            labelText: discountLabel,
                            labelStyle: TextStyle(
                                color: Constant.textFormFieldColor!,
                                fontSize: Constant.textFormFieldSize,
                                fontWeight: Constant.textFormFieldSizeFontW),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Constant.textFormFocuBorCol!, width: Constant.textFormFocuBorWid!),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Constant.textFormborderRadiusTL!),
                                  topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                                  bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                                  bottomRight: Radius.circular(Constant.textFormborderRadiusTL!),
                                )),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Constant.textFormEnaBorCol!, width: Constant.textFormEnaBorWid!),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Constant.textFormborderRadiusTL!),
                                  topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                                  bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                                  bottomRight: Radius.circular(Constant.textFormborderRadiusTL!),
                                )),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Constant.textFormcontentPadHor!, vertical: Constant.textFormcontentPadHVer!)),
                        onSaved: (String? value) {},
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
                            calculatePrice();
                            setState(() {});
                          }),
                      // const SizedBox(height: 16.0),
                      // const Text(
                      //   "Indicative Rate",
                      //   style: TextStyle(fontSize: 12),
                      // ),
                      // const Text(
                      //   "Rs.7,000.00(Rs./Case)",
                      //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      // ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                name: "Total Price",
                                fontColor: Constant.colorDullGray77,
                                fontSize: Constant.fontSize10,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  CommonText(
                                    name: "Rs." + rate.toStringAsFixed(2),
                                    fontColor: Constant.colorBlack,
                                    fontSize: Constant.fontSize15,
                                    fontWeight: Constant.fontWeight500,
                                  ),
                                  // CommonText(
                                  //   name: "/case",
                                  //   fontColor: Constant.colorDullGray77,
                                  //   fontSize: Constant.fontSize10,
                                  // ),
                                ],
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                name: "Total Final Price",
                                fontColor: Constant.colorDullGray77,
                                fontSize: Constant.fontSize10,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  CommonText(
                                    name: "Rs." + finalRate.toStringAsFixed(2),
                                    fontColor: Constant.colorGreencc,
                                    fontSize: Constant.fontSize15,
                                    fontWeight: Constant.fontWeight500,
                                  ),
                                  // CommonText(
                                  //   name: "/case",
                                  //   fontColor: Constant.colorDullGray77,
                                  //   fontSize: Constant.fontSize10,
                                  // ),
                                ],
                              )
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(onTap:(){
                              _selectFromDate(context, false);
                            },child:CommonTextFormField(
                              labeltxt: "Valid From",
                              labeltxtColor: Constant.textFormFieldColor,
                              labeltxtSize: Constant.textFormFieldSize,
                              labeltxtFontWeight:
                                  Constant.textFormFieldSizeFontW,
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
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: InkWell(onTap:(){
                              _selectToDate(context, false);
                            },child:CommonTextFormField(
                              labeltxt: "Valid To",
                              labeltxtColor: Constant.textFormFieldColor,
                              labeltxtSize: Constant.textFormFieldSize,
                              labeltxtFontWeight:
                                  Constant.textFormFieldSizeFontW,
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
                      ListView.builder(
                          key: const Key('builder1'), //attention
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: saudaOrders.length,
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
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color:
                                                          Constant.colorOrange,
                                                    ),
                                                    onPressed: ()async {
                                                      pSelectedOilType=oilTypes.where((element) => element.id==saudaOrders[index].oilTypeId).first;
                                                      if(saudaOrders[index].saudaValidFromDate!="") {
                                                        _pfromdatecontroller.text =
                                                            DateTimeUtils().dateToServerToDateFormat(saudaOrders[index].saudaValidFromDate!,DateTimeUtils.YYYY_MM_DD_Format,DateTimeUtils.DD_MM_YYYY_Format);
                                                      }else{
                                                        _pfromdatecontroller.text ="";
                                                      }
                                                      if(saudaOrders[index].saudaValidToDate!="") {
                                                        _ptodatecontroller.text = DateTimeUtils().dateToServerToDateFormat(saudaOrders[index].saudaValidToDate!,DateTimeUtils.YYYY_MM_DD_Format,DateTimeUtils.DD_MM_YYYY_Format);
                                                      }else{
                                                        _ptodatecontroller.text ="";
                                                      }
                                                      Meta metaSkuList = await ServiceRepository().getFinalPriceSkuNameListForMobile(
                                                          selectedDistributor!.id!,Constants.AUTH_USERID,selectedDistributor!
                                                          .saudaBookingTypeId!,selectedPlant!.id!,pSelectedOilType!.id!);
                                                      popupSkuList = [];
                                                      if (metaSkuList.statusCode == 200) {
                                                        jsonDecode(
                                                            metaSkuList.statusMsg)['response']
                                                            .forEach((f) => popupSkuList.add(SKUPricing.fromJson(f)));
                                                      }
                                                      pSelectedSKU=popupSkuList.where((element) => element.skuId==saudaOrders[index].skuId).first;
                                                      pSelectedDiscountType=saudaOrders[index].discountTypeId!;
                                                      selectedEditIndex=index;
                                                      if(pSelectedSKU!=null) {
                                                        if(pSelectedDiscountType==1) {
                                                          itemMaxDiscount =
                                                          pSelectedSKU!
                                                              .employeeSkuDiscount!;
                                                          discountLabel="Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")";
                                                        }else{
                                                          itemMaxDiscount =
                                                          pSelectedSKU!
                                                              .employeeSkuPremium!;
                                                          discountLabel="Premium";
                                                        }
                                                        itemRatePopup=pSelectedSKU!.price!;
                                                      }
                                                      showCustomAlertDialog(context, contBody(), 'Edit Sauda',
                                                          dialogActionButton(),
                                                          hideCancelBtn: true);
                                                      _pdiscountcontroller.text=saudaOrders[index].discountAmountPerCase!.toString();
                                                      _pquantitycontroller.text=saudaOrders[index].bidQuantity!.toString();
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 12.0),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Constant.colorRed,
                                                  ),
                                                  onPressed: () {
                                                    saudaOrders.removeAt(index);
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
                                                        name: saudaOrders[index]
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
                                                      name: saudaOrders[index]
                                                              .bidQuantity
                                                              .toString()+" "+(saudaOrders[index]
                                                          .uomName??"")
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
                                                        name: saudaOrders[index]
                                                            .plantDepot,
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
                                                            saudaOrders[index]
                                                                .quotedPrice
                                                                .toString() ,
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
                                                          (saudaOrders[index]
                                                                      .quotedPrice! *
                                                                  saudaOrders[
                                                                          index]
                                                                      .bidQuantity!)
                                                              .toString(),
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
                      Visibility(visible:saudaOrders.isNotEmpty,child: Container(
                        margin: const EdgeInsets.only(top:10),
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        color: const Color(0xFFECECEC),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Total Amount",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600,
                                    ),
                                  ],
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Expanded(
                                child: CommonText(
                                  name: "Rs."+getTotalValue().toStringAsFixed(2),
                                  fontSize: Constant.fontSize13,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                    ],
                  ))),
                ],
              ))),
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
        ));
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
        double finalRate = 0;
        double rate = 0;
        String pdiscountLabel="";
        SKUPricing? pSelectedItem=pSelectedSKU;
        if(selectedEditIndex!=-1){
          finalRate = 0;
          double selectedRate = 0;
          double finalPrice = 0;
          double qty = 0;
          selectedRate = pSelectedSKU!.price!;
          finalPrice = selectedRate;
          if (_pdiscountcontroller.text.toString() != "") {
            if (pSelectedSKU!=null && pSelectedSKU!.price! > 0) {
              if (pSelectedDiscountType == 1) {
                if(pSelectedSKU!=null && double.parse(
                    _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuDiscount!){
                  // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                  _pdiscountcontroller.text=pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                }
                finalPrice = pSelectedSKU!.price! -
                    double.parse(
                        _pdiscountcontroller.text.toString());
              } else {
                // if(pSelectedSKU!=null && double.parse(
                //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                //   _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                // }
                finalPrice = pSelectedSKU!.price! +
                    double.parse(
                        _pdiscountcontroller.text.toString());
              }
            }
          }
          if (_pquantitycontroller.text.toString() != "") {
            qty = double.parse(
                _pquantitycontroller.text.toString());
          }
          finalRate = finalPrice * qty;
          rate = selectedRate * qty;
        }
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
              height: 500.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                          padding: const EdgeInsets.only(top:10),
                          width: double.infinity,
                          height: 70,
                          child: CommonDropdownButtonFormField<OilType>(
                            value: pSelectedOilType,
                            label: "Oil Type",
                            onChanged: (OilType? newValue) async{
                              pSelectedItem=null;
                              pSelectedSKU=null;
                              pSelectedOilType = newValue!;
                              // BlocProvider.of<NewSaudaBloc>(mainContext).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
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
                            items: oilTypes
                                .map<DropdownMenuItem<OilType>>((value) {
                              return DropdownMenuItem<OilType>(
                                value: value,
                                child: Text(value.name!),
                              );
                            }).toList(),
                          )),
                    const SizedBox(height: 16.0),
                    // StatefulBuilder(
                    //     builder: (BuildContext context, StateSetter setState) {
                    //   return Container(
                    //       width: double.infinity,
                    //       // height: 70,
                    //       child: CommonDropdownButtonFormField<SKUPricing>(
                    //         isExpanded: true,
                    //         value: pSelectedSKU,
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
                    //             labelText: "SKU",
                    //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                    //             fillColor: fillColor),
                    //         onChanged: (SKUPricing? newValue) {
                    //           pSelectedSKU = newValue!;
                    //           itemRatePopup=pSelectedSKU!.price!;
                    //           setState(() {
                    //
                    //           });
                    //           // BlocProvider.of<NewSaudaBloc>(context).add(ChangeRate(popup: true));
                    //         },
                    //         items: skuList
                    //             .map<DropdownMenuItem<SKUPricing>>((value) {
                    //           return DropdownMenuItem<SKUPricing>(
                    //             value: value,
                    //             child: Text(value.skuName!),
                    //           );
                    //         }).toList(),
                    //       ));
                    // }),
                    SizedBox(
                        width: double.infinity,
                        // height: 70,
                        child: CommonDropdownButtonFormField<SKUPricing>(
                          key:_skuKey,
                          value: pSelectedItem,
                          label: "SKU Name",
                          onChanged: (SKUPricing? newValue) {
                            var o=[];//saudaOrders.where((element) => element.skuId==newValue!.skuId!);
                            if(selectedEditIndex!=-1 || o.isEmpty) {
                              pSelectedSKU = newValue!;
                              pSelectedItem=newValue;
                              itemRatePopup = pSelectedSKU!.price!;
                              setState(() {

                              });
                            }else{
                              newValue=null;
                              pSelectedSKU=null;
                              pSelectedItem=null;
                              _skuKey.currentState!.reset();
                              setState(() {

                              });
                              showSuccessDlg(context, "Error", "Error",successText: "SKU already selected",closeScreen: false);
                            }
                            // BlocProvider.of<NewSaudaBloc>(context).add(ChangeRate(popup: true));
                          },
                          items: popupSkuList
                              .map<DropdownMenuItem<SKUPricing>>((value) {
                            return DropdownMenuItem<SKUPricing>(
                              value: value,
                              child: Text(value.skuName!,overflow: TextOverflow.visible),
                            );
                          }).toList(),
                        )),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  name: "Rate (Rs)",
                                  fontColor: Constant.colorDullGray77,
                                  fontSize: Constant.fontSize10,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    CommonText(
                                      name: "Rs." + (itemRatePopup.toStringAsFixed(2)),
                                      fontColor: Constant.colorBlack,
                                      fontSize: Constant.fontSize15,
                                      fontWeight: Constant.fontWeight500,
                                    ),
                                    CommonText(
                                      name: "",
                                      fontColor: Constant.colorDullGray77,
                                      fontSize: Constant.fontSize10,
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Select Type",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                title: Text('Discount',
                                    style: TextStyle(
                                      fontSize: Constant.fontSize12,
                                    )),
                                value: 1,
                                groupValue: pSelectedDiscountType,
                                onChanged: (int? value) {
                                  setState(() {
                                    pSelectedDiscountType = value!;
                                    if(pSelectedSKU!=null) {
                                      if (pSelectedDiscountType == 1) {
                                        _pdiscountcontroller.text =
                                            pSelectedSKU!.employeeSkuDiscount!
                                                .toStringAsFixed(2);
                                        itemMaxDiscount=pSelectedSKU!.employeeSkuDiscount!;
                                        pdiscountLabel="Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")";
                                      } else {
                                        _pdiscountcontroller.text =
                                            pSelectedSKU!.employeeSkuPremium!
                                                .toStringAsFixed(2);
                                        itemMaxDiscount=0;
                                        pdiscountLabel="Premium";
                                      }

                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                                child: RadioListTile<int>(
                              title: Text('Premium',
                                  style: TextStyle(
                                    fontSize: Constant.fontSize12,
                                  )),
                              value: 2,
                              groupValue: pSelectedDiscountType,
                              onChanged: (int? value) {
                                setState(() {
                                  pSelectedDiscountType = value!;
                                  if(pSelectedSKU!=null) {
                                    if (pSelectedDiscountType == 1) {
                                      _pdiscountcontroller.text =
                                          pSelectedSKU!.employeeSkuDiscount!
                                              .toStringAsFixed(2);
                                      itemMaxDiscount=pSelectedSKU!.employeeSkuDiscount!;
                                      pdiscountLabel="Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")";
                                    } else {
                                      _pdiscountcontroller.text =
                                          pSelectedSKU!.employeeSkuPremium!
                                              .toStringAsFixed(2);
                                      itemMaxDiscount=0;
                                      pdiscountLabel="Premium";
                                    }

                                  }
                                });
                              },
                            )),
                          ]);
                    }),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _pdiscountcontroller,
                      maxLines: 1,
                      enabled: true,
                      onChanged: (String? value) {
                        finalRate = 0;
                        double selectedRate = 0;
                        double finalPrice = 0;
                        double qty = 0;
                        selectedRate = pSelectedSKU!.price!;
                        finalPrice = selectedRate;
                        if (_pdiscountcontroller.text.toString() != "") {
                          if (pSelectedSKU!=null && pSelectedSKU!.price! > 0) {
                            if (pSelectedDiscountType == 1) {
                              if(pSelectedSKU!=null && double.parse(
                                  _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuDiscount!){
                                // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                _pdiscountcontroller.text=pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                              }
                              finalPrice = pSelectedSKU!.price! -
                                  double.parse(
                                      _pdiscountcontroller.text.toString());
                            } else {
                              // if(pSelectedSKU!=null && double.parse(
                              //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                              //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                              //   // _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                              // }
                              finalPrice = pSelectedSKU!.price! +
                                  double.parse(
                                      _pdiscountcontroller.text.toString());
                            }
                          }
                        }
                        if (_pquantitycontroller.text.toString() != "") {
                          qty = double.parse(
                              _pquantitycontroller.text.toString());
                        }
                        finalRate = finalPrice * qty;
                        rate = selectedRate * qty;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          labelText: pdiscountLabel,
                          labelStyle: TextStyle(
                              color: Constant.textFormFieldColor!,
                              fontSize: Constant.textFormFieldSize,
                              fontWeight: Constant.textFormFieldSizeFontW),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Constant.textFormFocuBorCol!, width: Constant.textFormFocuBorWid!),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Constant.textFormborderRadiusTL!),
                                topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                                bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                                bottomRight: Radius.circular(Constant.textFormborderRadiusTL!),
                              )),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Constant.textFormEnaBorCol!, width: Constant.textFormEnaBorWid!),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Constant.textFormborderRadiusTL!),
                                topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                                bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                                bottomRight: Radius.circular(Constant.textFormborderRadiusTL!),
                              )),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: Constant.textFormcontentPadHor!, vertical: Constant.textFormcontentPadHVer!)),
                      onSaved: (String? value) {},
                    ),
                    // CommonTextFormField(
                    //     labeltxt: pdiscountLabel,//"Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")",
                    //     labeltxtColor: Constant.textFormFieldColor,
                    //     labeltxtSize: Constant.textFormFieldSize,
                    //     labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                    //     focuBorColor: Constant.textFormFocuBorCol,
                    //     focuBorWid: Constant.textFormFocuBorWid,
                    //     enaBorColor: Constant.textFormEnaBorCol,
                    //     enaBorWid: Constant.textFormEnaBorWid,
                    //     borderRadiusTL: Constant.textFormborderRadiusTL,
                    //     borderRadiusBR: Constant.textFormborderRadiusBR,
                    //     contentPadHor: Constant.textFormcontentPadHor,
                    //     contentPadHVer: Constant.textFormcontentPadHVer,
                    //     controllerTxt: _pdiscountcontroller,
                    //     keyborType: TextInputType.number,
                    //     onChanged: (String? value) {
                    //       finalRate = 0;
                    //       double selectedRate = 0;
                    //       double finalPrice = 0;
                    //       double qty = 0;
                    //       selectedRate = pSelectedSKU!.price!;
                    //       finalPrice = selectedRate;
                    //       if (_pdiscountcontroller.text.toString() != "") {
                    //         if (pSelectedSKU!=null && pSelectedSKU!.price! > 0) {
                    //           if (pSelectedDiscountType == 1) {
                    //             if(pSelectedSKU!=null && double.parse(
                    //                 _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuDiscount!){
                    //               // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                    //               _pdiscountcontroller.text=pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                    //             }
                    //             finalPrice = pSelectedSKU!.price! -
                    //                 double.parse(
                    //                     _pdiscountcontroller.text.toString());
                    //           } else {
                    //             // if(pSelectedSKU!=null && double.parse(
                    //             //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                    //             //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                    //             //   // _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                    //             // }
                    //             finalPrice = pSelectedSKU!.price! +
                    //                 double.parse(
                    //                     _pdiscountcontroller.text.toString());
                    //           }
                    //         }
                    //       }
                    //       if (_pquantitycontroller.text.toString() != "") {
                    //         qty = double.parse(
                    //             _pquantitycontroller.text.toString());
                    //       }
                    //       finalRate = finalPrice * qty;
                    //       rate = selectedRate * qty;
                    //       setState(() {});
                    //     }),
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
                        controllerTxt: _pquantitycontroller,
                        keyborType: TextInputType.number,
                        onChanged: (String? value) {
                          finalRate = 0;
                          double selectedRate = 0;
                          double finalPrice = 0;
                          double qty = 0;
                          selectedRate = pSelectedSKU!.price!;
                          finalPrice = selectedRate;
                          if (_pdiscountcontroller.text.toString() != "") {
                            if (pSelectedSKU!=null && pSelectedSKU!.price! > 0) {
                              if (pSelectedDiscountType == 1) {
                                if(pSelectedSKU!=null && double.parse(
                                    _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuDiscount!){
                                  // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                  _pdiscountcontroller.text=pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                                }
                                  finalPrice = pSelectedSKU!.price! -
                                    double.parse(
                                        _pdiscountcontroller.text.toString());
                              } else {
                                // if(pSelectedSKU!=null && double.parse(
                                //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                                //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                                //   // _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                                // }
                                finalPrice = pSelectedSKU!.price! +
                                    double.parse(
                                        _pdiscountcontroller.text.toString());
                              }
                            }
                          }
                          if (_pquantitycontroller.text.toString() != "") {
                            qty = double.parse(
                                _pquantitycontroller.text.toString());
                          }
                          finalRate = finalPrice * qty;
                          rate = selectedRate * qty;
                          setState(() {});
                        }),
                    const SizedBox(height: 16.0),
                    Visibility(visible:false,child:Row(
                      children: [
                        Expanded(
                          child: InkWell(onTap:(){
                            _selectFromDate(context, true);
                          },child:CommonTextFormField(
                            labeltxt: "Valid From",
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
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: InkWell(onTap:(){
                            _selectToDate(context, true);
                          },child:CommonTextFormField(
                            labeltxt: "Valid To",
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
                    )),
                    // const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              name: "Total Price",
                              fontColor: Constant.colorDullGray77,
                              fontSize: Constant.fontSize10,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                CommonText(
                                  name: "Rs." + rate.toStringAsFixed(2),
                                  fontColor: Constant.colorBlack,
                                  fontSize: Constant.fontSize15,
                                  fontWeight: Constant.fontWeight500,
                                ),
                                // CommonText(
                                //   name: "/case",
                                //   fontColor: Constant.colorDullGray77,
                                //   fontSize: Constant.fontSize10,
                                // ),
                              ],
                            )
                          ],
                        )),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              name: "Total Final Price",
                              fontColor: Constant.colorDullGray77,
                              fontSize: Constant.fontSize10,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                CommonText(
                                  name: "Rs." + finalRate.toStringAsFixed(2),
                                  fontColor: Constant.colorGreencc,
                                  fontSize: Constant.fontSize15,
                                  fontWeight: Constant.fontWeight500,
                                ),
                                // CommonText(
                                //   name: "/case",
                                //   fontColor: Constant.colorDullGray77,
                                //   fontSize: Constant.fontSize10,
                                // ),
                              ],
                            )
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 24.0),
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
      content: const Text("Confirm Sauda Request"),
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
                  if(saudaOrders.isEmpty){
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
                    SaudaOrders order = SaudaOrders();
                    order.incoTerms = selectedIncoTerms!.name;
                    order.incotermsId = selectedIncoTerms!.id;
                    order.skuName = selectedSKU!.skuName;
                    order.skuId = selectedSKU!.skuId;
                    order.oilTypeId = selectedOilType!.id;
                    order.plantId = selectedPlant!.id;
                    order.bidQuantity =
                        int.parse(_quantitycontroller.text.toString());
                    order.discountTypeId = widget.selectedDiscountType;
                    order.plantDepot = selectedPlant!.name;
                    order.pricingId = selectedSKU!.pricingId;
                    order.uomName=selectedSKU!.uom;
                    if(_fromdatecontroller.text.toString()!="") {
                      order.saudaValidFromDate =
                          DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(),DateTimeUtils.DD_MM_YYYY_Format,DateTimeUtils.YYYY_MM_DD_Format);
                    }else{
                      order.saudaValidFromDate ="";
                    }
                    if(_todatecontroller.text.toString()!="") {
                      order.saudaValidToDate = DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(),DateTimeUtils.DD_MM_YYYY_Format,DateTimeUtils.YYYY_MM_DD_Format);
                    }else{
                      order.saudaValidToDate ="";
                    }
                    order.discountAmountPerCase =0;
                    order.discountAmount =0;
                    if(_discountcontroller.text.toString()!="") {
                      order.discountAmountPerCase =
                          double.parse(_discountcontroller.text.toString());
                    }
                    double finalPrice = 0;
                    if (selectedSKU!.price! > 0) {
                      if (widget.selectedDiscountType == 1) {
                        finalPrice =
                            selectedSKU!.price! - order.discountAmountPerCase!;
                      } else {
                        finalPrice =
                            selectedSKU!.price! + order.discountAmountPerCase!;
                      }
                    }
                    if(_discountcontroller.text.toString()!="") {
                      order.discountAmount =
                          double.parse(_discountcontroller.text.toString()) *
                              order.bidQuantity!;
                    }
                    order.quotedPrice = finalPrice;
                    order.statusId=1;
                    saudaOrders.add(order);
                  }
                  NewSaudaRequest request = NewSaudaRequest();
                  request.salesOrganizationId=selectedSalesOrg!.id;
                  request.distributionChannelId=selectedDistrChannel!.id;
                  request.divisionId=selectedVertical!.id;
                  request.dealerId = selectedDistributor!.id;
                  request.bDOId = Constants.AUTH_USERID;
                  request.loginUserId = Constants.AUTH_USERID;
                  request.saudaBookingTypeId =
                      selectedDistributor!.saudaBookingTypeId;
                  request.biddingDate = DateTimeUtils().dateToStringFormat(
                      DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format);
                  request.brokerId = selectedBroker!=null?selectedBroker!.id!:0;
                  request.saudaOrders = saudaOrders;
                  BlocProvider.of<NewSaudaBloc>(context)
                      .add(SaveSauda(request: request));
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
                // if(_pdiscountcontroller.text.toString()==""){
                //   showSuccessDlg(context, "Error", "Error",successText: "Enter Discount Amount");
                //   return;
                // }
                if(_pquantitycontroller.text.toString()==""){
                  showSuccessDlg(context, "Error", "Error",successText: "Enter Quantity");
                  return;
                }
                if(selectedEditIndex==-1) {
                  SaudaOrders order = SaudaOrders();
                  order.incoTerms = selectedIncoTerms!.name;
                  order.incotermsId = selectedIncoTerms!.id;
                  order.skuName = pSelectedSKU!.skuName;
                  order.skuId = pSelectedSKU!.skuId;
                  order.oilTypeId = pSelectedOilType!.id;
                  order.plantId = selectedPlant!.id;
                  order.bidQuantity =
                      int.parse(_pquantitycontroller.text.toString());
                  order.discountTypeId = pSelectedDiscountType;
                  order.plantDepot = selectedPlant!.name;
                  order.pricingId = pSelectedSKU!.pricingId;
                  order.uomName=pSelectedSKU!.uom;
                  if (_fromdatecontroller.text.toString() != "") {
                    order.saudaValidFromDate =
                        DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format);
                  } else {
                    order.saudaValidFromDate = "";
                  }
                  if (_todatecontroller.text.toString() != "") {
                    order.saudaValidToDate =
                        DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format);
                  } else {
                    order.saudaValidToDate = "";
                  }
                  order.discountAmountPerCase = 0;
                  order.discountAmount = 0;
                  if (_pdiscountcontroller.text.toString() != "") {
                    order.discountAmountPerCase =
                        double.parse(_pdiscountcontroller.text.toString());
                  }
                  double finalPrice = 0;
                  if (pSelectedSKU!.price! > 0) {
                    if (pSelectedDiscountType == 1) {
                      finalPrice =
                          pSelectedSKU!.price! - order.discountAmountPerCase!;
                    } else {
                      finalPrice =
                          pSelectedSKU!.price! + order.discountAmountPerCase!;
                    }
                  }
                  if (_pdiscountcontroller.text.toString() != "") {
                    order.discountAmount =
                        double.parse(_pdiscountcontroller.text.toString()) *
                            order.bidQuantity!;
                  }
                  order.quotedPrice = finalPrice;
                  order.statusId = 1;
                  saudaOrders.add(order);
                }else{
                  SaudaOrders order = saudaOrders[selectedEditIndex];
                  order.incoTerms = selectedIncoTerms!.name;
                  order.incotermsId = selectedIncoTerms!.id;
                  order.skuName = pSelectedSKU!.skuName;
                  order.skuId = pSelectedSKU!.skuId;
                  order.oilTypeId = pSelectedOilType!.id;
                  order.plantId = selectedPlant!.id;
                  order.bidQuantity =
                      int.parse(_pquantitycontroller.text.toString());
                  order.discountTypeId = pSelectedDiscountType;
                  order.plantDepot = selectedPlant!.name;
                  order.pricingId = pSelectedSKU!.pricingId;
                  order.uomName=pSelectedSKU!.uom;
                  if (_pfromdatecontroller.text.toString() != "") {
                    order.saudaValidFromDate =
                        DateTimeUtils().dateToServerToDateFormat(
                            _pfromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format);
                  } else {
                    order.saudaValidFromDate = "";
                  }
                  if (_ptodatecontroller.text.toString() != "") {
                    order.saudaValidToDate =
                        DateTimeUtils().dateToServerToDateFormat(
                            _ptodatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format);
                  } else {
                    order.saudaValidToDate = "";
                  }
                  order.discountAmountPerCase = 0;
                  order.discountAmount = 0;
                  if (_pdiscountcontroller.text.toString() != "") {
                    order.discountAmountPerCase =
                        double.parse(_pdiscountcontroller.text.toString());
                  }
                  double finalPrice = 0;
                  if (pSelectedSKU!.price! > 0) {
                    if (pSelectedDiscountType == 1) {
                      finalPrice =
                          pSelectedSKU!.price! - order.discountAmountPerCase!;
                    } else {
                      finalPrice =
                          pSelectedSKU!.price! + order.discountAmountPerCase!;
                    }
                  }
                  if (_pdiscountcontroller.text.toString() != "") {
                    order.discountAmount =
                        double.parse(_pdiscountcontroller.text.toString()) *
                            order.bidQuantity!;
                  }
                  order.quotedPrice = finalPrice;
                  order.statusId = 1;
                }
                Navigator.pop(context);
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
    _discountcontroller.dispose();
    _quantitycontroller.dispose();
    super.dispose();
  }

  void calculatePrice() {
    finalRate = 0;
    double selectedRate = 0;
    double finalPrice = 0;
    double qty = 0;
    selectedRate = selectedSKU!.price!;
    finalPrice = selectedRate;
    if (_discountcontroller.text.toString() != "") {
      if (selectedSKU!.price! > 0) {
        if (widget.selectedDiscountType == 1) {
          finalPrice = selectedSKU!.price! -
              double.parse(_discountcontroller.text.toString());
        } else {
          finalPrice = selectedSKU!.price! +
              double.parse(_discountcontroller.text.toString());
        }
      }
    }
    if (_quantitycontroller.text.toString() != "") {
      qty = double.parse(_quantitycontroller.text.toString());
    }
    finalRate = finalPrice * qty;
    rate = selectedRate * qty;
    setState(() {});
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
      content:   Container(
          width: MediaQuery.of(context).size.width*0.70,
          child:Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title=="Error"?Icon(Icons.error_outlined ,size:70,color: Colors.red):Icon(Icons.check_circle_sharp ,size:70,color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title,style:TextStyle(
                        fontSize: Constant.fontSize20,
                        fontWeight: Constant.fontWeight600
                    )),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,style:TextStyle(
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
                buttonName: "Done",
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
                  if(closeScreen!) {
                    Navigator.pop(context);
                  }
                  if(title=="Error"){
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SaudaScreen()),
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
  double getTotalValue(){
    double total=0;
    for(SaudaOrders o in saudaOrders){
        total=total+(o.bidQuantity!*o.quotedPrice!);
    }
    return total;
  }
  _selectFromDate(BuildContext context,bool popup) async {
    if(!popup) {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _fromdatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
              _fromdatecontroller.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format,
              DateTimeUtils.YYYY_MM_DD_Format)),
          firstDate: DateTime.now().add(const Duration(days: -365)),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (selected != null) {
        _fromdatecontroller.text = DateTimeUtils()
            .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      }
    }else{
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _pfromdatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
              _pfromdatecontroller.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format,
              DateTimeUtils.YYYY_MM_DD_Format)),
          firstDate: DateTime.now().add(const Duration(days: -365)),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (selected != null) {
        _pfromdatecontroller.text = DateTimeUtils()
            .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      }
    }
  }

  _selectToDate(BuildContext context,bool popup) async {
    if(!popup) {
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
    }else{
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _ptodatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
              _ptodatecontroller.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format,
              DateTimeUtils.YYYY_MM_DD_Format)),
          firstDate: _ptodatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
              _ptodatecontroller.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format,
              DateTimeUtils.YYYY_MM_DD_Format)),
          lastDate: DateTime.now());
      if (selected != null) {
        _ptodatecontroller.text = DateTimeUtils()
            .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      }
    }
  }
}
