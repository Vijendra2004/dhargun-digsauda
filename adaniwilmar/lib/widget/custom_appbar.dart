import 'package:flutter/material.dart';
import '../config/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool backArrow;
  final Widget? listOfActions;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.backArrow = false,
      this.listOfActions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return SafeArea(
      child: Container(
        height: 60,
        color: const Color(0x75ffffff),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              automaticallyImplyLeading: backArrow,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(title!,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: Constant.fontWeight600,
                      fontSize: Constant.fontSize18,
                      color: Constant.colorBlack)),
              iconTheme: const IconThemeData(color: Colors.black),
              actions: listOfActions != null ? [listOfActions!] : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}
