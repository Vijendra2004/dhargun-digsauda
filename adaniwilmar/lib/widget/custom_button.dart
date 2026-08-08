import 'package:adaniwilmar/screen/home_screen_1.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: const Color(0xFFE71928),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: const Text("Go"),
    );
  }
}
