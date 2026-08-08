import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/pack_group_list.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/screen/common_filter/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/common-textfield.dart';
import 'package:adaniwilmar/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';

@immutable
class CommonFilterWidget extends StatelessWidget {
  GlobalKey dialogKey;
  String title;
  DistributorList? selectedDistributor;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  IncoTermList? selectedIncoTerm;
  PlanDepotList? selectedPlant;
  OilType? selectedOilType;
  BrokerList? selectedBroker;
  PackGroupList? selectedPackGroup;
  ActiveState? selectedState;
  OilTypeSkuList? selectedSKU;
  BdoList? selectedBDO;

  List<DistributorList>? selectedDistributors;
  List<PlanDepotList>? selectedPlants;
  List<IncoTermList>? selectedIncoTerms;
  List<OilType>? selectedOilTypes;
  List<BrokerList>? selectedBrokers;
  List<PackGroupList>? selectedPackGroups;
  List<ActiveState>? selectedStates;
  List<OilTypeSkuList>? selectedSkus;
  List<BdoList>? selectedBDOs;

  bool? showDistributor;
  bool? showSalesOrg;
  bool? showDistrChannel;
  bool? showVertical;
  bool? showIncoTerm;
  bool? showPlant;
  bool? showOilType;
  bool? showBroker;
  bool? showPackGroup;
  bool? showState;
  bool? showFromDate;
  bool? showToDate;
  bool? showSKU;
  bool? showBdo;

  bool? mDistributor;
  bool? mIncoTerm;
  bool? mPlant;
  bool? mOilType;
  bool? mBroker;
  bool? mPackGroup;
  bool? mState;
  bool? mSKU;
  bool? mBdo;

  CommonFilterWidget(
      {required this.dialogKey,
      required this.title,
      this.selectedDistributor,
      this.selectedSalesOrg,
      this.selectedDistrChannel,
      this.selectedVertical,
      this.selectedIncoTerm,
      this.selectedPlant,
      this.selectedOilType,
      this.selectedBroker,
      this.selectedPackGroup,
      this.selectedState,
      this.selectedSKU,
      this.selectedBDO,
      this.selectedDistributors,
      this.selectedPlants,
      this.selectedIncoTerms,
      this.selectedOilTypes,
      this.selectedBrokers,
      this.selectedPackGroups,
      this.selectedStates,
      this.selectedSkus,
      this.selectedBDOs,
      this.showDistributor,
      this.showSalesOrg,
      this.showDistrChannel,
      this.showVertical,
      this.showIncoTerm,
      this.showPlant,
      this.showOilType,
      this.showBroker,
      this.showPackGroup,
      this.showState,
      this.showFromDate,
      this.showToDate,
      this.showSKU,
      this.showBdo,
      this.mDistributor,
      this.mIncoTerm,
      this.mPlant,
      this.mOilType,
      this.mBroker,
      this.mPackGroup,
      this.mState,
      this.mSKU,
      this.mBdo,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommonFilterBloc(),
      child: CommonFilter(dialogKey: dialogKey, title: title),
    );
  }
}

class CommonFilter extends StatefulWidget {
  GlobalKey dialogKey;
  String title;
  DistributorList? selectedDistributor;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  IncoTermList? selectedIncoTerm;
  PlanDepotList? selectedPlant;
  OilType? selectedOilType;
  BrokerList? selectedBroker;
  PackGroupList? selectedPackGroup;
  ActiveState? selectedState;
  OilTypeSkuList? selectedSKU;
  BdoList? selectedBDO;

  List<DistributorList>? selectedDistributors;
  List<PlanDepotList>? selectedPlants;
  List<IncoTermList>? selectedIncoTerms;
  List<OilType>? selectedOilTypes;
  List<BrokerList>? selectedBrokers;
  List<PackGroupList>? selectedPackGroups;
  List<ActiveState>? selectedStates;
  List<OilTypeSkuList>? selectedSkus;
  List<BdoList>? selectedBDOs;

  bool? showDistributor;
  bool? showSalesOrg;
  bool? showDistrChannel;
  bool? showVertical;
  bool? showIncoTerm;
  bool? showPlant;
  bool? showOilType;
  bool? showBroker;
  bool? showPackGroup;
  bool? showState;
  bool? showFromDate;
  bool? showToDate;
  bool? showSKU;
  bool? showBdo;

  bool? mDistributor;
  bool? mIncoTerm;
  bool? mPlant;
  bool? mOilType;
  bool? mBroker;
  bool? mPackGroup;
  bool? mState;
  bool? mSKU;
  bool? mBdo;

  CommonFilter({
    required this.dialogKey,
    required this.title,
    this.selectedDistributor,
    this.selectedSalesOrg,
    this.selectedDistrChannel,
    this.selectedVertical,
    this.selectedIncoTerm,
    this.selectedPlant,
    this.selectedOilType,
    this.selectedBroker,
    this.selectedPackGroup,
    this.selectedState,
    this.selectedSKU,
    this.selectedBDO,
    this.selectedDistributors,
    this.selectedPlants,
    this.selectedIncoTerms,
    this.selectedOilTypes,
    this.selectedBrokers,
    this.selectedPackGroups,
    this.selectedStates,
    this.selectedSkus,
    this.selectedBDOs,
    this.showDistributor,
    this.showSalesOrg,
    this.showDistrChannel,
    this.showVertical,
    this.showIncoTerm,
    this.showPlant,
    this.showOilType,
    this.showBroker,
    this.showPackGroup,
    this.showState,
    this.showFromDate,
    this.showToDate,
    this.showSKU,
    this.showBdo,
    this.mDistributor,
    this.mIncoTerm,
    this.mPlant,
    this.mOilType,
    this.mBroker,
    this.mPackGroup,
    this.mState,
    this.mSKU,
    this.mBdo,
    Key? key,
  }) : super(key: key);
  @override
  State<CommonFilter> createState() => CommonFilterWidgetState();
}

class CommonFilterWidgetState extends State<CommonFilter> {
  List<DistributorList> distributorList = [];
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<IncoTermList> incoTerms = [];
  List<PlanDepotList> plants = [];
  List<OilType> oilTypes = [];
  List<BrokerList> brokerList = [];
  List<PackGroupList> packGroupList = [];
  List<ActiveState> stateList = [];
  List<OilTypeSkuList> skuList = [];
  List<BdoList> bdoList = [];

  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();

  double screenWidth = 0;
  double screenHeight = 0;
  String fromDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = "";

  @override
  void initState() {
    // TODO: implement initState
    if (widget.showSalesOrg!) {
      BlocProvider.of<CommonFilterBloc>(context)
          .add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0));
    } else if (widget.showDistributor!) {
      BlocProvider.of<CommonFilterBloc>(context).add(LoadCommonFilterScreen(
          userId: Constants.AUTH_USERID,
          salesOrganizationId: 0,
          distributionChannelId: 0,
          divisonId: 0));
    }
    if (!widget.showSalesOrg! && widget.showOilType!) {
      BlocProvider.of<CommonFilterBloc>(context).add(LoadOilType(
          userId: Constants.AUTH_USERID,
          salesOrganizationId: 0,
          distributionChannelId: 0,
          divisonId: 0));
    }
    if (widget.showBdo!) {
      BlocProvider.of<CommonFilterBloc>(context)
          .add(LoadBDO(userId: Constants.AUTH_USERID));
    }
    if (widget.showPackGroup!) {
      BlocProvider.of<CommonFilterBloc>(context)
          .add(LoadPackGroupList(userId: Constants.AUTH_USERID));
    }
    if (widget.showState!) {
      BlocProvider.of<CommonFilterBloc>(context).add(LoadStates(id: 0));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _fromdatecontroller.text = fromDate;
    _todatecontroller.text = toDate;
    return BlocListener<CommonFilterBloc, CommonFilterState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            widget.selectedDistributor = null;
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            setState(() {});
          }
          if (state is OnLoadDealerSaudaDetail) {
            widget.selectedIncoTerm = null;
            incoTerms = state.dealerSaudaDetail.incoTermList!;
            widget.selectedPlant = null;
            plants = state.dealerSaudaDetail.plantDepotListNew!;
            widget.selectedBroker = null;
            brokerList = state.dealerSaudaDetail.brokerList!;
            if (state.dealerSaudaDetail.saudaValidityPeriod != null) {
              toDate = DateTimeUtils().dateToStringFormat(
                  DateTime.now().add(Duration(
                      days: state.dealerSaudaDetail.saudaValidityPeriod!)),
                  DateTimeUtils.DD_MM_YYYY_Format);
            }
            _fromdatecontroller.text = fromDate;
            _todatecontroller.text = toDate;
            setState(() {});
          }
          if (state is OnLoadDistributionChannel) {
            widget.selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            widget.selectedVertical = null;
            widget.selectedOilType = null;
            widget.selectedDistributor = null;
            verticals = state.verticalList;
            setState(() {});
          }
          if (state is OnLoadPlant) {
            widget.selectedPlant = null;
            plants = state.plantList;
            setState(() {});
          }
          if (state is OnLoadOilType) {
            widget.selectedOilType = null;
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnLoadPackGroup) {
            widget.selectedPackGroup = null;
            packGroupList = state.packGroups;
            setState(() {});
          }
          if (state is OnLoadStates) {
            widget.selectedState = null;
            stateList = state.states;
            setState(() {});
          }
          if (state is OnLoadSKUDetails) {
            widget.selectedSKU = null;
            skuList = state.skuList;
            setState(() {});
          }
          if (state is OnLoadBDO) {
            widget.selectedBDO = null;
            bdoList = state.bdoList;
            setState(() {});
          }
        },
        child: StatefulBuilder(
            key: widget.dialogKey,
            builder: (context, setState) {
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
                  child: Text(widget.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Constant.fontSize15,
                        fontWeight: Constant.fontWeight500,
                      )),
                ),
                content: Container(
                    height: 300,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: getDialogContent()),
                actions: [dialogActionButtonFilter()],
              );
            }));
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
            width: screenWidth / 3,
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
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
