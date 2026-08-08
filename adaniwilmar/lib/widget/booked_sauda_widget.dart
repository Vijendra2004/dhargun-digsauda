import 'package:adaniwilmar/models/booked_sauda_response.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class SaudaBookedStatusWidget extends StatefulWidget {
  final List<SaudaBookedStatusDealerDetail>? bookedSaudas;
  final List<BookedSaudaResponse>? dealerSaudaDetails;
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
  SaudaBookedStatusWidget(
      {Key? key,
      this.bookedSaudas,
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
      this.dealerId = 0})
      : super(key: key);

  @override
  State<SaudaBookedStatusWidget> createState() =>
      _SaudaBookedStatusWidgetState();
}

class _SaudaBookedStatusWidgetState extends State<SaudaBookedStatusWidget> {
  int selected = 0 - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Constants.AUTH_ROLEID == Constants.DEALER
        ? ListView.builder(
            key: const Key('builder1'), //attention
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.dealerSaudaDetails!.length,
            itemBuilder: (context, ind) {
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
                                    builder: (context) => SaudaDetailScreen(
                                          saudaId: widget
                                              .dealerSaudaDetails![ind]
                                              .statusId==6||widget
                                              .dealerSaudaDetails![ind]
                                              .statusId==2 || widget
                                              .dealerSaudaDetails![ind]
                                              .saudaNumber==null || widget
                                              .dealerSaudaDetails![ind]
                                              .saudaNumber==""?widget
                                              .dealerSaudaDetails![ind]
                                              .saudaId!:int.parse(widget
                                              .dealerSaudaDetails![ind]
                                              .saudaNumber!),
                                        )));
                          },
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "#" +
                                  (widget
                                                          .dealerSaudaDetails![
                                                      ind]
                                                          .saudaNumber!=null && widget
                                                      .dealerSaudaDetails![
                                                  ind]
                                                      .saudaNumber!=""?widget
                                                          .dealerSaudaDetails![
                                                              ind]
                                                          .saudaNumber!:widget
                                                      .dealerSaudaDetails![
                                                  ind]
                                                      .saudaId!.toString()),
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
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.calendar_month,
                                                    size: 13,
                                                    color: Colors.orange),
                                                const SizedBox(width: 4.0),
                                                const SizedBox(width: 2),
                                                Text(
                                                  DateTimeUtils()
                                                      .dateToServerToDateFormat(
                                                          widget
                                                              .dealerSaudaDetails![
                                                                  ind]
                                                              .saudaBookedDate!,
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Total Qty",
                                                  style: TextStyle(
                                                      fontSize:
                                                      Constant.fontSize13,
                                                      color:
                                                      Constant.colorDullGray77,
                                                      fontWeight: Constant
                                                          .fontWeight400),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  widget
                                                      .dealerSaudaDetails![
                                                  ind]
                                                      .totalQuantity!.toString(),
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
                                                        .dealerSaudaDetails![
                                                            ind]
                                                        .statusId ==
                                                    1
                                                ? Constant.statusPendingColor
                                                : widget
                                                            .dealerSaudaDetails![
                                                                ind]
                                                            .statusId ==
                                                        2
                                                    ? Constant
                                                        .statusCompletedColor
                                                    : Constant
                                                        .statusRejectedColor,
                                            name: widget
                                                        .dealerSaudaDetails![
                                                            ind]
                                                        .status ==
                                                    null
                                                ? "Pending"
                                                : widget
                                                    .dealerSaudaDetails![ind]
                                                    .status!,
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
                                      bottom: BorderSide(
                                          width: 0.8, color: Color(0x13000000)),
                                    ),
                                  )),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment:
                                        Alignment.centerLeft,
                                        child:  Wrap(
                                          spacing: 2,
                                          runSpacing: 2,
                                          children: getSkus(widget
                                              .dealerSaudaDetails![ind]
                                              .bookedSaudaDetailDto!),
                                        ),
                                      ),

                                      const SizedBox(height: 10,),
                                      Align(
                                        alignment:
                                        Alignment.centerRight,
                                        child: Text(
                                            widget
                                                .dealerSaudaDetails![
                                            ind]
                                                .approvalUser!,
                                          style: TextStyle(
                                              fontSize: Constant
                                                  .fontSize13,
                                              color: Constant
                                                  .colorBlack,
                                              fontWeight: Constant
                                                  .fontWeight400),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ));
            })
        :
    ListView.builder(
            key: Key('builder'), //attention
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.bookedSaudas!.length,
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
                              SizedBox(
                                width: screenWidth * 0.66,
                                child: Text(
                                    widget.bookedSaudas![index].dealer!
                                        .split("-")[0],
                                    style: TextStyle(
                                        fontSize: widget.subFontSz,
                                        color: widget.headFontCol,
                                        fontWeight: widget.headFontWei)),
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 11,
                                      height: 14,
                                      child: Constant.locatoinIc),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: screenWidth * 0.6,
                                    child: Text(
                                        widget.bookedSaudas![index].dealer!
                                            .substring(widget
                                                    .bookedSaudas![index]
                                                    .dealer!
                                                    .indexOf("-") +
                                                1),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: widget.subFontCol,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      children: [
                        ListView.builder(
                            key: const Key('builder1'), //attention
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: widget
                                .bookedSaudas![index].bookedSaudaList!.length,
                            itemBuilder: (context, ind) {
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
                                                        SaudaDetailScreen(
                                                          saudaId: widget
                                                              .bookedSaudas![
                                                          index]
                                                              .bookedSaudaList![
                                                          ind].statusId==2 || widget
                                                              .bookedSaudas![
                                                          index]
                                                              .bookedSaudaList![
                                                          ind].statusId==6?widget
                                                              .bookedSaudas![
                                                          index]
                                                              .bookedSaudaList![
                                                          ind].saudaId!:int.parse(widget
                                                              .bookedSaudas![
                                                                  index]
                                                              .bookedSaudaList![
                                                                  ind]
                                                              .saudaNumber!),
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
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "#" +
                                                                      widget
                                                                          .bookedSaudas![
                                                                              index]
                                                                          .bookedSaudaList![
                                                                              ind]
                                                                          .saudaNumber!,
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
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .calendar_month,
                                                                    size: 13,
                                                                    color: Colors
                                                                        .orange),
                                                                const SizedBox(
                                                                    width: 4.0),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  DateTimeUtils().dateToServerToDateFormat(
                                                                      widget
                                                                          .bookedSaudas![
                                                                              index]
                                                                          .bookedSaudaList![
                                                                              ind]
                                                                          .saudaBookedDate!,
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
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Row(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Text(
                                                                  "Total Qty",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      Constant
                                                                          .fontSize13,
                                                                      color: Constant
                                                                          .colorDullGray77,
                                                                      fontWeight:
                                                                      Constant
                                                                          .fontWeight400),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  widget
                                                                      .bookedSaudas![
                                                                  index]
                                                                      .bookedSaudaList![
                                                                  ind].totalQuantity.toString(),
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
                                                            bgColor: widget
                                                                        .bookedSaudas![
                                                                            index]
                                                                        .bookedSaudaList![
                                                                            ind]
                                                                        .statusId ==
                                                                    1
                                                                ? Constant
                                                                    .statusPendingColor
                                                                : widget
                                                                            .bookedSaudas![
                                                                                index]
                                                                            .bookedSaudaList![
                                                                                ind]
                                                                            .statusId ==
                                                                        2
                                                                    ? Constant
                                                                        .statusCompletedColor
                                                                    : Constant
                                                                        .statusRejectedColor,
                                                            name: widget
                                                                        .bookedSaudas![
                                                                            index]
                                                                        .bookedSaudaList![
                                                                            ind]
                                                                        .status ==
                                                                    null
                                                                ? "Pending"
                                                                : widget
                                                                    .bookedSaudas![
                                                                        index]
                                                                    .bookedSaudaList![
                                                                        ind]
                                                                    .status!,
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
                                                  Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: 0.8,
                                                          color: Color(
                                                              0x13000000)),
                                                    ),
                                                  )),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: Wrap(
                                                          spacing: 2,
                                                          runSpacing: 2,
                                                          children: getSkus(widget
                                                              .bookedSaudas![index]
                                                              .bookedSaudaList![ind]
                                                              .bookedSaudaDetailDto!),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Align(
                                                        alignment:
                                                        Alignment.centerRight,
                                                        child: Text(
                                                          widget.bookedSaudas![index].bookedSaudaList![ind].approvalUser!,
                                                          style: TextStyle(
                                                              fontSize: Constant
                                                                  .fontSize13,
                                                              color: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight400),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
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

  List<Widget> getSkus(List<BookedSaudaDetailDto>? sp) {
    List<Widget> containers = [];
    for (int i = 0; i < sp!.length; i++) {
      BookedSaudaDetailDto? d = sp[i];
      containers.add(Container(
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.only(top: 2, bottom: 2, right: 4, left: 4),
        decoration: BoxDecoration(
          color: Constant.colorWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Text(
          d.oilType!+" ("+(d.skuCount==1? (d.skuCount!.toString()+" SKU"):(d.skuCount!.toString()+" SKU's"))+")",
          style: TextStyle(
              fontSize: Constant.fontSize11, color: Constant.colorBlack),
        ),
      ));
    }
    return containers;
  }
}
