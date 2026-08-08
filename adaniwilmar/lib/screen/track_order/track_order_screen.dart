import 'package:adaniwilmar/widget/common_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/bdo_list_response.dart';
import '../../models/daily_rate_response.dart';
import '../../models/dealer_response.dart';
import '../../models/do_number_response.dart';
import '../../models/pending_contract_filter_response.dart';
import '../../models/statistics_response.dart';
import '../../models/support_category_response.dart';
import '../../models/track_order_model.dart';
import '../../models/zone_response.dart';
import '../../models/zone_state_cities_response.dart';
import '../../utils/constant.dart';
import '../../utils/datetime_utils.dart';
import '../../utils/strings.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/autocomplete/autocompleter.dart';
import '../../widget/common-textfield.dart';
import '../../widget/common_button.dart';
import '../../widget/common_text.dart';
import '../../widget/curve_outer_box.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../state_trader_filter/state_trader_filter.dart';
import '../track_order_map_screen/track_order_map.dart';
import 'bloc/track_order_bloc.dart';
import 'bloc/track_order_event.dart';
import 'bloc/track_order_state.dart';

class TrackOrderScreenStateless extends StatelessWidget {
  // const ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return TrackOrderBloc();
          // ..add(LoadZonalHeadTrack(
          //     userId: Constants.AUTH_USERID, showAll: true));
        },
        child: TrackOrderScreen());
  }
}

class TrackOrderScreen extends StatefulWidget {
  // const TrackOrderScreen({Key? key} ) : super(key: key,);
  // static const String routeName = '/';

  // static Route route() {
  //   return MaterialPageRoute(
  //       settings: const RouteSettings(name: routeName),
  //       builder: (_) => const TrackOrderScreen());
  // }

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  var progressBar;

  void initState() {
    // TODO: implement initState
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      BlocProvider.of<TrackOrderBloc>(context).add(
          LoadZonalHeadTrack(userId: Constants.AUTH_USERID, showAll: true));
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      BlocProvider.of<TrackOrderBloc>(context).add(
          LoadStateHeadTrack(userId: Constants.AUTH_USERID, showAll: true));
    } else if (Constants.AUTH_ROLEID == Constants.SALE) {
      BlocProvider.of<TrackOrderBloc>(context)
          .add(LoadDistributorHeadTrack(userId: Constants.AUTH_USERID));
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      BlocProvider.of<TrackOrderBloc>(context).add(LoadStateDOTrack(
          distributorEmpCode: [Constants.AUTH_DEALER_CODE.toString()]));
    }
    Future.delayed(Duration(seconds: 1), () {
      /* var progressBar = ModalRoundedProgressBar(
        handleCallback: (handler) {
          _handler = handler;
          return () {};
        },
      );*/
      // showCustomFilterDialog(context, "Reports Filter", "Reports Filter",
      //     dialogActionButtonFilter(), progressBar);
    });
    super.initState();
  }

  ProgressBarHandler? _handler;
  TrackOrderModel trackOrderModel = TrackOrderModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StateTraderFilterWidget? tradeFilter;
  String? labelTxt = "";
  List<BdoList> bdoList = [];
  List<BdoList> stateHeadList = [];
  List<BdoList> zonalHeadList = [];
  List<DistributorList> distributorList = [];
  List<DoNumberResponse> doNumberList = [];
  List<DoMaterial> doMaterialList = [];
  List<String> distributorEmpCode = [];
  List<SalesDataResponse> saleDataList = [];
  BdoList? selectedZonalHead;
  BdoList? selectedStateHead;
  List<BdoList> materialList = [];
  List<DoNumberResponse> selectedDoNumbers = [];
  List<String> doNumbersIds = [];
  List<int> selectedMaterialIds = [];
  late TextEditingController _doNumberController = TextEditingController();
  IssueTypes? selectedSeverity;
  List<IssueTypes> severityList = [];
  List<OilTypesPendingContractReport> oilTypes = [];
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int selected = 0 - 1;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  final GlobalKey _dialogKey = GlobalKey();
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  StatisticsResponse? statistics = StatisticsResponse();
  DistributorList? selectedDistributor;
  List<ActiveZone> zoneList = [];
  List<ActiveStateResponse> stateList = [];
  List<ActiveZone> selectedZone = [];
  TextEditingController? _distributecontroller;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  TextEditingController? _distributorcontroller;
  int statusCount = 0;

  static String _displayStringForOption(DistributorList option) =>
      option.employeeName!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<TrackOrderBloc, TrackOrderState>(listener:
        (context, state) {
      if (state is ShowProgressBar) {
        _handler!.show!();
      } else if (state is HideProgressBar) {
        _handler!.dismiss!();
      } else if (state is OnTrackStateHead) {
        stateHeadList = [];
        stateHeadList = state.stateHeadList;
        if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
          Navigator.pop(context);
          showCustomFilterDialog(context, "Reports Filter", "Reports Filter",
              dialogActionButtonFilter(), progressBar);
        }
        if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
          if (stateHeadList.isNotEmpty) {
            showCustomFilterDialog(context, "Reports Filter", "Reports Filter",
                dialogActionButtonFilter(), progressBar);
          }
        }
        if (stateHeadList.isNotEmpty) {
          if (stateHeadList.length > 1) {
            selectedStateHead = stateHeadList[0];
          }
        } else {
          selectedStateHead = stateHeadList[0];
        }
        setState(() {});

        // showCustomFilterDialog(context, "Reports Filter", "Reports Filter",
        //     dialogActionButtonFilter(), progressBar);
      } else if (state is OnTrackZonalHead) {
        zonalHeadList = [];
        zonalHeadList = state.zonalHeadList;
        if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
          if (zonalHeadList.isNotEmpty) {
            showCustomFilterDialog(context, "Reports Filter", "Reports Filter",
                dialogActionButtonFilter(), progressBar);
          }
        }
        setState(() {});
      } else if (state is OnTrackDistributorHead) {
        distributorList = [];
        distributorList = state.distributorList;
        if (Constants.AUTH_ROLEID == Constants.SALE) {
          if (distributorList.isNotEmpty) {
            showCustomFilterDialog(context, "Reportzs Filter", "Reports Filter",
                dialogActionButtonFilter(), progressBar);
          }
        }
        setState(() {});
      } else if (state is OnTrackDoNumber) {
        doNumberList = [];
        doNumberList = state.doNumberList;
        if (Constants.AUTH_ROLEID == Constants.DEALER) {
          if (doNumberList.isNotEmpty) {
            // showCustomFilterDialog(context, "Reports Filter", "Reports Filter",
            //     dialogActionButtonFilter(), progressBar);
            _showMultiSelectDoNumber();
          }
        }
        setState(() {});
      } else if (state is FetchExternalAPITrackOrdersSuccessState) {
        setState(() {
          trackOrderModel = state.trackOrderModel;
          if (Constants.AUTH_ROLEID != Constants.DEALER) {
            Navigator.pop(context);
          }
          if (trackOrderModel != null) {
            for (int i = 0; i < trackOrderModel.doDetails!.length; i++) {
              if (trackOrderModel.doDetails![i].statusCode == 404) {
                statusCount = statusCount + 1;
              }
            }
          }
        });
      }
      else if (state is OnSaleData) {
        setState(() {
          Navigator.pop(context);
          saleDataList = state.salesDataResponse;
        });
      }
      else if (state is OnTrackMaterial) {
        doMaterialList = [];
        doMaterialList = state.materialList;
        doMaterialList.forEach((element) {GMLogger.v('-----${element.skuName}');});
        setState(() {});
      }
      else if (state is OnFailure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }
      else if (state is OnFailureSaleDataListTrackOrders) {
        trackOrderModel = TrackOrderModel();
        if (Constants.AUTH_ROLEID != Constants.DEALER) {
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error)));
      }

      else if (state is OnSuccess) {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(state.error)));
      }
    }, child:
        BlocBuilder<TrackOrderBloc, TrackOrderState>(builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          // key: _scaffoldKey,
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "Track Your Truck",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (Constants.AUTH_ROLEID == Constants.DEALER) {
                      _showMultiSelectDoNumber();
                    } else {
                      showCustomFilterDialog(
                          context,
                          "Reports Filter",
                          "Reports Filter",
                          dialogActionButtonFilter(),
                          progressBar);
                    }
                  },
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.all(7),
                      child: Constant.filterIc,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 60, right: 10, left: 10),
                height: screenHeight * 0.980,
                width: screenWidth,
                child: CurveBorderBox(
                  boxLRPadding: 8,
                  boxTOPPadding: 8,
                  boxBOTPadding: 0,
                  boxofWidget: SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child:
                        (((trackOrderModel.doDetails ?? []).isNotEmpty) &&
                                ((trackOrderModel.doDetails ?? []).length !=
                                    statusCount))
                            ? ListView.builder(
                                // key: Key('builder'),
                                //attention
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount:
                                    (trackOrderModel.doDetails ?? []).length,
                                itemBuilder: (context, i) {
                                  return (trackOrderModel
                                              .doDetails![i].statusCode !=
                                          404 && (trackOrderModel.doDetails![i].salesDataList != null))
                                      ? GestureDetector(
                                          onTap: () {
                                            if ((trackOrderModel.doDetails![i]
                                                .trackingLink??"").isNotEmpty && trackOrderModel.doDetails![i]
                                                .trackingLink != ' ') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TrackOrderMapScreen(
                                                            trackingLink:
                                                                trackOrderModel
                                                                        .doDetails![
                                                                            i]
                                                                        .trackingLink ??
                                                                    "")),
                                              );
                                            }else{
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Track Link Not Found')));
                                            }
                                          },
                                          child: CurveOuterBox(
                                              boxLRPadding: 0,
                                              boxTBPadding: 4,
                                              boxofWidget: Theme(
                                                data: theme,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                          12,
                                                          right:
                                                          25,
                                                          bottom:
                                                          15,
                                                          top: 4),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Column(
                                                            // crossAxisAlignment:
                                                            // CrossAxisAlignment.start,
                                                            children: [

                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("Delivery Number", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Row(
                                                                // mainAxisAlignment:
                                                                //     MainAxisAlignment
                                                                //         .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      trackOrderModel.doDetails![i].doNumber ??
                                                                          "",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          color: Colors.blue,
                                                                          fontWeight: Constant.fontWeight600)),
                                                                  const SizedBox(
                                                                      width:
                                                                      3),
                                                                  const Padding(
                                                                    padding:
                                                                    EdgeInsets.only(bottom: 2),
                                                                    child:
                                                                    Icon(
                                                                      Icons
                                                                          .edit_location_alt_outlined,
                                                                      size:
                                                                      16,
                                                                      color:
                                                                      Colors.blue,
                                                                    ),
                                                                  ),


                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),

                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("Invoice Number", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Text(trackOrderModel.doDetails![i].salesDataList!.billingNumber ?? "",
                                                                  style: TextStyle(fontSize: 16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("Dispatched Date", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Text(DateTimeUtils().convertDateFormat(trackOrderModel.doDetails![i].statusBody!.lastKnownDateTime ?? ""),
                                                                  style: TextStyle(fontSize: 16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("Ship To Party", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Text(trackOrderModel.doDetails![i].salesDataList!.shipToParty ?? "",
                                                                  style: TextStyle(fontSize: 16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                            ],
                                                          ),
                                                          Column(
                                                            // crossAxisAlignment:
                                                            // CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.all(4),
                                                                // margin: EdgeInsets.only(right: 10),
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      100.0),
                                                                  // color: Constant
                                                                  color: getStatusColor(trackOrderModel
                                                                      .doDetails![
                                                                  i]
                                                                      .statusBody!
                                                                      .currentStatus!),
                                                                ),
                                                                // height: 30,
                                                                // width: 100,
                                                                child:
                                                                Center(
                                                                  child:
                                                                  Text(
                                                                    trackOrderModel.doDetails![i].statusBody!.currentStatus ??
                                                                        "",
                                                                    // "Pending",
                                                                    style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      Constant.fontSize14,
                                                                      color:
                                                                      Constant.colorWhite,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("Invoice Date", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Text(DateTimeUtils().dateToServerToDateFormat(
                                                                    trackOrderModel.doDetails![i].salesDataList!.billingDate?? "",
                                                                    DateTimeUtils.ServerFormat,
                                                                    DateTimeUtils.DD_MM_YYYY_Format,
                                                                  ),
                                                                  style: TextStyle(fontSize: 16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("Expected Delivery Date", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Text(DateTimeUtils().convertDateFormat(trackOrderModel.doDetails![i].statusBody!.eta ?? ""),
                                                                  style: TextStyle(fontSize: 16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6, bottom: 10),
                                                                child: Text("", style: TextStyle(fontSize: 13, color: Constant.colorLightGray, fontWeight: Constant.fontWeight400)),
                                                              ),
                                                              Text("",
                                                                  style: TextStyle(fontSize: 16, color: Constant.colorBlack, fontWeight: Constant.fontWeight600)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      color: const Color(
                                                          0xFFECECEC),
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left:
                                                          15,
                                                          top: 12,
                                                          bottom:
                                                          12),
                                                      child: Row(
                                                        // crossAxisAlignment:
                                                        // CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width:(MediaQuery.of(context).size.width/2),

                                                            // flex:
                                                            // 2,
                                                            child:
                                                            CommonText(
                                                              name:
                                                              "Material",
                                                              fontSize:
                                                              Constant.fontSize12,
                                                              fontColor:
                                                              Constant.colorBlack,
                                                              fontWeight:
                                                              Constant.fontWeight700,
                                                            ),
                                                          ),
                                                          Container(
                                                            width:(MediaQuery.of(context).size.width/3),
                                                            // flex:
                                                            // 2,
                                                            child:
                                                            CommonText(
                                                              name:
                                                              "Quantity (MT)",
                                                              fontSize:
                                                              Constant.fontSize12,
                                                              fontColor:
                                                              Constant.colorBlack,
                                                              fontWeight:
                                                              Constant.fontWeight700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    (trackOrderModel.doDetails![i].salesDataList != null)?ListView.builder(
                                                        // key: const Key('builder1'),
                                                        //attention
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        itemCount: trackOrderModel.doDetails![i].salesDataList!.materials!.length,
                                                        itemBuilder:
                                                            (context, ind) {
                                                          return ListTile(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .zero,
                                                            title: Column(
                                                              children: [
                                                                /*ListView.builder(
                                                                    shrinkWrap: true,
                                                                    padding: const EdgeInsets.all(0),
                                                                    physics: const ClampingScrollPhysics(),
                                                                    itemCount: 1,
                                                                    itemBuilder: (context, ind) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // Navigator.push(
                                                                          //   context,
                                                                          // MaterialPageRoute(
                                                                          //     builder: (context) => SaudaDetailViewScreen(
                                                                          //       saudaId: dealerSaudaList[index].saudaListOutputs![ind].saudaOrderId!,
                                                                          //     )),
                                                                          // );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              const Color(0xFFFAFAFA),
                                                                          padding: const EdgeInsets.only(
                                                                              left: 16,
                                                                              right: 0,
                                                                              top: 12,
                                                                              bottom: 12),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: CommonText(
                                                                                  name: "Palm",
                                                                                  fontSize: Constant.fontSize12,
                                                                                  fontColor: Constant.colorBlack,
                                                                                  fontWeight: Constant.fontWeight700,
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: CommonText(
                                                                                  name: "15 Kg Tin",
                                                                                  fontSize: Constant.fontSize12,
                                                                                  fontColor: Constant.colorBlack,
                                                                                  fontWeight: Constant.fontWeight400,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    })*/
                                                                Container(
                                                                  color:
                                                                  const Color(0xFFFAFAFA),
                                                                  padding: const EdgeInsets.only(
                                                                      left: 16,
                                                                      right: 0,
                                                                      top: 12,
                                                                      bottom: 12),
                                                                  child:
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                    children: [
                                                                      // Expanded(
                                                                  Container(
                                                                  width:(MediaQuery.of(context).size.width/2),
                                                                        child: CommonText(
                                                                          name: trackOrderModel.doDetails![i].salesDataList!.materials![ind].skuName,
                                                                          fontSize: Constant.fontSize12,
                                                                          fontColor: Constant.colorBlack,
                                                                          fontWeight: Constant.fontWeight700,
                                                                        ),
                                                                      ),
                                                                      // Expanded(
                                                              Container(
                                                              width:(MediaQuery.of(context).size.width/3.5),
                                                                        child: CommonText(
                                                                          name: trackOrderModel.doDetails![i].salesDataList!.materials![ind].quantity.toString(),
                                                                          fontSize: Constant.fontSize12,
                                                                          fontColor: Constant.colorBlack,
                                                                          fontWeight: Constant.fontWeight400,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            // CurveOuterBox(
                                                            //   boxBorderColor: const Color(0xFFE7E7E7),
                                                            //  // boxShadowColor: const Color(0xFFFFFFFF),
                                                            //   boxBorderWidth: 0,
                                                            //   boxLRPadding: 0,
                                                            //   boxTBPadding: 0,
                                                            //   boxBRRadius: 5,
                                                            //   boxofWidget:
                                                            //
                                                            // )
                                                          );
                                                        }) : Container(),
                                                  ],
                                                ),
                                              )),
                                        )
                                      : Container();
                                })
                            : const Center(
                                child: Text(
                                  "No data found",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                  ),
                ),
              ),
              progressBar
            ],
          ),
        ),
      );
    }));
  }


  void _showMultiSelectDoNumber() async {
    bool isCheck = false;
    // if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
    //   doNumberList = selectedDoNumbers;
    //   isCheck = true;
    // }

    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<DoNumberResponse>(
          searchable: true,
          items: doNumberList
              .map((dist) =>
              MultiSelectItem<DoNumberResponse>(dist, dist.billingNo ?? ''))
              .toList(),
          initialValue: selectedDoNumbers,
          singleSelection: true,
          isUncheck: isCheck,
          onConfirm: (List<DoNumberResponse> values) {
            GMLogger.v('print -- ${values.first.doValue}');
            selectedDoNumbers = values;
            doNumbersIds.clear();
            for (DoNumberResponse d in values) {
              doNumbersIds.add(d.doValue!);
              // selectedDoNumbers.add(d);
            }
            setState(() {
              _doNumberController.text =
                  doNumbersIds.length.toString() + " Item(s) selected";
            });
            GMLogger.v(doNumbersIds.toString());

            /// This logic will pass the data automatically
            statusCount = 0;
            String distributorCode =
            (Constants.AUTH_ROLEID == Constants.DEALER)
                ? Constants.AUTH_DEALER_CODE
                : selectedDistributor!.employeeCode!;

          // if(Constants.AUTH_ROLEID == Constants.DEALER)
          //   {
          //    Navigator.pop(context);
          //   }

            BlocProvider.of<TrackOrderBloc>(context).add(
              FetchExternalAPITrackOrdersEvent(
                  distributorCode: distributorCode,
                  doNumberIds: doNumbersIds[0]),
            );
          },
        );
      },
    );
  }

  void showCustomFilterDialog(BuildContext context, messageValue, title,
      footerbutton, ModalRoundedProgressBar progressBar,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    //resetDialog();
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Stack(
          children: [
            StatefulBuilder(
                // key: _dialogKey,
                builder: (context, setState) {
              return AlertDialog(
                // insetPadding: const EdgeInsets.only(left: 20, right: 20),
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
                  // padding: const EdgeInsets.all(16),
                  child: ListTile(
                    title: Text("Filter",
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
                    // height: 310,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: SingleChildScrollView(child: getDialogContent())),
                actions: [
                  Row(
                    children: [footerbutton],
                  )
                ],
              );
            }),
            progressBar,
          ],
        );
      },
    );
  }

  Widget getDialogContent() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Visibility(
        visible: (Constants.AUTH_ROLEID == Constants.NHMANAGER),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: double.infinity,
              // height: 70,
              child: CommonDropdownButtonFormField<BdoList>(
                label: "Zonal Trader",
                value: selectedZonalHead,
                onChanged: (BdoList? newValue) {
                  GMLogger.v('object - ${newValue!.id}');
                  setState(() {
                    selectedZonalHead = newValue!;
                  });
                  BlocProvider.of<TrackOrderBloc>(context).add(
                      LoadStateHeadTrack(userId: newValue.id!, showAll: true));
                },
                items: zonalHeadList.map<DropdownMenuItem<BdoList>>((value) {
                  return DropdownMenuItem<BdoList>(
                    value: value,
                    child: Text(value.name!),
                  );
                }).toList(),
              )),
        ),
      ),
      Visibility(
        visible: (Constants.AUTH_ROLEID == Constants.ZHMANAGER) ||
            (Constants.AUTH_ROLEID == Constants.NHMANAGER),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: double.infinity,
                // height: 70,
                child: CommonDropdownButtonFormField<BdoList>(
                  label: "State Trader",
                  value: selectedStateHead,
                  onChanged: (BdoList? newValue) {
                    GMLogger.v('object - ${newValue!.id}');
                    setState(() {
                      selectedStateHead = newValue;
                    });
                    BlocProvider.of<TrackOrderBloc>(context)
                        .add(LoadDistributorHeadTrack(userId: newValue.id!));
                  },
                  items: stateHeadList.map<DropdownMenuItem<BdoList>>((value) {
                    return DropdownMenuItem<BdoList>(
                      value: value,
                      child: Text(value.name!),
                    );
                  }).toList(),
                ))),
      ),
      Visibility(
        visible: (Constants.AUTH_ROLEID == Constants.ZHMANAGER) ||
            (Constants.AUTH_ROLEID == Constants.NHMANAGER) ||
            (Constants.AUTH_ROLEID == Constants.SALE),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 70,
          child: CustomAutocomplete<DistributorList>(
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              _distributorcontroller = fieldTextEditingController;
              return TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusTLBR),
                            topRight: Radius.circular(borderRadiusTRBL),
                            bottomLeft: Radius.circular(borderRadiusTRBL),
                            bottomRight: Radius.circular(borderRadiusTLBR)),
                        borderSide:
                            BorderSide(color: borderColor!, width: 1.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusTLBR),
                            topRight: Radius.circular(borderRadiusTRBL),
                            bottomLeft: Radius.circular(borderRadiusTRBL),
                            bottomRight: Radius.circular(borderRadiusTLBR)),
                        borderSide:
                            BorderSide(color: borderColor!, width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusTLBR),
                            topRight: Radius.circular(borderRadiusTRBL),
                            bottomLeft: Radius.circular(borderRadiusTRBL),
                            bottomRight: Radius.circular(borderRadiusTLBR)),
                        borderSide:
                            BorderSide(color: borderColor!, width: 1.0)),
                    filled: true,

                    // hintStyle: TextStyle(color: Colors.grey[800]),
                    labelText: "Distributor Name",
                    labelStyle:
                        TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                    fillColor: fillColor),
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                // style: const TextStyle(fontWeight: FontWeight.normal),
              );
            },
            displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<DistributorList>.empty();
              }
              return distributorList.where((DistributorList option) {
                return option.employeeName
                    .toString()
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (DistributorList selection) {
              FocusManager.instance.primaryFocus?.unfocus();
              GMLogger.v("customer code -- ${selection.employeeCode}");
              setState(() {
                doNumberList = [];
                selectedDistributor = selection;
                distributorEmpCode.clear();
                distributorEmpCode.add(selection.employeeCode!);
              });
              BlocProvider.of<TrackOrderBloc>(context).add(
                  LoadStateDOTrack(distributorEmpCode: distributorEmpCode));
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonTextFormField(
          labeltxt: Strings.invoiceNoStr,
          labeltxtColor: Constant.textFormFieldColor,
          labeltxtSize: Constant.textFormFieldSize,
          labeltxtFontWeight: Constant.textFormFieldSizeFontW,
          focuBorColor: Constant.textFormEnaBorCol,
          focuBorWid: Constant.textFormFocuBorWid,
          enaBorColor: Constant.textFormEnaBorCol,
          enaBorWid: Constant.textFormEnaBorWid,
          borderRadiusTL: Constant.textFormborderRadiusTL,
          borderRadiusBR: Constant.textFormborderRadiusBR,
          contentPadHor: Constant.textFormcontentPadHor,
          contentPadHVer: Constant.textFormcontentPadHVer,
          enabled: false,
          dropdownIcon: true,
          controllerTxt: _doNumberController,
          onTapCallBack: () {
            _showMultiSelectDoNumber();
          },
        ),
      ),
    ]);
  }



  Widget dialogActionButtonFilter() {
    //double buttonWidth = screenWidth / 3;

    return SizedBox(
      //  width: screenWidth * 0.84,      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         SizedBox(width: (screenWidth / 3)/2),
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
          // const SizedBox(width: 16),
         /* SizedBox(
            width: screenWidth * 0.3,
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
                statusCount = 0;
                String distributorCode =
                    (Constants.AUTH_ROLEID == Constants.DEALER)
                        ? Constants.AUTH_DEALER_CODE
                        : selectedDistributor!.employeeCode!;
                // String doNumbers = doNumbersIds.join(',');
                *//* Do Material List
                BlocProvider.of<TrackOrderBloc>(context).add(
                  LoadMaterialTrack(userId: Constants.AUTH_ROLEID, doNumber: doNumbers, isLiftingId: false
                  ),
                );*//*
                BlocProvider.of<TrackOrderBloc>(context).add(
                  FetchExternalAPITrackOrdersEvent(
                      distributorCode: distributorCode, doNumberIds: doNumbersIds[0]),
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }

  Color? getStatusColor(String status) {
    if (status == "COMPLETED") {
      return Constant.statusCompletedColor;
    } else if (status == "PENDING") {
      return Constant.statusPendingColor;
    } else {
      return Constant.statusRejectedColor;
    }
  }
}
