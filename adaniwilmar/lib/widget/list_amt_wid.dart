import 'package:flutter/material.dart';

import '../config/constant.dart';

class ListAmtWid extends StatelessWidget {
  final List<dynamic>? listOfCustomer;
  final double? headFontSz;
  final Color? headFontCol;
  final FontWeight? headFontWei;
  final double? amtFontSz;
  final Color? amtFontCol;
  final FontWeight? amtFontWei;
  const ListAmtWid({
    Key? key,
    this.listOfCustomer,
    this.headFontSz,
    this.headFontCol,
    this.headFontWei,
    this.amtFontSz,
    this.amtFontCol,
    this.amtFontWei,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listOfCustomer?.length,
        itemBuilder: (context, index) {
          return Container(
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listOfCustomer?[index].get("name"),
                      style: TextStyle(
                          fontSize: headFontSz,
                          color: headFontCol,
                          fontWeight: headFontWei),
                    ),
                  ],
                )),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(listOfCustomer![index].get("amt")!,
                      style: TextStyle(
                        fontSize: amtFontSz,
                        color: amtFontCol,
                        fontWeight: amtFontWei,
                      )),
                )
              ],
            ),
          );
        });
  }
}
