import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/pending_contract_filter_response.dart';
import 'package:adaniwilmar/models/pending_contract_report_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/screen/pending_contract/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:adaniwilmar/widget/multiselect/util/multi_select_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../config/constant.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/widget.dart';

class PendingContractScreen extends StatelessWidget {
  const PendingContractScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingContractBloc()
        ..add(LoadPendingContractScreen(userId: Constants.AUTH_USERID, salesOrganizationId: 0, distributionChannelId: 0, divisonId: 0))
        ..add(LoadPendingContractFilter(userId: Constants.AUTH_USERID))
        ..add(LoadBDO(userId: Constants.AUTH_USERID))
        ..add(LoadActiveStates(id: 0))
        ..add(LoadPendingContractData(userId: Constants.AUTH_USERID, id: 0, stateIds: const [], skuIds: const [])),
      child: const PendingContractDetail(),
    );
  }
}

class PendingContractDetail extends StatefulWidget {
  const PendingContractDetail({Key? key}) : super(key: key);

  @override
  State<PendingContractDetail> createState() => _PendingContractScreenState();
}

class _PendingContractScreenState extends State<PendingContractDetail> {
  int selected = 0 - 1;
  List<DistributorList> distributorList = [];
  List<BdoList> bdoList = [];
  List<ActiveState> stateList = [];
  List<PackGroup>? packGroups = [];
  List<OilTypesPendingContractReport> oilTypes = [];
  List<SkuandPackGroup>? skuandPackGroups = [];
  PendingContractFilterValue filterValue = PendingContractFilterValue();
  ProgressBarHandler? _handler;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  final GlobalKey _dialogKey = GlobalKey();

  DistributorList? selectedDistributor;
  BdoList? selectedBdo;
  List<ActiveState>? selectedStates;
  List<PackGroup>? selectedPackGroups;
  OilTypesPendingContractReport? selectedOilType;
  List<SkuandPackGroup>? selectedSkus;

  PendingContractReport pendingContractData = PendingContractReport();
  List<PendingContractDealerOutput> pendingContractDealerOutput = [];
  List<PendingContractDealerOutput> searchPendingContractDealerOutput = [];

  List<PendingContractSkuOutput> pendingContractSkuOutput = [];
  List<PendingContractSkuOutput> searchPendingContractSkuOutput = [];

  final TextEditingController _packgroupcontroller = TextEditingController();
  final TextEditingController _statecontroller = TextEditingController();
  final TextEditingController _skucontroller = TextEditingController();

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;

  final TextEditingController _searchQueryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<PendingContractBloc, PendingContractState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            selectedDistributor = null;
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadBDO) {
            selectedDistributor = null;
            selectedBdo = null;
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnLoadStates) {
            selectedStates = [];
            _statecontroller.text = "All States";
            stateList = state.states;
            setState(() {});
          }
          if (state is OnPendingContractFilterSuccess) {
            selectedOilType = null;
            selectedPackGroups = [];
            selectedSkus = [];
            _packgroupcontroller.text = "All Packgroups";
            oilTypes = state.pendingContractFilters.oilTypesPendingContractReport!;
            packGroups = state.pendingContractFilters.packGroup!;
            setState(() {});
          }
          if (state is OnPendingContractDataSuccess) {
            pendingContractData = state.pendingContractData;
            pendingContractDealerOutput = pendingContractData.pendingContractDealerOutput ?? [];
            searchPendingContractDealerOutput = pendingContractData.pendingContractDealerOutput ?? [];
            if (pendingContractDealerOutput.isNotEmpty) {
              pendingContractSkuOutput = pendingContractDealerOutput[0].pendingContractSkuOutput ?? [];
              searchPendingContractSkuOutput = pendingContractDealerOutput[0].pendingContractSkuOutput ?? [];
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
            title: "Pending Contract",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showCustomFilterDialog(context, "Filter", "Filter", dialogActionButtonFilter());
                  },
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(7),
                      child: Constant.filterIc,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            // overflow: Overflow.visible,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                // height: screenHeight * 0.982,
                margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                child: pendingContractData.pendingDate != null
                    ? CurveBorderBox(
                        boxLRPadding: 0.0,
                        boxTOPPadding: 0.0,
                        boxofWidget: Column(
                          children: [
                            CurveBorderBox(
                                boxBgColor: const Color(0xFFFFFBF7),
                                boxShadowColor: const Color(0xFFFFFFFF),
                                boxLRPadding: 0.0,
                                boxTOPPadding: 0.0,
                                // boxTBPadding: 0.0,
                                boxofWidget: Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                                  height: screenHeight * 0.08,
                                  width: screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              name: "Pending Date",
                                              fontSize: Constant.fontSize14,
                                              fontColor: Constant.colorGray45,
                                            ),
                                            const SizedBox(height: 5.0),
                                            CommonText(
                                              name: DateTimeUtils().dateToServerToDateFormat(pendingContractData.currentDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MM_YYYY_HH_MM_AA),
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorGray45,
                                              fontWeight: Constant.fontWeight500,
                                            ),
                                            // CommonText(
                                            //   name: "Kolkata, West Bengal - 100102",
                                            //   fontSize: Constant.fontSize12,
                                            //   fontColor: Constant.colorLightGray,
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              name: "Total Pending Qty",
                                              fontSize: Constant.fontSize14,
                                              fontColor: Constant.colorBlack,
                                            ),
                                            const SizedBox(height: 5.0),
                                            CommonText(
                                              name: pendingContractData.totalQuantityInMT!.toStringAsFixed(2) + " MT",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight: Constant.fontWeight500,
                                            ),
                                            // CommonText(
                                            //   name: "Kolkata, West Bengal - 100102",
                                            //   fontSize: Constant.fontSize12,
                                            //   fontColor: Constant.colorLightGray,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _searchQueryController,
                                  onChanged: (query) => updateSearchQuery(query),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        updateSearchQuery("");
                                        _searchQueryController.text = "";
                                      },
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1, color: Colors.black),
                                    ),
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                    ),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(
                                          width: 1,
                                        )),
                                    labelStyle: const TextStyle(color: Colors.grey),
                                    labelText: (Constants.AUTH_ROLEID == Constants.DEALER) ? "Search SKU " : "Search Distributor",
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(4),
                                height: screenHeight * 0.870,
                                width: screenWidth,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Constants.AUTH_ROLEID == Constants.DEALER
                                          ? pendingContractDealerOutput.isNotEmpty
                                              ? ListView.builder(
                                                  key: const Key('builder 1'),
                                                  //attention
                                                  padding: const EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: pendingContractSkuOutput.length,
                                                  itemBuilder: (context, ind) {
                                                    return CurveOuterBox(
                                                        boxLRPadding: 0,
                                                        boxTBPadding: 4,
                                                        boxofWidget: Theme(
                                                          data: theme,
                                                          child: ExpansionTile(
                                                            tilePadding: const EdgeInsets.only(right: 15),
                                                            key: Key(ind.toString()),
                                                            initiallyExpanded: ind == selected,
                                                            title: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  width: 3,
                                                                  height: 22,
                                                                  color: Constant.callToCcolor1,
                                                                  margin: const EdgeInsets.only(top: 3),
                                                                ),
                                                                const SizedBox(width: 16),
                                                                Expanded(
                                                                    child: CommonText(
                                                                  name: pendingContractSkuOutput[ind].sku!,
                                                                  fontColor: Constant.colorBlack,
                                                                  fontSize: Constant.fontSize14,
                                                                  fontWeight: Constant.fontWeight600,
                                                                )),
                                                              ],
                                                            ),
                                                            children: [
                                                              ListView.builder(
                                                                  key: Key('builder ${selected.toString()}'),
                                                                  //attention
                                                                  padding: const EdgeInsets.all(0),
                                                                  shrinkWrap: true,
                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                  itemCount: pendingContractSkuOutput[ind].pendingContractSkuDetails!.length,
                                                                  itemBuilder: (context, index) {
                                                                    PendingContractSkuDetails skuDetail = pendingContractSkuOutput[ind].pendingContractSkuDetails![index];
                                                                    return ListTile(
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        title: Column(
                                                                          children: [
                                                                            Container(
                                                                                width: double.infinity,
                                                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      '#' + skuDetail.contractNumber!,
                                                                                      style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                                                                    ),
                                                                                    // const SizedBox(height: 4),
                                                                                    CommonText(
                                                                                      name: (skuDetail.contractValidFrom != null
                                                                                              ? DateTimeUtils().dateToServerToDateFormat(
                                                                                                  skuDetail.contractValidFrom!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format)
                                                                                              : "") +
                                                                                          " to " +
                                                                                          (skuDetail.contractValidTo != null
                                                                                              ? DateTimeUtils().dateToServerToDateFormat(
                                                                                                  skuDetail.contractValidTo!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format)
                                                                                              : ""),
                                                                                      fontSize: Constant.fontSize12,
                                                                                      fontColor: Constant.colorBlack,
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
                                                                              child: Column(
                                                                                children: [
                                                                                  const SizedBox(height: 16),
                                                                                  Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Align(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              CommonText(
                                                                                                name: "Pending Qty",
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorDullGray77,
                                                                                              ),
                                                                                              const SizedBox(height: 6.0),
                                                                                              CommonText(
                                                                                                name: skuDetail.quantityInCase!.toStringAsFixed(2),
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorBlack,
                                                                                                fontWeight: Constant.fontWeight500,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Align(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              CommonText(
                                                                                                name: "Outstanding Qty(MT)",
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorDullGray77,
                                                                                              ),
                                                                                              const SizedBox(height: 6.0),
                                                                                              CommonText(
                                                                                                name: skuDetail.quantityInMT!.toStringAsFixed(2),
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorBlack,
                                                                                                fontWeight: Constant.fontWeight500,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Align(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              CommonText(
                                                                                                name: "Rate(Rs.)",
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorDullGray77,
                                                                                              ),
                                                                                              const SizedBox(height: 6.0),
                                                                                              CommonText(
                                                                                                name: skuDetail.rate!.toStringAsFixed(2),
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorBlack,
                                                                                                fontWeight: Constant.fontWeight500,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: double.infinity,
                                                                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDFDFDF), width: 0.8))),
                                                                              padding: const EdgeInsets.only(bottom: 12),
                                                                            ),
                                                                          ],
                                                                        ));
                                                                  })
                                                            ],
                                                            onExpansionChanged: ((newState) {
                                                              if (newState) {
                                                                setState(() {
                                                                  selected = ind;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  selected = -1;
                                                                });
                                                              }
                                                            }),
                                                          ),
                                                        ));
                                                  })
                                              : const Visibility(visible: false, child: Text(""))
                                          : Constants.AUTH_ROLEID == Constants.SALE
                                              ? ListView.builder(
                                                  key: const Key('builder 1'),
                                                  //attention
                                                  padding: const EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: pendingContractDealerOutput.length,
                                                  itemBuilder: (context, index) {
                                                    return CurveOuterBox(
                                                        boxLRPadding: 0,
                                                        boxTBPadding: 4,
                                                        boxofWidget: Theme(
                                                          data: theme,
                                                          child: ExpansionTile(
                                                            tilePadding: EdgeInsets.zero,
                                                            initiallyExpanded: 1 == selected,
                                                            title: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  width: 3,
                                                                  height: 22,
                                                                  color: Constant.callToCcolor1,
                                                                  margin: const EdgeInsets.only(top: 3),
                                                                ),
                                                                const SizedBox(width: 16),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    CommonText(
                                                                      name: pendingContractDealerOutput[index].dealer!,
                                                                      fontColor: Constant.colorBlack,
                                                                      fontSize: Constant.fontSize13,
                                                                      fontWeight: Constant.fontWeight400,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            children: [
                                                              ListView.builder(
                                                                  key: const Key('builder 1'),
                                                                  //attention
                                                                  padding: const EdgeInsets.all(0),
                                                                  shrinkWrap: true,
                                                                  physics: const ClampingScrollPhysics(),
                                                                  itemCount: pendingContractDealerOutput[index].pendingContractSkuOutput!.length,
                                                                  itemBuilder: (context, ind) {
                                                                    return ListTile(
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        title: CurveOuterBox(
                                                                            boxShadowColor: const Color(0xFFFFFFFF),
                                                                            boxBorderWidth: 0,
                                                                            boxLRPadding: 0,
                                                                            boxTBPadding: 0,
                                                                            boxBRRadius: 5,
                                                                            boxofWidget: Column(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Color(0xFFF7F7F7),
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(25.0),
                                                                                      topRight: Radius.circular(5.0),
                                                                                      bottomLeft: Radius.circular(5.0),
                                                                                      bottomRight: Radius.circular(25.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                          width: double.infinity,
                                                                                          padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xFFF5F5F5),
                                                                                            borderRadius: BorderRadius.only(
                                                                                              topLeft: Radius.circular(25.0),
                                                                                              topRight: Radius.circular(5.0),
                                                                                              bottomLeft: Radius.circular(5.0),
                                                                                              bottomRight: Radius.circular(0.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                pendingContractDealerOutput[index].pendingContractSkuOutput![ind].sku!,
                                                                                                style: TextStyle(
                                                                                                    fontSize: Constant.fontSize13, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                                                                              ),
                                                                                              const SizedBox(height: 3),
                                                                                              CommonText(
                                                                                                name: "",
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorDullGray77,
                                                                                              ),
                                                                                            ],
                                                                                          )),
                                                                                      Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: getSkuDetails(
                                                                                              pendingContractDealerOutput[index].pendingContractSkuOutput![ind].pendingContractSkuDetails!))
                                                                                      //to do jere
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )));
                                                                  })
                                                            ],
                                                            onExpansionChanged: ((newState) {
                                                              if (newState) {
                                                                setState(() {
                                                                  selected = 1;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  selected = -1;
                                                                });
                                                              }
                                                            }),
                                                          ),
                                                        ));
                                                  })
                                              : ListView.builder(
                                                  key: const Key('builder 1'),
                                                  //attention
                                                  padding: const EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: pendingContractDealerOutput.length,
                                                  itemBuilder: (context, index) {
                                                    return CurveOuterBox(
                                                        boxLRPadding: 0,
                                                        boxTBPadding: 4,
                                                        boxofWidget: Theme(
                                                          data: theme,
                                                          child: ExpansionTile(
                                                            tilePadding: EdgeInsets.zero,
                                                            initiallyExpanded: 1 == selected,
                                                            title: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  width: 3,
                                                                  height: 22,
                                                                  color: Constant.callToCcolor1,
                                                                  margin: const EdgeInsets.only(top: 3),
                                                                ),
                                                                const SizedBox(width: 16),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    CommonText(
                                                                      name: pendingContractDealerOutput[index].dealer!,
                                                                      fontColor: Constant.colorBlack,
                                                                      fontSize: Constant.fontSize13,
                                                                      fontWeight: Constant.fontWeight400,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            children: [
                                                              ListView.builder(
                                                                  key: const Key('builder 1'),
                                                                  //attention
                                                                  padding: const EdgeInsets.all(0),
                                                                  shrinkWrap: true,
                                                                  physics: const ClampingScrollPhysics(),
                                                                  itemCount: pendingContractDealerOutput[index].pendingContractSkuOutput!.length,
                                                                  itemBuilder: (context, ind) {
                                                                    return ListTile(
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        title: CurveOuterBox(
                                                                            boxShadowColor: const Color(0xFFFFFFFF),
                                                                            boxBorderWidth: 0,
                                                                            boxLRPadding: 0,
                                                                            boxTBPadding: 0,
                                                                            boxBRRadius: 5,
                                                                            boxofWidget: Column(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Color(0xFFF7F7F7),
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(25.0),
                                                                                      topRight: Radius.circular(5.0),
                                                                                      bottomLeft: Radius.circular(5.0),
                                                                                      bottomRight: Radius.circular(25.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                          width: double.infinity,
                                                                                          padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xFFF5F5F5),
                                                                                            borderRadius: BorderRadius.only(
                                                                                              topLeft: Radius.circular(25.0),
                                                                                              topRight: Radius.circular(5.0),
                                                                                              bottomLeft: Radius.circular(5.0),
                                                                                              bottomRight: Radius.circular(0.0),
                                                                                            ),
                                                                                          ),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                pendingContractDealerOutput[index].pendingContractSkuOutput![ind].sku!,
                                                                                                style: TextStyle(
                                                                                                    fontSize: Constant.fontSize13, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                                                                              ),
                                                                                              const SizedBox(height: 3),
                                                                                              CommonText(
                                                                                                name: "",
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorDullGray77,
                                                                                              ),
                                                                                            ],
                                                                                          )),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 6),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Container(
                                                                                              width: double.infinity,
                                                                                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDFDFDF), width: 0.8))),
                                                                                              padding: const EdgeInsets.only(bottom: 12),
                                                                                            ),
                                                                                            const SizedBox(height: 16),
                                                                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                              CommonText(
                                                                                                name: "#" + pendingContractDealerOutput[index].pendingContractSkuOutput![ind].contractNumber!,
                                                                                                fontSize: Constant.fontSize13,
                                                                                                fontColor: Constant.colorBlack,
                                                                                              ),
                                                                                              CommonText(
                                                                                                name: (pendingContractDealerOutput[index].pendingContractSkuOutput![ind].contractValidFrom != null
                                                                                                        ? DateTimeUtils().dateToServerToDateFormat(
                                                                                                            pendingContractDealerOutput[index].pendingContractSkuOutput![ind].contractValidFrom!,
                                                                                                            DateTimeUtils.YYYY_MM_DD_Format,
                                                                                                            DateTimeUtils.DD_MMM_YYYY_Format)
                                                                                                        : "") +
                                                                                                    " to " +
                                                                                                    (pendingContractDealerOutput[index].pendingContractSkuOutput![ind].contractValidTo != null
                                                                                                        ? DateTimeUtils().dateToServerToDateFormat(
                                                                                                            pendingContractDealerOutput[index].pendingContractSkuOutput![ind].contractValidTo!,
                                                                                                            DateTimeUtils.YYYY_MM_DD_Format,
                                                                                                            DateTimeUtils.DD_MMM_YYYY_Format)
                                                                                                        : ""),
                                                                                                fontSize: Constant.fontSize13,
                                                                                                fontColor: Constant.colorBlack,
                                                                                              )
                                                                                            ]),
                                                                                            const SizedBox(height: 16),
                                                                                            Row(
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Align(
                                                                                                    alignment: Alignment.topLeft,
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        CommonText(
                                                                                                          name: "Pending Qty",
                                                                                                          fontSize: Constant.fontSize12,
                                                                                                          fontColor: Constant.colorDullGray77,
                                                                                                        ),
                                                                                                        const SizedBox(height: 6.0),
                                                                                                        CommonText(
                                                                                                          name: pendingContractDealerOutput[index]
                                                                                                              .pendingContractSkuOutput![ind]
                                                                                                              .quantityInCase!
                                                                                                              .toStringAsFixed(2),
                                                                                                          fontSize: Constant.fontSize12,
                                                                                                          fontColor: Constant.colorBlack,
                                                                                                          fontWeight: Constant.fontWeight500,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Align(
                                                                                                    alignment: Alignment.topLeft,
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        CommonText(
                                                                                                          name: "Outstanding Qty(MT)",
                                                                                                          fontSize: Constant.fontSize12,
                                                                                                          fontColor: Constant.colorDullGray77,
                                                                                                        ),
                                                                                                        const SizedBox(height: 6.0),
                                                                                                        CommonText(
                                                                                                          name: pendingContractDealerOutput[index]
                                                                                                              .pendingContractSkuOutput![ind]
                                                                                                              .quantityInMT!
                                                                                                              .toStringAsFixed(2),
                                                                                                          fontSize: Constant.fontSize12,
                                                                                                          fontColor: Constant.colorBlack,
                                                                                                          fontWeight: Constant.fontWeight500,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Align(
                                                                                                    alignment: Alignment.topLeft,
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        CommonText(
                                                                                                          name: "Rate(Rs.)",
                                                                                                          fontSize: Constant.fontSize12,
                                                                                                          fontColor: Constant.colorDullGray77,
                                                                                                        ),
                                                                                                        const SizedBox(height: 6.0),
                                                                                                        CommonText(
                                                                                                          name: pendingContractDealerOutput[index]
                                                                                                              .pendingContractSkuOutput![ind]
                                                                                                              .rate!
                                                                                                              .toStringAsFixed(2),
                                                                                                          fontSize: Constant.fontSize12,
                                                                                                          fontColor: Constant.colorBlack,
                                                                                                          fontWeight: Constant.fontWeight500,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )));
                                                                  })
                                                            ],
                                                            onExpansionChanged: ((newState) {
                                                              if (newState) {
                                                                setState(() {
                                                                  selected = 1;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  selected = -1;
                                                                });
                                                              }
                                                            }),
                                                          ),
                                                        ));
                                                  })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      )
                    : const Visibility(visible: true, child: Center(child: Text("No Data Found"))),
              ),
              progressBar
            ],
          ),
        )));
  }

  void updateSearchQuery(String newQuery) {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      var searchItem = searchSku(newQuery);
      setState(() {
        pendingContractSkuOutput = searchItem;
      });
    } else if (Constants.AUTH_ROLEID == Constants.SALE) {
      var searchItem = searchDealer(newQuery);
      setState(() {
        pendingContractDealerOutput = searchItem;
      });
    } else {
      // TESTED Done
      var searchItem = searchDealer(newQuery);
      setState(() {
        pendingContractDealerOutput = searchItem;
      });
    }
  }

  List<PendingContractDealerOutput> searchDealer(String input) {
    return searchPendingContractDealerOutput.where((e) => e.dealer!.toLowerCase().contains(input.toLowerCase())).toList();
  }

  List<PendingContractSkuOutput> searchSku(String input) {
    return searchPendingContractSkuOutput.where((e) => e.sku!.toLowerCase().contains(input.toLowerCase())).toList();
  }

  void showCustomFilterDialog(BuildContext context, messageValue, title, footerbutton, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
            key: _dialogKey,
            builder: (context, setState) {
              return AlertDialog(
                // insetPadding: const EdgeInsets.only(left: 20, right: 20),
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
                      constraints: const BoxConstraints(),
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
                content: Container(height: 400, width: double.infinity, padding: const EdgeInsets.only(left: 10, right: 10, top: 20), child: SingleChildScrollView(child: getDialogContent())),
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

  Widget getDialogContent() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Visibility(
          visible: Constants.AUTH_ROLEID == Constants.ZHMANAGER,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: 70,
                    child: CommonDropdownButtonFormField<BdoList>(
                      label: "Select BDO",
                      value: selectedBdo,
                      onChanged: (BdoList? newValue) {
                        setState(() {
                          selectedBdo = newValue!;
                        });
                        BlocProvider.of<PendingContractBloc>(context).add(LoadPendingContractScreen(
                            userId: Constants.AUTH_USERID, salesOrganizationId: 0, distributionChannelId: 0, divisonId: 0, bdoIds: selectedBdo!.id! != 0 ? [selectedBdo!.id!] : []));
                      },
                      items: bdoList.map<DropdownMenuItem<BdoList>>((value) {
                        return DropdownMenuItem<BdoList>(
                          value: value,
                          child: Text(value.name!, overflow: TextOverflow.visible),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: 16)
            ],
          )),
      Visibility(
          visible: Constants.AUTH_ROLEID == Constants.SALE,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: 70,
                    child: CommonDropdownButtonFormField<DistributorList>(
                      label: "Select Distributor",
                      value: selectedDistributor,
                      onChanged: (DistributorList? newValue) {
                        setState(() {
                          selectedDistributor = newValue!;
                        });
                      },
                      items: distributorList.map<DropdownMenuItem<DistributorList>>((value) {
                        return DropdownMenuItem<DistributorList>(
                          value: value,
                          child: Text(value.employeeName!, overflow: TextOverflow.visible),
                        );
                      }).toList(),
                    )),
              ),
            ],
          )),
      // const SizedBox(height: 16),
      Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: CommonDropdownButtonFormField<OilTypesPendingContractReport>(
            label: "Select Oil Type",
            value: selectedOilType,
            onChanged: (OilTypesPendingContractReport? newValue) {
              setState(() {
                selectedOilType = newValue!;
              });
              _dialogKey.currentState!.setState(() {});
            },
            items: oilTypes.map<DropdownMenuItem<OilTypesPendingContractReport>>((value) {
              return DropdownMenuItem<OilTypesPendingContractReport>(
                value: value,
                child: Text(value.oilTypeName!, overflow: TextOverflow.visible),
              );
            }).toList(),
          )),
      Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: InkWell(
              onTap: () {
                _showMultiSelectPackGroup(context);
              },
              child: CommonTextFormField(
                labeltxt: "Select PackGroup",
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
                keyborType: TextInputType.text,
                enabled: false,
                dropdownIcon: true,
                controllerTxt: _packgroupcontroller,
              ))),
      Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: InkWell(
              onTap: () {
                _showMultiSelectSku(context);
              },
              child: CommonTextFormField(
                labeltxt: "Select Material",
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
                keyborType: TextInputType.text,
                enabled: false,
                dropdownIcon: true,
                controllerTxt: _skucontroller,
              ))),
      Visibility(
          visible: Constants.AUTH_ROLEID != Constants.DEALER,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 70,
              child: InkWell(
                  onTap: () {
                    _showMultiSelectStates(context);
                  },
                  child: CommonTextFormField(
                    labeltxt: "Select States",
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
                    keyborType: TextInputType.text,
                    enabled: false,
                    dropdownIcon: true,
                    controllerTxt: _statecontroller,
                  ))))
    ]);
  }

  Widget dialogActionButtonFilter() {
    return SizedBox(
      // width: screenWidth * 0.8,
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
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
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
                List<int> skuIds = [];
                for (SkuandPackGroup p in selectedSkus!) {
                  skuIds.add(p.skuId!);
                }
                BlocProvider.of<PendingContractBloc>(context).add(LoadPendingContractData(
                    userId: Constants.AUTH_USERID,
                    id: Constants.AUTH_ROLEID == Constants.ZHMANAGER ? (selectedBdo != null ? selectedBdo!.id! : 0) : (selectedDistributor != null ? selectedDistributor!.id! : 0),
                    stateIds: const [],
                    skuIds: skuIds));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMultiSelectSku(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<SkuandPackGroup>(
          searchable: true,
          items: skuandPackGroups!.map((dist) => MultiSelectItem<SkuandPackGroup>(dist, dist.skuName!)).toList(),
          initialValue: selectedSkus!,
          onConfirm: (List<SkuandPackGroup> values) {
            selectedSkus = values;
            if (selectedSkus!.isNotEmpty) {
              _skucontroller.text = selectedSkus!.length.toString() + " Materials ";
            } else {
              _skucontroller.text = "All Materials";
            }
            _dialogKey.currentState!.setState(() {});
          },
        );
      },
    );
  }

  void _showMultiSelectPackGroup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<PackGroup>(
          searchable: true,
          items: packGroups!.map((dist) => MultiSelectItem<PackGroup>(dist, dist.name!)).toList(),
          initialValue: selectedPackGroups!,
          onConfirm: (List<PackGroup> values) {
            selectedPackGroups = values;
            if (selectedOilType!.oilTypeId == 0) {
              for (OilTypesPendingContractReport oiltype in oilTypes) {
                for (SkuandPackGroup sku in oiltype.skuandPackGroup!) {
                  if (selectedPackGroups!.where((element) => element.id == sku.packGroupId).isNotEmpty) {
                    skuandPackGroups!.add(sku);
                  }
                }
              }
            } else {
              for (SkuandPackGroup sku in selectedOilType!.skuandPackGroup!) {
                if (selectedPackGroups!.where((element) => element.id == sku.packGroupId).isNotEmpty) {
                  skuandPackGroups!.add(sku);
                }
              }
            }
            if (selectedPackGroups!.isNotEmpty) {
              _packgroupcontroller.text = selectedPackGroups!.length.toString() + " Pack groups ";
            } else {
              _packgroupcontroller.text = "All Packgroups";
            }
            _dialogKey.currentState!.setState(() {});
          },
        );
      },
    );
  }

  void _showMultiSelectStates(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<ActiveState>(
          searchable: true,
          items: stateList.map((dist) => MultiSelectItem<ActiveState>(dist, dist.stateName!)).toList(),
          initialValue: selectedStates!,
          onConfirm: (List<ActiveState> values) {
            selectedStates = values;
            if (selectedStates!.isNotEmpty) {
              _statecontroller.text = selectedStates!.length.toString() + " States ";
            } else {
              _statecontroller.text = "All States";
            }
            _dialogKey.currentState!.setState(() {});
          },
        );
      },
    );
  }

  List<Widget> getSkuDetails(List<PendingContractSkuDetails> skuDetails) {
    List<Widget> widgets = [];
    for (PendingContractSkuDetails detail in skuDetails) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDFDFDF), width: 0.8))),
              padding: const EdgeInsets.only(bottom: 12),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CommonText(
                name: "#" + detail.contractNumber!,
                fontSize: Constant.fontSize13,
                fontColor: Constant.colorBlack,
              ),
              CommonText(
                name: (detail.contractValidFrom != null ? DateTimeUtils().dateToServerToDateFormat(detail.contractValidFrom!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format) : "") +
                    " to " +
                    (detail.contractValidTo != null ? DateTimeUtils().dateToServerToDateFormat(detail.contractValidTo!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format) : ""),
                fontSize: Constant.fontSize13,
                fontColor: Constant.colorBlack,
              )
            ]),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          name: "Pending Qty",
                          fontSize: Constant.fontSize12,
                          fontColor: Constant.colorDullGray77,
                        ),
                        const SizedBox(height: 6.0),
                        CommonText(
                          name: detail.quantityInCase!.toStringAsFixed(2),
                          fontSize: Constant.fontSize12,
                          fontColor: Constant.colorBlack,
                          fontWeight: Constant.fontWeight500,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          name: "Outstanding Qty(MT)",
                          fontSize: Constant.fontSize12,
                          fontColor: Constant.colorDullGray77,
                        ),
                        const SizedBox(height: 6.0),
                        CommonText(
                          name: detail.quantityInMT!.toStringAsFixed(2),
                          fontSize: Constant.fontSize12,
                          fontColor: Constant.colorBlack,
                          fontWeight: Constant.fontWeight500,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          name: "Rate(Rs.)",
                          fontSize: Constant.fontSize12,
                          fontColor: Constant.colorDullGray77,
                        ),
                        const SizedBox(height: 6.0),
                        CommonText(
                          name: detail.rate!.toStringAsFixed(2),
                          fontSize: Constant.fontSize12,
                          fontColor: Constant.colorBlack,
                          fontWeight: Constant.fontWeight500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }
    return widgets;
  }
}
