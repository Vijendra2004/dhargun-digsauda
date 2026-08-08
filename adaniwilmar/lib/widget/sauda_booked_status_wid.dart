import 'package:flutter/material.dart';

import '../config/constant.dart';
import '../screen/screen.dart';
import 'widget.dart';

class SaudaBookedStatusWid extends StatelessWidget {
  const SaudaBookedStatusWid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpecialRateApprovalNext(
                          dealerId: 0,
                          specialRateId: 0,
                        )));
          },
          child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 13,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 4.0),
                                const SizedBox(width: 2),
                                Text(
                                  "01 Apr 2018",
                                  style: TextStyle(
                                      fontSize: Constant.fontSize13,
                                      color: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight500),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: CommonLabel(
                            bgColor: Constant.booSauStacolor,
                            name: "Accepted",
                            fontSize: Constant.fontSize11,
                            fontColor: Constant.colorWhite,
                            imageic: Constant.checkIc,
                            imagetrue: true,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.8, color: Color(0x13000000)),
                    ),
                  )),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, right: 8, left: 8),
                        decoration: BoxDecoration(
                          color: Constant.colorWhite,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Palm Oil (2 SKU’s)",
                          style: TextStyle(
                              fontSize: Constant.fontSize11,
                              color: Constant.colorBlack),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, right: 8, left: 8),
                        decoration: BoxDecoration(
                          color: Constant.colorWhite,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Palm Oil (2 SKU’s)",
                          style: TextStyle(
                              fontSize: Constant.fontSize11,
                              color: Constant.colorBlack),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
        const SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month,
                                size: 13, color: Colors.orange),
                            const SizedBox(width: 4.0),
                            const SizedBox(width: 2),
                            Text(
                              "01 Apr 2018",
                              style: TextStyle(
                                  fontSize: Constant.fontSize13,
                                  color: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: CommonLabel(
                        bgColor: Constant.colorRed,
                        name: "Rejected",
                        fontSize: Constant.fontSize11,
                        fontColor: Constant.colorWhite,
                        imageic: Constant.closeIc,
                        imagetrue: true,
                      ))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.8, color: Color(0x13000000)),
                ),
              )),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 8, left: 8),
                    decoration: BoxDecoration(
                      color: Constant.colorWhite,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Palm Oil (2 SKU’s)",
                      style: TextStyle(
                          fontSize: Constant.fontSize11,
                          color: Constant.colorBlack),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 8, left: 8),
                    decoration: BoxDecoration(
                      color: Constant.colorWhite,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Palm Oil (2 SKU’s)",
                      style: TextStyle(
                          fontSize: Constant.fontSize11,
                          color: Constant.colorBlack),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
