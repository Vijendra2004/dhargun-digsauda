import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/pending_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_slab.dart';
import 'package:adaniwilmar/screen/pending_sauda/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';
import '../pending_sauda_detail/pending_sauda_detail.dart';

class PendingSaudaScreen extends StatelessWidget {
  String categoryName = "";

  PendingSaudaScreen({this.categoryName = "", Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingSaudaBloc()
        ..add(LoadPendingSaudaSalesScreen(
            userId: Constants.AUTH_USERID,
            bdoIds: Constants.AUTH_ROLEID == Constants.SALE
                ? [Constants.AUTH_USERID]
                : [],
            dealerIds: const [],
            creditId: 0,
            loadData:
                Constants.AUTH_ROLEID == Constants.NHMANAGER ? false : true))
        ..add(LoadPendingSaudaList(userId: Constants.AUTH_USERID)),
      child: CreditLimitExp(
        categoryName: categoryName,
      ),
    );
  }
}

class CreditLimitExp extends StatefulWidget {
  String categoryName = "";

  CreditLimitExp({this.categoryName = "", Key? key}) : super(key: key);

  @override
  State<CreditLimitExp> createState() => _PendingSaudaState();
}

class _PendingSaudaState extends State<CreditLimitExp>
    with TickerProviderStateMixin {
  List<DistributorList> distributorList = [];
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController?.addListener(_handleTabSelection);
    tradeFilter = StateTraderFilterWidget(
      showAll: Constants.AUTH_ROLEID == Constants.ZHMANAGER ? false : true,
      selectDefault:
          Constants.AUTH_ROLEID == Constants.NHMANAGER ? true : false,
      resultFunction: (var value) {
        selectedBdo = value;
        BlocProvider.of<PendingSaudaBloc>(context)
            .add(LoadPendingSaudaSalesScreen(
          userId: Constants.AUTH_USERID,
          bdoIds: selectedBdo!.id == 0 ? [] : [selectedBdo!.id!],
          dealerIds: const [],
          creditId: 0,
        ));
      },
      onLoad: (var value) {
        if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
          selectedBdo = value;
          BlocProvider.of<PendingSaudaBloc>(context)
              .add(LoadPendingSaudaSalesScreen(
            userId: Constants.AUTH_USERID,
            bdoIds: selectedBdo!.id == 0 ? [] : [selectedBdo!.id!],
            dealerIds: const [],
            creditId: 0,
          ));
        } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
          selectedBdo = value;
          BlocProvider.of<PendingSaudaBloc>(context)
              .add(LoadPendingSaudaSalesScreen(
            userId: Constants.AUTH_USERID,
            bdoIds: selectedBdo!.id == 0 ? [] : [selectedBdo!.id!],
            dealerIds: const [],
            creditId: 0,
          ));
        }
      },
    );
    indicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  List<PendingSaudaSlab> saudaSlabs = [];
  List<PendingSauda> pendingSaudaList = [];
  List<PendingSauda> saudaListTab1 = [];
  List<PendingSauda> saudaListTab2 = [];
  List<PendingSauda> saudaListTab3 = [];
  List<PendingSauda> saudaListTab4 = [];

  List<PendingSaudaDistributor> saudaListTab1Distributor = [];
  List<PendingSaudaDistributor> saudaListTab2Distributor = [];
  List<PendingSaudaDistributor> saudaListTab3Distributor = [];
  List<PendingSaudaDistributor> saudaListTab4Distributor = [];
  List<PendingSaudaDistributor> saudaListTabSearch1Distributor = [];
  List<PendingSaudaDistributor> saudaListTabSearch2Distributor = [];
  List<PendingSaudaDistributor> saudaListTabSearch3Distributor = [];
  List<PendingSaudaDistributor> saudaListTabSearch4Distributor = [];
  TextEditingController searchController = TextEditingController();

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

  String slab1Name = "";
  String slab2Name = "";
  String slab3Name = "";
  String slab4Name = "";
  BdoList? selectedBdo;
  StateTraderFilterWidget? tradeFilter;

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
    return BlocListener<PendingSaudaBloc, PendingSaudaState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            saudaListTab1 = [];
            saudaListTab2 = [];
            saudaListTab3 = [];
            saudaListTab4 = [];

            saudaListTab1Distributor = [];
            saudaListTab2Distributor = [];
            saudaListTab3Distributor = [];
            saudaListTab4Distributor = [];

            pendingSaudaList = state.pendingSauda;
            saudaSlabs = state.pendingSaudaSlabs;
            getSaudaDaysList();
            searchController.text = "";
            setState(() {});
          }
          if (state is OnLoadPendingSauda) {
            distributorList = state.distributorList;
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
          appBar: const CustomAppBar(
            title: "Pending Sauda",
            backArrow: true,
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
                margin: const EdgeInsets.only(top: 60, right: 8, left: 8),
                height: screenHeight * 0.980,
                width: screenWidth,
                child: CurveBorderBox(
                    boxLRPadding: 0,
                    boxofWidget: Column(
                      children: [
                        TabBar(
                            indicator: tabController == 1
                                ? const BoxDecoration(
                                    color: Color(
                                      0xFFF68C33,
                                    ),
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            controller: tabController,
                            isScrollable: false,
                            indicatorColor: Colors.grey,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorPadding: const EdgeInsets.all(0),
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                  child: Container(
                                      height: screenHeight * 0.1,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                        color: Color(0xFF757575),
                                        width: 0.8,
                                      ))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            slab1Name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: tabController?.index == 0
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: Constant.fontSize14,
                                                fontWeight:
                                                    Constant.fontWeight600),
                                          ),
                                        ],
                                      ))),
                              Tab(
                                  child: Container(
                                      height: screenHeight * 0.1,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                        color: Color(0xFF757575),
                                        width: 0.8,
                                      ))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            slab2Name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: tabController?.index == 1
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: Constant.fontSize14,
                                                fontWeight:
                                                    Constant.fontWeight600),
                                          ),
                                        ],
                                      ))),
                              Tab(
                                  child: Container(
                                      height: screenHeight * 0.1,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                        color: Color(0xFF757575),
                                        width: 0.8,
                                      ))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            slab3Name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: tabController?.index == 2
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: Constant.fontSize14,
                                                fontWeight:
                                                    Constant.fontWeight600),
                                          ),
                                        ],
                                      ))),
                              Tab(
                                  child: SizedBox(
                                      height: screenHeight * 0.1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            slab4Name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: tabController?.index == 3
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: Constant.fontSize14,
                                                fontWeight:
                                                    Constant.fontWeight600),
                                          ),
                                        ],
                                      ))),
                            ]),
                        Visibility(
                            visible: Constants.AUTH_ROLEID != Constants.DEALER,
                            child: ListTile(
                              leading: const Icon(Icons.search),
                              title: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none),
                                onChanged: onSearchTextChanged,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  searchController.clear();
                                  onSearchTextChanged('');
                                },
                              ),
                            )),
                        Expanded(
                            child: Container(
                                height: screenHeight * 0.800,
                                width: screenWidth,
                                padding: const EdgeInsets.only(top: 8),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0xFFE5E5E5FF)))),
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Constants.AUTH_ROLEID != Constants.DEALER
                                        ? SingleChildScrollView(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    tradeFilter != null
                                                        ? tradeFilter!
                                                        : const Visibility(
                                                            visible: false,
                                                            child: Text(
                                                                "State Trade")),
                                                    ListView.builder(
                                                        key:
                                                            const Key(
                                                                'builder 1'),
                                                        //attention
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: (searchController
                                                                .text.isEmpty)
                                                            ? saudaListTab1Distributor
                                                                .length
                                                            : saudaListTabSearch1Distributor
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CurveOuterBox(
                                                            boxLRPadding: 0,
                                                            boxTBPadding: 8,
                                                            boxofWidget: Theme(
                                                                data: theme,
                                                                child: ListTile(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              PendingSaudaDetailScreen(
                                                                                dealerId: getCurrentSaudaDaysList(1)[index].dealerId!,
                                                                                saudaSlab: saudaSlabs[0],
                                                                                sindex: 0,
                                                                              )),
                                                                    );
                                                                  },
                                                                  title: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 3),
                                                                            // padding: EdgeInsets.zero,
                                                                            width:
                                                                                3,
                                                                            height:
                                                                                34,
                                                                            decoration:
                                                                                BoxDecoration(color: Constant.callToCcolor1, borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 16),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                width: screenWidth * 0.7,
                                                                                child: Text(getCurrentSaudaDaysList(1)[index].dealerName!, style: TextStyle(overflow: TextOverflow.visible, fontSize: Constant.fontSize16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.7,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: <Widget>[
                                                                                    SizedBox(width: 12, height: 13, child: Constant.locatoinIc),
                                                                                    const SizedBox(width: 8),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width * 0.63,
                                                                                      child: Text(getCurrentSaudaDaysList(1)[index].dealerLocation ?? "", style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorLightGray, overflow: TextOverflow.visible)),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  trailing:
                                                                      Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 24,
                                                                    color: Constant
                                                                        .colorGray45,
                                                                  ),
                                                                )),
                                                          );
                                                        })
                                                  ],
                                                )))
                                        : Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PendingSaudaDetailScreen(
                                                                      dealerId:
                                                                          Constants
                                                                              .AUTH_USERID,
                                                                      saudaSlab:
                                                                          saudaSlabs[
                                                                              0],
                                                                      sindex:
                                                                          0)),
                                                        );
                                                      },
                                                      child: CommonText(
                                                        name: "View Hub",
                                                        fontSize:
                                                            Constant.fontSize14,
                                                        fontColor: Constant
                                                            .colorOrange,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ))),
                                              Container(
                                                color: const Color(0xFFECECEC),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: CommonText(
                                                        name: "Date",
                                                        fontSize:
                                                            Constant.fontSize12,
                                                        fontColor:
                                                            Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: CommonText(
                                                        name: "Metric Tons(MT)",
                                                        fontSize:
                                                            Constant.fontSize12,
                                                        fontColor:
                                                            Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth,
                                                height: screenHeight * 0.63,
                                                child: SingleChildScrollView(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          saudaListTab1 != null
                                                              ? saudaListTab1
                                                                  .length
                                                              : 0,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return MaterialButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            // Navigator.push(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //       builder: (context) =>
                                                            //           SaudaDetailViewScreen(saudaId:distrPendingSaudaList[index]
                                                            //               .saudaOrderId! )),
                                                            // );
                                                          },
                                                          child: Container(
                                                            color: const Color(
                                                                0xFFFAFAFA),
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 8,
                                                                    top: 12,
                                                                    bottom: 12),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      CommonText(
                                                                    name: DateTimeUtils().dateToServerToDateFormat(
                                                                        saudaListTab1[index]
                                                                            .biddingDate!,
                                                                        DateTimeUtils
                                                                            .YYYY_MM_DD_Format,
                                                                        DateTimeUtils
                                                                            .DD_MMM_YYYY_Format),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      CommonText(
                                                                    name: saudaListTab1[index]
                                                                                .bidQuantity !=
                                                                            null
                                                                        ? (saudaListTab1[index].bidQuantity!.toStringAsFixed(2) +
                                                                            " MT")
                                                                        : (saudaListTab1[index].totalBidQuantity!.toStringAsFixed(2) +
                                                                            " MT"),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              )
                                            ],
                                          ),
                                    Constants.AUTH_ROLEID != Constants.DEALER
                                        ? SingleChildScrollView(
                                            child: Container(
                                                child: Column(
                                              children: [
                                                tradeFilter != null
                                                    ? tradeFilter!
                                                    : const Visibility(
                                                        visible: false,
                                                        child: Text(
                                                            "State Trade")),
                                                ListView.builder(
                                                    key: const Key('builder 2'),
                                                    //attention
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: (searchController
                                                            .text.isEmpty)
                                                        ? saudaListTab2Distributor
                                                            .length
                                                        : saudaListTabSearch2Distributor
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CurveOuterBox(
                                                        boxLRPadding: 8,
                                                        boxTBPadding: 8,
                                                        boxofWidget: Theme(
                                                            data: theme,
                                                            child: ListTile(
                                                              dense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => PendingSaudaDetailScreen(
                                                                          dealerId: getCurrentSaudaDaysList(2)[index]
                                                                              .dealerId!,
                                                                          saudaSlab: saudaSlabs[
                                                                              1],
                                                                          sindex:
                                                                              1)),
                                                                );
                                                              },
                                                              title: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                3),
                                                                        // padding: EdgeInsets.zero,
                                                                        width:
                                                                            3,
                                                                        height:
                                                                            34,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Constant.callToCcolor1,
                                                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              16),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.7,
                                                                            child:
                                                                                Text(getCurrentSaudaDaysList(2)[index].dealerName!, style: TextStyle(overflow: TextOverflow.visible, fontSize: Constant.fontSize16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.7,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                SizedBox(width: 12, height: 13, child: Constant.locatoinIc),
                                                                                const SizedBox(width: 8),
                                                                                SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.63,
                                                                                  child: Text(getCurrentSaudaDaysList(2)[index].dealerLocation ?? "", style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorLightGray, overflow: TextOverflow.visible)),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 24,
                                                                color: Constant
                                                                    .colorGray45,
                                                              ),
                                                            )),
                                                      );
                                                      ;
                                                    })
                                              ],
                                            )),
                                          )
                                        : Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PendingSaudaDetailScreen(
                                                                      dealerId:
                                                                          Constants
                                                                              .AUTH_USERID,
                                                                      saudaSlab:
                                                                          saudaSlabs[
                                                                              1],
                                                                      sindex:
                                                                          1)),
                                                        );
                                                      },
                                                      child: CommonText(
                                                        name: "View Hub",
                                                        fontSize:
                                                            Constant.fontSize14,
                                                        fontColor: Constant
                                                            .colorOrange,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ))),
                                              Container(
                                                color: const Color(0xFFECECEC),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: CommonText(
                                                        name: "Date",
                                                        fontSize:
                                                            Constant.fontSize12,
                                                        fontColor:
                                                            Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: CommonText(
                                                        name: "Metric Tons(MT)",
                                                        fontSize:
                                                            Constant.fontSize12,
                                                        fontColor:
                                                            Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.63,
                                                width: screenWidth,
                                                child: SingleChildScrollView(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount:
                                                            saudaListTab2 !=
                                                                    null
                                                                ? saudaListTab2
                                                                    .length
                                                                : 0,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return MaterialButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              // Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //       builder: (context) =>
                                                              //           SaudaDetailViewScreen(saudaId:distrPendingSaudaList[index]
                                                              //               .saudaOrderId! )),
                                                              // );
                                                            },
                                                            child: Container(
                                                              color: const Color(
                                                                  0xFFFAFAFA),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        CommonText(
                                                                      name: DateTimeUtils().dateToServerToDateFormat(
                                                                          saudaListTab2[index]
                                                                              .biddingDate!,
                                                                          DateTimeUtils
                                                                              .YYYY_MM_DD_Format,
                                                                          DateTimeUtils
                                                                              .DD_MMM_YYYY_Format),
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        CommonText(
                                                                      name: saudaListTab2[index]
                                                                                  .bidQuantity !=
                                                                              null
                                                                          ? (saudaListTab2[index].bidQuantity!.toStringAsFixed(2) +
                                                                              " MT")
                                                                          : (saudaListTab2[index].totalBidQuantity!.toStringAsFixed(2) +
                                                                              " MT"),
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })),
                                              )
                                            ],
                                          ),
                                    Constants.AUTH_ROLEID != Constants.DEALER
                                        ? SingleChildScrollView(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    tradeFilter != null
                                                        ? tradeFilter!
                                                        : const Visibility(
                                                            visible: false,
                                                            child: Text(
                                                                "State Trade")),
                                                    ListView.builder(
                                                        key:
                                                            const Key(
                                                                'builder 3'),
                                                        //attention
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: (searchController
                                                                .text.isEmpty)
                                                            ? saudaListTab3Distributor
                                                                .length
                                                            : saudaListTabSearch3Distributor
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CurveOuterBox(
                                                            boxLRPadding: 0,
                                                            boxTBPadding: 8,
                                                            boxofWidget: Theme(
                                                                data: theme,
                                                                child: ListTile(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  title:
                                                                      MaterialButton(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => PendingSaudaDetailScreen(
                                                                                dealerId: getCurrentSaudaDaysList(3)[index].dealerId!,
                                                                                saudaSlab: saudaSlabs[2],
                                                                                sindex: 2)),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: 3,
                                                                              height: 34,
                                                                              decoration: BoxDecoration(color: Constant.callToCcolor1, borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
                                                                              margin: const EdgeInsets.only(top: 3),
                                                                            ),
                                                                            const SizedBox(width: 16),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                SizedBox(
                                                                                  width: screenWidth * 0.7,
                                                                                  child: Text(getCurrentSaudaDaysList(3)[index].dealerName!, style: TextStyle(overflow: TextOverflow.visible, fontSize: Constant.fontSize16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: screenWidth * 0.7,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      SizedBox(width: 12, height: 13, child: Constant.locatoinIc),
                                                                                      const SizedBox(width: 8),
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.63,
                                                                                        child: Text(getCurrentSaudaDaysList(3)[index].dealerLocation ?? "", style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorLightGray, overflow: TextOverflow.visible)),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  trailing:
                                                                      Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 24,
                                                                    color: Constant
                                                                        .colorGray45,
                                                                  ),
                                                                )),
                                                          );
                                                        })
                                                  ],
                                                )),
                                          )
                                        : Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PendingSaudaDetailScreen(
                                                                      dealerId:
                                                                          Constants
                                                                              .AUTH_USERID,
                                                                      saudaSlab:
                                                                          saudaSlabs[
                                                                              2],
                                                                      sindex:
                                                                          2)),
                                                        );
                                                      },
                                                      child: CommonText(
                                                        name: "View Hub",
                                                        fontSize:
                                                            Constant.fontSize14,
                                                        fontColor: Constant
                                                            .colorOrange,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ))),
                                              Container(
                                                color: const Color(0xFFECECEC),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CommonText(
                                                      name: "Date",
                                                      fontSize:
                                                          Constant.fontSize12,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight500,
                                                    ),
                                                    CommonText(
                                                      name: "Metric Tons(MT)",
                                                      fontSize:
                                                          Constant.fontSize12,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight500,
                                                    ),
                                                    // Expanded(
                                                    //   child: ,
                                                    // ),
                                                    // Expanded(
                                                    //   child:
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.63,
                                                width: screenWidth,
                                                child: SingleChildScrollView(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount:
                                                            saudaListTab3 !=
                                                                    null
                                                                ? saudaListTab3
                                                                    .length
                                                                : 0,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return MaterialButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              // Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //       builder: (context) =>
                                                              //           SaudaDetailViewScreen(saudaId:distrPendingSaudaList[index]
                                                              //               .saudaOrderId! )),
                                                              // );
                                                            },
                                                            child: Container(
                                                              color: const Color(
                                                                  0xFFFAFAFA),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  CommonText(
                                                                    name: DateTimeUtils().dateToServerToDateFormat(
                                                                        saudaListTab3[index]
                                                                            .biddingDate!,
                                                                        DateTimeUtils
                                                                            .YYYY_MM_DD_Format,
                                                                        DateTimeUtils
                                                                            .DD_MMM_YYYY_Format),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
                                                                  ),
                                                                  CommonText(
                                                                    name: saudaListTab3[index]
                                                                                .bidQuantity !=
                                                                            null
                                                                        ? (saudaListTab3[index].bidQuantity!.toStringAsFixed(2) +
                                                                            " MT")
                                                                        : (saudaListTab3[index].totalBidQuantity!.toStringAsFixed(2) +
                                                                            " MT"),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
                                                                  )
                                                                  // Expanded(
                                                                  //   child:
                                                                  // ),
                                                                  // Expanded(
                                                                  //   child: ,
                                                                  // )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })),
                                              )
                                            ],
                                          ),
                                    Constants.AUTH_ROLEID != Constants.DEALER
                                        ? SingleChildScrollView(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    tradeFilter != null
                                                        ? tradeFilter!
                                                        : const Visibility(
                                                            visible: false,
                                                            child: Text(
                                                                "State Trade")),
                                                    ListView.builder(
                                                        key:
                                                            const Key(
                                                                'builder 4'),
                                                        //attention
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: (searchController
                                                                .text.isEmpty)
                                                            ? saudaListTab4Distributor
                                                                .length
                                                            : saudaListTabSearch4Distributor
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CurveOuterBox(
                                                            boxLRPadding: 0,
                                                            boxTBPadding: 8,
                                                            boxofWidget: Theme(
                                                                data: theme,
                                                                child: ListTile(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => PendingSaudaDetailScreen(
                                                                              dealerId: getCurrentSaudaDaysList(4)[index].dealerId!,
                                                                              saudaSlab: saudaSlabs[3],
                                                                              sindex: 3)),
                                                                    );
                                                                  },
                                                                  title: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                3,
                                                                            height:
                                                                                34,
                                                                            margin:
                                                                                const EdgeInsets.only(top: 3),
                                                                            decoration:
                                                                                BoxDecoration(color: Constant.callToCcolor1, borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 16),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                width: screenWidth * 0.7,
                                                                                child: Text(getCurrentSaudaDaysList(4)[index].dealerName!, style: TextStyle(overflow: TextOverflow.visible, fontSize: Constant.fontSize16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.7,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: <Widget>[
                                                                                    SizedBox(width: 12, height: 13, child: Constant.locatoinIc),
                                                                                    const SizedBox(width: 8),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width * 0.63,
                                                                                      child: Text(getCurrentSaudaDaysList(4)[index].dealerLocation ?? "", style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorLightGray, overflow: TextOverflow.visible)),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  trailing:
                                                                      Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 24,
                                                                    color: Constant
                                                                        .colorGray45,
                                                                  ),
                                                                )),
                                                          );
                                                        })
                                                  ],
                                                )),
                                          )
                                        : Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PendingSaudaDetailScreen(
                                                                      dealerId:
                                                                          Constants
                                                                              .AUTH_USERID,
                                                                      saudaSlab:
                                                                          saudaSlabs[
                                                                              3],
                                                                      sindex:
                                                                          3)),
                                                        );
                                                      },
                                                      child: CommonText(
                                                        name: "View Hub",
                                                        fontSize:
                                                            Constant.fontSize14,
                                                        fontColor: Constant
                                                            .colorOrange,
                                                        fontWeight: Constant
                                                            .fontWeight500,
                                                      ))),
                                              Container(
                                                color: const Color(0xFFECECEC),
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CommonText(
                                                      name: "Date",
                                                      fontSize:
                                                          Constant.fontSize14,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600,
                                                    ),
                                                    CommonText(
                                                      name: "Metric Tons(MT)",
                                                      fontSize:
                                                          Constant.fontSize14,
                                                      fontColor:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.63,
                                                width: screenWidth,
                                                child: SingleChildScrollView(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount:
                                                            saudaListTab4 !=
                                                                    null
                                                                ? saudaListTab4
                                                                    .length
                                                                : 0,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return MaterialButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              // Navigator.push(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //       builder: (context) =>
                                                              //           SaudaDetailViewScreen(saudaId:distrPendingSaudaList[index]
                                                              //               .saudaOrderId! )),
                                                              // );
                                                            },
                                                            child: Container(
                                                              color: const Color(
                                                                  0xFFFAFAFA),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  CommonText(
                                                                    name: DateTimeUtils().dateToServerToDateFormat(
                                                                        saudaListTab4[index]
                                                                            .biddingDate!,
                                                                        DateTimeUtils
                                                                            .YYYY_MM_DD_Format,
                                                                        DateTimeUtils
                                                                            .DD_MMM_YYYY_Format),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize14,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                  ),
                                                                  CommonText(
                                                                    name: saudaListTab4[index]
                                                                                .bidQuantity !=
                                                                            null
                                                                        ? (saudaListTab4[index].bidQuantity!.toStringAsFixed(2) +
                                                                            " MT")
                                                                        : (saudaListTab4[index].totalBidQuantity!.toStringAsFixed(2) +
                                                                            " MT"),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize14,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight600,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })),
                                              )
                                            ],
                                          ),
                                  ],
                                )))
                      ],
                    )),
              ),
              progressBar
            ],
          ),
        )));
  }

  void getSaudaDaysList() {
    for (int i = 0; i < saudaSlabs.length; i++) {
      if (i == 3) {
        slab4Name = ">" + (saudaSlabs[i].fromValue! - 1).toString() + "\nDays";
      } else if (i == 2) {
        slab3Name = (saudaSlabs[i].fromValue!).toString() +
            "-" +
            (saudaSlabs[i].toValue!).toString() +
            "\nDays";
      } else if (i == 1) {
        slab2Name = (saudaSlabs[i].fromValue!).toString() +
            "-" +
            (saudaSlabs[i].toValue!).toString() +
            "\nDays";
      } else {
        slab1Name = (saudaSlabs[i].fromValue!).toString() +
            "-" +
            (saudaSlabs[i].toValue!).toString() +
            "\nDays";
      }
      for (PendingSauda s in pendingSaudaList) {
        if (s.biddingDate != null) {
          int days = daysBetween(
              DateTimeUtils().stringToDate(
                  s.biddingDate!, DateTimeUtils.YYYY_MM_DD_Format),
              DateTime.now());
          if (i == 3 && days >= saudaSlabs[i].fromValue!) {
            saudaListTab4.add(s);
            if (saudaListTab4Distributor
                .where((element) => element.dealerId == s.userId!)
                .isEmpty) {
              PendingSaudaDistributor d = PendingSaudaDistributor();
              d.dealerId = s.userId;
              d.dealerCode = "";
              d.dealerName = s.user;
              d.plantName = s.plantName;
              d.dealerLocation = s.city;
              saudaListTab4Distributor.add(d);
            }
          } else if (i == 2 &&
              days >= saudaSlabs[i].fromValue! &&
              days <= saudaSlabs[i].toValue!) {
            saudaListTab3.add(s);
            if (saudaListTab3Distributor
                .where((element) => element.dealerId == s.userId!)
                .isEmpty) {
              PendingSaudaDistributor d = PendingSaudaDistributor();
              d.dealerId = s.userId;
              d.dealerCode = "";
              d.dealerName = s.user;
              d.plantName = s.plantName;
              d.dealerLocation = s.city;
              saudaListTab3Distributor.add(d);
            }
          } else if (i == 1 &&
              days >= saudaSlabs[i].fromValue! &&
              days <= saudaSlabs[i].toValue!) {
            saudaListTab2.add(s);
            if (saudaListTab2Distributor
                .where((element) => element.dealerId == s.userId!)
                .isEmpty) {
              PendingSaudaDistributor d = PendingSaudaDistributor();
              d.dealerId = s.userId;
              d.dealerCode = "";
              d.dealerName = s.user;
              d.plantName = s.plantName;
              d.dealerLocation = s.city;
              saudaListTab2Distributor.add(d);
            }
          } else if (i == 0 && days <= saudaSlabs[i].toValue!) {
            saudaListTab1.add(s);
            if (saudaListTab1Distributor
                .where((element) => element.dealerId == s.userId!)
                .isEmpty) {
              PendingSaudaDistributor d = PendingSaudaDistributor();
              d.dealerId = s.userId;
              d.dealerCode = "";
              d.dealerName = s.user;
              d.plantName = s.plantName;
              d.dealerLocation = s.city;
              saudaListTab1Distributor.add(d);
            }
          }
        }
      }
    }
    if (widget.categoryName != "") {
      if (slab1Name.contains(widget.categoryName)) {
        tabController!.animateTo(0);
      } else if (slab2Name.contains(widget.categoryName)) {
        tabController!.animateTo(1);
      } else if (slab3Name.contains(widget.categoryName)) {
        tabController!.animateTo(2);
      } else if (slab4Name.contains(widget.categoryName)) {
        tabController!.animateTo(3);
      }
      widget.categoryName = "";
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  onSearchTextChanged(String text) async {
    //customerLedgerSearchList.clear();
    saudaListTabSearch1Distributor.clear();
    saudaListTabSearch2Distributor.clear();
    saudaListTabSearch3Distributor.clear();
    saudaListTabSearch4Distributor.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var distributor in saudaListTab1Distributor) {
      if (distributor.dealerName!.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          saudaListTabSearch1Distributor.add(distributor);
        });
      } else {
        setState(() {});
      }
    }
    for (var distributor in saudaListTab2Distributor) {
      if (distributor.dealerName!.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          saudaListTabSearch2Distributor.add(distributor);
        });
      } else {
        setState(() {});
      }
    }
    for (var distributor in saudaListTab3Distributor) {
      if (distributor.dealerName!.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          saudaListTabSearch3Distributor.add(distributor);
        });
      } else {
        setState(() {});
      }
    }
    for (var distributor in saudaListTab4Distributor) {
      if (distributor.dealerName!.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          saudaListTabSearch4Distributor.add(distributor);
        });
      } else {
        setState(() {});
      }
    }
  }

  List<PendingSaudaDistributor> getCurrentSaudaDaysList(int tab) {
    if (searchController.text.isEmpty) {
      if (tab == 1) {
        return saudaListTab1Distributor;
      } else if (tab == 2) {
        return saudaListTab2Distributor;
      } else if (tab == 3) {
        return saudaListTab3Distributor;
      } else {
        return saudaListTab4Distributor;
      }
    } else {
      if (tab == 1) {
        return saudaListTabSearch1Distributor;
      } else if (tab == 2) {
        return saudaListTabSearch2Distributor;
      } else if (tab == 3) {
        return saudaListTabSearch3Distributor;
      } else {
        return saudaListTabSearch4Distributor;
      }
    }
  }
}
