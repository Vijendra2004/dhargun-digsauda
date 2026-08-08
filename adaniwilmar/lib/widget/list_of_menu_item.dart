import 'package:flutter/material.dart';

import '../config/constant.dart';
import '../models/modals.dart';
import '../screen/screen.dart';

class ListOfMenuItem extends StatelessWidget {
  const ListOfMenuItem({Key? key, this.listmenuItem}) : super(key: key);
  final List<ListOFMenuItemModel>? listmenuItem;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ListOFMenuItemModel.category.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (0 == index) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const CustomerLedger()),
                // );
              } else if (1 == index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallToCustomer(

                          )),
                );
              } else if (2 == index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpecialRateApprovalScreen(
                            distributor: null,
                          )),
                );
              } else if (3 == index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QualityAllocation()),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 67.0,
              padding: const EdgeInsets.all(16),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(ListOFMenuItemModel.category[index].name,
                        style: Theme.of(context).textTheme.bodyLarge!),
                  ),
                  ListOFMenuItemModel.category[index].round == true
                      ? Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: Constant.colorRed,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text("1",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Constant.colorWhite,
                                        fontSize: Constant.fontSize13)),
                          ))
                      : Container(),
                  const SizedBox(width: 80),
                  Container(
                    child: Constant.rightArow,
                  )
                ],
              ), //BoxDecoration
            ),
          );
        });
  }
}
