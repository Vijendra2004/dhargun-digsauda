import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/customer_ledger_response.dart';
import 'package:adaniwilmar/screen/customer_ledger/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../../config/constant.dart';
import '../../models/dealer_response.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class CustomerLedger extends StatelessWidget {
  const CustomerLedger({Key? key, required this.selectedCustomerLedgerId, this.selectedCustomerLedgerName}) : super(key: key);
  final String selectedCustomerLedgerId;
  final String? selectedCustomerLedgerName;
  static const String routeName = '/';

  Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => CustomerLedgerDetail(selectedCustomerLedger: selectedCustomerLedgerId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerLedgerBloc()..add(LoadCustomerLedgerScreen(userId: Constants.AUTH_USERID, dealerId: selectedCustomerLedgerId)),
      child: CustomerLedgerDetail(
        selectedCustomerLedger: selectedCustomerLedgerId,
        selectedCustomerLedgerName: selectedCustomerLedgerName,
      ),
    );
  }
}

class CustomerLedgerDetail extends StatefulWidget {
  const CustomerLedgerDetail({required this.selectedCustomerLedger, Key? key, this.selectedCustomerLedgerName}) : super(key: key);

  final String selectedCustomerLedger;
  final String? selectedCustomerLedgerName;

  @override
  State<CustomerLedgerDetail> createState() => _CustomerLedgerState();
}

class _CustomerLedgerState extends State<CustomerLedgerDetail> {
  LedgerInfo ledgerInfo = LedgerInfo(currentBalance: 0, customerLedger: [], transactionType: 1);
  DistributorList? selectedDistributor;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  List<DistributorList> distributorList = [];
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  BdoList? selectedBdo;
  StateTraderFilterWidget? tradeFilter;
  TextEditingController? _distributorcontroller;

  static String _displayStringForOption(DistributorList option) => option.employeeName!;

  @override
  void initState() {
    // TODO: implement initState
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        selectedBdo = value;
        selectedDistributor = null;
        BlocProvider.of<CustomerLedgerBloc>(context).add(LoadCustomerLedgerScreen(userId: Constants.AUTH_USERID, dealerId: widget.selectedCustomerLedger, bdoIds: []));
      },
      onLoad: (var value) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<CustomerLedgerBloc, CustomerLedgerState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            ledgerInfo = state.ledgerInfo;
            // distributorList = state.distributorList;
            // if (selectedDistributor != null) {
            //   selectedDistributor = distributorList
            //       .where((element) => element.id == selectedDistributor!.id!)
            //       .first;
            // } else {
            //   selectedDistributor = distributorList[0];
            // }
            setState(() {});
          }
          if (state is OnLedgerDataSuccess) {
            ledgerInfo = state.ledgerInfo;
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
                appBar: CustomAppBar(title: ['', null].contains(widget.selectedCustomerLedgerName) ? "Customer Ledger" : "Customer Ledger - " + widget.selectedCustomerLedgerName!, backArrow: true),
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: Container(
                        child: Constant.bgImgGlobal,
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.980,
                      width: screenWidth,
                      margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                      child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: CurveBorderBox(
                              boxLRPadding: 0,
                              boxTOPPadding: 0,
                              boxBOTPadding: 0,
                              boxHeight: screenHeight,
                              boxofWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                      visible: false,
                                      child: CurveBorderBox(
                                          boxLRPadding: 0,
                                          boxTOPPadding: 0,
                                          boxBOTPadding: 0,
                                          boxBgColor: const Color(0xFFFFFBF7),
                                          boxShadowColor: const Color(0xFFFFFFFF),
                                          boxHeight: Constants.AUTH_ROLEID == Constants.SALE ? screenHeight * 0.9 : screenHeight * 0.18,
                                          boxofWidget: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                tradeFilter != null ? tradeFilter! : const Visibility(visible: false, child: Text("State Trade")),
                                                StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                  return Container(
                                                      padding: const EdgeInsets.all(8),
                                                      width: double.infinity,
                                                      height: 70,
                                                      child: CustomAutocomplete<DistributorList>(
                                                        fieldViewBuilder:
                                                            (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                                                          _distributorcontroller = fieldTextEditingController;
                                                          return TextField(
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: 1,
                                                            decoration: InputDecoration(
                                                                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                                        bottomRight: Radius.circular(borderRadiusTLBR)),
                                                                    borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                                border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                                        bottomRight: Radius.circular(borderRadiusTLBR)),
                                                                    borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(borderRadiusTLBR),
                                                                        topRight: Radius.circular(borderRadiusTRBL),
                                                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                                                        bottomRight: Radius.circular(borderRadiusTLBR)),
                                                                    borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                                filled: true,

                                                                // hintStyle: TextStyle(color: Colors.grey[800]),
                                                                labelText: "Distributor Name",
                                                                labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                                                fillColor: fillColor),
                                                            controller: fieldTextEditingController,
                                                            focusNode: fieldFocusNode,
                                                            // style: const TextStyle(fontWeight: FontWeight.normal),
                                                          );
                                                        },
                                                        displayStringForOption: _displayStringForOption,
                                                        optionsBuilder: (TextEditingValue textEditingValue) {
                                                          if (textEditingValue.text == '') {
                                                            return const Iterable<DistributorList>.empty();
                                                          }
                                                          return distributorList.where((DistributorList option) {
                                                            return option.employeeName.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
                                                          });
                                                        },
                                                        onSelected: (DistributorList selection) {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          setState(() {
                                                            selectedDistributor = selection;
                                                          });
                                                          BlocProvider.of<CustomerLedgerBloc>(context).add(LoadLedgerData(userId: Constants.AUTH_USERID, dealerId: selectedDistributor!.employeeCode!));
                                                        },
                                                      )
                                                      // CommonDropdownButtonFormField<
                                                      //     DistributorList>(
                                                      //   isExpanded: true,
                                                      //   value: selectedDistributor,
                                                      //   icon: const Align(
                                                      //       alignment: Alignment.topRight,
                                                      //       child: Icon(
                                                      //         Icons.arrow_drop_down,
                                                      //         size: 24,
                                                      //       )),
                                                      //   elevation: 16,
                                                      //   style: TextStyle(
                                                      //       color: Colors.black,
                                                      //       fontWeight:
                                                      //           Constant.fontWeight500),
                                                      //   decoration: InputDecoration(
                                                      //       contentPadding:
                                                      //           const EdgeInsets.symmetric(
                                                      //               horizontal: 12.0,
                                                      //               vertical: 0.0),
                                                      //       focusedBorder: OutlineInputBorder(
                                                      //           borderRadius: BorderRadius.only(
                                                      //               topLeft: Radius.circular(
                                                      //                   borderRadiusTLBR),
                                                      //               topRight: Radius.circular(
                                                      //                   borderRadiusTRBL),
                                                      //               bottomLeft: Radius.circular(
                                                      //                   borderRadiusTRBL),
                                                      //               bottomRight:
                                                      //                   Radius.circular(
                                                      //                       borderRadiusTLBR)),
                                                      //           borderSide: BorderSide(
                                                      //               color: borderColor!,
                                                      //               width: 1.5)),
                                                      //       border: OutlineInputBorder(
                                                      //           borderRadius: BorderRadius.only(
                                                      //               topLeft: Radius.circular(borderRadiusTLBR),
                                                      //               topRight: Radius.circular(borderRadiusTRBL),
                                                      //               bottomLeft: Radius.circular(borderRadiusTRBL),
                                                      //               bottomRight: Radius.circular(borderRadiusTLBR)),
                                                      //           borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                      //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                      //       filled: true,
                                                      //       // hintStyle: TextStyle(color: Colors.grey[800]),
                                                      //       labelText: labelTxt,
                                                      //       labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                                      //       fillColor: fillColor),
                                                      //   onChanged:
                                                      //       (DistributorList? newValue) {
                                                      //     setState(() {
                                                      //       selectedDistributor =
                                                      //           newValue!;
                                                      //     });
                                                      //     BlocProvider.of<
                                                      //                 CustomerLedgerBloc>(
                                                      //             context)
                                                      //         .add(LoadLedgerData(
                                                      //             userId: Constants
                                                      //                 .AUTH_USERID,
                                                      //             dealerId:
                                                      //                 selectedDistributor!
                                                      //                     .employeeCode!));
                                                      //   },
                                                      //   items: distributorList.map<
                                                      //           DropdownMenuItem<
                                                      //               DistributorList>>(
                                                      //       (value) {
                                                      //     return DropdownMenuItem<
                                                      //         DistributorList>(
                                                      //       value: value,
                                                      //       child: Text(
                                                      //           value.employeeName!,
                                                      //           overflow:
                                                      //               TextOverflow.visible),
                                                      //     );
                                                      //   }).toList(),
                                                      // )
                                                      );
                                                }),
                                                CommonText(
                                                  name: Constants.DEALER_NAME,
                                                  fontSize: Constant.fontSize13,
                                                  fontColor: Constant.colorBlack,
                                                  fontWeight: Constant.fontWeight600,
                                                ),
                                                // CommonText(
                                                //   name: "Kolkata, West Bengal - 100102",
                                                //   fontSize: Constant.fontSize12,
                                                //   fontColor: Constant.colorLightGray,
                                                // ),
                                              ],
                                            ),
                                          ))),
                                  Container(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    margin: const EdgeInsets.only(left: 8, right: 8),
                                    height: screenHeight * 0.15,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Stack(children: [
                                      SvgPicture.asset(
                                        Constant.customerLedgerImage!,
                                        height: screenHeight * 0.15,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 120),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CommonText(
                                              name: "Outstanding Balance",
                                              fontSize: Constant.fontSize14,
                                              fontColor: Constant.colorBlack,
                                            ),
                                            CommonText(
                                              name: "Rs." + ledgerInfo.currentBalance.abs().toStringAsFixed(2),
                                              fontSize: Constant.fontSize23,
                                              fontWeight: Constant.fontWeight600,
                                              fontColor: ledgerInfo.transactionType == 1 ? Constant.colorGreencc : Constant.colorBtn,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 8, right: 8),
                                      height: screenHeight * 0.85,
                                      child: SingleChildScrollView(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(1),
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: ledgerInfo.customerLedger.length,
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.85,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    dense: true,
                                                    minLeadingWidth: 8,
                                                    contentPadding: const EdgeInsets.all(0),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          const Icon(
                                                            Icons.calendar_today_outlined,
                                                            size: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                          Padding(
                                                              padding: const EdgeInsets.only(left: 5, top: 2),
                                                              child: CommonText(
                                                                name: DateTimeUtils().dateToServerToDateFormat(
                                                                    ledgerInfo.customerLedger[index].postingDate, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MM_YYYY_Format),
                                                                fontSize: Constant.fontSize14,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight500,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    subtitle: CommonText(
                                                      name: ledgerInfo.customerLedger[index].transactionType == 1
                                                          ? "Credited from " + ledgerInfo.customerLedger[index].reference
                                                          : "Debited from " + ledgerInfo.customerLedger[index].reference,
                                                      fontSize: Constant.fontSize12,
                                                      fontColor: Constant.colorLightGray,
                                                    ),
                                                    trailing: CommonText(
                                                      name: "Rs. " + ledgerInfo.customerLedger[index].transactionAmount.abs().toStringAsFixed(2),
                                                      fontSize: Constant.fontSize16,
                                                      fontColor: ledgerInfo.customerLedger[index].transactionType == 1 ? Constant.colorGreencc : Constant.colorBtn,
                                                      fontWeight: Constant.fontWeight600,
                                                    ),
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                    // color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ))
                                ],
                              ))),
                    ),
                    progressBar
                  ],
                ),
                bottomNavigationBar: Visibility(
                    visible: true,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                        child: SizedBox(
                            height: 15,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: CommonText(
                                  name: "Note: Refreshes every 30 mins.",
                                  fontSize: Constant.fontSize13,
                                  fontColor: Constant.colorOrange,
                                  fontWeight: Constant.fontWeight600,
                                ))))))));
  }
}
