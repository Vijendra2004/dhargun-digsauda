import 'dart:convert';

import 'package:adaniwilmar/models/deviation_add_request.dart';
import 'package:adaniwilmar/screen/deviation_approval_status/deviation_approval_status.dart';
import 'package:adaniwilmar/screen/new_deviation_request/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../widget/widget.dart';

class NewDeviationRequestScreen extends StatelessWidget {
  const NewDeviationRequestScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const NewDeviationRequestScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewDeviationRequestBloc()
        // ..add(LoadNewDeviationRequestScreen(userId: Constants.AUTH_USERID))
        ..add(LoadDeviationReason(id: 0, saudaBookingTypeId: 0))
        ..add(LoadApprovedTourPlan(id: Constants.AUTH_USERID)),
      // ..add(LoadOilType()),
      child: NewDeviationRequestForm(),
    );
  }
}

class NewDeviationRequestForm extends StatefulWidget {
  NewDeviationRequestForm({Key? key}) : super(key: key);
  int? selectedDiscountType = 0;
  @override
  State<NewDeviationRequestForm> createState() =>
      _NewDeviationRequestFormState();
}

class _NewDeviationRequestFormState extends State<NewDeviationRequestForm> {
  List<DeviationReason> deviationReasonList = [];
  List<ApprovedMtp> approvedMtpList = [];
  List<TourPlanDetail> tourPlanList = [];
  final TextEditingController _releasedratecontroller = TextEditingController();
  final TextEditingController _remarkscontroller = TextEditingController();
  final TextEditingController _requestedratecontroller =
      TextEditingController();
  DeviationReason? selectedDeviationReason;
  ApprovedMtp? selectedApprovedMtp;
  TourPlanDetail? selectedTourPlanDetail;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0;
  double screenHeight = 0;
  String fromDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = "";
  double rate = 0;
  double finalRate = 0;
  ProgressBarHandler? _handler;
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

    return BlocListener<NewDeviationRequestBloc, NewDeviationRequestState>(
        listener: (context, state) {
          if (state is OnLoadDeviationReason) {
            deviationReasonList = state.deviationReasonList;
            setState(() {});
          }
          if (state is OnLoadApprovedTourPlan) {
            selectedApprovedMtp = null;
            approvedMtpList = state.approvedTourPlan;
            setState(() {});
          }
          if (state is OnLoadTourPlanDetailList) {
            selectedTourPlanDetail = null;
            tourPlanList = state.tourPlanDetail;
            setState(() {});
          }
          if (state is OnSaveDeviation) {
            showSuccessDlg(context, "Request Confirmed", "Success",
                successText: "Deviation Request Submitted Successfully");
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
                title: "New Deviation Request",
                backArrow: true,
                listOfActions: Row(
                  children: const [],
                )),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                      child: CurveBorderBox(
                          boxLRPadding: 8,
                          boxofWidget: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                CommonDropdownButtonFormField<DeviationReason>(
                                  value: deviationReasonList
                                          .contains(selectedDeviationReason)
                                      ? selectedDeviationReason
                                      : null,
                                  label: "Select Reason",
                                  onChanged: (DeviationReason? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      selectedDeviationReason = newValue;
                                    });
                                  },
                                  items: deviationReasonList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.reason!),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                CommonDropdownButtonFormField<ApprovedMtp>(
                                  value: approvedMtpList
                                          .contains(selectedApprovedMtp)
                                      ? selectedApprovedMtp
                                      : null,
                                  label: "MTP Number",
                                  onChanged: (ApprovedMtp? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      selectedApprovedMtp = newValue;
                                    });
                                    BlocProvider.of<NewDeviationRequestBloc>(
                                            context)
                                        .add(LoadTourPlanDetailList(
                                            mtpId: newValue.mtpId!));
                                  },
                                  items: approvedMtpList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.mtpNumber!),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16.0),
                                CommonDropdownButtonFormField<TourPlanDetail>(
                                  value: tourPlanList
                                          .contains(selectedTourPlanDetail)
                                      ? selectedTourPlanDetail
                                      : null,
                                  label: "Visitor",
                                  onChanged: (TourPlanDetail? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      selectedTourPlanDetail = newValue;
                                    });
                                    _releasedratecontroller.text =
                                        newValue.actualDate!.toString();
                                  },
                                  items: tourPlanList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.dealer!),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                CommonTextFormField(
                                  labeltxt: "Actual Date",
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
                                  contentPadHor: Constant.textFormcontentPadHor,
                                  contentPadHVer:
                                      Constant.textFormcontentPadHVer,
                                  controllerTxt: _releasedratecontroller,
                                  enabled: false,
                                ),
                                const SizedBox(height: 16.0),
                                CommonTextFormField(
                                    labeltxt: "Remarks",
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
                                    controllerTxt: _remarkscontroller,
                                    maxLine: 10,
                                    onChanged: (String? value) {
                                      setState(() {});
                                    }),
                                const SizedBox(height: 16.0),
                                InkWell(
                                    onTap: () {
                                      _selectFromDate(context, false);
                                    },
                                    child: CommonTextFormField(
                                        labeltxt: "Deviation Date",
                                        labeltxtColor:
                                            Constant.textFormFieldColor,
                                        labeltxtSize:
                                            Constant.textFormFieldSize,
                                        labeltxtFontWeight:
                                            Constant.textFormFieldSizeFontW,
                                        focuBorColor:
                                            Constant.textFormFocuBorCol,
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
                                        controllerTxt: _requestedratecontroller,
                                        enabled: false,
                                        onChanged: (String? value) {
                                          setState(() {});
                                        })),
                                const SizedBox(height: 16),
                              ],
                            ),
                          )),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    }),
                progressBar
              ],
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(
                    left: 32, right: 32, top: 16, bottom: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth / 1 - 67,
                      child: CommonButton(
                        buttonName: Constant.saudaLEButtonTxt2,
                        buttonNameSize: Constant.fontSize13,
                        buttonNameColor: Constant.pricbuttonTxtColor,
                        buttonColor: Constant.pricbuttonColor,
                        buttonHeight: 48,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Colors.transparent,
                        buttonNameWeight: Constant.fontWeight500,
                        buttonFunction: () {
                          showConfirmDlg(context, "Confirm Deviation Request",
                              "Confirm Request");
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
//popup

  void showConfirmDlg(BuildContext context, messageValue, title,
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
      // content: const Text("Confirm Deviation Request"),
      content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Icon(Icons.error_outlined,
                        size: 70, color: Colors.orange),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Confirm Deviation Request",
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Are you whish to confirm \ndeviation request",
                        textAlign: TextAlign.center,
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
                buttonName: "Cancel",
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
                }),
            CommonButton(
                buttonName: "Submit",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  if (selectedDeviationReason == null) {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Select Deviation Reason from the list",
                        closeScreen: true);
                    return;
                  }
                  if (selectedApprovedMtp == null) {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Select Approved Mtp from the list",
                        closeScreen: true);
                    return;
                  }
                  if (selectedTourPlanDetail == null) {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Select Tour Plan from the list",
                        closeScreen: true);
                    return;
                  }
                  if (_requestedratecontroller.text.toString() == "") {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Enter Deviation Date", closeScreen: true);
                    return;
                  }
                  DeviationRequest request = DeviationRequest();
                  request.monthlyTourPlanDetailsId =
                      selectedTourPlanDetail!.mtpDetailId;
                  request.createdBy = Constants.AUTH_USERID;
                  request.remarks = _remarkscontroller.text.toString();
                  request.revisedDate = DateTimeUtils()
                      .dateToServerToDateFormat(
                          _requestedratecontroller.text.toString(),
                          DateTimeUtils.DD_MM_YYYY_Format,
                          DateTimeUtils.YYYY_MM_DD_Format);
                  request.reasons = selectedDeviationReason!.reason!;
                  if (kDebugMode) {
                    GMLogger.v(jsonEncode(request));
                  }
                  BlocProvider.of<NewDeviationRequestBloc>(context)
                      .add(SaveDeviation(request: request));
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

  contBody() {}
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _releasedratecontroller.dispose();
    _remarkscontroller.dispose();
    super.dispose();
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white,
      bool? closeScreen = false}) {
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
      content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error"
                        ? Icon(Icons.error_outlined,
                            size: 70, color: Colors.red)
                        : Icon(Icons.check_circle_sharp,
                            size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title,
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
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
                buttonName: "Done",
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
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeviationApprovalStatusScreen()),
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

  _selectFromDate(BuildContext context, bool popup) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _requestedratecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _requestedratecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (selected != null) {
      _requestedratecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }
}
