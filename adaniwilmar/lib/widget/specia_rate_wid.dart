import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/widget/common_text.dart';
import 'package:flutter/material.dart';

import '../config/constant.dart';

class SpecialRateWid extends StatelessWidget {
  SpecialRateSkuDetail skuDetail = SpecialRateSkuDetail();
  SpecialRateWid({required this.skuDetail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
              color: const Color(0xFFffffff),
              borderRadius: const BorderRadius.only(
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          CommonText(
                            name: skuDetail.skuName!,
                            fontColor: Constant.colorBlack,
                            fontSize: Constant.fontSize14,
                            fontWeight: Constant.fontWeight600,
                          ),
                          CommonText(
                            name: skuDetail.plantName != null
                                ? skuDetail.plantName!
                                : "",
                            fontColor: Constant.colorDullGray77,
                            fontSize: Constant.fontSize12,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: CommonText(
                          name: skuDetail.quantityCase!.toStringAsFixed(2),
                          fontSize: Constant.fontSize13,
                          fontColor: Constant.colorOrange,
                        ))
                  ],
                ),
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(
                        color: Color(0xFFD5D5D5),
                        width: 0.8,
                      ),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 0, right: 0, bottom: 0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Final Rate Amount",
                                style: TextStyle(
                                    fontSize: Constant.fontSize12,
                                    color: Constant.colorBlack),
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  Text(
                                      'Rs. ' +
                                          skuDetail.finalPrice!
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Constant.colorBlack,
                                          fontSize: Constant.fontSize16,
                                          fontWeight: FontWeight.bold)),
                                  Text('',
                                      style: TextStyle(
                                          color: Constant.colorDullGray77,
                                          fontSize: Constant.fontSize13,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Special Rate Amount",
                                style: TextStyle(
                                    fontSize: Constant.fontSize12,
                                    color: Constant.colorBlack),
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  Text(
                                      'Rs. ' +
                                          skuDetail.specialPrice!
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Constant.colorGreencc,
                                          fontSize: Constant.fontSize16,
                                          fontWeight: FontWeight.bold)),
                                  Text('',
                                      style: TextStyle(
                                          color: Constant.colorDullGray77,
                                          fontSize: Constant.fontSize13,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    ))
              ],
            )),
        const SizedBox(height: 24)
      ],
    );
  }
}
