import 'package:adaniwilmar/screen/login/bloc/bloc.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const ForgotPasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: ForgotPassword(),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  ForgotPassword({this.selectedIndex = 0, Key? key}) : super(key: key);
  int selectedIndex = 0;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPassword> with SingleTickerProviderStateMixin {
  _ForgotPasswordPageState();

  TextEditingController userName = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool otpSent = false;
  int userId = 0;
  ProgressBarHandler? _handler;

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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your password changed successfully.")));
            Navigator.pop(context);
          }
          if (state is OnOTPSuccess) {
            otpSent = true;
            if (state.userId != 0) {
              userId = state.userId;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP has been sent to your registered mobile number/email")));
            }
            setState(() {});
          }
          if (state is OnFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
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
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: 14),
                              // CommonText(
                              //   name: "Sign In",
                              //   fontColor: Constant.colorBlack,
                              //   fontSize: Constant.fontSize16,
                              //   fontWeight: Constant.fontWeight600,
                              // ),
                              const SizedBox(height: 12),
                              CustomTextFromField(
                                maxLength: 10,
                                textLabl: "Registered Mobile No.",
                                controller: userName,
                                keyborType: TextInputType.number,
                                fontSize: Constant.fontSize14,
                                fontWeight: Constant.fontWeight500,
                                sufIcon: Constant.loginUserIc,
                              ),
                              const SizedBox(height: 8),
                              Visibility(
                                  visible: otpSent,
                                  child: Column(children: [
                                    CustomTextFromField(
                                      maxLength: 6,
                                      textLabl: "Enter OTP",
                                      controller: otp,
                                      keyborType: TextInputType.number,
                                      fontSize: Constant.fontSize16,
                                      fontWeight: Constant.fontWeight500,
                                      password: false,
                                      sufIcon: Constant.loginLockIc,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(16.0),
                                          textStyle: TextStyle(fontSize: Constant.fontSize11, decoration: TextDecoration.underline),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<LoginBloc>(context).add(ResendForgotPassordOTP(userId: userId));
                                        },
                                        child: const Text('Resend OTP'),
                                      ),
                                    ),
                                    CustomTextFromField(
                                      textLabl: "New Password",
                                      controller: password,
                                      keyborType: TextInputType.text,
                                      fontSize: Constant.fontSize16,
                                      fontWeight: Constant.fontWeight500,
                                      password: true,
                                      sufIcon: Constant.loginLockIc,
                                    ),
                                    CustomTextFromField(
                                      textLabl: "Confirm Password",
                                      controller: confirmPassword,
                                      keyborType: TextInputType.text,
                                      fontSize: Constant.fontSize16,
                                      fontWeight: Constant.fontWeight500,
                                      password: true,
                                      sufIcon: Constant.loginLockIc,
                                    ),
                                  ])),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: screenWidth / 1 - 67,
                                child: CommonButton(
                                    buttonName: otpSent ? "Submit" : "Get OTP",
                                    buttonNameWeight: Constant.fontWeight600,
                                    buttonNameSize: Constant.fontSize14,
                                    buttonNameColor: Constant.pricbuttonTxtColor,
                                    buttonColor: Constant.pricbuttonColor,
                                    buttonHeight: Constant.pricbuttonHeight,
                                    buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                    buttonRadiusBL: Constant.pricbutRadiusBL,
                                    buttonBorder: Colors.transparent,
                                    buttonFunction: () {
                                      if (!otpSent) {
                                        if (userName.text.toString().trim() == "") {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Valid Mobile Number")));
                                          // showSuccessDlg(
                                          //     context, "Error", "Error",
                                          //     successText: "Enter user name");
                                          return;
                                        }
                                      } else {
                                        if (otp.text.toString().trim() == "") {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Valid OTP")));
                                          // showSuccessDlg(
                                          //     context, "Error", "Error",
                                          //     successText: "Enter password");
                                          return;
                                        }
                                        if (password.text.toString().trim() == "") {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Password")));
                                          // showSuccessDlg(
                                          //     context, "Error", "Error",
                                          //     successText: "Enter password");
                                          return;
                                        }
                                        if (confirmPassword.text.toString().trim() == "") {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Confirm Password")));
                                          // showSuccessDlg(
                                          //     context, "Error", "Error",
                                          //     successText: "Enter password");
                                          return;
                                        }
                                        if (confirmPassword.text.toString().trim() != password.text.toString().trim()) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password and Confirm Password should be same")));
                                          // showSuccessDlg(
                                          //     context, "Error", "Error",
                                          //     successText: "Enter password");
                                          return;
                                        }
                                      }
                                      if (!otpSent) {
                                        BlocProvider.of<LoginBloc>(context).add(ForgotPassordOTP(mobileNumber: userName.text.toString()));
                                      } else {
                                        BlocProvider.of<LoginBloc>(context).add(ForgotPasswordSubmit(userId: userId, password: password.text.toString(), otpNumber: otp.text.toString()));
                                      }
                                    }),
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

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white, bool? closeScreen = false}) {
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
      content:  SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error" ? const Icon(Icons.error_outlined, size: 70, color: Colors.red) : const Icon(Icons.check_circle_sharp, size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title!, style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
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
