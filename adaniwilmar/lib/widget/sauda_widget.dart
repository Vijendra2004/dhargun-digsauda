import 'package:adaniwilmar/models/sauda_extension_list.dart';
import 'package:adaniwilmar/screen/saudu_number/sauda_number.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SaudaWidget extends StatefulWidget {
  final List<SaudaBookedDealerDetail>? saudaDetails;
  final List<SaudaBookedSaudaWithExtensionDetails>? dealerSaudaDetails;
  final bool? isApproved;
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

  const SaudaWidget({
    Key? key,
    this.saudaDetails,
    this.dealerSaudaDetails,
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
    this.isApproved,
  }) : super(key: key);

  @override
  State<SaudaWidget> createState() => _SaudaWidgetState();
}

class _SaudaWidgetState extends State<SaudaWidget> {
  int selected = 0 - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Constants.AUTH_ROLEID == Constants.DEALER
        ? ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const ClampingScrollPhysics(),
            itemCount: widget.dealerSaudaDetails!.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SaudaNumber(
                              sauda: widget.dealerSaudaDetails![index],
                              isApproved: widget.isApproved!,
                            )));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Sauda No:\t",
                                  style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorGray45),
                                ),
                                Text(widget.dealerSaudaDetails![index].saudaNumber!, style: TextStyle(fontSize: Constant.fontSize12, color: Constant.colorBlack, fontWeight: Constant.fontWeight500))
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
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    )),
                                const Expanded(
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
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                                          DateTimeUtils().dateToServerToDateFormat(widget.dealerSaudaDetails![index].saudaValidFromDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MMM_Format),
                                          style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                        ),
                                        Text(
                                          DateTimeUtils().dateToServerToDateFormat(widget.dealerSaudaDetails![index].saudaValidFromDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.YYYY_Format),
                                          style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorGray75),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      widget.dealerSaudaDetails![index].saudaExtendedDays.toString() + " Day",
                                      style: TextStyle(fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600, color: Constant.colorOrange),
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
                                              widget.dealerSaudaDetails![index].saudaExtendedToDate == null
                                                  ? widget.dealerSaudaDetails![index].saudaValidToDate!
                                                  : widget.dealerSaudaDetails![index].saudaExtendedToDate!,
                                              DateTimeUtils.YYYY_MM_DD_Format,
                                              DateTimeUtils.DD_MMM_Format),
                                          style: TextStyle(fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                        ),
                                        Text(
                                          DateTimeUtils().dateToServerToDateFormat(
                                              widget.dealerSaudaDetails![index].saudaExtendedToDate == null
                                                  ? widget.dealerSaudaDetails![index].saudaValidToDate!
                                                  : widget.dealerSaudaDetails![index].saudaExtendedToDate!,
                                              DateTimeUtils.YYYY_MM_DD_Format,
                                              DateTimeUtils.YYYY_Format),
                                          style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorGray75),
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
          )
        : ListView.builder(
            key: Key('buildersw'),
            //attention
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.saudaDetails!.length,
            itemBuilder: (context, index) {
              return CurveOuterBox(
                  boxLRPadding: 0,
                  boxTBPadding: 4,
                  boxofWidget: Theme(
                    data: theme,
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      key: Key(index.toString()),
                      initiallyExpanded: index == selected,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 3,
                            height: 34,
                            color: Constant.callToCcolor1,
                            margin: const EdgeInsets.only(top: 3),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.saudaDetails![index].dealerName!, style: TextStyle(fontSize: widget.headFontSz, color: widget.headFontCol, fontWeight: widget.headFontWei)),
                              Row(
                                children: [
                                  SizedBox(width: 12, height: 13, child: Constant.locatoinIc),
                                  const SizedBox(width: 4),
                                  Text(widget.saudaDetails![index].dealerCode!,
                                      style: TextStyle(
                                        fontSize: widget.subFontSz,
                                        color: widget.subFontCol,
                                      ))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      trailing: Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.keyboard_arrow_down_sharp)),
                      children: [
                        ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: CurveOuterBox(
                              boxBorderColor: const Color(0xFFE7E7E7),
                              boxShadowColor: const Color(0xFFFFFFFF),
                              boxBorderWidth: 0,
                              boxLRPadding: 0,
                              boxTBPadding: 0,
                              boxBRRadius: 5,
                              boxofWidget: SaudaExtensionWid(
                                sauda: widget.saudaDetails![index].saudaBookedList!,
                              ),
                            ))
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
}
