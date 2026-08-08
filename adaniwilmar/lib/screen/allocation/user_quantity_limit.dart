import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/screen/allocation/allocate_quantity.dart';
import 'package:adaniwilmar/screen/allocation/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class UserQuantityLimitScreen extends StatelessWidget {
  const UserQuantityLimitScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const UserQuantityLimitScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllocationBloc()
        ..add(LoadUserQuantityLimitData(userId: Constants.AUTH_USERID)),
      child: const QualityAllocation(),
    );
  }
}

class QualityAllocation extends StatefulWidget {
  const QualityAllocation({Key? key}) : super(key: key);

  @override
  State<QualityAllocation> createState() => _QualityAllocationState();
}

class _QualityAllocationState extends State<QualityAllocation>
    with TickerProviderStateMixin {
  List<OilType> oilTypes = [];
  OilType? selectedOilType;
  List<QuantityRequestList> quantityManagerAllocations = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Oil Type";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  ProgressBarHandler? _handler;
  TextEditingController _quantitycontroller = TextEditingController();
  get handleOk => null;
  int selectedTab = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget contBody() {
    return const Text("jai");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<AllocationBloc, AllocationState>(
        listener: (context, state) {
          if (state is OnUserQuantityLimitData) {
            quantityManagerAllocations = state.response;
            setState(() {});
          }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: "User Quantity Limit",
            backArrow: true,
          ),
          body: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: CurveBorderBox(
                      boxLRPadding: 0,
                      boxofWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: screenHeight * 0.950,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 16),
                            padding: const EdgeInsets.only(
                              right: 14,
                              top: 14,
                              bottom: 14,
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 0),
                                physics: const ClampingScrollPhysics(),
                                itemCount: quantityManagerAllocations.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllocateQuantityScreen(
                                                      quantityLimit:
                                                          quantityManagerAllocations[
                                                              index])),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
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
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        quantityManagerAllocations[
                                                                    index]
                                                                .oilTypeName ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: Constant
                                                                .fontSize14,
                                                            color: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight500),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Type",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      quantityManagerAllocations[
                                                              index]
                                                          .skuName!,
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.8,
                                                        color:
                                                            Color(0x13000000)),
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Valid From",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      DateTimeUtils().dateToServerToDateFormat(
                                                          quantityManagerAllocations[
                                                                  index]
                                                              .validFrom!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                )),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Valid To",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      DateTimeUtils().dateToServerToDateFormat(
                                                          quantityManagerAllocations[
                                                                  index]
                                                              .validTo!,
                                                          DateTimeUtils
                                                              .YYYY_MM_DD_Format,
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.8,
                                                        color:
                                                            Color(0x13000000)),
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 12,
                                                right: 12,
                                                bottom: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Given Qty",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      quantityManagerAllocations[
                                                                  index]
                                                              .quantityLimit!
                                                              .toStringAsFixed(
                                                                  2) +
                                                          " MT",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorOrange,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                )),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Available Qty",
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorBlack),
                                                    ),
                                                    Text(
                                                      quantityManagerAllocations[
                                                                  index]
                                                              .remainingQuantity
                                                              .toString() +
                                                          " MT",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: Constant
                                                              .fontSize12,
                                                          color: Constant
                                                              .colorOrange,
                                                          fontWeight: Constant
                                                              .fontWeight500),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ));
                                }),
                          )
                        ],
                      ))),
              progressBar
            ],
          ),
        )));
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
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
      title: Container(
        decoration: BoxDecoration(
          color: Constant.colorOrange,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
            )),
      ),
      content: Text(successText!),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
                buttonName: "Ok",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  Navigator.pop(context);
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  BlocProvider.of<AllocationBloc>(context).add(
                      LoadUserQuantityLimitData(userId: Constants.AUTH_USERID));
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
}
