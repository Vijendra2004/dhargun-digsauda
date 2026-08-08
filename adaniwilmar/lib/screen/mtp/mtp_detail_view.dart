import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/screen/mtp/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class MtpViewScreen extends StatelessWidget {
  int mtpId = 0;
  MtpViewScreen({required this.mtpId, Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => MtpViewScreen(
              mtpId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MtpBloc()
        ..add(LoadMtpViewScreen(userId: Constants.AUTH_USERID, id: mtpId)),
      child: MtpView(),
    );
  }
}

class MtpView extends StatefulWidget {
  MtpView({Key? key}) : super(key: key);

  @override
  State<MtpView> createState() => _MtpViewState();
}

class _MtpViewState extends State<MtpView> {
  MTPManagerDetail detail = MTPManagerDetail();
  double totalPrice = 0;
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<MtpBloc, MtpState>(
        listener: (context, state) {
          if (state is OnLoadMTPDetailSuccess) {
            detail = state.mtpDetail;
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
                  detail.mtpId == null
                      ? Text("")
                      : CurveOuterBox(
                          boxLRPadding: 0,
                          boxTBPadding: 0,
                          boxofWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CurveOuterBox(
                                  boxBgColor: const Color(0xFFFFFBF7),
                                  boxShadowColor: const Color(0xFFFFFFFF),
                                  boxofWidget: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    name: "Created By",
                                                    fontSize:
                                                        Constant.fontSize13,
                                                    fontColor: Constant
                                                        .colorDullGray77,
                                                  ),
                                                  CommonText(
                                                    name: detail.createdUser,
                                                    fontSize:
                                                        Constant.fontSize12,
                                                    fontColor:
                                                        Constant.colorBlack,
                                                    fontWeight:
                                                        Constant.fontWeight600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    name: "Mtp Number",
                                                    fontSize:
                                                        Constant.fontSize13,
                                                    fontColor: Constant
                                                        .colorDullGray77,
                                                  ),
                                                  CommonText(
                                                    name: detail.mtpNumber,
                                                    fontSize:
                                                        Constant.fontSize12,
                                                    fontColor:
                                                        Constant.colorBlack,
                                                    fontWeight:
                                                        Constant.fontWeight600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 8),
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
                                            padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12,
                                                top: 9,
                                                bottom: 9),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xFFDEDEDE)),
                                              color: const Color(0xFFffffff),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(25.0),
                                                topRight: Radius.circular(5.0),
                                                bottomLeft:
                                                    Radius.circular(5.0),
                                                bottomRight:
                                                    Radius.circular(25.0),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: detail
                                                              .monthlyTourPlanDetailList !=
                                                          null
                                                      ? detail
                                                          .monthlyTourPlanDetailList!
                                                          .length
                                                      : 0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                              child: CommonText(
                                                                            name:
                                                                                detail.monthlyTourPlanDetailList![index].dealer,
                                                                            fontColor:
                                                                                Constant.colorBlack,
                                                                            fontSize:
                                                                                Constant.fontSize10,
                                                                            fontWeight:
                                                                                Constant.fontWeight600,
                                                                          )),
                                                                          const SizedBox(
                                                                              width: 6),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 6),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CommonText(
                                                                          name: detail.monthlyTourPlanDetailList![index].town ??
                                                                              "",
                                                                          fontSize:
                                                                              Constant.fontSize11,
                                                                          fontColor:
                                                                              Constant.colorBlack,
                                                                          fontWeight:
                                                                              Constant.fontWeight500,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    child:
                                                                        CommonText(
                                                                      name: DateTimeUtils().dateToServerToDateFormat(
                                                                          detail
                                                                              .monthlyTourPlanDetailList![
                                                                                  index]
                                                                              .mtpDate!,
                                                                          DateTimeUtils
                                                                              .YYYY_MM_DD_Format,
                                                                          DateTimeUtils
                                                                              .DD_MMM_YYYY_Format),
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize15,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight600,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 12),
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                            top: BorderSide(
                                                              color: Color(
                                                                  0xFFD5D5D5),
                                                              width: 0.8,
                                                            ),
                                                          )),
                                                        ),
                                                      ],
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
