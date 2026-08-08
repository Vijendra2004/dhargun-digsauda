import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/screen/special_rate_approval_next.dart/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SpecialRateApprovalNext extends StatelessWidget {
  int dealerId;
  int specialRateId;
  SpecialRateApprovalNext(
      {required this.dealerId, required this.specialRateId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialRateApprovalViewBloc()
        ..add(LoadSpecialRateApprovalViewScreen(
            userId: Constants.AUTH_USERID,
            dealerId: dealerId,
            specialRateId: specialRateId)),
      child: const SpecialRateApprovalNextDetail(),
    );
  }
}

class SpecialRateApprovalNextDetail extends StatefulWidget {
  const SpecialRateApprovalNextDetail({Key? key}) : super(key: key);

  @override
  State<SpecialRateApprovalNextDetail> createState() =>
      SpecialRateApprovalNextState();
}

class SpecialRateApprovalNextState
    extends State<SpecialRateApprovalNextDetail> {
  SpecialRateView specialRateView = SpecialRateView();
  List<Widget> skus = [];
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
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
    return BlocListener<SpecialRateApprovalViewBloc,
            SpecialRateApprovalViewState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            specialRateView = state.sprateInfo;
            getSkuDetail();
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
            title: "Special Rate Approval Details",
            backArrow: true,
            listOfActions: Row(
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: SizedBox(
                //     width: 30.0,
                //     height: 30.0,
                //     child: Container(
                //       decoration: const BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.all(Radius.circular(30))),
                //       padding: const EdgeInsets.all(7),
                //       child: Constant.filterIc,
                //     ),
                //   ),
                // ),
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
                        CurveOuterBox(
                            boxBgColor: const Color(0xFFFFFBF7),
                            boxShadowColor: const Color(0xFFFFFFFF),
                            boxofWidget: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              name: "Request Date",
                                              fontSize: Constant.fontSize13,
                                              fontColor:
                                                  Constant.colorDullGray77,
                                            ),
                                            CommonText(
                                              name: specialRateView
                                                          .requestDate !=
                                                      null
                                                  ? DateTimeUtils()
                                                      .dateToServerToDateFormat(
                                                          specialRateView
                                                              .requestDate!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format)
                                                  : "",
                                              fontSize: Constant.fontSize13,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: CommonLabel(
                                            bgColor: specialRateView.statusId !=
                                                    null
                                                ? (specialRateView.statusId == 1
                                                    ? Constant
                                                        .statusPendingColor
                                                    : specialRateView
                                                                .statusId ==
                                                            2
                                                        ? Constant
                                                            .statusCompletedColor
                                                        : Constant
                                                            .statusRejectedColor)
                                                : Constant.statusPendingColor,
                                            name: specialRateView.status ?? "",
                                            fontSize: Constant.fontSize11,
                                            fontColor: Constant.colorWhite,
                                            imageic: Constant.checkIc,
                                            imagetrue: true,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Column(
                          children: skus,
                        ),
                      ],
                    ),
                  )
                ],
              )),
              progressBar
            ],
          ),
          // bottomNavigationBar: CustomNavBar()
        ));
  }

  void getSkuDetail() {
    skus = [];
    if (specialRateView.skuList != null) {
      for (int i = 0; i < specialRateView.skuList!.length; i++) {
        skus.add(SpecialRateWid(skuDetail: specialRateView.skuList![i]));
      }
    }
  }
}
