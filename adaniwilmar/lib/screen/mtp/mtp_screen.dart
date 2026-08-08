import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/screen/mtp/bloc/bloc.dart';
import 'package:adaniwilmar/screen/mtp/mtp_detail_view.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class MtpScreen extends StatelessWidget {
  const MtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MtpBloc()..add(LoadMtpScreen(userId: Constants.AUTH_USERID)),
      child: const Mtp(),
    );
  }
}

class Mtp extends StatefulWidget {
  const Mtp({Key? key}) : super(key: key);

  @override
  State<Mtp> createState() => _MtpScreenState();
}

class _MtpScreenState extends State<Mtp> with TickerProviderStateMixin {
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  ProgressBarHandler? _handler;
  List<CurrentOrUpcomingmonthViewDto> mtpCurrentList = [];
  List<CurrentOrUpcomingmonthViewDto> mtpUpcomingList = [];

  List<MTPManagerList> mtpManagerCurrentList = [];
  List<MTPManagerList> mtpManagerUpcomingList = [];

  List<String> managerCurrentList = [];
  List<String> managerUpcomingList = [];

  double screenHeight = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      _handleTabSelection();
    });
    indicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  int selected = 0 - 1;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    double screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    Widget _tabmenu = Container(
      margin: const EdgeInsets.all(1),
      height: screenHeight * 0.96,
      width: screenWidth,
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: TabBar (
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
                                "Current MTP",
                                style: TextStyle(
                                    color: tabController?.index == 0
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: Constant.fontSize14,
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
                                "Upcoming MTP",
                                style: TextStyle(
                                    color: tabController?.index == 1
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: Constant.fontSize14,
                                    fontWeight: Constant.fontWeight600),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Container(
                    padding: const EdgeInsets.all(2),
                    child: SingleChildScrollView(
                      child: Constants.AUTH_ROLEID == Constants.ZHMANAGER
                          ? ListView.builder(
                              key: Key(
                                  'buildermtp1'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: managerCurrentList.length,
                              itemBuilder: (context, index) {
                                List<MTPManagerList> filteredList =
                                    mtpManagerCurrentList
                                        .where((element) =>
                                            element.createdUser ==
                                            managerCurrentList[index])
                                        .toList();
                                return CurveOuterBox(
                                    boxLRPadding: 0,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.only(right: 15),
                                        key: Key(index.toString()),
                                        initiallyExpanded: index == selected,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 22,
                                              color: Constant.callToCcolor1,
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name:
                                                      managerCurrentList[index],
                                                  fontColor:
                                                      Constant.colorBlack,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        children: [
                                          ListView.builder(
                                              key: Key(
                                                  'builder ${selected.toString()}'), //attention
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: filteredList.length,
                                              itemBuilder: (context, ind) {
                                                return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MtpViewScreen(
                                                                      mtpId: filteredList[
                                                                              index]
                                                                          .mtpId!)));
                                                    },
                                                    child: ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        title: CurveOuterBox(
                                                          boxBorderColor:
                                                              const Color(
                                                                  0xFFE7E7E7),
                                                          boxShadowColor:
                                                              const Color(
                                                                  0xFFFFFFFF),
                                                          boxBorderWidth: 0,
                                                          boxLRPadding: 0,
                                                          boxTBPadding: 0,
                                                          boxBRRadius: 5,
                                                          boxofWidget:
                                                              Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      top: 15,
                                                                      bottom:
                                                                          15),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFECECEC),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              25.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              5.0),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              5.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              25.0),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CommonText(
                                                                            name:
                                                                                "Booked No",
                                                                            fontColor:
                                                                                Constant.colorGray45,
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            fontWeight:
                                                                                Constant.fontWeight600,
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 5.0),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              CommonText(
                                                                                name: filteredList[ind].mtpNumber,
                                                                                fontColor: Constant.colorBlack,
                                                                                fontSize: Constant.fontSize11,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child:
                                                                              CommonLabel(
                                                                            labelRadiusBig:
                                                                                2.0,
                                                                            bgColor:
                                                                                Constant.booSauStacolor,
                                                                            name:
                                                                                filteredList[ind].status!,
                                                                            fontSize:
                                                                                Constant.fontSize11,
                                                                            fontColor:
                                                                                Constant.colorWhite,
                                                                            imageic:
                                                                                Constant.checkIc,
                                                                            imagetrue:
                                                                                true,
                                                                          ))
                                                                    ],
                                                                  )),
                                                        )));
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
                              })
                          : ListView.builder(
                              key: Key(
                                  'buildermtp2'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: mtpCurrentList.length,
                              itemBuilder: (context, index) {
                                return CurveOuterBox(
                                    boxLRPadding: 0,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.only(right: 15),
                                        key: Key(index.toString()),
                                        initiallyExpanded: index == selected,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 22,
                                              color: Constant.callToCcolor1,
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name: DateTimeUtils()
                                                      .dateToServerToDateFormat(
                                                          mtpCurrentList[index]
                                                              .date!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MMM_YYYY_Format),
                                                  fontColor:
                                                      Constant.colorBlack,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        children: [
                                          ListView.builder(
                                              key: Key(
                                                  'builder ${selected.toString()}'), //attention
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: mtpCurrentList[index]
                                                  .mtpDateWiseCitiesDtos!
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return Column(
                                                    children: mtpCurrentList[
                                                                    index]
                                                                .mtpDateWiseCitiesDtos![
                                                                    ind]
                                                                .mtpDateWiseDealersDtos !=
                                                            null
                                                        ? getDealerList(
                                                            mtpCurrentList[
                                                                    index]
                                                                .mtpDateWiseCitiesDtos![
                                                                    ind]
                                                                .town!,
                                                            mtpCurrentList[
                                                                    index]
                                                                .mtpDateWiseCitiesDtos![
                                                                    ind]
                                                                .mtpDateWiseDealersDtos!)
                                                        : []);
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
                    )),
                Container(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Constants.AUTH_ROLEID == Constants.ZHMANAGER
                          ? ListView.builder(
                              key: Key(
                                  'buildermtp3'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: managerUpcomingList.length,
                              itemBuilder: (context, index) {
                                List<MTPManagerList> filteredList =
                                    mtpManagerUpcomingList
                                        .where((element) =>
                                            element.createdUser ==
                                            managerCurrentList[index])
                                        .toList();
                                return CurveOuterBox(
                                    boxLRPadding: 0,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.only(right: 15),
                                        key: Key(index.toString()),
                                        initiallyExpanded: index == selected,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 22,
                                              color: Constant.callToCcolor1,
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name:
                                                      managerCurrentList[index],
                                                  fontColor:
                                                      Constant.colorBlack,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        children: [
                                          ListView.builder(
                                              key: Key(
                                                  'builder ${selected.toString()}'), //attention
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: filteredList.length,
                                              itemBuilder: (context, ind) {
                                                return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MtpViewScreen(
                                                                      mtpId: filteredList[
                                                                              index]
                                                                          .mtpId!)));
                                                    },
                                                    child: ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        title: CurveOuterBox(
                                                          boxBorderColor:
                                                              const Color(
                                                                  0xFFE7E7E7),
                                                          boxShadowColor:
                                                              const Color(
                                                                  0xFFFFFFFF),
                                                          boxBorderWidth: 0,
                                                          boxLRPadding: 0,
                                                          boxTBPadding: 0,
                                                          boxBRRadius: 5,
                                                          boxofWidget:
                                                              Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      top: 15,
                                                                      bottom:
                                                                          15),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFECECEC),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              25.0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              5.0),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              5.0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              25.0),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CommonText(
                                                                            name:
                                                                                "Booked No",
                                                                            fontColor:
                                                                                Constant.colorGray45,
                                                                            fontSize:
                                                                                Constant.fontSize12,
                                                                            fontWeight:
                                                                                Constant.fontWeight600,
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 5.0),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              CommonText(
                                                                                name: filteredList[ind].mtpNumber,
                                                                                fontColor: Constant.colorBlack,
                                                                                fontSize: Constant.fontSize11,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child:
                                                                              CommonLabel(
                                                                            labelRadiusBig:
                                                                                2.0,
                                                                            bgColor:
                                                                                Constant.booSauStacolor,
                                                                            name:
                                                                                filteredList[ind].status!,
                                                                            fontSize:
                                                                                Constant.fontSize11,
                                                                            fontColor:
                                                                                Constant.colorWhite,
                                                                            imageic:
                                                                                Constant.checkIc,
                                                                            imagetrue:
                                                                                true,
                                                                          ))
                                                                    ],
                                                                  )),
                                                        )));
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
                              })
                          : ListView.builder(
                              key: Key(
                                  'builder ${selected.toString()}'), //attention
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: mtpUpcomingList.length,
                              itemBuilder: (context, index) {
                                return CurveOuterBox(
                                    boxLRPadding: 0,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.zero,
                                        key: Key(index.toString()),
                                        initiallyExpanded: index == selected,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 22,
                                              color: Constant.callToCcolor1,
                                              margin:
                                                  const EdgeInsets.only(top: 3),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name: DateTimeUtils()
                                                      .dateToServerToDateFormat(
                                                          mtpUpcomingList[index]
                                                              .date!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MMM_YYYY_Format),
                                                  fontColor:
                                                      Constant.colorBlack,
                                                  fontSize: Constant.fontSize14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        children: [
                                          ListView.builder(
                                              key: Key(
                                                  'builder ${selected.toString()}'), //attention
                                              padding: const EdgeInsets.all(0),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: mtpUpcomingList[index]
                                                  .mtpDateWiseCitiesDtos!
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return Column(
                                                    children: mtpUpcomingList[
                                                                    index]
                                                                .mtpDateWiseCitiesDtos![
                                                                    ind]
                                                                .mtpDateWiseDealersDtos !=
                                                            null
                                                        ? getDealerList(
                                                            mtpUpcomingList[
                                                                    index]
                                                                .mtpDateWiseCitiesDtos![
                                                                    ind]
                                                                .town!,
                                                            mtpUpcomingList[
                                                                    index]
                                                                .mtpDateWiseCitiesDtos![
                                                                    ind]
                                                                .mtpDateWiseDealersDtos!)
                                                        : []);
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
                    ))
              ],
            ),
          ),
        ],
      ),
    );
    return BlocListener<MtpBloc, MtpState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            mtpCurrentList = state.mtpCurrentList;
            mtpUpcomingList = state.mtpUpcomingList;
            mtpManagerUpcomingList = state.mtpManagerUpcomingList;
            mtpManagerCurrentList = state.mtpManagerCurrentList;
            getManagerList();
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
          appBar: const CustomAppBar(title: "Total MTP", backArrow: true),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              SafeArea(
                child: CurveOuterBox(
                  boxLRPadding: 0,
                  boxTBPadding: 0,
                  boxofWidget: _tabmenu,
                ),
              ),
              progressBar
            ],
          ),
        ));
  }

  List<Widget> getDealerList(
      String townName, List<MtpDateWiseDealersDtos> dealers) {
    List<Widget> dealerList = [];
    for (MtpDateWiseDealersDtos d in dealers) {
      dealerList.add(ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: CurveOuterBox(
            boxBorderColor: const Color(0xFFE7E7E7),
            boxShadowColor: const Color(0xFFFFFFFF),
            boxBorderWidth: 0,
            boxLRPadding: 0,
            boxTBPadding: 0,
            boxBRRadius: 5,
            boxofWidget: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 15, bottom: 15),
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
                children: [
                  CommonText(
                    name: d.dealer,
                    fontColor: Constant.colorBlack,
                    fontSize: Constant.fontSize12,
                    fontWeight: Constant.fontWeight600,
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 12, height: 12, child: Constant.locatoinIc),
                      const SizedBox(width: 4),
                      CommonText(
                        name: townName,
                        fontColor: Constant.colorBlack,
                        fontSize: Constant.fontSize11,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )));
    }
    return dealerList;
  }

  void getManagerList() {
    for (MTPManagerList m in mtpManagerCurrentList) {
      if (managerCurrentList.indexOf(m.createdUser!) == -1) {
        managerCurrentList.add(m.createdUser!);
      }
    }
    for (MTPManagerList m in mtpManagerUpcomingList) {
      if (managerUpcomingList.indexOf(m.createdUser!) == -1) {
        managerUpcomingList.add(m.createdUser!);
      }
    }
  }
}
