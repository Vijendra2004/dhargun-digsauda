import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/pending_contract_filter_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sales_report_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/screen/reports/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:adaniwilmar/widget/multiselect/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/oil_pack_group_type_model.dart';
import '../../widget/widget.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc()
        ..add(LoadReportScreen(userId: Constants.AUTH_USERID, salesOrganizationId: 0, distributionChannelId: 0, divisonId: 0))
        ..add(LoadReportFilter(userId: Constants.AUTH_USERID))
        ..add(LoadBDO(userId: Constants.AUTH_USERID))
        ..add(LoadActiveStates(id: 0))
        ..add(LoadPlant(stateId: 0))
        ..add(LoadOilType(userId: Constants.AUTH_USERID, salesOrganizationId: 0, distributionChannelId: 0, divisonId: 0))
        ..add(LoadReportData(
            userId: Constants.AUTH_USERID,
            id: 0,
            bdoIds: const [],
            dealerIds: const [],
            stateIds: const [],
            isSales: false,
            oilTypeIds: const [],
            packGroupIds: const [],
            plantId: 0,
            oilPackGroupTypeId: 0,
            fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY_REPORT)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            nationalHeadIds: [Constants.AUTH_USERID],
            zhIds: const []))
        ..add(LoadReportData(
            userId: Constants.AUTH_USERID,
            id: 0,
            bdoIds: const [],
            dealerIds: const [],
            stateIds: const [],
            isSales: true,
            oilTypeIds: const [],
            packGroupIds: const [],
            plantId: 0,
            oilPackGroupTypeId: 0,
            fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY_REPORT)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            nationalHeadIds: [Constants.AUTH_USERID],
            zhIds: const [])),
      child: const Report(),
    );
  }
}

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<Report> with TickerProviderStateMixin {
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  List<String>? selectReport = [];
  String dropdownValue = 'One';

  List<OilPackGroupType> oilPackGroupType = [];
  OilPackGroupType oilPackGroupTypeValue = OilPackGroupType();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);

    indicatorColor = colors[0];
    oilPackGroupType.add(OilPackGroupType(name: "Select", id: 0));
    oilPackGroupType.add(OilPackGroupType(name: "BP", id: 1));
    oilPackGroupType.add(OilPackGroupType(name: "CP", id: 2));

    oilPackGroupTypeValue = oilPackGroupType[0];
  }

  List<DistributorList> distributorList = [];
  List<BdoList> bdoList = [];
  List<ActiveState> stateList = [];
  List<PackGroup>? packGroups = [];
  List<OilType> oilTypes = [];
  List<SkuandPackGroup>? skuandPackGroups = [];
  List<PlanDepotList> plants = [];
  PendingContractFilterValue filterValue = PendingContractFilterValue();
  ProgressBarHandler? _handler;
  double screenWidth = 0;
  double screenHeight = 0;
  final GlobalKey _dialogKey = GlobalKey();
  bool isQtyMTVisible = true;
  List<DistributorList>? selectedDistributors = [];
  List<BdoList>? selectedBdos = [];
  List<ActiveState>? selectedStates = [];
  List<PackGroup>? selectedPackGroups = [];
  List<OilType>? selectedOilTypes = [];
  PlanDepotList? selectedPlant;
  String saudaFromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY_REPORT)), DateTimeUtils.DD_MM_YYYY_Format);
  String saudaToDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);

  List<DistributorList>? selectedSaleDistributors = [];
  List<BdoList>? selectedSaleBdos = [];
  List<ActiveState>? selectedSaleStates = [];
  List<PackGroup>? selectedSalePackGroups = [];
  List<OilType>? selectedSaleOilTypes = [];
  PlanDepotList? selectedSalePlant;
  String salesFromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY_REPORT)), DateTimeUtils.DD_MM_YYYY_Format);
  String salesToDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);

  List<SalesReport> salesReport = [];
  List<SalesReport> saudaReport = [];
  SaudaNHReport saudaNHReport = SaudaNHReport(saudaNHReportStateList: <SaudaNHReportStateList>[]);
  double totalSalesQty = 0;
  double totalSaudaQty = 0;
  double totalSaudaQtyCase = 0;
  double totalSalesQtyCase = 0;
  String fromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY_REPORT)), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);

  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  final TextEditingController _packgroupcontroller = TextEditingController();
  final TextEditingController _statecontroller = TextEditingController();
  final TextEditingController _oiltypecontroller = TextEditingController();
  final TextEditingController _bdocontroller = TextEditingController();
  final TextEditingController _distributorController = TextEditingController();

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;

  int selected = 0 - 1;

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    if (tabController!.index == 0) {
      _fromdatecontroller.text = saudaFromDate;
      _todatecontroller.text = saudaToDate;
    } else {
      _fromdatecontroller.text = salesFromDate;
      _todatecontroller.text = salesToDate;
    }
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );

    Widget tabDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TabBar(
                      controller: tabController,
                      tabAlignment: TabAlignment.start,
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicatorWeight: 2,
                      indicator: tabController == 1
                          ? const BoxDecoration(
                              color: Color(0xFFF68C33),
                            )
                          : tabController == 2
                              ? const BoxDecoration(color: Colors.green)
                              : const BoxDecoration(
                                  color: Color(0xFFF68C33),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                      tabs: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.09,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  "Sauda Report",
                                  style: TextStyle(color: tabController?.index == 0 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                                ),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.08,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  "Sales Report",
                                  style: TextStyle(color: tabController?.index == 1 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ]),
                ),


                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: Constant.colorDullOrange,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          name: "From Date",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(height: 6.0),
                                        CommonText(
                                          name: saudaFromDate,
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
                                          name: "To Date",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(height: 6.0),
                                        CommonText(
                                          name: saudaToDate,
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
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                            color: Constant.colorDullOrange,
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                  InkWell(
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              isQtyMTVisible ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                              color: isQtyMTVisible ? Constant.colorOrange : Constant.saudaAppDullColor,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name: "Total Qty(MT)",
                                                  fontSize: Constant.fontSize12,
                                                  fontColor: Constant.colorDullGray77,
                                                ),
                                                const SizedBox(height: 6.0),
                                                CommonText(
                                                  name: totalSaudaQty.toStringAsFixed(2),
                                                  fontSize: Constant.fontSize12,
                                                  fontColor: Constant.colorBlack,
                                                  fontWeight: Constant.fontWeight500,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    onTap: () {
                                      setState(() {
                                        isQtyMTVisible = true;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                    child: InkWell(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Icon(
                                          !isQtyMTVisible ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                          color: !isQtyMTVisible ? Constant.colorOrange : Constant.saudaAppDullColor,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              name: "Total Qty(Case)",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorDullGray77,
                                            ),
                                            const SizedBox(height: 6.0),
                                            CommonText(
                                              name: totalSaudaQtyCase.toStringAsFixed(2),
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight: Constant.fontWeight500,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isQtyMTVisible = false;
                                    });
                                  },
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: CommonText(
                                  name: "Quantity",
                                  fontSize: Constant.fontSize13,
                                  fontColor: Constant.colorOrange,
                                  fontWeight: Constant.fontWeight600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(child: getSaudaReportWidget())
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: Constant.colorDullOrange,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          name: "From Date",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(height: 6.0),
                                        CommonText(
                                          name: salesFromDate,
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
                                          name: "To Date",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(height: 6.0),
                                        CommonText(
                                          name: salesToDate,
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
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                            color: Constant.colorDullOrange,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          name: "Total Qty(MT)",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(height: 6.0),
                                        CommonText(
                                          name: totalSalesQty.toStringAsFixed(2),
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
                                          name: "Total Qty(Case)",
                                          fontSize: Constant.fontSize12,
                                          fontColor: Constant.colorDullGray77,
                                        ),
                                        const SizedBox(height: 6.0),
                                        CommonText(
                                          name: totalSalesQtyCase.toStringAsFixed(2),
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
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: CommonText(
                                    name: "Quantity in Metric Ton(s)",
                                    fontSize: Constant.fontSize13,
                                    fontColor: Constant.colorOrange,
                                    fontWeight: Constant.fontWeight600,
                                  ))),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                                child: ListView.builder(
                                    key: const Key('builder 2'),
                                    //attention
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: salesReport.length,
                                    itemBuilder: (context, index) {
                                      return Column(children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              HeadingSix(
                                                headingSix: salesReport[index].oilType,
                                                heaingSize: Constant.fontSize13,
                                                headingWeight: Constant.fontWeight500,
                                                headingColor: Constant.colorBlack,
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          CommonText(
                                                            name: "Total Qty(MT)",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorDullGray77,
                                                          ),
                                                          const SizedBox(height: 6.0),
                                                          CommonText(
                                                            name: salesReport[index].quantityInMT!.toStringAsFixed(2) + " MT",
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
                                                            name: "Total Qty(Case)",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorDullGray77,
                                                          ),
                                                          const SizedBox(height: 6.0),
                                                          CommonText(
                                                            name: (salesReport[index].premiumquantityInMT != null ? salesReport[index].quantityCase!.toStringAsFixed(2) : "0.00"),
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
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          CommonText(
                                                            name: "Premium",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorDullGray77,
                                                          ),
                                                          const SizedBox(height: 6.0),
                                                          CommonText(
                                                            name: (salesReport[index].premiumquantityInMT != null ? salesReport[index].premiumquantityInMT!.toStringAsFixed(2) : "0.00"),
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
                                                            name: "Bakery",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorDullGray77,
                                                          ),
                                                          const SizedBox(height: 6.0),
                                                          CommonText(
                                                            name: (salesReport[index].bakeryquantityInMT != null ? salesReport[index].bakeryquantityInMT!.toStringAsFixed(2) : "0.00"),
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
                                                            name: "Lauric",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorDullGray77,
                                                          ),
                                                          const SizedBox(height: 6.0),
                                                          CommonText(
                                                            name: (salesReport[index].lauricquantityInMT != null ? salesReport[index].lauricquantityInMT!.toStringAsFixed(2) : "0.00"),
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
                                                            name: "Popular",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorDullGray77,
                                                          ),
                                                          const SizedBox(height: 6.0),
                                                          CommonText(
                                                            name: (salesReport[index].popularquantityInMT != null ? salesReport[index].popularquantityInMT!.toStringAsFixed(2) : "0.00"),
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
                                              const SizedBox(height: 10.0),
                                            ],
                                          ),
                                        ),
                                        const BorderBottom(bordeSize: 0.8, bottomColor: Color(0xFFE6EBF8)),
                                      ]);
                                    })),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );

    return BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            selectedDistributors = [];
            _distributorController.text = "All Distributors";
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadBDO) {
            selectedDistributors = [];
            selectedBdos = [];
            _bdocontroller.text = "All State Traders";
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnLoadStates) {
            selectedStates = [];
            _statecontroller.text = "All States";
            stateList = state.states;
            setState(() {});
          }
          if (state is OnLoadPlant) {
            selectedPlant = null;
            plants = state.plantList;
            setState(() {});
          }
          if (state is OnLoadOilType) {
            selectedOilTypes = [];
            _oiltypecontroller.text = "All ";
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnReportFilterSuccess) {
            selectedPackGroups = [];
            _packgroupcontroller.text = "All Packgroups";
            packGroups = state.pendingContractFilters.packGroup!;
            setState(() {});
          }
          if (state is OnReportDataSuccess) {
            if (state.isSales) {
              salesReport = state.reportData;
            } else {
              saudaReport = state.reportData;
            }
            getTotalQty();
            getTotalQtyCase();
            setState(() {});
          }
          if (state is OnNHReportDataSuccess) {
            saudaNHReport = state.reportData;
            totalSaudaQty = saudaNHReport.totalQuantity!;
            totalSaudaQtyCase = saudaNHReport.quantityCase!;
            setState(() {});
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar && _handler != null) {
            _handler!.dismiss!();
          }
          if (state is OnFailureInReport) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connection Timeout!")));
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Reports ",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showCustomFilterDialog(context, "Reports Filter", "Reports Filter", dialogActionButtonFilter());
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
                height: screenHeight * 0.980,
                margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                child: CurveBorderBox(boxLRPadding: 0, boxofWidget: tabDetails),
              ),
              progressBar
            ],
          ),
        )));
  }

  void showCustomFilterDialog(BuildContext context, messageValue, title, footerbutton, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    resetDialog();
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
                  padding: const EdgeInsets.all(16),
                  child: Text(tabController!.index == 0 ? "Sauda Filter" : "Sales Filter",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: Constant.fontSize15,
                        fontWeight: Constant.fontWeight500,
                      )),
                ),
                content: Container(
                    height: (Constants.AUTH_ROLEID == Constants.ZHMANAGER || Constants.AUTH_ROLEID == Constants.SALE)
                        ? 510
                        : Constants.AUTH_ROLEID != Constants.DEALER
                            ? 440
                            : 400,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: SingleChildScrollView(child: getDialogContent())),
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
          child: Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 70,
              child: InkWell(
                  onTap: () {
                    _showMultiSelectBdo(context);
                  },
                  child: CommonTextFormField(
                    labeltxt: "Select Bdos",
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
                    controllerTxt: _bdocontroller,
                  )))),
      Visibility(
        visible: Constants.AUTH_ROLEID == Constants.SALE,
        child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: 70,
            child: InkWell(
                onTap: () {
                  _showMultiSelectDistributor(context);
                },
                child: CommonTextFormField(
                  labeltxt: "Select Distributor",
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
                  controllerTxt: _distributorController,
                ))),
      ),
      Visibility(
          visible: Constants.AUTH_ROLEID != Constants.DEALER,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 70,
              child: CommonDropdownButtonFormField<PlanDepotList>(
                value: tabController!.index == 0 ? selectedPlant : selectedSalePlant,
                label: "Select Plant",
                onChanged: (PlanDepotList? newValue) {
                  if (newValue == null) return;
                  setState(() {
                    if (tabController!.index == 0) {
                      selectedPlant = newValue;
                    } else {
                      selectedSalePlant = newValue;
                    }
                  });
                },
                items: plants.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.name!, overflow: TextOverflow.visible),
                  );
                }).toList(),
              ))),
      Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: InkWell(
              onTap: () {
                _showMultiSelectOilType(context);
              },
              child: CommonTextFormField(
                labeltxt: "Select OilType",
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
                controllerTxt: _oiltypecontroller,
              ))),
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
                  )))),
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: 70,
            child: CommonDropdownButtonFormField<OilPackGroupType>(
              value: oilPackGroupTypeValue,
              label: "Pack Group Type",
              onChanged: (OilPackGroupType? newValue) {
                setState(() {
                  oilPackGroupTypeValue = newValue!;
                });
                /* BlocProvider.of<NewSaudaBloc>(
                    context).add(
                    LoadDistributionChannel(
                        id: selectedSalesOrg!
                            .id!));*/
              },
              items: oilPackGroupType.map<DropdownMenuItem<OilPackGroupType>>((value) {
                return DropdownMenuItem<OilPackGroupType>(
                  value: value,
                  child: Text(value.name!),
                );
              }).toList(),
            ));
      }),
      Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: InkWell(
              onTap: () {
                _selectFromDate(context);
              },
              child: CommonTextFormField(
                labeltxt: "From Date",
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
              ))),
      Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: InkWell(
              onTap: () {
                _selectToDate(context);
              },
              child: CommonTextFormField(
                labeltxt: "To Date",
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
              ))),
    ]);
  }

  Widget getSaudaReportWidget() {
    if (!(tabController!.index == 0 ? false : true)) {
      return ListView.builder(
          key: const Key('builder 1'),
          //attention
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: saudaNHReport.saudaNHReportStateList.length,
          itemBuilder: (context, parentIndex) {
            return CurveOuterBox(
                boxLRPadding: 0,
                boxTBPadding: 2,
                boxofWidget: ExpansionTile(
                  children: [
                    ListView.builder(
                      key: const Key('builder 2'),
                      //attention
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList.length,
                      itemBuilder: (context, index) {
                        return CurveOuterBox(
                          boxLRPadding: 0,
                          boxTBPadding: 2,
                          boxofWidget: ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CommonText(
                                      name: "Oil Type",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorDullGray77,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    HeadingSix(
                                      headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].oilType,
                                      heaingSize: Constant.fontSize13,
                                      headingWeight: Constant.fontWeight500,
                                      headingColor: Constant.colorBlack,
                                    ),
                                  ],
                                ),
                                isQtyMTVisible
                                    ? Column(
                                        children: [
                                          CommonText(
                                            name: "Qty(MT)",
                                            fontSize: Constant.fontSize12,
                                            fontColor: Constant.colorDullGray77,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          HeadingSix(
                                            headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].totalOilTypeQuantity!.toStringAsFixed(2),
                                            heaingSize: Constant.fontSize13,
                                            headingWeight: Constant.fontWeight500,
                                            headingColor: Constant.colorBlack,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          CommonText(
                                            name: "Qty(Case)",
                                            fontSize: Constant.fontSize12,
                                            fontColor: Constant.colorDullGray77,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          HeadingSix(
                                            headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].quantityCase!.toStringAsFixed(2),
                                            heaingSize: Constant.fontSize13,
                                            headingWeight: Constant.fontWeight500,
                                            headingColor: Constant.colorBlack,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5, left: 14, right: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      name: "Material Name",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorDullGray77,
                                    ),
                                    !isQtyMTVisible
                                        ? Text(
                                            "Qty(Case)",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: Constant.fontSize12,
                                              color: Constant.colorDullGray77,
                                            ),
                                          )
                                        : Text(
                                            "Qty(MT)",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: Constant.fontSize12,
                                              color: Constant.colorDullGray77,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                physics: const ClampingScrollPhysics(),
                                itemCount: saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].saudaListReport!.length,
                                itemBuilder: (context, idx) {
                                  return Container(
                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5, left: 14, right: 14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: HeadingSix(
                                            headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].saudaListReport![idx].skuName.toString(),
                                            heaingSize: Constant.fontSize13,
                                            headingWeight: Constant.fontWeight500,
                                            headingColor: Constant.colorBlack,
                                          ),
                                        ),
                                        Expanded(
                                          child: !isQtyMTVisible
                                              ? Text(
                                                  saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].saudaListReport![idx].bidQuantityCase.toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: Constant.fontSize13,
                                                    fontWeight: Constant.fontWeight500,
                                                    color: Constant.colorBlack,
                                                  ),
                                                )
                                              : Text(
                                                  saudaNHReport.saudaNHReportStateList[parentIndex].saudaNHReportOilTypeList[index].saudaListReport![idx].bidQuantity.toString(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: Constant.fontSize13,
                                                    fontWeight: Constant.fontWeight500,
                                                    color: Constant.colorBlack,
                                                  ),
                                                ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CommonText(
                            name: "State",
                            fontSize: Constant.fontSize12,
                            fontColor: Constant.colorDullGray77,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          HeadingSix(
                            headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].stateName,
                            heaingSize: Constant.fontSize13,
                            headingWeight: Constant.fontWeight500,
                            headingColor: Constant.colorBlack,
                          ),
                        ],
                      ),
                      isQtyMTVisible
                          ? Column(
                              children: [
                                CommonText(
                                  name: "Qty(MT)",
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorDullGray77,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                HeadingSix(
                                  headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].totalStateQuantity!.toStringAsFixed(2),
                                  heaingSize: Constant.fontSize13,
                                  headingWeight: Constant.fontWeight500,
                                  headingColor: Constant.colorBlack,
                                ),
                              ],
                            )
                          : Column(
                              //base list
                              children: [
                                CommonText(
                                  name: "Qty(Case)",
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorDullGray77,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                HeadingSix(
                                  headingSix: saudaNHReport.saudaNHReportStateList[parentIndex].totalQuantityCase!.toStringAsFixed(2),
                                  heaingSize: Constant.fontSize13,
                                  headingWeight: Constant.fontWeight500,
                                  headingColor: Constant.colorBlack,
                                ),
                              ],
                            ),
                    ],
                  ),
                ));
          });
    } else {
      return ListView.builder(
        key: const Key('builder 1'),
        //attention
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: saudaReport.length,
        itemBuilder: (context, index) {
          return CurveOuterBox(
            boxLRPadding: 0,
            boxTBPadding: 2,
            boxofWidget: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CommonText(
                        name: "Oil Type",
                        fontSize: Constant.fontSize12,
                        fontColor: Constant.colorDullGray77,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      HeadingSix(
                        headingSix: saudaReport[index].oilType,
                        heaingSize: Constant.fontSize13,
                        headingWeight: Constant.fontWeight500,
                        headingColor: Constant.colorBlack,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CommonText(
                        name: "Quantity",
                        fontSize: Constant.fontSize12,
                        fontColor: Constant.colorDullGray77,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      HeadingSix(
                        headingSix: saudaReport[index].quantityInMT!.toStringAsFixed(2),
                        heaingSize: Constant.fontSize13,
                        headingWeight: Constant.fontWeight500,
                        headingColor: Constant.colorBlack,
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        name: "Material Name",
                        fontSize: Constant.fontSize12,
                        fontColor: Constant.colorDullGray77,
                      ),
                      CommonText(
                        name: "Quantity",
                        fontSize: Constant.fontSize12,
                        fontColor: Constant.colorDullGray77,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5),
                  physics: const ClampingScrollPhysics(),
                  itemCount: saudaReport[index].skuReport!.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: HeadingSix(
                              headingSix: saudaReport[index].skuReport![idx].skuName.toString(),
                              heaingSize: Constant.fontSize13,
                              headingWeight: Constant.fontWeight500,
                              headingColor: Constant.colorBlack,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          HeadingSix(
                            headingSix: saudaReport[index].skuReport![idx].bidQuantity.toString(),
                            heaingSize: Constant.fontSize13,
                            headingWeight: Constant.fontWeight500,
                            headingColor: Constant.colorBlack,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget dialogActionButtonFilter() {
    return SizedBox(
      // width: screenWidth * 0.84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(width: 9),
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
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
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
              buttonFunction: () async {
                int plantId = 0;
                List<int> nationalHeadIds = [];
                List<int> zhIds = [];
                List<int> bdoIds = [];
                List<int> dealerIds = [];
                List<int> stateIds = [];
                List<int> oilTypeIds = [];
                List<int> packGroupIds = [];
                // GMLogger.v(tabController!.index.toString());
                if (tabController!.index == 0) {
                  if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
                    zhIds.add(Constants.AUTH_USERID);
                    for (BdoList d in selectedBdos!) {
                      bdoIds.add(d.id!);
                    }
                  } else if (Constants.AUTH_ROLEID == Constants.SALE) {
                    bdoIds.add(Constants.AUTH_USERID);
                    for (DistributorList d in selectedDistributors!) {
                      dealerIds.add(d.id!);
                    }
                  } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                    nationalHeadIds.add(Constants.AUTH_USERID);
                  }
                  for (ActiveState d in selectedStates!) {
                    stateIds.add(d.stateId!);
                  }
                  for (OilType d in selectedOilTypes!) {
                    oilTypeIds.add(d.id!);
                  }
                  for (PackGroup d in selectedPackGroups!) {
                    packGroupIds.add(d.id!);
                  }
                  if (selectedPlant != null) {
                    plantId = selectedPlant!.id!;
                  }
                } else {
                  if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
                    zhIds.add(Constants.AUTH_USERID);
                    for (BdoList d in selectedSaleBdos!) {
                      bdoIds.add(d.id!);
                    }
                  } else if (Constants.AUTH_ROLEID == Constants.SALE) {
                    bdoIds.add(Constants.AUTH_USERID);
                    for (DistributorList d in selectedSaleDistributors!) {
                      dealerIds.add(d.id!);
                    }
                  } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                    nationalHeadIds.add(Constants.AUTH_USERID);
                  }
                  for (ActiveState d in selectedSaleStates!) {
                    stateIds.add(d.stateId!);
                  }
                  for (OilType d in selectedSaleOilTypes!) {
                    oilTypeIds.add(d.id!);
                  }
                  for (PackGroup d in selectedSalePackGroups!) {
                    packGroupIds.add(d.id!);
                  }
                  if (selectedSalePlant != null) {
                    plantId = selectedSalePlant!.id!;
                  }
                }
                BlocProvider.of<ReportBloc>(context).add(LoadReportData(
                    userId: Constants.AUTH_USERID,
                    oilPackGroupTypeId: oilPackGroupTypeValue.id ?? 1,
                    id: Constants.AUTH_USERID,
                    bdoIds: bdoIds,
                    dealerIds: dealerIds,
                    stateIds: stateIds,
                    isSales: tabController!.index == 0 ? false : true,
                    oilTypeIds: oilTypeIds,
                    packGroupIds: packGroupIds,
                    plantId: plantId,
                    fromDate: DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                    toDate: DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                    nationalHeadIds: nationalHeadIds,
                    zhIds: zhIds));

                Navigator.pop(context);
                setTheDateToUI();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMultiSelectOilType(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<OilType>(
          searchable: true,
          items: oilTypes.map((dist) => MultiSelectItem<OilType>(dist, dist.name!)).toList(),
          initialValue: tabController!.index == 0 ? selectedOilTypes! : selectedSaleOilTypes!,
          onConfirm: (List<OilType> values) {
            if (tabController!.index == 0) {
              selectedOilTypes = values;
              if (selectedOilTypes!.isNotEmpty) {
                _oiltypecontroller.text = selectedOilTypes!.length.toString() + " Oil Types ";
              } else {
                _oiltypecontroller.text = "All OilTypes";
              }
            } else {
              selectedSaleOilTypes = values;
              if (selectedSaleOilTypes!.isNotEmpty) {
                _oiltypecontroller.text = selectedSaleOilTypes!.length.toString() + " Oil Types ";
              } else {
                _oiltypecontroller.text = "All OilTypes";
              }
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
          initialValue: tabController!.index == 0 ? selectedPackGroups! : selectedSalePackGroups!,
          onConfirm: (List<PackGroup> values) {
            if (tabController!.index == 0) {
              selectedPackGroups = values;
              if (selectedPackGroups!.isNotEmpty) {
                _packgroupcontroller.text = selectedPackGroups!.length.toString() + " Pack groups ";
              } else {
                _packgroupcontroller.text = "All Packgroups";
              }
            } else {
              selectedSalePackGroups = values;
              if (selectedSalePackGroups!.isNotEmpty) {
                _packgroupcontroller.text = selectedSalePackGroups!.length.toString() + " Pack groups ";
              } else {
                _packgroupcontroller.text = "All Packgroups";
              }
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
          initialValue: tabController!.index == 0 ? selectedStates! : selectedSaleStates!,
          onConfirm: (List<ActiveState> values) {
            if (tabController!.index == 0) {
              selectedStates = values;
              if (selectedStates!.isNotEmpty) {
                _statecontroller.text = selectedStates!.length.toString() + " States ";
              } else {
                _statecontroller.text = "All States";
              }
            } else {
              selectedSaleStates = values;
              if (selectedSaleStates!.isNotEmpty) {
                _statecontroller.text = selectedSaleStates!.length.toString() + " States ";
              } else {
                _statecontroller.text = "All States";
              }
            }
            _dialogKey.currentState!.setState(() {});
          },
        );
      },
    );
  }

  void _showMultiSelectDistributor(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<DistributorList>(
          searchable: true,
          items: distributorList.map((dist) => MultiSelectItem<DistributorList>(dist, dist.employeeName!)).toList(),
          initialValue: tabController!.index == 0 ? selectedDistributors! : selectedSaleDistributors!,
          onConfirm: (List<DistributorList> values) {
            if (tabController!.index == 0) {
              selectedDistributors = values;
              if (selectedDistributors!.isNotEmpty) {
                _distributorController.text = selectedDistributors!.length.toString() + " Distributors ";
              } else {
                _distributorController.text = "All Distributors";
              }
            } else {
              selectedSaleDistributors = values;
              if (selectedSaleDistributors!.isNotEmpty) {
                _distributorController.text = selectedSaleDistributors!.length.toString() + " Distributors ";
              } else {
                _distributorController.text = "All Distributors";
              }
            }
          },
        );
      },
    );
  }

  void _showMultiSelectBdo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
          searchable: true,
          items: bdoList.map((dist) => MultiSelectItem<BdoList>(dist, dist.name!)).toList(),
          initialValue: tabController!.index == 0 ? selectedBdos! : selectedSaleBdos!,
          onConfirm: (List<BdoList> values) {
            if (tabController!.index == 0) {
              selectedBdos = values;
              if (selectedBdos!.isNotEmpty) {
                _bdocontroller.text = selectedBdos!.length.toString() + " Bdos ";
              } else {
                _bdocontroller.text = "All State Traders";
              }
            } else {
              selectedSaleBdos = values;
              if (selectedSaleBdos!.isNotEmpty) {
                _bdocontroller.text = selectedSaleBdos!.length.toString() + " State Traders ";
              } else {
                _bdocontroller.text = "All State Traders";
              }
            }
          },
        );
      },
    );
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      _todatecontroller.text = "";
      /*if (tabController!.index == 0) {
        saudaFromDate = _fromdatecontroller.text.toString();
      } else {
        salesFromDate = _fromdatecontroller.text.toString();
      }*/
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.ServerFormat2)),
        lastDate:
            DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.ServerFormat2)).add(const Duration(days: 30)));
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      /*if (tabController!.index == 0) {
        saudaToDate = _todatecontroller.text.toString();
      } else {
        salesToDate = _todatecontroller.text.toString();
      }*/
    }
  }

  void getTotalQty() {
    if (salesReport.isNotEmpty) {
      totalSalesQty = 0;
      for (SalesReport s in salesReport) {
        totalSalesQty = totalSalesQty + s.quantityInMT!;
      }
    }
    if (saudaReport.isNotEmpty) {
      totalSaudaQty = 0;
      for (SalesReport s in saudaReport) {
        totalSaudaQty = totalSaudaQty + s.quantityInMT!;
      }
    }
    setState(() {});
  }

  void getTotalQtyCase() {
    if (salesReport.isNotEmpty) {
      totalSalesQtyCase = 0;
      for (SalesReport s in salesReport) {
        totalSalesQtyCase = totalSalesQtyCase + s.quantityCase!;
      }
    }
    if (saudaReport.isNotEmpty) {
      totalSaudaQtyCase = 0;
      for (SalesReport s in saudaReport) {
        totalSaudaQtyCase = totalSaudaQtyCase + s.quantityCase!;
      }
    }
    setState(() {});
  }

  resetDialog() {
    if (tabController!.index == 0) {
      if (selectedBdos!.isNotEmpty) {
        _bdocontroller.text = selectedBdos!.length.toString() + " State Traders ";
      } else {
        _bdocontroller.text = "All State Traders";
      }
      if (selectedDistributors!.isNotEmpty) {
        _distributorController.text = selectedDistributors!.length.toString() + " Distributors ";
      } else {
        _distributorController.text = "All Distributors";
      }
      if (selectedStates!.isNotEmpty) {
        _statecontroller.text = selectedStates!.length.toString() + " States ";
      } else {
        _statecontroller.text = "All States";
      }
      if (selectedPackGroups!.isNotEmpty) {
        _packgroupcontroller.text = selectedPackGroups!.length.toString() + " Pack groups ";
      } else {
        _packgroupcontroller.text = "All Packgroups";
      }
      if (selectedOilTypes!.isNotEmpty) {
        _oiltypecontroller.text = selectedOilTypes!.length.toString() + " Oil Types ";
      } else {
        _oiltypecontroller.text = "All OilTypes";
      }
    } else {
      if (selectedSaleBdos!.isNotEmpty) {
        _bdocontroller.text = selectedSaleBdos!.length.toString() + " Bdos ";
      } else {
        _bdocontroller.text = "All State Traders";
      }
      if (selectedSaleDistributors!.isNotEmpty) {
        _distributorController.text = selectedSaleDistributors!.length.toString() + " Distributors ";
      } else {
        _distributorController.text = "All Distributors";
      }
      if (selectedSaleStates!.isNotEmpty) {
        _statecontroller.text = selectedSaleStates!.length.toString() + " States ";
      } else {
        _statecontroller.text = "All States";
      }
      if (selectedSalePackGroups!.isNotEmpty) {
        _packgroupcontroller.text = selectedSalePackGroups!.length.toString() + " Pack groups ";
      } else {
        _packgroupcontroller.text = "All Packgroups";
      }
      if (selectedSaleOilTypes!.isNotEmpty) {
        _oiltypecontroller.text = selectedSaleOilTypes!.length.toString() + " Oil Types ";
      } else {
        _oiltypecontroller.text = "All OilTypes";
      }
    }
  }

  void setTheDateToUI() {
    if (tabController!.index == 1) {
      salesFromDate = _fromdatecontroller.text;
      salesToDate = _todatecontroller.text;
      salesReport.clear();
    } else if (tabController!.index == 0) {
      saudaFromDate = _fromdatecontroller.text;
      saudaToDate = _todatecontroller.text;
      saudaNHReport.saudaNHReportStateList.clear();
    }
    setState(() {});
  }
}
