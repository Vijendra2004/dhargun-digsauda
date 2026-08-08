import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/models/status_list.dart';
import 'package:adaniwilmar/screen/special_rate_approval_manager/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:adaniwilmar/widget/special_rate_app_wid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SpecialRateApprovalManagerScreen extends StatelessWidget {
  const SpecialRateApprovalManagerScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SpecialRateApprovalManagerScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialRateApprovalManagerBloc()
        ..add(LoadBdoList(userId: Constants.AUTH_USERID))
        ..add(LoadSpecialRateApprovalManagerScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now().add(Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            bdoId: 0,
            salesOrganizationId: 1,
            distributionChannelId: 1,
            divisionId: 1,
            statusId: Constants.AUTH_ROLEID==Constants.ZHMANAGER?15:9))
        ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
      child: SpecialRateApprovalManager(),
    );
  }
}

class SpecialRateApprovalManager extends StatefulWidget {
  SpecialRateApprovalManager({Key? key}) : super(key: key);
  int? selectedDiscountType = 1;
  @override
  State<SpecialRateApprovalManager> createState() =>
      _SpecialRateApprovalManagerState();
}

class _SpecialRateApprovalManagerState
    extends State<SpecialRateApprovalManager> {
  List<BdoList> bdoList = [];
  List<SpecialRateList> approvalList = [];
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<StatusList> statusList = [];
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  StatusList? selectedStatus;
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  BdoList? selectedBdo;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0;
  double screenHeight = 0;
  String fromDate = DateTimeUtils().dateToStringFormat(
      DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)),
      DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _commentcontroller = TextEditingController();
  int approvalStatusId = 0;
  final GlobalKey _dialogKey = GlobalKey();
  ProgressBarHandler? _handler;
  bool _isRemarkEditing = false;
  
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
    return BlocListener<SpecialRateApprovalManagerBloc,
            SpecialRateApprovalManagerState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            approvalList = state.specialRateList;
            setState(() {});
          }
          if (state is OnLoadBdoList) {
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            StatusList s = StatusList(id: 1, name: "Pending");
            statusList.add(s);
            if(Constants.AUTH_ROLEID==Constants.ZHMANAGER) {
              StatusList s1 = StatusList(
                  id: 15, name: "Waiting For Request Approval");
              statusList.add(s1);
              selectedStatus=s1;
            }else {
              StatusList s1 = StatusList(id: 9, name: "Request For Approval");
              statusList.add(s1);
              selectedStatus=s1;
            }
            StatusList s2 = StatusList(id: 6, name: "Completed");
            statusList.add(s2);
            _fromdatecontroller.text = fromDate;
            _todatecontroller.text = toDate;
            setState(() {});
          }
          if (state is OnLoadDistributionChannel) {
            if (_dialogKey.currentState != null &&
                _dialogKey.currentState!.mounted) {
              _dialogKey.currentState!.setState(() {
                selectedDistrChannel = null;
                distrChannels = state.distributionChannel;
              });
            }
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            if (_dialogKey.currentState != null &&
                _dialogKey.currentState!.mounted) {
              _dialogKey.currentState!.setState(() {
                selectedVertical = null;
                verticals = state.verticalList;
              });
            }
            setState(() {});
          }
          if (state is OnSaveSuccess) {
            showSuccessDlg(
                context,
                approvalStatusId == 2 || approvalStatusId == 9
                    ? "Special Rate Approved"
                    : "Special Rate Rejected",
                "Special Rate Approval",
                successText: approvalStatusId == 2 || approvalStatusId == 9
                    ? "Special Rate Approved"
                    : "Special Rate Rejected");
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
                  title: "Special Rate Approval",
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
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                        child:Container(
                        height: screenHeight * 0.980,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                        child: CurveOuterBox(
                          boxofWidget: Column(children: [
                            SizedBox(
                                width: double.infinity,
                                child: CommonDropdownButtonFormField<BdoList>(
                                  value: selectedBdo,
                                  label: Constants.ZHMANAGER == Constants.AUTH_ROLEID
                                      ? "State Trader"
                                      : Constants.NHMANAGER == Constants.AUTH_ROLEID
                                          ? "Zonal Traders"
                                          : "Distributors",
                                  onChanged: (BdoList? newValue) {
                                    setState(() {
                                      selectedBdo = newValue!;
                                    });
                                    BlocProvider.of<SpecialRateApprovalManagerBloc>(context)
                                        .add(LoadSpecialRateApprovalManagerScreen(
                                            userId: Constants.AUTH_USERID,
                                            fromDate: DateTimeUtils()
                                                .dateToServerToDateFormat(
                                                    _fromdatecontroller.text
                                                        .toString(),
                                                    DateTimeUtils
                                                        .DD_MM_YYYY_Format,
                                                    DateTimeUtils
                                                        .YYYY_MM_DD_Format),
                                            toDate: DateTimeUtils().dateToServerToDateFormat(
                                                _todatecontroller.text
                                                    .toString(),
                                                DateTimeUtils.DD_MM_YYYY_Format,
                                                DateTimeUtils
                                                    .YYYY_MM_DD_Format),
                                            bdoId: selectedBdo != null
                                                ? selectedBdo!.id!
                                                : 0,
                                            salesOrganizationId:
                                                selectedSalesOrg != null
                                                    ? selectedSalesOrg!.id!
                                                    : 0,
                                            distributionChannelId:
                                                selectedDistrChannel != null
                                                    ? selectedDistrChannel!.id!
                                                    : 0,
                                            divisionId: selectedVertical != null
                                                ? selectedVertical!.id!
                                                : 0,
                                            statusId: selectedStatus != null
                                                ? selectedStatus!.id
                                                : Constants.AUTH_ROLEID==Constants.ZHMANAGER?15:9));
                                  },
                                  items: bdoList
                                      .map<DropdownMenuItem<BdoList>>((value) {
                                    return DropdownMenuItem<BdoList>(
                                      value: value,
                                      child: Text(value.name!),
                                    );
                                  }).toList(),
                                )),
                            Container(
                              height: screenHeight * 0.750,
                              width: screenWidth,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: approvalList.length,
                                  itemBuilder: (context, index) {
                                    return SpecialRateApproWid(
                                      textHeading: approvalList[index]
                                          .dealerName!
                                          .split("-")[0],
                                      textHeadingFs: Constant.fontSize14,
                                      textHeadingFCol: Constant.colorBlack,
                                      textHeadingFw: Constant.fontWeight500,
                                      bgHeading: Constant.saudaAppDullColor,
                                      subHeading: approvalList[index]
                                          .dealerName!
                                          .split("-")[1],
                                      subHeadingFs: Constant.fontSize13,
                                      subHeadingFColor:
                                          Constant.saudaAppDullColor,
                                      thridHeading: "SKU Name :",
                                      thridHeadingFCol:
                                          Constant.saudaAppDullColor,
                                      thridHeadingFs: Constant.fontSize13,
                                      thridHeadingDark:
                                          approvalList[index].skuName,
                                      thridHeadingDarkFCol: Constant.colorBlack,
                                      thridHeadingDarkFs: Constant.fontSize13,
                                      thridHeadingDarkFW:
                                          Constant.fontWeight500,
                                      txtCol1Heading1: "Req. Price",
                                      txtCol1HeadingCol:
                                          Constant.saudaAppDullColor,
                                      txtCol1HeadingFs: Constant.fontSize13,
                                      txtCol1HeadingOraCol:
                                          Constant.saudaAppDullColor,
                                      txtCol1SubHeading1: approvalList[index]
                                          .specialPrice!
                                          .toStringAsFixed(2),
                                      txtCol1SubHeadingCol: Constant.colorBlack,
                                      txtCol1SubHeadingFs: Constant.fontSize13,
                                      txtCol1SubHeadingFw:
                                          Constant.fontWeight500,
                                      txtCol2SubHeading1: approvalList[index]
                                          .quantity!
                                          .toStringAsFixed(2),
                                      txtCol3SubHeading1: approvalList[index]
                                          .discountOrPremium!
                                          .toStringAsFixed(2),
                                      txtCol2Heading1: "Quantity",
                                      txtCol3Heading1: "Discount",
                                      specialRateList: approvalList[index],
                                    );
                                  }),
                            )
                          ]),
                        ))),
                    progressBar
                  ],
                ),
                bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 6),
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
                              showCustomAlertDialog(context, {},
                                  'Reject Special Rate', dialogActionButton(),
                                  hideCancelBtn: true);
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          child: CommonButton(
                            buttonName: ((selectedStatus == null ||
                                  selectedStatus!.id == 15) && Constants.ZHMANAGER==Constants.AUTH_ROLEID)
                                ? "Request for Approval"
                                : "Approve",
                            buttonNameSize: Constant.fontSize13,
                            buttonNameColor: Constant.pricbuttonTxtColor,
                            buttonColor: Constant.saudaLETBoxColor1,
                            buttonHeight: 40,
                            buttonRadiusTL: Constant.pricbuttonRadiusTL,
                            buttonRadiusBL: Constant.pricbutRadiusBL,
                            buttonBorder: Colors.transparent,
                            buttonNameWeight: Constant.fontWeight500,
                            buttonFunction: () {
                              if (selectedStatus != null &&
                                  selectedStatus!.id == 15) {
                                approvalStatusId = 9;
                              } else {
                                approvalStatusId = 2;
                              }
                              showCustomAlertDialog(context, {},
                                  'Approve Special Rate', dialogActionButton(),
                                  hideCancelBtn: true);
                            },
                          ),
                        ),
                      ],
                    )))));
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now());
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _todatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: _todatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _todatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        lastDate: DateTime.now());
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  void showCustomAlertDialog(
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
              child: SingleChildScrollView(
                child: SizedBox(
                height: _isRemarkEditing ? 150 : 200,
                //  crossAxisAlignment: CrossAxisAlignment.start,
                  child: 
                  //[
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
                      onTapCallBack: () {
                        setState(() {
                        _isRemarkEditing = true;
                        });
                      },
                    )
                 // ],
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
          // const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 3.2,
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
          const SizedBox(width: 12),
          SizedBox(
            width: screenWidth / 3.2,
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
                SpecialRateManagerRequest request = SpecialRateManagerRequest();
                request.specialRateIdInfo = [];
                request.loginUserId = Constants.AUTH_USERID;
                request.statusId = approvalStatusId;
                request.remarks = _commentcontroller.text.toString();
                request.salesOrganizationId =
                    selectedSalesOrg == null ? 1 : selectedSalesOrg!.id!;
                request.distributionChannelId = selectedDistrChannel == null
                    ? 1
                    : selectedDistrChannel!.id!;
                request.divisionId =
                    selectedVertical == null ? 1 : selectedVertical!.id!;
                for (SpecialRateList s in approvalList) {
                  if (s.isApproved!) {
                    SpecialRateIdInfo ns = SpecialRateIdInfo();
                    ns.specialRateIds = s!.specialRateId!;
                    ns.dealerId=s!.dealerId;
                    ns.quantityInCases=s!.quantity;
                    // ns.saudaValidFromDate = s!.requestDate;
                    request.specialRateIdInfo!.add(ns);
                  }
                }
                BlocProvider.of<SpecialRateApprovalManagerBloc>(context)
                    .add(SaveApproval(request: request));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  contBody() {}
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
                  if (title == "Error") {
                    return;
                  }
                  BlocProvider.of<SpecialRateApprovalManagerBloc>(context).add(
                      LoadSpecialRateApprovalManagerScreen(
                          userId: Constants.AUTH_USERID,
                          fromDate: DateTimeUtils().dateToServerToDateFormat(
                              _fromdatecontroller.text.toString(),
                              DateTimeUtils.DD_MM_YYYY_Format,
                              DateTimeUtils.YYYY_MM_DD_Format),
                          toDate: DateTimeUtils().dateToServerToDateFormat(
                              _todatecontroller.text.toString(),
                              DateTimeUtils.DD_MM_YYYY_Format,
                              DateTimeUtils.YYYY_MM_DD_Format),
                          bdoId: selectedBdo != null ? selectedBdo!.id! : 0,
                          salesOrganizationId: selectedSalesOrg != null
                              ? selectedSalesOrg!.id!
                              : 0,
                          distributionChannelId: selectedDistrChannel != null
                              ? selectedDistrChannel!.id!
                              : 0,
                          divisionId: selectedVertical != null
                              ? selectedVertical!.id!
                              : 0,
                          statusId:
                              selectedStatus != null ? selectedStatus!.id : Constants.AUTH_ROLEID==Constants.ZHMANAGER?15:9));
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
      Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectFromDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "From",
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
                  controllerTxt: _fromdatecontroller,
                  enabled: false,
                )),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectToDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "To",
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
                  controllerTxt: _todatecontroller,
                  enabled: false,
                )),
          ),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: CommonDropdownButtonFormField<SalesOrganization>(
            value: selectedSalesOrg,
            label: "Sales Organization",
            onChanged: (SalesOrganization? newValue) {
              setState(() {
                selectedSalesOrg = newValue!;
              });
              BlocProvider.of<SpecialRateApprovalManagerBloc>(ctx)
                  .add(LoadDistributionChannel(id: selectedSalesOrg!.id!));
            },
            items:
                salesOrgList.map<DropdownMenuItem<SalesOrganization>>((value) {
              return DropdownMenuItem<SalesOrganization>(
                value: value,
                child: Text(value.salesOrganizationName!),
              );
            }).toList(),
          )),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: CommonDropdownButtonFormField<DistributionChannel>(
            value: selectedDistrChannel,
            label: "Distribution Channel",
            onChanged: (DistributionChannel? newValue) {
              setState(() {
                selectedDistrChannel = newValue!;
              });
              BlocProvider.of<SpecialRateApprovalManagerBloc>(ctx).add(
                  LoadVerticalList(distributionId: selectedDistrChannel!.id!));
            },
            items: distrChannels
                .map<DropdownMenuItem<DistributionChannel>>((value) {
              return DropdownMenuItem<DistributionChannel>(
                value: value,
                child: Text(value.distributionChannelName!),
              );
            }).toList(),
          )),
      const SizedBox(height: 16.0),
      SizedBox(
          width: double.infinity,
          child: CommonDropdownButtonFormField<Vertical>(
            value: selectedVertical,
            label: "Division",
            onChanged: (Vertical? newValue) {
              setState(() {
                selectedVertical = newValue!;
              });
            },
            items: verticals.map<DropdownMenuItem<Vertical>>((value) {
              return DropdownMenuItem<Vertical>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          )),
      const SizedBox(height: 16.0),
      SizedBox(
          width: double.infinity,
          child: CommonDropdownButtonFormField<StatusList>(
            value: selectedStatus,
            label: "Status",
            onChanged: (StatusList? newValue) {
              setState(() {
                selectedStatus = newValue!;
              });
            },
            items: statusList.map<DropdownMenuItem<StatusList>>((value) {
              return DropdownMenuItem<StatusList>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          )),
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
        return StatefulBuilder(
            key: _dialogKey,
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
                    height: 350,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: getDialogContent()),
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

  Widget dialogActionButtonFilter() {
    var ct = context;
    return SizedBox(
      // width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 3.2,
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
          const SizedBox(width: 12),
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Apply",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                BlocProvider.of<SpecialRateApprovalManagerBloc>(ct).add(
                    LoadSpecialRateApprovalManagerScreen(
                        userId: Constants.AUTH_USERID,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        bdoId: selectedBdo != null ? selectedBdo!.id! : 0,
                        salesOrganizationId: selectedSalesOrg != null
                            ? selectedSalesOrg!.id!
                            : 0,
                        distributionChannelId: selectedDistrChannel != null
                            ? selectedDistrChannel!.id!
                            : 0,
                        divisionId: selectedVertical != null
                            ? selectedVertical!.id!
                            : 0,
                        statusId:
                            selectedStatus != null ? selectedStatus!.id : Constants.AUTH_ROLEID==Constants.ZHMANAGER?15:9));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
