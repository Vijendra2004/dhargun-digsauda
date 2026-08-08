import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/screen/aboutus/about_us.dart';
import 'package:adaniwilmar/screen/account_statement/AccountStatementScreen.dart';
import 'package:adaniwilmar/screen/gamificationDashboard/gamification_dashboard.dart';
import 'package:adaniwilmar/screen/more_screen/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constant.dart';
import '../../screen/screen.dart';
import '../../widget/widget.dart';
import '../tds_declaration_form/tds_form_page.dart';
import '../updates/update_detail.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const MoreScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreScreenBloc()
        ..add(GetFormApi())
        ..add(GetTanNumbrApi()),
      child: MoreMenu(),
    );
  }
}

class MoreMenu extends StatefulWidget {
  MoreMenu({Key? key}) : super(key: key);

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  _MoreMenuState();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ProgressBarHandler? _handler;
  bool onClickHelpMenu = false;
  bool loadAWLForms = true;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    double screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<MoreScreenBloc, MoreScreenState>(
        listener: (context, state) {
          if (state is ShowProgress) {
            _handler!.show!();
          }
          if (state is HideProgress) {
            _handler!.dismiss!();
          }
          if (state is FormPageSuccess) {
            if (Constants.AUTH_ROLEID == Constants.DEALER || (Constants.AUTH_ROLEID != Constants.DEALER && state.response.isNotEmpty)) {
              setState(() {
                loadAWLForms = true;
              });
            } else {
              setState(() {
                loadAWLForms = false;
              });
            }
            //tdsFormsList = state.response;
            setState(() {});
          }

          if (state is TanNumberSuccess) {
            GMLogger.v("tanNUmber---${state.response}");
            setState(() {
              _controller.text = state.response;
            });
          }

          if (state is TanNumberUpdateSuccess) {
            BlocProvider.of<MoreScreenBloc>(context).add(GetTanNumbrApi());
          }

          if (state is OnSuccessLoggedOut) {
            Constants.AUTH_TOKEN = "";
            Constants.AUTH_USERID = 0;
            Constants.AUTH_ROLEID = 0;
            Constants.AUTH_DEALER_CODE = "";
            Constants.AUTH_USER_NAME = "";
            Constants.AUTH_LAST_ACCESS_DATE = "";
            Navigator.popUntil(context, ModalRoute.withName('/login'));
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }
          // if (state is OnFailure) {
          //   showSuccessDlg(context, "Error", "Error", successText: state.error);
          // }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: "More", backArrow: true),
          body: Stack(
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  height: screenHeight,
                  width: screenWidth,
                  margin: const EdgeInsets.only(top: 50),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      CurveOuterBox(
                          boxofWidget: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListBody(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  //Need to check this page.
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdatesScreen()));*/

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UpdateDetailScreen()),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 9, bottom: 9),
                                  child: Row(children: [
                                    SizedBox(width: 18, height: 18, child: Constant.moreDialogIc1),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: Text(
                                      "Updates",
                                      style: TextStyle(fontSize: 13),
                                    ))
                                  ]),
                                )),
                            const BorderBottom(),
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                                  child: Row(children: [
                                    SizedBox(width: 18, height: 18, child: Constant.moreDialogIc2),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: Text(
                                      "About Us",
                                      style: TextStyle(fontSize: 13),
                                    ))
                                  ]),
                                )),
                            const BorderBottom(
                              bordeSize: 1,
                            ),
                            Visibility(
                              visible: Constants.DEALER == Constants.AUTH_ROLEID,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => StockListScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                                    child: Row(children: [
                                      SizedBox(width: 18, height: 18, child: Constant.stockImage),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                          child: Text(
                                            "Stock",
                                            style: TextStyle(fontSize: 13),
                                          ))
                                    ]),
                                  )),
                            ),
                            Visibility(
                              visible: Constants.DEALER == Constants.AUTH_ROLEID,
                              child: const BorderBottom(
                                bordeSize: 1,
                              ),
                            ),
                            Visibility(
                              visible: Constants.DEALER != Constants.AUTH_ROLEID,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StockReportScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                                    child: Row(children: [
                                      SizedBox(width: 18, height: 18, child: Constant.stockImage),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                          child: Text(
                                            "Stock Reports",
                                            style: TextStyle(fontSize: 13),
                                          ))
                                    ]),
                                  )),
                            ),
                            Visibility(
                              visible: Constants.DEALER != Constants.AUTH_ROLEID,
                              child: const BorderBottom(
                                bordeSize: 1,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                                  child: Row(children: [
                                    SizedBox(width: 18, height: 18, child: Constant.moreDialogIc3),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: Text(
                                      "Support",
                                      style: TextStyle(fontSize: 13),
                                    ))
                                  ]),
                                )),
                            const BorderBottom(
                              bordeSize: 1,
                            ),
                            Visibility(
                              visible: Constants.NHMANAGER != Constants.AUTH_ROLEID,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingContractScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                                    child: Row(children: [
                                      SizedBox(width: 18, height: 18, child: Constant.moreDialogIc4),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                          child: Text(
                                        "Pending Contract",
                                        style: TextStyle(fontSize: 13),
                                      ))
                                    ]),
                                  )),
                            ),
                            Visibility(
                                visible: Constants.NHMANAGER != Constants.AUTH_ROLEID,
                                child: const BorderBottom(
                                  bordeSize: 1,
                                )),
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                                  child: Row(children: [
                                    SizedBox(width: 18, height: 18, child: Constant.moreDialogIc5),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: Text(
                                      "Reports",
                                      style: TextStyle(fontSize: 13),
                                    ))
                                  ]),
                                )),
                            const BorderBottom(
                              bordeSize: 1,
                            ),
                            Visibility(
                                visible: loadAWLForms,
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        onClickHelpMenu = !onClickHelpMenu;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(children: [
                                          SizedBox(width: 18, height: 18, child: Constant.gamification),
                                          const SizedBox(width: 10),
                                          const Expanded(
                                              child: Text(
                                            "Self Help Menu",
                                            style: TextStyle(fontSize: 13),
                                          )),
                                          onClickHelpMenu == false ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up)
                                        ]),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: onClickHelpMenu == true && Constants.AUTH_ROLEID == Constants.DEALER,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20, top: 20, right: 5, bottom: 10),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GamificationDashboardScreen()));
                                                  },
                                                  child: const Row(
                                                    children: [Icon(Icons.circle_rounded, size: 10.0, color: Color(0xFFF68C33)), SizedBox(width: 10), Text("Gamification Dashboard")],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: onClickHelpMenu == true && Constants.AUTH_ROLEID == Constants.DEALER,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountStatementScreen()));
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.only(left: 20, top: 15, right: 5, bottom: 15),
                                                  child: Row(
                                                    children: [Icon(Icons.circle_rounded, size: 10.0, color: Color(0xFFF68C33)), SizedBox(width: 10), Text("Account Statement")],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: false,
                                              /*onClickHelpMenu ==
                                                          true &&
                                                      Constants.AUTH_ROLEID ==
                                                          Constants.DEALER,*/
                                              child: InkWell(
                                                child: const Padding(
                                                  padding: EdgeInsets.only(left: 20, top: 10, right: 5, bottom: 10),
                                                  child: Row(
                                                    children: [Icon(Icons.circle_rounded, size: 10.0, color: Color(0xFFF68C33)), SizedBox(width: 10), Text("TAN Number")],
                                                  ),
                                                ),
                                                onTap: () {
                                                  openTanNumberUpdateAlert(context);
                                                },
                                              ),
                                            ),
                                            Visibility(
                                              visible: onClickHelpMenu == true,
                                              child: InkWell(
                                                child: const Padding(
                                                  padding: EdgeInsets.only(left: 20, top: 15, right: 5, bottom: 10),
                                                  child: Row(
                                                    children: [Icon(Icons.circle_rounded, size: 10.0, color: Color(0xFFF68C33)), SizedBox(width: 10), Text("Dynamic Forms")],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TdsFormScreen()));
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                    ))),
                            const BorderBottom(
                              bordeSize: 1,
                            ),
                            Visibility(
                                visible: false,
                                // Constants.NHMANAGER != Constants.AUTH_ROLEID,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChequeStatusReport()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                                      child: Row(children: [
                                        SizedBox(width: 18, height: 18, child: Constant.moreDialogIc6),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                            child: Text(
                                          "Cheque Status Report",
                                          style: TextStyle(fontSize: 13),
                                        ))
                                      ]),
                                    ))),
                            Visibility(
                                visible: Constants.NHMANAGER != Constants.AUTH_ROLEID,
                                child: const BorderBottom(
                                  bordeSize: 1,
                                )),
                            InkWell(
                                onTap: () async {
                                  if (Constants.AUTH_ROLEID == Constants.SALE) {
                                    BlocProvider.of<MoreScreenBloc>(context).add(LogOutEvent(userId: Constants.AUTH_USERID));
                                  } else {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    Constants.AUTH_TOKEN = "";
                                    Constants.AUTH_USERID = 0;
                                    Constants.AUTH_ROLEID = 0;
                                    Constants.AUTH_DEALER_CODE = "";
                                    Constants.AUTH_USER_NAME = "";
                                    Constants.AUTH_LAST_ACCESS_DATE = "";
                                    prefs.setString("AUTH_TOKEN", Constants.AUTH_TOKEN);
                                    prefs.setInt("AUTH_USERID", Constants.AUTH_USERID);
                                    prefs.setInt("AUTH_ROLEID", Constants.AUTH_ROLEID);
                                    prefs.setString("AUTH_DEALER_CODE", Constants.AUTH_DEALER_CODE);
                                    prefs.setString("AUTH_USER_NAME", Constants.AUTH_USER_NAME);
                                    prefs.setString("LAST_ALIVE_TIME", "");
                                    prefs.setString("AUTH_LAST_ACCESS_DATE", Constants.AUTH_LAST_ACCESS_DATE);
                                    Navigator.popUntil(context, ModalRoute.withName('/login'));
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                                  child: Row(children: [
                                    SizedBox(width: 18, height: 18, child: Constant.moreDialogIc7),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                        child: Text(
                                      "Log Out",
                                      style: TextStyle(fontSize: 13),
                                    ))
                                  ]),
                                )),
                          ],
                        ),
                      ))
                    ]),
                  )),
              progressBar
            ],
          ),
          // bottomNavigationBar: CustomNavBar(
          //   selectedIndex: 5,
          // ),
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
                  //to be commented
                  // Constants.AUTH_TOKEN = "";
                  // Constants.AUTH_USERID = 0;
                  // Constants.AUTH_ROLEID = 0;
                  // Constants.AUTH_DEALER_CODE = "";
                  // Constants.AUTH_USER_NAME = "";
                  // Constants.AUTH_LAST_ACCESS_DATE = "";
                  // Navigator.popUntil(context, ModalRoute.withName('/login'));
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LoginScreen()));
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

  void openTanNumberUpdateAlert(BuildContext context) {
    final RegExp _regex = RegExp(r'^[A-Z]{4}[0-9]{5}[A-Z]{1}$');

    showModalBottomSheet(
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (buildContext) {
        return SizedBox(
            child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text("Update TAN Number",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Aganè',
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: TextFormField(
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                    ],
                    controller: _controller,
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: Constant.fontWeight400),
                    decoration: const InputDecoration(
                      hintText: "Ex: XXXX00000Z",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          if (_regex.hasMatch(_controller.text)) {
                            OpenAreYouSureAlert(buildContext, context);
                          } else {
                            _showAlertDialog(buildContext, "Invalid TAN Number");
                          }
                        } else {
                          _showAlertDialog(buildContext, "Please enter the TAN Number");
                        }
                      },
                      child: const Text("Update")),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  void _showAlertDialog(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(s),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Add functionality for the "OK" button
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void OpenAreYouSureAlert(BuildContext context, BuildContext b_context) {
    AlertDialog alert = AlertDialog(
      // insetPadding: EdgeInsets.only(left: 20, right: 20),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Icon(Icons.error_outlined, size: 54, color: Constant.homeBoxPendingOrange),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('Update TAN Number', style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
                  ),
                  const SizedBox(height: 8),
                  Text('Do you want to update the TAN number?',
                      style: TextStyle(
                        fontSize: Constant.fontSize14,
                      )),
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
                  //Navigator.pop(b_context);
                }),
            CommonButton(
                buttonName: "Yes",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  BlocProvider.of<MoreScreenBloc>(b_context).add(TanNumberUpdate(_controller.text));
                  Navigator.pop(b_context);
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
