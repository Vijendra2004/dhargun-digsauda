import 'dart:convert';

import 'package:adaniwilmar/db/databas_helper.dart';
import 'package:adaniwilmar/db/table_common.dart';
import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/storage/SPUtils.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/material.dart';

import '../config/constant.dart';
import '../widget/border_bottom.dart';
import '../widget/common_button.dart';

class Utils {
  saveOfflineData(String cid, Meta content) async {
    var db = DatabaseHelper();
    await db.saveOrUpdateContent(cid, jsonEncode(content));
  }

  Future<int> deleteOfflineDataByCID(String cid) async {
    var db = DatabaseHelper();
    return await db.delete(cid);
  }

  saveFacilityOfflineData(String cid, Meta content) async {
    var db = DatabaseHelper();
//    await db.saveOrUpdateFacilityContent(cid, jsonEncode(content));
    await db.saveOrUpdateContent(cid, jsonEncode(content));
  }

  // ignore: missing_return
  Future<Meta> getOfflineData(String cid) async {
    var db = DatabaseHelper();
    CommonTable? tempTable = await db.getContentByCID(cid);
    if (tempTable != null) {
      if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
              Constants.LANGUAGE_ENGLISH ||
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
        if (tempTable.englishContent == null) {
          return Meta(statusCode: 201, statusMsg: "No Data Found");
        }
        return Meta.fromJson(jsonDecode(tempTable.englishContent));
      } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
          Constants.LANGUAGE_TAMIL) {
        if (tempTable.tamilContent == null) {
          return Meta(statusCode: 201, statusMsg: "No Data Found");
        }
        return Meta.fromJson(jsonDecode(tempTable.tamilContent));
      }
    } else {
      return Meta(statusCode: 201, statusMsg: "No Data Found");
    }
    return Meta();
  }

  int getInterNetSpeed() {
    return SPUtil.getInt(Constants.INTERNET_SPEED,
        defValue: Constants.NET_SPEED_LOW);
  }

  String convertToK(double number) {
    if(number<100){
      return number.toStringAsFixed(2);
    } else{
      double result = number / 1000;
      return '${result.toStringAsFixed(2)}K';
    }
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white,bool? closeScreen=false}) {
    // set up the button
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),

      content:   Container(
          width: MediaQuery.of(context).size.width*0.70,
          child:Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: getIcon(title),

                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title,style:TextStyle(
                        fontSize: Constant.fontSize20,
                        fontWeight: Constant.fontWeight600
                    )),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        successText!,
                        textAlign: TextAlign.center,style:TextStyle(
                      fontSize: Constant.fontSize14,
                    )),
                  ),
                  SizedBox(height: 20),
                  BorderBottom(bordeSize: 1)
                ],
              ),
            ]),
          ])),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CommonButton(
                buttonName: "Done",
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.textFormFieldColor,
                buttonColor: Colors.white,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.black,
                buttonNameWeight: Constant.fontWeight500,
                buttonFunction: () {
                  Navigator.pop(context);
                  if(closeScreen!) {
                    Navigator.of(context).pop(true);
                  }
                 else if(title=="Error"){
                    return;
                  }
                 else {

                  }


                })
          ],
        )
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return alert;
          });
        });
  }

  Icon getIcon(String msg) {
    if(msg == "Error"){
      return Icon(Icons.error_outlined ,size:70,color: Colors.red);
    } else if(msg == "Success"){
      Icon(Icons.check_circle_sharp ,size:70,color: Colors.green);
    }
    return Icon(Icons.error_outlined ,size:70,color: Colors.orangeAccent);
  }

  // Function to convert a hex string to a Color
  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}
