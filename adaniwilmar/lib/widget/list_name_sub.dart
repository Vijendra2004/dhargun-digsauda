import 'package:adaniwilmar/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ListOfNameSub extends StatelessWidget {
  final List<dynamic>? listOfCustomer;
  final double? headFontSz;
  final Color? headFontCol;
  final FontWeight? headFontWei;
  final double? subFontSz;
  final Color? subFontCol;
  final FontWeight? subFontWei;
  final double? amtFontSz;
  final Color? amtFontCol;
  final FontWeight? amtFontWei;
  final SvgPicture? sbIcon;
  final Color? sbIconColor;
  final double? sbIconSize;
  final bool? trueforImage;
  final Image? imageIc;
  const ListOfNameSub(
      {Key? key,
      this.listOfCustomer,
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
      this.trueforImage = false,
      this.imageIc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8, bottom: 0, left: 0, right: 0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listOfCustomer?.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
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
            child: ListTile(
              onTap: () {

              },
              dense: true,
              contentPadding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
              horizontalTitleGap: 0,
              visualDensity: const VisualDensity(horizontal: -4, vertical: 0),
              leading: Container(
                height: 40,
                width: 4,
                decoration: BoxDecoration(
                    color: Constant.colorOrange,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
              ),
              title: Text(
                listOfCustomer?[index].get("name"),
                style: TextStyle(
                    fontSize: headFontSz,
                    color: headFontCol,
                    fontWeight: headFontWei),
              ),
              subtitle: listOfCustomer![index].get("subName") != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        trueforImage == true
                            ? SizedBox(width: 13, height: 16, child: imageIc)
                            : SizedBox(width: 13, height: 16, child: sbIcon),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(listOfCustomer![index].get("subName")!,
                              style: TextStyle(
                                fontSize: subFontSz,
                                color: subFontCol,
                              )),
                        )
                      ],
                    )
                  : null,
              trailing: Text(listOfCustomer![index].get("amt")!,
                  style: TextStyle(
                    fontSize: amtFontSz,
                    color: amtFontCol,
                    fontWeight: amtFontWei,
                  )),
            ),
          );
        });
  }
}

