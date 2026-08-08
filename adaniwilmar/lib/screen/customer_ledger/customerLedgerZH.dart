import 'package:adaniwilmar/models/customerLedgerNHResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/common_text.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';
import 'bloc/customer_ledger_bloc.dart';
import 'bloc/customer_ledger_event.dart';
import 'bloc/customer_ledger_state.dart';
import 'customerLedgerStateTrader.dart';

class CustomerLedgerZH extends StatelessWidget {
  const CustomerLedgerZH(
      {Key? key,
      required this.selectedCustomerLedgerId,
      this.selectedCustomerLedgerName})
      : super(key: key);
  final int selectedCustomerLedgerId;
  final String? selectedCustomerLedgerName;
  static const String routeName = '/';

  Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => CustomerLedgerNHDetail(
            selectedCustomerLedgerId: selectedCustomerLedgerId,
            selectedCustomerLedgerName: selectedCustomerLedgerName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerLedgerBloc()
        ..add(LoadCustomerLedgerNH(userId: selectedCustomerLedgerId)),
      child: CustomerLedgerNHDetail(
          selectedCustomerLedgerId: selectedCustomerLedgerId,
          selectedCustomerLedgerName: selectedCustomerLedgerName),
    );
  }
}

class CustomerLedgerNHDetail extends StatefulWidget {
  const CustomerLedgerNHDetail(
      {Key? key,
      required this.selectedCustomerLedgerId,
      this.selectedCustomerLedgerName})
      : super(key: key);
  final int selectedCustomerLedgerId;
  final String? selectedCustomerLedgerName;

  @override
  State<CustomerLedgerNHDetail> createState() => _CustomerLedgerNHState();
}

class _CustomerLedgerNHState extends State<CustomerLedgerNHDetail> {
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  CustomerLedgerNHResponse customerLedgerZHResponse = CustomerLedgerNHResponse(
      totalOutStandingBalance: 0,transactionType: 1, customerLedgerNH: []);

  @override
  void initState() {
    super.initState();
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
    return BlocListener<CustomerLedgerBloc, CustomerLedgerState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
          if (state is OnLoadCustomerLedgerSuccess) {
            customerLedgerZHResponse = state.customerLedgerNHResponse;
            setState(() {});
          }
          if (state is OnFailure) {}
        },
        child: SafeArea(
            child: Scaffold(
                primary: false,
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                    title:
                        ['', null].contains(widget.selectedCustomerLedgerName)
                            ? "Customer Ledger"
                            : "Customer Ledger - " +
                                widget.selectedCustomerLedgerName!,
                    backArrow: true),
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: Container(
                        child: Constant.bgImgGlobal,
                      ),
                    ),
                    Container(
                      height: screenHeight,
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
                                  Container(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    margin: const EdgeInsets.only(left: 0, right: 0),
                                    height: screenHeight * 0.15,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                            Constant.customerLedgerImage!,
                                          height: screenHeight * 0.15,
                                        ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 140),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CommonText(
                                              name: "Outstanding Balance",
                                              fontSize: Constant.fontSize14,
                                              fontColor: Constant.colorBlack,
                                            ),
                                            CommonText(
                                              name: "Rs." +
                                                  customerLedgerZHResponse
                                                      .totalOutStandingBalance
                                                      .abs()
                                                      .toStringAsFixed(2),
                                              fontSize: Constant.fontSize23,
                                              fontWeight: Constant.fontWeight600,
                                              fontColor: customerLedgerZHResponse.transactionType == 1
                                                  ? Constant.colorGreencc
                                                  : Constant.colorBtn,
                                            ),
                                          ],
                                        ),
                                      ),]
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      height: screenHeight * 0.82,
                                      child: SingleChildScrollView(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(1),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: customerLedgerZHResponse
                                              .customerLedgerNH!.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => CustomerLedgerStateTrader(
                                                            selectedCustomerLedgerId:
                                                                customerLedgerZHResponse
                                                                    .customerLedgerNH![
                                                                        index]
                                                                    .customerLedgerUserId!,
                                                            selectedCustomerLedgerName:
                                                                customerLedgerZHResponse
                                                                    .customerLedgerNH![
                                                                        index]
                                                                    .customerLedgerUserName),
                                                      ));
                                                },
                                                title: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                              child: CommonText(
                                                            name: customerLedgerZHResponse
                                                                .customerLedgerNH![
                                                                    index]
                                                                .customerLedgerUserName,
                                                            fontSize: Constant
                                                                .fontSize14,
                                                            fontColor: Constant
                                                                .colorBlack,
                                                            fontWeight: Constant
                                                                .fontWeight600,
                                                          )),
                                                          CommonText(
                                                            name: "Rs." +
                                                                customerLedgerZHResponse
                                                                    .customerLedgerNH![
                                                                        index]
                                                                    .totalOutStandingBalance!
                                                                    .abs()
                                                                    .toStringAsFixed(
                                                                        2),
                                                            fontSize: Constant
                                                                .fontSize16,
                                                            fontColor: customerLedgerZHResponse
                                                                        .customerLedgerNH![
                                                                            index].transactionType == 1
                                                                ? Constant
                                                                    .colorGreencc
                                                                : Constant
                                                                    .colorBtn,
                                                            fontWeight: Constant
                                                                .fontWeight600,
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        thickness: 1,
                                                        // color: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ));
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
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 8, right: 8),
                        child: Container(
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
