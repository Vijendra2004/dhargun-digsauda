import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/screen/pcp/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class PcpViewScreen extends StatelessWidget {
  int pjpId = 0;
  PcpViewScreen({required this.pjpId, Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => PcpViewScreen(
              pjpId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PcpBloc()
        ..add(LoadPcpViewScreen(userId: Constants.AUTH_USERID, id: pjpId)),
      child: PcpView(),
    );
  }
}

class PcpView extends StatefulWidget {
  PcpView({Key? key}) : super(key: key);

  @override
  State<PcpView> createState() => _PcpViewState();
}

class _PcpViewState extends State<PcpView> {
  PCPManagerDetail detail = PCPManagerDetail();
  double totalPrice = 0;
  ProgressBarHandler? _handler;
  double screenHeight = 0;
  double screenWidth = 0;

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
    return BlocListener<PcpBloc, PcpState>(
        listener: (context, state) {
          if (state is OnLoadPCPDetailSuccess) {
            detail = state.pcpDetail;
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
          appBar: CustomAppBar(
            title: "PCP Detail",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(7),
                      child: Constant.searchIc,
                    ),
                  ),
                ),
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
              SingleChildScrollView(
                  child: Column(
                children: [
                  Container(height: Constant.containerTopWrapper),
                  CurveOuterBox(
                    boxLRPadding: 0,
                    boxTBPadding: 0,
                    boxofWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(0),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: detail
                                                        .permanentJourneyPlanDetails !=
                                                    null
                                                ? detail
                                                    .permanentJourneyPlanDetails!
                                                    .length
                                                : 0,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CurveOuterBox(
                                                            boxLRPadding: 0,
                                                            boxBgColor:
                                                                const Color(
                                                                    0xFFFFFBF7),
                                                            boxShadowColor:
                                                                const Color(
                                                                    0xFFFFFFFF),
                                                            boxofWidget:
                                                                Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CommonText(
                                                                              name: detail.permanentJourneyPlanDetails![index].retailer,
                                                                              fontSize: Constant.fontSize13,
                                                                              fontColor: Constant.colorBlack,
                                                                            ),
                                                                            CommonText(
                                                                              name: "",
                                                                              fontSize: Constant.fontSize12,
                                                                              fontColor: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight600,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child:
                                                                              CommonLabel(
                                                                            bgColor:
                                                                                Constant.booSauStacolor,
                                                                            name:
                                                                                detail.status ?? "",
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
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                            height: 8),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                    name:
                                                                        "No. of Visits",
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize13,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorDullGray77,
                                                                  ),
                                                                  CommonText(
                                                                    name: detail
                                                                        .permanentJourneyPlanDetails![
                                                                            index]
                                                                        .noOfVisit
                                                                        .toString(),
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
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
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                      name:
                                                                          "No of Sub Dealer Visit",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorDullGray77),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  CommonText(
                                                                      name: detail
                                                                          .permanentJourneyPlanDetails![
                                                                              index]
                                                                          .noOfSubDealer
                                                                          .toString(),
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                      name:
                                                                          "No of Whole seller Visit",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorDullGray77),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  CommonText(
                                                                      name: detail
                                                                          .permanentJourneyPlanDetails![
                                                                              index]
                                                                          .noOfWholeSeller
                                                                          .toString(),
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                      name:
                                                                          "Remarks",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorDullGray77),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  CommonText(
                                                                      name: detail
                                                                              .permanentJourneyPlanDetails![
                                                                                  index]
                                                                              .remarks ??
                                                                          "",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 12)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
              progressBar
            ],
          ),
        ));
  }
}
