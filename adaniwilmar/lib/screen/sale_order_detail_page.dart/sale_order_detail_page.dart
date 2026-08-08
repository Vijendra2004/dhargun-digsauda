import 'package:adaniwilmar/models/lifting_detail_response.dart';
import 'package:adaniwilmar/models/sales_order_approval_request.dart';
import 'package:adaniwilmar/screen/sale_order_detail_page.dart/bloc/bloc.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SalesOrderDetailPageScreen extends StatelessWidget {
  SalesOrderDetailPageScreen({required this.id, Key? key}) : super(key: key);
  int id = 0;
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SalesOrderDetailPageScreen(
              id: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesOrderDetailPageBloc()
        ..add(LoadSalesOrderDetailPageScreen(
          userId: Constants.AUTH_USERID,
          id: id,
        )),
      child: SalesOrderDetailPage(
        id: id,
      ),
    );
  }
}

class SalesOrderDetailPage extends StatefulWidget {
  SalesOrderDetailPage({required this.id, Key? key}) : super(key: key);
  int id = 0;

  @override
  State<SalesOrderDetailPage> createState() => _SalesOrderDetailPageState();
}

class _SalesOrderDetailPageState extends State<SalesOrderDetailPage> with TickerProviderStateMixin {
  LiftingDetailResponse liftingDetail = LiftingDetailResponse();
  List<String?> enquiryNos = [];
  Map<String?, List<LiftingRequestDetailList>> enquiryList = <String?, List<LiftingRequestDetailList>>{};
  ProgressBarHandler? _handler;
  double screenWidth = 0;
  double screenHeight = 0;
  int approvalStatusId = 0;

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
    return BlocListener<SalesOrderDetailPageBloc, SalesOrderDetailPageState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            liftingDetail = state.liftingDetail;
            enquiryNos = [];
            enquiryList.clear();
            getEnquiryDetail();
            setState(() {});
          }
          if (state is OnApprovalSuccess) {
            showSuccessDlg(context, approvalStatusId == 2 ? "Sales Order Approved" : "Sales Order Rejected", "Sales Order Approval",
                successText: approvalStatusId == 2 ? "Sales Order Approved" : "Sales Order Rejected");
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
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
                  title: "Sales Order", //"Lifting Number - " + (liftingDetail.liftingNumber ?? ""),
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
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(height: Constant.containerTopWrapper),
                        CurveOuterBox(
                          boxLRPadding: 0,
                          boxTBPadding: 0,
                          boxofWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Sales Order Request No", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: liftingDetail.liftingNumber ?? "", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Distributor Name", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(name: liftingDetail.dealer ?? "", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Requested Date", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: liftingDetail.liftingDate != null
                                                          ? DateTimeUtils().dateToServerToDateFormat(liftingDetail.liftingDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format)
                                                          : "",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Ship to Party", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(name: liftingDetail.shipToParty ?? "", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Visibility(
                                                visible: false,
                                                child: Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      CommonText(name: "Vehicle Size (in MT)", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                      const SizedBox(height: 4),
                                                      CommonText(
                                                          name: liftingDetail.vehicleSize != null ? liftingDetail.vehicleSize!.toStringAsFixed(2) : "",
                                                          fontSize: Constant.fontSize12,
                                                          fontColor: Constant.colorBlack,
                                                          fontWeight: Constant.fontWeight500),
                                                    ],
                                                  ),
                                                )),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Plant", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(name: liftingDetail.plantName ?? "", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Remarks", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: liftingDetail.enquiryRemarks ?? "", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                            Expanded(child: Column()),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    CommonText(name: "Price Details", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                    const SizedBox(height: 8),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(0),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: enquiryNos.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFECECEC),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(25.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(0.0),
                                                    bottomRight: Radius.circular(0.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CommonText(
                                                      name: "Sales Order No",
                                                      fontColor: Color(0xFF757575),
                                                      fontSize: Constant.fontSize14,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    CommonText(
                                                      name: enquiryNos[index] ?? " N/A",
                                                      fontColor: Constant.colorBlack,
                                                      fontSize: Constant.fontSize14,
                                                      fontWeight: Constant.fontWeight600,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets.all(0),
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: enquiryList[enquiryNos[index]]!.length,
                                                  itemBuilder: (context, idx) {
                                                    LiftingRequestDetailList detail = enquiryList[enquiryNos[index]]![idx];
                                                    return Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                                          color: const Color(0xFFF5F5F5),
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(0.0),
                                                            topRight: Radius.circular(0.0),
                                                            bottomLeft: Radius.circular(5.0),
                                                            bottomRight: Radius.circular(0.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: <Widget>[
                                                                ListTile(
                                                                  contentPadding: const EdgeInsets.all(0),
                                                                  title: CommonText(
                                                                    name: detail.skuName ?? "",
                                                                    fontColor: Constant.colorBlack,
                                                                    fontSize: Constant.fontSize14,
                                                                    fontWeight: Constant.fontWeight600,
                                                                  ),
                                                                  subtitle: CommonText(
                                                                    name: "(" + (detail.liftingQuantityInMT!.toStringAsFixed(2)) + " MT)",
                                                                    fontColor: Constant.colorRed,
                                                                    fontSize: Constant.fontSize12,
                                                                    fontWeight: Constant.fontWeight600,
                                                                  ),
                                                                  trailing: CommonText(
                                                                    name: "Rs." + detail.finalRate!.toStringAsFixed(2),
                                                                    fontSize: Constant.fontSize16,
                                                                    fontColor: Constant.colorOrange,
                                                                    fontWeight: Constant.fontWeight600,
                                                                  ),
                                                                ),
                                                                // Row(
                                                                //   children: <Widget>[
                                                                //     Expanded(
                                                                //       child: Column(
                                                                //         crossAxisAlignment:
                                                                //             CrossAxisAlignment
                                                                //                 .start,
                                                                //         mainAxisAlignment:
                                                                //             MainAxisAlignment
                                                                //                 .start,
                                                                //         children: [
                                                                //           const SizedBox(
                                                                //             height: 8,
                                                                //           ),
                                                                //           Row(
                                                                //             mainAxisAlignment:
                                                                //                 MainAxisAlignment
                                                                //                     .start,
                                                                //             crossAxisAlignment:
                                                                //                 CrossAxisAlignment
                                                                //                     .start,
                                                                //             children: <
                                                                //                 Widget>[
                                                                //               SizedBox(
                                                                //                   width:
                                                                //                       MediaQuery.of(context).size.width * 0.50,
                                                                //                   child: Expanded(
                                                                //                       child: CommonText(
                                                                //                     name: detail.skuName ?? "",
                                                                //                     fontColor: Constant.colorBlack,
                                                                //                     fontSize: Constant.fontSize14,
                                                                //                     fontWeight: Constant.fontWeight600,
                                                                //                   ))),
                                                                //               SizedBox(
                                                                //                   width: MediaQuery.of(context).size.width *
                                                                //                       0.20,
                                                                //                   child:
                                                                //                       CommonText(
                                                                //                     name: "(" + (detail.liftingQuantityInMT!.toStringAsFixed(2)) + " MT)",
                                                                //                     fontColor: Constant.colorRed,
                                                                //                     fontSize: Constant.fontSize12,
                                                                //                     fontWeight: Constant.fontWeight600,
                                                                //                   )),
                                                                //             ],
                                                                //           )
                                                                //         ],
                                                                //       ),
                                                                //     ),
                                                                //     const SizedBox(
                                                                //         width: 10),
                                                                //     Align(
                                                                //         alignment:
                                                                //             Alignment
                                                                //                 .centerRight,
                                                                //         child:
                                                                //             CommonText(
                                                                //           name: detail
                                                                //               .liftingQuantity!
                                                                //               .toStringAsFixed(
                                                                //                   2),
                                                                //           fontSize:
                                                                //               Constant
                                                                //                   .fontSize11,
                                                                //           fontColor:
                                                                //               Constant
                                                                //                   .colorOrange,
                                                                //           fontWeight:
                                                                //               Constant
                                                                //                   .fontWeight500,
                                                                //         ))
                                                                //   ],
                                                                // ),
                                                                // const SizedBox(
                                                                //     height: 16),
                                                                // SizedBox(
                                                                //   width:
                                                                //       double.infinity,
                                                                //   child: Row(
                                                                //     children: [
                                                                //       Expanded(
                                                                //         child: Column(
                                                                //           crossAxisAlignment:
                                                                //               CrossAxisAlignment
                                                                //                   .start,
                                                                //           children: [
                                                                //             CommonText(
                                                                //               name:
                                                                //                   "",
                                                                //               fontSize:
                                                                //                   Constant.fontSize11,
                                                                //               fontColor:
                                                                //                   Constant.colorDullGray77,
                                                                //               fontWeight:
                                                                //                   Constant.fontWeight500,
                                                                //             ),
                                                                //             CommonText(
                                                                //               name: detail.remarks ??
                                                                //                   "",
                                                                //               fontSize:
                                                                //                   Constant.fontSize10,
                                                                //               fontColor:
                                                                //                   Constant.colorBlack,
                                                                //               fontWeight:
                                                                //                   Constant.fontWeight600,
                                                                //             ),
                                                                //           ],
                                                                //         ),
                                                                //       ),
                                                                //     ],
                                                                //   ),
                                                                // ),
                                                                // Row(children: [
                                                                //   Text(
                                                                //       "Enquiry Remarks")
                                                                // ]),
                                                                // SizedBox(
                                                                //     height: 3),
                                                                // Row(children: [
                                                                //   Flexible(
                                                                //       child:
                                                                //           Text(
                                                                //     detail.enquiryRemarks ??
                                                                //         "",
                                                                //     style: TextStyle(
                                                                //         fontSize:
                                                                //             Constant
                                                                //                 .fontSize14,
                                                                //         fontWeight:
                                                                //             Constant
                                                                //                 .fontWeight600,
                                                                //         overflow:
                                                                //             TextOverflow.visible),
                                                                //   ))
                                                                // ])
                                                              ],
                                                            ),
                                                            const SizedBox(height: 12),
                                                            // Container(
                                                            //   decoration: const BoxDecoration(
                                                            //       border: Border(
                                                            //         top: BorderSide(
                                                            //           color: Color(0xFFD5D5D5),
                                                            //           width: 0.8,
                                                            //         ),
                                                            //       )),
                                                            // ),
                                                            // Container(
                                                            //   child: Column(
                                                            //     children: [
                                                            //       Row(
                                                            //         children: [
                                                            //           Expanded(
                                                            //             child: Column(
                                                            //               crossAxisAlignment:
                                                            //               CrossAxisAlignment
                                                            //                   .start,
                                                            //               mainAxisAlignment:
                                                            //               MainAxisAlignment.end,
                                                            //               children: [
                                                            //                 const SizedBox(
                                                            //                   height: 8,
                                                            //                 ),
                                                            //                 Row(
                                                            //                   children: [
                                                            //                     CommonText(
                                                            //                       name:
                                                            //                       "RPO 15 Itr Tin (New)-NEW",
                                                            //                       fontColor: Constant
                                                            //                           .colorBlack,
                                                            //                       fontSize: Constant
                                                            //                           .fontSize12,
                                                            //                       fontWeight: Constant
                                                            //                           .fontWeight600,
                                                            //                     ),
                                                            //                     const SizedBox(
                                                            //                         width: 6),
                                                            //                     CommonText(
                                                            //                       name: "(7 MT)",
                                                            //                       fontColor: Constant
                                                            //                           .colorRed,
                                                            //                       fontSize: Constant
                                                            //                           .fontSize12,
                                                            //                       fontWeight: Constant
                                                            //                           .fontWeight600,
                                                            //                     ),
                                                            //                   ],
                                                            //                 )
                                                            //               ],
                                                            //             ),
                                                            //           ),
                                                            //           Align(
                                                            //               alignment:
                                                            //               Alignment.centerRight,
                                                            //               child: CommonText(
                                                            //                 name: "2000 Case",
                                                            //                 fontSize:
                                                            //                 Constant.fontSize11,
                                                            //                 fontColor:
                                                            //                 Constant.colorOrange,
                                                            //                 fontWeight: Constant
                                                            //                     .fontWeight500,
                                                            //               ))
                                                            //         ],
                                                            //       ),
                                                            //       const SizedBox(height: 16),
                                                            //       Container(
                                                            //         width: double.infinity,
                                                            //         child: Row(
                                                            //           children: [
                                                            //             Expanded(
                                                            //               child: Column(
                                                            //                 crossAxisAlignment:
                                                            //                 CrossAxisAlignment
                                                            //                     .start,
                                                            //                 children: [
                                                            //                   CommonText(
                                                            //                     name:
                                                            //                     "Ex - Haldia - Cuttack",
                                                            //                     fontSize: Constant
                                                            //                         .fontSize11,
                                                            //                     fontColor: Constant
                                                            //                         .colorDullGray77,
                                                            //                     fontWeight: Constant
                                                            //                         .fontWeight500,
                                                            //                   ),
                                                            //                   CommonText(
                                                            //                     name:
                                                            //                     "Inquiry 19022928 has been saved",
                                                            //                     fontSize: Constant
                                                            //                         .fontSize10,
                                                            //                     fontColor: Constant
                                                            //                         .colorBlack,
                                                            //                     fontWeight: Constant
                                                            //                         .fontWeight600,
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //             ),
                                                            //           ],
                                                            //         ),
                                                            //       ),
                                                            //     ],
                                                            //   ),
                                                            // ),
                                                            // const SizedBox(height: 12),
                                                            // Container(
                                                            //   decoration: const BoxDecoration(
                                                            //       border: Border(
                                                            //         top: BorderSide(
                                                            //           color: Color(0xFFD5D5D5),
                                                            //           width: 0.8,
                                                            //         ),
                                                            //       )),
                                                            // ),
                                                          ],
                                                        ));
                                                  }),
                                              Container(
                                                  padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                                    color: const Color(0xFFF5F5F5),
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(0.0),
                                                      topRight: Radius.circular(0.0),
                                                      bottomLeft: Radius.circular(5.0),
                                                      bottomRight: Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(child: Container()),
                                                      Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: Row(
                                                          children: [
                                                            CommonText(
                                                              name: "Total Quantity",
                                                              fontSize: Constant.fontSize14,
                                                              fontColor: Constant.colorDullGray77,
                                                              fontWeight: Constant.fontWeight500,
                                                            ),
                                                            const SizedBox(width: 24),
                                                            CommonText(
                                                              name: liftingDetail.totalQuantity!.toStringAsFixed(2),
                                                              fontSize: Constant.fontSize18,
                                                              fontColor: Constant.colorGreencc,
                                                              fontWeight: Constant.fontWeight600,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(height: 12)
                                            ],
                                          );
                                        })
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
                bottomNavigationBar: Visibility(
                    visible: (Constants.AUTH_ROLEID != Constants.DEALER && (liftingDetail.statusId != null && liftingDetail.statusId == 1)),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: screenWidth / 2.2,
                              child: CommonButton(
                                buttonName: "Reject",
                                buttonNameSize: Constant.fontSize13,
                                buttonNameColor: Constant.pricbuttonTxtColor,
                                buttonColor: Constant.pricDisBocolor,
                                buttonHeight: 40,
                                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                buttonRadiusBL: Constant.pricbutRadiusBL,
                                buttonBorder: Colors.transparent,
                                buttonNameWeight: Constant.fontWeight500,
                                buttonFunction: () {
                                  approvalStatusId = 3;
                                  showCustomAlertDialog(context, {}, 'Reject Sales Order', dialogActionButton(), hideCancelBtn: true);
                                },
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 2.2,
                              child: CommonButton(
                                buttonName: "Approve",
                                buttonNameSize: Constant.fontSize13,
                                buttonNameColor: Constant.pricbuttonTxtColor,
                                buttonColor: Constant.saudaLETBoxColor1,
                                buttonHeight: 40,
                                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                buttonRadiusBL: Constant.pricbutRadiusBL,
                                buttonBorder: Colors.transparent,
                                buttonNameWeight: Constant.fontWeight500,
                                buttonFunction: () {
                                  approvalStatusId = 2;
                                  showCustomAlertDialog(context, {}, 'Approve Sales Order', dialogActionButton(), hideCancelBtn: true);
                                },
                              ),
                            ),
                          ],
                        ))))));
  }

  getEnquiryDetail() {
    for (LiftingRequestDetailList l in liftingDetail.liftingRequestDetailList!) {
      if (enquiryNos.indexOf(liftingDetail.enquiryNumber) == -1) {
        enquiryNos.add(liftingDetail.enquiryNumber);
        List<LiftingRequestDetailList> enquiries = [];
        enquiryList[liftingDetail.enquiryNumber] = enquiries;
        enquiryList[liftingDetail.enquiryNumber]!.add(l);
      } else {
        enquiryList[liftingDetail.enquiryNumber]!.add(l);
      }
    }
  }

  void showCustomAlertDialog(BuildContext context, messageValue, title, footerbutton, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
    // set up the button

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.all(0),
                title: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: Constant.fontSize15,
                      fontWeight: Constant.fontWeight500,
                    )),
                trailing: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Constant.colorWhite,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            content: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 100.0,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Table(children: [
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(title!,
                                style: TextStyle(
                                  fontSize: Constant.fontSize14,
                                )),
                          ),
                          SizedBox(height: 20),
                          BorderBottom(bordeSize: 1)
                        ],
                      ),
                    ]),
                  ])),
            ),
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

  Widget dialogActionButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 2 - 67,
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
            width: screenWidth / 2 - 67,
            child: CommonButton(
              buttonName: "Save",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                SaveSalesOrderApprovalRequest request = SaveSalesOrderApprovalRequest();
                request.loginUserId = Constants.AUTH_USERID;
                request.statusId = approvalStatusId;
                request.id = widget.id;
                BlocProvider.of<SalesOrderDetailPageBloc>(context).add(SaveSalesOrderApproval(request: request));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  contBody() {}

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
    AlertDialog alert = AlertDialog(
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
      // title: Container(
      //   decoration: BoxDecoration(
      //     color: Constant.colorOrange,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(25.0),
      //       topRight: Radius.circular(5.0),
      //       bottomLeft: Radius.circular(0.0),
      //       bottomRight: Radius.circular(0.0),
      //     ),
      //   ),
      //   padding: const EdgeInsets.only(top: 12, bottom: 12),
      //   child: Text(title,
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         color: titleColor,
      //       )),
      // ),
      // content: Text(successText!),
      content: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error" ? Icon(Icons.error_outlined, size: 70, color: Colors.red) : Icon(Icons.check_circle_sharp, size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title!, style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  SizedBox(height: 20),
                  BorderBottom(bordeSize: 1)
                ],
              ),
            ]),
          ])),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
                buttonName: "Ok",
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.textFormFieldColor,
                buttonColor: Colors.white,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.black,
                buttonNameWeight: Constant.fontWeight500,
                buttonFunction: () {
                  Navigator.pop(context);
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaudaSalesOrderStatusScreen()),
                  );
                })
          ],
        )
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return alert;
          });
        });
  }
}
