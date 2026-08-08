import 'package:adaniwilmar/screen/discount/user_discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/common-textfield.dart';
import '../../widget/common_button.dart';
import '../../widget/common_text.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/floating_button.dart';
import 'bloc/discount_bloc.dart';
import 'bloc/discount_state.dart';
import 'geography_discount.dart';


class GeographyDiscountDetailScreen extends StatelessWidget {
  static const String routeName = '/discount';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const UserDiscountScreen());
  }

  const GeographyDiscountDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentDate = DateTimeUtils()
        .dateToStringFormat(DateTime.now(), DateTimeUtils.ServerFormat);
    GMLogger.v(currentDate.toString());
    return BlocProvider(
      create: (context) => CreateDiscountBloc(),
        // ..add(LoadUserDiscountList(userId: Constants.AUTH_USERID,date: currentDate)),
      child: const UserDiscount(),
    );
  }
}

class UserDiscount extends StatefulWidget {
  const UserDiscount({Key? key}) : super(key: key);

  @override
  State<UserDiscount> createState() => _UserDiscountState();
}

class _UserDiscountState extends State<UserDiscount> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  // List<UserDiscountListRequest> userDiscountRequestList = [];
  // List<UserDiscountListRequest> userDiscountFilterList = [];
  // List<UserDiscountListRequest> filterList = [];
  bool isFilter = false;
  ProgressBarHandler? _handler;

  final TextEditingController _filterdatecontroller = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey _dialogKey = GlobalKey();

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

    return BlocListener<CreateDiscountBloc, CreateDiscountState>(
      listener: (context, state) {
        // if (state is UserDiscountListRequestSuccess) {
        //   userDiscountRequestList = state.userDiscountRequestList;
        //   print(userDiscountRequestList);
        // }

        if (state is ShowProgressBar) {
          _handler!.show!();
        }
        if (state is HideProgressBar) {
          _handler!.dismiss!();
        }
      },
      child: BlocBuilder<CreateDiscountBloc, CreateDiscountState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              primary: false,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                title: "Geography Discount",
                backArrow: true,
                listOfActions: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showCustomFilterDialog(context, "Filter", "Filter",
                            dialogActionButtonFilter());
                      },
                      icon: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                          padding: const EdgeInsets.all(7),
                          child: Constant.filterIc,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Visibility(
                // visible: Constants.AUTH_ROLEID == Constants.NHMANAGER,
                  visible: true,
                  child: FloatingButton(
                      buttonBgColor: Constant.colorRed,
                      buttonIcon: Constant.saudaIcPlus,
                      navigationFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                               GeographyDiscountScreen()),
                        );
                      },
                      buttoniconSize: 20)),
              body: BlocListener<CreateDiscountBloc, CreateDiscountState>(
                listener: (context, state) {
                  // if (state is UserDiscountListRequestSuccess) {
                  //   userDiscountRequestList = state.userDiscountRequestList;
                  //   print(userDiscountRequestList);
                  // }
                  // if (state is ShowProgressBar) {
                  //   _handler!.show!();
                  // }
                  // if (state is HideProgressBar) {
                  //   _handler!.dismiss!();
                  // }
                },
                child: Stack(
                  // clipBehavior: Clip.none,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      child: Container(
                        child: Constant.bgImgGlobal,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 60, right: 8, left: 8),
                      height: screenHeight * 0.980,
                      width: screenWidth,
                      child: CurveBorderBox(
                        boxLRPadding: 8,
                        boxTOPPadding: 0,
                        boxBOTPadding: 0,
                        boxofWidget: ListView.builder(
                          // itemCount: isFilter ? filterList.length: userDiscountRequestList.length,
                          itemCount: 4,
                          // userDiscountRequestList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 8, right: 8, top: 14, bottom: 8),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0,
                                          color: const Color(0xFFDEDEDE)),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             // UserDiscountDetailsScreen(
                                            //             //     id: userDiscountRequestList[
                                            //             //     index]
                                            //             //         .id)
                                            //     )
                                            // );
                                          },
                                          child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12,),
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
                                                  Radius.circular(0.0),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    // userDiscountRequestList[
                                                    // index]
                                                    //     .skuName ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize:
                                                        Constant.fontSize13,
                                                        color:
                                                        Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight600),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GeographyDiscountScreen()));
                                                    },
                                                    icon: Container(
                                                      child: Constant.filterIc,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 12,
                                              right: 12,
                                              bottom: 12),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 3),
                                              Container(
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xFFBDBDBD),
                                                            width: 0.8))),
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  children: [
                                                    // Expanded(
                                                    //   child: Align(
                                                    //     alignment: Alignment.topLeft,
                                                    //     child: Column(
                                                    //       crossAxisAlignment:
                                                    //       CrossAxisAlignment
                                                    //           .start,
                                                    //       children: [
                                                    //         CommonText(
                                                    //           name:
                                                    //           "Distributor Channel",
                                                    //           fontSize:
                                                    //           Constant.fontSize12,
                                                    //           fontColor: Constant
                                                    //               .colorDullGray77,
                                                    //         ),
                                                    //         const SizedBox(
                                                    //             height: 6.0),
                                                    //         CommonText(
                                                    //           name: 'Customer Sale',
                                                    //           fontSize:
                                                    //           Constant.fontSize12,
                                                    //           fontColor:
                                                    //           Constant.colorBlack,
                                                    //           fontWeight: Constant
                                                    //               .fontWeight500,
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                        Alignment.topLeft,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            CommonText(
                                                              name:
                                                              "Discount Amount",
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorDullGray77,
                                                            ),
                                                            const SizedBox(
                                                                height: 6.0),
                                                            CommonText(
                                                              name: "",
                                                              // userDiscountRequestList[
                                                              // index]
                                                              //     .actualDiscount
                                                              //     .toString(),
                                                              fontSize: Constant
                                                                  .fontSize12,
                                                              fontColor: Constant
                                                                  .colorBlack,
                                                              fontWeight: Constant
                                                                  .fontWeight500,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: <Widget>[
                                                  const Icon(
                                                      Icons.calendar_month,
                                                      size: 13,
                                                      color: Colors.orange),
                                                  const SizedBox(width: 4.0),
                                                  Text("",
                                                    // "${userDiscountRequestList[index].validFrom.toString()} - ${userDiscountRequestList[index].validTo.toString()}",
                                                    style: TextStyle(
                                                        fontSize:
                                                        Constant.fontSize13,
                                                        color: Constant
                                                            .colorGray45,
                                                        fontWeight: Constant
                                                            .fontWeight500),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    progressBar
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showCustomFilterDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
            key: _dialogKey,
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: const EdgeInsets.only(left: 20, right: 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                titlePadding: const EdgeInsets.all(0),
                contentPadding: EdgeInsets.zero,
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Constant.colorOrange,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: Constant.fontSize15,
                          fontWeight: Constant.fontWeight500,
                        )),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Constant.colorWhite,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                content: Container(
                    height: 100,
                    width: double.infinity,
                    padding:
                    const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: getDialogContent()),
                actions: [
                  Row(
                    children: [footerbutton],
                  )
                ],
              );
            });
      },
    );
  }

  Widget getDialogContent() {
    var ctx = context;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectFromDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "Filter Date",
                  labeltxtColor: Constant.textFormFieldColor,
                  labeltxtSize: Constant.textFormFieldSize,
                  labeltxtFontWeight: Constant.textFormFieldSizeFontW,
                  focuBorColor: Constant.textFormFocuBorCol,
                  focuBorWid: Constant.textFormFocuBorWid,
                  enaBorColor: Constant.textFormEnaBorCol,
                  enaBorWid: Constant.textFormEnaBorWid,
                  borderRadiusTL: Constant.textFormborderRadiusTL,
                  borderRadiusBR: Constant.textFormborderRadiusBR,
                  contentPadHor: Constant.textFormcontentPadHor,
                  contentPadHVer: Constant.textFormcontentPadHVer,
                  controllerTxt: _filterdatecontroller,
                  enabled: false,
                )),
          ),
        ],
      ),
    ]);
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _filterdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
            _filterdatecontroller.text.toString(),
            DateTimeUtils.DD_MM_YYYY_Format,
            DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _filterdatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.ServerFormat);
    }
  }

  Widget dialogActionButtonFilter() {
    var ct = context;
    return SizedBox(
      // width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(width: 9),
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Cancel",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.saudaLETTxtColor,
              buttonColor: Constant.saudaLETbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Apply",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                String filterDate = _filterdatecontroller.text.toString();
                BlocProvider.of<CreateDiscountBloc>(context);
                    // .add(LoadUserDiscountList(userId: Constants.AUTH_USERID,date:filterDate));
                _filterdatecontroller.clear();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}