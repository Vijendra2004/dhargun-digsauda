import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/screen/allocation/bloc/bloc.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class UpdateQuantityLimitScreen extends StatelessWidget {
  bool isAssignedQuantity = false;
  UpdateQuantityLimitScreen({this.isAssignedQuantity = false, Key? key})
      : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => UpdateQuantityLimitScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllocationBloc()
        ..add(LoadUpdateQuantityLimitData(
            userId: Constants.AUTH_USERID, assignedLimit: isAssignedQuantity)),
      child: QualityAllocation(
        isAssignedQuantity: isAssignedQuantity,
      ),
    );
  }
}

class QualityAllocation extends StatefulWidget {
  bool isAssignedQuantity = false;
  QualityAllocation({this.isAssignedQuantity = false, Key? key})
      : super(key: key);

  @override
  State<QualityAllocation> createState() => _QualityAllocationState();
}

class _QualityAllocationState extends State<QualityAllocation>
    with TickerProviderStateMixin {
  List<OilType> oilTypes = [];
  OilType? selectedOilType;
  List<QuantityRequestList> quantityManagerAllocations = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Oil Type";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  ProgressBarHandler? _handler;
  TextEditingController _quantitycontroller = TextEditingController();
  get handleOk => null;
  int selectedTab = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget contBody() {
    return const Text("jai");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var ctx = context;
    void showCustomAlertDialog(BuildContext context, messageValue, title,
        handleOk, Null Function() param4,
        {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white,
        String type = "",
        double givenQty = 0,
        double availableQty = 0,
        int specialityLimitId = 0,
        int oilTypeId = 0,
        String oilTypeName = "",
        String zhName = "",
        String validFrom = "",
        String validTo = "",
        int skuId = 0}) {
      _quantitycontroller.text = givenQty.toStringAsFixed(2);
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
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
              )),
        ),
        content: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.37,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Oil Type",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w500),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          oilTypeName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Material",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w500),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          type,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Valid From",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w500),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          validFrom,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Valid To",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w500),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          validTo,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize13,
                              color: Constant.colorBlack,
                              fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          zhName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Constant.fontSize16,
                              color: Constant.colorOrange,
                              fontWeight: FontWeight.w600),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CommonTextFormField(
                          labeltxt: "Quantity(MT)",
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
                          controllerTxt: _quantitycontroller,
                        ))
                  ],
                ))),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonButton(
                  buttonName: "Cancel",
                  buttonNameSize: Constant.pricbuttonNameSize,
                  buttonNameColor: Constant.textFormFieldColor,
                  buttonColor: Colors.white,
                  buttonHeight: Constant.pricbuttonHeight,
                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                  buttonRadiusBL: Constant.pricbutRadiusBL,
                  buttonBorder: Colors.black,
                  buttonFunction: () {
                    Navigator.pop(ctx);
                  }),
              CommonButton(
                  buttonName: "Submit",
                  buttonNameSize: Constant.pricbuttonNameSize,
                  buttonNameColor: Constant.pricbuttonTxtColor,
                  buttonColor: Constant.pricbuttonColor,
                  buttonHeight: Constant.pricbuttonHeight,
                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                  buttonRadiusBL: Constant.pricbutRadiusBL,
                  buttonBorder: Colors.transparent,
                  buttonFunction: () {
                    if (_quantitycontroller.text.toString() == "") {
                      return;
                    }
                    if (widget.isAssignedQuantity) {
                      BlocProvider.of<AllocationBloc>(ctx).add(
                          UpdateAssignedQuantityLimit(
                              request: AssignedQuantityLimitRequest(
                                  loginUserId: Constants.AUTH_USERID,
                                  id: specialityLimitId,
                                  quantityLimit: double.parse(
                                      _quantitycontroller.text.toString()))));
                    } else {
                      BlocProvider.of<AllocationBloc>(ctx).add(
                          UpdateQuantityLimit(
                              request: UpdateQuantityLimitRequest(
                                  loginUserId: Constants.AUTH_USERID,
                                  specialityFatDiscountId: specialityLimitId,
                                  actualDiscount: double.parse(
                                      _quantitycontroller.text.toString()))));
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
          return alert;
        },
      );
    }

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<AllocationBloc, AllocationState>(
        listener: (context, state) {
          if (state is OnUpdateQuantityLimitData) {
            quantityManagerAllocations = state.response;
            setState(() {});
          }
          if (state is OnSaveQuantityLimit) {
            showSuccessDlg(context, "Quantity Request", "Quantity Request",
                successText: "Request Confirmed");
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
            title: "Update Quantity Limit",
            backArrow: true,
          ),
          body: Stack(
            clipBehavior: Clip.hardEdge,
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
                  margin: EdgeInsets.only(top: 60, right: 8, left: 8),
                  child: CurveBorderBox(
                      boxLRPadding: 0,
                      boxofWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: screenHeight * 0.950,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 16),
                            padding: const EdgeInsets.only(
                              right: 14,
                              top: 14,
                              bottom: 14,
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 0),
                                physics: const ClampingScrollPhysics(),
                                itemCount: quantityManagerAllocations.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        if (Constants.AUTH_ROLEID ==
                                                Constants.NHMANAGER &&
                                            widget.isAssignedQuantity) return;
                                        showCustomAlertDialog(
                                          context,
                                          "",
                                          "Update",
                                          {},
                                          () {},
                                          type:
                                              quantityManagerAllocations[index]
                                                  .skuName!,
                                          givenQty: widget.isAssignedQuantity
                                              ? quantityManagerAllocations[
                                                      index]
                                                  .actualQuantity!
                                              : quantityManagerAllocations[
                                                      index]
                                                  .quantityLimit!,
                                          skuId:
                                              quantityManagerAllocations[index]
                                                  .skuId!,
                                          availableQty:
                                              quantityManagerAllocations[index]
                                                  .remainingQuantity!,
                                          specialityLimitId:
                                              quantityManagerAllocations[index]
                                                  .id!,
                                          oilTypeId:
                                              quantityManagerAllocations[index]
                                                  .oilTypeId!,
                                          oilTypeName:
                                              quantityManagerAllocations[index]
                                                  .oilTypeName!,
                                          zhName:
                                              quantityManagerAllocations[index]
                                                  .employeeName!,
                                          validFrom: DateTimeUtils()
                                              .dateToServerToDateFormat(
                                                  quantityManagerAllocations[
                                                          index]
                                                      .validFrom!,
                                                  DateTimeUtils
                                                      .YYYY_MM_DD_Format,
                                                  DateTimeUtils
                                                      .DD_MMM_YYYY_Format),
                                          validTo: DateTimeUtils()
                                              .dateToServerToDateFormat(
                                                  quantityManagerAllocations[
                                                          index]
                                                      .validTo!,
                                                  DateTimeUtils
                                                      .YYYY_MM_DD_Format,
                                                  DateTimeUtils
                                                      .DD_MMM_YYYY_Format),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  top: 9,
                                                  bottom: 9),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF5F5F5),
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(25.0),
                                                  topRight:
                                                      Radius.circular(5.0),
                                                  bottomLeft:
                                                      Radius.circular(5.0),
                                                  bottomRight:
                                                      Radius.circular(25.0),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        quantityManagerAllocations[
                                                                    index]
                                                                .employeeName ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: Constant
                                                                .fontSize14,
                                                            color: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight500),
                                                      ),
                                                    ],
                                                  )),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      children: [
                                                        CommonLabel(
                                                          bgColor: Constant
                                                              .booSauStacolor,
                                                          name: (widget
                                                                      .isAssignedQuantity
                                                                  ? quantityManagerAllocations[
                                                                          index]
                                                                      .actualQuantity!
                                                                      .toStringAsFixed(
                                                                          2)
                                                                  : quantityManagerAllocations[
                                                                          index]
                                                                      .quantityLimit!
                                                                      .toStringAsFixed(
                                                                          2)) +
                                                              " MT",
                                                          fontSize: Constant
                                                              .fontSize11,
                                                          fontColor: Constant
                                                              .colorWhite,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  top: 2,
                                                  bottom: 2),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        quantityManagerAllocations[
                                                                index]
                                                            .oilTypeName!,
                                                        style: TextStyle(
                                                            fontSize: Constant
                                                                .fontSize14,
                                                            color: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight500),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Type",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      quantityManagerAllocations[
                                                              index]
                                                          .skuName!,
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.8,
                                                        color:
                                                            Color(0x13000000)),
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Valid From",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      DateTimeUtils().dateToServerToDateFormat(
                                                          quantityManagerAllocations[
                                                                  index]
                                                              .validFrom!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                )),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Valid To",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      DateTimeUtils().dateToServerToDateFormat(
                                                          quantityManagerAllocations[
                                                                  index]
                                                              .validTo!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.8,
                                                        color:
                                                            Color(0x13000000)),
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ));
                                }),
                          )
                        ],
                      )))),
              progressBar
            ],
          ),
        )));
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
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  BlocProvider.of<AllocationBloc>(context).add(
                      LoadUpdateQuantityLimitData(
                          userId: Constants.AUTH_USERID,
                          assignedLimit: widget.isAssignedQuantity));
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
