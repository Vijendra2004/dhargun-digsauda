import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/constant.dart';
import 'common_text.dart';
import 'widget.dart';

class CustomNavBar extends StatefulWidget {
  int selectedIndex = -1;
  CustomNavBar({this.selectedIndex = -1, Key? key}) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int? _selectedIndex;
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectedIndex != -1) {
      _selectedIndex = widget.selectedIndex;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 30,
      color: Colors.white,
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                //onTabTapped(1);
                setState(() {
                  _selectedIndex = 1;
                });
                // Navigator.popUntil(context, ModalRoute.withName('/home'));
                Navigator.pushNamed(context, '/home');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      _selectedIndex == 1
                          ? "assets/images/HomeON.svg"
                          : "assets/images/HomeOFF.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  CommonText(
                    name: "Home",
                    fontColor: Constant.colorBlack,
                    fontSize: Constant.fontSize12,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // onTabTapped(2);
                setState(() {
                  _selectedIndex = 2;
                });
                // Navigator.popUntil(context, ModalRoute.withName('/home'));
                Navigator.pushNamed(context, '/sauda');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      _selectedIndex == 2
                          ? "assets/images/SaudaON.svg"
                          : "assets/images/SaudaOFF.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  CommonText(
                    name: "Sauda",
                    fontColor: Constant.colorDullGray77,
                    fontSize: Constant.fontSize12,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                // Navigator.popUntil(context, ModalRoute.withName('/home'));
                Navigator.pushNamed(context, '/sales');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      _selectedIndex == 3
                          ? "assets/images/SalesON.svg"
                          : "assets/images/SalesOFF.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  CommonText(
                    name: "Sales",
                    fontColor: Constant.colorDullGray77,
                    fontSize: Constant.fontSize12,
                  )
                ],
              ),
            ),
            Visibility(visible:Constants.AUTH_ROLEID!=Constants.DEALER,child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                // Navigator.popUntil(context, ModalRoute.withName('/home'));
                Navigator.pushNamed(context, '/stp');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      _selectedIndex == 4
                          ? "assets/images/STPON.svg"
                          : "assets/images/STPOFF.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  CommonText(
                    name: "STP",
                    fontColor: Constant.colorDullGray77,
                    fontSize: Constant.fontSize12,
                  )
                ],
              ),
            )),
            InkWell(
              onTap: () {
                // onTabTapped(5);
                setState(() {
                  _selectedIndex = 5;
                });
                // Navigator.popUntil(context, ModalRoute.withName('/home'));
                Navigator.pushNamed(context, '/more');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      _selectedIndex == 5
                          ? "assets/images/MoreON.svg"
                          : "assets/images/MoreOFF.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  CommonText(
                    name: "More",
                    fontColor: Constant.colorDullGray77,
                    fontSize: Constant.fontSize12,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
