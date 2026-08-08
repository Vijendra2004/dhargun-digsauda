import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/sauda_extension_request.dart';
import 'package:adaniwilmar/models/sauda_extension_response.dart';
import 'package:adaniwilmar/screen/saudu_extension_details/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaExtensionDetailScreen extends StatelessWidget {
  const SaudaExtensionDetailScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaExtensionDetailScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaExtensionDetailBloc()
        ..add(LoadSaudaExtensionDetailScreen(
            userId: Constants.AUTH_USERID, fromDate: "", toDate: ""))
        ..add(LoadNewSaudaExtensionScreen(
            userId: Constants.AUTH_USERID,
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisonId: 0))
        ..add(LoadOilType(
            userId: Constants.AUTH_USERID,
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisonId: 0)),
      child: const SaudaExtensionDetails(),
    );
  }
}

class SaudaExtensionDetails extends StatefulWidget {
  // SaudaBookedSaudaWithExtensionDetails sauda;
  const SaudaExtensionDetails({Key? key}) : super(key: key);

  @override
  State<SaudaExtensionDetails> createState() => _SaudaExtensionDetailsState();
}

class _SaudaExtensionDetailsState extends State<SaudaExtensionDetails> {
  List<SaudaExtension> saudaDetails = [];
  List<OilType> oilTypes = [];
  List<DistributorList> distributorList = [];
  DistributorList? selectedDistributor;
  OilType? selectedOilType;

  int pendingCount = 0;
  int approvedCount = 0;
  int selectedCount = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  final TextEditingController _daycontroller = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _commentcontroller = TextEditingController();
  bool isChecked = false;
  ProgressBarHandler? _handler;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;

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
    return BlocListener<SaudaExtensionDetailBloc, SaudaExtensionDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            saudaDetails = state.saudaExtensions;
            pendingCount = state.saudaExtensions.length;
            setState(() {});
          }
          if (state is OnLoadOilType) {
            selectedOilType = null;
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnLoadNewSaudaSuccess) {
            selectedDistributor = null;
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnSaveSuccess) {
            showSuccessDlg(
                context, "Extension Saved Successfully", "Sauda Extension",
                successText: "Sauda Extension Saved Successfully");
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
                  title: "Sauda Extension",
                  backArrow: true,
                  listOfActions: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showCustomFilterDialog(context, "Filter", "Filter",
                              dialogActionButtonFilter());
                        },
                        icon: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.all(7),
                            child: Constant.filterIc,
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
                    Container(
                      height: screenHeight,
                      margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: selectedCount > 0
                                ? screenHeight * 0.840
                                : screenHeight * 0.800,
                            width: screenWidth,
                            child: CurveBorderBox(
                              boxLRPadding: 0,
                              boxofWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // CurveBorderBox(
                                  //     boxBgColor: const Color(0xFFFFFBF7),
                                  //     boxShadowColor: Colors.transparent,
                                  //     boxTOPPadding: 0,
                                  //     boxofWidget: SizedBox(
                                  //       width:
                                  //           MediaQuery.of(context).size.width,
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Row(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.center,
                                  //             children: [
                                  //               Expanded(
                                  //                 child: Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     CommonText(
                                  //                       name: "Sauda's Booked",
                                  //                       fontSize:
                                  //                           Constant.fontSize13,
                                  //                       fontColor: Constant
                                  //                           .colorDullGray77,
                                  //                     ),
                                  //                     CommonText(
                                  //                       name: pendingCount
                                  //                               .toString() +
                                  //                           " SKU",
                                  //                       fontSize:
                                  //                           Constant.fontSize13,
                                  //                       fontColor:
                                  //                           Constant.colorBlack,
                                  //                       fontWeight: Constant
                                  //                           .fontWeight600,
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     )),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Row(
                                              children: [
                                                const Text("Select All"),
                                                Checkbox(
                                                  onChanged: (bool? value) {
                                                    isChecked = value!;
                                                    if (value) {
                                                      selectAllSaudas();
                                                    } else {
                                                      unSelectAllSaudas();
                                                    }
                                                    setState(() {});
                                                  },
                                                  value: isChecked,
                                                  activeColor:
                                                      Colors.green[600],
                                                )
                                              ],
                                            )),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: CommonText(
                                                  name:
                                                      selectedCount.toString() +
                                                          " Selected ",
                                                  fontColor:
                                                      Constant.colorDullGray77,
                                                  fontSize: Constant.fontSize12,
                                                  fontWeight:
                                                      Constant.fontWeight500),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: saudaDetails.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () {
                                                  saudaDetails[index]
                                                          .isExpanded =
                                                      !saudaDetails[index]
                                                          .isExpanded!;
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12,
                                                                  right: 12,
                                                                  top: 9,
                                                                  bottom: 9),
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
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "#" +
                                                                          saudaDetails[index]
                                                                              .saudaNumber!,
                                                                      style: TextStyle(
                                                                          fontSize: Constant
                                                                              .fontSize14,
                                                                          color: Constant
                                                                              .colorBlack,
                                                                          fontWeight:
                                                                              Constant.fontWeight500),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Checkbox(
                                                                        onChanged:
                                                                            (bool?
                                                                                value) {
                                                                          saudaDetails[index].isSelected =
                                                                              value!;
                                                                          getSelectedCount();
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        value: saudaDetails[index]
                                                                            .isSelected,
                                                                        activeColor:
                                                                            Colors.green[600],
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                      // Container(
                                                      //     width: double.infinity,
                                                      //     padding:
                                                      //         const EdgeInsets.only(
                                                      //             left: 12,
                                                      //             right: 12,
                                                      //             top: 9,
                                                      //             bottom: 9),
                                                      //     child: Column(
                                                      //       crossAxisAlignment:
                                                      //           CrossAxisAlignment
                                                      //               .start,
                                                      //       children: [
                                                      //         Row(
                                                      //           children: [
                                                      //             Expanded(
                                                      //               child: Text(
                                                      //                 saudaDetails[
                                                      //                         index]
                                                      //                     .bookedSku!,
                                                      //                 style: TextStyle(
                                                      //                     fontSize: Constant
                                                      //                         .fontSize14,
                                                      //                     color: Constant
                                                      //                         .colorBlack,
                                                      //                     fontWeight:
                                                      //                         Constant
                                                      //                             .fontWeight500),
                                                      //               ),
                                                      //             ),
                                                      //           ],
                                                      //         )
                                                      //       ],
                                                      //     )),
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              saudaDetails[
                                                                      index]
                                                                  .skuList!
                                                                  .length,
                                                          itemBuilder:
                                                              (context, ind) {
                                                            return Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            12,
                                                                        right:
                                                                            12,
                                                                        top: 9,
                                                                        bottom:
                                                                            9),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            saudaDetails[index].skuList![ind].skuName!,
                                                                            style: TextStyle(
                                                                                fontSize: Constant.fontSize14,
                                                                                color: Constant.colorBlack,
                                                                                fontWeight: Constant.fontWeight500),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ));
                                                          }),
                                                      const BorderBottom(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                left: 12,
                                                                right: 12,
                                                                bottom: 12),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Sauda From Date:",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize12,
                                                                      color: Constant
                                                                          .colorGray45),
                                                                ),
                                                                Text(
                                                                    (saudaDetails[index].saudaBookedDate !=
                                                                                null ||
                                                                            saudaDetails[index].saudaValidFromDate !=
                                                                                null)
                                                                        ? DateTimeUtils().dateToServerToDateFormat(
                                                                            saudaDetails[index].saudaValidFromDate == null
                                                                                ? saudaDetails[index]
                                                                                    .saudaBookedDate!
                                                                                : saudaDetails[index]
                                                                                    .saudaValidFromDate!,
                                                                            DateTimeUtils
                                                                                .YYYY_MM_DD_Format,
                                                                            DateTimeUtils
                                                                                .DD_MM_YYYY_Format)
                                                                        : "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            Constant
                                                                                .fontSize12,
                                                                        color: Constant
                                                                            .colorBlack,
                                                                        fontWeight:
                                                                            Constant.fontWeight500))
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    width: 10,
                                                                    height: 10,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Constant
                                                                          .saExColorRed,
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                    )),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      bottom: BorderSide(
                                                                          width:
                                                                              0.8,
                                                                          color:
                                                                              Color(0x13000000)),
                                                                    ),
                                                                  )),
                                                                ),
                                                                Container(
                                                                    width: 10,
                                                                    height: 10,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Constant
                                                                          .colorOrange,
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                    )),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 3),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          DateTimeUtils().dateToServerToDateFormat(
                                                                              saudaDetails[index].saudaValidToDate == null ? saudaDetails[index].saudaBookedDate! : saudaDetails[index].saudaValidToDate!,
                                                                              DateTimeUtils.YYYY_MM_DD_Format,
                                                                              DateTimeUtils.DD_MMM_Format),
                                                                          style: TextStyle(
                                                                              fontSize: Constant.fontSize12,
                                                                              color: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500),
                                                                        ),
                                                                        Text(
                                                                          DateTimeUtils().dateToServerToDateFormat(
                                                                              saudaDetails[index].saudaValidToDate == null ? saudaDetails[index].saudaBookedDate! : saudaDetails[index].saudaValidToDate!,
                                                                              DateTimeUtils.YYYY_MM_DD_Format,
                                                                              DateTimeUtils.YYYY_Format),
                                                                          style: TextStyle(
                                                                              fontSize: Constant.fontSize11,
                                                                              color: Constant.colorGray75),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 70,
                                                                    child: Align(
                                                                        alignment: Alignment.center,
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              showCustomAlertDialog(context, contBody(), 'Extension Period', {}, hideCancelBtn: true, sauda: saudaDetails[index]);
                                                                            },
                                                                            child: CommonLabel(
                                                                              bgColor: Constant.colorOrange,
                                                                              name: saudaDetails[index].extendedDays == null ? saudaDetails[index].saudaExtendedDays.toString() : saudaDetails[index].extendedDays.toString(),
                                                                              fontSize: Constant.fontSize14,
                                                                              fontColor: Constant.colorWhite,
                                                                              icondata: Icons.edit,
                                                                              iconColor: Colors.white,
                                                                              iconSize: 24,
                                                                            ))),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          DateTimeUtils().dateToServerToDateFormat(
                                                                              saudaDetails[index].saudaExtendedToDate == null
                                                                                  ? saudaDetails[index].saudaValidToDate!
                                                                                  : saudaDetails[index].extendedToDate == null
                                                                                      ? saudaDetails[index].saudaExtendedToDate!
                                                                                      : saudaDetails[index].extendedToDate!,
                                                                              DateTimeUtils.YYYY_MM_DD_Format,
                                                                              DateTimeUtils.DD_MMM_Format),
                                                                          style: TextStyle(
                                                                              fontSize: Constant.fontSize12,
                                                                              color: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500),
                                                                        ),
                                                                        Text(
                                                                          DateTimeUtils().dateToServerToDateFormat(
                                                                              saudaDetails[index].saudaExtendedToDate == null
                                                                                  ? saudaDetails[index].saudaValidToDate!
                                                                                  : saudaDetails[index].extendedToDate == null
                                                                                      ? saudaDetails[index].saudaExtendedToDate!
                                                                                      : saudaDetails[index].extendedToDate!,
                                                                              DateTimeUtils.YYYY_MM_DD_Format,
                                                                              DateTimeUtils.YYYY_Format),
                                                                          style: TextStyle(
                                                                              fontSize: Constant.fontSize11,
                                                                              color: Constant.colorGray75),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                          visible: saudaDetails[
                                                                  index]
                                                              .isExpanded!,
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 12,
                                                                      right: 12,
                                                                      top: 9,
                                                                      bottom:
                                                                          9),
                                                              child: Column(
                                                                  children: [
                                                                    // const BorderBottom(),
                                                                    // ListView.builder(
                                                                    //   shrinkWrap: true,
                                                                    //   padding: const EdgeInsets.all(0),
                                                                    //   physics: const NeverScrollableScrollPhysics(),
                                                                    //   itemCount: saudaDetails[index].skuList!.length,
                                                                    //   itemBuilder: (context, ind) {
                                                                    //     return Container(
                                                                    //         width: double.infinity,
                                                                    //         padding:
                                                                    //         const EdgeInsets.only(
                                                                    //             left: 12,
                                                                    //             right: 12,
                                                                    //             top: 9,
                                                                    //             bottom: 9),
                                                                    //         child: Column(
                                                                    //           crossAxisAlignment:
                                                                    //           CrossAxisAlignment
                                                                    //               .start,
                                                                    //           children: [
                                                                    //             Row(
                                                                    //               children: [
                                                                    //                 Expanded(
                                                                    //                   child: Text(
                                                                    //                     saudaDetails[
                                                                    //                     index]
                                                                    //                         .skuList![ind].skuName!,
                                                                    //                     style: TextStyle(
                                                                    //                         fontSize: Constant
                                                                    //                             .fontSize14,
                                                                    //                         color: Constant
                                                                    //                             .colorBlack,
                                                                    //                         fontWeight:
                                                                    //                         Constant
                                                                    //                             .fontWeight500),
                                                                    //                   ),
                                                                    //                 ),
                                                                    //               ],
                                                                    //             )
                                                                    //           ],
                                                                    //         ));
                                                                    //   }),
                                                                    const BorderBottom(),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CommonText(
                                                                              name: "Sauda Qty",
                                                                              fontSize: Constant.fontSize14,
                                                                              fontColor: Constant.colorGray45,
                                                                            ),
                                                                            const SizedBox(height: 5.0),
                                                                            CommonText(
                                                                              name: saudaDetails[index].saudaQuantityCase!.toStringAsFixed(2),
                                                                              fontSize: Constant.fontSize12,
                                                                              fontColor: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CommonText(
                                                                              name: "Pending Qty",
                                                                              fontSize: Constant.fontSize14,
                                                                              fontColor: Constant.colorGray45,
                                                                            ),
                                                                            const SizedBox(height: 5.0),
                                                                            CommonText(
                                                                              name: saudaDetails[index].pendingQuantityCase!.toStringAsFixed(2),
                                                                              fontSize: Constant.fontSize12,
                                                                              fontColor: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CommonText(
                                                                              name: "Base Rate",
                                                                              fontSize: Constant.fontSize14,
                                                                              fontColor: Constant.colorGray45,
                                                                            ),
                                                                            const SizedBox(height: 5.0),
                                                                            CommonText(
                                                                              name: saudaDetails[index].basicRate!.toStringAsFixed(2),
                                                                              fontSize: Constant.fontSize12,
                                                                              fontColor: Constant.colorBlack,
                                                                              fontWeight: Constant.fontWeight500,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    const BorderBottom(),
                                                                  ])))
                                                    ],
                                                  ),
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    progressBar
                  ],
                ),
                bottomNavigationBar: selectedCount > 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 0, bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth / 2.8,
                              child: CommonButton(
                                buttonName: "Save",
                                buttonNameSize: Constant.fontSize13,
                                buttonNameColor: Constant.pricbuttonTxtColor,
                                buttonColor: Constant.colorGreencc,
                                buttonHeight: 40,
                                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                buttonRadiusBL: Constant.pricbutRadiusBL,
                                buttonBorder: Colors.transparent,
                                buttonNameWeight: Constant.fontWeight500,
                                buttonFunction: () {
                                  showRemarksDialog(context, {},
                                      'Save Extension', dialogActionButton(),
                                      hideCancelBtn: true);
                                },
                              ),
                            ),
                          ],
                        ))
                    : const Text(""))));
  }

  void showCustomAlertDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white,
      SaudaExtension? sauda}) {
    // set up the button
    if (sauda!.extendedDays != null) {
      _daycontroller.text = sauda.extendedDays.toString();
    } else {
      _daycontroller.text = "";
    }
    if (sauda.extendedToDate != null) {
      _datecontroller.text = DateTimeUtils().dateToServerToDateFormat(
          sauda.extendedToDate!,
          DateTimeUtils.YYYY_MM_DD_Format,
          DateTimeUtils.DD_MM_YYYY_Format);
    } else {
      _datecontroller.text = DateTimeUtils().dateToServerToDateFormat(
          sauda.saudaExtendedToDate == null
              ? sauda.saudaValidFromDate!
              : sauda.saudaExtendedToDate!,
          DateTimeUtils.YYYY_MM_DD_Format,
          DateTimeUtils.DD_MM_YYYY_Format);
    }
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // double finalRate = 0;
        // double rate = 0;
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
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: Constant.fontSize15,
                    fontWeight: Constant.fontWeight500,
                  )),
            ),
            content: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 180.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextFormField(
                        labeltxt: "Extension Day (Max:" +
                            sauda.saudaExtendedDays! +
                            " )",
                        labeltxtColor: Constant.textFormFieldColor,
                        labeltxtSize: Constant.textFormFieldSize,
                        labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                        focuBorColor: Constant.textFormFocuBorCol,
                        focuBorWid: Constant.textFormFocuBorWid,
                        enaBorColor: Constant.textFormEnaBorCol,
                        enaBorWid: Constant.textFormEnaBorWid,
                        borderRadiusTL: Constant.textFormborderRadiusTL,
                        borderRadiusBR: Constant.textFormborderRadiusBR,
                        contentPadHor: Constant.textFormcontentPadHor,
                        contentPadHVer: Constant.textFormcontentPadHVer,
                        controllerTxt: _daycontroller,
                        keyborType: TextInputType.number,
                        onChanged: (String? value) {
                          int maxDays = 0;
                          if (sauda.saudaExtendedDays != null) {
                            maxDays = int.parse(sauda.saudaExtendedDays!
                                .replaceAll("days", ""));
                          }
                          if (value != null &&
                              value != "" &&
                              int.parse(value) > maxDays) {
                            if (sauda.saudaExtendedDays != null) {
                              _daycontroller.text = sauda.saudaExtendedDays!
                                  .replaceAll("days", "");
                            } else {
                              _daycontroller.text = "0";
                            }
                          }
                          int days = 0;
                          if (_daycontroller.text.toString() != "") {
                            days = int.parse(_daycontroller.text.toString());
                          }
                          _datecontroller.text = DateTimeUtils()
                              .dateToStringFormat(
                                  DateTimeUtils()
                                      .stringToDate(
                                          sauda.saudaExtendedToDate == null
                                              ? sauda.saudaValidToDate!
                                              : sauda.saudaExtendedToDate!,
                                          DateTimeUtils.YYYY_MM_DD_Format)
                                      .add(Duration(
                                          days: (maxDays - days) * -1)),
                                  DateTimeUtils.DD_MM_YYYY_Format);
                          DateTime curDate = DateTimeUtils().stringToDate(
                              sauda.saudaValidToDate!,
                              DateTimeUtils.YYYY_MM_DD_Format);
                          // .add(Duration(
                          //     days: 1));
                          for (int d = 0; d < days; d++) {
                            if (curDate.weekday == 7) {
                              curDate = curDate.add(const Duration(days: 1));
                            }
                            curDate = curDate.add(const Duration(days: 1));
                          }
                          _datecontroller.text = DateTimeUtils()
                              .dateToStringFormat(
                                  curDate, DateTimeUtils.DD_MM_YYYY_Format);
                        }),
                    const SizedBox(height: 16.0),
                    CommonTextFormField(
                        labeltxt: "Extend Upto Date",
                        labeltxtColor: Constant.textFormFieldColor,
                        labeltxtSize: Constant.textFormFieldSize,
                        labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                        focuBorColor: Constant.textFormFocuBorCol,
                        focuBorWid: Constant.textFormFocuBorWid,
                        enaBorColor: Constant.textFormEnaBorCol,
                        enaBorWid: Constant.textFormEnaBorWid,
                        borderRadiusTL: Constant.textFormborderRadiusTL,
                        borderRadiusBR: Constant.textFormborderRadiusBR,
                        contentPadHor: Constant.textFormcontentPadHor,
                        contentPadHVer: Constant.textFormcontentPadHVer,
                        controllerTxt: _datecontroller,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        onChanged: (String? value) {}),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  Center(
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
                            buttonColor: Constant.colorBtn,
                            buttonHeight: 40,
                            buttonRadiusTL: Constant.pricbuttonRadiusTL,
                            buttonRadiusBL: Constant.pricbutRadiusBL,
                            buttonBorder: Colors.transparent,
                            buttonFunction: () {
                              if (_daycontroller.text.toString() != "") {
                                sauda.extendedDays =
                                    int.parse(_daycontroller.text.toString());
                                sauda.extendedToDate = DateTimeUtils()
                                    .dateToServerToDateFormat(
                                        _datecontroller.text.toString(),
                                        DateTimeUtils.DD_MM_YYYY_Format,
                                        DateTimeUtils.YYYY_MM_DD_Format);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        });
      },
    );
  }

  contBody() {}
  getSelectedCount() {
    selectedCount = 0;
    for (SaudaExtension s in saudaDetails) {
      if (s.isSelected!) {
        selectedCount += 1;
      }
    }
  }

  selectAllSaudas() {
    selectedCount = saudaDetails.length;
    for (SaudaExtension s in saudaDetails) {
      s.isSelected = true;
    }
  }

  unSelectAllSaudas() {
    selectedCount = 0;
    for (SaudaExtension s in saudaDetails) {
      s.isSelected = false;
    }
  }

  void showRemarksDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
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
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: Constant.fontSize15,
                    fontWeight: Constant.fontWeight500,
                  )),
            ),
            content: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 220.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextFormField(
                      labeltxt: "Remarks",
                      labeltxtColor: Constant.textFormFieldColor,
                      labeltxtSize: Constant.textFormFieldSize,
                      labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                      focuBorColor: Constant.textFormFocuBorCol,
                      focuBorWid: Constant.textFormFocuBorWid,
                      enaBorColor: Constant.textFormEnaBorCol,
                      enaBorWid: Constant.textFormEnaBorWid,
                      borderRadiusTL: Constant.textFormborderRadiusTL,
                      borderRadiusBR: Constant.textFormborderRadiusBR,
                      contentPadHor: Constant.textFormcontentPadHor,
                      contentPadHVer: Constant.textFormcontentPadHVer,
                      controllerTxt: _commentcontroller,
                      maxLine: 9,
                    )
                  ],
                ),
              ),
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
                SaudaExtensionRequest request = SaudaExtensionRequest();
                request.saudaExtensionList = [];
                request.loginUserId = Constants.AUTH_USERID;
                request.remarks = _commentcontroller.text.toString();
                for (SaudaExtension s in saudaDetails) {
                  if (s.isSelected!) {
                    SaudaExtensionList extension = SaudaExtensionList();
                    extension.saudaNumber = s.saudaNumber;
                    extension.requestDate = s.extendedToDate == null
                        ? s.saudaExtendedToDate!
                        : s.extendedToDate.toString();
                    // extension.requestDate = DateTimeUtils()
                    //     .dateToServerToDateFormat(
                    //         s.extendedToDate == null
                    //             ? s.saudaExtendedToDate!
                    //             : s.extendedToDate!,
                    //         DateTimeUtils.DD_MM_YYYY_Format,
                    //         DateTimeUtils.YYYY_MM_DD_Format);
                    extension.pendingContractId = s.pendingContractId;
                    extension.saudaOrderId = s.saudaOrderId;
                    extension.extentionDateCount = s.extendedDays ??
                        int.parse((s.saudaExtendedDays == null
                            ? "0"
                            : s.saudaExtendedDays!.replaceAll("days", "")));
                    request.saudaExtensionList!.add(extension);
                  }
                }
                BlocProvider.of<SaudaExtensionDetailBloc>(context)
                    .add(SaveSaudaExtension(request: request));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    // set up the button
    // set up the AlertDialog
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
      title: Container(
        decoration: BoxDecoration(
          color: Constant.colorOrange,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
            )),
      ),
      content: Text(successText!),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
                buttonName: "Ok",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  Navigator.pop(context);
                  BlocProvider.of<SaudaExtensionDetailBloc>(context).add(
                      LoadSaudaExtensionDetailScreen(
                          userId: Constants.AUTH_USERID,
                          fromDate: "",
                          toDate: ""));
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

  Widget getDialogContent() {
    var ctx = context;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
          width: double.infinity,
          child: CommonDropdownButtonFormField<DistributorList>(
            value: selectedDistributor,
            label: "Distributor Name",
            onChanged: (DistributorList? newValue) {
              setState(() {
                selectedDistributor = newValue!;
              });
            },
            items:
                distributorList.map<DropdownMenuItem<DistributorList>>((value) {
              return DropdownMenuItem<DistributorList>(
                value: value,
                child:
                    Text(value.employeeName!, overflow: TextOverflow.visible),
              );
            }).toList(),
          )),
      const SizedBox(height: 16.0),
      SizedBox(
          width: double.infinity,
          //height: 70,
          child: CommonDropdownButtonFormField<OilType>(
            value: selectedOilType,
            label: "Oil Type",
            onChanged: (OilType? newValue) {
              setState(() {
                selectedOilType = newValue!;
              });
            },
            items: oilTypes.map<DropdownMenuItem<OilType>>((value) {
              return DropdownMenuItem<OilType>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          )),
      const SizedBox(height: 16.0),
      BorderBottom(bordeSize: 1)
    ]);
  }

  void showCustomFilterDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.only(left: 20, right: 20),
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
                height: 170,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: getDialogContent()),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [footerbutton],
              )
            ],
          );
        });
      },
    );
  }

  Widget dialogActionButtonFilter() {
    var ct = context;
    return SizedBox(
      width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 3,
            child: CommonButton(
              buttonName: "Cancel",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.saudaLETTxtColor,
              buttonColor: Constant.saudaLETbuttonColor,
              buttonHeight: 50,
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
            width: screenWidth / 3,
            child: CommonButton(
              buttonName: "Apply",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                BlocProvider.of<SaudaExtensionDetailBloc>(ct).add(
                    LoadSaudaExtensionDetailScreen(
                        userId: Constants.AUTH_USERID,
                        fromDate: "",
                        toDate: ""));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
