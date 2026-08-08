import 'dart:convert';

import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/contract_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/filler_sku_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sales_order_request.dart';
import 'package:adaniwilmar/models/skulist_response.dart';
import 'package:adaniwilmar/models/vehicle_size_response.dart';
import 'package:adaniwilmar/screen/new_sales_order_form/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda_sales_order_status/sauda_sale_order_status.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:adaniwilmar/widget/multiselect/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/common_dropdown_button_form_field.dart';
import '../../widget/widget.dart';

class NewSalesOrderScreen extends StatelessWidget {
  const NewSalesOrderScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const NewSalesOrderScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewSalesOrderBloc()
        ..add(LoadNewSalesOrderScreen(userId: Constants.AUTH_USERID, salesOrganizationId: 0, distributionChannelId: 0, divisonId: 0))
        ..add(LoadDefaults(id: Constants.AUTH_USERID)),
      // ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
      // ..add(LoadOilType()),
      child: const NewSalesOrderForm(),
    );
  }
}

class NewSalesOrderForm extends StatefulWidget {
  const NewSalesOrderForm({Key? key}) : super(key: key);

  @override
  State<NewSalesOrderForm> createState() => _NewSalesOrderFormState();
}

class _NewSalesOrderFormState extends State<NewSalesOrderForm> {
  List<DistributorList> distributorList = [];
  List<SKUList> skuList = [];
  List<FillerSKU> fillerSkuList = [];
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<IncoTermList> incoTerms = [];
  List<PlanDepotList> plants = [];
  List<DailyRate> dailyRates = [];
  List<OilType> oilTypes = [];
  List<BrokerList> brokerList = [];
  List<VehicleSize> vehicleList = [];
  List<DistributorList> shipToParty = [];
  List<Contract> contracts = [];
  List<BdoList> bdoList = [];
  DealerSaudaDetail saudaDetail = DealerSaudaDetail();
  final TextEditingController _discountcontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _deliveryrequestdatecontroller = TextEditingController();
  final TextEditingController _remarkscontroller = TextEditingController();
  final TextEditingController _skucontroller = TextEditingController();
  SKUList? selectedSKU;
  DistributorList? selectedDistributor;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  IncoTermList? selectedIncoTerms;
  PlanDepotList? selectedPlant;
  OilType? selectedOilType;
  BrokerList? selectedBroker;
  VehicleSize? selectedVehicleSize;
  DistributorList? selectedShipToParty;
  Contract? selectedContract;
  BdoList? selectedBdo;
  List<LiftingRequestDetails> salesOrders = [];
  List<SKUList> salesOrderFillerSku = [];
  DefaultInputResponse userDefaults = DefaultInputResponse(salesOrganizationId: 0, distrinbutionChannelId: 0, divisionId: 0, stateId: 0, plantId: 0);

  double itemRate = 0;
  double itemRatePopup = 0;
  double itemMaxDiscount = 0;
  double itemMaxPremium = 0;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0;
  double screenHeight = 0;
  String deliveryRequestDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = "";
  double rate = 0;
  double finalRate = 0;
  double volumePercentage = 0;
  double weightPercentage = 0;
  double volDispPerc = 0;
  double weightDispPerc = 0;
  double maximumVehicleCapacityInPercent = 0;
  double maximumVolumeCapacityInPercent = 0;
  double netWeight = 0;

  static String _displayStringForOption(DistributorList option) => option.employeeName!;

  static String _displayStringForSkuOption(SKUList option) => option.skuName!;

  final TextEditingController _pdiscountcontroller = TextEditingController();
  final TextEditingController _pquantitycontroller = TextEditingController();
  final TextEditingController _pfromdatecontroller = TextEditingController();
  final TextEditingController _ptodatecontroller = TextEditingController();
  TextEditingController? _skunamecontroller;
  TextEditingController? _distributorcontroller;
  SKUList? pSelectedSKU;
  OilType? pSelectedOilType;
  int? pSelectedDiscountType = 1;
  late final GlobalKey<FormFieldState> _skuKey = GlobalKey();
  int selectedEditIndex = -1;
  Map<String, TextEditingController> _quantitycontrollers = Map<String, TextEditingController>();
  ProgressBarHandler? _handler;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<NewSalesOrderBloc, NewSalesOrderState>(
        listener: (context, state) {
          if (state is OnLoadDefaults) {
            userDefaults = state.defaults;
            BlocProvider.of<NewSalesOrderBloc>(context).add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0));
            if (Constants.AUTH_ROLEID == Constants.DEALER) {
              BlocProvider.of<NewSalesOrderBloc>(context).add(LoadDealerSalesOrderDetail(
                id: Constants.AUTH_USERID,
                saudaBookingTypeId: 1,
                salesOrganizationId: 0,
                distributionChannelId: 0,
                //selectedDistrChannel!.id!,
                divisionId: 0, //selectedVertical!.id!
              ));
              BlocProvider.of<NewSalesOrderBloc>(context).add(LoadShipToParty(distributorId: Constants.AUTH_USERID, salesOrgId: 0));
              BlocProvider.of<NewSalesOrderBloc>(context).add(LoadSKUDetails(
                  userId: Constants.AUTH_USERID,
                  dealerId: Constants.AUTH_ROLEID == Constants.DEALER ? Constants.AUTH_USERID : selectedDistributor!.id!,
                  plantId: 0,
                  saudaNumber: "",
                  oilTypeId: 0,
                  vehicleSize: selectedVehicleSize != null ? double.parse(selectedVehicleSize!.name!) : 0));

            } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
              BlocProvider.of<NewSalesOrderBloc>(context).add(LoadBDO(userId: Constants.AUTH_USERID));
            }
          }
          if (state is OnLoadSuccess) {
            selectedDistributor = null;
            if(_distributorcontroller!=null)
            _distributorcontroller!.text = "";
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            if (userDefaults.salesOrganizationId! > 0) {
              selectedSalesOrg = salesOrgList.where((element) => element.id == userDefaults.salesOrganizationId!).first;
              if (selectedSalesOrg != null) {
                if (Constants.AUTH_ROLEID != Constants.ZHMANAGER) {
                  BlocProvider.of<NewSalesOrderBloc>(context)
                      .add(LoadNewSalesOrderScreen(userId: Constants.AUTH_USERID, salesOrganizationId: selectedSalesOrg!.id!, distributionChannelId: 0, divisonId: 0));
                }
              }
              userDefaults.salesOrganizationId = 0;
            }
            setState(() {});
          }
          if (state is OnLoadBDO) {
            selectedBdo = null;
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnLoadDealerSalesOrderDetail) {
            /*selectedSKU = null;
            _skucontroller.text = "Select Sku";
            _skunamecontroller!.text = "";
            pSelectedSKU = null;*/
            saudaDetail = state.dealerSalesOrderDetail;
            selectedIncoTerms = null;
            incoTerms = state.dealerSalesOrderDetail.incoTermList!;
            if (incoTerms != null && incoTerms.length > 0) {
              selectedIncoTerms = incoTerms[0];
            }
            selectedPlant = null;
            plants = state.dealerSalesOrderDetail.plantDepotListNew!;

            if(Constants.AUTH_ROLEID == Constants.DEALER && userDefaults.plantId!>0 && plants.isNotEmpty){
              selectedPlant = plants.where((element) => element.id == userDefaults.plantId!).first;
            } else if (plants.isNotEmpty && plants.length > 0) {
              if (state.dealerSalesOrderDetail.highestBookedPlantId != null && state.dealerSalesOrderDetail.highestBookedPlantId! > 0) {
                if (plants.where((element) => element.id == state.dealerSalesOrderDetail.highestBookedPlantId!).isNotEmpty) {
                  selectedPlant = plants.where((element) => element.id == state.dealerSalesOrderDetail.highestBookedPlantId!).first;
                }
              } else {
                selectedPlant = plants[0];
              }
            }
            selectedBroker = null;
            brokerList = state.dealerSalesOrderDetail.brokerList!;
            setState(() {});
          }
          if (state is OnLoadSKUDetails) {
            selectedSKU = null;
            _skucontroller.text = "Select Sku";
            _skunamecontroller!.text = "";
            selectedContract = null;
            contracts = [];
            skuList = state.skuList;
            if (skuList != null && skuList.isNotEmpty) {
              maximumVehicleCapacityInPercent = skuList[0].maximumVehicleCapacityInPercent!;
              maximumVolumeCapacityInPercent = skuList[0].maximumVolumeCapacityInPercent!;
            }
            // salesOrders = [];
            // salesOrderFillerSku = [];
            setState(() {});
          }
          if (state is OnLoadFillerSKUDetails) {
            fillerSkuList = state.skuList;
            for (FillerSKU sk in fillerSkuList) {
              _quantitycontrollers[sk.skuId.toString() + "_" + sk.packTypeId.toString()] = new TextEditingController();
              _quantitycontrollers[sk.skuId.toString() + "_" + sk.packTypeId.toString()]!.text = sk.suggestedQuantity!.toStringAsFixed(2);
            }
            setState(() {});
            showCustomAlertDialog(context, "Filler SKU", "Filler SKU", dialogActionButton());
          }

          if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            setState(() {});
          }
          // if (state is OnLoadIncoTerms) {
          //   incoTerms = state.incoTerms;
          //   setState(() {});
          // }
          if (state is OnLoadVerticalList) {
            selectedVertical = null;
            pSelectedOilType = null;
            selectedOilType = null;
            selectedDistributor = null;
            verticals = state.verticalList;
            setState(() {});
          }
          // if (state is OnLoadPlant) {
          //   selectedPlant=null;
          //   plants = state.plantList;
          //   setState(() {});
          // }
          if (state is OnLoadShipToParty) {
            selectedShipToParty = null;
            shipToParty.clear();
            if (Constants.AUTH_ROLEID == Constants.DEALER) {
              DistributorList defaultShipToParty = DistributorList(id: 0, employeeCode: "0", employeeName: "Select Ship To Party");
              shipToParty.add(defaultShipToParty);
            }
            shipToParty.addAll(state.shipToParty);
            selectedVehicleSize = null;
            vehicleList = state.vehicleSize;
            setState(() {});
          }
          if (state is OnLoadContract) {
            selectedContract = null;
            contracts = state.contracts;
            setState(() {});
          }
          if (state is OnLoadOilType) {
            pSelectedOilType = null;
            selectedOilType = null;
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnSaveSalesOrder) {
            showSuccessDlg(context, "Request Confirmed", "Success", successText: state.message);
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
          if (state is OnRateChange) {
            selectedSKU = selectedSKU;
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
              title: "New Sales Order",
              backArrow: true,
              listOfActions: Row(
                children: [],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(height: Constant.containerTopWrapper),
                      CurveOuterBox(
                          boxofWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 16),
                          Visibility(
                              visible: Constants.AUTH_ROLEID != Constants.DEALER,
                              child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: CommonDropdownButtonFormField<SalesOrganization>(
                                      value: selectedSalesOrg,
                                      label: "Sales Organization",
                                      onChanged: (SalesOrganization? newValue) {
                                        if (newValue == null) return;
                                        setState(() {
                                          selectedSalesOrg = newValue;
                                        });
                                        if (Constants.AUTH_ROLEID != Constants.ZHMANAGER) {
                                          BlocProvider.of<NewSalesOrderBloc>(context).add(LoadNewSalesOrderScreen(
                                              userId: Constants.AUTH_USERID, salesOrganizationId: selectedSalesOrg!.id!, distributionChannelId: 0, divisonId: 0));
                                        }
                                        // BlocProvider.of<NewSalesOrderBloc>(context)
                                        //     .add(LoadDistributionChannel(
                                        //         id: selectedSalesOrg!.id!));
                                      },
                                      items: salesOrgList.map<DropdownMenuItem<SalesOrganization>>((value) {
                                        return DropdownMenuItem<SalesOrganization>(
                                          value: value,
                                          child: Text(value.salesOrganizationName!),
                                        );
                                      }).toList(),
                                    ));
                              })),
                          // const SizedBox(height: 16),
                          // StatefulBuilder(builder:
                          //     (BuildContext context, StateSetter setState) {
                          //   return SizedBox(
                          //       width: double.infinity,
                          //       //height: 70,
                          //       child: DropdownButtonFormField<DistributionChannel>(
                          //         isExpanded: true,
                          //         value: selectedDistrChannel,
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
                          //             labelText: "Distribution Channel",
                          //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                          //             fillColor: fillColor),
                          //         onChanged: (DistributionChannel? newValue) {
                          //           setState(() {
                          //             selectedDistrChannel = newValue!;
                          //           });
                          //           BlocProvider.of<NewSalesOrderBloc>(context).add(
                          //               LoadVerticalList(
                          //                   distributionId:
                          //                   selectedDistrChannel!.id!));
                          //         },
                          //         items: distrChannels
                          //             .map<DropdownMenuItem<DistributionChannel>>(
                          //                 (value) {
                          //               return DropdownMenuItem<DistributionChannel>(
                          //                 value: value,
                          //                 child: Text(value.distributionChannelName!),
                          //               );
                          //             }).toList(),
                          //       ));
                          // }),
                          // const SizedBox(height: 16.0),
                          // StatefulBuilder(builder:
                          //     (BuildContext context, StateSetter setState) {
                          //   return SizedBox(
                          //       width: double.infinity,
                          //       //height: 70,
                          //       child: DropdownButtonFormField<Vertical>(
                          //         isExpanded: true,
                          //         value: selectedVertical,
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
                          //             labelText: "Division",
                          //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                          //             fillColor: fillColor),
                          //         onChanged: (Vertical? newValue) {
                          //           setState(() {
                          //             selectedVertical = newValue!;
                          //           });
                          //           BlocProvider.of<NewSalesOrderBloc>(context).add(LoadNewSalesOrderScreen(userId: Constants.AUTH_USERID,
                          //               salesOrganizationId: selectedSalesOrg!.id!,
                          //               distributionChannelId: selectedDistrChannel!.id!,
                          //               divisonId: selectedVertical!.id!));
                          //           BlocProvider.of<NewSalesOrderBloc>(context).add(LoadOilType(userId: Constants.AUTH_USERID,
                          //               salesOrganizationId: selectedSalesOrg!.id!,
                          //               distributionChannelId: selectedDistrChannel!.id!,
                          //               divisonId: selectedVertical!.id!));
                          //         },
                          //         items: verticals
                          //             .map<DropdownMenuItem<Vertical>>((value) {
                          //           return DropdownMenuItem<Vertical>(
                          //             value: value,
                          //             child: Text(value.name!),
                          //           );
                          //         }).toList(),
                          //       ));
                          // }),
                          Visibility(visible: Constants.AUTH_ROLEID != Constants.DEALER, child: const SizedBox(height: 16)),
                          Visibility(
                            visible: Constants.AUTH_ROLEID == Constants.ZHMANAGER,
                            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                              return SizedBox(
                                  width: double.infinity,
                                  // height: 70,
                                  child: CommonDropdownButtonFormField<BdoList>(
                                    value: selectedBdo,
                                    label: "State Trader",
                                    onChanged: (BdoList? newValue) {
                                      if (newValue == null) return;
                                      setState(() {
                                        selectedBdo = newValue;
                                      });
                                      BlocProvider.of<NewSalesOrderBloc>(context).add(LoadNewSalesOrderScreen(
                                          userId: Constants.AUTH_USERID,
                                          salesOrganizationId: selectedSalesOrg!.id!,
                                          distributionChannelId: 0,
                                          divisonId: 0,
                                          bdoId: selectedBdo != null ? selectedBdo!.id! : 0));
                                    },
                                    items: bdoList.map<DropdownMenuItem<BdoList>>((value) {
                                      return DropdownMenuItem<BdoList>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                                  ));
                            }),
                          ),
                          Visibility(visible: Constants.AUTH_ROLEID == Constants.ZHMANAGER, child: const SizedBox(height: 16)),
                          Visibility(
                            visible: Constants.AUTH_ROLEID != Constants.DEALER,
                            child:
                                // StatefulBuilder(builder:
                                //     (BuildContext context, StateSetter setState) {
                                //   return SizedBox(
                                //       width: double.infinity,
                                //       // height: 70,
                                //       child: DropdownButtonFormField<DistributorList>(
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
                                //                     bottomLeft: Radius.circular(borderRadiusTRBL),
                                //                     bottomRight: Radius.circular(borderRadiusTLBR)),
                                //                 borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                //             filled: true,
                                //             // hintStyle: TextStyle(color: Colors.grey[800]),
                                //             labelText: "Distributor Name",
                                //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                //             fillColor: fillColor),
                                //         onChanged: (DistributorList? newValue) {
                                //           setState(() {
                                //             selectedDistributor = newValue!;
                                //           });
                                //           BlocProvider.of<NewSalesOrderBloc>(context)
                                //               .add(LoadDealerSalesOrderDetail(
                                //             id: selectedDistributor!.id!,
                                //             saudaBookingTypeId: selectedDistributor!
                                //                 .saudaBookingTypeId!,
                                //             salesOrganizationId:
                                //                 selectedSalesOrg != null
                                //                     ? selectedSalesOrg!.id!
                                //                     : 0,
                                //             distributionChannelId:
                                //                 0, //selectedDistrChannel!.id!,
                                //             divisionId: 0, //selectedVertical!.id!
                                //           ));
                                //           BlocProvider.of<NewSalesOrderBloc>(context)
                                //               .add(LoadShipToParty(
                                //                   distributorId:
                                //                       selectedDistributor!.id!,
                                //                   salesOrgId: selectedSalesOrg != null
                                //                       ? selectedSalesOrg!.id!
                                //                       : 0));
                                //         },
                                //         items: distributorList
                                //             .map<DropdownMenuItem<DistributorList>>(
                                //                 (value) {
                                //           return DropdownMenuItem<DistributorList>(
                                //             value: value,
                                //             child: Text(value.employeeName!,
                                //                 overflow: TextOverflow.visible),
                                //           );
                                //         }).toList(),
                                //       ));
                                // })
                                CustomAutocomplete<DistributorList>(
                              fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                                _distributorcontroller = fieldTextEditingController;
                                return TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(borderRadiusTLBR),
                                              topRight: Radius.circular(borderRadiusTRBL),
                                              bottomLeft: Radius.circular(borderRadiusTRBL),
                                              bottomRight: Radius.circular(borderRadiusTLBR)),
                                          borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(borderRadiusTLBR),
                                              topRight: Radius.circular(borderRadiusTRBL),
                                              bottomLeft: Radius.circular(borderRadiusTRBL),
                                              bottomRight: Radius.circular(borderRadiusTLBR)),
                                          borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(borderRadiusTLBR),
                                              topRight: Radius.circular(borderRadiusTRBL),
                                              bottomLeft: Radius.circular(borderRadiusTRBL),
                                              bottomRight: Radius.circular(borderRadiusTLBR)),
                                          borderSide: BorderSide(color: borderColor!, width: 1.0)),
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
                                  return option.employeeName.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (DistributorList selection) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  selectedDistributor = selection;
                                });
                                BlocProvider.of<NewSalesOrderBloc>(context).add(LoadSKUDetails(
                                    userId: Constants.AUTH_USERID,
                                    dealerId: Constants.AUTH_ROLEID == Constants.DEALER ? Constants.AUTH_USERID : selectedDistributor!.id!,
                                    plantId: 0,
                                    saudaNumber: "",
                                    oilTypeId: 0,
                                    vehicleSize: selectedVehicleSize != null ? double.parse(selectedVehicleSize!.name!) : 0));
                                /*BlocProvider.of<NewSalesOrderBloc>(context).add(LoadDealerSalesOrderDetail(
                                  id: selectedDistributor!.id!,
                                  saudaBookingTypeId: selectedDistributor!.saudaBookingTypeId!,
                                  salesOrganizationId: selectedSalesOrg != null ? selectedSalesOrg!.id! : 0,
                                  distributionChannelId: 0,
                                  //selectedDistrChannel!.id!,
                                  divisionId: 0, //selectedVertical!.id!
                                ));*/
                                BlocProvider.of<NewSalesOrderBloc>(context)
                                    .add(LoadShipToParty(distributorId: selectedDistributor!.id!, salesOrgId: selectedSalesOrg != null ? selectedSalesOrg!.id! : 0));
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                              onTap: () {
                                _selectFromDate(context, false);
                              },
                              child: CommonTextFormField(
                                labeltxt: "Delivery Request Date",
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
                                controllerTxt: _deliveryrequestdatecontroller,
                                enabled: false,
                              )),

                          const SizedBox(height: 16),
                          Visibility(
                              visible: false,
                              child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                    width: double.infinity,
                                    //height: 70,
                                    child: CommonDropdownButtonFormField<VehicleSize>(
                                      value: selectedVehicleSize,
                                      label: "Vehicle Size",
                                      onChanged: (VehicleSize? newValue) {
                                        if (newValue == null) return;
                                        setState(() {
                                          selectedVehicleSize = newValue;
                                        });
                                      },
                                      items: vehicleList.map<DropdownMenuItem<VehicleSize>>((value) {
                                        return DropdownMenuItem<VehicleSize>(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                    ));
                              })),
                          const SizedBox(height: 16),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<DistributorList>(
                                  value: selectedShipToParty,
                                  label: "Ship to Party",
                                  onChanged: (DistributorList? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      selectedShipToParty = newValue;
                                    });
                                  },
                                  items: shipToParty.map<DropdownMenuItem<DistributorList>>((value) {
                                    return DropdownMenuItem<DistributorList>(
                                      value: value,
                                      child: Text(value.employeeName!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          // CustomAutoComplete<DistributorList>(
                          //   fieldViewBuilder: (
                          //       BuildContext context,
                          //       TextEditingController fieldTextEditingController,
                          //       FocusNode fieldFocusNode,
                          //       VoidCallback onFieldSubmitted
                          //       ) {
                          //     return TextField(
                          //       decoration:InputDecoration(
                          //           contentPadding: const EdgeInsets.symmetric(
                          //               horizontal: 12.0, vertical: 0.0),
                          //           focusedBorder: OutlineInputBorder(
                          //               borderRadius: BorderRadius.only(
                          //                   topLeft: Radius.circular(
                          //                       borderRadiusTLBR),
                          //                   topRight: Radius.circular(
                          //                       borderRadiusTRBL),
                          //                   bottomLeft: Radius.circular(
                          //                       borderRadiusTRBL),
                          //                   bottomRight: Radius.circular(
                          //                       borderRadiusTLBR)),
                          //               borderSide: BorderSide(
                          //                   color: borderColor!, width: 1.0)),
                          //           border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.only(
                          //                   topLeft: Radius.circular(
                          //                       borderRadiusTLBR),
                          //                   topRight: Radius.circular(
                          //                       borderRadiusTRBL),
                          //                   bottomLeft: Radius.circular(borderRadiusTRBL),
                          //                   bottomRight: Radius.circular(borderRadiusTLBR)),
                          //               borderSide: BorderSide(color: borderColor!, width: 1.0)),
                          //           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                          //           filled: true,
                          //           // hintStyle: TextStyle(color: Colors.grey[800]),
                          //           labelText: "Ship To Party",
                          //           labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                          //           fillColor: fillColor),
                          //       controller: fieldTextEditingController,
                          //       focusNode: fieldFocusNode,
                          //       style: const TextStyle(fontWeight: FontWeight.normal),
                          //     );
                          //   },
                          //   displayStringForOption: _displayStringForOption,
                          //   optionsBuilder: (TextEditingValue textEditingValue) {
                          //     if (textEditingValue.text == '') {
                          //       return const Iterable<DistributorList>.empty();
                          //     }
                          //     return shipToParty.where((DistributorList option) {
                          //       return option.employeeName
                          //           .toString().toLowerCase()
                          //           .contains(textEditingValue.text.toLowerCase());
                          //     });
                          //   },
                          //   onSelected: (DistributorList selection) {
                          //     selectedShipToParty = selection;
                          //   },
                          // ),
                          const SizedBox(height: 16.0),
                          CustomAutocomplete<SKUList>(
                            fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                              _skunamecontroller = fieldTextEditingController;
                              return TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(borderRadiusTLBR),
                                            topRight: Radius.circular(borderRadiusTRBL),
                                            bottomLeft: Radius.circular(borderRadiusTRBL),
                                            bottomRight: Radius.circular(borderRadiusTLBR)),
                                        borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(borderRadiusTLBR),
                                            topRight: Radius.circular(borderRadiusTRBL),
                                            bottomLeft: Radius.circular(borderRadiusTRBL),
                                            bottomRight: Radius.circular(borderRadiusTLBR)),
                                        borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(borderRadiusTLBR),
                                            topRight: Radius.circular(borderRadiusTRBL),
                                            bottomLeft: Radius.circular(borderRadiusTRBL),
                                            bottomRight: Radius.circular(borderRadiusTLBR)),
                                        borderSide: BorderSide(color: borderColor!, width: 1.0)),
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
                                return const Iterable<SKUList>.empty();
                              }
                              return skuList.where((SKUList option) {
                                return option.skuName.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (SKUList selection) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              selectedSKU = selection;
                              BlocProvider.of<NewSalesOrderBloc>(context).add(LoadContractDetail(
                                  distributorId: Constants.AUTH_ROLEID == Constants.DEALER ? Constants.AUTH_USERID : selectedDistributor!.id!,
                                  salesOrgId: selectedSalesOrg != null ? selectedSalesOrg!.id! : 0,
                                  skuId: selectedSKU != null ? selectedSKU!.skuId! : 0));
                              setState(() {});
                            },
                          ),
                          // SizedBox(
                          //     width: double.infinity,
                          //     //height: 70,
                          //     child: Container(
                          //         padding: const EdgeInsets.all(0),
                          //         width: double.infinity,
                          //         height: 70,
                          //         child: InkWell(
                          //             onTap: () {
                          //               _showMultiSelectSku(context);
                          //             },
                          //             child: CommonTextFormField(
                          //               labeltxt: "Select Sku",
                          //               labeltxtColor: Constant.textFormFieldColor,
                          //               labeltxtSize: Constant.textFormFieldSize,
                          //               labeltxtFontWeight:
                          //                   Constant.textFormFieldSizeFontW,
                          //               focuBorColor: Constant.textFormFocuBorCol,
                          //               focuBorWid: Constant.textFormFocuBorWid,
                          //               enaBorColor: Constant.textFormFocuBorCol,
                          //               enaBorWid: Constant.textFormEnaBorWid,
                          //               borderRadiusTL:
                          //                   Constant.textFormborderRadiusTL,
                          //               borderRadiusBR:
                          //                   Constant.textFormborderRadiusBR,
                          //               contentPadHor:
                          //                   Constant.textFormcontentPadHor,
                          //               contentPadHVer:
                          //                   Constant.textFormcontentPadHVer,
                          //               keyborType: TextInputType.text,
                          //               enabled: false,
                          //               dropdownIcon: true,
                          //               controllerTxt: _skucontroller,
                          //             )))
                          //     // DropdownButtonFormField<SKUList>(
                          //     //   isExpanded: true,
                          //     //   value: selectedSKU,
                          //     //   icon: const Align(
                          //     //       alignment: Alignment.topRight,
                          //     //       child: Icon(
                          //     //         Icons.keyboard_arrow_down,
                          //     //         size: 16,
                          //     //       )),
                          //     //   elevation: 16,
                          //     //   style: const TextStyle(color: Colors.black),
                          //     //   decoration: InputDecoration(
                          //     //       contentPadding: const EdgeInsets.symmetric(
                          //     //           horizontal: 10.0, vertical: 0.0),
                          //     //       focusedBorder: OutlineInputBorder(
                          //     //           borderRadius: BorderRadius.only(
                          //     //               topLeft:
                          //     //               Radius.circular(borderRadiusTLBR),
                          //     //               topRight:
                          //     //               Radius.circular(borderRadiusTRBL),
                          //     //               bottomLeft:
                          //     //               Radius.circular(borderRadiusTRBL),
                          //     //               bottomRight:
                          //     //               Radius.circular(borderRadiusTLBR)),
                          //     //           borderSide: BorderSide(
                          //     //               color: borderColor!, width: 1.0)),
                          //     //       border: OutlineInputBorder(
                          //     //           borderRadius: BorderRadius.only(
                          //     //               topLeft:
                          //     //               Radius.circular(borderRadiusTLBR),
                          //     //               topRight:
                          //     //               Radius.circular(borderRadiusTRBL),
                          //     //               bottomLeft:
                          //     //               Radius.circular(borderRadiusTRBL),
                          //     //               bottomRight:
                          //     //               Radius.circular(borderRadiusTLBR)),
                          //     //           borderSide: BorderSide(
                          //     //               color: borderColor!, width: 1.0)),
                          //     //       enabledBorder: OutlineInputBorder(
                          //     //           borderRadius: BorderRadius.only(
                          //     //               topLeft:
                          //     //               Radius.circular(borderRadiusTLBR),
                          //     //               topRight:
                          //     //               Radius.circular(borderRadiusTRBL),
                          //     //               bottomLeft:
                          //     //               Radius.circular(borderRadiusTRBL),
                          //     //               bottomRight:
                          //     //               Radius.circular(borderRadiusTLBR)),
                          //     //           borderSide: BorderSide(
                          //     //               color: borderColor!, width: 1.0)),
                          //     //       filled: true,
                          //     //       // hintStyle: TextStyle(color: Colors.grey[800]),
                          //     //       labelText: "SKU Name",
                          //     //       labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                          //     //       fillColor: fillColor),
                          //     //   onChanged: (SKUList? newValue) {
                          //     //     selectedSKU = newValue!;
                          //     //     BlocProvider.of<NewSalesOrderBloc>(context).add(
                          //     //         LoadContractDetail(
                          //     //             distributorId: Constants.AUTH_ROLEID ==
                          //     //                 Constants.DEALER
                          //     //                 ? Constants.AUTH_USERID
                          //     //                 : selectedDistributor!.id!,
                          //     //             salesOrgId: selectedSalesOrg!=null?selectedSalesOrg!.id!:0,
                          //     //             skuId: selectedSKU!=null?selectedSKU!.skuId!:0
                          //     //           ));
                          //     //     setState(() {});
                          //     //   },
                          //     //   items:
                          //     //   skuList.map<DropdownMenuItem<SKUList>>((value) {
                          //     //     return DropdownMenuItem<SKUList>(
                          //     //       value: value,
                          //     //       child: Text(value.skuName!,
                          //     //           overflow: TextOverflow.visible),
                          //     //     );
                          //     //   }).toList(),
                          //     // )
                          //     ),
                          const SizedBox(height: 16.0),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<Contract>(
                                  value: selectedContract,
                                  label: "Contract Number",
                                  onChanged: (Contract? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      selectedContract = newValue;
                                    });
                                    _quantitycontroller.text = "";
                                    LiftingRequestDetails? lr = null;
                                    if (selectedSKU != null && selectedContract != null) {
                                      if (salesOrders.where((element) => element.skuId == selectedSKU!.skuId! && element.saudaOrderId == selectedContract!.saudaOrderId!).isNotEmpty) {
                                        lr = salesOrders.where((element) => element.skuId == selectedSKU!.skuId! && element.saudaOrderId == selectedContract!.saudaOrderId!).first;
                                      }
                                      if (lr != null && lr.liftingQuantity != null) {
                                        _quantitycontroller.text = lr.liftingQuantity!.toStringAsFixed(2);
                                      }
                                    }
                                      BlocProvider.of<NewSalesOrderBloc>(context).add(LoadDealerSalesOrderDetail(
                                        id: Constants.AUTH_ROLEID == Constants.DEALER?Constants.AUTH_USERID: selectedDistributor?.id!??0,
                                        saudaBookingTypeId:Constants.AUTH_ROLEID == Constants.DEALER?1: selectedDistributor!.saudaBookingTypeId!,
                                        salesOrganizationId: selectedContract?.salesOrganizationId,
                                        distributionChannelId: selectedContract?.distributionChannelId,
                                        //selectedDistrChannel!.id!,
                                        divisionId: selectedContract?.divisionId, //selectedVertical!.id!
                                      ));
                                    setParentState();
                                  },
                                  items: contracts.map<DropdownMenuItem<Contract>>((value) {
                                    return DropdownMenuItem<Contract>(
                                      value: value,
                                      child: Text(value.saudaNumber!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          const SizedBox(height: 16.0),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<PlanDepotList>(
                                  value: selectedPlant,
                                  label: "Plant",
                                  onChanged: (PlanDepotList? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      selectedPlant = newValue;
                                    });
                                  },
                                  items: plants.map<DropdownMenuItem<PlanDepotList>>((value) {
                                    return DropdownMenuItem<PlanDepotList>(
                                      value: value,
                                      child: Text(value.name!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          const SizedBox(height: 16.0),
                          CommonText(
                              name: "Available Quantity : " + (selectedContract != null ? selectedContract!.availableQuantity!.toStringAsFixed(2) : "0.00"),
                              fontSize: Constant.fontSize13,
                              fontColor: Constant.colorBlack,
                              fontWeight: Constant.fontWeight600),
                          const SizedBox(height: 8.0),
                          CommonText(
                              name: "SO Open Quantity : " + (selectedContract != null ? selectedContract!.soOpenQuantity!.toStringAsFixed(2) : "0.00"),
                              fontSize: Constant.fontSize13,
                              fontColor: Constant.colorBlack,
                              fontWeight: Constant.fontWeight600),

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
                                if (selectedSKU != null) {
                                  double quantity = 0;
                                  if (_quantitycontroller.text.toString() != "") {
                                    quantity = double.parse(_quantitycontroller.text.toString());
                                  } else {
                                    quantity = 0;
                                  }
                                  if (selectedContract != null) {
                                    if (quantity > selectedContract!.availableQuantity!) {
                                      selectedSKU!.usedQuantity = selectedContract!.availableQuantity;
                                      _quantitycontroller.text = selectedContract!.availableQuantity!.toStringAsFixed(2);
                                    }
                                  }
                                }
                                setState(() {});
                              }),
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Container(
                              width: 3,
                              height: 34,
                              color: Constant.callToCcolor1,
                              margin: const EdgeInsets.only(top: 3),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CommonText(name: "SKU List", fontSize: Constant.fontSize13, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                            ),
                            InkWell(
                                onTap: () {
                                  if (_quantitycontroller.text.toString() == "") {
                                    return;
                                  }
                                  if (selectedSKU == null) {
                                    return;
                                  }
                                  if (selectedContract == null) {
                                    return;
                                  }
                                  if (selectedSKU != null) {
                                    LiftingRequestDetails? lr = null;
                                    if (salesOrders.where((element) => element.skuId == selectedSKU!.skuId! && element.saudaOrderId == selectedContract!.saudaOrderId!).isNotEmpty) {
                                      lr = salesOrders.where((element) => element.skuId == selectedSKU!.skuId! && element.saudaOrderId == selectedContract!.saudaOrderId!).first;
                                    }
                                    if (lr == null) {
                                      lr = LiftingRequestDetails();
                                      lr.skuName = selectedSKU!.skuName;
                                      lr.skuId = selectedSKU!.skuId;
                                      lr.skuCode = selectedSKU!.skuCode;
                                      lr.liftingQuantity = double.parse(_quantitycontroller.text.toString());
                                      lr.liftingQuantityInMT = double.parse(_quantitycontroller.text.toString()) * selectedSKU!.caseToMetricTonValue!;
                                      lr.saudaOrderId = selectedContract!.saudaOrderId!;
                                      lr.saudaNumber = selectedContract!.saudaNumber!;
                                      salesOrders.add(lr);
                                    } else {
                                      lr.skuName = selectedSKU!.skuName;
                                      lr.skuId = selectedSKU!.skuId;
                                      lr.skuCode = selectedSKU!.skuCode;
                                      lr.liftingQuantity = double.parse(_quantitycontroller.text.toString());
                                      lr.liftingQuantityInMT = double.parse(_quantitycontroller.text.toString()) * selectedSKU!.caseToMetricTonValue!;
                                      lr.saudaOrderId = selectedContract!.saudaOrderId!;
                                      lr.saudaNumber = selectedContract!.saudaNumber!;
                                    }
                                    selectedSKU = null;
                                    _quantitycontroller.text = "";
                                    _skunamecontroller!.text = "";
                                    selectedContract = null;
                                    // calculateVolumePercentage();
                                    setState(() {});
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: SizedBox(width: 25, height: 25, child: Icon(Icons.add_circle, color: Constant.colorOrange)),
                                )),
                            const SizedBox(width: 12),
                          ]),
                          const SizedBox(height: 16),
                          Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFECECEC),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(25.0),
                                ),
                              ),
                              child: ListView.builder(
                                  key: const Key('builder1'),
                                  //attention
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: salesOrders.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                Expanded(
                                                  child: CommonText(
                                                      name: "Contract ID : " + salesOrders[index].saudaNumber!,
                                                      fontSize: Constant.fontSize13,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight600),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      salesOrders.removeAt(index);
                                                      // calculateVolumePercentage();
                                                      setState(() {});
                                                    },
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: SizedBox(width: 25, height: 25, child: Icon(Icons.delete, color: Constant.colorGray45)),
                                                    )),
                                                const SizedBox(width: 12),
                                              ]),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            CommonText(
                                                              name: salesOrders[index].skuName,
                                                              fontColor: Constant.colorBlack,
                                                              fontSize: Constant.fontSize12,
                                                              fontWeight: Constant.fontWeight600,
                                                            ),
                                                            const SizedBox(width: 6),
                                                            CommonText(
                                                              name: "(" + salesOrders[index].liftingQuantityInMT!.toStringAsFixed(2) + " MT)",
                                                              fontColor: Constant.colorRed,
                                                              fontSize: Constant.fontSize12,
                                                              fontWeight: Constant.fontWeight600,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment: Alignment.centerRight,
                                                      child: CommonText(
                                                        name: salesOrders[index].liftingQuantity!.toStringAsFixed(2),
                                                        fontSize: Constant.fontSize11,
                                                        fontColor: Constant.colorOrange,
                                                        fontWeight: Constant.fontWeight500,
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(visible: index < salesOrders.length - 1, child: const BorderBottom()),
                                      ],
                                    );
                                  })),
                          const SizedBox(height: 16.0),
                          Visibility(
                              visible: false,
                              child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(25.0),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CommonText(name: "", fontSize: Constant.fontSize13, fontColor: Constant.colorDullGray77, fontWeight: Constant.fontWeight500),
                                      CommonText(name: "Weight%", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                      const SizedBox(height: 12),
                                      Row(children: [
                                        Expanded(
                                            child: Container(
                                                child: LinearProgressIndicator(
                                          value: weightDispPerc,
                                          color: Colors.orangeAccent,
                                          backgroundColor: Colors.grey,
                                        ))),
                                        SizedBox(width: 4),
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.20,
                                            child: CommonText(
                                                name: weightPercentage.toStringAsFixed(2), fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500))
                                      ]),
                                      const SizedBox(height: 12),
                                      CommonText(name: "Volume%", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                      const SizedBox(height: 12),
                                      Row(children: [
                                        Expanded(
                                            child: Container(
                                          child: LinearProgressIndicator(
                                            value: volDispPerc,
                                            color: Colors.greenAccent,
                                            backgroundColor: Colors.grey,
                                          ),
                                        )),
                                        SizedBox(width: 4),
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.20,
                                            child: CommonText(
                                                name: volumePercentage.toStringAsFixed(2), fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500))
                                      ]),
                                      const SizedBox(height: 12),
                                      CommonText(name: "Net Weight", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77, fontWeight: Constant.fontWeight500),
                                      const SizedBox(height: 12),
                                      CommonText(name: netWeight.toStringAsFixed(2), fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77, fontWeight: Constant.fontWeight500),
                                    ],
                                  ))),
                          Visibility(visible: false, child: const SizedBox(height: 8)),
                          Visibility(
                              visible: false,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Container(
                                  width: 3,
                                  height: 34,
                                  color: Constant.callToCcolor1,
                                  margin: const EdgeInsets.only(top: 3),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CommonText(name: "Filler SKU", fontSize: Constant.fontSize13, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                ),
                                // InkWell(
                                //     onTap:() {
                                //       BlocProvider.of<NewSalesOrderBloc>(context).add(LoadFillerSKUDetails(userId: Constants.AUTH_USERID,
                                //           volumePercentage: 1, plantId: selectedPlant!.id!,
                                //           dealerId: selectedDistributor!.id!,
                                //           vehicleSize: double.parse(selectedVehicleSize!.name!),
                                //           weightPercentage: 1));
                                //     }
                                //     ,child:Align(
                                //   alignment: Alignment.topRight,
                                //   child: SizedBox(
                                //       width: 25,
                                //       height: 25,
                                //       child: Icon(Icons.add_circle, color: Constant.colorOrange)),
                                // )),
                                // const SizedBox(width: 12),
                              ])),
                          Visibility(visible: false, child: const SizedBox(height: 16)),
                          Visibility(
                              visible: false,
                              child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECEC),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(25.0),
                                    ),
                                  ),
                                  child: ListView.builder(
                                      key: const Key('builder2'),
                                      //attention
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: skuList.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                            visible: (skuList[index].availableQuantity! - skuList[index].usedQuantity!) > 0,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      // Row(
                                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                                      //     children: [
                                                      //       Expanded(
                                                      //         child: CommonText(
                                                      //             name: "",
                                                      //             fontSize: Constant.fontSize13,
                                                      //             fontColor: Constant.colorBlack,
                                                      //             fontWeight: Constant.fontWeight600),
                                                      //       ),
                                                      //       InkWell(
                                                      //           onTap:() {
                                                      //             salesOrderFillerSku.removeAt(index);
                                                      //             setState(() {
                                                      //
                                                      //             });
                                                      //           }
                                                      //           ,child:Align(
                                                      //         alignment: Alignment.topRight,
                                                      //         child: SizedBox(
                                                      //             width: 25,
                                                      //             height: 25,
                                                      //             child: Icon(Icons.delete, color: Constant.colorGray45)),
                                                      //       )),
                                                      //       const SizedBox(width: 12),
                                                      //     ]),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    CommonText(
                                                                      name: skuList[index].skuName,
                                                                      fontColor: Constant.colorBlack,
                                                                      fontSize: Constant.fontSize12,
                                                                      fontWeight: Constant.fontWeight600,
                                                                    ),
                                                                    const SizedBox(width: 6),
                                                                    CommonText(
                                                                      name: "(" + (skuList[index].availableQuantity! * skuList[index].caseToMetricTonValue!).toStringAsFixed(2) + ")",
                                                                      fontColor: Constant.colorRed,
                                                                      fontSize: Constant.fontSize12,
                                                                      fontWeight: Constant.fontWeight600,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                              alignment: Alignment.centerRight,
                                                              child: CommonText(
                                                                name: (skuList[index].availableQuantity! - skuList[index].usedQuantity!).toStringAsFixed(2),
                                                                fontSize: Constant.fontSize11,
                                                                fontColor: Constant.colorOrange,
                                                                fontWeight: Constant.fontWeight500,
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(visible: index < skuList.length - 1, child: const BorderBottom()),
                                              ],
                                            ));
                                      }))),
                          const SizedBox(height: 16),
                          CommonTextFormField(
                            maxLine: 4,
                            labeltxt: "Remarks",
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
                            controllerTxt: _remarkscontroller,
                          ),
                          const SizedBox(height: 16),
                        ],
                      )),
                    ],
                  )),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }),
              progressBar
            ],
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
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
                        showConfirmDlg(context, "Confirm SalesOrder Request", "Confirm Request");
                      },
                    ),
                  ),
                ],
              )),
        )));
  }

  void showCustomAlertDialog(BuildContext context, messageValue, title, footerbutton, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
    // set up the button

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
              width: MediaQuery.of(context).size.width * 0.90,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 500.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 400,
                      child: ListView.builder(
                        // shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: ClampingScrollPhysics(),
                        itemCount: fillerSkuList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 180,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                fillerSkuList[index].skuName!,
                                                style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: Checkbox(
                                                  onChanged: (bool? value) {
                                                    fillerSkuList[index].isSelected = value!;
                                                    setState(() {});
                                                  },
                                                  value: fillerSkuList[index].isSelected!,
                                                  activeColor: Colors.green[600],
                                                ))
                                          ],
                                        )
                                      ],
                                    )),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
                                  child: Column(children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.30,
                                            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(
                                                "Suggested Quantity",
                                                style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorGray45),
                                              ),
                                              Text(fillerSkuList[index].suggestedQuantity!.toStringAsFixed(2),
                                                  style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500))
                                            ])),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.30,
                                          child: CommonTextFormField(
                                              labeltxt: "Add Qty",
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
                                              controllerTxt: _quantitycontrollers[fillerSkuList[index].skuId.toString() + "_" + fillerSkuList[index].packTypeId.toString()],
                                              keyborType: TextInputType.number,
                                              onChanged: (String? value) {
                                                if (_quantitycontrollers[fillerSkuList[index].skuId.toString() + "_" + fillerSkuList[index].packTypeId.toString()]!.text.toString() != "") {
                                                  fillerSkuList[index].selectedQty =
                                                      double.parse(_quantitycontrollers[fillerSkuList[index].skuId.toString() + "_" + fillerSkuList[index].packTypeId.toString()]!.text.toString());
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                      ],
                                    )
                                  ]),
                                )
                              ],
                            ),
                          );
                        },
                      ))
                ],
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

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white, bool? closeScreen = false}) {
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
                    child: title == "Error" ? Icon(Icons.error_outlined, size: 70, color: Colors.red) : Icon(Icons.check_circle_sharp, size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
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
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaudaSalesOrderStatusScreen()),
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
                for (FillerSKU sk in fillerSkuList) {
                  if (sk.isSelected!) {
                    LiftingRequestDetails lr = LiftingRequestDetails();
                    lr.skuName = sk.skuName;
                    lr.skuId = sk.skuId;
                    lr.skuCode = sk.skuCode;
                    if (_quantitycontrollers[sk.skuId.toString() + "_" + sk.packTypeId!.toString()]!.text.toString() != "") {
                      lr.liftingQuantity = double.parse(_quantitycontrollers[sk.skuId.toString() + "_" + sk.packTypeId!.toString()]!.text.toString());
                      lr.liftingQuantityInMT = double.parse(_quantitycontrollers[sk.skuId.toString() + "_" + sk.packTypeId!.toString()]!.text.toString()) * sk.caseToMetricTon!;
                    }
                    // salesOrderFillerSku.add(lr);
                  }
                }
                setState(() {});
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

  void showConfirmDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
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
      // content: const Text("Confirm Sales Order Request"),
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
                    child: Icon(Icons.error_outlined, size: 54, color: Constant.homeBoxPendingOrange),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Confirm Sales Order Request?', style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Are you sure you want to confirm sales order request?',
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
                  // if(selectedSalesOrg==null){
                  //   showSuccessDlg(context, "Error", "Error",successText: "Select Sales Organization from the list",closeScreen: true);
                  //   return;
                  // }
                  // if(selectedDistrChannel==null){
                  //   showSuccessDlg(context, "Error", "Error",successText: "Select Distribution Channel from the list",closeScreen: true);
                  //   return;
                  // }
                  // if(selectedVertical==null){
                  //   showSuccessDlg(context, "Error", "Error",successText: "Select Division from the list",closeScreen: true);
                  //   return;
                  // }
                  if (Constants.AUTH_ROLEID != Constants.DEALER) {
                    if (selectedDistributor == null) {
                      showSuccessDlg(context, "Error", "Error", successText: "Select Distributor from the list", closeScreen: true);
                      return;
                    }
                  }
                  if (selectedPlant == null) {
                    showSuccessDlg(context, "Error", "Error", successText: "Select Plant from the list");
                    return;
                  }
                  // if (selectedVehicleSize == null) {
                  //   showSuccessDlg(context, "Error", "Error",
                  //       successText: "Select Vehicle Size from the list");
                  //   return;
                  // }
                  // if (selectedContract == null) {
                  //   showSuccessDlg(context, "Error", "Error",
                  //       successText: "Select Contract from the list");
                  //   return;
                  // }
                  // if (selectedShipToParty == null) {
                  //   showSuccessDlg(context, "Error", "Error",
                  //       successText: "Select Ship to Party from the list");
                  //   return;
                  // }
                  if (salesOrders.isEmpty) {
                    showSuccessDlg(context, "Error", "Error", successText: "Add SKU from the list");
                    return;
                  }
                  // if (maximumVehicleCapacityInPercent < weightPercentage) {
                  //   showSuccessDlg(context, "Error", "Error",
                  //       successText: "Weight Exceeds the Vehicle Capacity");
                  //   return;
                  // }
                  // if (maximumVolumeCapacityInPercent < volumePercentage) {
                  //   showSuccessDlg(context, "Error", "Error",
                  //       successText: "Volume Exceeds the Capacity");
                  //   return;
                  // }
                  SalesOrder order = SalesOrder();
                  order.plantId = selectedPlant!.id!;
                  order.liftingDate = _deliveryrequestdatecontroller.text.toString() != ""
                      ? DateTimeUtils().dateToServerToDateFormat(_deliveryrequestdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)
                      : "";
                  order.dealerId = Constants.AUTH_ROLEID == Constants.DEALER ? Constants.AUTH_USERID : selectedDistributor!.id!;
                  order.statusId = 1;
                  order.loginUserId = Constants.AUTH_USERID;
                  order.bDOId = Constants.AUTH_ROLEID == Constants.DEALER ? 0 : Constants.AUTH_USERID;
                  order.customerRemarks = _remarkscontroller.text.toString();
                  order.shipToPartyId = selectedShipToParty != null ? selectedShipToParty!.id : 0;
                  order.vehicleSizeId = selectedVehicleSize != null ? selectedVehicleSize!.id : 0;
                  // order.saudaOrderId = selectedContract!.id;
                  // order.saudaNumber = selectedContract!.saudaNumber;
                  order.liftingRequestDetails = salesOrders;
                  GMLogger.v(jsonEncode(order));
                  BlocProvider.of<NewSalesOrderBloc>(context).add(SaveSalesOrder(request: order));
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

  void calculateVolumePercentage() {
    double quantity = 0;
    double volumnQty = 0;
    netWeight = 0;
    if (skuList != null && skuList.isNotEmpty) {
      maximumVehicleCapacityInPercent = skuList[0].maximumVehicleCapacityInPercent!;
      maximumVolumeCapacityInPercent = skuList[0].maximumVolumeCapacityInPercent!;
    }
    for (LiftingRequestDetails l in salesOrders) {
      quantity = quantity + l.liftingQuantity!;
      SKUList sku = skuList.where((element) => element.skuId == l.skuId).first;
      if (sku != null) {
        if (salesOrders.length == 1) {
          if (sku.maxAllowableCasesSingleSku != null && sku.maxAllowableCasesSingleSku != 0) {
            volumnQty = volumnQty + (l.liftingQuantity! / sku.maxAllowableCasesSingleSku!);
          }
        } else {
          if (sku.maxAllowableCasesMultipleSku != null && sku.maxAllowableCasesMultipleSku != 0) {
            volumnQty = volumnQty + (l.liftingQuantity! / sku.maxAllowableCasesMultipleSku!);
          }
        }
        netWeight = netWeight + (l.liftingQuantity! * sku.caseToMetricTonValue!);
      }
    }
    if (selectedVehicleSize != null) {
      weightPercentage = (quantity) / (double.parse(selectedVehicleSize!.name!)) * 100;
    } else {
      weightPercentage = 0.0;
    }
    volumePercentage = volumnQty * 100;
    volDispPerc = (volumePercentage / maximumVolumeCapacityInPercent);
    weightDispPerc = (weightPercentage / maximumVehicleCapacityInPercent);
    setState(() {});
  }

  _selectFromDate(BuildContext context, bool popup) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _deliveryrequestdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_deliveryrequestdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (selected != null) {
      _deliveryrequestdatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  void _showMultiSelectSku(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<SKUList>(
          searchable: true,
          singleSelection: true,
          items: skuList.map((dist) => MultiSelectItem<SKUList>(dist, dist.skuName!)).toList(),
          initialValue: selectedSKU != null ? [selectedSKU!] : [],
          onConfirm: (List<SKUList> values) {
            if (values != null && values.length > 0) {
              selectedSKU = values.first;
              _skucontroller.text = selectedSKU!.skuName!;
            }
            BlocProvider.of<NewSalesOrderBloc>(context).add(LoadContractDetail(
                distributorId: Constants.AUTH_ROLEID == Constants.DEALER ? Constants.AUTH_USERID : selectedDistributor!.id!,
                salesOrgId: selectedSalesOrg != null ? selectedSalesOrg!.id! : 0,
                skuId: selectedSKU != null ? selectedSKU!.skuId! : 0));
            setState(() {});
          },
        );
      },
    );
  }

  void setParentState() {
    setState(() {});
  }
}
