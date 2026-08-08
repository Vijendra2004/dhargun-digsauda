import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Color? buttonBgColor;
  final Function? navigationFunction;
  final IconData? buttonIcon;
  final double? buttoniconSize;

  const FloatingButton(
      {Key? key,
      this.buttonBgColor,
      this.buttonIcon,
      this.navigationFunction,
      this.buttoniconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        navigationFunction!();
      },
      backgroundColor: buttonBgColor,
      child: Icon(
        Icons.add,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}
