import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:adaniwilmar/screen/secondary_sales/bloc/bloc.dart';
import 'package:adaniwilmar/screen/secondary_sales_detail/secondary_sales_detail.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SecondarySalesScreen extends StatelessWidget {
  const SecondarySalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SecondarySalesBloc()
        ..add(LoadSecondarySalesScreen(
          userId: Constants.AUTH_USERID,
        )),
      child: const SecondarySales(),
    );
  }
}

class SecondarySales extends StatefulWidget {
  const SecondarySales({Key? key}) : super(key: key);

  @override
  State<SecondarySales> createState() => _SecondarySalesState();
}

class _SecondarySalesState extends State<SecondarySales> {
  int selected = 0 - 1;
  List<SecondarySalesFortheDayViewDto> secondarySalesList = [];
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

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
    return BlocListener<SecondarySalesBloc, SecondarySalesState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            secondarySalesList = state.secondarySales;
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
          appBar: const CustomAppBar(
                title: "Reports",
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
              SingleChildScrollView(
                  child: Container(
                    height: screenHeight,
                    margin: const EdgeInsets.only(top: 64),
                child: 
                  CurveOuterBox(
                    boxofWidget: Expanded(
                          child: ListView.builder(
                              key: Key(
                                  'builderss'), //attention
                              // padding: const EdgeInsets.only(top: 60),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: secondarySalesList.length,
                              itemBuilder: (context, index) {
                                return CurveOuterBox(
                                    boxLRPadding: 0,
                                    boxTBPadding: 4,
                                    boxofWidget: Theme(
                                      data: theme,
                                      child: ExpansionTile(
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
                                                          secondarySalesList[
                                                                  index]
                                                              .visitDate!,
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
                                              itemCount: secondarySalesList[
                                                      index]
                                                  .wholesellerSecondarySales!
                                                  .length,
                                              itemBuilder: (context, ind) {
                                                return ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  title: Container(
                                                      color: const Color(
                                                          0xFFF7F7F7),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              top: 8,
                                                              bottom: 8),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => SecondarySalesDetailScreen(
                                                                    wholeSellerId: secondarySalesList[
                                                                            index]
                                                                        .wholesellerSecondarySales![
                                                                            ind]
                                                                        .wholesellerId!,
                                                                    distributorName: secondarySalesList[
                                                                            index]
                                                                        .wholesellerSecondarySales![
                                                                            ind]
                                                                        .dealer!,
                                                                    totalPrice: secondarySalesList[
                                                                            index]
                                                                        .wholesellerSecondarySales![
                                                                            ind]
                                                                        .totalPrice!,
                                                                    visitDate: secondarySalesList[
                                                                            index]
                                                                        .wholesellerSecondarySales![
                                                                            ind]
                                                                        .visitDate!)),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      25.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      5.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 46.0,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      top: 9,
                                                                      bottom:
                                                                          9),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF5F5F5),
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
                                                                              0.0),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        secondarySalesList[index]
                                                                            .wholesellerSecondarySales![ind]
                                                                            .dealer!,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Constant.fontSize13,
                                                                            color: Constant.colorBlack,
                                                                            fontWeight: Constant.fontWeight600),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              const BorderBottom(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        bottom:
                                                                            12),
                                                                child: Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                        height:
                                                                            3),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                CommonText(
                                                                                  name: "Total Quantity",
                                                                                  fontSize: Constant.fontSize10,
                                                                                  fontColor: Constant.colorDullGray77,
                                                                                  fontWeight: Constant.fontWeight500,
                                                                                ),
                                                                                CommonText(
                                                                                  name: secondarySalesList[index].wholesellerSecondarySales![ind].totalQuantity!.toStringAsFixed(2),
                                                                                  fontSize: Constant.fontSize10,
                                                                                  fontColor: Constant.colorBlack,
                                                                                  fontWeight: Constant.fontWeight600,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                CommonText(
                                                                                  name: "Total Price",
                                                                                  fontSize: Constant.fontSize10,
                                                                                  fontColor: Constant.colorDullGray77,
                                                                                  fontWeight: Constant.fontWeight500,
                                                                                ),
                                                                                CommonText(
                                                                                  name: "Rs. " + secondarySalesList[index].wholesellerSecondarySales![ind].totalPrice!.toStringAsFixed(2),
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
                                                      )),
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
                  ),
                
              )),
              progressBar
            ],
          ),
        ));
  }
}
