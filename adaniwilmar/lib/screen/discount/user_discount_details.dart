import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../config/theme.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/user_discount_list.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/common_text.dart';
import '../../widget/curve_outer_box.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';
import 'bloc/discount_bloc.dart';
import 'bloc/discount_event.dart';
import 'bloc/discount_state.dart';

class UserDiscountDetailsScreen extends StatelessWidget {
  int? id;
  String? fromDate;
  String? toDate;

  UserDiscountDetailsScreen(
      {required this.id,
      required this.fromDate,
      required this.toDate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CreateDiscountBloc()..add(LoadUserDiscountDetails(id: id)),
      child: UserDiscount(fromDate: fromDate, toDate: toDate),
    );
  }
}

class UserDiscount extends StatefulWidget {
  String? fromDate;
  String? toDate;

  UserDiscount({Key? key, required this.fromDate, required this.toDate})
      : super(key: key);

  @override
  State<UserDiscount> createState() => _UserDiscountState();
}

class _UserDiscountState extends State<UserDiscount> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<UserDiscountDetails> userDiscountRequestDetails = [];
  ProgressBarHandler? _handler;

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

    return BlocBuilder<CreateDiscountBloc, CreateDiscountState>(
      builder: (context, state) {
        return SafeArea(
            child: BlocListener<CreateDiscountBloc, CreateDiscountState>(
          listener: (context, state) {
            if (state is UserDiscountDetailsRequestSuccess) {
              userDiscountRequestDetails = state.userDiscountDetailsList;
              GMLogger.v(userDiscountRequestDetails);
              // print(widget.index);
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
                title: "User Discount Details", backArrow: true),
            body: Stack(
                // clipBehavior: Clip.none,
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    child: Container(
                      child: Constant.bgImgGlobal,
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.980,
                    width: screenWidth,
                    margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                    child: SingleChildScrollView(
                      child: CurveBorderBox(
                        boxLRPadding: 0,
                        boxTOPPadding: 0,
                        boxofWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CurveBorderBox(
                              boxBgColor: const Color(0xFFFFFBF7),
                              boxShadowColor: const Color(0xFFFFFFFF),
                              boxofWidget: Container(
                                margin: const EdgeInsets.only(
                                    top: 16, left: 10, right: 8),
                                width: MediaQuery.of(context).size.width,
                                height: screenHeight * 0.08,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              name: "Valid From",
                                              fontSize: Constant.fontSize12,
                                              fontColor:
                                                  Constant.colorDullGray77),
                                          const SizedBox(height: 4),
                                          CommonText(
                                              name: widget.fromDate,
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CommonText(
                                              name: "Valid To",
                                              fontSize: Constant.fontSize12,
                                              fontColor:
                                                  Constant.colorDullGray77),
                                          const SizedBox(height: 4),
                                          CommonText(
                                              name: widget.toDate,
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide.none,
                                  ),
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                // child: ListView.separated(
                                //     shrinkWrap: true,
                                //     padding: const EdgeInsets.only(
                                //         top: 10, bottom: 10),
                                //     physics: const ClampingScrollPhysics(),
                                //     itemCount: userDiscountRequestDetails.length,
                                //     separatorBuilder:
                                //         (BuildContext context, int index) =>
                                //             const Divider(height: 3),
                                //     itemBuilder: (context, index) {
                                //       return Container(
                                //           width: double.infinity,
                                //           padding: const EdgeInsets.only(
                                //               left: 12,
                                //               right: 12,
                                //               top: 9,
                                //               bottom: 9),
                                //           decoration: const BoxDecoration(
                                //               border: Border.fromBorderSide(
                                //                   BorderSide.none)),
                                //           child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Column(children: [
                                //                   Row(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceBetween,
                                //                       children: [
                                //                         CommonText(
                                //                           name: userDiscountRequestDetails[index].employeeName.toString(),
                                //                           fontColor: Constant
                                //                               .colorBlack,
                                //                           fontSize: Constant
                                //                               .fontSize14,
                                //                           fontWeight: Constant
                                //                               .fontWeight600,
                                //                         ),
                                //                         CommonText(
                                //                           name: "Rs. "+ userDiscountRequestDetails[index].discount.toString() ?? "",
                                //                           fontSize: Constant
                                //                               .fontSize16,
                                //                           fontColor: Constant
                                //                               .colorOrange,
                                //                           fontWeight: Constant
                                //                               .fontWeight600,
                                //                         ),
                                //                       ]),
                                //                   SizedBox(height: 5),
                                //                   Row(
                                //                     mainAxisAlignment:
                                //                         MainAxisAlignment
                                //                             .spaceBetween,
                                //                     children: [
                                //                       CommonText(
                                //                         name: userDiscountRequestDetails[index].skuCode ?? "",
                                //                         fontColor:
                                //                             Constant.colorRed,
                                //                         fontSize: Constant
                                //                             .fontSize12,
                                //                         fontWeight: Constant
                                //                             .fontWeight600,
                                //                       ),
                                //                       CommonText(
                                //                         name: "Discount",
                                //                         fontSize: Constant
                                //                             .fontSize16,
                                //                         fontColor: Constant
                                //                             .colorOrange,
                                //                         fontWeight: Constant
                                //                             .fontWeight600,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ]),
                                //                 SizedBox(height: 10),
                                //                 CommonText(
                                //                   name: "Material Name",
                                //                   fontSize:
                                //                       Constant.fontSize12,
                                //                   fontColor: Constant
                                //                       .colorDullGray77,
                                //                 ),
                                //                 SizedBox(height: 5),
                                //                 CommonText(
                                //                   name:
                                //                       userDiscountRequestDetails[index].skuName ?? "",
                                //                   fontColor:
                                //                       Constant.colorBlack,
                                //                   fontSize:
                                //                       Constant.fontSize14,
                                //                   fontWeight:
                                //                       Constant.fontWeight600,
                                //                 ),
                                //               ]));
                                //     }),
                                child: ListView.builder(
                                    key: const Key('builder 1'),
                                    //attention
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: userDiscountRequestDetails.length,
                                    itemBuilder: (context, index) {
                                      return CurveOuterBox(
                                          boxLRPadding: 0,
                                          boxTBPadding: 4,
                                          boxofWidget: Theme(
                                            data: theme,
                                            child: ExpansionTile(
                                              tilePadding:
                                                  EdgeInsets.only(right: 15),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 3,
                                                    height: 22,
                                                    color:
                                                        Constant.callToCcolor1,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 3),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                      child: Container(
                                                          child: CommonText(
                                                    name: userDiscountRequestDetails[index].employeeName,
                                                    fontColor:
                                                        Constant.colorBlack,
                                                    fontSize:
                                                        Constant.fontSize14,
                                                    fontWeight:
                                                        Constant.fontWeight600,
                                                  ))),
                                                ],
                                              ),
                                              children: [
                                                ListView.builder(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: userDiscountRequestDetails[index].discountList?.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indx) {
                                                    return ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        title: Column(
                                                          children: [
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      userDiscountRequestDetails[index].discountList![indx].skuName.toString(),
                                                                      style: TextStyle(
                                                                          fontSize: Constant
                                                                              .fontSize13,
                                                                          color: Constant
                                                                              .colorBlack,
                                                                          fontWeight:
                                                                              Constant.fontWeight600),
                                                                    ),
                                                                    // const SizedBox(height: 4),
                                                                    CommonText(
                                                                      name: "",
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      fontColor:
                                                                          Constant
                                                                              .colorBlack,
                                                                    ),
                                                                  ],
                                                                )),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      left: 12,
                                                                      right: 12,
                                                                      bottom:
                                                                          8),
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          16),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonText(
                                                                                name: "State",
                                                                                fontSize: Constant.fontSize12,
                                                                                fontColor: Constant.colorDullGray77,
                                                                              ),
                                                                              const SizedBox(height: 6.0),
                                                                              CommonText(
                                                                                name: userDiscountRequestDetails[index].discountList![indx].stateName,
                                                                                fontSize: Constant.fontSize12,
                                                                                fontColor: Constant.colorBlack,
                                                                                fontWeight: Constant.fontWeight500,
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
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonText(
                                                                                name: "Discount (RS.)",
                                                                                fontSize: Constant.fontSize12,
                                                                                fontColor: Constant.colorDullGray77,
                                                                              ),
                                                                              const SizedBox(height: 6.0),
                                                                              CommonText(
                                                                                name: userDiscountRequestDetails[index].discountList![indx].discount?.toStringAsFixed(2),
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
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration: const BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Color(
                                                                              0xFFDFDFDF),
                                                                          width:
                                                                              0.8))),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          12),
                                                            ),
                                                          ],
                                                        ));
                                                  },
                                                )
                                              ],
                                              // onExpansionChanged: ((newState) {
                                              //   if (newState) {
                                              //     setState(() {
                                              //       selected = ind;
                                              //     });
                                              //   } else {
                                              //     setState(() {
                                              //       selected = -1;
                                              //     });
                                              //   }
                                              // }),
                                            ),
                                          ));
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  progressBar,
                ]),
          ),
        ));
      },
    );
  }
}
