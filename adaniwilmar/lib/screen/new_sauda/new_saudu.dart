import 'dart:async';
import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/EssentialSkuMapping.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/new_sauda_request.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/bloc.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/new_sauda_event.dart';
import 'package:adaniwilmar/screen/sauda_booked_status/sauda_booked_status.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/qps_req_model.dart';
import '../../models/qps_res_model.dart';
import '../../models/sauda_booking_status.dart';
import '../../utils/utils.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class NewSauduScreen extends StatelessWidget {
  const NewSauduScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName),
        builder: (_) => const NewSauduScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      NewSaudaBloc()
      // ..add(LoadNewSaudaScreen(userId: Constants.AUTH_USERID))
      // ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
        ..add(LoadDefaults(id: Constants.AUTH_USERID)),
      // ..add(LoadOilType()),
      child: NewSauduForm(),
    );
  }
}

class NewSauduForm extends StatefulWidget {
  NewSauduForm({Key? key}) : super(key: key);
  int? selectedDiscountType = 1;
  int? selectedSaudaType = 1;

  @override
  State<NewSauduForm> createState() => _NewSauduFormState();
}

class _NewSauduFormState extends State<NewSauduForm> {
  List<DistributorList> distributorList = [];
  SaudaBookingStatus saudaBookingStatus = SaudaBookingStatus();

  List<SKUPricing> skuList = [];
  List<SKUPricing> popupSkuList = [];
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<IncoTermList> incoTerms = [];
  List<PlanDepotList> plants = [];
  List<DailyRate> dailyRates = [];
  List<OilType> oilTypes = [];
  List<Response> mandatorySkuMap = [];
  List<Sku> skuID = [];
  List<BrokerList> brokerList = [];
  bool isManuallyEdited = false;
  int? employeeSkuDiscountId = 0;
  int? employeeSkuPremiumId = 0;
  List<BdoList> bdoList = [];
  bool hasMandatorySkus = false;
  bool _forceShowMandatoryDialog = false;
  String? _lastShownEssentialSkuCodes;
  Timer? _debounce;
  DateTime? _selectedFromDate;
  DateTime? _selectedPFromDate;
  DateTime? _selectedToDate;
  DateTime? _selectedPToDate;
  Set<int>? _essentialSkuIds;
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
  BdoList? selectedBdo;

  ValueNotifier<List<SaudaOrders>> saudaOrders = ValueNotifier([]);

  DefaultInputResponse userDefaults = DefaultInputResponse(
      salesOrganizationId: 0,
      distrinbutionChannelId: 0,
      divisionId: 0,
      stateId: 0,
      plantId: 0);
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
  Color? labelTxtCol = Color(0xFFA1A1A1);
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0;
  double screenHeight = 0;
  String fromDate = DateTimeUtils().dateToStringFormat(
      DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = "";
  double rate = 0;
  double finalRate = 0;
  int? _lastLength;
  String discountLabel = "Discount Amount (Max :0.00)";
  String pDiscountLabel = "Discount Amount (Max :0.00)";

  static String _displayStringForOption(DistributorList option) =>
      option.employeeName!;

  static String _displayPlantForOption(PlanDepotList option) =>
      option.name!;

  static String _displayStringForSkuOption(SKUPricing option) =>
      option.skuName!;

  static String _displayStringForOilTypeOption(OilType option) => option.name!;

  final TextEditingController _pdiscountcontroller = TextEditingController();
  final TextEditingController _pquantitycontroller = TextEditingController();
  final TextEditingController _pfromdatecontroller = TextEditingController();
  final TextEditingController _ptodatecontroller = TextEditingController();
  TextEditingController? _skunamecontroller;
  TextEditingController? _distributorcontroller;
  TextEditingController? _plantcontroller;
  TextEditingController? _oiltypecontroller;

  TextEditingController? _popupskunamecontroller;
  TextEditingController? _popupoiltypecontroller;

  SKUPricing? pSelectedSKU;
  OilType? pSelectedOilType;
  int? pSelectedDiscountType = 1;
  late final GlobalKey<FormFieldState> _skuKey = GlobalKey();
  int selectedEditIndex = -1;
  ProgressBarHandler? _handler;
  GlobalKey _dialogKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  String oldSkuText = "";

  List<QPSResponseData> qpsResModel = <QPSResponseData>[];

  List<QPSResponseData> qpsDiscountResModel = <QPSResponseData>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height - MediaQuery
        .of(context)
        .padding
        .top - Constant.appBarHeight;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<NewSaudaBloc, NewSaudaState>(
        listener: (context, state) async {
          if (state is OnLoadDefaults) {
            userDefaults = state.defaults;
            BlocProvider.of<NewSaudaBloc>(context).add(
                LoadSalesOrganization(id: 0, saudaBookingTypeId: 0));
            if (Constants.AUTH_ROLEID == Constants.DEALER) {
              BlocProvider.of<NewSaudaBloc>(context).add(LoadDealerSaudaDetail(
                  id: Constants.AUTH_USERID,
                  saudaBookingTypeId: 1,
                  salesOrganizationId: 0,
                  distributionChannelId: 0,
                  divisionId: 0));
            } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
              BlocProvider.of<NewSaudaBloc>(context).add(
                  LoadBDO(userId: Constants.AUTH_USERID));
            }
          }

          if (state is OnGetSaudaBooking) {
            saudaBookingStatus = state.saudaBookingStatus;
            if (!(state.saudaBookingStatus.isActive ?? false)) {
              Utils().showSuccessDlg(context, "Error", "Warning",
                  successText: state.saudaBookingStatus.message);
            }
            setState(() {});
          }

          if (state is LoadRemoveQPS) {
            qpsResModel.clear();
          }

          if (state is LoadQPS) {
            qpsResModel.clear();
            qpsResModel.addAll(state.qpsResModel);
            if (state.isAlertTriggered) {
              // saudaOrders[selectedEditIndex].qpsResModel = state.qpsResModel;
              // calculateQPSDiscount(state.qpsReqModel[0].quantity ?? 0,
              //     isFromAlert: state.isAlertTriggered);
            } else {
              calculatePrice();
            }
            setState(() {});
          }

          if (state is LoadQPSDiscount) {
            qpsDiscountResModel = [];
            qpsDiscountResModel.addAll(state.qpsResModel);
            for (var d in state.qpsResModel) {
              for (int i = 0; i < saudaOrders.value.length; i++) {
                if (saudaOrders.value[i].skuId == d.skuId) {
                  saudaOrders.value[i].qpsDiscount = d.discount;
                }
              }
            }
            setState(() {});
          }

          if (state is OnLoadSuccess) {
            selectedDistributor = null;
            _distributorcontroller!.text = "";
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            if (userDefaults.salesOrganizationId! > 0) {
              if (salesOrgList
                  .where((element) =>
              element.id == userDefaults.salesOrganizationId!)
                  .isNotEmpty) {
                selectedSalesOrg = salesOrgList
                    .where((element) =>
                element.id == userDefaults.salesOrganizationId!)
                    .first;
              }
              if (selectedSalesOrg != null) {
                BlocProvider.of<NewSaudaBloc>(context).add(
                    LoadDistributionChannel(id: selectedSalesOrg!.id!));
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
          if (state is OnLoadDealerSaudaDetail) {
            if (state.loadLimit) {
              saudaDetail = state.dealerSaudaDetail;
              if (state.dealerSaudaDetail.saudaValidityPeriod != null) {
                toDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(
                    Duration(
                        days: state.dealerSaudaDetail.saudaValidityPeriod!)),
                    DateTimeUtils.DD_MM_YYYY_Format);
              }
              _fromdatecontroller.text = fromDate;
              _todatecontroller.text = toDate;
              _pfromdatecontroller.text = fromDate;
              _ptodatecontroller.text = toDate;
            } else {
              selectedSKU = null;
              _skunamecontroller!.text = "";
              pSelectedSKU = null;
              saudaDetail = state.dealerSaudaDetail;
              selectedIncoTerms = null;
              incoTerms = state.dealerSaudaDetail.incoTermList!;
              if (incoTerms.isNotEmpty) {
                selectedIncoTerms = incoTerms[0];
              }
              selectedPlant = null;
              _plantcontroller!.text = "";
              plants = state.dealerSaudaDetail.plantDepotListNew!;
              if (userDefaults.plantId! > 0 && plants
                  .where((element) => element.id == userDefaults.plantId!)
                  .isNotEmpty) {
                selectedPlant = plants
                    .where((element) => element.id == userDefaults.plantId!)
                    .first;
                if (selectedPlant != null) {
                  if (Constants.AUTH_ROLEID == Constants.DEALER) {
                    BlocProvider.of<NewSaudaBloc>(context)
                        .add(LoadSKUDetails(userId: Constants.AUTH_USERID,
                        dealerId: Constants.AUTH_USERID,
                        plantId: selectedPlant!.id!,
                        saudaBookingTypeId: 1,
                        oilTypeId: 0));
                  }
                }
              } else if (plants.isNotEmpty) {
                if (state.dealerSaudaDetail.highestBookedPlantId != null &&
                    state.dealerSaudaDetail.highestBookedPlantId! > 0) {
                  if (plants
                      .where((element) =>
                  element.id == state.dealerSaudaDetail.highestBookedPlantId!)
                      .isNotEmpty) {
                    selectedPlant = plants
                        .where((element) =>
                    element.id == state.dealerSaudaDetail.highestBookedPlantId!)
                        .first;
                  }
                } else {
                  selectedPlant = plants[0];
                }
                if (Constants.AUTH_ROLEID == Constants.DEALER) {
                  BlocProvider.of<NewSaudaBloc>(context)
                      .add(LoadSKUDetails(userId: Constants.AUTH_USERID,
                      dealerId: Constants.AUTH_USERID,
                      plantId: selectedPlant!.id!,
                      saudaBookingTypeId: 1,
                      oilTypeId: 0));
                }
              }
              selectedBroker = null;
              brokerList.clear();
              BrokerList defaultBroker = BrokerList();
              defaultBroker.id = 0;
              defaultBroker.name = "Select Broker";
              brokerList.add(defaultBroker);
              brokerList.addAll(state.dealerSaudaDetail.brokerList!);
              if (brokerList.length == 2) {
                selectedBroker = brokerList.elementAt(1);
              }
              if (state.dealerSaudaDetail.saudaValidityPeriod != null) {
                toDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(
                    Duration(
                        days: state.dealerSaudaDetail.saudaValidityPeriod!)),
                    DateTimeUtils.DD_MM_YYYY_Format);
              }
              _fromdatecontroller.text = fromDate;
              _todatecontroller.text = toDate;
              _pfromdatecontroller.text = fromDate;
              _ptodatecontroller.text = toDate;
            }
            setState(() {});
          }
          if (state is OnLoadSKUDetails) {
            if (state.isPopup) {
              pSelectedSKU = null;
              popupSkuList = state.skuList;
            } else if (state.skuList.isNotEmpty) {
              selectedSKU = null;
              _skunamecontroller!.text = "";
              skuList = state.skuList;
              // if (Constants.AUTH_ROLEID == Constants.DEALER) {
              //   popupSkuList = state.skuList;
              // }
            } else {
              //Constants.AUTH_ROLEID!=Constants.DEALER ?
              showSuccessDlgOne(context, "Contact HO", "Contact HO",
                  successText: "Please contact HO. Prices are not uploaded for the Material under the selected depot/plant.");
              //  : const Text("");
            }
            setState(() {});
          }

          if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            if (userDefaults.distrinbutionChannelId! > 0) {
              if (distrChannels
                  .where((element) =>
              element.id == userDefaults.distrinbutionChannelId!)
                  .isNotEmpty) {
                selectedDistrChannel = distrChannels
                    .where((element) =>
                element.id == userDefaults.distrinbutionChannelId!)
                    .first;
              }
              if (selectedDistrChannel != null) {
                BlocProvider.of<NewSaudaBloc>(context).add(LoadVerticalList(
                    distributionId: selectedDistrChannel!.id!));
              }
            }
            userDefaults.distrinbutionChannelId = 0;
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
            _distributorcontroller!.text = "";
            _oiltypecontroller!.text = "";
            verticals = state.verticalList;
            if (userDefaults.divisionId! > 0) {
              if (verticals
                  .where((element) => element.id == userDefaults.divisionId!)
                  .isNotEmpty) {
                selectedVertical = verticals
                    .where((element) => element.id == userDefaults.divisionId!)
                    .first;
              }
              if (selectedVertical != null) {
                if (Constants.AUTH_ROLEID != Constants.ZHMANAGER) {
                  BlocProvider.of<NewSaudaBloc>(context).add(LoadNewSaudaScreen(
                      userId: Constants.AUTH_USERID,
                      salesOrganizationId: selectedSalesOrg!.id!,
                      distributionChannelId: selectedDistrChannel!.id!,
                      divisonId: selectedVertical!.id!));
                }
                BlocProvider.of<NewSaudaBloc>(context)
                    .add(LoadOilType(userId: Constants.AUTH_USERID,
                    salesOrganizationId: selectedSalesOrg!.id!,
                    distributionChannelId: selectedDistrChannel!.id!,
                    divisonId: selectedVertical!.id!));
              }
            }
            userDefaults.divisionId = 0;
            setState(() {});
          }
          if (state is OnLoadPlant) {
            GMLogger.v("OnLoadPlant calling");
          }
          if (state is OnLoadOilType) {
            pSelectedOilType = null;
            selectedOilType = null;
            _oiltypecontroller!.text = "";
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnMandatory) {
            mandatorySkuMap = state.mandatorySku;

            final mandatorySkuCodes = mandatorySkuMap
                .where((e) => e.mandatorySkuMappingList != null)
                .expand((e) => e.mandatorySkuMappingList!)
                .map((e) => e.mandatorySkuCode)
                .where((code) => code != null && code.isNotEmpty)
                .join(', ');

            final mandatorySkuCodesPercent = mandatorySkuMap
                .where((e) => e.mandatorySkuMappingList != null)
                .expand((e) => e.mandatorySkuMappingList!)
                .map((e) => e.mandatoryBookingQuantityPercentage)
                .join(', ');

            final essentialSkuCodes = mandatorySkuMap
                .where((e) => e.essentialSkuName != null)
                .expand((e) => e.essentialSkuName!)
                .where((code) => code.isNotEmpty)
                .join(', ');

            final allMandatorySkus = mandatorySkuMap
                .where((e) => e.mandatorySkuMappingList != null)
                .expand((e) => e.mandatorySkuMappingList!)
                .toList();

            mandatorySkuMap
                .where((e) => e.mandatorySkuMappingList != null)
                .expand((e) => e.mandatorySkuMappingList!)
                .forEach((sku) {
              employeeSkuPremiumId = sku.employeeSkuPremiumId?.toInt() ?? 0;
              employeeSkuDiscountId = sku.employeeSkuDiscountId?.toInt() ?? 0;
              final double price = sku.mandatorySkuPrice ?? 0;
              final num quantity = sku.mandatorySkuQuantity ?? 0;
              final num discount = sku.employeeSkuDiscount ?? 0;
              final int roundedQuantity = quantity.round();
              final double discountAmount = price - discount;
              final double finalRate = price * roundedQuantity;


              // Avoid adding duplicate SKU entries
              if (sku.mandatorySkuCode != null) {
                final existingOrderIndex = saudaOrders.value.indexWhere(
                      (o) => o.skuId == sku.mandatorySkuId,
                );

                if (existingOrderIndex != -1) {
                  final existingOrder = saudaOrders.value[existingOrderIndex];

                  GMLogger.v("Existing Order isManuallyEdited: ${existingOrder
                      .isManuallyEdited}");
                  GMLogger.v(
                      "rounded quantity: ${existingOrder.isManuallyEdited}");
                  GMLogger.v(": ${existingOrder.isManuallyEdited}");

                  existingOrder.bidQuantity = roundedQuantity;

                  // Update only if not manually edited
                  if (existingOrder.isManuallyEdited != true) {
                    existingOrder.quotedPrice =
                        double.parse(discountAmount.toStringAsFixed(2));
                    existingOrder.finalBaseRate =
                        double.parse(price.toStringAsFixed(2));
                    existingOrder.saudaValidFromDate =
                        DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format);
                    existingOrder.saudaValidToDate =
                        DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format);
                    existingOrder.discountTypeId = 1;
                    existingOrder.isMandatorySku = true;
                  }
                } else {
                  // New entry from API
                  SaudaOrders order = SaudaOrders()
                    ..skuName = sku.mandatorySkuName
                    ..bidQuantity = roundedQuantity
                    ..skuId = sku.mandatorySkuId
                    ..oilTypeId = sku.oilTypeId
                    ..saudaValidFromDate = DateTimeUtils()
                        .dateToServerToDateFormat(
                        _fromdatecontroller.text.toString(),
                        DateTimeUtils.DD_MM_YYYY_Format,
                        DateTimeUtils.YYYY_MM_DD_Format)
                    ..saudaValidToDate = DateTimeUtils()
                        .dateToServerToDateFormat(
                        _todatecontroller.text.toString(),
                        DateTimeUtils.DD_MM_YYYY_Format,
                        DateTimeUtils.YYYY_MM_DD_Format)
                    ..discountTypeId = 1
                    ..statusId = 1
                    ..incoTerms = selectedIncoTerms?.name.toString()
                    ..incotermsId = selectedIncoTerms?.id
                    ..plantId = selectedPlant?.id
                    ..plantDepot = selectedPlant?.name
                    ..pricingId = sku.pricingId
                    ..uomName = sku.uom
                    ..discountAmount = double.parse(
                        discountAmount.toStringAsFixed(2))
                    ..discountAmountPerCase = sku.employeeSkuDiscount
                    ..quotedPrice = double.parse(
                        discountAmount.toStringAsFixed(2))
                    ..finalBaseRate = double.parse(price.toStringAsFixed(2))
                    ..discountId = pSelectedDiscountType == 0
                        ? employeeSkuDiscountId
                        : employeeSkuPremiumId
                    ..isMandatorySku = true
                    ..isManuallyEdited = false;

                  saudaOrders.value.add(order);

                  checkAlertQPSQtyListDiscount();
                }
              }
            });

            hasMandatorySkus = mandatorySkuCodes.isNotEmpty;
            setState(() {}); // if this update triggers a rebuild

            GMLogger.v("Current essential SKU codes: $essentialSkuCodes");

            for (int i = 0; i < mandatorySkuMap.length; i++) {
              GMLogger.v(
                  'Code ${i + 1}: ${mandatorySkuMap[i].essentialSkuCode}');
            }


            if (hasMandatorySkus &&
                (_forceShowMandatoryDialog ||
                    essentialSkuCodes != _lastShownEssentialSkuCodes)) {
              _lastShownEssentialSkuCodes = essentialSkuCodes;
              _forceShowMandatoryDialog = false; // Store current

              await showSuccessDlgSam(
                context,
                "Mandatory Items",
                "Information",
                successText: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: Constant.fontSize14, color: Colors.black),
                    children: [
                      TextSpan(text: "To book SKU codes "),
                      TextSpan(
                        text: "$essentialSkuCodes ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: "you must also book the following materials: "),
                    ],
                  ),
                ),
                essentialSkus: mandatorySkuMap,
              );
            }
          }


          if (state is OnSaveSauda) {
            showSuccessDlg(context, "Request Confirmed", "Success",
                successText: "Sauda Request Confirmed", closeScreen: true);
          }
          if (state is OnFailure) {
            if (state.error != "QPS Discount not available.") {}
            showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
          if (state is OnRateChange) {
            if (state.change) {
              itemRatePopup = pSelectedSKU!.price!;
            } else {
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
        child: SafeArea(
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
                          setAlertDiscountAndPremium();
                          validateAndAddItemToSAUDAList();
                        },
                        icon: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    30))),
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
                  GestureDetector(
                      child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: SingleChildScrollView(
                            controller: _controller,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(height: Constant.containerTopWrapper),
                                CurveOuterBox(
                                    boxofWidget: SizedBox(
                                      // height: MediaQuery.of(context).size.height - 215,
                                      // height:double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            const SizedBox(height: 16),
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID !=
                                                    Constants.DEALER,
                                                child: StatefulBuilder(
                                                    builder: (
                                                        BuildContext context,
                                                        StateSetter setState) {
                                                      return SizedBox(
                                                          width: double
                                                              .infinity,
                                                          // height: 70,
                                                          child: CommonDropdownButtonFormField<
                                                              SalesOrganization>(
                                                            value: selectedSalesOrg,
                                                            label: "Sales Organization",
                                                            onChanged: (
                                                                SalesOrganization? newValue) {
                                                              setState(() {
                                                                selectedSalesOrg =
                                                                newValue!;
                                                              });
                                                              BlocProvider.of<
                                                                  NewSaudaBloc>(
                                                                  context).add(
                                                                  LoadDistributionChannel(
                                                                      id: selectedSalesOrg!
                                                                          .id!));
                                                            },
                                                            items: salesOrgList
                                                                .map<
                                                                DropdownMenuItem<
                                                                    SalesOrganization>>((
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  SalesOrganization>(
                                                                value: value,
                                                                child: Text(
                                                                    value
                                                                        .salesOrganizationName!),
                                                              );
                                                            }).toList(),
                                                          ));
                                                    })),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                                child: const SizedBox(
                                                    height: 16)),
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID !=
                                                    Constants.DEALER,
                                                child: StatefulBuilder(
                                                    builder: (
                                                        BuildContext context,
                                                        StateSetter setState) {
                                                      return SizedBox(
                                                          width: double
                                                              .infinity,
                                                          //height: 70,
                                                           child: CommonDropdownButtonFormField<
                                                              DistributionChannel>(
                                                            value: selectedDistrChannel,
                                                            label: "Distribution Channel",
                                                            onChanged: (
                                                                DistributionChannel? newValue) {
                                                              setState(() {
                                                                selectedDistrChannel =
                                                                newValue!;
                                                              });
                                                              BlocProvider.of<
                                                                  NewSaudaBloc>(
                                                                  context).add(
                                                                  LoadVerticalList(
                                                                      distributionId: selectedDistrChannel!
                                                                          .id!));
                                                            },
                                                            items: distrChannels
                                                                .map<
                                                                DropdownMenuItem<
                                                                    DistributionChannel>>((
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  DistributionChannel>(
                                                                value: value,
                                                                child: Text(
                                                                    value
                                                                        .distributionChannelName!),
                                                              );
                                                            }).toList(),
                                                          ));
                                                    })),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                                child: const SizedBox(
                                                    height: 16.0)),
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID !=
                                                    Constants.DEALER,
                                                child: StatefulBuilder(
                                                    builder: (
                                                        BuildContext context,
                                                        StateSetter setState) {
                                                      return SizedBox(
                                                          width: double
                                                              .infinity,
                                                          //height: 70,
                                                           child: CommonDropdownButtonFormField<
                                                              Vertical>(
                                                            value: selectedVertical,
                                                            label: "Division",
                                                            onChanged: (
                                                                Vertical? newValue) {
                                                              setState(() {
                                                                selectedVertical =
                                                                newValue!;
                                                              });
                                                              if (Constants
                                                                  .AUTH_ROLEID !=
                                                                  Constants
                                                                      .ZHMANAGER) {
                                                                BlocProvider.of<
                                                                    NewSaudaBloc>(
                                                                    context)
                                                                    .add(
                                                                    LoadNewSaudaScreen(
                                                                        userId: Constants
                                                                            .AUTH_USERID,
                                                                        salesOrganizationId: selectedSalesOrg!
                                                                            .id!,
                                                                        distributionChannelId: selectedDistrChannel!
                                                                            .id!,
                                                                        divisonId: selectedVertical!
                                                                            .id!));
                                                              }
                                                              BlocProvider.of<
                                                                  NewSaudaBloc>(
                                                                  context).add(
                                                                  LoadOilType(
                                                                      userId: Constants
                                                                          .AUTH_USERID,
                                                                      salesOrganizationId: selectedSalesOrg!
                                                                          .id!,
                                                                      distributionChannelId: selectedDistrChannel!
                                                                          .id!,
                                                                      divisonId: selectedVertical!
                                                                          .id!));
                                                            },
                                                            items: verticals
                                                                .map<
                                                                DropdownMenuItem<
                                                                    Vertical>>((
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  Vertical>(
                                                                value: value,
                                                                child: Text(
                                                                    value
                                                                        .name!),
                                                              );
                                                            }).toList(),
                                                          ));
                                                    })),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID ==
                                                Constants.ZHMANAGER,
                                                child: const SizedBox(
                                                    height: 16)),
                                            Visibility(
                                              visible: Constants.AUTH_ROLEID ==
                                                  Constants.ZHMANAGER,
                                              child: StatefulBuilder(builder: (
                                                  BuildContext context,
                                                  StateSetter setState) {
                                                return SizedBox(
                                                    width: double.infinity,
                                                    // height: 70,
                                                    child: CommonDropdownButtonFormField<
                                                        BdoList>(
                                                      isExpanded: true,
                                                      value: selectedBdo,
                                                      icon: const Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            size: 16,
                                                          )),
                                                      elevation: 16,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      label: "State Trader",
                                                      onChanged: (
                                                          BdoList? newValue) {
                                                        setState(() {
                                                          selectedBdo =
                                                          newValue!;
                                                        });
                                                        BlocProvider.of<
                                                            NewSaudaBloc>(
                                                            context).add(
                                                            LoadNewSaudaScreen(
                                                                userId: Constants
                                                                    .AUTH_USERID,
                                                                salesOrganizationId: selectedSalesOrg!
                                                                    .id!,
                                                                distributionChannelId: selectedDistrChannel!
                                                                    .id!,
                                                                divisonId: selectedVertical!
                                                                    .id!,
                                                                bdoId: selectedBdo!
                                                                    .id!));
                                                      },
                                                      items: bdoList.map<
                                                          DropdownMenuItem<
                                                              BdoList>>((
                                                          value) {
                                                        return DropdownMenuItem<
                                                            BdoList>(
                                                          value: value,
                                                          child: Text(
                                                              value.name!),
                                                        );
                                                      }).toList(),
                                                    ));
                                              }),
                                            ),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                                child: const SizedBox(
                                                    height: 16)),
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID !=
                                                    Constants.DEALER,
                                                child: Column(children: [
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
                                                  //               Icons.arrow_drop_down_sharp,
                                                  //               size: 24,
                                                  //             )),
                                                  //         elevation: 16,
                                                  //         style:  TextStyle(color: Colors.black,fontSize: Constant.fontSize15),
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
                                                  //             labelText: "Distributor Name",
                                                  //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                                  //             fillColor: fillColor),
                                                  //         onChanged: (DistributorList? newValue) {
                                                  //           setState(() {
                                                  //             selectedDistributor = newValue!;
                                                  //           });
                                                  //           BlocProvider.of<NewSaudaBloc>(context).add(
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
                                                  CustomAutocomplete<
                                                      DistributorList>(
                                                    fieldViewBuilder: (
                                                        BuildContext context,
                                                        TextEditingController fieldTextEditingController,
                                                        FocusNode fieldFocusNode,
                                                        VoidCallback onFieldSubmitted) {
                                                      _distributorcontroller =
                                                          fieldTextEditingController;
                                                      return TextField(
                                                        keyboardType: TextInputType
                                                            .multiline,
                                                        maxLines: 1,
                                                        decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12.0,
                                                                vertical: 10.0),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR)),
                                                                borderSide: BorderSide(
                                                                    color: borderColor!,
                                                                    width: 1.0)),
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR)),
                                                                borderSide: BorderSide(
                                                                    color: borderColor!,
                                                                    width: 1.0)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR)),
                                                                borderSide: BorderSide(
                                                                    color: borderColor!,
                                                                    width: 1.0)),
                                                            filled: true,
                                                            // hintStyle: TextStyle(color: Colors.grey[800]),
                                                            labelText: "Distributor Name",
                                                            labelStyle: TextStyle(
                                                                color: labelTxtCol,
                                                                fontSize: labelTxtSize),
                                                            fillColor: fillColor),
                                                        controller: fieldTextEditingController,
                                                        focusNode: fieldFocusNode,
                                                        // style: const TextStyle(fontWeight: FontWeight.normal),
                                                      );
                                                    },
                                                    displayStringForOption: _displayStringForOption,
                                                    optionsBuilder: (
                                                        TextEditingValue textEditingValue) {
                                                      if (textEditingValue
                                                          .text == '') {
                                                        return const Iterable<
                                                            DistributorList>.empty();
                                                      }
                                                      return distributorList
                                                          .where((
                                                          DistributorList option) {
                                                        return option
                                                            .employeeName
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(
                                                            textEditingValue
                                                                .text
                                                                .toLowerCase());
                                                      });
                                                    },
                                                    onSelected: (
                                                        DistributorList selection) {
                                                      FocusManager.instance
                                                          .primaryFocus
                                                          ?.unfocus();
                                                      setState(() {
                                                        selectedDistributor =
                                                            selection;
                                                      });
                                                      BlocProvider.of<
                                                          NewSaudaBloc>(context)
                                                          .add(
                                                          LoadDealerSaudaDetail(
                                                              id: selectedDistributor!
                                                                  .id ?? 0,
                                                              saudaBookingTypeId: selectedDistributor!
                                                                  .saudaBookingTypeId ??
                                                                  0,
                                                              salesOrganizationId: selectedSalesOrg!
                                                                  .id ?? 0,
                                                              distributionChannelId: selectedDistrChannel!
                                                                  .id ?? 0,
                                                              divisionId: selectedVertical!
                                                                  .id ?? 0));
                                                    },
                                                  ),
                                                  const SizedBox(height: 16),
                                                ])),
                                            StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return SizedBox(
                                                      width: double.infinity,
                                                      //height: 70,
                                                      child: CommonDropdownButtonFormField<
                                                          BrokerList>(
                                                        value: selectedBroker,
                                                        label: "Broker",
                                                        onChanged: (
                                                            BrokerList? newValue) {
                                                          setState(() {
                                                            selectedBroker =
                                                            newValue!;
                                                          });
                                                        },
                                                        items: brokerList.map<
                                                            DropdownMenuItem<
                                                                BrokerList>>((
                                                            value) {
                                                          return DropdownMenuItem<
                                                              BrokerList>(
                                                            value: value,
                                                            child: Text(
                                                                value.name!),
                                                          );
                                                        }).toList(),
                                                      ));
                                                }),
                                            const SizedBox(height: 16.0),
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID !=
                                                    Constants.DEALER,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    CurveBox(
                                                        boxSize: 2,
                                                        miniusValue: 27,
                                                        boxHeight: 76,
                                                        boxColor: Constant
                                                            .saudaLETBoxColor1,
                                                        headingTxt: Constant
                                                            .saudaLETBox1Txt1,
                                                        subHeading: saudaDetail
                                                            .availableSaudaLimit !=
                                                            null
                                                            ? saudaDetail
                                                            .availableSaudaLimit
                                                            .toString() + "\tMT"
                                                            : "0" + "\tMT",
                                                        headingFontSize: Constant
                                                            .fontSize13,
                                                        subHeadingFontSize: Constant
                                                            .fontSize16,
                                                        subhHadingFontWeight: FontWeight
                                                            .w600),
                                                    const SizedBox(width: 13),
                                                    CurveBox(
                                                        boxSize: 2,
                                                        miniusValue: 30,
                                                        boxHeight: 76,
                                                        boxColor: Constant
                                                            .saudaLETBoxColor2,
                                                        headingTxt: Constant
                                                            .saudaLETBox2Txt2,
                                                        subHeading: saudaDetail
                                                            .totalSaudaLimit !=
                                                            null
                                                            ? saudaDetail
                                                            .totalSaudaLimit
                                                            .toString() + "\tMT"
                                                            : "0" + "\tMT",
                                                        headingFontSize: Constant
                                                            .fontSize13,
                                                        subHeadingFontSize: Constant
                                                            .fontSize16,
                                                        subhHadingFontWeight: FontWeight
                                                            .w600)
                                                  ],
                                                )),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                                child: const SizedBox(
                                                    height: 16)),
                                            StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return SizedBox(
                                                      width: double.infinity,
                                                      //height: 70,
                                                      child: CommonDropdownButtonFormField<
                                                          IncoTermList>(
                                                        value: selectedIncoTerms,
                                                        label: "Incoterm",
                                                        onChanged: (
                                                            IncoTermList? newValue) {
                                                          setState(() {
                                                            selectedIncoTerms =
                                                            newValue!;
                                                          });
                                                        },
                                                        items: incoTerms.map<
                                                            DropdownMenuItem<
                                                                IncoTermList>>((
                                                            value) {
                                                          return DropdownMenuItem<
                                                              IncoTermList>(
                                                            value: value,
                                                            child: Text(
                                                                value.name!),
                                                          );
                                                        }).toList(),
                                                      ));
                                                }),
                                            const SizedBox(height: 16.0),
                                            Column(children: [
                                              CustomAutocomplete<
                                                  PlanDepotList>(
                                                fieldViewBuilder: (
                                                    BuildContext context,
                                                    TextEditingController fieldTextEditingController,
                                                    FocusNode fieldFocusNode,
                                                    VoidCallback onFieldSubmitted,) {
                                                  _plantcontroller =
                                                      fieldTextEditingController;

                                                  if (selectedPlant != null &&
                                                      _plantcontroller!.text !=
                                                          _displayPlantForOption(
                                                              selectedPlant!)) {
                                                    _plantcontroller!.text =
                                                        _displayPlantForOption(
                                                            selectedPlant!);
                                                  }

                                                  return TextField(
                                                    keyboardType: TextInputType
                                                        .multiline,
                                                    maxLines: 1,
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 10.0),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                          topLeft: Radius
                                                              .circular(
                                                              borderRadiusTLBR),
                                                          topRight: Radius
                                                              .circular(
                                                              borderRadiusTRBL),
                                                          bottomLeft: Radius
                                                              .circular(
                                                              borderRadiusTRBL),
                                                          bottomRight: Radius
                                                              .circular(
                                                              borderRadiusTLBR),
                                                        ),
                                                        borderSide: BorderSide(
                                                            color: borderColor!,
                                                            width: 1.0),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                          topLeft: Radius
                                                              .circular(
                                                              borderRadiusTLBR),
                                                          topRight: Radius
                                                              .circular(
                                                              borderRadiusTRBL),
                                                          bottomLeft: Radius
                                                              .circular(
                                                              borderRadiusTRBL),
                                                          bottomRight: Radius
                                                              .circular(
                                                              borderRadiusTLBR),
                                                        ),
                                                        borderSide: BorderSide(
                                                            color: borderColor!,
                                                            width: 1.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                          topLeft: Radius
                                                              .circular(
                                                              borderRadiusTLBR),
                                                          topRight: Radius
                                                              .circular(
                                                              borderRadiusTRBL),
                                                          bottomLeft: Radius
                                                              .circular(
                                                              borderRadiusTRBL),
                                                          bottomRight: Radius
                                                              .circular(
                                                              borderRadiusTLBR),
                                                        ),
                                                        borderSide: BorderSide(
                                                            color: borderColor!,
                                                            width: 1.0),
                                                      ),
                                                      filled: true,
                                                      labelText: "Plant",
                                                      labelStyle: TextStyle(
                                                          color: labelTxtCol,
                                                          fontSize: labelTxtSize),
                                                      fillColor: fillColor,
                                                    ),
                                                    controller: fieldTextEditingController,
                                                    focusNode: fieldFocusNode,
                                                  );
                                                },

                                                displayStringForOption: _displayPlantForOption,
                                                optionsBuilder: (
                                                    TextEditingValue textEditingValue) {
                                                  if (textEditingValue
                                                      .text == '') {
                                                    return const Iterable<
                                                        PlanDepotList>.empty();
                                                  }
                                                  return plants
                                                      .where((
                                                      PlanDepotList option) {
                                                    return option
                                                        .name
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(
                                                        textEditingValue
                                                            .text
                                                            .toLowerCase());
                                                  });
                                                },
                                                onSelected: (
                                                    PlanDepotList selection) {
                                                  FocusManager.instance
                                                      .primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    selectedPlant =
                                                        selection;
                                                  });

                                                  _oiltypecontroller
                                                      ?.text = "";
                                                  selectedOilType =
                                                  null;
                                                  _skunamecontroller
                                                      ?.text = "";
                                                  selectedSKU = null;
                                                  itemRate = 0;
                                                  rate = 0;
                                                  itemMaxDiscount = 0;
                                                  _quantitycontroller
                                                      .text = "0";
                                                  finalRate = 0;
                                                  saudaOrders.value.clear();

                                                  BlocProvider.of<
                                                      NewSaudaBloc>(
                                                      context)
                                                      .add(
                                                      LoadSKUDetails(
                                                          userId: Constants
                                                              .AUTH_USERID,
                                                          dealerId: Constants
                                                              .AUTH_USERID,
                                                          plantId: selectedPlant!
                                                              .id!,
                                                          saudaBookingTypeId: 1,
                                                          oilTypeId: 0));
                                                },
                                              ),
                                              Visibility(visible: Constants
                                                  .AUTH_ROLEID !=
                                                  Constants.DEALER,
                                                  child: const SizedBox(
                                                      height: 16.0)),
                                            ]),
                                            /*StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return SizedBox(
                                                      width: double.infinity,
                                                      //height: 70,
                                                      child: CommonDropdownButtonFormField<
                                                          PlanDepotList>(
                                                        isExpanded: true,
                                                        value: selectedPlant,
                                                        icon: const Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_drop_down_sharp,
                                                              size: 24,
                                                            )),
                                                        elevation: 16,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: Constant
                                                                .fontSize15),
                                                        decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10.0,
                                                                vertical: 0.0),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR)),
                                                                borderSide: BorderSide(
                                                                    color: borderColor!,
                                                                    width: 1.0)),
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR)),
                                                                borderSide: BorderSide(
                                                                    color: borderColor!,
                                                                    width: 1.0)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                        borderRadiusTRBL),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                        borderRadiusTLBR)),
                                                                borderSide: BorderSide(
                                                                    color: borderColor!,
                                                                    width: 1.0)),
                                                            filled: true,
                                                            // hintStyle: TextStyle(color: Colors.grey[800]),
                                                            labelText: "Plant",
                                                            labelStyle: TextStyle(
                                                                color: labelTxtCol,
                                                                fontSize: labelTxtSize),
                                                            fillColor: fillColor),
                                                        onChanged: (
                                                            PlanDepotList? newValue) {
                                                          setState(() {
                                                            selectedPlant =
                                                            newValue!;
                                                          });

                                                          _oiltypecontroller
                                                              ?.text = "";
                                                          selectedOilType =
                                                          null;
                                                          _skunamecontroller
                                                              ?.text = "";
                                                          selectedSKU = null;
                                                          itemRate = 0;
                                                          rate = 0;
                                                          itemMaxDiscount = 0;
                                                          _quantitycontroller
                                                              .text = "0";
                                                          finalRate = 0;
                                                          saudaOrders.value.clear();

                                                          if (Constants
                                                              .AUTH_ROLEID ==
                                                              Constants
                                                                  .DEALER) {
                                                            BlocProvider.of<
                                                                NewSaudaBloc>(
                                                                context)
                                                                .add(
                                                                LoadSKUDetails(
                                                                    userId: Constants
                                                                        .AUTH_USERID,
                                                                    dealerId: Constants
                                                                        .AUTH_USERID,
                                                                    plantId: selectedPlant!
                                                                        .id!,
                                                                    saudaBookingTypeId: 1,
                                                                    oilTypeId: 0));
                                                          }
                                                        },
                                                        items: plants.map<
                                                            DropdownMenuItem<
                                                                PlanDepotList>>((
                                                            value) {
                                                          return DropdownMenuItem<
                                                              PlanDepotList>(
                                                            value: value,
                                                            child: Text(
                                                                value.name!),
                                                          );
                                                        }).toList(),
                                                      ));
                                                }),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                                child: const SizedBox(
                                                    height: 16.0)),*/
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID !=
                                                    Constants.DEALER,
                                                child:
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
                                                //               Icons.arrow_drop_down_sharp,
                                                //               size: 24,
                                                //             )),
                                                //         elevation: 16,
                                                //         style:  TextStyle(color: Colors.black,fontSize: Constant.fontSize15),
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
                                                //           BlocProvider.of<NewSaudaBloc>(context).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
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
                                                // })
                                                CustomAutocomplete<OilType>(
                                                  fieldViewBuilder: (
                                                      BuildContext context,
                                                      TextEditingController fieldTextEditingController,
                                                      FocusNode fieldFocusNode,
                                                      VoidCallback onFieldSubmitted) {
                                                    _oiltypecontroller =
                                                        fieldTextEditingController;
                                                    return TextField(
                                                      keyboardType: TextInputType
                                                          .multiline,
                                                      maxLines: 1,
                                                      decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 12.0,
                                                              vertical: 0.0),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                      borderRadiusTLBR),
                                                                  topRight: Radius
                                                                      .circular(
                                                                      borderRadiusTRBL),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                      borderRadiusTRBL),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                      borderRadiusTLBR)),
                                                              borderSide: BorderSide(
                                                                  color: borderColor!,
                                                                  width: 1.0)),
                                                          border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                      borderRadiusTLBR),
                                                                  topRight: Radius
                                                                      .circular(
                                                                      borderRadiusTRBL),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                      borderRadiusTRBL),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                      borderRadiusTLBR)),
                                                              borderSide: BorderSide(
                                                                  color: borderColor!,
                                                                  width: 1.0)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                      borderRadiusTLBR),
                                                                  topRight: Radius
                                                                      .circular(
                                                                      borderRadiusTRBL),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                      borderRadiusTRBL),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                      borderRadiusTLBR)),
                                                              borderSide: BorderSide(
                                                                  color: borderColor!,
                                                                  width: 1.0)),
                                                          filled: true,
                                                          // hintStyle: TextStyle(color: Colors.grey[800]),
                                                          labelText: "Oil Type",
                                                          labelStyle: TextStyle(
                                                              color: labelTxtCol,
                                                              fontSize: labelTxtSize),
                                                          fillColor: fillColor),
                                                      controller: fieldTextEditingController,
                                                      focusNode: fieldFocusNode,
                                                      // style: const TextStyle(fontWeight: FontWeight.normal),
                                                    );
                                                  },
                                                  displayStringForOption: _displayStringForOilTypeOption,
                                                  optionsBuilder: (
                                                      TextEditingValue textEditingValue) {
                                                    if (textEditingValue.text ==
                                                        '') {
                                                      return const Iterable<
                                                          OilType>.empty();
                                                    }
                                                    return oilTypes.where((
                                                        OilType option) {
                                                      return option.name
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                          textEditingValue.text
                                                              .toLowerCase());
                                                    });
                                                  },
                                                  onSelected: (
                                                      OilType selection) {
                                                    FocusManager.instance
                                                        .primaryFocus
                                                        ?.unfocus();
                                                    setState(() {
                                                      selectedOilType =
                                                          selection;
                                                    });
                                                    BlocProvider.of<
                                                        NewSaudaBloc>(context)
                                                        .add(LoadSKUDetails(
                                                        userId: Constants
                                                            .AUTH_USERID,
                                                        dealerId: selectedDistributor!
                                                            .id!,
                                                        plantId: selectedPlant!
                                                            .id!,
                                                        saudaBookingTypeId: selectedDistributor!
                                                            .saudaBookingTypeId!,
                                                        oilTypeId: selectedOilType!
                                                            .id!));
                                                  },
                                                )),
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
                                            //               Icons.arrow_drop_down_sharp,
                                            //               size: 24,
                                            //             )),
                                            //         elevation: 16,
                                            //         style:  TextStyle(color: Colors.black,fontSize: Constant.fontSize15),
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
                                            //           BlocProvider.of<NewSaudaBloc>(context).add(const ChangeRate(popup: false));
                                            //           if(Constants.DEALER==Constants.AUTH_ROLEID) {
                                            //             BlocProvider.of<NewSaudaBloc>(context).add(
                                            //                 LoadSKUDetails(
                                            //                     userId: Constants.AUTH_USERID,
                                            //                     dealerId: Constants.AUTH_USERID,
                                            //                     plantId: selectedPlant!.id!,
                                            //                     saudaBookingTypeId: 1,
                                            //                     oilTypeId: 0,
                                            //                     popup: true,
                                            //                     skuId: selectedSKU!.skuId!
                                            //                 ));
                                            //           }
                                            //           if(Constants.AUTH_ROLEID==Constants.DEALER) {
                                            //             BlocProvider.of<NewSaudaBloc>(context).add(
                                            //                 LoadDealerSaudaDetail(
                                            //                     id: Constants.AUTH_USERID,
                                            //                     saudaBookingTypeId: 1,
                                            //                     salesOrganizationId: selectedSKU!.salesOrganizationId!=null?selectedSKU!.salesOrganizationId!:0,
                                            //                     distributionChannelId: selectedSKU!.distributionChannelId!=null?selectedSKU!.distributionChannelId!:0,
                                            //                     divisionId: selectedSKU!.divisionId!=null?selectedSKU!.divisionId!:0,loadLimit: true));
                                            //           }
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
                                                  VoidCallback onFieldSubmitted) {
                                                _skunamecontroller =
                                                    fieldTextEditingController;
                                                return TextField(
                                                  keyboardType: TextInputType
                                                      .multiline,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 0.0),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  borderRadiusTLBR),
                                                              topRight: Radius
                                                                  .circular(
                                                                  borderRadiusTRBL),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  borderRadiusTRBL),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                  borderRadiusTLBR)),
                                                          borderSide: BorderSide(
                                                              color: borderColor!,
                                                              width: 1.0)),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  borderRadiusTLBR),
                                                              topRight: Radius
                                                                  .circular(
                                                                  borderRadiusTRBL),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  borderRadiusTRBL),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                  borderRadiusTLBR)),
                                                          borderSide: BorderSide(
                                                              color: borderColor!,
                                                              width: 1.0)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  borderRadiusTLBR),
                                                              topRight: Radius
                                                                  .circular(
                                                                  borderRadiusTRBL),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  borderRadiusTRBL),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                  borderRadiusTLBR)),
                                                          borderSide: BorderSide(
                                                              color: borderColor!,
                                                              width: 1.0)),
                                                      filled: true,
                                                      // hintStyle: TextStyle(color: Colors.grey[800]),
                                                      labelText: "SKU Name",
                                                      labelStyle: TextStyle(
                                                          color: labelTxtCol,
                                                          fontSize: labelTxtSize),
                                                      fillColor: fillColor),
                                                  controller: fieldTextEditingController,
                                                  focusNode: fieldFocusNode,
                                                  // style: const TextStyle(fontWeight: FontWeight.normal),
                                                );
                                              },
                                              displayStringForOption: _displayStringForSkuOption,
                                              optionsBuilder: (
                                                  TextEditingValue textEditingValue) {
                                                if (textEditingValue.text
                                                    .isEmpty) {
                                                  return const Iterable<
                                                      SKUPricing>.empty();
                                                } else {
                                                  ///Alert show for empty data.
                                                  checkForEmptyData(
                                                      textEditingValue.text);

                                                  return skuList.where((
                                                      SKUPricing option) {
                                                    return option.skuName
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(
                                                        textEditingValue.text
                                                            .toLowerCase());
                                                  });
                                                }
                                              },
                                              onSelected: (
                                                  SKUPricing selection) {
                                                FocusManager.instance
                                                    .primaryFocus?.unfocus();
                                                selectedSKU = selection;
                                                widget.selectedDiscountType = 1;
                                                widget.selectedSaudaType = 1;
                                                setDiscountAndPremium();

                                                BlocProvider.of<NewSaudaBloc>(
                                                    context).add(
                                                    const ChangeRate(
                                                        popup: false));
                                                if (Constants.DEALER ==
                                                    Constants.AUTH_ROLEID) {
                                                  BlocProvider.of<NewSaudaBloc>(
                                                      context).add(
                                                      LoadSKUDetails(
                                                          userId: Constants
                                                              .AUTH_USERID,
                                                          dealerId: Constants
                                                              .AUTH_USERID,
                                                          plantId: selectedPlant!
                                                              .id!,
                                                          saudaBookingTypeId: 1,
                                                          oilTypeId: 0,
                                                          popup: true,
                                                          skuId: selectedSKU!
                                                              .skuId!));
                                                  // }
                                                  // if (Constants.AUTH_ROLEID ==
                                                  //     Constants.DEALER) {
                                                  BlocProvider.of<NewSaudaBloc>(
                                                      context).add(
                                                      LoadDealerSaudaDetail(
                                                          id: Constants
                                                              .AUTH_USERID,
                                                          saudaBookingTypeId: 1,
                                                          salesOrganizationId: selectedSKU!
                                                              .salesOrganizationId !=
                                                              null
                                                              ? selectedSKU!
                                                              .salesOrganizationId!
                                                              : 0,
                                                          distributionChannelId: selectedSKU!
                                                              .distributionChannelId !=
                                                              null
                                                              ? selectedSKU!
                                                              .distributionChannelId!
                                                              : 0,
                                                          divisionId: selectedSKU!
                                                              .divisionId !=
                                                              null
                                                              ? selectedSKU!
                                                              .divisionId!
                                                              : 0,
                                                          loadLimit: true));
                                                }

                                                if (Constants.AUTH_ROLEID ==
                                                    Constants.ZHMANAGER ||
                                                    Constants.AUTH_ROLEID ==
                                                        Constants.SALE ||
                                                    Constants.DEALER ==
                                                        Constants.AUTH_ROLEID) {
                                                  BlocProvider.of<NewSaudaBloc>(
                                                      context).add(
                                                      OnLoadSaudaRestriction(
                                                          userId: Constants
                                                              .AUTH_USERID,
                                                          salesOrganizationId: selection
                                                              .salesOrganizationId ??
                                                              0,
                                                          distributionChannelId: selection
                                                              .distributionChannelId ??
                                                              0,
                                                          divisonId: selection
                                                              .divisionId ?? 0,
                                                          dealerId: (selectedDistributor ??
                                                              DistributorList())
                                                              .id ?? 0,
                                                          stateTraderId: (selectedBdo ??
                                                              BdoList()).id ??
                                                              0,
                                                          skuId: selection
                                                              .skuId ?? 0));
                                                }

                                                itemRate =
                                                    selection.price ?? 0.0;
                                                _quantitycontroller.text = "";
                                                qpsResModel.clear();
                                                checkAlertQPSQty(
                                                    selection.skuId);
                                                setState(() {});
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            Visibility(
                                                visible: Constants
                                                    .AUTH_ROLEID ==
                                                    Constants.DEALER,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    CurveBox(
                                                        boxSize: 2,
                                                        miniusValue: 27,
                                                        boxHeight: 76,
                                                        boxColor: Constant
                                                            .saudaLETBoxColor1,
                                                        headingTxt: Constant
                                                            .saudaLETBox1Txt1,
                                                        subHeading: saudaDetail
                                                            .availableSaudaLimit !=
                                                            null
                                                            ? saudaDetail
                                                            .availableSaudaLimit
                                                            .toString() + "\tMT"
                                                            : "0" + "\tMT",
                                                        headingFontSize: Constant
                                                            .fontSize13,
                                                        subHeadingFontSize: Constant
                                                            .fontSize16,
                                                        subhHadingFontWeight: FontWeight
                                                            .w600),
                                                    const SizedBox(width: 13),
                                                    CurveBox(
                                                        boxSize: 2,
                                                        miniusValue: 30,
                                                        boxHeight: 76,
                                                        boxColor: Constant
                                                            .saudaLETBoxColor2,
                                                        headingTxt: Constant
                                                            .saudaLETBox2Txt2,
                                                        subHeading: saudaDetail
                                                            .totalSaudaLimit !=
                                                            null
                                                            ? saudaDetail
                                                            .totalSaudaLimit
                                                            .toString() + "\tMT"
                                                            : "0" + "\tMT",
                                                        headingFontSize: Constant
                                                            .fontSize13,
                                                        subHeadingFontSize: Constant
                                                            .fontSize16,
                                                        subhHadingFontWeight: FontWeight
                                                            .w600)
                                                  ],
                                                )),
                                            Visibility(visible: Constants
                                                .AUTH_ROLEID ==
                                                Constants.DEALER,
                                                child: const SizedBox(
                                                    height: 16)),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        CommonText(
                                                          name: "Basic Rate",
                                                          fontColor: Constant
                                                              .colorDullGray77,
                                                          fontSize: Constant
                                                              .fontSize10,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Row(
                                                          children: [
                                                            CommonText(
                                                              name: "Rs." +
                                                                  (itemRate
                                                                      .toStringAsFixed(
                                                                      2)),
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontSize: Constant
                                                                  .fontSize15,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                            CommonText(
                                                              name: "",
                                                              fontColor: Constant
                                                                  .colorDullGray77,
                                                              fontSize: Constant
                                                                  .fontSize10,
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
                                              style: TextStyle(fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return Container(
                                                      margin: const EdgeInsets
                                                          .only(right: 100),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                                child: Theme(
                                                                    data: Theme
                                                                        .of(
                                                                        context)
                                                                        .copyWith(
                                                                        unselectedWidgetColor: Colors
                                                                            .green[900],
                                                                        disabledColor: Colors
                                                                            .green[900],
                                                                        /*toggleableActiveColor: Colors
                                                                            .green[900]*/
                                                                    ),
                                                                    child: RadioListTile<
                                                                        int>(
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      title: const Text(
                                                                          'Discount',
                                                                          style: TextStyle(
                                                                              fontSize: 12)),
                                                                      value: 1,
                                                                      groupValue: widget
                                                                          .selectedDiscountType,
                                                                      onChanged: (
                                                                          int? value) {
                                                                        setState(() {
                                                                          widget
                                                                              .selectedDiscountType =
                                                                          value!;

                                                                          setDiscountAndPremium();

                                                                          /* if(selectedSKU!=null) {
                                                          if (widget.selectedDiscountType ==
                                                              1) {
                                                            _discountcontroller.text =
                                                                selectedSKU!
                                                                    .employeeSkuDiscount!
                                                                    .toStringAsFixed(2);
                                                            itemMaxDiscount=selectedSKU!.employeeSkuDiscount!;
                                                          } else {
                                                            _discountcontroller.text =
                                                                selectedSKU!.employeeSkuPremium!
                                                                    .toStringAsFixed(2);
                                                          }
                                                          setDiscountLabel();
                                                        }*/
                                                                        });
                                                                      },
                                                                    ))),
                                                            Expanded(
                                                                child: Theme(
                                                                    data: Theme
                                                                        .of(
                                                                        context)
                                                                        .copyWith(
                                                                        unselectedWidgetColor: Colors
                                                                            .green[900],
                                                                        disabledColor: Colors
                                                                            .green[900],
                                                                        /*toggleableActiveColor: Colors
                                                                            .green[900]*/
                                                                    ),
                                                                    child: RadioListTile<
                                                                        int>(
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      title: const Text(
                                                                        'Premium',
                                                                        style: TextStyle(
                                                                            fontSize: 12),
                                                                      ),
                                                                      value: 2,
                                                                      groupValue: widget
                                                                          .selectedDiscountType,
                                                                      onChanged: (
                                                                          int? value) {
                                                                        setState(() {
                                                                          widget
                                                                              .selectedDiscountType =
                                                                          value!;
                                                                          setDiscountAndPremium();
                                                                          /*if(selectedSKU!=null) {
                                                          if (widget.selectedDiscountType ==
                                                              1) {
                                                            _discountcontroller.text =
                                                                selectedSKU!
                                                                    .employeeSkuDiscount!
                                                                    .toStringAsFixed(2);
                                                            itemMaxDiscount=selectedSKU!.employeeSkuDiscount!;
                                                          } else {
                                                            _discountcontroller.text =
                                                                selectedSKU!.employeeSkuPremium!
                                                                    .toStringAsFixed(2);
                                                            itemMaxDiscount=0;
                                                          }
                                                          setDiscountLabel();
                                                        }*/
                                                                        });
                                                                      },
                                                                    ))),
                                                          ]));
                                                }),
                                            const SizedBox(height: 16.0),

                                            const Text(
                                              "Sauda Type",
                                              style: TextStyle(fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return Container(
                                                      margin: const EdgeInsets
                                                          .only(right: 100),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                                child: Theme(
                                                                    data: Theme
                                                                        .of(
                                                                        context)
                                                                        .copyWith(
                                                                        unselectedWidgetColor: Colors
                                                                            .green[900],
                                                                        disabledColor: Colors
                                                                            .green[900],
                                                                        /*toggleableActiveColor: Colors
                                                                            .green[900]*/
                                                                    ),
                                                                    child: RadioListTile<
                                                                        int>(
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      title: const Text(
                                                                          'Punch',
                                                                          style: TextStyle(
                                                                              fontSize: 12)),
                                                                      value: 1,
                                                                      groupValue: widget
                                                                          .selectedSaudaType,
                                                                      onChanged: (
                                                                          int? value) {
                                                                        setState(() {
                                                                          widget
                                                                              .selectedSaudaType =
                                                                          value!;
                                                                          /*if(selectedSKU!=null) {
                                                          if (widget.selectedSaudaType ==
                                                              1) {
                                                            _discountcontroller.text =
                                                                selectedSKU!
                                                                    .employeeSkuDiscount!
                                                                    .toStringAsFixed(2);
                                                            itemMaxDiscount=selectedSKU!.employeeSkuDiscount!;
                                                          } else {
                                                            _discountcontroller.text =
                                                                selectedSKU!.employeeSkuPremium!
                                                                    .toStringAsFixed(2);
                                                          }
                                                          setDiscountLabel();
                                                        }*/
                                                                        });
                                                                      },
                                                                    ))),
                                                            Expanded(
                                                                child: Theme(
                                                                    data: Theme
                                                                        .of(
                                                                        context)
                                                                        .copyWith(
                                                                        unselectedWidgetColor: Colors
                                                                            .green[900],
                                                                        disabledColor: Colors
                                                                            .green[900],
                                                                        /*toggleableActiveColor: Colors
                                                                            .green[900]*/
                                                                    ),
                                                                    child: RadioListTile<
                                                                        int>(
                                                                      contentPadding: EdgeInsets
                                                                          .zero,
                                                                      title: const Text(
                                                                        'RePunch',
                                                                        style: TextStyle(
                                                                            fontSize: 12),
                                                                      ),
                                                                      value: 2,
                                                                      groupValue: widget
                                                                          .selectedSaudaType,
                                                                      onChanged: (
                                                                          int? value) {
                                                                        setState(() {
                                                                          widget
                                                                              .selectedSaudaType =
                                                                          value!;
                                                                          /*if(selectedSKU!=null) {
                                                          if (widget.selectedDiscountType ==
                                                              1) {
                                                            _discountcontroller.text =
                                                                selectedSKU!
                                                                    .employeeSkuDiscount!
                                                                    .toStringAsFixed(2);
                                                            itemMaxDiscount=selectedSKU!.employeeSkuDiscount!;
                                                          } else {
                                                            _discountcontroller.text =
                                                                selectedSKU!.employeeSkuPremium!
                                                                    .toStringAsFixed(2);
                                                            itemMaxDiscount=0;
                                                          }
                                                          setDiscountLabel();
                                                        }*/
                                                                        });
                                                                      },
                                                                    ))),
                                                          ]));
                                                }),
                                            const SizedBox(height: 16.0),

                                            // CommonTextFormField(
                                            //     labeltxt: "Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")",
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
                                            //     onChanged: (String? value) {
                                            //       if (selectedSKU!=null && _discountcontroller.text.toString()!="") {
                                            //         if (widget.selectedDiscountType == 1) {
                                            //           if(selectedSKU!=null && double.parse(
                                            //               _discountcontroller.text.toString())>selectedSKU!.employeeSkuDiscount!){
                                            //             // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+selectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                            //             _discountcontroller.text=selectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                                            //           }
                                            //         } else {
                                            //           // if(selectedSKU!=null && double.parse(
                                            //           //     _discountcontroller.text.toString())>selectedSKU!.employeeSkuPremium!){
                                            //           //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+selectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                                            //           //   _discountcontroller.text=selectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                                            //           // }
                                            //         }
                                            //       }
                                            //       calculatePrice();
                                            //       setState(() {});
                                            //     }),
                                            TextFormField(
                                              keyboardType: TextInputType
                                                  .number,
                                              controller: _discountcontroller,
                                              inputFormatters: [
                                                new FilteringTextInputFormatter
                                                    .deny(RegExp("[\\-]"))
                                              ],
                                              maxLines: 1,
                                              enabled: true,
                                              onChanged: (String? value) {
                                                if (selectedSKU != null &&
                                                    _discountcontroller.text
                                                        .toString() != "") {
                                                  if (widget
                                                      .selectedDiscountType ==
                                                      1) {
                                                    if (selectedSKU != null &&
                                                        double.parse(
                                                            _discountcontroller
                                                                .text
                                                                .toString()) >
                                                            selectedSKU!
                                                                .employeeSkuDiscount!) {
                                                      // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+selectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                                      _discountcontroller.text =
                                                          selectedSKU!
                                                              .employeeSkuDiscount!
                                                              .toStringAsFixed(
                                                              2);
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
                                                      color: Constant
                                                          .textFormFieldColor!,
                                                      fontSize: Constant
                                                          .textFormFieldSize,
                                                      fontWeight: Constant
                                                          .textFormFieldSizeFontW),
                                                  fillColor: Colors.white,
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constant
                                                              .textFormFocuBorCol!,
                                                          width: Constant
                                                              .textFormFocuBorWid!),
                                                      borderRadius: BorderRadius
                                                          .only(
                                                        topLeft: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusTL!),
                                                        topRight: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusBR!),
                                                        bottomLeft: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusBR!),
                                                        bottomRight: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusTL!),
                                                      )),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Constant
                                                              .textFormEnaBorCol!,
                                                          width: Constant
                                                              .textFormEnaBorWid!),
                                                      borderRadius: BorderRadius
                                                          .only(
                                                        topLeft: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusTL!),
                                                        topRight: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusBR!),
                                                        bottomLeft: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusBR!),
                                                        bottomRight: Radius
                                                            .circular(Constant
                                                            .textFormborderRadiusTL!),
                                                      )),
                                                  contentPadding: EdgeInsets
                                                      .symmetric(
                                                      horizontal: Constant
                                                          .textFormcontentPadHor!,
                                                      vertical: Constant
                                                          .textFormcontentPadHVer!)),
                                              onSaved: (String? value) {},
                                            ),
                                            const SizedBox(height: 16.0),
                                            CommonTextFormField(
                                                labeltxt: "Quantity",
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
                                                controllerTxt: _quantitycontroller,
                                                keyborType: TextInputType
                                                    .number,
                                                onChanged: (String? value) {
                                                  if (saudaOrders.value
                                                      .isEmpty ||
                                                      saudaOrders.value
                                                          .length == 1) {
                                                    _lastLength = null;
                                                    calculatePrice();
                                                    GMLogger.v(
                                                        "Discount Value: " +
                                                            _quantitycontroller
                                                                .text
                                                                .toString());
                                                    setState(() {});
                                                  }
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
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        CommonText(
                                                          name: "Basic Value",
                                                          fontColor: Constant
                                                              .colorDullGray77,
                                                          fontSize: Constant
                                                              .fontSize10,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Row(
                                                          children: [
                                                            CommonText(
                                                              name: "Rs." + rate
                                                                  .toStringAsFixed(
                                                                  2),
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontSize: Constant
                                                                  .fontSize15,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
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
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        CommonText(
                                                          name: "Final Basic Value",
                                                          fontColor: Constant
                                                              .colorDullGray77,
                                                          fontSize: Constant
                                                              .fontSize10,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Row(
                                                          children: [
                                                            CommonText(
                                                              name: "Rs." +
                                                                  finalRate
                                                                      .toStringAsFixed(
                                                                      2),
                                                              fontColor: Constant
                                                                  .colorGreencc,
                                                              fontSize: Constant
                                                                  .fontSize15,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
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
                                                  child: InkWell(
                                                      onTap: () {
                                                        _selectFromDate(
                                                            context, false);
                                                      },
                                                      child: CommonTextFormField(
                                                        labeltxt: "Valid From",
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
                                                        controllerTxt: _fromdatecontroller,
                                                        enabled: false,
                                                      )),
                                                ),
                                                const SizedBox(width: 16.0),
                                                Expanded(
                                                  child: InkWell(
                                                      onTap: () {
                                                        // _selectToDate(context, false);
                                                      },
                                                      child: CommonTextFormField(
                                                        labeltxt: "Valid To",
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
                                                        controllerTxt: _todatecontroller,
                                                        enabled: false,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            //
                                            ValueListenableBuilder<
                                                List<SaudaOrders>>(
                                                valueListenable: saudaOrders,
                                                builder: (context, orders, _) {
                                                  // call API when the length changes
                                                  final currentLength = orders
                                                      .length;

                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                      _) {
                                                    if (_lastLength !=
                                                        currentLength &&
                                                        currentLength == 1) {
                                                      _lastLength =
                                                          currentLength;
                                                      skuID.clear();

                                                      for (var d in saudaOrders
                                                          .value) {
                                                        skuID.add(Sku(
                                                          skuId: d.skuId!,
                                                          oilTypeId: d
                                                              .oilTypeId!,
                                                          quantity: (d
                                                              .bidQuantity ?? 0)
                                                              .toDouble(),
                                                        ));
                                                      }
                                                      GMLogger.v(
                                                          "API call for Mandatory Skus");
                                                      BlocProvider
                                                          .of<
                                                          NewSaudaBloc>(context)
                                                          .add(
                                                          Constants
                                                              .AUTH_ROLEID !=
                                                              Constants.DEALER ?
                                                          MandatorySkus(
                                                            userId: Constants
                                                                .AUTH_USERID,
                                                            stateId: userDefaults
                                                                .stateId!,
                                                            oilTypeId: selectedOilType!
                                                                .id!,
                                                            dealerId: selectedDistributor!
                                                                .id!,
                                                            distributionChannelId: selectedDistrChannel!
                                                                .id!,
                                                            divisonId: selectedVertical!
                                                                .id!,
                                                            salesOrganizationId: selectedSalesOrg!
                                                                .id!,
                                                            skusId: skuID,
                                                            plantId: selectedPlant!
                                                                .id!,
                                                          ) : MandatorySkus(
                                                            userId: Constants
                                                                .AUTH_USERID,
                                                            stateId: userDefaults
                                                                .stateId!,
                                                            oilTypeId: 0,
                                                            dealerId: Constants
                                                                .AUTH_USERID,
                                                            distributionChannelId: selectedSKU
                                                                ?.distributionChannelId ??
                                                                0,
                                                            divisonId: selectedSKU
                                                                ?.divisionId ??
                                                                0,
                                                            salesOrganizationId: selectedSKU
                                                                ?.salesOrganizationId ??
                                                                0,
                                                            skusId: skuID,
                                                            plantId: selectedPlant!
                                                                .id!,
                                                          )
                                                      );
                                                    }
                                                  });


                                                  return saudaEditDeleteContainer();
                                                }),

                                            Visibility(
                                                visible: saudaOrders.value
                                                    .isNotEmpty,
                                                child: Container(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height * 0.05,
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  // padding: const EdgeInsets.only(
                                                  //     top: 10,
                                                  //     bottom: 10,
                                                  //     left: 10,
                                                  //     right: 10),
                                                  color: const Color(
                                                      0xFFECECEC),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              10, 10, 0, 0),
                                                          child: CommonText(
                                                            name: "Total Amount",
                                                            fontSize: Constant
                                                                .fontSize13,
                                                            fontColor: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight500,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              0, 0, 10, 0),
                                                          child: CommonText(
                                                            name: "Rs." +
                                                                getTotalValue()
                                                                    .toString(),
                                                            fontSize: Constant
                                                                .fontSize13,
                                                            fontColor: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),

                                            GestureDetector(
                                              onTap: () {
                                                checkAlertSkuMandatory(
                                                    forceShow: true);
                                              },
                                              child:
                                              hasMandatorySkus == true ?
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Align(
                                                    alignment: Alignment
                                                        .centerRight,
                                                    child: Text(
                                                      "Click here to view the Mandatory items",
                                                      style: TextStyle(
                                                          color: Constant
                                                              .pricbuttonColor),)),
                                              ) : const SizedBox(),
                                            )
                                          ],
                                        ))),
                              ],
                            ),
                          )),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }),
                  progressBar
                ],
              ),
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 16, bottom: 16),
                  child: Visibility(
                    visible: saudaBookingStatus.isActive ?? false,
                    child: SizedBox(
                      width: screenWidth / 1 - 67,
                      child: CommonButton(
                        buttonName: Constant.saudaLEButtonTxt2,
                        buttonNameSize: Constant.fontSize13,
                        buttonNameColor: Constant.pricbuttonTxtColor,
                        buttonColor: saudaOrders.value.isEmpty ? Constant
                            .colorGray45 : Constant.pricbuttonColor,
                        buttonHeight: 48,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Colors.transparent,
                        buttonNameWeight: Constant.fontWeight500,
                        buttonFunction: () {
                          if (saudaOrders.value.isEmpty) {
                            GMLogger.v("No sauda orders to confirm");
                          } else {
                            showConfirmDlg(context, "Confirm Sauda Request",
                                "Confirm Request");
                          }
                        },
                      ),
                    ),
                  )),
            )));
  }

  Container saudaEditDeleteContainer() {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFECECEC),
          borderRadius: BorderRadius
              .only(
            topLeft: Radius.circular(
                25.0),
            topRight: Radius.circular(
                5.0),
            bottomLeft: Radius.circular(
                5.0),
            bottomRight: Radius
                .circular(25.0),
          ),
        ),
        child: ListView.builder(
            key: const Key('builder1'),
            //attention
            padding: const EdgeInsets
                .all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: saudaOrders.value.length,
            itemBuilder: (context,
                index) {
              return Container(
                  width: double
                      .infinity,
                  padding: const EdgeInsets
                      .only(left: 12,
                      right: 12,
                      top: 9,
                      bottom: 9),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: const Color(
                            0xFFDEDEDE)),
                    color: const Color(
                        0xFFffffff),
                    borderRadius: const BorderRadius
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
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .start,
                    mainAxisSize: MainAxisSize
                        .min,
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          /// LEFT SECTION – SKU NAME (flexible + no overflow)
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Flexible(
                                  child: CommonText(
                                    name: "("+saudaOrders.value[index].mtQtyVal.toString()+" MT)" ?? '',
                                    fontColor: Constant.colorRed,
                                    fontSize: Constant.fontSize16,
                                    fontWeight: Constant.fontWeight700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),

                          /// RIGHT SECTION – ICONS
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            // Prevents occupying extra space
                            children: [

                              /// EDIT ICON
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Constant.colorOrange,
                                  ),
                                  onPressed: () async {
                                    // --- your existing logic (kept unchanged) ---
                                    if (Constants.AUTH_ROLEID !=
                                        Constants.DEALER) {
                                      pSelectedOilType = oilTypes
                                          .firstWhere((element) =>
                                      element.id ==
                                          saudaOrders.value[index].oilTypeId);
                                      Meta metaSkuList = await ServiceRepository()
                                          .getFinalPriceSkuNameListForMobile(
                                          selectedDistributor!.id!,
                                          Constants.AUTH_USERID,
                                          selectedDistributor!
                                              .saudaBookingTypeId!,
                                          selectedPlant!.id!,
                                          pSelectedOilType!.id!);

                                      popupSkuList = [];

                                      if (metaSkuList.statusCode == 200) {
                                        jsonDecode(
                                            metaSkuList.statusMsg)['response']
                                            .forEach((f) =>
                                            popupSkuList.add(
                                            SKUPricing.fromJson(f)));
                                      }
                                    }

                                    _pfromdatecontroller.text =
                                    (saudaOrders.value[index]
                                        .saudaValidFromDate ?? "").isNotEmpty
                                        ? DateTimeUtils()
                                        .dateToServerToDateFormat(
                                        saudaOrders.value[index]
                                            .saudaValidFromDate!,
                                        DateTimeUtils.YYYY_MM_DD_Format,
                                        DateTimeUtils.DD_MM_YYYY_Format)
                                        : "";

                                    _ptodatecontroller.text =
                                    (saudaOrders.value[index]
                                        .saudaValidToDate ?? "").isNotEmpty
                                        ? DateTimeUtils()
                                        .dateToServerToDateFormat(
                                        saudaOrders.value[index]
                                            .saudaValidToDate!,
                                        DateTimeUtils.YYYY_MM_DD_Format,
                                        DateTimeUtils.DD_MM_YYYY_Format)
                                        : "";

                                    pSelectedSKU = popupSkuList.firstWhere(
                                            (element) =>
                                        element.skuId ==
                                            saudaOrders.value[index].skuId);

                                    pSelectedDiscountType =
                                    saudaOrders.value[index].discountTypeId!;
                                    selectedEditIndex = index;

                                    if (pSelectedSKU != null) {
                                      itemMaxDiscount =
                                      pSelectedDiscountType == 1
                                          ? pSelectedSKU!.employeeSkuDiscount!
                                          : pSelectedSKU!.employeeSkuPremium!;
                                      itemRatePopup = pSelectedSKU!.price!;
                                    }

                                    _pdiscountcontroller.text = saudaOrders
                                        .value[index].discountAmountPerCase!
                                        .toString();
                                    _pquantitycontroller.text =
                                        saudaOrders.value[index].bidQuantity!
                                            .toString();

                                    showCustomAlertDialog(
                                      context,
                                      contBody(),
                                      'Edit Sauda',
                                      dialogActionButton(),
                                      hideCancelBtn: true,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// DELETE ICON
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Constant.colorRed,
                                ),
                                onPressed: () {
                                  final SaudaOrders removed = saudaOrders
                                      .value[index];
                                  saudaOrders.value =
                                  [...saudaOrders.value]..removeAt(index);
                                  selectedEditIndex = -1;

                                  if (saudaOrders.value.isEmpty) {
                                    _pquantitycontroller.clear();
                                    _pdiscountcontroller.clear();
                                    pSelectedSKU = null;
                                  }

                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(
                          height: 8),
                      buildSkuCard(mandatorySkuMap,
                          context, index),
                    ],
                  ));
            }));
  }

  Widget buildSkuCard(List<Response> response, BuildContext context,
      int index) {
    final String? currentSkuName = saudaOrders.value[index].skuName;
    // STEP 1: Get the matching mandatory SKU mappings
    final List matchingMandatoryMappings = mandatorySkuMap
        .where((e) =>
    currentSkuName != null &&
        e.essentialSkuCode?.any((code) => currentSkuName.contains(code)) ==
            true)
        .expand((e) => e.mandatorySkuMappingList ?? [])
        .toList();


    // STEP 2: Create separate lists
/*    final List<String> mandatoryNames = [];
    final List<double> baseRates = [];
    final List<String> quantities = [];
    final List<String> finalRates = [];

    for (final mandatory in matchingMandatoryMappings) {
      final double price = mandatory.mandatorySkuPrice;
      final num quantity = mandatory.mandatorySkuQuantity;
      final double finalRate = price * quantity.round();

      mandatoryNames.add(mandatory.mandatorySkuName ?? '');
      baseRates.add(double.parse(price.roundToDouble().toStringAsFixed(2)));
      quantities.add(quantity.round().toInt().toString());
      finalRates.add(finalRate.roundToDouble().toStringAsFixed(2));
    }*/


    // STEP 3: Build the UI
    return Column(
      children: [
        firstContainer(
          context,
          index,
          skuName: currentSkuName,
        ),

        /*for (int i = 0; i < mandatoryNames.length; i++)
          mandatoryContainer(
            context,
            index,
            mandatorySkuName: mandatoryNames[i],
            baseRate: baseRates[i].toDouble().toString(),
            quantity: quantities[i],
            finalRate: finalRates[i],
          ),*/
      ],
    );
  }

  Container firstContainer(BuildContext context, int index, {String? skuName}) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(
                    0xFFD5D5D5),
                width: 0.8,
              ),
            )),
        child: Padding(
          padding: const EdgeInsets
              .only(
              top: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(
                        context)
                        .size
                        .width /
                        2.0,
                    child: CommonText(
                      name: "Base Rate (per Qty)",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ),
                  CommonText(
                    name: "Rs. ${(saudaOrders.value[index]
                        .finalBaseRate ??
                        0)
                        .toStringAsFixed(
                        2)}",
                    fontSize: Constant
                        .fontSize12,
                    fontWeight: Constant
                        .fontWeight600,
                  ),
                ],
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "${(saudaOrders.value[index]
                            .discountTypeId ??
                            1) ==
                            1
                            ? 'Discount'
                            : 'Premium'}  (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                        name: "Rs. ${(saudaOrders.value[index]
                            .discountAmountPerCase ??
                            0)
                            .toStringAsFixed(
                            2)}",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                        fontColor: Constant
                            .colorGreencc),
                  ],
                ),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: const SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "Discounted Final Rate (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                      name: "Rs. ${(saudaOrders.value[index]
                          .quotedPrice ??
                          0)
                          .toStringAsFixed(
                          2)}",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "QPS Discount (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                        name: "Rs. ${(saudaOrders.value[index]
                            .qpsDiscount ??
                            0)
                            .toStringAsFixed(
                            2)}",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                        fontColor: Constant
                            .colorGreencc),
                  ],
                ),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: const SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "Final Base Rate (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                      name: "Rs. ${((saudaOrders.value[index]
                          .quotedPrice ??
                          0) -
                          (saudaOrders.value[index]
                              .qpsDiscount ??
                              0))
                          .toStringAsFixed(
                          2)}",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(
                        context)
                        .size
                        .width /
                        2.0,
                    child: CommonText(
                      name: "Final Rate",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ),
                  CommonText(
                    name: "Rs. ${((saudaOrders.value[index]
                        .quotedPrice ??
                        0) -
                        (saudaOrders.value[index]
                            .qpsDiscount ??
                            0))
                        .toStringAsFixed(
                        2)} x " +
                        saudaOrders.value[index]
                            .bidQuantity
                            .toString() +
                        " " +
                        (saudaOrders.value[index]
                            .uomName ??
                            ""),
                    fontSize: Constant
                        .fontSize12,
                    fontColor: Constant
                        .colorOrange,
                    fontWeight: Constant
                        .fontWeight600,
                  ),
                ],
              ),
              const SizedBox(
                  height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(
                        context)
                        .size
                        .width /
                        2.0,
                    child: CommonText(
                      name: skuName,
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ),
                  CommonText(
                    name:
                    "Rs. ${(((saudaOrders.value[index]
                        .quotedPrice ??
                        0) -
                        (saudaOrders.value[index]
                            .qpsDiscount ??
                            0)) *
                        (saudaOrders.value[index]
                            .bidQuantity ??
                            0))
                        .toStringAsFixed(
                        2)}",
                    fontSize: Constant
                        .fontSize12,
                    fontWeight: Constant
                        .fontWeight600,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Container mandatoryContainer(BuildContext context, int index,
      {String? mandatorySkuName, String? baseRate,
        String? finalRate, String? quantity}) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(
                    0xFFD5D5D5),
                width: 0.8,
              ),
            )),
        child: Padding(
          padding: const EdgeInsets
              .only(
              top: 8),
          child: Column(
            children: [
              /*Align(
                                                                  alignment: Alignment
                                                                      .centerRight,
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 20,
                                                                        height: 20,
                                                                        child: IconButton(
                                                                          padding: EdgeInsets
                                                                              .zero,
                                                                          constraints: const BoxConstraints(),
                                                                          icon: Icon(
                                                                            Icons
                                                                                .edit,
                                                                            size: 20,
                                                                            color: Constant
                                                                                .colorOrange,
                                                                          ),
                                                                          onPressed: () async {
                                                                            if (Constants
                                                                                .AUTH_ROLEID !=
                                                                                Constants
                                                                                    .DEALER) {
                                                                              pSelectedOilType =
                                                                                  oilTypes
                                                                                      .where((
                                                                                      element) =>
                                                                                  element
                                                                                      .id ==
                                                                                      saudaOrders.value[index]
                                                                                          .oilTypeId)
                                                                                      .first;
                                                                              Meta metaSkuList = await ServiceRepository()
                                                                                  .getFinalPriceSkuNameListForMobile(
                                                                                  selectedDistributor!
                                                                                      .id!,
                                                                                  Constants
                                                                                      .AUTH_USERID,
                                                                                  selectedDistributor!
                                                                                      .saudaBookingTypeId!,
                                                                                  selectedPlant!
                                                                                      .id!,
                                                                                  pSelectedOilType!
                                                                                      .id!);
                                                                              popupSkuList =
                                                                              [
                                                                              ];
                                                                              if (metaSkuList
                                                                                  .statusCode ==
                                                                                  200) {
                                                                                jsonDecode(
                                                                                    metaSkuList
                                                                                        .statusMsg)['response']
                                                                                    .forEach((
                                                                                    f) =>
                                                                                    popupSkuList
                                                                                        .add(
                                                                                        SKUPricing
                                                                                            .fromJson(
                                                                                            f)));
                                                                              }
                                                                            }
                                                                            if (saudaOrders.value[index]
                                                                                .saudaValidFromDate !=
                                                                                "") {
                                                                              _pfromdatecontroller
                                                                                  .text =
                                                                                  DateTimeUtils()
                                                                                      .dateToServerToDateFormat(
                                                                                      saudaOrders.value[index]
                                                                                          .saudaValidFromDate!,
                                                                                      DateTimeUtils
                                                                                          .YYYY_MM_DD_Format,
                                                                                      DateTimeUtils
                                                                                          .DD_MM_YYYY_Format);
                                                                            } else {
                                                                              _pfromdatecontroller
                                                                                  .text =
                                                                              "";
                                                                            }
                                                                            if (saudaOrders.value[index]
                                                                                .saudaValidToDate !=
                                                                                "") {
                                                                              _ptodatecontroller
                                                                                  .text =
                                                                                  DateTimeUtils()
                                                                                      .dateToServerToDateFormat(
                                                                                      saudaOrders.value[index]
                                                                                          .saudaValidToDate!,
                                                                                      DateTimeUtils
                                                                                          .YYYY_MM_DD_Format,
                                                                                      DateTimeUtils
                                                                                          .DD_MM_YYYY_Format);
                                                                            } else {
                                                                              _ptodatecontroller
                                                                                  .text =
                                                                              "";
                                                                            }
                                                                            pSelectedSKU =
                                                                                popupSkuList
                                                                                    .where((
                                                                                    element) =>
                                                                                element
                                                                                    .skuId ==
                                                                                    saudaOrders.value[index]
                                                                                        .skuId)
                                                                                    .first;
                                                                            pSelectedDiscountType =
                                                                            saudaOrders.value[index]
                                                                                .discountTypeId!;
                                                                            selectedEditIndex =
                                                                                index;
                                                                            if (pSelectedSKU !=
                                                                                null) {
                                                                              if (pSelectedDiscountType ==
                                                                                  1) {
                                                                                itemMaxDiscount =
                                                                                pSelectedSKU!
                                                                                    .employeeSkuDiscount!;
                                                                              } else {
                                                                                itemMaxDiscount =
                                                                                pSelectedSKU!
                                                                                    .employeeSkuPremium!;
                                                                              }
                                                                              itemRatePopup =
                                                                              pSelectedSKU!
                                                                                  .price!;
                                                                            }

                                                                            // checkAlertQPSQty(
                                                                            //     pSelectedSKU!
                                                                            //         .skuId ??
                                                                            //         0,
                                                                            //     isAlertTriggered: true);

                                                                            _pdiscountcontroller
                                                                                .text =
                                                                                saudaOrders.value[index]
                                                                                    .discountAmountPerCase!
                                                                                    .toString();
                                                                            _pquantitycontroller
                                                                                .text =
                                                                                saudaOrders.value[index]
                                                                                    .bidQuantity!
                                                                                    .toString();

                                                                            showCustomAlertDialog(
                                                                                context,
                                                                                contBody(),
                                                                                'Edit Sauda',
                                                                                dialogActionButton(),
                                                                                hideCancelBtn: true);
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),*/
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(
                        context)
                        .size
                        .width /
                        2.0,
                    child: CommonText(
                      name: "Mandatory Base Rate (per Qty)",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ),
                  CommonText(
                    name: "Rs. $baseRate",
                    fontSize: Constant
                        .fontSize12,
                    fontWeight: Constant
                        .fontWeight600,
                  ),
                ],
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "${(saudaOrders.value[index]
                            .discountTypeId ??
                            1) ==
                            1
                            ? 'Discount'
                            : 'Premium'}  (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                        name: "Rs. ${(saudaOrders.value[index]
                            .discountAmountPerCase ??
                            0)
                            .toStringAsFixed(
                            2)}",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                        fontColor: Constant
                            .colorGreencc),
                  ],
                ),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: const SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .discountAmountPerCase ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "Discounted Final Rate (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                      name: "Rs. ${(saudaOrders.value[index]
                          .quotedPrice ??
                          0)
                          .toStringAsFixed(
                          2)}",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "QPS Discount (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                        name: "Rs. ${(saudaOrders.value[index]
                            .qpsDiscount ??
                            0)
                            .toStringAsFixed(
                            2)}",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                        fontColor: Constant
                            .colorGreencc),
                  ],
                ),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: const SizedBox(
                    height: 8),
              ),
              Visibility(
                visible: (saudaOrders.value[index]
                    .qpsDiscount ??
                    0) !=
                    0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(
                          context)
                          .size
                          .width /
                          2.0,
                      child: CommonText(
                        name: "Final Base Rate (per Qty)",
                        fontSize: Constant
                            .fontSize12,
                        fontWeight: Constant
                            .fontWeight600,
                      ),
                    ),
                    CommonText(
                      name: "Rs. ${((saudaOrders.value[index]
                          .quotedPrice ??
                          0) -
                          (saudaOrders.value[index]
                              .qpsDiscount ??
                              0))
                          .toStringAsFixed(
                          2)}",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(
                        context)
                        .size
                        .width /
                        2.0,
                    child: CommonText(
                      name: "Final Rate",
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ),
                  CommonText(
                    name: "Rs. $baseRate x " +
                        " $quantity" +
                        " " +
                        (saudaOrders.value[index]
                            .uomName ??
                            ""),
                    fontSize: Constant
                        .fontSize12,
                    fontColor: Constant
                        .colorOrange,
                    fontWeight: Constant
                        .fontWeight600,
                  ),
                ],
              ),
              const SizedBox(
                  height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(
                        context)
                        .size
                        .width /
                        2.0,
                    child: CommonText(
                      name: mandatorySkuName,
                      fontSize: Constant
                          .fontSize12,
                      fontWeight: Constant
                          .fontWeight600,
                    ),
                  ),
                  CommonText(
                    name:
                    "Rs. $finalRate",
                    fontSize: Constant
                        .fontSize12,
                    fontWeight: Constant
                        .fontWeight600,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  checkAlertQPSQty(int? skuId, {bool isAlertTriggered = false}) {
    //qpsResModel.clear();
    List<SkuDetails> qpsReqModel = <SkuDetails>[];
    double qty = 0;
    if (_pquantitycontroller.text.isNotEmpty && isAlertTriggered) {
      qty = double.parse(_pquantitycontroller.text);
    } else if (_quantitycontroller.text.isNotEmpty) {
      qty = double.parse(
          _quantitycontroller.text.isEmpty ? "0" : _quantitycontroller.text);
    }
    qpsReqModel.add(SkuDetails(quantity: qty, skuId: skuId));
    BlocProvider.of<NewSaudaBloc>(context)
        .add(OnLoadQPS(qpsReqModel: qpsReqModel,
        isAlertTriggered: isAlertTriggered,
        dealerId: (selectedDistributor ?? DistributorList()).id ??
            Constants.AUTH_USERID));
  }


//popup
  void showCustomAlertDialog(BuildContext context, messageValue, title,
      footerbutton,
      {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors
          .white}) {
    // set up the button

    // show the dialog
    // var mainContext=context;
    if (selectedEditIndex == -1 && Constants.AUTH_ROLEID != Constants.DEALER) {
      popupSkuList = [];
    }
    pSelectedDiscountType = 1;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        double finalRate = 0;
        double rate = 0;
        SKUPricing? pSelectedItem = pSelectedSKU;
        if (selectedEditIndex != -1 && saudaOrders.value.isNotEmpty) {
          pSelectedDiscountType =
              saudaOrders.value[selectedEditIndex].discountTypeId ?? 1;
          finalRate = 0;
          double selectedRate = 0;
          double finalPrice = 0;
          double qty = 0;
          selectedRate = pSelectedSKU!.price!;
          finalPrice = selectedRate;
          if (_pquantitycontroller.text.isNotEmpty) {
            qty = double.parse(_pquantitycontroller.text);
          }
          if (qty != 0) {
            if (pSelectedSKU != null && pSelectedSKU!.price! > 0) {
              QPSResponseData allottedQPS = QPSResponseData();
              allottedQPS = calculateQPSDiscount(qty, isFromAlert: true);
              pSelectedSKU!.qpsDiscount = allottedQPS.discount;
              if (pSelectedDiscountType == 1) {
                if (pSelectedSKU != null &&
                    double.parse(_pdiscountcontroller.text.toString()) >
                        pSelectedSKU!.employeeSkuDiscount!) {
                  // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                  _pdiscountcontroller.text =
                      pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
                }
                finalPrice = ((pSelectedSKU!.price ??
                    0) /*- (allottedQPS.discount ?? 0)*/) -
                    double.parse(_pdiscountcontroller.text.toString());
              } else {
                // if(pSelectedSKU!=null && double.parse(
                //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                //   _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                // }
                finalPrice = ((pSelectedSKU!.price ??
                    0) /*- (allottedQPS.discount ?? 0)*/) +
                    double.parse(_pdiscountcontroller.text.toString());
              }
            }
          }
          // if (_pquantitycontroller.text.isNotEmpty) {
          //   qty = double.parse(
          //       _pquantitycontroller.text.toString());
          // }
          finalRate = finalPrice * qty;
          rate = selectedRate * qty;
        }
        // double itemRatePopup=0;
        return StatefulBuilder(
            key: _dialogKey,
            builder: (ctx1, setState) {
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                  height: Constants.AUTH_ROLEID != Constants.DEALER
                      ? 475.0
                      : 400.0,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: Constants.AUTH_ROLEID != Constants.DEALER,
                            child:
                            // Container(
                            //     padding: const EdgeInsets.only(top:10),
                            //     width: double.infinity,
                            //     height: 70,
                            //     child: CommonDropdownButtonFormField<OilType>(
                            //       isExpanded: true,
                            //       value: pSelectedOilType,
                            //       icon: const Align(
                            //           alignment: Alignment.topRight,
                            //           child: Icon(
                            //             Icons.keyboard_arrow_down,
                            //             size: 24,
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
                            //           labelText: "Oil Type",
                            //           labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                            //           fillColor: fillColor),
                            //       onChanged: (OilType? newValue) async{
                            //         pSelectedItem=null;
                            //         pSelectedSKU=null;
                            //         pSelectedOilType = newValue!;
                            //         // BlocProvider.of<NewSaudaBloc>(mainContext).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
                            //         //     .saudaBookingTypeId!,oilTypeId: pSelectedOilType!.id!,popup: true));
                            //         Meta metaSkuList = await ServiceRepository().getFinalPriceSkuNameListForMobile(
                            //             selectedDistributor!.id!,Constants.AUTH_USERID,selectedDistributor!
                            //             .saudaBookingTypeId!,selectedPlant!.id!,pSelectedOilType!.id!);
                            //         popupSkuList = [];
                            //         if (metaSkuList.statusCode == 200) {
                            //           jsonDecode(
                            //               metaSkuList.statusMsg)['response']
                            //               .forEach((f) => popupSkuList.add(SKUPricing.fromJson(f)));
                            //         }
                            //         setState(() {
                            //
                            //         });
                            //       },
                            //       items: oilTypes
                            //           .map<DropdownMenuItem<OilType>>((value) {
                            //         return DropdownMenuItem<OilType>(
                            //           value: value,
                            //           child: Text(value.name!),
                            //         );
                            //       }).toList(),
                            //     ))),
                            CustomAutocomplete<OilType>(
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                _popupoiltypecontroller =
                                    fieldTextEditingController;
                                if (pSelectedOilType != null) {
                                  _popupoiltypecontroller!.text =
                                  pSelectedOilType!.name!;
                                }
                                return TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets
                                          .symmetric(
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
                                              bottomLeft: Radius.circular(
                                                  borderRadiusTRBL),
                                              bottomRight: Radius.circular(
                                                  borderRadiusTLBR)),
                                          borderSide: BorderSide(
                                              color: borderColor!, width: 1.0)),
                                      enabledBorder: OutlineInputBorder(
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
                                      filled: true,
                                      // hintStyle: TextStyle(color: Colors.grey[800]),
                                      labelText: "Oil Type",
                                      labelStyle: TextStyle(color: labelTxtCol,
                                          fontSize: labelTxtSize),
                                      fillColor: fillColor),
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                  // style: const TextStyle(fontWeight: FontWeight.normal),
                                );
                              },
                              optionsMaxWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.74,
                              displayStringForOption: _displayStringForOilTypeOption,
                              optionsBuilder: (
                                  TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<OilType>.empty();
                                }
                                return oilTypes.where((OilType option) {
                                  return option.name.toString()
                                      .toLowerCase()
                                      .contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (OilType selection) async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                pSelectedItem = null;
                                pSelectedSKU = null;
                                _popupskunamecontroller!.text = "";
                                pSelectedOilType = selection;
                                // BlocProvider.of<NewSaudaBloc>(mainContext).add(LoadSKUDetails(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.id!,plantId: selectedPlant!.id!,saudaBookingTypeId: selectedDistributor!
                                //     .saudaBookingTypeId!,oilTypeId: pSelectedOilType!.id!,popup: true));
                                Meta metaSkuList = await ServiceRepository()
                                    .getFinalPriceSkuNameListForMobile(
                                    selectedDistributor!.id!,
                                    Constants.AUTH_USERID,
                                    selectedDistributor!.saudaBookingTypeId!,
                                    selectedPlant!.id!, pSelectedOilType!.id!);
                                popupSkuList = [];
                                if (metaSkuList.statusCode == 200) {
                                  jsonDecode(metaSkuList.statusMsg)['response']
                                      .forEach((f) =>
                                      popupSkuList.add(SKUPricing.fromJson(f)));
                                }
                                setState(() {});
                              },
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
                        //             size: 24,
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
                        //         var o=saudaOrders.valuewhere((element) => element.skuId==newValue!.skuId!);
                        //         if(selectedEditIndex!=-1 || o.isEmpty) {
                        //           pSelectedSKU = newValue!;
                        //           pSelectedItem=newValue;
                        //           itemRatePopup = pSelectedSKU!.price!;
                        //           setState(() {
                        //
                        //           });
                        //         }else{
                        //           newValue=null;
                        //           pSelectedSKU=null;
                        //           pSelectedItem=null;
                        //           _skuKey.currentState!.reset();
                        //           setState(() {
                        //
                        //           });
                        //           showSuccessDlg(context, "Error", "Error",successText: "SKU already selected",closeScreen: false);
                        //         }
                        //         // BlocProvider.of<NewSaudaBloc>(context).add(ChangeRate(popup: true));
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
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            _popupskunamecontroller =
                                fieldTextEditingController;
                            if (pSelectedSKU != null) {
                              _popupskunamecontroller!.text =
                              pSelectedSKU!.skuName!;
                            }
                            return TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              decoration: InputDecoration(
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
                                          bottomLeft: Radius.circular(
                                              borderRadiusTRBL),
                                          bottomRight: Radius.circular(
                                              borderRadiusTLBR)),
                                      borderSide: BorderSide(
                                          color: borderColor!, width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
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
                                  filled: true,
                                  // hintStyle: TextStyle(color: Colors.grey[800]),
                                  labelText: "SKU Name",
                                  labelStyle: TextStyle(color: labelTxtCol,
                                      fontSize: labelTxtSize),
                                  fillColor: fillColor),
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              // style: const TextStyle(fontWeight: FontWeight.normal),
                            );
                          },
                          optionsMaxWidth: MediaQuery
                              .of(context)
                              .size
                              .width * 0.74,
                          displayStringForOption: _displayStringForSkuOption,
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<SKUPricing>.empty();
                            }
                            return popupSkuList.where((SKUPricing option) {
                              return option.skuName.toString()
                                  .toLowerCase()
                                  .contains(
                                  textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (SKUPricing selection) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var o = saudaOrders.value.where((element) =>
                            element.skuId == selection.skuId!);

                            if ((selectedEditIndex != -1 &&
                                saudaOrders.value.isNotEmpty) || o.isEmpty) {
                              pSelectedSKU = selection;
                              pSelectedItem = selection;
                              itemRatePopup = pSelectedSKU!.price!;
                              setAlertDiscountAndPremium();
                              setState(() {});
                            } else {
                              pSelectedSKU = null;
                              pSelectedItem = null;
                              _popupskunamecontroller!.text = "";
                              if (_skuKey.currentState != null)
                                _skuKey.currentState!.reset();
                              setState(() {});
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "SKU already selected",
                                  closeScreen: false);
                            }
                            // BlocProvider.of<NewSaudaBloc>(context).add(ChangeRate(popup: true));

                            ///To reset the rate and basic value.
                            pSelectedDiscountType = 1;
                            _pquantitycontroller.clear();
                            finalRate = 0;
                            double selectedRate = 0;
                            double finalPrice = 0;
                            double qty = 0;
                            selectedRate = pSelectedSKU!.price!;
                            finalPrice = selectedRate;
                            if (_pdiscountcontroller.text.isNotEmpty) {
                              if (pSelectedSKU != null &&
                                  pSelectedSKU!.price! > 0) {
                                if (pSelectedDiscountType == 1) {
                                  if (pSelectedSKU != null && double.parse(
                                      _pdiscountcontroller.text.toString()) >
                                      pSelectedSKU!.employeeSkuDiscount!) {
                                    // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                    _pdiscountcontroller.text =
                                        pSelectedSKU!.employeeSkuDiscount!
                                            .toStringAsFixed(2);
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
                            _pquantitycontroller.clear();
                            if (_pquantitycontroller.text.toString() != "") {
                              qty = double.parse(
                                  _pquantitycontroller.text.toString());
                            }
                            finalRate = finalPrice * qty;
                            rate = selectedRate * qty;

                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Basic Rate (Rs)",
                                      fontColor: Constant.colorDullGray77,
                                      fontSize: Constant.fontSize10,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        CommonText(
                                          name: "Rs." +
                                              (itemRatePopup.toStringAsFixed(
                                                  2)),
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
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight
                              .w600),
                        ),
                        StatefulBuilder(builder: (BuildContext context,
                            StateSetter setState) {
                          return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.33,
                                  child: RadioListTile<int>(
                                    visualDensity: VisualDensity.compact,
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
                                        setAlertDiscountAndPremium();

                                        ///To reset the rate and basic value.

                                        finalRate = 0;
                                        double selectedRate = 0;
                                        double finalPrice = 0;
                                        double qty = 0;
                                        selectedRate = pSelectedSKU!.price!;
                                        finalPrice = selectedRate;
                                        if (_pdiscountcontroller.text
                                            .isNotEmpty) {
                                          if (pSelectedSKU != null &&
                                              pSelectedSKU!.price! > 0) {
                                            if (pSelectedDiscountType == 1) {
                                              if (pSelectedSKU != null &&
                                                  double.parse(
                                                      _pdiscountcontroller.text
                                                          .toString()) >
                                                      pSelectedSKU!
                                                          .employeeSkuDiscount!) {
                                                // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                                _pdiscountcontroller.text =
                                                    pSelectedSKU!
                                                        .employeeSkuDiscount!
                                                        .toStringAsFixed(2);
                                              }
                                              finalPrice =
                                                  pSelectedSKU!.price! -
                                                      double.parse(
                                                          _pdiscountcontroller
                                                              .text.toString());
                                            } else {
                                              // if(pSelectedSKU!=null && double.parse(
                                              //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                                              //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                                              //   // _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                                              // }
                                              finalPrice =
                                                  pSelectedSKU!.price! +
                                                      double.parse(
                                                          _pdiscountcontroller
                                                              .text.toString());
                                            }
                                          }
                                        }
                                        if (_pquantitycontroller.text
                                            .isNotEmpty) {
                                          qty = double.parse(
                                              _pquantitycontroller.text
                                                  .toString());
                                        }
                                        finalRate = finalPrice * qty;
                                        rate = selectedRate * qty;

                                        ///End
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.33,
                                    child: RadioListTile<int>(
                                      visualDensity: VisualDensity.compact,
                                      title: Text('Premium',
                                          style: TextStyle(
                                            fontSize: Constant.fontSize12,
                                          )),
                                      value: 2,
                                      groupValue: pSelectedDiscountType,
                                      onChanged: (int? value) {
                                        setState(() {
                                          pSelectedDiscountType = value!;
                                          setAlertDiscountAndPremium();

                                          ///To reset the rate and basic value.

                                          finalRate = 0;
                                          double selectedRate = 0;
                                          double finalPrice = 0;
                                          double qty = 0;
                                          selectedRate = pSelectedSKU!.price!;
                                          finalPrice = selectedRate;
                                          if (_pdiscountcontroller.text
                                              .isNotEmpty) {
                                            if (pSelectedSKU != null &&
                                                pSelectedSKU!.price! > 0) {
                                              if (pSelectedDiscountType == 1) {
                                                if (pSelectedSKU != null &&
                                                    double.parse(
                                                        _pdiscountcontroller
                                                            .text.toString()) >
                                                        pSelectedSKU!
                                                            .employeeSkuDiscount!) {
                                                  // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                                  _pdiscountcontroller.text =
                                                      pSelectedSKU!
                                                          .employeeSkuDiscount!
                                                          .toStringAsFixed(2);
                                                }
                                                finalPrice =
                                                    pSelectedSKU!.price! -
                                                        double.parse(
                                                            _pdiscountcontroller
                                                                .text
                                                                .toString());
                                              } else {
                                                // if(pSelectedSKU!=null && double.parse(
                                                //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                                                //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                                                //   // _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                                                // }
                                                finalPrice =
                                                    pSelectedSKU!.price! +
                                                        double.parse(
                                                            _pdiscountcontroller
                                                                .text
                                                                .toString());
                                              }
                                            }
                                          }
                                          if (_pquantitycontroller.text
                                              .toString() != "") {
                                            qty = double.parse(
                                                _pquantitycontroller.text
                                                    .toString());
                                          }
                                          finalRate = finalPrice * qty;
                                          rate = selectedRate * qty;
                                          setState(() {});

                                          ///End
                                        });
                                      },
                                    )),
                              ]);
                        }),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _pdiscountcontroller,
                          inputFormatters: [new FilteringTextInputFormatter
                              .deny(RegExp("[\\-]"))
                          ],
                          maxLines: 1,
                          enabled: true,
                          onChanged: (String? value) {
                            _pquantitycontroller.clear();
                            finalRate = 0;
                            double selectedRate = 0;
                            double finalPrice = 0;
                            double qty = 0;
                            selectedRate = pSelectedSKU!.price!;
                            finalPrice = selectedRate;
                            if (_pdiscountcontroller.text.toString() != "") {
                              if (pSelectedSKU != null &&
                                  pSelectedSKU!.price! > 0) {
                                if (pSelectedDiscountType == 1) {
                                  if (pSelectedSKU != null && double.parse(
                                      _pdiscountcontroller.text.toString()) >
                                      pSelectedSKU!.employeeSkuDiscount!) {
                                    // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                    _pdiscountcontroller.text =
                                        pSelectedSKU!.employeeSkuDiscount!
                                            .toStringAsFixed(2);
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
                              labelText: pDiscountLabel,
                              labelStyle: TextStyle(
                                  color: Constant.textFormFieldColor!,
                                  fontSize: Constant.textFormFieldSize,
                                  fontWeight: Constant.textFormFieldSizeFontW),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constant.textFormFocuBorCol!,
                                      width: Constant.textFormFocuBorWid!),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Constant.textFormborderRadiusTL!),
                                    topRight: Radius.circular(
                                        Constant.textFormborderRadiusBR!),
                                    bottomLeft: Radius.circular(
                                        Constant.textFormborderRadiusBR!),
                                    bottomRight: Radius.circular(
                                        Constant.textFormborderRadiusTL!),
                                  )),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constant.textFormEnaBorCol!,
                                      width: Constant.textFormEnaBorWid!),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Constant.textFormborderRadiusTL!),
                                    topRight: Radius.circular(
                                        Constant.textFormborderRadiusBR!),
                                    bottomLeft: Radius.circular(
                                        Constant.textFormborderRadiusBR!),
                                    bottomRight: Radius.circular(
                                        Constant.textFormborderRadiusTL!),
                                  )),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Constant.textFormcontentPadHor!,
                                  vertical: Constant.textFormcontentPadHVer!)),
                          onSaved: (String? value) {},
                        ),
                        // CommonTextFormField(
                        //     labeltxt: "Discount Amount (Max :"+itemMaxDiscount.toStringAsFixed(2)+")",
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
                              if (_pquantitycontroller.text.isNotEmpty) {
                                qty = double.parse(_pquantitycontroller.text);
                              }
                              if (qty != 0) {
                                if (pSelectedSKU != null &&
                                    pSelectedSKU!.price! > 0) {
                                  QPSResponseData allottedQPS = QPSResponseData();

                                  allottedQPS = calculateQPSDiscount(
                                      qty, isFromAlert: true);

                                  pSelectedSKU!.qpsDiscount =
                                      allottedQPS.discount;

                                  double discountValue = 0;

                                  if (_pdiscountcontroller.text.isNotEmpty) {
                                    discountValue =
                                        double.parse(_pdiscountcontroller.text);
                                  }

                                  if (pSelectedDiscountType == 1) {
                                    if (pSelectedSKU != null && discountValue >
                                        pSelectedSKU!.employeeSkuDiscount!) {
                                      // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter discount greater than "+pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2));
                                      _pdiscountcontroller.text =
                                          pSelectedSKU!.employeeSkuDiscount!
                                              .toStringAsFixed(2);
                                    }

                                    finalPrice = ((pSelectedSKU!.price ?? 0) /* -
                                        (allottedQPS.discount ?? 0)*/
                                    ) -
                                        discountValue;
                                  } else {
                                    // if(pSelectedSKU!=null && double.parse(
                                    //     _pdiscountcontroller.text.toString())>pSelectedSKU!.employeeSkuPremium!){
                                    //   // showSuccessDlg(context, "Error", "Error",successText: "Cannot enter premium greater than "+pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2));
                                    //   // _pdiscountcontroller.text=pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
                                    // }

                                    finalPrice = ((pSelectedSKU!.price ?? 0) /*-
                                        (allottedQPS.discount ?? 0)*/
                                    ) +
                                        discountValue;
                                  }
                                }
                              }
                              // if (_pquantitycontroller.text.isNotEmpty) {
                              //   qty = double.parse(
                              //       _pquantitycontroller.text);
                              // }
                              finalRate = finalPrice * qty;
                              rate = selectedRate * qty;
                              pSelectedSKU!.finalRate = finalRate;

                              setState(() {});
                            }),
                        const SizedBox(height: 16.0),
                        Visibility(
                            visible: false,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        _selectFromDate(context, true);
                                      },
                                      child: CommonTextFormField(
                                        labeltxt: "Valid From",
                                        labeltxtColor: Constant
                                            .textFormFieldColor,
                                        labeltxtSize: Constant
                                            .textFormFieldSize,
                                        labeltxtFontWeight: Constant
                                            .textFormFieldSizeFontW,
                                        focuBorColor: Constant
                                            .textFormFocuBorCol,
                                        focuBorWid: Constant.textFormFocuBorWid,
                                        enaBorColor: Constant.textFormEnaBorCol,
                                        enaBorWid: Constant.textFormEnaBorWid,
                                        borderRadiusTL: Constant
                                            .textFormborderRadiusTL,
                                        borderRadiusBR: Constant
                                            .textFormborderRadiusBR,
                                        contentPadHor: Constant
                                            .textFormcontentPadHor,
                                        contentPadHVer: Constant
                                            .textFormcontentPadHVer,
                                        controllerTxt: _fromdatecontroller,
                                        enabled: false,
                                      )),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        // _selectToDate(context, true);
                                      },
                                      child: CommonTextFormField(
                                        labeltxt: "Valid To",
                                        labeltxtColor: Constant
                                            .textFormFieldColor,
                                        labeltxtSize: Constant
                                            .textFormFieldSize,
                                        labeltxtFontWeight: Constant
                                            .textFormFieldSizeFontW,
                                        focuBorColor: Constant
                                            .textFormFocuBorCol,
                                        focuBorWid: Constant.textFormFocuBorWid,
                                        enaBorColor: Constant.textFormEnaBorCol,
                                        enaBorWid: Constant.textFormEnaBorWid,
                                        borderRadiusTL: Constant
                                            .textFormborderRadiusTL,
                                        borderRadiusBR: Constant
                                            .textFormborderRadiusBR,
                                        contentPadHor: Constant
                                            .textFormcontentPadHor,
                                        contentPadHVer: Constant
                                            .textFormcontentPadHVer,
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
                                      name: "Basic Value",
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
                                      name: "Final Basic Value",
                                      fontColor: Constant.colorDullGray77,
                                      fontSize: Constant.fontSize10,
                                    ),
                                    const SizedBox(height: 4),
                                    CommonText(
                                      name: "Rs." +
                                          finalRate.toStringAsFixed(2),
                                      fontColor: Constant.colorGreencc,
                                      fontSize: Constant.fontSize15,
                                      fontWeight: Constant.fontWeight500,
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

  QPSResponseData calculateQPSDiscount(double qty,
      {required bool isFromAlert}) {
    QPSResponseData allottedQPS = QPSResponseData();
    List<QPSResponseData> qpsResModelTemp = <QPSResponseData>[];

    if (isFromAlert && selectedEditIndex != -1 &&
        saudaOrders.value.isNotEmpty) {
      qpsResModelTemp =
          saudaOrders.value[selectedEditIndex].qpsResModel ??
              <QPSResponseData>[];
    } else {
      qpsResModelTemp = qpsResModel;
    }

    if (qty != 0) {
      allottedQPS.skuId ??= 0;

      List<QPSResponseData> qpsResMaterialBased = <QPSResponseData>[];
      List<QPSResponseData> qpsResOilBased = <QPSResponseData>[];

      QPSResponseData allottedQPSResMaterialBased = QPSResponseData();
      QPSResponseData allottedQPSResOilBased = QPSResponseData();

      // List<QPSResponseData> separateSchemeList = <QPSResponseData>[];

      int tempQPSDiscountId = 0;

      if (qpsResModelTemp.isNotEmpty) {
        tempQPSDiscountId = qpsResModelTemp.first.qpsDiscountId ?? 0;
      }
      int q = 0;
      for (; q < qpsResModelTemp.length;) {
        if (tempQPSDiscountId == qpsResModelTemp[q].qpsDiscountId) {
          if ((qpsResModelTemp[q].fromRange ?? 0) <= qty &&
              (qpsResModelTemp[q].toRange ?? 0) >= qty) {
            allottedQPS.discount = (allottedQPS.discount ?? 0.0) +
                (qpsResModelTemp[q].discount ?? 0.0);
            // separateSchemeList.add(qpsResModelTemp[q]);
          }
          q = q + 1;
        } else {
          if ((qpsResModelTemp[q - 1].fromRange ?? 0) <= qty &&
              (qpsResModelTemp[q - 1].toRange ?? 0) >= qty) {} else
          if ((qpsResModelTemp[q - 1].toRange ?? 0) < qty) {
            allottedQPS.discount = (allottedQPS.discount ?? 0.0) +
                (qpsResModelTemp[q - 1].discount ?? 0.0);
          }

          tempQPSDiscountId = qpsResModelTemp[q].qpsDiscountId ?? 0;

          if ((qpsResModelTemp[q].fromRange ?? 0) <= qty &&
              (qpsResModelTemp[q].toRange ?? 0) >= qty) {
            allottedQPS.discount = (allottedQPS.discount ?? 0.0) +
                (qpsResModelTemp[q].discount ?? 0.0);
            // separateSchemeList.add(qpsResModelTemp[q]);
          }
          q = q + 1;

          // separateSchemeList.clear();
        }

        allottedQPS.skuId = allottedQPSResMaterialBased.skuId ?? 0;
        allottedQPS.slabName = allottedQPSResMaterialBased.slabName ?? "";
        allottedQPS.fromRange = allottedQPSResMaterialBased.fromRange ?? 0;
        allottedQPS.toRange = allottedQPSResMaterialBased.toRange ?? 0;
        allottedQPS.skuType = allottedQPSResMaterialBased.skuType ?? 0;

        /* if (it.skuType == 1) {
          qpsResMaterialBased.add(it);
          if ((it.fromRange ?? 0) <= qty && (it.toRange ?? 0) >= qty) {
            allottedQPSResMaterialBased = it;
          }
        }
        if (it.skuType == 0) {
          qpsResOilBased.add(it);
          if ((it.fromRange ?? 0) <= qty && (it.toRange ?? 0) >= qty) {
            allottedQPSResOilBased = it;
          }
        }*/
      }

      if (qpsResModelTemp.isNotEmpty) {
        if ((qpsResModelTemp.last.toRange ?? 0) < qty) {
          allottedQPS.discount = (allottedQPS.discount ?? 0.0) +
              (qpsResModelTemp.last.discount ?? 0.0);
        }
      }

      // for (var it in qpsResModelTemp) {
      //   if ((it.fromRange ?? 0) <= qty && (it.toRange ?? 0) >= qty) {
      //     allottedQPS = it;
      //     break;
      //   }
      // }

      /*if (qpsResModelTemp.isNotEmpty) {
        if ((allottedQPSResMaterialBased.skuId ?? 0) == 0 &&
            qpsResMaterialBased.isNotEmpty) {
          if ((qpsResMaterialBased.last.toRange ?? 0) < qty) {
            allottedQPSResMaterialBased = qpsResMaterialBased.last;
          }
        }
        if ((allottedQPSResOilBased.skuId ?? 0) == 0 &&
            qpsResOilBased.isNotEmpty) {
          if ((qpsResOilBased.last.toRange ?? 0) < qty) {
            allottedQPSResOilBased = qpsResOilBased.last;
          }
        }
        allottedQPS.skuId = allottedQPSResMaterialBased.skuId ?? 0;
        allottedQPS.slabName = allottedQPSResMaterialBased.slabName ?? "";
        allottedQPS.fromRange = allottedQPSResMaterialBased.fromRange ?? 0;
        allottedQPS.toRange = allottedQPSResMaterialBased.toRange ?? 0;
        allottedQPS.discount = (allottedQPSResMaterialBased.discount ?? 0.0) +
            (allottedQPSResOilBased.discount ?? 0.0);
        allottedQPS.skuType = allottedQPSResMaterialBased.skuType ?? 0;
      }*/
    }

    if (selectedEditIndex != -1 && saudaOrders.value.isNotEmpty) {
      double? discountPremiumCalculatedAmount = 0;

      if (isFromAlert) {
        if (pSelectedDiscountType == 1) {
          discountPremiumCalculatedAmount =
              (saudaOrders.value[selectedEditIndex].quotedPrice ?? 0) -
                  (saudaOrders.value[selectedEditIndex].discountAmountPerCase ??
                      0);
        } else if (pSelectedDiscountType == 2) {
          discountPremiumCalculatedAmount =
              (saudaOrders.value[selectedEditIndex].quotedPrice ?? 0) +
                  (saudaOrders.value[selectedEditIndex].discountAmountPerCase ??
                      0);
        }
      } else {
        if (widget.selectedDiscountType == 1) {
          discountPremiumCalculatedAmount =
              (saudaOrders.value[selectedEditIndex].quotedPrice ?? 0) -
                  (saudaOrders.value[selectedEditIndex].discountAmountPerCase ??
                      0);
        } else if (widget.selectedDiscountType == 2) {
          discountPremiumCalculatedAmount =
              (saudaOrders.value[selectedEditIndex].quotedPrice ?? 0) +
                  (saudaOrders.value[selectedEditIndex].discountAmountPerCase ??
                      0);
        }
      }

      saudaOrders.value[selectedEditIndex].qpsDiscount =
      (allottedQPS.discount ?? 0);
      saudaOrders.value[selectedEditIndex].finalRate =
      ((discountPremiumCalculatedAmount - (allottedQPS.discount ?? 0)) * qty);
    } else {}
    return allottedQPS;
  }

  void showConfirmDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors
          .white}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
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
      content: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Icon(Icons.error_outlined, size: 54,
                        color: Constant.homeBoxPendingOrange),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Confirm Sauda Request?', style: TextStyle(
                        fontSize: Constant.fontSize20,
                        fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        'Are you sure you want to confirm sauda request?',
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
                buttonName: "Yes,Confirm",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  saveUIEnteredSAUDA();
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
                FocusManager.instance.primaryFocus?.unfocus();
                _scrollDown();
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: screenWidth / 3.2,
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
                saveAlertEnteredSAUDA();
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

    selectedRate = (selectedSKU ?? SKUPricing()).price!;
    finalPrice = selectedRate;

    double qty = 0;
    // Find the QPS discount.
    if (_quantitycontroller.text.isNotEmpty) {
      qty = double.parse(
          _quantitycontroller.text.isEmpty ? "0" : _quantitycontroller.text);
    }

    QPSResponseData allottedQPS = QPSResponseData();

    allottedQPS = calculateQPSDiscount(qty, isFromAlert: false);

    double discountValue = 0;
    if (_discountcontroller.text.isNotEmpty) {
      discountValue = double.parse(_discountcontroller.text);
    }

    if ((selectedSKU!.price ?? 0) > 0) {
      double qpsDiscountedValue = (selectedSKU!.price ?? 0) /*-
          (allottedQPS.discount ?? 0)*/
      ;
      if (widget.selectedDiscountType == 1) {
        finalPrice = qpsDiscountedValue - discountValue;
      } else if (widget.selectedDiscountType == 2) {
        finalPrice = qpsDiscountedValue + discountValue;
      }
    }

    finalRate = finalPrice * qty;
    rate = selectedRate * qty;

    setSelectedEditIndex();
    if (qty != 0) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(seconds: 2), () {
        validateAndAddItemToSAUDAList(isFromQPS: true,
            finalRateData: finalRate,
            qpsDiscountData: allottedQPS.discount);
      });
    } else if (qty == 0 && saudaOrders.value.isNotEmpty) {
      final updated = [...saudaOrders.value];
      updated.removeAt(selectedEditIndex);
      saudaOrders.value = updated;

      setSelectedEditIndex();
    }
    setState(() {});
  }

  setSelectedEditIndex() {
    if (saudaOrders.value.length == 1) {
      selectedEditIndex = 0;
    } else if (saudaOrders.value.isEmpty) {
      selectedEditIndex = -1;
    }
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors
          .white, bool? closeScreen = false}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
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

      content: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: getIcon(title),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(
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
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error" || title == "Information") {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SaudaBookedStatusScreen()),
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


  Future<void> showSuccessDlgSam(BuildContext context,
      String messageValue,
      String title, {
        bool? hideCancelBtn = false,
        RichText? successText,
        Color? titleColor = Colors.white,
        bool? closeScreen = false,
        List<Response>? essentialSkus,
      }) async {
    AlertDialog alert = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Color(0xFFF68C33),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(5.0),
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: successText ?? const SizedBox(),
            ),


            // Scrollable table
            // Inside your Column children:
            if (essentialSkus != null && essentialSkus.isNotEmpty)
              Builder(
                builder: (context) {
                  final allMappings = essentialSkus
                      .expand((sku) => sku.mandatorySkuMappingList ?? [])
                      .toList();
                  hasMandatorySkus = true;
                  final rowCount = allMappings.length;
                  final tableHeight = rowCount < 5
                      ? (60.0 + rowCount * 28.0)
                      : 200.0;
                  final bottomSpacing = rowCount < 5 ? 10.0 : 20.0;

                  return Column(
                    children: [
                      Container(
                        height: tableHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: rowCount < 5
                              ? Colors.white
                              : Colors.grey.shade300),
                        ),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: BorderSide(color: Colors.grey.shade300),
                              outside: BorderSide(color: Colors.grey.shade300),
                            ),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                            },
                            children: [
                              // Header row
                              const TableRow(
                                decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5)),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Mandatory SKU',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Percentage',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              // Data rows
                              ...allMappings.map((mapping) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 8.0),
                                      child: Text(
                                        mapping.mandatorySkuName ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        '${mapping
                                            .mandatoryBookingQuantityPercentage ??
                                            0}%',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: bottomSpacing),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CommonButton(
                  buttonName: "Done",
                  buttonNameSize: Constant.fontSize13,
                  buttonNameColor: Constant.pricbuttonTxtColor,
                  buttonColor: Constant.pricbuttonColor,
                  buttonHeight: 50,
                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                  buttonRadiusBL: Constant.pricbutRadiusBL,
                  buttonBorder: Colors.white,
                  buttonNameWeight: Constant.fontWeight500,
                  buttonFunction: () {
                    Navigator.pop(context);
                    if (closeScreen!) {
                      Navigator.pop(context);
                    }
                    if (title == "Error" || title == "Information") {
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (
                              context) => const SaudaBookedStatusScreen()),
                    );
                  }),
            )
          ],
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) => alert);
      },
    );
  }


  void showSuccessDlgOne(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors
          .white, bool? closeScreen = false}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
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

      content: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: getIcon(title),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(
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
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const SaudaBookedStatusScreen()),
                  // );
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

  double getTotalValue() {
    double total = 0;
    for (SaudaOrders o in saudaOrders.value) {
      total = total +
          (o.bidQuantity! * ((o.quotedPrice ?? 0) - (o.qpsDiscount ?? 0)));
    }
    return total;
  }

// Declare these as class-level variables (at the top of your State class)

  // SaudaOrders order = SaudaOrders();
  // Class-level variables

// Method for FROM date
  _selectFromDate(BuildContext context, bool popup) async {
    if (!popup) {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _selectedFromDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (selected != null) {
        setState(() {
          _selectedFromDate = selected;
          _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(
              selected, DateTimeUtils.DD_MM_YYYY_Format);
          if (saudaDetail.saudaValidityPeriod != null) {
            _selectedToDate =
                selected.add(Duration(days: saudaDetail.saudaValidityPeriod!));
            _todatecontroller.text = DateTimeUtils().dateToStringFormat(
                _selectedToDate!, DateTimeUtils.DD_MM_YYYY_Format);
          }

          // Update existing orders in the list
          if (saudaOrders.value.isNotEmpty) {
            for (var order in saudaOrders.value) {
              order.saudaValidFromDate =
                  DateTimeUtils.YYYY_MM_DD_Format.format(selected);
              if (_selectedToDate != null) {
                order.saudaValidToDate =
                    DateTimeUtils.YYYY_MM_DD_Format.format(_selectedToDate!);
              }
            }
          }
        });
      }
    } else {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _selectedPFromDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (selected != null) {
        setState(() {
          _selectedPFromDate = selected;
          _pfromdatecontroller.text = DateTimeUtils().dateToStringFormat(
              selected, DateTimeUtils.DD_MM_YYYY_Format);
          if (saudaDetail.saudaValidityPeriod != null) {
            _selectedPToDate =
                selected.add(Duration(days: saudaDetail.saudaValidityPeriod!));
            _ptodatecontroller.text = DateTimeUtils().dateToStringFormat(
                _selectedPToDate!, DateTimeUtils.DD_MM_YYYY_Format);
          }
        });
      }
    }
  }

// Method for TO date (if you have a separate date picker for "to date")
  _selectToDate(BuildContext context, bool popup) async {
    if (!popup) {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _selectedToDate ?? (_selectedFromDate ?? DateTime.now()),
          firstDate: _selectedFromDate ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (selected != null) {
        setState(() {
          _selectedToDate = selected;
          _todatecontroller.text = DateTimeUtils().dateToStringFormat(
              selected, DateTimeUtils.DD_MM_YYYY_Format);
        });
      }
    } else {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _selectedPToDate ??
              (_selectedPFromDate ?? DateTime.now()),
          firstDate: _selectedPFromDate ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (selected != null) {
        setState(() {
          _selectedPToDate = selected;
          _ptodatecontroller.text = DateTimeUtils().dateToStringFormat(
              selected, DateTimeUtils.DD_MM_YYYY_Format);
        });
      }
    }
  }

  void setDiscountLabel() {
    if (widget.selectedDiscountType == 1) {
      discountLabel =
          "Discount Amount (Max :" + itemMaxDiscount.toStringAsFixed(2) + ")";
    } else {
      discountLabel = "Premium";
    }
    setState(() {});
  }

  void setPDiscountLabel() {
    if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {
      _dialogKey.currentState!.setState(() {
        if (pSelectedDiscountType == 1) {
          String disc = "0.00";
          if (pSelectedSKU != null) {
            disc = pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
          }
          pDiscountLabel = "Discount Amount(Max :" + disc + ")";
        } else {
          pDiscountLabel = "Premium";
        }
      });
    }
  }

  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  Icon getIcon(String msg) {
    if (msg == "Error") {
      return Icon(Icons.error_outlined, size: 70, color: Colors.red);
    } else if (msg == "Success") {
      Icon(Icons.check_circle_sharp, size: 70, color: Colors.green);
    }
    return Icon(Icons.error_outlined, size: 70, color: Colors.orangeAccent);
  }

  void checkForEmptyData(String text) {
    //This logic is to show alert for empty data.
    bool isValuePresent = false;
    for (var sku in skuList) {
      if (sku.skuName.toString().toLowerCase().contains(text.toLowerCase())) {
        isValuePresent = true;
        break;
      } else {
        isValuePresent = false;
      }
    }
    if (!isValuePresent) {
      if (oldSkuText != text && text.isNotEmpty) {
        oldSkuText = text;
        showSuccessDlgOne(context, "Contact HO", "Contact HO",
            successText: "Please contact HO. Prices are not uploaded for the Material under the selected depot/plant.");
      }
    }
    //ends
  }

  setDiscountAndPremium() {
    ///This is to set the default type to discount.
    if (selectedSKU != null) {
      if (widget.selectedDiscountType == 1) {
        _discountcontroller.text =
            selectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
        itemMaxDiscount = selectedSKU!.employeeSkuDiscount!;
      } else {
        _discountcontroller.text =
            selectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
        itemMaxDiscount = 0;
      }
      setDiscountLabel();
    }
    _quantitycontroller.text = "";
    calculatePrice();

    ///ends
  }

  setAlertDiscountAndPremium() {
    if (pSelectedSKU != null) {
      if (pSelectedDiscountType == 1) {
        _pdiscountcontroller.text =
            pSelectedSKU!.employeeSkuDiscount!.toStringAsFixed(2);
      } else {
        _pdiscountcontroller.text =
            pSelectedSKU!.employeeSkuPremium!.toStringAsFixed(2);
      }
      itemMaxDiscount = pSelectedSKU!.employeeSkuDiscount!;
    }
    setPDiscountLabel();
    _pquantitycontroller.clear();
  }

  checkAlertQPSQtyListDiscount() {
    // qpsResModel.clear();
    // skuID.clear();
    List<SkuDetails> qpsReqModel = <SkuDetails>[];

    for (var d in saudaOrders.value) {
      qpsReqModel.add(SkuDetails(
          quantity: (d.bidQuantity ?? 0).toDouble(), skuId: d.skuId));
    }

    BlocProvider.of<NewSaudaBloc>(context).add(OnLoadQPSDiscountList(
        qpsReqModel: qpsReqModel,
        dealerId: (selectedDistributor ?? DistributorList()).id ??
            Constants.AUTH_USERID));
  }


  void checkAlertSkuMandatory(
      {bool forceShow = false, bool isAlertTriggered = false}) {
    _forceShowMandatoryDialog = forceShow;
    skuID.clear();
    for (var d in saudaOrders.value) {
      skuID.add(Sku(
        skuId: d.skuId!,
        oilTypeId: d.oilTypeId!,
        quantity: (d.bidQuantity ?? 0).toDouble(),
      ));
    }


    BlocProvider.of<NewSaudaBloc>(context).add(
        Constants
            .AUTH_ROLEID !=
            Constants.DEALER ?
        MandatorySkus(
          userId: Constants.AUTH_USERID,
          stateId: userDefaults.stateId!,
          oilTypeId: selectedOilType!
              .id!,
          dealerId: selectedDistributor!
              .id!,
          distributionChannelId: selectedDistrChannel!.id!,
          divisonId: selectedVertical!
              .id!,
          salesOrganizationId: selectedSalesOrg!
              .id!,
          skusId: skuID,
          plantId: selectedPlant!.id!,
        ) : MandatorySkus(
          userId: Constants.AUTH_USERID,
          stateId: userDefaults.stateId!,
          oilTypeId: 0,
          dealerId: Constants.AUTH_USERID,
          distributionChannelId: selectedSKU?.distributionChannelId ?? 0,
          divisonId: selectedSKU?.divisionId ?? 0,
          salesOrganizationId: selectedSKU?.salesOrganizationId ?? 0,
          skusId: skuID,
          plantId: selectedPlant!.id!,
        )
    );
  }

  saveAlertEnteredSAUDA({bool isFromQPS = false}) {
    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      if (pSelectedOilType == null) {
        showSuccessDlg(context, "Error", "Error",
            successText: "Select Oil Type from the list");
        return;
      }
    }
    if (pSelectedSKU == null) {
      showSuccessDlg(
          context, "Error", "Error", successText: "Select SKU from the list");
      return;
    }

    // if(_pdiscountcontroller.text.toString()==""){
    //   showSuccessDlg(context, "Error", "Error",successText: "Enter Discount Amount");
    //   return;
    // }
    if (_pquantitycontroller.text.toString() == "") {
      showSuccessDlg(context, "Error", "Error", successText: "Enter Quantity");
      return;
    }
    _essentialSkuIds = mandatorySkuMap
        .where((e) => e.essentialSkuId != null)
        .expand((e) => e.essentialSkuId!)
        .toSet();


    if (selectedEditIndex == -1) {
      double qty = double.parse(_pquantitycontroller.text) * pSelectedSKU!.caseToMetricTonValue!;
      SaudaOrders order = SaudaOrders();
      order.incoTerms = selectedIncoTerms!.name;
      order.incotermsId = selectedIncoTerms!.id;
      order.skuName = pSelectedSKU!.skuName;
      order.mtQtyVal =double.parse(qty.toStringAsFixed(3));
      order.skuId = pSelectedSKU!.skuId;
      order.oilTypeId = pSelectedOilType != null ? pSelectedOilType!.id : 0;
      order.plantId = selectedPlant!.id;
      order.bidQuantity = int.parse(_pquantitycontroller.text.toString());
      order.discountTypeId = pSelectedDiscountType;
      order.plantDepot = selectedPlant!.name;
      order.pricingId = pSelectedSKU!.pricingId;
      order.uomName = pSelectedSKU!.uom;
      if (_fromdatecontroller.text.toString() != "") {
        order.saudaValidFromDate = DateTimeUtils().dateToServerToDateFormat(
            _fromdatecontroller.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format);
      } else {
        order.saudaValidFromDate = "";
      }
      if (_todatecontroller.text.toString() != "") {
        order.saudaValidToDate = DateTimeUtils().dateToServerToDateFormat(
            _todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format);
      } else {
        order.saudaValidToDate = "";
      }
      order.discountAmountPerCase = 0;
      order.discountAmount = 0;
      if (_pdiscountcontroller.text.isNotEmpty) {
        order.discountAmountPerCase =
            double.parse(_pdiscountcontroller.text.toString());
      }
      double finalPrice = 0;
      if (pSelectedSKU!.price! > 0) {
        if (pSelectedDiscountType == 1) {
          finalPrice = pSelectedSKU!.price! - order.discountAmountPerCase!;
        } else {
          finalPrice = pSelectedSKU!.price! + order.discountAmountPerCase!;
        }
      }
      if (_pdiscountcontroller.text.toString() != "") {
        order.discountAmount =
            double.parse(_pdiscountcontroller.text.toString()) *
                order.bidQuantity!;
      }
      order.quotedPrice = finalPrice;
      order.statusId = 1;
      order.qpsDiscount = (pSelectedSKU?.qpsDiscount ?? 0);
      order.finalRate = (pSelectedSKU?.finalRate ?? 0);
      order.qpsResModel = qpsResModel;
      order.isMandatorySku = hasMandatorySkus;
      order.finalBaseRate = pSelectedSKU!.price ?? 0;
      order.discountId =
      pSelectedDiscountType == 0 ? pSelectedSKU?.employeeSkuDiscount?.toInt() ??
          0 : pSelectedSKU?.employeeSkuPremium?.toInt() ?? 0;
      saudaOrders.value.add(order);
    }
    else {
      double qty = double.parse(_pquantitycontroller.text) * pSelectedSKU!.caseToMetricTonValue!;
      SaudaOrders order = saudaOrders.value[selectedEditIndex];
      order.incoTerms = selectedIncoTerms!.name;
      order.incotermsId = selectedIncoTerms!.id;
      order.skuName = pSelectedSKU!.skuName;
      order.mtQtyVal = double.parse(qty.toStringAsFixed(3));
      order.skuId = pSelectedSKU!.skuId;
      order.oilTypeId = pSelectedOilType != null ? pSelectedOilType!.id : 0;
      order.plantId = selectedPlant!.id;
      order.bidQuantity = int.parse(_pquantitycontroller.text.toString());
      order.discountTypeId = pSelectedDiscountType;
      order.plantDepot = selectedPlant!.name;
      order.pricingId = pSelectedSKU!.pricingId;
      order.uomName = pSelectedSKU!.uom;
      if (_pfromdatecontroller.text.toString() != "") {
        order.saudaValidFromDate = DateTimeUtils().dateToServerToDateFormat(
            _pfromdatecontroller.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format);
      } else {
        order.saudaValidFromDate = "";
      }
      if (_ptodatecontroller.text.toString() != "") {
        order.saudaValidToDate = DateTimeUtils().dateToServerToDateFormat(
            _ptodatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
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
          finalPrice = pSelectedSKU!.price! - order.discountAmountPerCase!;
        } else {
          finalPrice = pSelectedSKU!.price! + order.discountAmountPerCase!;
        }
      }
      if (_pdiscountcontroller.text.isNotEmpty) {
        order.discountAmount =
            double.parse(_pdiscountcontroller.text.toString()) *
                order.bidQuantity!;
      }
      order.quotedPrice = finalPrice;
      order.statusId = 1;
      //cant assign here
      // order.qpsDiscount = (allottedQPS.discount??0).toString();

      order.qpsDiscount = saudaOrders.value[selectedEditIndex].qpsDiscount ?? 0;
      order.finalRate = (pSelectedSKU?.finalRate ?? 0);
      order.qpsResModel = qpsResModel;
      order.finalBaseRate = pSelectedSKU!.price ?? 0;
      order.isManuallyEdited = true;
      order.isMandatorySku = hasMandatorySkus;
      order.discountId =
      pSelectedDiscountType == 0 ? pSelectedSKU?.employeeSkuDiscount?.toInt() ??
          0 : pSelectedSKU?.employeeSkuPremium?.toInt() ?? 0;
      saudaOrders.value[selectedEditIndex] = order;
    }
    checkAlertQPSQtyListDiscount();

    SaudaOrders? currentOrder;
    if (selectedEditIndex == -1 && saudaOrders.value.isNotEmpty) {
      currentOrder = saudaOrders.value.last;
    } else if (selectedEditIndex >= 0 &&
        selectedEditIndex < saudaOrders.value.length) {
      currentOrder = saudaOrders.value[selectedEditIndex];
    }

    if (currentOrder != null &&
        _essentialSkuIds!.contains(currentOrder.skuId)) {
      checkAlertSkuMandatory();
      hasMandatorySkus = true;
    } else if (_essentialSkuIds!.isEmpty) {
      checkAlertSkuMandatory();
    }

    Navigator.pop(context);
    FocusManager.instance.primaryFocus?.unfocus();

    _scrollDown();
    setState(() {});
    if (!isFromQPS) {
      // sendCurrentSAUDAList();
    }
  }

  void saveUIEnteredSAUDA() {
    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      if (selectedSalesOrg == null) {
        showSuccessDlg(context, "Error", "Error",
            successText: "Select Sales Organization from the list",
            closeScreen: true);
        return;
      }
      if (selectedDistrChannel == null) {
        showSuccessDlg(context, "Error", "Error",
            successText: "Select Distribution Channel from the list",
            closeScreen: true);
        return;
      }
      if (selectedVertical == null) {
        showSuccessDlg(context, "Error", "Error",
            successText: "Select Division from the list", closeScreen: true);
        return;
      }
      if (selectedDistributor == null) {
        showSuccessDlg(context, "Error", "Error",
            successText: "Select Distributor from the list", closeScreen: true);
        return;
      }
    }
    if (selectedIncoTerms == null) {
      showSuccessDlg(context, "Error", "Error",
          successText: "Select Incoterms from the list");
      return;
    }
    if (selectedPlant == null) {
      showSuccessDlg(
          context, "Error", "Error", successText: "Select Plant from the list");
      return;
    }


    if (saudaOrders.value.isEmpty) {
      Navigator.pop(context);
      showSuccessDlg(
        context,
        "Error",
        "Error",
        successText: "Add at least one SKU before saving",
      );
      return;
    }


    final NewSaudaRequest request = NewSaudaRequest();

    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      request.salesOrganizationId = selectedSKU?.salesOrganizationId ?? 0;
      request.distributionChannelId = selectedSKU?.distributionChannelId ?? 0;
      request.divisionId = selectedSKU?.divisionId ?? 0;
    } else {
      request.salesOrganizationId = selectedSalesOrg?.id ?? 0;
      request.distributionChannelId = selectedDistrChannel?.id ?? 0;
      request.divisionId = selectedVertical?.id ?? 0;
    }

    request.isCrossAndUpsellContract = hasMandatorySkus;
    request.dealerId = (Constants.AUTH_ROLEID == Constants.DEALER)
        ? Constants.AUTH_USERID
        : (selectedDistributor?.id ?? 0);
    request.bDOId = (Constants.AUTH_ROLEID == Constants.ZHMANAGER)
        ? (selectedBdo?.id ?? 0)
        : Constants.AUTH_USERID;
    request.loginUserId = Constants.AUTH_USERID;
    request.saudaBookingTypeId =
        selectedDistributor?.saudaBookingTypeId ?? 1;
    request.saudaType = widget.selectedSaudaType;
    request.biddingDate = DateTimeUtils().dateToStringFormat(
        DateTime.now(),
        DateTimeUtils.YYYY_MM_DD_Format);
    request.brokerId = selectedBroker?.id ?? 0;


    request.saudaOrders = List<SaudaOrders>.from(saudaOrders.value);


    BlocProvider.of<NewSaudaBloc>(context).add(SaveSauda(request: request));
    Navigator.pop(context);
  }

  void validateAndAddItemToSAUDAList(
      {bool isFromQPS = false, double? finalRateData = 0.0, double? qpsDiscountData = 0.0}) {
    if (selectedIncoTerms == null) {
      showSuccessDlg(context, "Error", "Error",
          successText: "Select Incoterms from the list");
      return;
    }
    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      if (selectedOilType == null) {
        showSuccessDlg(context, "Error", "Error",
            successText: "Select Oil Type from the list");
        return;
      }
    }
    if (selectedPlant == null) {
      showSuccessDlg(
          context, "Error", "Error", successText: "Select Plant from the list");
      return;
    }
    if (selectedSKU == null) {
      showSuccessDlg(
          context, "Error", "Error", successText: "Select SKU from the list");
      return;
    }
    // if(_discountcontroller.text.toString()==""){
    //   showSuccessDlg(context, "Error", "Error",successText: "Enter Discount Amount");
    //   return;
    // }
    if (_quantitycontroller.text.isEmpty) {
      showSuccessDlg(context, "Error", "Error", successText: "Enter Quantity");
      return;
    }
    // At the top of your State class with other variables


// In your method:
    if (saudaOrders.value.isEmpty) {
      double qty = double.parse(_quantitycontroller.text) * selectedSKU!.caseToMetricTonValue!;
      SaudaOrders order = SaudaOrders();
      order.incoTerms = selectedIncoTerms!.name;
      order.incotermsId = selectedIncoTerms!.id;
      order.skuName = selectedSKU!.skuName;
      order.mtQtyVal = double.parse(qty.toStringAsFixed(3));
      order.skuId = selectedSKU!.skuId;
      order.oilTypeId = selectedOilType != null ? selectedOilType!.id : 0;
      order.plantId = selectedPlant!.id;
      order.bidQuantity = int.parse(
          _quantitycontroller.text.isEmpty ? "0" : _quantitycontroller.text);
      order.discountTypeId = widget.selectedDiscountType;
      order.plantDepot = selectedPlant!.name;
      order.pricingId = selectedSKU!.pricingId;
      order.uomName = selectedSKU!.uom;

      // Use the stored DateTime variables instead of parsing text
      order.saudaValidFromDate = _selectedFromDate != null
          ? DateTimeUtils.YYYY_MM_DD_Format.format(_selectedFromDate!)
          : DateTimeUtils.YYYY_MM_DD_Format.format(DateTime.now());

      order.saudaValidToDate = DateTimeUtils().dateToServerToDateFormat(
          _todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
          DateTimeUtils.YYYY_MM_DD_Format);

      order.discountAmountPerCase = 0;
      order.discountAmount = 0;
      if (_discountcontroller.text.toString() != "") {
        order.discountAmountPerCase =
            double.parse(_discountcontroller.text.toString());
      }
      double finalPrice = 0;
      if (selectedSKU!.price! > 0) {
        if (widget.selectedDiscountType == 1) {
          finalPrice = selectedSKU!.price! - order.discountAmountPerCase!;
        } else {
          finalPrice = selectedSKU!.price! + order.discountAmountPerCase!;
        }
      }
      if (_discountcontroller.text.toString() != "") {
        order.discountAmount =
            double.parse(_discountcontroller.text.toString()) *
                order.bidQuantity!;
      }
      order.quotedPrice = finalPrice;
      order.statusId = 1;
      order.qpsDiscount = qpsDiscountData ?? 0;
      order.finalRate = finalRateData;
      order.qpsResModel = qpsResModel;
      order.finalBaseRate = selectedSKU!.price ?? 0;
      order.discountId =
      pSelectedDiscountType == 0 ? pSelectedSKU?.employeeSkuDiscount?.toInt() ??
          0 : pSelectedSKU?.employeeSkuPremium?.toInt() ?? 0;
      saudaOrders.value.add(order);
      setState(() {});
    }
    else if (isFromQPS && saudaOrders.value.isNotEmpty) {
      SaudaOrders order = saudaOrders.value[selectedEditIndex];

      double qty = double.parse(_quantitycontroller.text) * selectedSKU!.caseToMetricTonValue!;

      order.incoTerms = selectedIncoTerms!.name;
      order.incotermsId = selectedIncoTerms!.id;
      order.skuName = selectedSKU!.skuName;
      order.mtQtyVal = double.parse(qty.toStringAsFixed(3));
      order.skuId = selectedSKU!.skuId;
      order.oilTypeId = selectedOilType != null ? selectedOilType!.id : 0;
      order.plantId = selectedPlant!.id;
      order.bidQuantity = int.parse(
          _quantitycontroller.text.isEmpty ? "0" : _quantitycontroller.text);
      order.discountTypeId = widget.selectedDiscountType;
      order.plantDepot = selectedPlant!.name;
      order.pricingId = selectedSKU!.pricingId;
      order.uomName = selectedSKU!.uom;

      // Use the stored DateTime variables instead of parsing text
      order.saudaValidFromDate = _selectedFromDate != null
          ? DateTimeUtils.YYYY_MM_DD_Format.format(_selectedFromDate!)
          : DateTimeUtils.YYYY_MM_DD_Format.format(DateTime.now());

      order.saudaValidToDate = DateTimeUtils().dateToServerToDateFormat(
          _todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format,
          DateTimeUtils.YYYY_MM_DD_Format);

      order.discountAmountPerCase = 0;
      order.discountAmount = 0;
      if (_discountcontroller.text.toString() != "") {
        order.discountAmountPerCase =
            double.parse(_discountcontroller.text.toString());
      }
      double finalPrice = 0;
      if (selectedSKU!.price! > 0) {
        if (widget.selectedDiscountType == 1) {
          finalPrice = selectedSKU!.price! - order.discountAmountPerCase!;
        } else {
          finalPrice = selectedSKU!.price! + order.discountAmountPerCase!;
        }
      }
      if (_discountcontroller.text.toString() != "") {
        order.discountAmount =
            double.parse(_discountcontroller.text.toString()) *
                order.bidQuantity!;
      }
      order.quotedPrice = finalPrice;
      order.statusId = 1;
      order.qpsDiscount = qpsDiscountData ?? 0;
      order.finalRate = finalRateData;
      order.qpsResModel = qpsResModel;
      order.finalBaseRate = selectedSKU!.price ?? 0;
      order.discountId =
      pSelectedDiscountType == 0 ? pSelectedSKU?.employeeSkuDiscount?.toInt() ??
          0 : pSelectedSKU?.employeeSkuPremium?.toInt() ?? 0;
      saudaOrders.value[selectedEditIndex] = order;
      selectedEditIndex = -1;
      setState(() {});
    }

    itemRatePopup = 0;
    pSelectedSKU = null;
    pSelectedOilType = null;
    pSelectedDiscountType = 0;
    _pdiscountcontroller.text = "";
    _pquantitycontroller.text = "";
    selectedEditIndex = -1;
    if (!isFromQPS) {
      showCustomAlertDialog(
          context, contBody(), 'Add Sauda', dialogActionButton(),
          hideCancelBtn: true);
    }
  }

  void processTheQPSDiscountLogic() {}
}
