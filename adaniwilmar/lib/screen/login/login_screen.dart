import 'package:adaniwilmar/screen/home.dart';
import 'package:adaniwilmar/screen/login/bloc/bloc.dart';
import 'package:adaniwilmar/screen/login/forgot_password_screen.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_device/safe_device.dart';

import '../../config/constant.dart';
import '../../utils/constant.dart';
import '../../widget/widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Login(),
    );
  }
}

class Login extends StatefulWidget {
  Login({this.selectedIndex = 0, Key? key}) : super(key: key);
  int selectedIndex = 0;

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> with SingleTickerProviderStateMixin {
  _LoginPageState();

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  ProgressBarHandler? _handler;

  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    //checkRoot();

    ///For checking purpose
//     National Trader - 8884413500/Password
//     9099090739
    //     Zonal Trader - 9925005891/Password
//
//     State Trader - 9265802627/Password
//     7777981908
//    9993668038/ Adani@2024
//   live state trader
//     userName.text = "9874300856";
//     password.text = "Muskan786ali";

    // userName.text = "8460479446";
    // password.text = "Feb@2023";
//
    //     Distributor - 9428161283/Password. And 9413309972/ Password: 9414376309 and 4056-320/Password: 9414376309
//     & 9448193271/Password & 9845908099/Password & 9448068892 /Password & 9437070819/Password

    // live
    // 9100101770/Satya@123

    if (kDebugMode) {
      // live
      // userName.text = "9763767575";
      // password.text = "liverpool1460";
      // password.text = "Password";

      // userName.text = "9265802627";
      // password.text = "Password";

      // userName.text = "9428161283";
      // password.text = "Password";

      //Distributor
      // userName.text = "9925049540";
      // password.text = "Password";

      //   live state trader
      // userName.text = "7777981908";
      // password.text = "Password";

      userName.text = "9925005891";
      password.text = "Password";
    }
    super.initState();
  }

  Future<bool> isDeviceCompromised() async {
    bool isRooted = await SafeDevice.isJailBroken;
    bool isEmulator = await SafeDevice.isRealDevice == false;

    return isRooted || isEmulator;
  }

  void checkRoot() async {
    if (await isDeviceCompromised()) {
      showErrorDialog(
          "Security Alert", "For security reasons, this application does not support rooted or jailbroken devices.");
    } else if (await SafeDevice.isDevelopmentModeEnable) {
      showErrorDialog("Security Alert",
          "For security reasons, this application does not support devices with Developer Mode enabled. Please disable Developer Mode in your settings to proceed.");
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text("Exit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is OnSuccess) {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePageNew()));
          }
          if (state is OnFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid Login Credentials")));
            //showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(child: Constant.loginImgBg),
                          Container(child: Constant.loginLogoImg),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 14),
                                  // CommonText(
                                  //   name: "URL ",
                                  //   fontColor: Constant.colorBlack,
                                  //   fontSize: Constant.fontSize16,
                                  //   fontWeight: Constant.fontWeight600,
                                  // ),
                                  Visibility(
                                    visible: false,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0,
                                          top: 5,
                                          bottom: 15,
                                          right: 0),
                                      child: TextFormField(
                                        controller: _urlController,
                                        onChanged: (String value) {},
                                        decoration: InputDecoration(
                                            hintText: "Enter ngrok URL here",
                                            labelStyle: TextStyle(
                                                color:
                                                    Constant.textFormFieldColor,
                                                fontSize:
                                                    Constant.textFormFieldSize,
                                                fontWeight: Constant
                                                    .textFormFieldSizeFontW),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: Constant
                                                        .textFormFocuBorWid!),
                                                borderRadius: const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    bottomLeft:
                                                        Radius.circular(4.0))),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: Constant
                                                        .textFormEnaBorWid!),
                                                borderRadius: const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    bottomLeft:
                                                        Radius.circular(4.0))),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  bottomLeft:
                                                      Radius.circular(4.0)),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(horizontal: Constant.textFormcontentPadHor!, vertical: Constant.textFormcontentPadHVer!)),
                                        onSaved: (String? value) {},
                                      ),
                                    ),
                                  ),
                                  CommonText(
                                    name: "Sign In",
                                    fontColor: Constant.colorBlack,
                                    fontSize: Constant.fontSize16,
                                    fontWeight: Constant.fontWeight600,
                                  ),
                                  const SizedBox(height: 12),
                                  CustomTextFromField(
                                    textLabl: "Username",
                                    controller: userName,
                                    keyborType: TextInputType.number,
                                    fontSize: Constant.fontSize14,
                                    fontWeight: Constant.fontWeight500,
                                    sufIcon: Constant.loginUserIc,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextFromField(
                                    textLabl: "Password",
                                    controller: password,
                                    keyborType: TextInputType.text,
                                    fontSize: Constant.fontSize16,
                                    fontWeight: Constant.fontWeight500,
                                    password: true,
                                    sufIcon: Constant.loginLockIc,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle: TextStyle(
                                            fontSize: Constant.fontSize11,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForgotPasswordScreen()));
                                      },
                                      child: const Text(
                                          Constants.forgotPassword,
                                          style: TextStyle(
                                              color: Color(0XFF00968b))),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: screenWidth / 1 - 67,
                                    child: CommonButton(
                                        buttonName: "GO",
                                        buttonNameWeight:
                                            Constant.fontWeight600,
                                        buttonNameSize: Constant.fontSize14,
                                        buttonNameColor:
                                            Constant.pricbuttonTxtColor,
                                        buttonColor: Constant.pricbuttonColor,
                                        buttonHeight: Constant.pricbuttonHeight,
                                        buttonRadiusTL:
                                            Constant.pricbuttonRadiusTL,
                                        buttonRadiusBL:
                                            Constant.pricbutRadiusBL,
                                        buttonBorder: Colors.transparent,
                                        buttonFunction: () {
                                          if (userName.text.toString().trim() ==
                                              "") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Enter Valid Mobile Number")));
                                            return;
                                          }
                                          if (password.text.toString().trim() ==
                                              "") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Invalid Login Credentials")));
                                            return;
                                          }
                                          if (_urlController.text.isNotEmpty) {
                                            // Constants.BaseUrlDev = _urlController.text.toString();
                                            // Constants.BaseUrlTest = _urlController.text.toString();
                                            // Constants.BaseUrlRelease = _urlController.text.toString();
                                          }
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(LoginButtonPressed(
                                                  verticalId: 1,
                                                  isRequestFromWeb: false,
                                                  password:
                                                      password.text.toString(),
                                                  mobileNumber:
                                                      userName.text.toString(),
                                                  email: ""));
                                        }),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 16),
                                        child: Constant.loginGroupLogo),
                                  ),
                                ]),
                          )

                          //SizedBox(height: 420)
                        ],
                      ),
                    )),
              ),
              progressBar
            ],
          ),
        ));
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white,
      bool? closeScreen = false}) {
    // set up the button
    // set up the AlertDialog
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
      title: const SizedBox.shrink(),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
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
