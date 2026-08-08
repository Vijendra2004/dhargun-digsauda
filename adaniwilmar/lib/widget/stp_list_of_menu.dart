import 'package:adaniwilmar/screen/daily_sales_report/daily_sales_report.dart';
import 'package:flutter/material.dart';

import '../config/constant.dart';
import '../models/stp_model.dart';
import '../screen/screen.dart';
import '../utils/constant.dart';

class StpListOfMenu extends StatelessWidget {
  const StpListOfMenu({Key? key, this.listmenuItem}) : super(key: key);
  final List<StpModel>? listmenuItem;
  @override
  Widget build(BuildContext context) {
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {}
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: StpModel.stpData.length,
        itemBuilder: (context, index) {
          bool visible = true;
          if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
            if (index < 2) visible = false;
          }
          if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
            if (index < 1) visible = false;
          }
          return Visibility(
              visible: visible,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 67.0,
                padding: const EdgeInsets.only(
                    top: 9, bottom: 9, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x18000000),
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
                child: GestureDetector(
                  onTap: () {
                    if (1 == index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DeviationApprovalStatusScreen()),
                      );
                    } else if (0 == index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DailySalesReportScreen()),
                      );
                    } else if (2 == index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondarySalesScreen()),
                      );
                    }
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(StpModel.stpData[index].name,
                            style: TextStyle(
                                fontSize: Constant.fontSize16,
                                fontFamily: 'Aganè')),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: StpModel.stpData[index].round == true
                              ? Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text("1",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.white)),
                                  ))
                              : Container(),
                        )
                      ],
                    ),
                    trailing: SizedBox(
                        height: 15, width: 24, child: Constant.rightArow),
                  ),
                ), //BoxDecoration
              ));
        });
  }
}
