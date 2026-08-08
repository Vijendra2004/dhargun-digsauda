import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/screen/sauda_details/sauda_details.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../config/constant.dart';

class SaudaApproWid extends StatefulWidget {
  final String? textHeading;
  final double? textHeadingFs;
  final FontWeight? textHeadingFw;
  final Color? textHeadingFCol;
  final String? subHeading;
  final double? subHeadingFs;
  final Color? subHeadingFColor;
  final Color? bgHeading;
  final String? thridHeading;
  final double? thridHeadingFs;
  final Color? thridHeadingFCol;
  final String? thridHeadingDark;
  final double? thridHeadingDarkFs;
  final Color? thridHeadingDarkFCol;
  final FontWeight? thridHeadingDarkFW;
  final String? txtCol1Heading1;
  final double? txtCol1HeadingFs;
  final Color? txtCol1HeadingCol;
  final Color? txtCol1HeadingOraCol;
  final String? txtCol1SubHeading1;
  final double? txtCol1SubHeadingFs;
  final Color? txtCol1SubHeadingCol;
  final FontWeight? txtCol1SubHeadingFw;
  final String? txtCol2SubHeading1;
  final String? txtCol3SubHeading1;
  final String? txtCol2Heading1;
  final String? txtCol3Heading1;
  final String? iconImg;
  final SaudaList? saudaList;
  final Function? saudaApprovedFunc;

  SaudaApproWid(
      {Key? key,
      this.textHeading,
      this.textHeadingFs,
      this.textHeadingFCol,
      this.textHeadingFw,
      this.bgHeading,
      this.subHeading,
      this.subHeadingFs,
      this.subHeadingFColor,
      this.thridHeading,
      this.thridHeadingFCol,
      this.thridHeadingFs,
      this.thridHeadingDark,
      this.thridHeadingDarkFCol,
      this.thridHeadingDarkFs,
      this.thridHeadingDarkFW,
      this.txtCol1Heading1,
      this.txtCol1HeadingCol,
      this.txtCol1HeadingFs,
      this.txtCol1HeadingOraCol,
      this.txtCol1SubHeading1,
      this.txtCol1SubHeadingCol,
      this.txtCol1SubHeadingFs,
      this.txtCol1SubHeadingFw,
      this.txtCol2SubHeading1,
      this.txtCol3SubHeading1,
      this.txtCol2Heading1,
      this.txtCol3Heading1,
      this.iconImg,
      this.saudaList,
      this.saudaApprovedFunc})
      : super(key: key);
  int? selectedDiscountType = 1;
  @override
  State<SaudaApproWid> createState() => SaudaApproWidState();
}

class SaudaApproWidState extends State<SaudaApproWid> {
  void _showEditQuantityDialog(BuildContext context, int index) {
    final TextEditingController controller = TextEditingController(
      text: widget.saudaList!.skuList![index].quantity!.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Quantity"),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "New Quantity"),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                double? newQty = double.tryParse(controller.text);
                if (newQty != null) {
                  setState(
                      () => widget.saudaList!.skuList![index].quantity = newQty);
                  if (widget.saudaApprovedFunc != null) {
                    widget.saudaApprovedFunc!();
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaudaDetailScreen(
                        saudaId: widget.saudaList!.saudaId!,
                      )));
        },
        child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 9, bottom: 9),
                decoration: BoxDecoration(
                  color: (widget.saudaList!.isError == null ||
                          !widget.saudaList!.isError!)
                      ? const Color(0xFFF5F5F5)
                      : Colors.red[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.textHeading!,
                                style: TextStyle(
                                  fontSize: widget.textHeadingFs,
                                  color: widget.textHeadingFCol!,
                                  fontWeight: widget.textHeadingFw,
                                ),
                              ),
                              widget.iconImg == "" || widget.iconImg == null
                                  ? Container()
                                  : Row(
                                      children: [
                                        Image.asset(widget.iconImg!,
                                            width: 12.0, height: 13.0),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          widget.subHeading!,
                                          style: TextStyle(
                                              fontSize: widget.subHeadingFs,
                                              color: widget.subHeadingFColor),
                                        )
                                      ],
                                    )
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Checkbox(
                              onChanged: (bool? value) {
                                widget.saudaList!.isApproved = value;
                                if(widget.saudaApprovedFunc!=null) {
                                  widget.saudaApprovedFunc!();
                                }
                                setState(() {});
                              },
                              value: widget.saudaList!.isApproved!,
                              activeColor: Colors.green,
                            ))
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 12, right: 12, bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Booking No :",
                            style: TextStyle(
                                fontSize: widget.thridHeadingFs,
                                color: widget.thridHeadingFCol),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(widget.saudaList!.saudaId!.toString(),
                              style: TextStyle(
                                  fontSize: widget.thridHeadingDarkFs,
                                  color: widget.thridHeadingDarkFCol,
                                  fontWeight: Constant.fontWeight500)))
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget.saudaList != null
                          ? widget.saudaList!.skuList!.length
                          : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Sku Name ",
                                      style: TextStyle(
                                          fontSize: widget.thridHeadingFs,
                                          color: widget.thridHeadingFCol),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        widget.saudaList!.skuList![index]
                                            .skuName!,
                                        style: TextStyle(
                                            fontSize: widget.thridHeadingDarkFs,
                                            color: widget.thridHeadingDarkFCol,
                                            fontWeight:
                                                Constant.fontWeight500)))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.8, color: Color(0x13000000)),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.txtCol1Heading1!,
                                          style: TextStyle(
                                            fontSize: widget.txtCol1HeadingFs,
                                            color: widget.txtCol1HeadingCol,
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Text(
                                              widget.saudaList!.skuList![index]
                                                  .quantity!
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: widget
                                                      .txtCol1SubHeadingFs,
                                                  color: widget
                                                      .txtCol1SubHeadingCol,
                                                  fontWeight: widget
                                                      .txtCol1SubHeadingFw),
                                            ),
                                            const SizedBox(width: 4),
                                            InkWell(
                                              onTap: () =>
                                                  _showEditQuantityDialog(
                                                      context, index),
                                              child: const Icon(Icons.edit,
                                                  size: 16, color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.txtCol2Heading1!,
                                          style: TextStyle(
                                            fontSize: widget.txtCol1HeadingFs,
                                            color: widget.txtCol1HeadingCol,
                                          ),
                                        ),
                                        Text(
                                          widget.saudaList!.skuList![index]
                                              .quantityInMT!
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize:
                                                  widget.txtCol1SubHeadingFs,
                                              color:
                                                  widget.txtCol1SubHeadingCol,
                                              fontWeight:
                                                  Constant.fontWeight600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.txtCol3Heading1!,
                                          style: TextStyle(
                                            fontSize: widget.txtCol1HeadingFs,
                                            color: widget.txtCol1HeadingCol,
                                          ),
                                        ),
                                        Text(
                                          widget.saudaList!.skuList![index]
                                              .pricePercase!
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize:
                                                  widget.txtCol1SubHeadingFs,
                                              color:
                                                  widget.txtCol1SubHeadingCol,
                                              fontWeight:
                                                  Constant.fontWeight600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashLength: 2.0,
                              dashColor: Colors.black,
                              dashRadius: 0.0,
                              dashGapLength: 2.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            ),
                          ],
                        );
                      }),
                ],
              ),
            )
          ],
        ));
  }
}
