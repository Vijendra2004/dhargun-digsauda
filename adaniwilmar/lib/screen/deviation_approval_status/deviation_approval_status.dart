import 'package:adaniwilmar/models/deviation_response.dart';
import 'package:adaniwilmar/screen/deviation_approval_status/bloc/bloc.dart';
import 'package:adaniwilmar/screen/new_deviation_request/new_deviation_request.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class DeviationApprovalStatusScreen extends StatelessWidget {
  const DeviationApprovalStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviationApprovalBloc()..add(LoadDeviationApprovalScreen(userId: Constants.AUTH_USERID)),
      child: const DeviationApprovalStatus(),
    );
  }
}

class DeviationApprovalStatus extends StatefulWidget {
  const DeviationApprovalStatus({Key? key}) : super(key: key);

  @override
  State<DeviationApprovalStatus> createState() => _DeviationApprovalStatusState();
}

class _DeviationApprovalStatusState extends State<DeviationApprovalStatus> with TickerProviderStateMixin {
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  ProgressBarHandler? _handler;
  List<DeviationResponse> deviationApprovedList = [];
  List<DeviationResponse> pendingDeviationList = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);

    indicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

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
    Widget homeGraphs = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(1),
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                margin: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: 70,
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
                        ? BoxDecoration(
                      color: Constant.colorYellow,
                    )
                        : tabController == 2
                        ? const BoxDecoration(color: Colors.green)
                        : BoxDecoration(
                      color: Constant.colorYellow,
                      borderRadius: const BorderRadius.only(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 15),
                                  child: CommonText(
                                      name: deviationApprovedList.length.toString(),
                                      fontSize: Constant.fontSize22,
                                      fontColor: tabController?.index == 0 ? Colors.white : Colors.black,
                                      fontWeight: Constant.fontWeight600),
                                )
                            ),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child:  CommonText(
                                    name: "Approval",
                                    fontSize: Constant.fontSize14,
                                    fontColor: tabController?.index == 0 ? Colors.white : Colors.black,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 15),
                                  child: CommonText(
                                      name: pendingDeviationList.length.toString(),
                                      fontSize: Constant.fontSize22,
                                      fontColor: tabController?.index == 1 ? Colors.white : Colors.black,
                                      fontWeight: Constant.fontWeight600),
                                )
                            ),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: CommonText(
                                    name: "Pending  ",
                                    fontSize: Constant.fontSize14,
                                    fontColor: tabController?.index == 1 ? Colors.white : Colors.black,
                                  ),
                                )
                            ),
                          ],
                        ),

                      ),
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SingleChildScrollView(
                        child: ListView.builder(
                            key: const Key('builder_1'),
                            //attention
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: deviationApprovedList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DeviationDetails(
                                                    deviationResponse: deviationApprovedList[index],
                                                  )));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                          borderRadius: const BorderRadius.only(
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
                                                height: 46.0,
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      deviationApprovedList[index].dealer!,
                                                      style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 3),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CommonText(
                                                                name: "Planned Date",
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorDullGray77,
                                                                fontWeight: Constant.fontWeight500,
                                                              ),
                                                              CommonText(
                                                                name: deviationApprovedList[index].actualDate!,
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight600,
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
                                                                name: "Deviation Date",
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorDullGray77,
                                                                fontWeight: Constant.fontWeight500,
                                                              ),
                                                              CommonText(
                                                                name: deviationApprovedList[index].revisedDate!,
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight600,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              );
                            })),
                    SingleChildScrollView(
                        child: ListView.builder(
                            key: const Key('builder_2'),
                            //attention
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pendingDeviationList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeviationDetails(deviationResponse: pendingDeviationList[index])));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                          borderRadius: const BorderRadius.only(
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
                                                height: 46.0,
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      pendingDeviationList[index].dealer!,
                                                      style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 3),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CommonText(
                                                                name: "Planned Date",
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorDullGray77,
                                                                fontWeight: Constant.fontWeight500,
                                                              ),
                                                              CommonText(
                                                                name: pendingDeviationList[index].actualDate!,
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight600,
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
                                                                name: "Deviation Date",
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorDullGray77,
                                                                fontWeight: Constant.fontWeight500,
                                                              ),
                                                              CommonText(
                                                                name: pendingDeviationList[index].revisedDate!,
                                                                fontSize: Constant.fontSize10,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight600,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              );
                            }))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return BlocListener<DeviationApprovalBloc, DeviationApprovalState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            deviationApprovedList = state.deviationList;
            pendingDeviationList = state.pendingDeviationList;
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
              appBar: const CustomAppBar(title: "Total Deviation", backArrow: true),
              floatingActionButton: Visibility(
                  visible: Constants.SALE == Constants.AUTH_ROLEID,
                  child: FloatingButton(
                      buttonBgColor: Constant.colorRed,
                      buttonIcon: Constant.saudaIcPlus,
                      navigationFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewDeviationRequestScreen()),
                        );
                        },
                      buttoniconSize: 20)),
              body: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: Container(
                      child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                height: screenHeight * 0.98,
                width: screenWidth,
                margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                child: CurveBorderBox(
                  boxLRPadding: 0,
                  boxofWidget: homeGraphs,
                ),
              ),
              progressBar
            ],
          ),
        )));
  }
}
