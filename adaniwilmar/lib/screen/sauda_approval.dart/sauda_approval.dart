import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/models/sauda_approval_request.dart';
import 'package:adaniwilmar/screen/home.dart';
import 'package:adaniwilmar/screen/sauda_approval.dart/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SaudaApprovalScreen extends StatelessWidget {
  const SaudaApprovalScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaApprovalScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaApprovalBloc()
        ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0))
        ..add(LoadSaudaApprovalScreen(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisionId: 0,
            statusId: 1,
            pageNo: 0)),
      child: SaudaApproval(),
    );
  }
}

class SaudaApproval extends StatefulWidget {
  SaudaApproval({Key? key}) : super(key: key);
  int? selectedDiscountType = 1;

  @override
  State<SaudaApproval> createState() => _SaudaApprovalState();
}

class _SaudaApprovalState extends State<SaudaApproval> {
  int selected = 0 - 1;
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  SaudaApprovalList approvalList = SaudaApprovalList();
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
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
  String fromDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _commentcontroller = TextEditingController();
  int approvalStatusId = 0;
  final GlobalKey _dialogKey = GlobalKey();
  int selectedCount = 0;
  bool isChecked = false;
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

    return BlocListener<SaudaApprovalBloc, SaudaApprovalState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            approvalList = state.bookedSaudha;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            _fromdatecontroller.text = fromDate;
            _todatecontroller.text = toDate;
            setState(() {});
          }
          if (state is OnSaveSuccess) {
            selectedCount = 0;
            showSuccessDlg(
                context,
                approvalStatusId == 2 ? "Sauda Approved" : "Sauda Rejected",
                "Sauda Approval",
                successText: approvalStatusId == 2
                    ? "Sauda Approved"
                    : "Sauda Rejected");
            _commentcontroller.text = "";
          }
          if (state is OnFailure) {
            if (state.saveError) {
              showSuccessDlg(context, "Error", "Error",
                  successText: state.error);
            }
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
                  title: "Sauda Approval",
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
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                            height: screenHeight * 0.980,
                            width: screenWidth,
                            margin: const EdgeInsets.only(
                                top: 60, left: 2, right: 2),
                            child:
                                (approvalList.saudaListGroup != null &&
                                        approvalList.saudaListGroup!.isNotEmpty)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CurveOuterBox(
                                            boxofWidget: Column(children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Row(
                                                    children: [
                                                      const Text("Select All"),
                                                      Checkbox(
                                                        onChanged:
                                                            (bool? value) {
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
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: CommonText(
                                                        name: selectedCount
                                                                .toString() +
                                                            " Selected ",
                                                        fontColor: Constant
                                                            .colorDullGray77,
                                                        fontSize:
                                                            Constant.fontSize12,
                                                        fontWeight: Constant
                                                            .fontWeight500),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                  height: screenHeight * 0.780,
                                                  padding: EdgeInsets.zero,
                                                  child: ListView.builder(
                                                      key: const Key(
                                                          'builder 1'),
                                                      //attention
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount: approvalList
                                                                  .saudaListGroup !=
                                                              null
                                                          ? approvalList
                                                              .saudaListGroup!
                                                              .length
                                                          : 0,
                                                      itemBuilder:
                                                          (context, ind) {
                                                        return CurveOuterBox(
                                                            boxLRPadding: 0,
                                                            boxTBPadding: 2,
                                                            boxofWidget: Theme(
                                                              data: theme,
                                                              child:
                                                                  ExpansionTile(
                                                                tilePadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                initiallyExpanded:
                                                                    1 ==
                                                                        selected,
                                                                title: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 3,
                                                                      height:
                                                                          22,
                                                                      color: Constant
                                                                          .callToCcolor1,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              3),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            16),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        CommonText(
                                                                          name: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .dealerName!,
                                                                          fontColor:
                                                                              Constant.colorBlack,
                                                                          fontSize:
                                                                              Constant.fontSize13,
                                                                          fontWeight:
                                                                              Constant.fontWeight400,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                children: [
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      padding: const EdgeInsets.all(0),
                                                                      physics: const ClampingScrollPhysics(),
                                                                      itemCount: approvalList.saudaListGroup![ind].saudaList != null ? approvalList.saudaListGroup![ind].saudaList!.length : 0,
                                                                      itemBuilder: (context, index) {
                                                                        return SaudaApproWid(
                                                                          textHeading: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index]
                                                                              .dealerName,
                                                                          textHeadingFs:
                                                                              Constant.fontSize14,
                                                                          textHeadingFCol:
                                                                              Constant.colorBlack,
                                                                          textHeadingFw:
                                                                              Constant.fontWeight500,
                                                                          bgHeading:
                                                                              Constant.saudaAppDullColor,
                                                                          subHeading: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index]
                                                                              .plantName,
                                                                          subHeadingFs:
                                                                              Constant.fontSize13,
                                                                          subHeadingFColor:
                                                                              Constant.saudaAppDullColor,
                                                                          thridHeading:
                                                                              "SKU Name :",
                                                                          thridHeadingFCol:
                                                                              Constant.saudaAppDullColor,
                                                                          thridHeadingFs:
                                                                              Constant.fontSize13,
                                                                          thridHeadingDark: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index]
                                                                              .skuName,
                                                                          thridHeadingDarkFCol:
                                                                              Constant.colorBlack,
                                                                          thridHeadingDarkFs:
                                                                              Constant.fontSize13,
                                                                          thridHeadingDarkFW:
                                                                              Constant.fontWeight500,
                                                                          txtCol1Heading1:
                                                                              "Quantity",
                                                                          txtCol1HeadingCol:
                                                                              Constant.saudaAppDullColor,
                                                                          txtCol1HeadingFs:
                                                                              Constant.fontSize13,
                                                                          txtCol1HeadingOraCol:
                                                                              Constant.saudaAppDullColor,
                                                                          txtCol1SubHeading1: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index]
                                                                              .bidQuantityCase!
                                                                              .toStringAsFixed(2),
                                                                          txtCol1SubHeadingCol:
                                                                              Constant.colorBlack,
                                                                          txtCol1SubHeadingFs:
                                                                              Constant.fontSize13,
                                                                          txtCol1SubHeadingFw:
                                                                              Constant.fontWeight500,
                                                                          txtCol2SubHeading1: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index]
                                                                              .bidQuantity!
                                                                              .toStringAsFixed(2),
                                                                          txtCol3SubHeading1: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index]
                                                                              .bidPrice!
                                                                              .toStringAsFixed(2),
                                                                          txtCol2Heading1:
                                                                              "Quantity(MT)",
                                                                          txtCol3Heading1:
                                                                              "Rate(RS)",
                                                                          saudaList: approvalList
                                                                              .saudaListGroup![ind]
                                                                              .saudaList![index],
                                                                          saudaApprovedFunc:
                                                                              () {
                                                                            getSelectedCount();
                                                                            setState(() {});
                                                                          },
                                                                        );
                                                                      })
                                                                ],
                                                                onExpansionChanged:
                                                                    ((newState) {
                                                                  if (newState) {
                                                                    setState(
                                                                        () {
                                                                      selected =
                                                                          1;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      selected =
                                                                          -1;
                                                                    });
                                                                  }
                                                                }),
                                                              ),
                                                            ));
                                                      }))
                                            ]),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(top: 100),
                                        height: screenHeight * 0.980,
                                        child: const Align(
                                            alignment: Alignment.center,
                                            child: CurveOuterBox(
                                                boxTBPadding: 30,
                                                boxofWidget: Text(
                                                    "No records found")))))),
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
                              _commentcontroller.text = "";
                              showCustomAlertDialog(context, {}, 'Reject Sauda',
                                  dialogActionButton(),
                                  hideCancelBtn: true);
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
                              _commentcontroller.text = "";
                              showCustomAlertDialog(context, {},
                                  'Approve Sauda', dialogActionButton(),
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
        firstDate: DateTime.now().add(const Duration(days: -2000)),
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
        lastDate: DateTime.now().add(const Duration(days: 2000)));
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
                  constraints: const BoxConstraints(),
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
              height: 250.0,
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
          const SizedBox(width: 5),
          SizedBox(
            width: screenWidth / 3.5,
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
            width: screenWidth / 3.5,
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
                Navigator.pop(context);
                SaudaApprovalRequest request = SaudaApprovalRequest();
                request.saudaOrderIds = [];
                request.skuList = [];
                request.modifiedBy = Constants.AUTH_USERID;
                request.statusId = approvalStatusId;
                request.remarks = _commentcontroller.text.toString();
                request.loginUserId = Constants.AUTH_USERID;
                for (SaudaApprovalDealerDetail dealer
                    in approvalList.saudaListGroup!) {
                  for (SaudaList s in dealer.saudaList!) {
                    if (s.isApproved!) {
                      request.saudaOrderIds!.add(s.saudaId!);
                    }
                    if (s.skuList != null) {
                      for (SaudaApprovalSkuList sku in s.skuList!) {
                        if (sku.quantity != sku.originalQuantity) {
                          // Check if already added to avoid duplicates as per requirement
                          bool alreadyAdded = false;
                          for (var existingSku in request.skuList!) {
                            if (existingSku['skuId'] == sku.skuId) {
                              existingSku['quantity'] = sku.quantity;
                              alreadyAdded = true;
                              break;
                            }
                          }
                          if (!alreadyAdded) {
                            request.skuList!.add(
                                {"skuId": sku.skuId, "quantity": sku.quantity});
                          }
                        }
                      }
                    }
                  }
                }
                if (request.saudaOrderIds!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Select atleast one Sauda Order")));
                  return;
                }
                GMLogger.v("requestData---${request.toJson()}");
                BlocProvider.of<SaudaApprovalBloc>(context)
                    .add(SaveApproval(request: request));
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
    AlertDialog alert = AlertDialog(
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
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error"
                        ? const Icon(Icons.error_outlined,
                            size: 70, color: Colors.red)
                        : const Icon(Icons.check_circle_sharp,
                            size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title!,
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  const SizedBox(height: 20),
                  const BorderBottom(bordeSize: 1)
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
                  if (Constants.AUTH_ROLEID == Constants.SALE ||
                      Constants.AUTH_ROLEID == Constants.ZHMANAGER ||
                      Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePageNew()));
                  } else {
                    BlocProvider.of<SaudaApprovalBloc>(context).add(
                        LoadSaudaApprovalScreen(
                            userId: Constants.AUTH_USERID,
                            fromDate:
                                DateTimeUtils()
                                    .dateToServerToDateFormat(
                                        _fromdatecontroller.text.toString(),
                                        DateTimeUtils.DD_MM_YYYY_Format,
                                        DateTimeUtils.YYYY_MM_DD_Format),
                            toDate:
                                DateTimeUtils()
                                    .dateToServerToDateFormat(
                                        _todatecontroller.text.toString(),
                                        DateTimeUtils.DD_MM_YYYY_Format,
                                        DateTimeUtils.YYYY_MM_DD_Format),
                            salesOrganizationId: selectedSalesOrg != null
                                ? selectedSalesOrg!.id!
                                : 0,
                            distributionChannelId: selectedDistrChannel != null
                                ? selectedDistrChannel!.id!
                                : 0,
                            divisionId: selectedVertical != null
                                ? selectedVertical!.id!
                                : 0,
                            statusId: 1,
                            pageNo: 0));
                  }
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
                  labeltxt: "From Date",
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
          const SizedBox(width: 8.0),
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectToDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "To Date",
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
            BlocProvider.of<SaudaApprovalBloc>(ctx)
                .add(LoadDistributionChannel(id: selectedSalesOrg!.id!));
          },
          items: salesOrgList.map<DropdownMenuItem<SalesOrganization>>((value) {
            return DropdownMenuItem<SalesOrganization>(
              value: value,
              child: Text(value.salesOrganizationName!),
            );
          }).toList(),
        ),
      ),
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
            BlocProvider.of<SaudaApprovalBloc>(ctx).add(
                LoadVerticalList(distributionId: selectedDistrChannel!.id!));
          },
          items:
              distrChannels.map<DropdownMenuItem<DistributionChannel>>((value) {
            return DropdownMenuItem<DistributionChannel>(
              value: value,
              child: Text(value.distributionChannelName!),
            );
          }).toList(),
        ),
      ),
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
        ),
      ),
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
                      constraints: const BoxConstraints(),
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
                    height: 300,
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
              buttonHeight: 50,
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
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                BlocProvider.of<SaudaApprovalBloc>(ct).add(
                    LoadSaudaApprovalScreen(
                        userId: Constants.AUTH_USERID,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        salesOrganizationId: selectedSalesOrg != null
                            ? selectedSalesOrg!.id!
                            : 0,
                        distributionChannelId: selectedDistrChannel != null
                            ? selectedDistrChannel!.id!
                            : 0,
                        divisionId: selectedVertical != null
                            ? selectedVertical!.id!
                            : 0,
                        statusId: 1,
                        pageNo: 0));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  getSelectedCount() {
    selectedCount = 0;
    for (SaudaApprovalDealerDetail dealer in approvalList.saudaListGroup!) {
      for (SaudaList s in dealer.saudaList!) {
        if (s.isApproved!) {
          selectedCount = selectedCount + 1;
        }
      }
    }
  }

  selectAllSaudas() {
    selectedCount = 0;
    for (SaudaApprovalDealerDetail dealer in approvalList.saudaListGroup!) {
      selectedCount = selectedCount + dealer.saudaList!.length;
      for (SaudaList s in dealer.saudaList!) {
        s.isApproved = true;
      }
    }
  }

  unSelectAllSaudas() {
    selectedCount = 0;
    for (SaudaApprovalDealerDetail dealer in approvalList.saudaListGroup!) {
      for (SaudaList s in dealer.saudaList!) {
        s.isApproved = false;
      }
    }
  }
}
