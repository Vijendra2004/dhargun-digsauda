import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/cheque_pending_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/screen/cheque_status_report/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../config/constant.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../../widget/widget.dart';

class ChequeStatusReport extends StatelessWidget {
  const ChequeStatusReport({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ChequeStatusReport());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChequeStatusBloc()
        ..add(LoadChequeStatusScreen(
            userId: Constants.AUTH_USERID,
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisonId: 0))
        ..add(LoadBDO(
          userId: Constants.AUTH_USERID,
        ))
        ..add(LoadChequeStatusData(
            userId: Constants.AUTH_USERID,
            bdoIds: const [],
            dealerIds: const [])),
      child: const ChequeStatusReportDetail(),
    );
  }
}

class ChequeStatusReportDetail extends StatefulWidget {
  const ChequeStatusReportDetail({Key? key}) : super(key: key);
  @override
  State<ChequeStatusReportDetail> createState() => _ChequeStatusReportState();
}

class _ChequeStatusReportState extends State<ChequeStatusReportDetail> {
  List<DistributorList> distributorList = [];
  List<DistributorList> selectedDistributors = [];

  List<BdoList> bdoList = [];
  List<BdoList> selectedBdos = [];

  List<int> selectedBdoIds = [];
  List<int> dealerIds = [];
  List<ChequePending> chequeStatus = [];

  ProgressBarHandler? _handler;
  final TextEditingController _bdoController = TextEditingController();
  final TextEditingController _distributorController = TextEditingController();
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
    return BlocListener<ChequeStatusBloc, ChequeStatusState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            distributorList = state.distributorList;
            selectedDistributors = [];
            _distributorController.text = "All Distributors";
            setState(() {});
          }
          if (state is OnLoadBDO) {
            _distributorController.text = "All Distributors";
            _bdoController.text = "All State Traders";
            selectedDistributors = [];
            selectedBdos = [];
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnChequeStatusDataSuccess) {
            chequeStatus = state.chequePendingStatus;
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
          appBar: const CustomAppBar(
              title: "Cheque Status Report", backArrow: true),
          body: Stack(
            // overflow: Overflow.visible,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                height: screenHeight * 0.980,
                margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                child: CurveBorderBox(
                  boxLRPadding: 8,
                  boxTOPPadding: 14,
                  boxofWidget: Column(
                    children: [
                      Visibility(
                          visible: Constants.AUTH_ROLEID != Constants.SALE &&
                              Constants.AUTH_ROLEID != Constants.DEALER,
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              height: 70,
                              child: InkWell(
                                  onTap: () {
                                    _showMultiSelectBdo(context);
                                  },
                                  child: CommonTextFormField(
                                    labeltxt: "All State Traders",
                                    labeltxtColor: Constant.textFormFieldColor,
                                    labeltxtSize: Constant.textFormFieldSize,
                                    labeltxtFontWeight:
                                        Constant.textFormFieldSizeFontW,
                                    focuBorColor: Constant.textFormFocuBorCol,
                                    focuBorWid: Constant.textFormFocuBorWid,
                                    enaBorColor: Constant.textFormEnaBorCol,
                                    enaBorWid: Constant.textFormEnaBorWid,
                                    borderRadiusTL:
                                        Constant.textFormborderRadiusTL,
                                    borderRadiusBR:
                                        Constant.textFormborderRadiusBR,
                                    contentPadHor:
                                        Constant.textFormcontentPadHor,
                                    contentPadHVer:
                                        Constant.textFormcontentPadHVer,
                                    keyborType: TextInputType.text,
                                    enabled: false,
                                    dropdownIcon: true,
                                    controllerTxt: _bdoController,
                                  )))),
                      Visibility(
                          visible: Constants.AUTH_ROLEID != Constants.DEALER,
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              width: double.infinity,
                              height: 70,
                              child: InkWell(
                                  onTap: () {
                                    _showMultiSelectDistributor(context);
                                  },
                                  child: CommonTextFormField(
                                    labeltxt: "Select Distributors",
                                    labeltxtColor: Constant.textFormFieldColor,
                                    labeltxtSize: Constant.textFormFieldSize,
                                    labeltxtFontWeight:
                                        Constant.textFormFieldSizeFontW,
                                    focuBorColor: Constant.textFormFocuBorCol,
                                    focuBorWid: Constant.textFormFocuBorWid,
                                    enaBorColor: Constant.textFormEnaBorCol,
                                    enaBorWid: Constant.textFormEnaBorWid,
                                    borderRadiusTL:
                                        Constant.textFormborderRadiusTL,
                                    borderRadiusBR:
                                        Constant.textFormborderRadiusBR,
                                    contentPadHor:
                                        Constant.textFormcontentPadHor,
                                    contentPadHVer:
                                        Constant.textFormcontentPadHVer,
                                    keyborType: TextInputType.text,
                                    enabled: false,
                                    dropdownIcon: true,
                                    controllerTxt: _distributorController,
                                  )))),
                      Container(
                          height: (Constants.AUTH_ROLEID ==
                                      Constants.NHMANAGER ||
                                  Constants.AUTH_ROLEID == Constants.ZHMANAGER)
                              ? screenHeight * 0.730
                              : Constants.AUTH_ROLEID == Constants.DEALER
                                  ? screenHeight * 0.910
                                  : screenHeight * 0.825,
                          // margin: const EdgeInsets.only(top: 2),
                          child: SingleChildScrollView(
                              child: ListView.builder(
                                  key: const Key('builder 1'), //attention
                                  padding: const EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: chequeStatus.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xFFDEDEDE)),
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
                                                MaterialButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => SaudaNumber()));
                                                  },
                                                  child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              right: 12,
                                                              top: 14,
                                                              bottom: 14),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFF5F5F5),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
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
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  "#" +
                                                                      chequeStatus[
                                                                              index]
                                                                          .chequeNo!,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize13,
                                                                      color: Constant
                                                                          .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight600),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                        ],
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 12,
                                                          right: 12,
                                                          bottom: 12),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(height: 3),
                                                      Container(
                                                        width: double.infinity,
                                                        decoration: const BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Color(
                                                                        0xFFBDBDBD),
                                                                    width:
                                                                        0.8))),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 12),
                                                        child: Row(
                                                          children: [
                                                            CommonText(
                                                              name:
                                                                  "Distributor Name :",
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorDullGray77,
                                                            ),
                                                            CommonText(
                                                              name: chequeStatus[
                                                                      index]
                                                                  .dealerName!,
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 14),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                    name:
                                                                        "Name of the Bank",
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorDullGray77,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          6.0),
                                                                  CommonText(
                                                                    name: chequeStatus[
                                                                            index]
                                                                        .bankName!,
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  CommonText(
                                                                    name:
                                                                        "Branch Name",
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorDullGray77,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          6.0),
                                                                  CommonText(
                                                                    name: chequeStatus[
                                                                            index]
                                                                        .branchName!,
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize12,
                                                                    fontColor:
                                                                        Constant
                                                                            .colorBlack,
                                                                    fontWeight:
                                                                        Constant
                                                                            .fontWeight500,
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
                                        ],
                                      ),
                                    );
                                  }))),
                    ],
                  ),
                ),
              ),
              progressBar
            ],
          ),
        )));
  }

  void _showMultiSelectDistributor(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<DistributorList>(
          searchable: true,
          width: MediaQuery.of(context).size.width * 0.98,
          itemsTextStyle: TextStyle(
              fontFamily: 'Aganè',
              fontSize: Constant.fontSize14,
              color: Constant.colorBlack),
          selectedItemsTextStyle: TextStyle(
              fontFamily: 'Aganè',
              fontSize: Constant.fontSize14,
              color: Constant.colorBlack,
              fontWeight: Constant.fontWeight600),
          items: distributorList
              .map((dist) =>
                  MultiSelectItem<DistributorList>(dist, dist.employeeName!))
              .toList(),
          initialValue: selectedDistributors,
          onConfirm: (List<DistributorList> values) {
            selectedDistributors = values;
            dealerIds.clear();
            for (DistributorList d in values) {
              dealerIds.add(d.id!);
            }
            if (selectedDistributors.isNotEmpty) {
              _distributorController.text =
                  selectedDistributors.length.toString() + " Distributors ";
            } else {
              _distributorController.text = "All Distributors";
            }
            BlocProvider.of<ChequeStatusBloc>(context).add(LoadChequeStatusData(
                userId: Constants.AUTH_USERID,
                bdoIds: selectedBdoIds,
                dealerIds: dealerIds));
          },
        );
      },
    );
  }

  void _showMultiSelectBdo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
          searchable: true,
          items: bdoList
              .map((dist) => MultiSelectItem<BdoList>(dist, dist.name!))
              .toList(),
          initialValue: selectedBdos,
          onConfirm: (List<BdoList> values) {
            selectedBdos = values;
            selectedBdoIds.clear();
            for (BdoList d in values) {
              selectedBdoIds.add(d.id!);
            }
            BlocProvider.of<ChequeStatusBloc>(context).add(
                LoadChequeStatusScreen(
                    userId: Constants.AUTH_USERID,
                    salesOrganizationId: 0,
                    distributionChannelId: 0,
                    divisonId: 0,
                    bdoIds: selectedBdoIds));
            BlocProvider.of<ChequeStatusBloc>(context).add(LoadChequeStatusData(
                userId: Constants.AUTH_USERID,
                bdoIds: selectedBdoIds,
                dealerIds: const []));
          },
        );
      },
    );
  }
}
