import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SpecialRateWidget extends StatefulWidget {
  final List<SpecialRateResponse>? specialRates;
  final List<SpecialRateList>? dealerSpecialRates;
  int dealerId = 0;
  final double? headFontSz;
  final Color? headFontCol;
  final FontWeight? headFontWei;
  final double? subFontSz;
  final Color? subFontCol;
  final FontWeight? subFontWei;
  final double? amtFontSz;
  final Color? amtFontCol;
  final FontWeight? amtFontWei;
  final IconData? sbIcon;
  final Color? sbIconColor;
  final double? sbIconSize;
  final Widget? otherWidget;
  SpecialRateWidget(
      {Key? key,
      this.specialRates,
      this.dealerSpecialRates,
      this.headFontSz,
      this.headFontCol,
      this.headFontWei,
      this.subFontSz,
      this.subFontCol,
      this.subFontWei,
      this.amtFontSz,
      this.amtFontCol,
      this.amtFontWei,
      this.sbIcon,
      this.sbIconColor,
      this.sbIconSize,
      this.otherWidget,
      this.dealerId = 0})
      : super(key: key);

  @override
  State<SpecialRateWidget> createState() => _SpecialRateWidgetState();
}

class _SpecialRateWidgetState extends State<SpecialRateWidget> {
  int selected = 0 - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Constants.DEALER == Constants.AUTH_ROLEID
        ? ListView.builder(
            key: Key('builder ${selected.toString()}'), //attention
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dealerSpecialRates!.length,
            itemBuilder: (context, idx) {
              return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: CurveOuterBox(
                    boxBorderColor: const Color(0xFFE7E7E7),
                    boxShadowColor: const Color(0xFFFFFFFF),
                    boxBorderWidth: 0,
                    boxLRPadding: 0,
                    boxTBPadding: 0,
                    boxBRRadius: 5,
                    boxofWidget: Column(
                      children: [
                        MaterialButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SpecialRateApprovalNext(
                                          dealerId: widget
                                              .dealerSpecialRates![idx]
                                              .dealerId!,
                                          specialRateId: widget
                                              .dealerSpecialRates![idx]
                                              .specialRateId!,
                                        )));
                          },
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 0, right: 12, top: 12, bottom: 9),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_month,
                                                    size: 13,
                                                    color: Colors.orange),
                                                const SizedBox(width: 6.0),
                                                Text(
                                                  DateTimeUtils()
                                                      .dateToServerToDateFormat(
                                                          widget
                                                              .dealerSpecialRates![
                                                                  idx]
                                                              .requestDate!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                  style: TextStyle(
                                                      fontSize:
                                                          Constant.fontSize13,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight500),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: CommonLabel(
                                            bgColor: widget
                                                .dealerSpecialRates![idx].statusId==1?Constant.statusPendingColor:widget
                                                .dealerSpecialRates![idx].statusId==2?Constant.statusCompletedColor:Constant.statusRejectedColor,
                                            name: widget
                                                .dealerSpecialRates![idx]
                                                .statusName,
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
                                  Row(
                                    children: getSkus(
                                        widget.dealerSpecialRates![idx]),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ));
            })
        : ListView.builder(
            key: Key('buildersr'), //attention
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.specialRates!.length,
            itemBuilder: (context, index) {
              return CurveOuterBox(
                  boxLRPadding: 0,
                  boxTBPadding: 0,
                  boxofWidget: Theme(
                    data: theme,
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                      key: Key(index.toString()),
                      initiallyExpanded: index == selected,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                                color: Constant.callToCcolor1,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                          ),
                          const SizedBox(width: 14),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    widget.specialRates![index].dealerName!
                                        .split("-")[0],
                                    style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        fontSize: widget.headFontSz,
                                        color: widget.headFontCol,
                                        fontWeight: widget.headFontWei)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                        width: 12,
                                        height: 13,
                                        child: Constant.locatoinIc),
                                    const SizedBox(width: 4),
                                    Container(
                                        margin: EdgeInsets.only(top: 4),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.63,
                                        child: Text(
                                            widget.specialRates![index]
                                                .dealerName!
                                                .substring(widget
                                                        .specialRates![index]
                                                        .dealerName!
                                                        .indexOf("-") +
                                                    1),
                                            style: TextStyle(
                                                fontSize: widget.subFontSz,
                                                color: widget.subFontCol,
                                                overflow:
                                                    TextOverflow.visible)))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      children: [
                        ListView.builder(
                            key: Key(
                                'builder ${selected.toString()}'), //attention
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget
                                .specialRates![index].specialRateList!.length,
                            itemBuilder: (context, idx) {
                              return ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: CurveOuterBox(
                                    boxBorderColor: const Color(0xFFE7E7E7),
                                    boxShadowColor: const Color(0xFFFFFFFF),
                                    boxBorderWidth: 0,
                                    boxLRPadding: 0,
                                    boxTBPadding: 0,
                                    boxBRRadius: 5,
                                    boxofWidget: Column(
                                      children: [
                                        MaterialButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SpecialRateApprovalNext(
                                                          dealerId: widget
                                                              .specialRates![
                                                                  index]
                                                              .dealerId!,
                                                          specialRateId: widget
                                                              .specialRates![
                                                                  index]
                                                              .specialRateList![
                                                                  idx]
                                                              .specialRateId!,
                                                        )));
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  top: 9,
                                                  bottom: 9),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF5F5F5),
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(25.0),
                                                  topRight:
                                                      Radius.circular(5.0),
                                                  bottomLeft:
                                                      Radius.circular(5.0),
                                                  bottomRight:
                                                      Radius.circular(25.0),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .calendar_month,
                                                                    size: 13,
                                                                    color: Colors
                                                                        .orange),
                                                                const SizedBox(
                                                                    width: 6.0),
                                                                Text(
                                                                  DateTimeUtils().dateToServerToDateFormat(
                                                                      widget
                                                                          .specialRates![
                                                                              index]
                                                                          .specialRateList![
                                                                              idx]
                                                                          .requestDate!,
                                                                      DateTimeUtils
                                                                          .YYYY_MM_DD_Format,
                                                                      DateTimeUtils
                                                                          .DD_MM_YYYY_Format),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Constant
                                                                              .fontSize13,
                                                                      color: Constant
                                                                          .colorBlack,
                                                                      fontWeight:
                                                                          Constant
                                                                              .fontWeight500),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: CommonLabel(
                                                            bgColor:  widget
                                                                .specialRates![
                                                            index]
                                                                .specialRateList![
                                                            idx].statusId==1?Constant.statusPendingColor: widget
                                                                .specialRates![
                                                            index]
                                                                .specialRateList![
                                                            idx].statusId==2?Constant.statusCompletedColor:Constant.statusRejectedColor,
                                                            name: widget
                                                                .specialRates![
                                                                    index]
                                                                .specialRateList![
                                                                    idx]
                                                                .statusName,
                                                            fontSize: Constant
                                                                .fontSize11,
                                                            fontColor: Constant
                                                                .colorWhite,
                                                            imageic: Constant
                                                                .checkIc,
                                                            imagetrue: true,
                                                          ))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  // Container(
                                                  //     decoration:
                                                  //         const BoxDecoration(
                                                  //   border: Border(
                                                  //     bottom: BorderSide(
                                                  //         width: 0.8,
                                                  //         color: Color(0x13000000)),
                                                  //   ),
                                                  // )),
                                                  // const SizedBox(
                                                  //   height: 8,
                                                  // ),
                                                  Row(
                                                    children: getSkus(widget
                                                        .specialRates![index]
                                                        .specialRateList![idx]),
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ));
                            })
                      ],
                      onExpansionChanged: ((newState) {
                        if (newState) {
                          setState(() {
                            selected = index;
                          });
                        } else {
                          setState(() {
                            selected = -1;
                          });
                        }
                      }),
                    ),
                  ));
            });
  }

  List<Widget> getSkus(SpecialRateList? sp) {
    List<Widget> containers = [];
    for (int i = 0; i < sp!.oilTypeList!.length; i++) {
      SpecialRateOilTypeList? d = sp.oilTypeList![i];
      containers.add(Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.only(top: 2, bottom: 2, right: 8, left: 8),
        decoration: BoxDecoration(
          color: Constant.colorWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Text(
          d.skuName!,
          style: TextStyle(
              fontSize: Constant.fontSize11, color: Constant.colorBlack),
        ),
      ));
    }
    return containers;
  }
}
