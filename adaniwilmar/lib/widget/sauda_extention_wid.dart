import 'package:adaniwilmar/models/sauda_extension_list.dart';
import 'package:adaniwilmar/screen/saudu_number/sauda_number.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../config/constant.dart';

class SaudaExtensionWid extends StatelessWidget {
  List<SaudaBookedSaudaWithExtensionDetails> sauda;
  SaudaExtensionWid({required this.sauda, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sauda.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SaudaNumber(sauda: sauda[index],isApproved:false ,)));
            },
            child: Column(
              children: [
                Visibility(
                    visible: Constants.SALE != Constants.AUTH_ROLEID,
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 9, bottom: 9),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sauda[index].bdoName ?? "",
                              style: TextStyle(
                                  fontSize: Constant.fontSize14,
                                  color: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.orangeAccent,
                                  size: 13.0,
                                ),
                                const SizedBox(width: 4.0),
                                Text(sauda[index].bdoAddress ?? "",
                                    style: TextStyle(
                                      fontSize: Constant.fontSize12,
                                      color: Constant.colorLightGray,
                                    ))
                              ],
                            )
                          ],
                        ))),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 12, right: 12, bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sauda No:\t",
                            style: TextStyle(
                                fontSize: Constant.fontSize12,
                                color: Constant.colorGray45),
                          ),
                          Text(sauda[index].saudaNumber!,
                              style: TextStyle(
                                  fontSize: Constant.fontSize12,
                                  color: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Constant.saExColorRed,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              )),
                          Expanded(
                              child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 3.0,
                            dashColor: Color(0x13000000),
                            dashRadius: 0.0,
                            dashGapLength: 3.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          )),
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Constant.colorOrange,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              )),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateTimeUtils().dateToServerToDateFormat(
                                        sauda[index].saudaValidFromDate!,
                                        DateTimeUtils.YYYY_MM_DD_Format,
                                        DateTimeUtils.DD_MMM_Format),
                                    style: TextStyle(
                                        fontSize: Constant.fontSize14,
                                        color: Constant.colorBlack,
                                        fontWeight: Constant.fontWeight600),
                                  ),
                                  Text(
                                    DateTimeUtils().dateToServerToDateFormat(
                                        sauda[index].saudaValidFromDate!,
                                        DateTimeUtils.YYYY_MM_DD_Format,
                                        DateTimeUtils.YYYY_Format),
                                    style: TextStyle(
                                        fontSize: Constant.fontSize13,
                                        color: Constant.colorGray75),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                sauda[index].saudaExtendedDays.toString() +
                                    " Day",
                                style: TextStyle(
                                    fontSize: Constant.fontSize14,
                                    fontWeight: Constant.fontWeight600,
                                    color: Constant.colorOrange),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateTimeUtils().dateToServerToDateFormat(
                                        sauda[index].saudaExtendedToDate == null
                                            ? sauda[index].saudaValidToDate!
                                            : sauda[index].saudaExtendedToDate!,
                                        DateTimeUtils.YYYY_MM_DD_Format,
                                        DateTimeUtils.DD_MMM_Format),
                                    style: TextStyle(
                                        fontSize: Constant.fontSize14,
                                        color: Constant.colorBlack,
                                        fontWeight: Constant.fontWeight600),
                                  ),
                                  Text(
                                    DateTimeUtils().dateToServerToDateFormat(
                                        sauda[index].saudaExtendedToDate == null
                                            ? sauda[index].saudaValidToDate!
                                            : sauda[index].saudaExtendedToDate!,
                                        DateTimeUtils.YYYY_MM_DD_Format,
                                        DateTimeUtils.YYYY_Format),
                                    style: TextStyle(
                                        fontSize: Constant.fontSize13,
                                        color: Constant.colorGray75),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}
