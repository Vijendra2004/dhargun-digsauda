import 'package:flutter/material.dart';

import '../config/constant.dart';
import 'widget.dart';

class SaudaConversionWid extends StatelessWidget {
  const SaudaConversionWid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "sdfsd",
                      style: TextStyle(
                          fontSize: Constant.fontSize14,
                          color: Constant.colorBlack,
                          fontWeight: Constant.fontWeight500),
                    ),
                  ],
                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      CommonLabel(
                        bgColor: Constant.booSauStacolor,
                        name: "Accepted",
                        fontSize: Constant.fontSize11,
                        fontColor: Constant.colorWhite,
                        imageic: Constant.checkIc,
                        imagetrue: true,
                      )
                    ],
                  ),
                )
              ],
            )),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From SKU",
                    style: TextStyle(
                        fontSize: Constant.fontSize12,
                        color: Constant.colorBlack),
                  ),
                  Text(
                    "Palm 15 kg Tin(New)",
                    style: TextStyle(
                        fontSize: Constant.fontSize12,
                        color: Constant.colorBlack,
                        fontWeight: Constant.fontWeight500),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From SKU",
                    style: TextStyle(
                        fontSize: Constant.fontSize12,
                        color: Constant.colorBlack),
                  ),
                  Text(
                    "Palm 15 kg Tin(New)",
                    style: TextStyle(
                        fontSize: Constant.fontSize12,
                        color: Constant.colorBlack,
                        fontWeight: Constant.fontWeight500),
                  )
                ],
              )),
            ],
          ),
        )
      ],
    );
  }
}
