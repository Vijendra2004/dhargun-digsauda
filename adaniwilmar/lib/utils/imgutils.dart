import 'package:flutter/material.dart';
// import 'package:adaniwilmar/theme/images.dart';

// ignore: must_be_immutable
class LoginPageImage extends StatelessWidget {
  String title;

  LoginPageImage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 7,
        width: MediaQuery.of(context).size.width / 3.0,
        decoration: const BoxDecoration(),
        child: title == "register" ? const Text("") : const Text("")
        // ? Image.asset(
        //     ImageData.otp_img,
        //     // height: MediaQuery.of(context).size.height / 8,
        //   )
        // : Image.asset(
        //     ImageData.loginLogoImgPath,
        //   ),
        // child: Image.asset(ImageData.loginLogoImgPath,height: 120.0,width: 120.0)
        );
  }
}

class NotificationAppBarImage extends StatelessWidget {
  const NotificationAppBarImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("");
  }
}
