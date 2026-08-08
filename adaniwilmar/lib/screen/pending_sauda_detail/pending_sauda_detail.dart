import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_slab.dart';
import 'package:adaniwilmar/screen/pending_sauda_detail/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/dealer_pending_sauda_sales.dart';
import '../../models/pending_sauda_distributor_details_response.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/widget.dart';
import '../packgroup_invoice_detail/packgroup_invoice_detail.dart';
import '../sauda_detail_view/sauda_detail_view.dart';

class PendingSaudaDetailScreen extends StatelessWidget {
  int dealerId = 0;
  PendingSaudaSlab saudaSlab;
  int sindex = -1;

  PendingSaudaDetailScreen({required this.dealerId, required this.saudaSlab, required this.sindex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingSaudaDetailBloc()
        ..add(LoadPendingSaudaDetailSalesScreen(
          userId: Constants.AUTH_USERID,
          bdoIds: [Constants.AUTH_USERID],
          dealerIds: [],
          creditId: 0,
        ))
        ..add(LoadSalesOrganization(id: Constants.AUTH_USERID, saudaBookingTypeId: 0))
        ..add(LoadDealerDetail(id: dealerId, salesOrgId: 0, distributionId: 0, divisionId: 0))
        ..add(LoadDealerSaudaList(
            id: dealerId,
            salesOrgId: 0,
            distributionId: 0,
            divisionId: 0,
            fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: -Constants.REPORT_MAX_DAY)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format)))
        ..add(LoadSalesScreen(
            dealerId: dealerId,
            userId: Constants.AUTH_USERID,
            packGroupId: 0,
            statusId: 0,
            fromDate: DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: -Constants.REPORT_MAX_DAY)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format))),
      child: PendingSaudaDetails(
        dealerId: dealerId,
        saudaSlab: saudaSlab,
        sindex: sindex,
      ),
    );
  }
}

class PendingSaudaDetails extends StatefulWidget {
  int dealerId = 0;
  PendingSaudaSlab saudaSlab;
  int sindex = -1;

  PendingSaudaDetails({required this.dealerId, required this.saudaSlab, required this.sindex, Key? key}) : super(key: key);

  @override
  State<PendingSaudaDetails> createState() => _PendingSaudaDetailState();
}

class _PendingSaudaDetailState extends State<PendingSaudaDetails> with TickerProviderStateMixin {
  List<DistributorList> distributorList = [];
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  TabController? innerTabController;
  Color? indicatorColor;
  Color? innerIndicatorColor;
  String toDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String fromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(Duration(days: Constants.REPORT_MAX_DAY_PENDING_SAUDA)), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);
    innerTabController = TabController(length: 2, vsync: this);
    innerTabController?.addListener(_handleInnerTabSelection);

    indicatorColor = colors[0];
    innerIndicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void _handleInnerTabSelection() {
    setState(() {});
  }

  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];

  List<PendingSaudaList> pendingSaudaList = [];
  List<PendingSaudaList> pendingSaudaList1 = [];
  List<PendingSaudaList> dealerPendingSaudaList = [];
  List<PendingSauda> distrPendingSaudaList = [];
  List<PendingSauda> distrAllPendingSaudaList = [];
  List<PendingSaudaList> dealerSaudaList = [];
  List<DealerSaudaList> dealerSalesList = [];
  DealerDetail dealerDetail = DealerDetail();
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  bool constructVertical = false;

  ProgressBarHandler? _handler;
  double screenWidth = 0;
  double screenHeight = 0;

  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  List<int> dealerIds = [];
  DealerPendingSales invoices = DealerPendingSales();

  final GlobalKey _dialogKey = GlobalKey();

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    _fromdatecontroller.text = fromDate;
    _todatecontroller.text = toDate;
    int selected = 0 - 1;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<PendingSaudaDetailBloc, PendingSaudaDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            pendingSaudaList1 = [];
            pendingSaudaList = state.pendingSauda;
            for (PendingSaudaList s in pendingSaudaList) {
              PendingSaudaList mPendingSauda = PendingSaudaList();
              mPendingSauda.saudaListOutputs = [];
              for (SaudaListOutputs saudaListOutput in s.saudaListOutputs!) {
                if (saudaListOutput.dealerId == widget.dealerId) {
                  mPendingSauda.biddingDate = s.biddingDate;
                  mPendingSauda.saudaListOutputs?.add(saudaListOutput);
                }
              }
              pendingSaudaList1.add(mPendingSauda);
            }
            pendingSaudaList = pendingSaudaList1;

            for (PendingSaudaList s in pendingSaudaList) {
              if (s.biddingDate != null) {
                int days = daysBetween(DateTimeUtils().stringToDate(s.biddingDate!, DateTimeUtils.YYYY_MM_DD_Format), DateTime.now());
                if (widget.sindex == 3 && days >= widget.saudaSlab.fromValue!) {
                  dealerPendingSaudaList.add(s);
                } else if (widget.sindex == 2 && days >= widget.saudaSlab.fromValue! && days <= widget.saudaSlab.toValue!) {
                  dealerPendingSaudaList.add(s);
                } else if (widget.sindex == 1 && days >= widget.saudaSlab.fromValue! && days <= widget.saudaSlab.toValue!) {
                  dealerPendingSaudaList.add(s);
                } else if (widget.sindex == 0 && days <= widget.saudaSlab.toValue!) {
                  dealerPendingSaudaList.add(s);
                }
              }
            }
            setState(() {});
          }
          if (state is OnLoadSalesSuccess) {
            invoices = state.dealerInvoiceResponse;
            setState(() {});
          }
          if (state is OnLoadPendingSaudaDetail) {
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadDealerDetail) {
            dealerDetail = state.dealerDetail;
            setState(() {});
          }
          if (state is OnLoadDealerSaudaList) {
            dealerSaudaList = state.saudaList;
            setState(() {});
          }
          if (state is OnLoadDealerSalesList) {
            dealerSalesList = state.salesList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            setState(() {});
          }
          if (state is OnLoadDistributionChannel) {
            if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {
              _dialogKey.currentState!.setState(() {
                selectedDistrChannel = null;
                selectedVertical = null;
                verticals = [];
                distrChannels = state.distributionChannel;
              });
            }
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {
              _dialogKey.currentState!.setState(() {
                selectedVertical = null;
                verticals = [];
                verticals = state.verticalList;
              });
            }
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
            title: dealerDetail != null && dealerDetail.dealerName != null ? dealerDetail.dealerName : "Pending Sauda",
            backArrow: true,
            listOfActions: Row(
              children: [
                Visibility(
                    visible: true,
                    child: IconButton(
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
                    )),
              ],
            ),
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  height: screenHeight,
                  width: screenWidth,
                  margin: const EdgeInsets.only(top: 50),
                  child: CurveOuterBox(
                    boxTBPadding: 1,
                    boxLRPadding: 1,
                    boxofWidget: Container(
                      color: Colors.transparent,
                      width: screenWidth,
                      height: screenHeight * 0.970,
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
                                            "Pending Sauda ",
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
                                            "Distributor Details",
                                            style: TextStyle(color: tabController?.index == 1 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Expanded(
                            // height: screenHeight * 0.890,
                            // width: screenWidth,
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                Container(
                                  height: screenHeight * 0.70,
                                  width: screenWidth,
                                  margin: const EdgeInsets.only(top: 5),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: dealerPendingSaudaList.length,
                                      itemBuilder: (context, index) {
                                        return CurveOuterBox(
                                            boxLRPadding: 0,
                                            boxTBPadding: 7,
                                            boxofWidget: Theme(
                                              data: theme,
                                              child: ExpansionTile(
                                                tilePadding: const EdgeInsets.only(right: 15),
                                                key: Key(index.toString()),
                                                initiallyExpanded: index == selected,
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
                                                          name: DateTimeUtils()
                                                              .dateToServerToDateFormat(dealerPendingSaudaList[index].biddingDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format),
                                                          fontColor: Constant.colorBlack,
                                                          fontSize: Constant.fontSize14,
                                                          fontWeight: Constant.fontWeight600,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                children: [
                                                  Container(
                                                    color: const Color(0xFFECECEC),
                                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: CommonText(
                                                            name: "Sauda Number",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorBlack,
                                                            fontWeight: Constant.fontWeight500,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: CommonText(
                                                            name: "Quantity (MT)",
                                                            fontSize: Constant.fontSize12,
                                                            fontColor: Constant.colorBlack,
                                                            fontWeight: Constant.fontWeight500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      padding: const EdgeInsets.all(0),
                                                      physics: const ClampingScrollPhysics(),
                                                      itemCount: dealerPendingSaudaList[index].saudaListOutputs!.length,
                                                      itemBuilder: (context, ind) {
                                                        return MaterialButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => SaudaDetailViewScreen(
                                                                        saudaId: dealerPendingSaudaList[index].saudaListOutputs![ind].saudaOrderId!,
                                                                      )),
                                                            );
                                                          },
                                                          child: Container(
                                                            color: const Color(0xFFFAFAFA),
                                                            padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: CommonText(
                                                                    name: (dealerPendingSaudaList[index].saudaListOutputs![ind].saudaNumber == null)
                                                                        ? "-"
                                                                        : dealerPendingSaudaList[index].saudaListOutputs![ind].saudaNumber,
                                                                    fontSize: Constant.fontSize12,
                                                                    fontColor: Constant.colorBlack,
                                                                    fontWeight: Constant.fontWeight500,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: CommonText(
                                                                    name: dealerPendingSaudaList[index].saudaListOutputs![ind].totalQty!.toStringAsFixed(2),
                                                                    fontSize: Constant.fontSize12,
                                                                    fontColor: Constant.colorBlack,
                                                                    fontWeight: Constant.fontWeight500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      })
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
                                      }),
                                ),
                                Container(
                                  height: screenHeight * 0.70,
                                  width: screenWidth,
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    children: [
                                      CurveBorderBox(
                                          boxLRPadding: 0,
                                          boxTOPPadding: 2,
                                          boxBOTPadding: 0,
                                          boxBgColor: Colors.white,
                                          boxShadowColor: const Color(0xFFFFFFFF),
                                          boxofWidget: CurveBorderBox(
                                              boxLRPadding: 0,
                                              boxTOPPadding: 0,
                                              boxBOTPadding: 0,
                                              boxofWidget: Container(
                                                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(25.0))),
                                                height: screenHeight * 0.26,
                                                width: screenWidth,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 5, right: 5, top: 2),
                                                      color: const Color(0xFFFFFBF7),
                                                      height: screenHeight * 0.08,
                                                      child: ListTile(
                                                        title: CommonText(
                                                          name: "Distributor Name",
                                                          fontSize: Constant.fontSize14,
                                                          fontColor: Constant.colorDullGray77,
                                                        ),
                                                        subtitle: CommonText(
                                                          name: dealerDetail.dealerName ?? "",
                                                          fontSize: Constant.fontSize14,
                                                          fontColor: Constant.colorBlack,
                                                          fontWeight: Constant.fontWeight600,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: screenHeight * 0.16,
                                                      width: screenWidth,
                                                      margin: const EdgeInsets.only(left: 16, right: 8),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                  height: screenHeight * 0.08,
                                                                  width: screenWidth * 0.45,
                                                                  child: ListTile(
                                                                    dense: true,
                                                                    contentPadding: const EdgeInsets.all(0),
                                                                    title: CommonText(name: "Distributor Code", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                                                    subtitle: CommonText(
                                                                        name: dealerDetail.dealerCode ?? "",
                                                                        fontSize: Constant.fontSize14,
                                                                        fontColor: Constant.colorBlack,
                                                                        fontWeight: Constant.fontWeight600),
                                                                  )),
                                                              SizedBox(
                                                                  height: screenHeight * 0.08,
                                                                  width: screenWidth * 0.4,
                                                                  child: ListTile(
                                                                    dense: true,
                                                                    contentPadding: const EdgeInsets.all(0),
                                                                    title: CommonText(name: "Sauda", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                                                    subtitle: CommonText(
                                                                        name: dealerDetail.saudaOutStatnding != null ? dealerDetail.saudaOutStatnding!.toStringAsFixed(2) : "0.00",
                                                                        fontSize: Constant.fontSize14,
                                                                        fontColor: Constant.colorBlack,
                                                                        fontWeight: Constant.fontWeight600),
                                                                  )),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Visibility(
                                                                  visible: false,
                                                                  child: SizedBox(
                                                                      height: screenHeight * 0.08,
                                                                      width: screenWidth * 0.45,
                                                                      child: ListTile(
                                                                        dense: true,
                                                                        contentPadding: const EdgeInsets.all(0),
                                                                        title: CommonText(name: "Current Limit", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                                                        subtitle: CommonText(
                                                                            name: dealerDetail.currentLimit != null ? dealerDetail.currentLimit!.toStringAsFixed(2) : "0.00",
                                                                            fontSize: Constant.fontSize14,
                                                                            fontColor: Constant.colorBlack,
                                                                            fontWeight: Constant.fontWeight600),
                                                                      ))),
                                                              SizedBox(
                                                                  height: screenHeight * 0.08,
                                                                  width: screenWidth * 0.4,
                                                                  child: ListTile(
                                                                    dense: true,
                                                                    contentPadding: const EdgeInsets.all(0),
                                                                    title: CommonText(name: "Sales", fontSize: Constant.fontSize14, fontColor: Constant.colorDullGray77),
                                                                    subtitle: CommonText(
                                                                        name: dealerDetail.sales != null ? dealerDetail.sales!.toStringAsFixed(2) : "0.00",
                                                                        fontSize: Constant.fontSize14,
                                                                        fontColor: Constant.colorBlack,
                                                                        fontWeight: Constant.fontWeight600),
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))),
                                      Container(
                                        height: screenHeight * 0.580,
                                        width: screenWidth,
                                        margin: const EdgeInsets.only(top: 20),
                                        child: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                  color: Colors.transparent,
                                                  margin: const EdgeInsets.all(0),
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 50,
                                                  child: TabBar (
                                                      controller: innerTabController,
                                                      tabAlignment: TabAlignment.start,
                                                      indicatorSize: TabBarIndicatorSize.label,
                                                      isScrollable: true,
                                                      padding: EdgeInsets.zero,
                                                      indicatorPadding: EdgeInsets.zero,
                                                      labelPadding: EdgeInsets.zero,
                                                      indicatorWeight: 2,
                                                      indicator: innerTabController == 1
                                                          ? const BoxDecoration(
                                                        color: Color(0xFFF68C33),
                                                      )
                                                          : innerTabController == 2
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
                                                                      "Sauda",
                                                                      style: TextStyle(
                                                                          color: innerTabController?.index == 0 ? Colors.white : Colors.black,
                                                                          fontSize: Constant.fontSize16,
                                                                          fontWeight: Constant.fontWeight600),
                                                                    ),
                                                                  )
                                                              ),
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
                                                                  child:Center(
                                                                    child: Text(
                                                                      "Sales",
                                                                      style: TextStyle(
                                                                          color: innerTabController?.index == 1 ? Colors.white : Colors.black,
                                                                          fontSize: Constant.fontSize16,
                                                                          fontWeight: Constant.fontWeight600),
                                                                    ),
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(left: 2, right: 2),
                                                  height: screenHeight * 0.50,
                                                  width: screenWidth,
                                                  child: TabBarView(controller: innerTabController, children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(0),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                              child: ListView.builder(
                                                                  shrinkWrap: true,
                                                                  padding: const EdgeInsets.all(0),
                                                                  physics: const ClampingScrollPhysics(),
                                                                  itemCount: dealerSaudaList.length,
                                                                  itemBuilder: (context, index) {
                                                                    return CurveOuterBox(
                                                                        boxLRPadding: 0,
                                                                        boxTBPadding: 7,
                                                                        boxofWidget: Theme(
                                                                          data: theme,
                                                                          child: ExpansionTile(
                                                                            tilePadding: const EdgeInsets.only(right: 15),
                                                                            key: Key(index.toString()),
                                                                            initiallyExpanded: index == selected,
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
                                                                                      name: DateTimeUtils().dateToServerToDateFormat(
                                                                                          dealerSaudaList[index].biddingDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format),
                                                                                      fontColor: Constant.colorBlack,
                                                                                      fontSize: Constant.fontSize14,
                                                                                      fontWeight: Constant.fontWeight600,
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            children: [
                                                                              Container(
                                                                                color: const Color(0xFFECECEC),
                                                                                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: CommonText(
                                                                                        name: "Sauda Number",
                                                                                        fontSize: Constant.fontSize12,
                                                                                        fontColor: Constant.colorBlack,
                                                                                        fontWeight: Constant.fontWeight500,
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: CommonText(
                                                                                        name: "Quantity (MT)",
                                                                                        fontSize: Constant.fontSize12,
                                                                                        fontColor: Constant.colorBlack,
                                                                                        fontWeight: Constant.fontWeight500,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  padding: const EdgeInsets.all(0),
                                                                                  physics: const ClampingScrollPhysics(),
                                                                                  itemCount: dealerSaudaList[index].saudaListOutputs!.length,
                                                                                  itemBuilder: (context, ind) {
                                                                                    return MaterialButton(
                                                                                      padding: EdgeInsets.zero,
                                                                                      onPressed: () {
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => SaudaDetailViewScreen(
                                                                                                    saudaId: dealerSaudaList[index].saudaListOutputs![ind].saudaOrderId!,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      child: Container(
                                                                                        color: const Color(0xFFFAFAFA),
                                                                                        padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: CommonText(
                                                                                                name: (dealerSaudaList[index].saudaListOutputs![ind].saudaNumber == null)
                                                                                                    ? "-"
                                                                                                    : dealerSaudaList[index].saudaListOutputs![ind].saudaNumber,
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorBlack,
                                                                                                fontWeight: Constant.fontWeight500,
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: CommonText(
                                                                                                name: dealerSaudaList[index].saudaListOutputs![ind].totalQty!.toStringAsFixed(2),
                                                                                                fontSize: Constant.fontSize12,
                                                                                                fontColor: Constant.colorBlack,
                                                                                                fontWeight: Constant.fontWeight500,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  })
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
                                                                  }))
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Expanded(
                                                            child: ListView.builder(
                                                                shrinkWrap: true,
                                                                padding: const EdgeInsets.all(0),
                                                                physics: const ClampingScrollPhysics(),
                                                                itemCount: invoices.dashboardSalesDetails != null ? invoices.dashboardSalesDetails!.length : 0,
                                                                itemBuilder: (context, index) {
                                                                  return CurveOuterBox(
                                                                      boxLRPadding: 0,
                                                                      boxTBPadding: 7,
                                                                      boxofWidget: Theme(
                                                                        data: theme,
                                                                        child: ExpansionTile(
                                                                          tilePadding: const EdgeInsets.only(right: 15),
                                                                          key: Key(index.toString()),
                                                                          initiallyExpanded: index == selected,
                                                                          title: Container(
                                                                              padding: const EdgeInsets.only(left: 16, right: 8),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Visibility(
                                                                                      visible: false,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Expanded(
                                                                                              child: CommonText(
                                                                                            name: "Date ",
                                                                                            fontColor: Constant.colorBlack,
                                                                                            fontSize: Constant.fontSize14,
                                                                                            fontWeight: Constant.fontWeight600,
                                                                                          )),
                                                                                          Expanded(
                                                                                              child: CommonText(
                                                                                            name: "Total Qty",
                                                                                            fontColor: Constant.colorBlack,
                                                                                            fontSize: Constant.fontSize14,
                                                                                            fontWeight: Constant.fontWeight600,
                                                                                          )),
                                                                                          Expanded(
                                                                                              child: CommonText(
                                                                                            name: "Invoice Value(Rs.)",
                                                                                            fontColor: Constant.colorBlack,
                                                                                            fontSize: Constant.fontSize14,
                                                                                            fontWeight: Constant.fontWeight600,
                                                                                          )),
                                                                                        ],
                                                                                      )),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Expanded(
                                                                                          child: CommonText(
                                                                                        name: DateTimeUtils().dateToServerToDateFormat(invoices.dashboardSalesDetails![index].invoiceDate!,
                                                                                            DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format),
                                                                                        fontColor: Constant.colorBlack,
                                                                                        fontSize: Constant.fontSize14,
                                                                                        fontWeight: Constant.fontWeight600,
                                                                                      )),
                                                                                      Expanded(
                                                                                          child: CommonText(
                                                                                        name: invoices.dashboardSalesDetails![index].totalInvoiceQuantity?.toStringAsFixed(2),
                                                                                        fontColor: Constant.colorBlack,
                                                                                        fontSize: Constant.fontSize14,
                                                                                        fontWeight: Constant.fontWeight600,
                                                                                      )),
                                                                                      Expanded(
                                                                                          child: CommonText(
                                                                                        name: invoices.dashboardSalesDetails![index].totalInvoiceValue?.toStringAsFixed(2),
                                                                                        fontColor: Constant.colorBlack,
                                                                                        fontSize: Constant.fontSize14,
                                                                                        fontWeight: Constant.fontWeight600,
                                                                                      )),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              )),
                                                                          children: [
                                                                            Container(
                                                                              color: const Color(0xFFECECEC),
                                                                              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: CommonText(
                                                                                      name: "Invoice Number ",
                                                                                      fontSize: Constant.fontSize12,
                                                                                      fontColor: Constant.colorBlack,
                                                                                      fontWeight: Constant.fontWeight500,
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: CommonText(
                                                                                      name: "Total Qty",
                                                                                      fontSize: Constant.fontSize12,
                                                                                      fontColor: Constant.colorBlack,
                                                                                      fontWeight: Constant.fontWeight500,
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: CommonText(
                                                                                      name: "Invoice Value(Rs.)",
                                                                                      fontSize: Constant.fontSize12,
                                                                                      fontColor: Constant.colorBlack,
                                                                                      fontWeight: Constant.fontWeight500,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            ListView.builder(
                                                                                shrinkWrap: true,
                                                                                padding: const EdgeInsets.all(0),
                                                                                physics: const ClampingScrollPhysics(),
                                                                                itemCount: invoices.dashboardSalesDetails![index].invoiceList!.length,
                                                                                itemBuilder: (context, ind) {
                                                                                  return MaterialButton(
                                                                                    padding: EdgeInsets.zero,
                                                                                    onPressed: () {
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => PackGroupInvoiceDetailScreen(
                                                                                                id: invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceId!,
                                                                                                isBulkPack: invoices.isBulkPack!)),
                                                                                      );
                                                                                    },
                                                                                    child: Container(
                                                                                      color: const Color(0xFFFAFAFA),
                                                                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          //                                                                                                      name: (("null," "").contains(invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceNumber!)) ? invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceNumber! : "-",
                                                                                          Expanded(
                                                                                            flex: 2,
                                                                                            child: CommonText(
                                                                                              name: (!("null," "").contains(invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceNumber!))
                                                                                                  ? invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceNumber!
                                                                                                  : "-",
                                                                                              fontSize: Constant.fontSize12,
                                                                                              fontColor: Constant.colorBlack,
                                                                                              fontWeight: Constant.fontWeight500,
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 2,
                                                                                            child: CommonText(
                                                                                              name: invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceQuantity!.toStringAsFixed(2),
                                                                                              fontSize: Constant.fontSize12,
                                                                                              fontColor: Constant.colorBlack,
                                                                                              fontWeight: Constant.fontWeight500,
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 2,
                                                                                            child: CommonText(
                                                                                              name: invoices.dashboardSalesDetails![index].invoiceList![ind].invoiceValue!.toStringAsFixed(2),
                                                                                              fontSize: Constant.fontSize12,
                                                                                              fontColor: Constant.colorBlack,
                                                                                              fontWeight: Constant.fontWeight500,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                })
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
                                                                }))
                                                      ],
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            )),
                                        // CurveBorderBox(
                                        //   boxLRPadding: 0,
                                        //   boxTOPPadding: 2,
                                        //   boxBOTPadding: 0,
                                        //   boxofWidget: CurveBorderBox(
                                        //     boxLRPadding: 0,
                                        //     boxTOPPadding: 0,
                                        //     boxBOTPadding: 0,
                                        //     boxofWidget: ,
                                        //   )),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              progressBar
            ],
          ),
        )));
  }

  // Widget getDialogContent() {
  //   var ctx = context;
  //   return Column(mainAxisSize: MainAxisSize.min, children: [
  //     SizedBox(
  //         width: double.infinity,
  //         // height: 70,
  //         child: CommonDropdownButtonFormField<SalesOrganization>(
  //           isExpanded: true,
  //           value: selectedSalesOrg,
  //           icon: const Align(
  //               alignment: Alignment.topRight,
  //               child: Icon(
  //                 Icons.keyboard_arrow_down,
  //                 size: 16,
  //               )),
  //           elevation: 16,
  //           style: const TextStyle(color: Colors.black),
  //           decoration: InputDecoration(
  //               contentPadding:
  //                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               filled: true,
  //               // hintStyle: TextStyle(color: Colors.grey[800]),
  //               labelText: "Sales Organization",
  //               labelStyle:
  //                   TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
  //               fillColor: fillColor),
  //           onChanged: (SalesOrganization? newValue) {
  //             setState(() {
  //               selectedSalesOrg = newValue!;
  //             });
  //             BlocProvider.of<PendingSaudaDetailBloc>(ctx)
  //                 .add(LoadDistributionChannel(id: selectedSalesOrg!.id!));
  //           },
  //           items:
  //               salesOrgList.map<DropdownMenuItem<SalesOrganization>>((value) {
  //             return DropdownMenuItem<SalesOrganization>(
  //               value: value,
  //               child: Text(value.salesOrganizationName!),
  //             );
  //           }).toList(),
  //         )),
  //     const SizedBox(height: 16),
  //     SizedBox(
  //         width: double.infinity,
  //         //height: 70,
  //         child: CommonDropdownButtonFormField<DistributionChannel>(
  //           isExpanded: true,
  //           value: selectedDistrChannel,
  //           icon: const Align(
  //               alignment: Alignment.topRight,
  //               child: Icon(
  //                 Icons.keyboard_arrow_down,
  //                 size: 16,
  //               )),
  //           elevation: 16,
  //           style: const TextStyle(color: Colors.black),
  //           decoration: InputDecoration(
  //               contentPadding:
  //                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               filled: true,
  //               // hintStyle: TextStyle(color: Colors.grey[800]),
  //               labelText: "Distribution Channel",
  //               labelStyle:
  //                   TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
  //               fillColor: fillColor),
  //           onChanged: (DistributionChannel? newValue) {
  // setState(() {
  //               selectedDistrChannel = newValue!;
  // });
  //             // GMLogger.v(jsonEncode(selectedVertical));
  //             // GMLogger.v("cmoing in ................");
  //             BlocProvider.of<PendingSaudaDetailBloc>(ctx).add(
  //                 LoadVerticalList(distributionId: selectedDistrChannel!.id!));
  //           },
  //           items: distrChannels
  //               .map<DropdownMenuItem<DistributionChannel>>((value) {
  //             return DropdownMenuItem<DistributionChannel>(
  //               value: value,
  //               child: Text(value.distributionChannelName!),
  //             );
  //           }).toList(),
  //         )),
  //     const SizedBox(height: 16.0),
  //     SizedBox(
  //         width: double.infinity,
  //         //height: 70,
  //         child: CommonDropdownButtonFormField<Vertical>(
  //           isExpanded: true,
  //           value: constructVertical ? null : selectedVertical,
  //           icon: const Align(
  //               alignment: Alignment.topRight,
  //               child: Icon(
  //                 Icons.keyboard_arrow_down,
  //                 size: 16,
  //               )),
  //           elevation: 16,
  //           style: const TextStyle(color: Colors.black),
  //           decoration: InputDecoration(
  //               contentPadding:
  //                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(borderRadiusTLBR),
  //                       topRight: Radius.circular(borderRadiusTRBL),
  //                       bottomLeft: Radius.circular(borderRadiusTRBL),
  //                       bottomRight: Radius.circular(borderRadiusTLBR)),
  //                   borderSide: BorderSide(color: borderColor!, width: 1.0)),
  //               filled: true,
  //               // hintStyle: TextStyle(color: Colors.grey[800]),
  //               labelText: "Division",
  //               labelStyle:
  //                   TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
  //               fillColor: fillColor),
  //           onChanged: (Vertical? newValue) {
  //             // setState(() {
  //             selectedVertical = newValue!;
  //             // });
  //           },
  //           items: verticals.map<DropdownMenuItem<Vertical>>((value) {
  //             return DropdownMenuItem<Vertical>(
  //               value: value,
  //               child: Text(value.name!),
  //             );
  //           }).toList(),
  //         )),
  //   ]);
  // }
  //
  // void showCustomFilterDialog(
  //     BuildContext context, messageValue, title, footerbutton,
  //     {bool? hideCancelBtn = false,
  //     String? successText = 'OK',
  //     Color? titleColor = Colors.white}) {
  //   // set up the button
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext ctx) {
  //       return StatefulBuilder(
  //           key: _dialogKey,
  //           builder: (context, setState) {
  //             return AlertDialog(
  //               insetPadding: const EdgeInsets.only(left: 20, right: 20),
  //               shape: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(25.0),
  //                   topRight: Radius.circular(5.0),
  //                   bottomLeft: Radius.circular(5.0),
  //                   bottomRight: Radius.circular(25.0),
  //                 ),
  //               ),
  //               titlePadding: const EdgeInsets.all(0),
  //               contentPadding: EdgeInsets.zero,
  //               title: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(
  //                   color: Constant.colorOrange,
  //                   borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(25.0),
  //                     topRight: Radius.circular(5.0),
  //                     bottomLeft: Radius.circular(0.0),
  //                     bottomRight: Radius.circular(0.0),
  //                   ),
  //                 ),
  //                 padding: const EdgeInsets.all(16),
  //                 child: Text(title,
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                       color: titleColor,
  //                       fontSize: Constant.fontSize15,
  //                       fontWeight: Constant.fontWeight500,
  //                     )),
  //               ),
  //               content: Container(
  //                   height: 300,
  //                   width: double.infinity,
  //                   padding:
  //                       const EdgeInsets.only(left: 10, right: 10, top: 20),
  //                   child: getDialogContent()),
  //               actions: [
  //                 Row(
  //                   children: [footerbutton],
  //                 )
  //               ],
  //             );
  //           });
  //     },
  //   );
  // }
  //
  // Widget dialogActionButtonFilter() {
  //   var ct = context;
  //   return SizedBox(
  //     width: screenWidth * 0.8,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         const SizedBox(width: 9),
  //         SizedBox(
  //           width: screenWidth / 3,
  //           child: CommonButton(
  //             buttonName: "Cancel",
  //             buttonNameWeight: Constant.fontWeight500,
  //             buttonNameSize: Constant.fontSize13,
  //             buttonNameColor: Constant.saudaLETTxtColor,
  //             buttonColor: Constant.saudaLETbuttonColor,
  //             buttonHeight: 50,
  //             buttonRadiusTL: Constant.pricbuttonRadiusTL,
  //             buttonRadiusBL: Constant.pricbutRadiusBL,
  //             buttonBorder: Constant.saudaLETbuttonBorder,
  //             buttonFunction: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         SizedBox(
  //           width: screenWidth / 3,
  //           child: CommonButton(
  //             buttonName: "Apply",
  //             buttonNameWeight: Constant.fontWeight500,
  //             buttonNameSize: Constant.fontSize13,
  //             buttonNameColor: Constant.pricbuttonTxtColor,
  //             buttonColor: Constant.pricbuttonColor,
  //             buttonHeight: 50,
  //             buttonRadiusTL: Constant.pricbuttonRadiusTL,
  //             buttonRadiusBL: Constant.pricbutRadiusBL,
  //             buttonBorder: Colors.transparent,
  //             buttonFunction: () {
  //               int salesOrgId = 0;
  //               int distrId = 0;
  //               int divisionId = 0;
  //               if (selectedSalesOrg != null) {
  //                 salesOrgId = selectedSalesOrg!.id!;
  //               }
  //               if (selectedDistrChannel != null) {
  //                 distrId = selectedDistrChannel!.id!;
  //               }
  //               if (selectedVertical != null) {
  //                 divisionId = selectedVertical!.id!;
  //               }
  //               BlocProvider.of<PendingSaudaDetailBloc>(ct).add(
  //                   LoadDealerDetail(
  //                       id: widget.dealerId,
  //                       salesOrgId: salesOrgId,
  //                       distributionId: distrId,
  //                       divisionId: divisionId));
  //               BlocProvider.of<PendingSaudaDetailBloc>(ct).add(
  //                   LoadDealerSaudaList(
  //                       id: widget.dealerId,
  //                       salesOrgId: salesOrgId,
  //                       distributionId: distrId,
  //                       divisionId: divisionId));
  //               BlocProvider.of<PendingSaudaDetailBloc>(ct).add(
  //                   LoadDealerSalesList(
  //                       id: widget.dealerId,
  //                       salesOrgId: salesOrgId,
  //                       distributionId: distrId,
  //                       divisionId: divisionId));
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
                content: Container(height: 150, width: double.infinity, padding: const EdgeInsets.only(left: 10, right: 10, top: 20), child: getDialogContent()),
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

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now().add(const Duration(days: Constants.REPORT_MAX_DAY_PENDING_SAUDA))
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now());
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      // _todatecontroller.text = DateTimeUtils().dateToStringFormat(
      //     selected.add(Duration(days: Constants.REPORT_MAX_DAY)),
      //     DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _todatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        lastDate: DateTime.now());
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
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
    var ct = context;
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
                fromDate = _fromdatecontroller.text.toString();
                toDate = _todatecontroller.text.toString();
                int salesOrgId = 0;
                int distrId = 0;
                int divisionId = 0;
                if (selectedSalesOrg != null) {
                  salesOrgId = selectedSalesOrg!.id!;
                }
                if (selectedDistrChannel != null) {
                  distrId = selectedDistrChannel!.id!;
                }
                if (selectedVertical != null) {
                  divisionId = selectedVertical!.id!;
                }
                BlocProvider.of<PendingSaudaDetailBloc>(ct).add(LoadDealerSaudaList(
                  id: widget.dealerId,
                  salesOrgId: salesOrgId,
                  distributionId: distrId,
                  divisionId: divisionId,
                  fromDate: DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                  toDate: DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                ));
                BlocProvider.of<PendingSaudaDetailBloc>(ct).add(LoadSalesScreen(
                  dealerId: widget.dealerId,
                  userId: Constants.AUTH_USERID,
                  statusId: 0,
                  packGroupId: 0,
                  fromDate: DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                  toDate: DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format),
                ));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
