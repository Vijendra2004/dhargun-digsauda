import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/CitiesList.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/oil_package_type_id.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/discount/bloc/bloc.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/new_sauda_bloc.dart';
import 'package:adaniwilmar/widget/common_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/bdo_list_response.dart';
import '../../models/daily_rate_response.dart';
import '../../models/dealer_response.dart';
import '../../models/geography_discount_list.dart';
import '../../models/geography_discount_request.dart';
import '../../models/oil_package_types.dart';
import '../../models/state_response.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/new_sauda_state.dart' as NewSaudaState;
import '../../models/zone_response.dart';
import '../../models/zone_state_cities_response.dart';
import '../../utils/constant.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/autocomplete/autocompleter.dart';
import '../../widget/border_bottom.dart';
import '../../widget/common-textfield.dart';
import '../../widget/common_button.dart';
import '../../widget/common_text.dart';
import '../../widget/curve_outer_box.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../support/bloc/support_bloc.dart';
import '../support/bloc/support_event.dart';
import 'bloc/discount_bloc.dart';
import 'bloc/discount_event.dart';
import 'bloc/discount_state.dart';
import 'geography_discount.dart';

class CreateGeography extends StatelessWidget {
  bool isUpdate = false;
  int id;
  List<int> materialIds;
  List<int> zoneIds;
  List<int> stateIds;
  int oilTypeId;
  String packGroupId;
  int packTypeId;
  int salesOrganizationId;
  int distributionChannelId;
  int divisionId;
  String skuName;
  int oilPackageTypeId;
  List<CitiesList> cities;
  String discount;
  String discountReason;
  String fromDate;
  String toDate;
  bool isActive;

  CreateGeography(
      {required this.isUpdate,
      required this.id,
      required this.materialIds,
      required this.zoneIds,
      required this.stateIds,
      required this.oilTypeId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisionId,
        required this.oilPackageTypeId,
      required this.packGroupId,
        required this.packTypeId,
      required this.cities,
        required this.isActive,
        required this.skuName,
      required this.discount,
      required this.discountReason,
      required this.fromDate,
      required this.toDate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()
        ..add(LoadNewSupportScreen(userId: Constants.AUTH_USERID)),
      child: GeographyDiscount(
          isUpdate: isUpdate,
          id: id,
          materialIds: materialIds,
          zoneIds: zoneIds,
          stateIds: stateIds,
          oilTypeId: oilTypeId,
          packGroupId: packGroupId,
          packTypeId: packTypeId,
          cities: cities,
          skuName: skuName,
          discount: discount,
          isActive: isActive,
          salesOrganizationId: salesOrganizationId,
          distributionChannelId: distributionChannelId,
          divisionId: divisionId,
          oilPackageTypeId: oilPackageTypeId,
          discountReason: discountReason,
          fromDate: fromDate,
          toDate: toDate),
    );
  }
}

class GeographyDiscount extends StatefulWidget {
  bool isUpdate = false;
  int id;
  List<int> materialIds;
  List<int> zoneIds;
  List<int> stateIds;
  int oilTypeId;
  String packGroupId;
  int packTypeId;
  List<CitiesList> cities;
  String discount;
  String skuName;
  int salesOrganizationId;
  int distributionChannelId;
  int divisionId;
  int oilPackageTypeId;
  String discountReason;
  String fromDate;
  String toDate;
  bool isActive;

  GeographyDiscount(
      {required this.isUpdate,
      required this.id,
      required this.materialIds,
      required this.zoneIds,
      required this.stateIds,
      required this.oilTypeId,
      required this.packGroupId,
        required this.packTypeId,
      required this.cities,
        required this.isActive,
      required this.discount,
        required this.skuName,
      required this.discountReason,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisionId,
        required this.oilPackageTypeId,
      required this.fromDate,
      required this.toDate,
      Key? key})
      : super(key: key);

  @override
  State<GeographyDiscount> createState() => _GeographyDiscountState();
}

class _GeographyDiscountState extends State<GeographyDiscount> {
  List<DistributorList> distributorList = [];
  bool _checkboxValue = false;
  bool _isActive = false;
  List<Vertical> verticals = [];
  bool selectAll = false;
  OilType? selectedOilType;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Vertical? selectedVertical;
  List<ActiveStateResponse> stateList = [];
  List<CityTerritory> cityTerritoryList = [];
  List<ActiveZone> zoneList = [];
  List<BdoList> materialList = [];
  OilType? pSelectedOilType;
  DistributorList? selectedDistributor;
  List<BdoList> selectedMaterials = [];
  List<ActiveStateResponse> selectedState = [];
  List<Cities> selectedCityTerritory = [];
  List<ActiveZone> selectedZone = [];
  PlanDepotList? selectedPlant;
  List<SKUPricing> popupSkuList = [];
  List<int> selectedMaterialIds = [];
  List<int> selectedStateIds = [];
  List<int> selectedZoneIds = [];
  List<SalesOrganization> salesOrgList = [];
  List<OilType> oilTypes = [];
  TextEditingController? _distributorcontroller;
  TextEditingController? _oiltypecontroller;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  BdoList? selectedEmployee;
  List<BdoList>? selectedBdos = [];
  List<int> dealerIds = [];
  ActiveZone? selectedZoneState;
  SalesOrganization? selectedSalesOrg;
  List<Category>? oilPackageTypes;
  Category? selectedOilPackageTypes;
  List<OilPackGroupTypeId>? oilPackageTypeIds;
  OilPackGroupTypeId? selectedOilPackageTypeId;
  Color? borderColor = Constant.pricDisBocolor;
  DistributionChannel? selectedDistrChannel;
  TextEditingController? _popupoiltypecontroller;
  List<CityTerritory> _searchResult = [];
  List<DistributionChannel> distrChannels = [];
  static String _displayStringForOilTypeOption(OilType option) => option.name!;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Color(0xFFA1A1A1);
  String appBarTitle = "Create Geography Discount";
  DefaultInputResponse userDefaults = DefaultInputResponse(
      salesOrganizationId: 0,
      distrinbutionChannelId: 0,
      divisionId: 0,
      stateId: 0,
      plantId: 0);
  late TextEditingController _reasoncontroller = TextEditingController();
  late TextEditingController _dicountcontroller = TextEditingController();
  late TextEditingController _fromdatecontroller = TextEditingController();
  late TextEditingController _todatecontroller = TextEditingController();
  late TextEditingController _materialController = TextEditingController();
  late TextEditingController _zoneController = TextEditingController();
  late TextEditingController _stateController = TextEditingController();
  late TextEditingController _cityTerritoryController = TextEditingController();
  TextEditingController _searchController = new TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();
  ProgressBarHandler? _handler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();

    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 00);

    _todatecontroller.text =
        DateTimeUtils().dateToStringFormat(
          endOfDay,
          DateTimeUtils.DD_MM_YYYY_HH_MM_24_format,
        );
  }

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


    return BlocProvider(
      create: (context) => CreateDiscountBloc()
        // ..add(LoadPackGroupList(userId: Constants.AUTH_USERID))
        ..add(LoadMaterialByOilPkgType(oilTypeIds: widget.oilTypeId, packGroupIds: int.parse(widget.packGroupId), oilPkgTypeId: widget.packTypeId))
        ..add(LoadZone(userId: Constants.AUTH_USERID))
        ..add(LoadOilPackageType())
        ..add(LoadOilPackageTypeId())
        ..add(LoadSalesOrganization(saudaBookingTypeId:0,id: 0)
        ),
      child: BlocListener<CreateDiscountBloc, CreateDiscountState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
          if (state is OnLoadMaterial) {
            selectedMaterials = [];
            materialList = state.metrialList;
            if (widget.isUpdate) {
                _isActive = widget.isActive;
              _checkboxValue = true;
              selectedMaterialIds = widget.materialIds;
              loadMaterial();
              BlocProvider.of<CreateDiscountBloc>(context)
                  .add(LoadZone(userId: Constants.AUTH_USERID));
            }
          }

          if (state is OnLoadZone) {
            GMLogger.v(state.props);
            selectedZone = [];
            _zoneController.text = "Select Zone";
            zoneList = state.zoneList;
            if (widget.isUpdate) {
              loadZone();
              BlocProvider.of<CreateDiscountBloc>(context)
                  .add(LoadState(zoneId: widget.zoneIds));
            }
          }

          if (state is OnLoadState) {
            GMLogger.v(state.props);
            selectedState = [];
            _stateController.text = "Select State";
            stateList = state.stateList;
            if (widget.isUpdate) {
              loadState();
              BlocProvider.of<CreateDiscountBloc>(context)
                  .add(LoadCityTerritory(cityTerritoryId: widget.stateIds));
            }
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
                BlocProvider.of<CreateDiscountBloc>(context).add(
                    LoadDistributionChannel(id: selectedSalesOrg!.id!));
              }
              userDefaults.salesOrganizationId = 0;
            }


            if (widget.isUpdate && widget.salesOrganizationId != null) {
              final matched = salesOrgList.where(
                    (element) => element.id == widget.salesOrganizationId,
              );

              if (matched.isNotEmpty) {
                selectedSalesOrg = matched.first;
              } else {
                selectedSalesOrg = SalesOrganization(
                  id: widget.salesOrganizationId,
                  salesOrganizationName: 'Current selection',
                );
                salesOrgList.insert(0, selectedSalesOrg!);
              }

              BlocProvider.of<CreateDiscountBloc>(context).add(
                LoadDistributionChannel(id: selectedSalesOrg!.id!),
              );
            }

            setState(() {});
          }
          if (state is OnLoadOilPackage) {
            oilPackageTypes = state.oilPackageTypeList;
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
                BlocProvider.of<CreateDiscountBloc>(context).add(
                    LoadDistributionChannel(id: selectedSalesOrg!.id!));
              }
              userDefaults.salesOrganizationId = 0;
            }
            setState(() {});
          }

          if (state is OnLoadOilPackageTypeId) {
            oilPackageTypeIds = state.oilPackageTypeId;
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
                BlocProvider.of<CreateDiscountBloc>(context).add(
                    LoadDistributionChannel(id: selectedSalesOrg!.id!));
              }
              userDefaults.salesOrganizationId = 0;
            }
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            verticals = state.verticalList;
            selectedVertical = null;
            pSelectedOilType = null;
            selectedOilType = null;
            selectedDistributor = null;

            if (userDefaults.divisionId! > 0) {
              if (verticals
                  .where((element) => element.id == userDefaults.divisionId!)
                  .isNotEmpty) {
                selectedVertical = verticals
                    .where((element) => element.id == userDefaults.divisionId!)
                    .first;
              }
              if (selectedVertical != null) {
                BlocProvider.of<CreateDiscountBloc>(context).add(
                  LoadOilType(
                    userId: Constants.AUTH_USERID,
                    salesOrganizationId: selectedSalesOrg!.id!,
                    distributionChannelId: selectedDistrChannel!.id!,
                    divisonId: selectedVertical!.id!,
                  ),
                );
              }
              userDefaults.divisionId = 0;
            }

            if (widget.isUpdate && widget.divisionId != null) {
              final matched = verticals.where(
                    (element) => element.id == widget.divisionId,
              );

              if (matched.isNotEmpty) {
                selectedVertical = matched.first;
              } else {
                selectedVertical = Vertical(
                  id: widget.divisionId,
                );
                verticals.insert(0, selectedVertical!);
              }

              BlocProvider.of<CreateDiscountBloc>(context).add(
                LoadOilType(
                  userId: Constants.AUTH_USERID,
                  salesOrganizationId: selectedSalesOrg!.id!,
                  distributionChannelId: selectedDistrChannel!.id!,
                  divisonId: selectedVertical!.id!,
                ),
              );
            }

            setState(() {});
          }

          if (state is OnLoadDistributionChannel) {
            distrChannels = state.distributionChannel;
            selectedDistrChannel = null;

            if (userDefaults.distrinbutionChannelId! > 0) {
              final matched = distrChannels.where(
                    (element) => element.id == userDefaults.distrinbutionChannelId!,
              );

              if (matched.isNotEmpty) {
                selectedDistrChannel = matched.first;
              }

              if (selectedDistrChannel != null) {
                BlocProvider.of<CreateDiscountBloc>(context).add(
                  LoadVerticalList(distributionId: selectedDistrChannel!.id!),
                );
              }

              userDefaults.distrinbutionChannelId = 0;
            }

            if (widget.isUpdate && widget.distributionChannelId != null) {
              final matched = distrChannels.where(
                    (element) => element.id == widget.distributionChannelId,
              );

              if (matched.isNotEmpty) {
                selectedDistrChannel = matched.first;
              } else {
                selectedDistrChannel = DistributionChannel(
                  id: widget.distributionChannelId,
                  distributionChannelName: 'Current selection',
                );
                distrChannels.insert(0, selectedDistrChannel!);
              }

              BlocProvider.of<CreateDiscountBloc>(context).add(
                LoadVerticalList(distributionId: selectedDistrChannel!.id!),
              );
            }

            setState(() {});
          }

          if (state is OnLoadOilType) {
            pSelectedOilType = null;
            selectedOilType = null;
            oilTypes = state.oilTypeList;
            setState(() {});
          }
          if (state is OnCityTerritory) {
            GMLogger.v(state.props);
            selectedCityTerritory = [];
            _cityTerritoryController.text = "Show Cities and district";
            cityTerritoryList = state.cityTerritoryList;
            if (widget.isUpdate) {
              loadCityTerritory();
            }
          }

          if (state is OnSaveUserDiscount) {
            showSuccessDlg(context, "Request Confirmed", "Success",
                successText: "Geography Discount created");
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
        },
        child: SafeArea(
            child: BlocBuilder<CreateDiscountBloc, CreateDiscountState>(
          builder: (context, state) {
            return Scaffold(
              primary: false,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                  title: widget.isUpdate
                      ? "Update Geography Discount"
                      : appBarTitle,
                  backArrow: true),
              body: Stack(
                // clipBehavior: Clip.none,
                clipBehavior: Clip.hardEdge,
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
                          child: Column(
                            children: [
                              CurveOuterBox(
                                boxofWidget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: true,
                                      child: Column(children: [
                                        Visibility(
                                            visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                            child: StatefulBuilder(
                                                builder: (
                                                    BuildContext context,
                                                    StateSetter setState) {
                                                  return SizedBox(
                                                    width: double.infinity,
                                                    child: CommonDropdownButtonFormField<SalesOrganization>(
                                                      label: "Sales Organization",
                                                      value: selectedSalesOrg,
                                                      items: salesOrgList.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value.salesOrganizationName ?? ""),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if (value == null) return;
                                                        setState(() {
                                                          selectedSalesOrg = value;
                                                        });
                                                        context.read<CreateDiscountBloc>().add(
                                                          LoadDistributionChannel(id: value.id!),
                                                        );
                                                      },
                                                    )
                                                  );
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
                                                      child: CommonDropdownButtonFormField<DistributionChannel>(
                                                        label: "Distribution Channel",
                                                        value: selectedDistrChannel,
                                                        items: distrChannels.map((value) {
                                                          return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(value.distributionChannelName ?? ""),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedDistrChannel = value;
                                                          });
                                                          if(selectedDistrChannel!=null){
                                                            BlocProvider.of<
                                                                CreateDiscountBloc>(
                                                                context)
                                                                .add(LoadVerticalList(
                                                                distributionId:
                                                                selectedDistrChannel!
                                                                    .id!));
                                                          }
                                                        },
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
                                                      child: CommonDropdownButtonFormField<Vertical>(
                                                        value: selectedVertical,
                                                        label: "Division",
                                                        onChanged: (Vertical? newValue) {
                                                          setState(() {
                                                            selectedVertical = newValue!;
                                                          });
                                                          BlocProvider.of<CreateDiscountBloc>(context).add(
                                                              LoadOilType(
                                                                  userId: Constants.AUTH_USERID,
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
                                                })),
                                        SizedBox(height: 16,),
                                        Visibility(
                                            visible: Constants.AUTH_ROLEID != Constants.DEALER,
                                            child:
                                            CustomAutocomplete<OilType>(
                                              fieldViewBuilder: (
                                                  BuildContext context,
                                                  TextEditingController fieldTextEditingController,
                                                  FocusNode fieldFocusNode,
                                                  VoidCallback onFieldSubmitted,
                                                  ) {
                                                _popupoiltypecontroller = fieldTextEditingController;

                                                // Map widget.oilTypeId to pSelectedOilType only if pSelectedOilType is not already set
                                                if (widget.oilTypeId != null && widget.oilTypeId != 0 && pSelectedOilType == null) {
                                                  pSelectedOilType = oilTypes.firstWhere(
                                                        (oilType) => oilType.id == widget.oilTypeId,
                                                    orElse: () => OilType(), // Provide a default OilType or handle null case
                                                  );
                                                }

                                                // Set value from pSelectedOilType if present
                                                if (pSelectedOilType != null && pSelectedOilType!.name != null) {
                                                  _popupoiltypecontroller!.text = pSelectedOilType!.name!;
                                                }

                                                return TextField(
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight: Radius.circular(borderRadiusTLBR),
                                                      ),
                                                      borderSide: BorderSide(color: borderColor!, width: 1.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight: Radius.circular(borderRadiusTLBR),
                                                      ),
                                                      borderSide: BorderSide(color: borderColor!, width: 1.0),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                        bottomRight: Radius.circular(borderRadiusTLBR),
                                                      ),
                                                      borderSide: BorderSide(color: borderColor!, width: 1.0),
                                                    ),
                                                    filled: true,
                                                    labelText: "Oil Type",
                                                    labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                                    fillColor: fillColor,
                                                  ),
                                                  controller: fieldTextEditingController,
                                                  focusNode: fieldFocusNode,
                                                );
                                              },
                                              optionsMaxWidth: MediaQuery.of(context).size.width * 0.74,
                                              displayStringForOption: _displayStringForOilTypeOption,
                                              optionsBuilder: (TextEditingValue textEditingValue) {
                                                if (textEditingValue.text == '') {
                                                  return const Iterable<OilType>.empty();
                                                }
                                                return oilTypes.where((OilType option) {
                                                  return option.name.toString().toLowerCase().contains(
                                                    textEditingValue.text.toLowerCase(),
                                                  );
                                                });
                                              },
                                              onSelected: (OilType selection) async {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                pSelectedOilType = selection;
                                                setState(() {});
                                              },
                                            )
                                        ),
                                        SizedBox(
                                            height: 16),

                                        Visibility(
                                            visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                            child: StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                // Set the initial value if not already set
                                                if (selectedOilPackageTypes == null && int.parse(widget.packGroupId) != 0) {
                                                  selectedOilPackageTypes = oilPackageTypes?.firstWhere(
                                                        (pkg) => pkg.id == int.parse(widget.packGroupId),
                                                    orElse: () => oilPackageTypes!.first,
                                                  );
                                                }

                                                return SizedBox(
                                                  width: double.infinity,
                                                  child: CommonDropdownButtonFormField<Category>(
                                                    value: selectedOilPackageTypes,
                                                    label: "Pack Group",
                                                    onChanged: (Category? newValue) {
                                                      if (newValue == null) return;
                                                      setState(() => selectedOilPackageTypes = newValue);

                                                      BlocProvider.of<CreateDiscountBloc>(context).add(
                                                        LoadMaterialByOilPkgType(
                                                          oilTypeIds: pSelectedOilType!.id!,
                                                          packGroupIds: newValue.id!,
                                                          oilPkgTypeId: selectedOilPackageTypeId?.id ?? 0,
                                                        ),
                                                      );
                                                    },
                                                    items: oilPackageTypes
                                                        ?.map((pkg) => DropdownMenuItem<Category>(
                                                      value: pkg,
                                                      child: Text(pkg.name!),
                                                    ))
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            )),
                                        SizedBox(
                                            height: 16),
                                        Visibility(
                                            visible: Constants
                                                .AUTH_ROLEID !=
                                                Constants.DEALER,
                                            child: StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                // Set the initial value if not already set
                                                if (selectedOilPackageTypeId == null && widget.packTypeId != 0) {
                                                  selectedOilPackageTypeId = oilPackageTypeIds?.firstWhere(
                                                        (pkg) => pkg.id == widget.packTypeId,
                                                    orElse: () => oilPackageTypeIds!.first,
                                                  );
                                                }

                                                return SizedBox(
                                                  width: double.infinity,
                                                  child: CommonDropdownButtonFormField<OilPackGroupTypeId>(
                                                    value: selectedOilPackageTypeId,
                                                    label: "Pack Type",
                                                    onChanged: (OilPackGroupTypeId? newValue) {
                                                      if (newValue == null) return;
                                                      setState(() => selectedOilPackageTypeId = newValue);

                                                      BlocProvider.of<CreateDiscountBloc>(context).add(
                                                        LoadMaterialByOilPkgType(
                                                          oilTypeIds: pSelectedOilType!.id!,
                                                          packGroupIds: selectedOilPackageTypes?.id ?? 0,
                                                          oilPkgTypeId: selectedOilPackageTypeId?.id ?? 0,
                                                        ),
                                                      );
                                                    },
                                                    items: oilPackageTypeIds
                                                        ?.map((pkg) => DropdownMenuItem<OilPackGroupTypeId>(
                                                      value: pkg,
                                                      child: Text(pkg.name!),
                                                    ))
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            )),
                                        Visibility(visible: Constants
                                            .AUTH_ROLEID !=
                                            Constants.DEALER,
                                            child: const SizedBox(
                                                height: 16)),
                                        InkWell(
                                            onTap: () {
                                              _showMultiSelectMaterial(context);
                                            },
                                            child: CommonTextFormField(
                                              labeltxt: "Material",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormEnaBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
                                              borderRadiusTL: Constant
                                                  .textFormborderRadiusTL,
                                              borderRadiusBR: Constant
                                                  .textFormborderRadiusBR,
                                              contentPadHor: Constant
                                                  .textFormcontentPadHor,
                                              contentPadHVer: Constant
                                                  .textFormcontentPadHVer,
                                              enabled: false,
                                              dropdownIcon: true,
                                              controllerTxt:
                                                  _materialController,
                                            )),
                                        const SizedBox(height: 18),
                                        Container(
                                            decoration: const BoxDecoration(
                                              border: Border.fromBorderSide(
                                                BorderSide.none,
                                              ),
                                              color: Color(0xFFF5F5F5),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                            ),
                                            child: CommonTextFormField(
                                              labeltxt: "Discount",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormFocuBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
                                              borderRadiusTL: Constant
                                                  .textFormborderRadiusTL,
                                              borderRadiusBR: Constant
                                                  .textFormborderRadiusBR,
                                              contentPadHor: Constant
                                                  .textFormcontentPadHor,
                                              contentPadHVer: Constant
                                                  .textFormcontentPadHVer,
                                              controllerTxt: _dicountcontroller,
                                            )),
                                        const SizedBox(height: 18),
                                        CommonTextFormField(
                                          labeltxt: "Reason For Discount",
                                          labeltxtColor:
                                              Constant.textFormFieldColor,
                                          labeltxtSize:
                                              Constant.textFormFieldSize,
                                          labeltxtFontWeight:
                                              Constant.textFormFieldSizeFontW,
                                          focuBorColor:
                                              Constant.textFormFocuBorCol,
                                          focuBorWid:
                                              Constant.textFormFocuBorWid,
                                          enaBorColor:
                                              Constant.textFormEnaBorCol,
                                          enaBorWid: Constant.textFormEnaBorWid,
                                          borderRadiusTL:
                                              Constant.textFormborderRadiusTL,
                                          borderRadiusBR:
                                              Constant.textFormborderRadiusBR,
                                          contentPadHor:
                                              Constant.textFormcontentPadHor,
                                          contentPadHVer:
                                              Constant.textFormcontentPadHVer,
                                          controllerTxt: _reasoncontroller,
                                        ),
                                        const SizedBox(height: 18),
                                        InkWell(
                                            onTap: () {
                                              _selectFromDate(context);
                                            },
                                            child: CommonTextFormField(
                                              labeltxt: "From Date",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormFocuBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
                                              borderRadiusTL: Constant
                                                  .textFormborderRadiusTL,
                                              borderRadiusBR: Constant
                                                  .textFormborderRadiusBR,
                                              contentPadHor: Constant
                                                  .textFormcontentPadHor,
                                              contentPadHVer: Constant
                                                  .textFormcontentPadHVer,
                                              controllerTxt:
                                                  _fromdatecontroller,
                                              enabled: false,
                                            )),
                                        const SizedBox(height: 18),
                                        InkWell(
                                            onTap: () {
                                              _selectToDate(context);
                                            },
                                            child: CommonTextFormField(
                                              labeltxt: "To Date",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormFocuBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
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
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _checkboxValue,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _checkboxValue = newValue!;
                                                });
                                              },
                                            ),
                                            const Text('Applies to cities'),
                                          ],
                                        ),
                                        if (_checkboxValue)
                                          BlocBuilder<CreateDiscountBloc,
                                              CreateDiscountState>(
                                            builder: (context, state) {
                                              return InkWell(
                                                  onTap: () {
                                                    _showMultiSelectZone(
                                                        context);
                                                    // BlocProvider.of<CreateDiscountBloc>(context)
                                                    //     .add(LoadState(zoneId: selectedZoneIds));

                                                    // // context.read<CreateDiscountBloc>().add(LoadZonalHead(userId: Constants.AUTH_USERID,showAll:false));context
                                                  },
                                                  child: CommonTextFormField(
                                                    labeltxt: "Zone",
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
                                                    enabled: false,
                                                    dropdownIcon: true,
                                                    controllerTxt:
                                                        _zoneController,
                                                    // onChanged: (ActiveZone? newValue){
                                                    //   setState(() {
                                                    //     selectedZoneState = newValue!;
                                                    //   });
                                                    // context.read<CreateDiscountBloc>().add(LoadState(zoneId:selectedZoneIds));

                                                    // },
                                                  ));
                                            },
                                          ),
                                        if (_checkboxValue)
                                        const SizedBox(height: 16),
                                        if (_checkboxValue)
                                          BlocBuilder<CreateDiscountBloc,
                                              CreateDiscountState>(
                                            builder: (context, state) {
                                              return InkWell(
                                                  onTap: () {
                                                    _showMultiSelectState(
                                                        context);
                                                  },
                                                  child: CommonTextFormField(
                                                    labeltxt: "State",
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
                                                    enabled: false,
                                                    dropdownIcon: true,
                                                    controllerTxt:
                                                        _stateController,
                                                  ));
                                            },
                                          ),
                                        if (_checkboxValue)
                                        const SizedBox(height: 16),
                                        if (_checkboxValue)
                                          InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context,
                                                  "Select All",
                                                  dialogCitiesAndDistrict());
                                              // tempCityTerritoryList = cityTerritoryList;
                                            },
                                            child: CommonTextFormField(
                                              labeltxt: "Cities and District",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormFocuBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
                                              borderRadiusTL: Constant
                                                  .textFormborderRadiusTL,
                                              borderRadiusBR: Constant
                                                  .textFormborderRadiusBR,
                                              contentPadHor: Constant
                                                  .textFormcontentPadHor,
                                              contentPadHVer: Constant
                                                  .textFormcontentPadHVer,
                                              enabled: false,
                                              controllerTxt:
                                                  _cityTerritoryController,
                                              dropdownIcon: true,
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _isActive,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _isActive = newValue!;
                                                });
                                              },
                                            ),
                                            const Text('is Active'),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
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
                        width: screenWidth / 2 - 40,
                        child: CommonButton(
                            buttonName: Constant.saudaLEButtonTxt1,
                            buttonNameSize: Constant.pricbuttonNameSize,
                            buttonNameColor: Constant.saudaLETTxtColor,
                            buttonColor: Constant.saudaLETbuttonColor,
                            buttonHeight: Constant.pricbuttonHeight,
                            buttonRadiusTL: Constant.pricbuttonRadiusTL,
                            buttonRadiusBL: Constant.pricbutRadiusBL,
                            buttonBorder: Constant.saudaLETbuttonBorder,
                            buttonFunction: () {
                              Navigator.pop(context);
                            }),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: screenWidth / 2 - 40,
                        child: CommonButton(
                          buttonName: widget.isUpdate ? 'Update' : 'Save',
                          buttonNameSize: Constant.pricbuttonNameSize,
                          buttonNameColor: Constant.pricbuttonTxtColor,
                          buttonColor: Constant.pricbuttonColor,
                          buttonHeight: Constant.pricbuttonHeight,
                          buttonRadiusTL: Constant.pricbuttonRadiusTL,
                          buttonRadiusBL: Constant.pricbutRadiusBL,
                          buttonBorder: Colors.transparent,
                          buttonFunction: () {
                            GeographyDiscountRequest geoDiscountRequest =
                                GeographyDiscountRequest();
                            geoDiscountRequest.id =
                                widget.isUpdate ? widget.id : 0;
                            geoDiscountRequest.loginUserId =
                                Constants.AUTH_USERID;

                            if (pSelectedOilType != null) {
                              geoDiscountRequest.oilTypeId = pSelectedOilType!.id;
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select Oil Type from the list",
                                  closeScreen: false);
                              return;
                            }

                            geoDiscountRequest.isActive = _isActive;

                            if (selectedOilPackageTypes != null) {
                              geoDiscountRequest.packGroupId = selectedOilPackageTypes!.id;
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select Oil Package Type from the list",
                                  closeScreen: false);
                              return;
                            }


                            if (selectedMaterialIds.isNotEmpty ||
                                widget.materialIds.isNotEmpty) {
                              geoDiscountRequest.skuIds = selectedMaterialIds;
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select Material from the list",
                                  closeScreen: false);
                              return;
                            }

                            if (selectedOilPackageTypeId != null) {
                              geoDiscountRequest.packGroupTypeId = selectedOilPackageTypeId!.id;
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select Oil Package group Type from the list",
                                  closeScreen: false);
                              return;
                            }

                            if (_dicountcontroller.text.toString().isNotEmpty) {
                              geoDiscountRequest.actualDiscount = 0;
                              if (_dicountcontroller.text.toString() != "") {
                                geoDiscountRequest.actualDiscount =
                                    double.parse(
                                        _dicountcontroller.text.toString());
                              }
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Enter the Discount amount",
                                  closeScreen: false);
                              return;
                            }

                            if (_reasoncontroller.text.toString().isNotEmpty) {
                              geoDiscountRequest.discountReason =
                                  _reasoncontroller.text.toString();
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText:
                                      "Provide the reason for the discount",
                                  closeScreen: false);
                              return;
                            }

                            if (_fromdatecontroller.text
                                .toString()
                                .isNotEmpty) {
                              geoDiscountRequest.validFrom = DateTimeUtils()
                                  .dateToServerToDateFormat(
                                      _fromdatecontroller.text.toString(),
                                      DateTimeUtils.DD_MM_YYYY_HH_MM_24,
                                      DateTimeUtils.ServerFormat1);
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select From date",
                                  closeScreen: false);
                              return;
                            }

                            if (_todatecontroller.text.toString().isNotEmpty) {
                              geoDiscountRequest.validTo = DateTimeUtils()
                                  .dateToServerToDateFormat(
                                      _todatecontroller.text.toString(),
                                      DateTimeUtils.DD_MM_YYYY_HH_MM_24,
                                      DateTimeUtils.ServerFormat1);
                            } else {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select To date",
                                  closeScreen: false);
                              return;
                            }

                            if (!_checkboxValue) {
                              showSuccessDlg(context, "Error", "Error",
                                  successText: "Select Checkbox",
                                  closeScreen: false);
                              return;
                            } else {
                              if (selectedZoneIds.isEmpty) {
                                showSuccessDlg(context, "Error", "Error",
                                    successText: "Select Zone from the list",
                                    closeScreen: false);
                                return;
                              } else if (selectedStateIds.isEmpty) {
                                showSuccessDlg(context, "Error", "Error",
                                    successText: "Select State from the list",
                                    closeScreen: false);
                                return;
                              } else if (selectedCityTerritory.isEmpty) {
                                showSuccessDlg(context, "Error", "Error",
                                    successText:
                                        "Select cities and territories from the list",
                                    closeScreen: false);
                                return;
                              } else {
                                geoDiscountRequest.cities =
                                    selectedCityTerritory;
                                BlocProvider.of<CreateDiscountBloc>(context)
                                    .add(SaveGeographyDiscount(
                                        request: geoDiscountRequest,
                                        isUpdate: widget.isUpdate));
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )),
            );
          },
        )),
      ),
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
        firstDate: (Constants.AUTH_ROLEID != Constants.NHMANAGER)
            ? DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format))
            : DateTime.now().add(const Duration(days: -2000)),
        lastDate: (Constants.AUTH_ROLEID != Constants.NHMANAGER)
            ? DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format))
            : DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
      if (picked_s != null && picked_s != selectedTime) {
        setState(() {
          selectedTime = picked_s;
        });
      }
      _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(
          DateTime(selected.year, selected.month, selected.day,
              selectedTime.hour, selectedTime.minute),
          DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
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
        firstDate: (Constants.AUTH_ROLEID != Constants.NHMANAGER)
            ? DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format))
            : DateTime.now().add(const Duration(days: -2000)),
        lastDate: (Constants.AUTH_ROLEID != Constants.NHMANAGER)
            ? DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format))
            : DateTime.now().add(const Duration(days: 2000)));

    if (selected != null) {
      final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
      if (picked_s != null && picked_s != selectedTime) {
        setState(() {
          selectedTime = picked_s;
        });
      }
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(
          DateTime(selected.year, selected.month, selected.day,
              selectedTime.hour, selectedTime.minute),
          DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
    }
  }

  void _showMultiSelectMaterial(BuildContext context) async {
    bool isCheck = false;
    if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
      materialList = selectedMaterials;
      isCheck = true;
    }
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
          searchable: true,
          items:   materialList
              .map((dist) => MultiSelectItem<BdoList>(dist, dist.name!))
              .toList(),
          initialValue: selectedMaterials,
          isUncheck: isCheck,
          onConfirm: (List<BdoList> values) {
            selectedMaterials = values;
            selectedMaterialIds.clear();
            for (BdoList d in values) {
              selectedMaterialIds.add(d.id!);
            }
            setState(() {
              _materialController.text =
                  selectedMaterialIds.length.toString() + " Item(s) selected";
            });
            GMLogger.v(selectedMaterialIds.toString());
          },
        );
      },
    );
  }

  void _showMultiSelectZone(BuildContext context) async {
    bool isCheck = false;
    if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
      zoneList = selectedZone;
      isCheck = true;
    }
    CreateDiscountBloc createDiscountBloc =
        BlocProvider.of<CreateDiscountBloc>(context);
    await showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: createDiscountBloc,
          child: MultiSelectDialog<ActiveZone>(
            searchable: true,
            items: zoneList
                .map((zone) =>
                    MultiSelectItem<ActiveZone>(zone, zone.name ?? ""))
                .toList(),
            initialValue: selectedZone,
            isUncheck: isCheck,
            onConfirm: (List<ActiveZone> values) {
              selectedZone = values;
              selectedZoneIds.clear();
              for (ActiveZone d in values) {
                selectedZoneIds.add(d.id!);
              }
              setState(() {
                _zoneController.text =
                    selectedZoneIds.length.toString() + " Item(s) selected";
              });
              createDiscountBloc.add(LoadState(zoneId: selectedZoneIds));
            },
          ),
        );
      },
    );
  }

  void _showMultiSelectState(BuildContext context) async {
    bool isCheck = false;
    if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
      stateList = selectedState;
      isCheck = true;
    }
    CreateDiscountBloc createDiscountBloc =
        BlocProvider.of<CreateDiscountBloc>(context);
    await showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: createDiscountBloc,
          child: MultiSelectDialog<ActiveStateResponse>(
            searchable: true,
            items: stateList
                .map((state) => MultiSelectItem<ActiveStateResponse>(
                    state, state.stateName ?? ''))
                .toList(),
            initialValue: selectedState,
            isUncheck: isCheck,
            onConfirm: (List<ActiveStateResponse> values) {
              selectedState = values;
              selectedStateIds.clear();
              for (ActiveStateResponse d in values) {
                selectedStateIds.add(d.stateId!);
              }
              setState(() {
                _stateController.text =
                    selectedStateIds.length.toString() + " Item(s) selected";
              });
              createDiscountBloc
                  .add(LoadCityTerritory(cityTerritoryId: selectedStateIds));
            },
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, title, footerbutton) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Container(
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
                        title: Row(children: [
                          Text(
                              (Constants.AUTH_ROLEID == Constants.NHMANAGER)
                                  ? title
                                  : "Cities & Districts",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Constant.colorWhite,
                                fontSize: Constant.fontSize15,
                                fontWeight: Constant.fontWeight500,
                              )),
                          if ((Constants.AUTH_ROLEID == Constants.NHMANAGER))
                            Checkbox(
                              value: selectAll,
                              onChanged: (newValue) {
                                setState(() {
                                  selectAll = newValue!;
                                  cityTerritoryList.forEach((element) {
                                    element.isChecked = newValue;
                                  });
                                });
                              },
                            ),
                        ]),
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
                    ListTile(
                      title: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            onSearchTextChanged(value, setState);
                          }),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _searchController.clear();
                          onSearchTextChanged('', setState);
                        },
                      ),
                    ),
                    Expanded(
                        child: _searchResult.isEmpty ||
                                _searchController.text.isEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: (Constants.AUTH_ROLEID !=
                                        Constants.NHMANAGER)
                                    ? selectedCityTerritory.length
                                    : cityTerritoryList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return (Constants.AUTH_ROLEID !=
                                          Constants.NHMANAGER)
                                      ? getContentUpdate(index, setState)
                                      : getContent(index, setState);
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _searchResult.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return getSearchContent(index, setState);
                                },
                              )),
                  ],
                ),
              );
            },
          ),
          actions: [
            Row(
              children: [footerbutton],
            )
          ],
        );
      },
    );
  }

  Widget dialogCitiesAndDistrict() {
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
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                _searchController.clear();
                selectAll = false;
                loadCityTerritory();
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
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                selectedCityTerritory.clear();

                cityTerritoryList.forEach((element) {
                  if (element.isChecked == true) {
                    selectedCityTerritory.add(Cities(
                        cityId: element.cityId,
                        districtId: element.districtId,
                        territoryId: element.territoryId,
                        stateId: element.stateId,
                        zoneId: element.zoneId));
                  }
                });
                setState(() {
                  _cityTerritoryController.text =
                      selectedCityTerritory.length.toString() +
                          " Item(s) selected";
                });
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getContent(int index, StateSetter setState) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.only(top: 20),
        height: 100,
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide.none,
            ),
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Row(children: [
          Checkbox(
            value: cityTerritoryList[index].isChecked,
            onChanged: (newValue) {
              setState(() {
                cityTerritoryList[index].isChecked = newValue;
              });
            },
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      name: "Zone",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].zoneName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                  SizedBox(
                    height: 15,
                  ),
                  CommonText(
                      name: "District",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].districtName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      name: "State",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].stateName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                  SizedBox(
                    height: 10,
                  ),
                  CommonText(
                      name: "City",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].cityName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                ],
              ),
            ),
          )
        ]),
      )
    ]);
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GeographyDiscountScreen()),
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

  void loadMaterial() {
    for (var id in widget.materialIds) {
      var selectedObj = materialList.firstWhere((x) => x.id == id);
      selectedMaterials.add(selectedObj);
    }
    setState(() {
      if (selectedMaterials.isEmpty) {
        _materialController.text = "Select Materials";
      } else {
        _materialController.text =
            widget.materialIds.length.toString() + " Item(s) selected";
      }
    });

    _dicountcontroller = TextEditingController(text: widget.discount);
    _reasoncontroller = TextEditingController(text: widget.discountReason);
    _fromdatecontroller = TextEditingController(
      text: DateTimeUtils().dateToServerToDateFormat(
        widget.fromDate,
        DateTimeUtils.ServerFormat,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24,
      ),
    );
    _todatecontroller = TextEditingController(
      text: DateTimeUtils().dateToServerToDateFormat(
        widget.toDate,
        DateTimeUtils.ServerFormat,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24,
      ),
    );
  }

  void loadZone() {
    for (var id in widget.zoneIds) {
      var selectedObj = zoneList.firstWhere((x) => x.id == id);
      selectedZone.add(selectedObj);
      selectedZoneIds = widget.zoneIds;
    }
    setState(() {
      if (selectedZone.isEmpty) {
        _zoneController.text = "Select Zone";
      } else {
        _zoneController.text =
            widget.zoneIds.length.toString() + " Item(s) selected";
      }
    });
  }

  void loadState() {
    for (var id in widget.stateIds) {
      var selectedObj = stateList.firstWhere((x) => x.stateId == id);
      selectedState.add(selectedObj);
      selectedStateIds = widget.stateIds;
    }
    setState(() {
      if (selectedState.isEmpty) {
        _stateController.text = "Select state";
      } else {
        _stateController.text =
            widget.stateIds.length.toString() + " Item(s) selected";
      }
    });
  }

  void loadCityTerritory() {
    List<CityTerritory> temp = [];
    selectedCityTerritory.clear();
    cityTerritoryList.forEach((element) {
      if (widget.cities
          .where(
              (x) => x.cityId == element.cityId && x.stateId == element.stateId)
          .isNotEmpty) {
        selectedCityTerritory.add(Cities(
            cityId: element.cityId,
            districtId: element.districtId,
            stateId: element.stateId,
            territoryId: element.territoryId,
            zoneId: element.zoneId));
        element.isChecked = true;
        temp.add(element);
      } else {
        element.isChecked = false;
        temp.add(element);
      }
    });
    cityTerritoryList = temp;
    setState(() {
      if (selectedCityTerritory.isEmpty) {
        _cityTerritoryController.text = "Show Cities and District";
      } else {
        _cityTerritoryController.text =
            selectedCityTerritory.length.toString() + " Item(s) selected";
      }
    });
  }

  getContentUpdate(int index, StateSetter setState) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.only(top: 20),
        height: 100,
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide.none,
            ),
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Row(children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      name: "Zone",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].zoneName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                  SizedBox(
                    height: 15,
                  ),
                  CommonText(
                      name: "District",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].districtName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      name: "State",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].stateName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                  SizedBox(
                    height: 10,
                  ),
                  CommonText(
                      name: "City",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: cityTerritoryList[index].cityName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                ],
              ),
            ),
          )
        ]),
      )
    ]);
  }

  onSearchTextChanged(
    String? text,
    StateSetter setState,
  ) {
    _searchResult.clear();
    if (text!.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      for (var element in cityTerritoryList) {
        if (element.cityName!.toLowerCase().contains(text.toLowerCase()) ||
            element.districtName!.toLowerCase().contains(text.toLowerCase())) {
          _searchResult.add(element);
        }
      }
    });
  }

  Widget getSearchContent(int index, StateSetter setState) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.only(top: 20),
        height: 100,
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide.none,
            ),
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Row(children: [
          Checkbox(
            value: selectAll ? true : _searchResult[index].isChecked,
            onChanged: (newValue) {
              setState(() {
                _searchResult[index].isChecked = newValue;
              });
            },
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      name: "Zone",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: _searchResult[index].zoneName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                  SizedBox(
                    height: 15,
                  ),
                  CommonText(
                      name: "District",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: _searchResult[index].districtName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                      name: "State",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: _searchResult[index].stateName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                  SizedBox(
                    height: 10,
                  ),
                  CommonText(
                      name: "City",
                      fontSize: Constant.fontSize14,
                      fontColor: Constant.colorBlack,
                      fontWeight: Constant.fontWeight500),
                  CommonText(
                      name: _searchResult[index].cityName,
                      fontSize: Constant.fontSize12,
                      fontColor: Constant.colorDullGray77),
                ],
              ),
            ),
          )
        ]),
      )
    ]);
  }
}
