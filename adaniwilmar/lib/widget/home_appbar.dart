import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/constant.dart';

class HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppbar({Key? key}) : super(key: key);
  int selectedIndex = 0;

  @override
  State<HomeAppbar> createState() => _HomeAppbar();

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}

class _HomeAppbar extends State<HomeAppbar> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return SafeArea(
      child: Container(
        height: 60,
        color: const Color(0x75ffffff),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Constant.homeUserIc,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Constants.AUTH_USER_NAME,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500,
                                      fontSize: Constant.fontSize13,
                                    ),
                          ),
                          Text(
                            Constants.AUTH_LAST_ACCESS_DATE,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Constant.colorGray75,
                                      fontSize: Constant.fontSize12,
                                    ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              actions: [
                Constants.NOTIFICATION_RECD
                    ? IconButton(
                        onPressed: () {},
                        icon: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.all(2),
                            child: new Stack(children: <Widget>[
                              Container(
                                  width: 30.0,
                                  height: 30.0,
                                  child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Constant.bellIconNot)),
                              new Positioned(
                                // draw a red marble
                                top: 0.0,
                                right: 2,
                                child: new Icon(Icons.brightness_1,
                                    size: 12.0, color: Colors.orange),
                              )
                            ]),
                          ),
                        ))
                    : IconButton(
                        onPressed: () {},
                        icon: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.all(2),
                            child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Constant.bellIconNot),
                          ),
                        ),
                      ),
                //Container(width: 15, height: 12, child: Constant.homeBellIc),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
