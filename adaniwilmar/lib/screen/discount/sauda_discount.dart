import 'package:adaniwilmar/screen/discount/user_discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../models/list_of_discount.dart';
import '../../utils/constant.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';
import '../pending_sauda/bloc/pending_sauda_bloc.dart';
import 'assigned_discount.dart';
import 'create_discount_screen.dart';
import 'create_geography_discount.dart';
import 'geography_discount.dart';

class DiscountScreen extends StatelessWidget {
  static const String routeName = '/discount';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const DiscountScreen());
  }

  const DiscountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingSaudaBloc(),
      child: Discount(),
    );
  }
}

class Discount extends StatefulWidget {
  const Discount({Key? key}) : super(key: key);

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int discountTypeLength = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;

    List<ListOFDiscountModel> list = [];

    switch (Constants.AUTH_ROLEID) {
      case Constants.NHMANAGER:
        list = ListOFDiscountModel.nList;
        break;
      case Constants.ZHMANAGER:
        list = ListOFDiscountModel.zsList;
        break;
      case Constants.SALE:
        list = ListOFDiscountModel.zsList;
        break;
    }

    return SafeArea(
      child: Scaffold(
        primary: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Sauda Discount", backArrow: true),
        body: Stack(
          // clipBehavior: Clip.none,
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              child: Container(
                child: Constant.bgImgGlobal,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60, right: 10, left: 10),
              height: screenHeight * 0.980,
              width: screenWidth,
              child: CurveBorderBox(
                boxLRPadding: 8,
                boxTOPPadding: 0,
                boxBOTPadding: 0,
                boxofWidget: SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Visibility(
                              visible: true,
                              child: InkWell(
                                onTap: () {
                                  if(Constants.AUTH_ROLEID == Constants.NHMANAGER){
                                    if (0 == index) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                              GeographyDiscountScreen()),
                                      );
                                    } else if (1 == index) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const UserDiscountScreen()),
                                      );
                                    }
                                  }
                                  else{
                                    if (0 == index) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GeographyDiscountScreen()),
                                      );
                                    } else if (1 == index) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const AssignedDiscountScreen()),
                                      );
                                    }
                                  }
                                  // if (0 == index) {
                                  //   // Navigator.push(
                                  //   //   context,
                                  //   //   MaterialPageRoute(
                                  //   //       builder: (context) =>
                                  //   //       const  GeographyDiscount()),
                                  //   // );
                                  // } else if (1 == index) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const UserDiscountScreen()),
                                  //   );
                                  // } else if (2 == index) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const AssignedDiscountScreen()),
                                  //   );
                                  // }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 8, top: 5),
                                  height: 67.0,
                                  // padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(25.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x18000000),
                                        offset: Offset(
                                          2.0,
                                          1.0,
                                        ),
                                        blurRadius: 3.0,
                                        spreadRadius: 2.0,
                                      ),
                                      //BoxShadow
                                    ],
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.only(
                                        top: 8, left: 16, right: 16),
                                    title: Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: screenWidth * 0.60,
                                          child: Text(
                                            list[index].name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Constant.fontSize16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Constant.rightArow,
                                  ), //BoxDecoration
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
