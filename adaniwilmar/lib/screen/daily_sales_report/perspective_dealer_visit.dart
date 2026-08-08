import 'dart:convert';
import 'dart:io';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_visit_request.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/daily_sales_report/bloc/bloc.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class PerspectiveDealerVisitScreen extends StatelessWidget {
  int dealerId;
  PerspectiveDealerVisitScreen({required this.dealerId, Key? key})
      : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => PerspectiveDealerVisitScreen(
              dealerId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailySalesReportBloc(),
      child: PerspectiveDealerVisitForm(
        dealerId: dealerId,
      ),
    );
  }
}

class PerspectiveDealerVisitForm extends StatefulWidget {
  PerspectiveDealerVisitForm({required this.dealerId, Key? key})
      : super(key: key);
  int dealerId;
  @override
  State<PerspectiveDealerVisitForm> createState() =>
      _PerspectiveDealerVisitFormState();
}

class _PerspectiveDealerVisitFormState
    extends State<PerspectiveDealerVisitForm> {
  final TextEditingController _prospectnamecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _mobilenumbercontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _interestlevelcontroller =
      TextEditingController();
  final TextEditingController _potentialcontroller = TextEditingController();
  List<FileList> fileList = [];
  double itemRate = 0;
  double itemRatePopup = 0;
  double itemMaxDiscount = 0;
  double itemMaxPremium = 0;
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
  ProgressBarHandler? _handler;
  final ImagePicker _picker = ImagePicker();

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
    return BlocListener<DailySalesReportBloc, DailySalesReportState>(
        listener: (context, state) {
          if (state is OnSavePriceDiscovery) {
            showSuccessDlg(context, "Request Confirmed", "Success",
                successText: state.response);
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
              title: "Perspective Dealer Visit",
              backArrow: true,
              listOfActions: Row(
                children: [],
              )),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  height: screenHeight * 0.950,
                  child: SingleChildScrollView(
                      child: CurveBorderBox(
                          boxLRPadding: 11,
                          boxofWidget: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              CommonTextFormField(
                                labeltxt: "Prospect Name",
                                labeltxtColor: Constant.textFormFieldColor,
                                labeltxtSize: Constant.textFormFieldSize,
                                labeltxtFontWeight:
                                    Constant.textFormFieldSizeFontW,
                                focuBorColor: Constant.textFormFocuBorCol,
                                focuBorWid: Constant.textFormFocuBorWid,
                                enaBorColor: Constant.textFormEnaBorCol,
                                enaBorWid: Constant.textFormEnaBorWid,
                                borderRadiusTL: Constant.textFormborderRadiusTL,
                                borderRadiusBR: Constant.textFormborderRadiusBR,
                                contentPadHor: Constant.textFormcontentPadHor,
                                contentPadHVer: Constant.textFormcontentPadHVer,
                                controllerTxt: _prospectnamecontroller,
                                enabled: true,
                              ),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                labeltxt: "Mobile Number",
                                labeltxtColor: Constant.textFormFieldColor,
                                labeltxtSize: Constant.textFormFieldSize,
                                labeltxtFontWeight:
                                    Constant.textFormFieldSizeFontW,
                                focuBorColor: Constant.textFormFocuBorCol,
                                focuBorWid: Constant.textFormFocuBorWid,
                                enaBorColor: Constant.textFormEnaBorCol,
                                enaBorWid: Constant.textFormEnaBorWid,
                                borderRadiusTL: Constant.textFormborderRadiusTL,
                                borderRadiusBR: Constant.textFormborderRadiusBR,
                                contentPadHor: Constant.textFormcontentPadHor,
                                contentPadHVer: Constant.textFormcontentPadHVer,
                                controllerTxt: _mobilenumbercontroller,
                                enabled: true,
                                keyborType: TextInputType.number,
                              ),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                labeltxt: "Email ID",
                                labeltxtColor: Constant.textFormFieldColor,
                                labeltxtSize: Constant.textFormFieldSize,
                                labeltxtFontWeight:
                                    Constant.textFormFieldSizeFontW,
                                focuBorColor: Constant.textFormFocuBorCol,
                                focuBorWid: Constant.textFormFocuBorWid,
                                enaBorColor: Constant.textFormEnaBorCol,
                                enaBorWid: Constant.textFormEnaBorWid,
                                borderRadiusTL: Constant.textFormborderRadiusTL,
                                borderRadiusBR: Constant.textFormborderRadiusBR,
                                contentPadHor: Constant.textFormcontentPadHor,
                                contentPadHVer: Constant.textFormcontentPadHVer,
                                controllerTxt: _emailcontroller,
                                enabled: true,
                              ),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                labeltxt: "Address",
                                maxLine: 3,
                                labeltxtColor: Constant.textFormFieldColor,
                                labeltxtSize: Constant.textFormFieldSize,
                                labeltxtFontWeight:
                                    Constant.textFormFieldSizeFontW,
                                focuBorColor: Constant.textFormFocuBorCol,
                                focuBorWid: Constant.textFormFocuBorWid,
                                enaBorColor: Constant.textFormEnaBorCol,
                                enaBorWid: Constant.textFormEnaBorWid,
                                borderRadiusTL: Constant.textFormborderRadiusTL,
                                borderRadiusBR: Constant.textFormborderRadiusBR,
                                contentPadHor: Constant.textFormcontentPadHor,
                                contentPadHVer: Constant.textFormcontentPadHVer,
                                controllerTxt: _addresscontroller,
                                enabled: true,
                              ),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                labeltxt: "Perspective Sale(MT)",
                                maxLine: 1,
                                labeltxtColor: Constant.textFormFieldColor,
                                labeltxtSize: Constant.textFormFieldSize,
                                labeltxtFontWeight:
                                    Constant.textFormFieldSizeFontW,
                                focuBorColor: Constant.textFormFocuBorCol,
                                focuBorWid: Constant.textFormFocuBorWid,
                                enaBorColor: Constant.textFormEnaBorCol,
                                enaBorWid: Constant.textFormEnaBorWid,
                                borderRadiusTL: Constant.textFormborderRadiusTL,
                                borderRadiusBR: Constant.textFormborderRadiusBR,
                                contentPadHor: Constant.textFormcontentPadHor,
                                contentPadHVer: Constant.textFormcontentPadHVer,
                                controllerTxt: _quantitycontroller,
                                keyborType: TextInputType.number,
                                enabled: true,
                              ),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                  labeltxt: "Perspective Interest Level",
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
                                  controllerTxt: _interestlevelcontroller,
                                  keyborType: TextInputType.number,
                                  onChanged: (String? value) {
                                    setState(() {});
                                  }),
                              const SizedBox(height: 16.0),
                              CommonTextFormField(
                                  labeltxt: "Business Potential (Rs./Year)",
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
                                  controllerTxt: _potentialcontroller,
                                  keyborType: TextInputType.number,
                                  onChanged: (String? value) {
                                    setState(() {});
                                  }),
                              const SizedBox(height: 16),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                      onTap: () async {
                                        XFile? pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          FileList f = FileList();
                                          f.filePath = pickedFile.path;
                                          f.fileName = pickedFile.name;
                                          f.id = 1;
                                          f.fileExtention = pickedFile.name
                                              .substring(pickedFile.name
                                                      .lastIndexOf(".") +
                                                  1);
                                          fileList.add(f);
                                          setState(() {});
                                        }
                                      },
                                      child: CommonText(
                                        name: "Attach a file",
                                        fontSize: Constant.fontSize13,
                                        fontColor: Constant.colorBlack,
                                      ))),
                              ListView.builder(
                                key: Key('builderfile'), //attention
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int idx) {
                                  return Stack(children: [
                                    InkWell(
                                        onTap: () {
                                          fileList.removeAt(idx);
                                          setState(() {});
                                        },
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Icon(Icons.delete,
                                                      color: Constant
                                                          .colorGray45)),
                                            ))),
                                    SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: Image.file(
                                            File(fileList[idx].filePath!)))
                                  ]);
                                },
                                itemCount: fileList.length,
                              )
                            ],
                          ))))),
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
                        if (_prospectnamecontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Prospect Name");
                          return;
                        }
                        if (_mobilenumbercontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Mobile Number");
                          return;
                        }
                        if (_emailcontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Email ID");
                          return;
                        }
                        if (_addresscontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Address");
                          return;
                        }
                        if (_quantitycontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Perspective Sale");
                          return;
                        }
                        if (_interestlevelcontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Interest Level");
                          return;
                        }
                        if (_potentialcontroller.text.toString() == "") {
                          showSuccessDlg(context, "Error", "Error",
                              successText: "Enter Business Potential");
                          return;
                        }
                        showConfirmDlg(
                            context,
                            "Confirm Perspective Dealer Visit Request",
                            "Confirm Request");
                      },
                    ),
                  ),
                ],
              )),
        )));
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
      content: const Text("Confirm Perspective Dealer Visit Request"),
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
                buttonHeight: 48,
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
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  PerspectiveVisitRequest request = PerspectiveVisitRequest();
                  request.prospectiveDealerAddDto = ProspectiveDealerAddDto();
                  request.prospectiveDealerAddDto!.fileList = fileList;
                  request.prospectiveDealerAddDto!.dealerId = widget.dealerId;
                  request.prospectiveDealerAddDto!.name =
                      _prospectnamecontroller.text.toString();
                  request.prospectiveDealerAddDto!.businessPotentialPeryear =
                      double.parse(_potentialcontroller.text.toString());
                  request.prospectiveDealerAddDto!.prospectiveSales =
                      double.parse(_quantitycontroller.text.toString());
                  request.prospectiveDealerAddDto!.prospectiveInterestLevel =
                      double.parse(_interestlevelcontroller.text.toString());
                  request.prospectiveDealerAddDto!.address =
                      _addresscontroller.text.toString();
                  request.prospectiveDealerAddDto!.createdBy =
                      Constants.AUTH_USERID;
                  request.prospectiveDealerAddDto!.mobileNumber =
                      _mobilenumbercontroller.text.toString();
                  request.prospectiveDealerAddDto!.email =
                      _emailcontroller.text.toString();
                  request.prospectiveDealerAddDto!.isActive = true;
                  request.prospectiveDealerAddDto!.stateId = 0;
                  request.prospectiveDealerAddDto!.pincode = "";
                  request.prospectiveDealerAddDto!.cityId = 0;
                  BlocProvider.of<DailySalesReportBloc>(context)
                      .add(SavePerspectiveVisit(request: request));
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
    _quantitycontroller.dispose();
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
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
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
