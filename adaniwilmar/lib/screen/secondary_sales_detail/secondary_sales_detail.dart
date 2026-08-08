import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:adaniwilmar/screen/secondary_sales_detail/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SecondarySalesDetailScreen extends StatelessWidget {
  int wholeSellerId = 0;
  String distributorName = "";
  double totalPrice = 0;
  String visitDate = "";
  SecondarySalesDetailScreen(
      {required this.wholeSellerId,
      required this.distributorName,
      required this.totalPrice,
      required this.visitDate,
      Key? key})
      : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SecondarySalesDetailScreen(
              wholeSellerId: 0,
              distributorName: "",
              totalPrice: 0,
              visitDate: "",
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SecondarySalesDetailBloc()
        ..add(LoadSecondarySalesDetailScreen(
            userId: Constants.AUTH_USERID,
            wholeSellerId: wholeSellerId,
            visitDate: visitDate)),
      child: SecondarySalesDetail(
        wholeSellerId: wholeSellerId,
        visitDate: visitDate,
        totalPrice: totalPrice,
        distributorName: distributorName,
      ),
    );
  }
}

class SecondarySalesDetail extends StatefulWidget {
  int wholeSellerId = 0;
  String distributorName = "";
  double totalPrice = 0;
  String visitDate = "";

  SecondarySalesDetail(
      {required this.wholeSellerId,
      required this.distributorName,
      required this.totalPrice,
      required this.visitDate,
      Key? key})
      : super(key: key);

  @override
  State<SecondarySalesDetail> createState() => _SecondarySalesDetailState();
}

class _SecondarySalesDetailState extends State<SecondarySalesDetail> {
  List<SecondarySalesFortheDayDetailViewDto> secondarySalesDetailList = [];
  ProgressBarHandler? _handler;
  double screenWidth = 0.0;
  double screenHeight = 0.0;

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
    return BlocListener<SecondarySalesDetailBloc, SecondarySalesDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            secondarySalesDetailList = state.secondarySalesDetail;
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
            title: "Secondary Sales Details",
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
                  height: screenHeight * 0.980,
                  color: Colors.red,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                    boxLRPadding: 8,
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
                                              name: "Distributor Name",
                                              fontSize: Constant.fontSize13,
                                              fontColor:
                                                  Constant.colorDullGray77,
                                            ),
                                            CommonText(
                                              name: widget.distributorName,
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
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
                                            color: const Color(0xFFDEDEDE)),
                                        color: const Color(0xFFffffff),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(0),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                secondarySalesDetailList.length,
                                            itemBuilder: (context, index) {
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
                                                                  height: 8,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                        child:
                                                                            CommonText(
                                                                      name: secondarySalesDetailList[
                                                                              index]
                                                                          .skuName,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize10,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight600,
                                                                    )),
                                                                    const SizedBox(
                                                                        width:
                                                                            6),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: CommonText(
                                                                name: secondarySalesDetailList[
                                                                        index]
                                                                    .quantity
                                                                    .toString(),
                                                                fontSize: Constant
                                                                    .fontSize11,
                                                                fontColor: Constant
                                                                    .colorOrange,
                                                                fontWeight: Constant
                                                                    .fontWeight500,
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                    name: secondarySalesDetailList[
                                                                            index]
                                                                        .oilType,
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize11,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
                                                                  ),
                                                                  // CommonText(
                                                                  //   name: "Rs." +
                                                                  //       secondarySalesDetailList
                                                                  //           [index]
                                                                  //           .price!
                                                                  //           .toStringAsFixed(2)
                                                                  //       ,
                                                                  //   fontSize:
                                                                  //       Constant
                                                                  //           .fontSize10,
                                                                  //   fontColor:
                                                                  //       Constant
                                                                  //           .colorDullGray77,
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: CommonText(
                                                                name: "Rs." +
                                                                    (secondarySalesDetailList[index]
                                                                            .price!)
                                                                        .toStringAsFixed(
                                                                            2),
                                                                fontSize: Constant
                                                                    .fontSize15,
                                                                fontColor: Constant
                                                                    .colorBlack,
                                                                fontWeight: Constant
                                                                    .fontWeight600,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                      top: BorderSide(
                                                        color:
                                                            Color(0xFFD5D5D5),
                                                        width: 0.8,
                                                      ),
                                                    )),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Expanded(child: Container()),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Row(
                                                  children: [
                                                    CommonText(
                                                      name: "Total Price",
                                                      fontSize:
                                                          Constant.fontSize11,
                                                      fontColor: Constant
                                                          .colorDullGray77,
                                                      fontWeight: Constant
                                                          .fontWeight500,
                                                    ),
                                                    const SizedBox(width: 24),
                                                    CommonText(
                                                      name: "Rs. " +
                                                          widget.totalPrice
                                                              .toStringAsFixed(
                                                                  2),
                                                      fontSize:
                                                          Constant.fontSize15,
                                                      fontColor:
                                                          Constant.colorGreencc,
                                                      fontWeight: Constant
                                                          .fontWeight600,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
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
                  )),
              progressBar
            ],
          ),
        )));
  }
}
