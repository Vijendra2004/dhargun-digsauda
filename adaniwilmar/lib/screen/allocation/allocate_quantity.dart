import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/screen/allocation/bloc/bloc.dart';
import 'package:adaniwilmar/screen/allocation/user_quantity_limit.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class AllocateQuantityScreen extends StatelessWidget {
  QuantityRequestList quantityLimit = QuantityRequestList();

  AllocateQuantityScreen({required this.quantityLimit, Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => AllocateQuantityScreen(
              quantityLimit: QuantityRequestList(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllocationBloc()
        // ..add(LoadAllocateQuantityScreen(userId: Constants.AUTH_USERID))
        ..add(LoadZonalHead(userId: Constants.AUTH_USERID)),
      child: AllocateQuantityForm(
        quantityLimit: quantityLimit,
      ),
    );
  }
}

class AllocateQuantityForm extends StatefulWidget {
  QuantityRequestList quantityLimit = QuantityRequestList();

  AllocateQuantityForm({required this.quantityLimit, Key? key}) : super(key: key);

  @override
  State<AllocateQuantityForm> createState() => _AllocateQuantityFormState();
}

class _AllocateQuantityFormState extends State<AllocateQuantityForm> {
  QuantityRequestList quantityLimit = QuantityRequestList();
  List<BdoList> zhList = [];
  final TextEditingController _limitcontroller = TextEditingController();
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
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
  ProgressBarHandler? _handler;
  bool isZhChecked = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<AllocationBloc, AllocationState>(
        listener: (context, state) {
          if (state is OnLoadZhList) {
            zhList = state.zhList;
            setState(() {});
          }
          if (state is OnSaveQuantityLimit) {
            showSuccessDlg(context, "Request Confirmed", "Success", successText: "Your quantity limit request has been raised successfully");
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
            title: "Allocate Quantity",
            backArrow: true,
            listOfActions: Row(
              children: [],
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
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 60),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      CurveOuterBox(
                          boxLRPadding: 0,
                          boxTBPadding: 0,
                          boxofWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CurveOuterBox(
                                  boxBgColor: const Color(0xFFFFFBF7),
                                  boxShadowColor: const Color(0xFFFFFFFF),
                                  boxofWidget: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.all(0.0),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    name: "Oil Type",
                                                    fontSize: Constant.fontSize13,
                                                    fontColor: Constant.colorDullGray77,
                                                  ),
                                                  CommonText(
                                                    name: widget.quantityLimit.oilTypeName ?? "",
                                                    fontSize: Constant.fontSize12,
                                                    fontColor: Constant.colorBlack,
                                                    fontWeight: Constant.fontWeight600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
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
                                                  CommonText(name: "Material", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: widget.quantityLimit.skuName ?? "", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight500),
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
                                                  CommonText(name: "Valid From", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: widget.quantityLimit.validFrom != null
                                                          ? DateTimeUtils().dateToServerToDateFormat(widget.quantityLimit.validFrom!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format)
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
                                                  CommonText(name: "Valid To", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: widget.quantityLimit.validTo != null
                                                          ? DateTimeUtils().dateToServerToDateFormat(widget.quantityLimit.validTo!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_YYYY_Format)
                                                          : "",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500),
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
                                                  CommonText(name: "Actual Quantity", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: widget.quantityLimit.quantityLimit != null ? widget.quantityLimit.quantityLimit!.toStringAsFixed(2) : "",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorOrange,
                                                      fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CommonText(name: "Remaining Quantity", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                                                  const SizedBox(height: 4),
                                                  CommonText(
                                                      name: widget.quantityLimit.remainingQuantity != null ? widget.quantityLimit.remainingQuantity!.toStringAsFixed(2) : "",
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorOrange,
                                                      fontWeight: Constant.fontWeight500),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CommonTextFormField(
                                  labeltxt: "Quantity (MT)",
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
                                  controllerTxt: _limitcontroller,
                                  keyborType: TextInputType.number,
                                  onChanged: (String? value) {
                                    setState(() {});
                                  }),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          _selectFromDate(context, false);
                                        },
                                        child: CommonTextFormField(
                                          labeltxt: "Valid From",
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
                                          _selectToDate(context, false);
                                        },
                                        child: CommonTextFormField(
                                          labeltxt: "Valid To",
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
                              const SizedBox(height: 16.0),
                              CommonText(
                                  name: "Select " + (Constants.AUTH_ROLEID == Constants.NHMANAGER ? "Zonal Trader" : "State Trader"), fontSize: Constant.fontSize14, fontColor: Constant.colorBlack),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  const Text("Select All"),
                                  Checkbox(
                                    onChanged: (bool? value) {
                                      isZhChecked = value!;
                                      if (value) {
                                        selectAllZh();
                                      } else {
                                        unselectAllZh();
                                      }
                                      setState(() {});
                                    },
                                    value: isZhChecked,
                                    activeColor: Colors.green[600],
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: zhList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Checkbox(
                                              onChanged: (bool? value) {
                                                zhList[index].selected = value;
                                                setState(() {});
                                              },
                                              value: zhList[index].selected!,
                                              activeColor: Colors.green,
                                            )),
                                        Expanded(
                                            child: Text(
                                          zhList[index].name!,
                                          style: TextStyle(
                                            fontSize: Constant.fontSize14,
                                            color: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                        )),
                                      ]),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )),
                    ],
                  ))),
              progressBar
            ],
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth / 2 - 40,
                    child: CommonButton(
                        buttonName: Constant.saudaLEButtonTxt1,
                        buttonNameSize: Constant.pricbuttonNameSize,
                        buttonNameColor: Constant.saudaLETTxtColor,
                        buttonColor: Constant.saudaLETbuttonColor,
                        buttonHeight: Constant.pricbuttonHeight,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Constant.saudaLETbuttonBorder,
                        buttonFunction: () {
                          _limitcontroller.text = "";
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserQuantityLimitScreen()),
                          );
                        }),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: screenWidth / 2 - 40,
                    child: CommonButton(
                        buttonName: Constant.saudaLEButtonTxt2,
                        buttonNameSize: Constant.pricbuttonNameSize,
                        buttonNameColor: Constant.pricbuttonTxtColor,
                        buttonColor: Constant.pricbuttonColor,
                        buttonHeight: Constant.pricbuttonHeight,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Colors.transparent,
                        buttonFunction: () {
                          if (_limitcontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error", successText: "Enter Quantity", closeScreen: false);
                            return;
                          }
                          if (_fromdatecontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error", successText: "Enter Valid From", closeScreen: false);
                            return;
                          }
                          if (_todatecontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error", successText: "Enter Valid To", closeScreen: false);
                            return;
                          }
                          AllocateQuantityLimitRequest request = AllocateQuantityLimitRequest();
                          request.loginUserId = Constants.AUTH_USERID;
                          request.id = widget.quantityLimit.id;
                          request.oilTypeId = widget.quantityLimit.oilTypeId;
                          request.skuId = widget.quantityLimit.skuId;
                          request.empActualDiscount = double.parse(_limitcontroller.text.toString());
                          if (_fromdatecontroller.text.toString() != "") {
                            request.empValidFrom = DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format);
                          } else {
                            request.empValidFrom = "";
                          }
                          if (_todatecontroller.text.toString() != "") {
                            request.empValidTo = DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format);
                          } else {
                            request.empValidTo = "";
                          }
                          request.customerId = [];
                          for (BdoList s in zhList) {
                            if (s.selected!) {
                              request.customerId!.add(s.id!);
                            }
                          }
                          if (request.customerId!.length == 0) {
                            showSuccessDlg(context, "Error", "Error", successText: "Select Zonal Trader from the list", closeScreen: false);
                            return;
                          }
                          BlocProvider.of<AllocationBloc>(context).add(SaveAllocateQuantityLimit(request: request));
                        }),
                  ),
                ],
              )),
        )));
  }

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white, bool? closeScreen = false}) {
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
      title: SizedBox.shrink(),
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
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserQuantityLimitScreen()),
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
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      _todatecontroller.text = "";
    }
  }

  _selectToDate(BuildContext context, bool popup) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _todatecontroller.text.toString() == ""
            ? _fromdatecontroller.text.toString() == ""
                ? DateTime.now()
                : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format))
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        lastDate: DateTime.now().add(Duration(days: 2000)));
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  selectAllZh() {
    for (BdoList z in zhList) {
      z.selected = true;
    }
  }

  unselectAllZh() {
    for (BdoList z in zhList) {
      z.selected = false;
    }
  }
}
