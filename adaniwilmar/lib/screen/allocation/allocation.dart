import 'package:adaniwilmar/screen/allocation/new_quantity_allocation.dart';
import 'package:adaniwilmar/screen/allocation/update_quantity_limit.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';
import '../quantity_allocation_tab_screen/quantity_allocation_tab.dart';
import '../request_quantity_tab_screen/request_quantity_tab.dart';

class AllocationScreen extends StatelessWidget {
  const AllocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height + (58) - MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      primary: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Allocation", backArrow: true),
      floatingActionButton: Visibility(
          visible: false,
          child: FloatingButton(
              buttonBgColor: Constant.colorRed,
              buttonIcon: Constant.saudaIcPlus,
              navigationFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewQuantityAllocationScreen()),
                );
              },
              buttoniconSize: 20)),
          body: Stack(
            // overflow: Overflow.visible,
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
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Visibility(
                                visible: false,
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateQuantityLimitScreen(
                                            isAssignedQuantity: false,
                                          )),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.only(
                                          right: 14,
                                          top: 14,
                                          bottom: 14,
                                        ),
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
                                              color: Color(0x25000000),
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 20,
                                              color: Constant.callToCcolor1,
                                              margin: const EdgeInsets.only(top: 3),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      name: "Update Quantity Limit",
                                                      fontSize: Constant.fontSize13,
                                                      fontColor: Constant.colorBlack,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                  ],
                                                )),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 24,
                                                color: Constant.colorGray45,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const QuantityAllocationTabScreen()),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.only(
                                      right: 14,
                                      top: 14,
                                      bottom: 14,
                                    ),
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
                                          color: Color(0x25000000),
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 3,
                                          height: 20,
                                          color: Constant.callToCcolor1,
                                          margin: const EdgeInsets.only(top: 3),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name: "Quantity Allocation",
                                                  fontSize: Constant.fontSize13,
                                                  fontColor: Constant.colorBlack,
                                                  fontWeight: Constant.fontWeight500,
                                                ),
                                              ],
                                            )),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 24,
                                            color: Constant.colorGray45,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RequestQuantityTabScreen()),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.only(
                                      right: 14,
                                      top: 14,
                                      bottom: 14,
                                    ),
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
                                          color: Color(0x25000000),
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 3,
                                          height: 20,
                                          color: Constant.callToCcolor1,
                                          margin: const EdgeInsets.only(top: 3),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CommonText(
                                                  name: "Request Quantity",
                                                  fontSize: Constant.fontSize13,
                                                  fontColor: Constant.colorBlack,
                                                  fontWeight: Constant.fontWeight500,
                                                ),
                                              ],
                                            )),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 24,
                                            color: Constant.colorGray45,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                )),
            // child: CurveBorderBox(
            //   boxLRPadding: 8,
            //   boxTOPPadding: 0,
            //   boxBOTPadding: 0,
            //   boxofWidget: SizedBox(
            //     height: screenHeight,
            //     width: screenWidth,
            //     child:
            //   )
            //   )
          )
        ],
      ),
    ));
  }
}
