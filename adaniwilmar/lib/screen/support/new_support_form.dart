import 'dart:convert';

import 'package:adaniwilmar/models/support_list_response.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/screen/support/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class NewSupportScreen extends StatelessWidget {
  const NewSupportScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const NewSupportScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()
        ..add(LoadNewSupportScreen(userId: Constants.AUTH_USERID)),
      //   ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
      // ..add(LoadOilType()),
      child: const NewSupportForm(),
    );
  }
}

class NewSupportForm extends StatefulWidget {
  const NewSupportForm({Key? key}) : super(key: key);

  @override
  State<NewSupportForm> createState() => _NewSupportFormState();
}

class _NewSupportFormState extends State<NewSupportForm> {
  List<IssueTypes> featureList = [];
  List<IssueTypes> componentList = [];
  List<IssueTypes> severityList = [];
  final TextEditingController _remarkscontroller = TextEditingController();
  IssueTypes? selectedFeature;
  IssueTypes? selectedComponent;
  IssueTypes? selectedSeverity;
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
    return BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is OnNewSupportSuccess) {
            selectedComponent = null;
            selectedFeature = null;
            selectedSeverity = null;
            featureList = state.response.issueTypes!;
            componentList = state.response.modules!;
            severityList = state.response.severityTypes!;
            setState(() {});
          }
          if (state is OnSaveSuccess) {
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
              title: "New Support Ticket",
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
                    height: screenHeight,
                    width: screenWidth,
                    margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                    child: CurveBorderBox(
                        boxLRPadding: 8.0,
                        boxTOPPadding: 14.0,
                        boxofWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return SizedBox(
                                  width: double.infinity,
                                  // height: 70,
                                  child: CommonDropdownButtonFormField<IssueTypes>(
                                    value: selectedFeature,
                                    label: "Feature",
                                    onChanged: (IssueTypes? newValue) {
                                      setState(() {
                                        selectedFeature = newValue!;
                                      });
                                    },
                                    items: featureList
                                        .map<DropdownMenuItem<IssueTypes>>(
                                            (value) {
                                      return DropdownMenuItem<IssueTypes>(
                                        value: value,
                                        child: Text(value.name!,
                                            overflow: TextOverflow.visible),
                                      );
                                    }).toList(),
                                  ));
                            }),
                            const SizedBox(height: 16),
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return SizedBox(
                                  width: double.infinity,
                                  // height: 70,
                                  child: CommonDropdownButtonFormField<IssueTypes>(
                                    value: selectedComponent,
                                    label: "Component",
                                    onChanged: (IssueTypes? newValue) {
                                      setState(() {
                                        selectedComponent = newValue!;
                                      });
                                    },
                                    items: componentList
                                        .map<DropdownMenuItem<IssueTypes>>(
                                            (value) {
                                      return DropdownMenuItem<IssueTypes>(
                                        value: value,
                                        child: Text(value.name!,
                                            overflow: TextOverflow.visible),
                                      );
                                    }).toList(),
                                  ));
                            }),
                            const SizedBox(height: 16),
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return SizedBox(
                                  width: double.infinity,
                                  // height: 70,
                                  child: CommonDropdownButtonFormField<IssueTypes>(
                                    value: selectedSeverity,
                                    label: "Impact",
                                    onChanged: (IssueTypes? newValue) {
                                      setState(() {
                                        selectedSeverity = newValue!;
                                      });
                                    },
                                    items: severityList
                                        .map<DropdownMenuItem<IssueTypes>>(
                                            (value) {
                                      return DropdownMenuItem<IssueTypes>(
                                        value: value,
                                        child: Text(value.name!,
                                            overflow: TextOverflow.visible),
                                      );
                                    }).toList(),
                                  ));
                            }),
                            const SizedBox(height: 16),
                            CommonTextFormField(
                              maxLine: 4,
                              labeltxt: "Remarks",
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
                              controllerTxt: _remarkscontroller,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 100,
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBFBFB),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xFFDEDEDE)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Constant.cameraIc,
                                  ),
                                  CommonText(
                                    name: "Click here to upload image",
                                    fontSize: Constant.fontSize11,
                                    fontColor: Constant.colorBlack,
                                    fontWeight: Constant.fontWeight500,
                                  ),
                                ],
                              )),
                            ),
                          ],
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
                      buttonName: "Submit",
                      buttonNameSize: Constant.fontSize13,
                      buttonNameColor: Constant.pricbuttonTxtColor,
                      buttonColor: Constant.pricbuttonColor,
                      buttonHeight: 48,
                      buttonRadiusTL: Constant.pricbuttonRadiusTL,
                      buttonRadiusBL: Constant.pricbutRadiusBL,
                      buttonBorder: Colors.transparent,
                      buttonNameWeight: Constant.fontWeight500,
                      buttonFunction: () {
                        showConfirmDlg(context, "Confirm Support Request",
                            "Confirm Request");
                      },
                    ),
                  ),
                ],
              )),
        )));
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
      // titlePadding: const EdgeInsets.all(0),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportScreen()),
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

  contBody() {}
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
                    child: Text("Confirm Support Request",
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Are you whish to confirm \nsupport request",
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
                  if (selectedFeature == null) {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Select Feature from the list",
                        closeScreen: true);
                    return;
                  }
                  if (selectedComponent == null) {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Select Component from the list");
                    return;
                  }
                  if (selectedSeverity == null) {
                    showSuccessDlg(context, "Error", "Error",
                        successText: "Select Impact from the list");
                    return;
                  }
                  SupportRequest request = SupportRequest();
                  request.loginUserId = Constants.AUTH_USERID;
                  request.attachments = [];
                  request.componentId = selectedComponent!.id!;
                  request.impactId = selectedSeverity!.id!;
                  request.featureId = selectedFeature!.id!;
                  request.feature = selectedFeature!.name!;
                  request.description = _remarkscontroller.text.toString();
                  if (kDebugMode) {
                    GMLogger.v(jsonEncode(request));
                  }
                  BlocProvider.of<SupportBloc>(context)
                      .add(SaveSupport(request: request));
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
