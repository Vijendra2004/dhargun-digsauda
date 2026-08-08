import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/screen/customer_ledger/bloc/bloc.dart';
import 'package:adaniwilmar/screen/state_trader_filter/state_trader_filter.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constant.dart';
import '../../models/modals.dart';
import '../../widget/widget.dart';

class CallToCustomer extends StatelessWidget {
  const CallToCustomer({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const CallToCustomer());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerLedgerBloc()
        ..add(LoadCallToCustomer(userId: Constants.AUTH_USERID, dealerId: 0)),
      child: CallToCustomerDetail(distributorList: []),
    );
  }
}

class CallToCustomerDetail extends StatefulWidget {
  List<CallToCustomerList> distributorList = [];
  List<CallToCustomerList> distributorSearchList = [];

  CallToCustomerDetail({required this.distributorList, Key? key})
      : super(key: key);

  @override
  State<CallToCustomerDetail> createState() => _CallToCustomerDetailState();
}

class _CallToCustomerDetailState extends State<CallToCustomerDetail> {
  List<CallToCustomerModel> customerList = [];
  BdoList? selectedBdo;
  StateTraderFilterWidget? tradeFilter;
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    tradeFilter = StateTraderFilterWidget(
      resultFunction: (var value) {
        selectedBdo = value;
        BlocProvider.of<CustomerLedgerBloc>(context).add(LoadCallToCustomer(
            userId: Constants.AUTH_USERID,
            dealerId: 0,
            bdoIds: selectedBdo!.id == 0 ? [] : [selectedBdo!.id!]));
      },
      onLoad: (var value) {},
    );
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
          if (state is OnLoadCallToCustomerSuccess) {
            widget.distributorList = state.distributorList;
            // customerList = [];
            // for (CallToCustomerList d in widget.distributorList) {
            //   CallToCustomerModel c = CallToCustomerModel(
            //       name: d.dealerName!,
            //       subName: d.mobileNumber ?? "",
            //       amt: "#" + (d.dealerCode ?? ""));
            //   customerList.add(c);
            // }
            setState(() {});
          }
          if (state is OnSaveSuccess) {
            if (state.mobileNumber != null && state.mobileNumber != "") {
              _launchUrl(state.mobileNumber);
            }
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
              title: (Constants.AUTH_ROLEID == Constants.DEALER)
                  ? "Call to State Trader"
                  : "Call to Customer",
              backArrow: true),
          body: Stack(
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
                  boxofWidget: SizedBox(
                    height: screenHeight,
                    width: screenWidth,
                    child: Column(
                      children: [
                        tradeFilter != null
                            ? tradeFilter!
                            : const Visibility(
                                visible: false, child: Text("State Trade")),
                        ListTile(
                          leading: const Icon(Icons.search),
                          title: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                hintText: 'Search', border: InputBorder.none),
                            onChanged: onSearchTextChanged,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              searchController.clear();
                              onSearchTextChanged('');
                            },
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                              height: tradeFilter != null
                                  ? screenHeight * 0.79
                                  : screenHeight * 0.89,
                              width: screenWidth,
                              child: SingleChildScrollView(
                                  child: widget.distributorSearchList
                                              .isNotEmpty ||
                                          searchController.text.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 0,
                                              left: 0,
                                              right: 0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: widget
                                              .distributorSearchList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
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
                                                  BlocProvider.of<
                                                              CustomerLedgerBloc>(
                                                          context)
                                                      .add(SaveCallToCustomer(
                                                          BDOId: Constants
                                                              .AUTH_USERID,
                                                          dealerMobileNumber: widget
                                                              .distributorSearchList[
                                                                  index]
                                                              .mobileNumber!,
                                                          dealerId: widget
                                                              .distributorSearchList[
                                                                  index]
                                                              .dealerId!));
                                                },
                                                dense: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 8, 0),
                                                horizontalTitleGap: 0,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: -4,
                                                        vertical: 0),
                                                leading: Container(
                                                  height: 40,
                                                  width: 4,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Constant.colorOrange,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                ),
                                                title: Text(
                                                  Constants.DEALER ==
                                                          Constants.AUTH_ROLEID
                                                      ? widget
                                                          .distributorSearchList[
                                                              index]
                                                          .bdoName!
                                                      : widget
                                                          .distributorSearchList[
                                                              index]
                                                          .dealerName!,
                                                  style: TextStyle(
                                                      fontSize:
                                                          Constant.fontSize15,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600),
                                                ),
                                                subtitle: widget
                                                            .distributorSearchList[
                                                                index]
                                                            .mobileNumber !=
                                                        null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                              width: 13,
                                                              height: 16,
                                                              child: Constant
                                                                  .phone),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Text(
                                                                widget
                                                                    .distributorSearchList[
                                                                        index]
                                                                    .mobileNumber!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: Constant
                                                                      .fontSize12,
                                                                  color: Constant
                                                                      .colorLightGray,
                                                                )),
                                                          )
                                                        ],
                                                      )
                                                    : null,
                                                trailing: Text(
                                                    "#" +
                                                        (widget
                                                                .distributorSearchList[
                                                                    index]
                                                                .dealerCode ??
                                                            ""),
                                                    style: TextStyle(
                                                      fontSize:
                                                          Constant.fontSize13,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600,
                                                    )),
                                              ),
                                            );
                                          })
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 0,
                                              left: 0,
                                              right: 0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              widget.distributorList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
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
                                                  BlocProvider.of<
                                                              CustomerLedgerBloc>(
                                                          context)
                                                      .add(SaveCallToCustomer(
                                                          BDOId: Constants
                                                              .AUTH_USERID,
                                                          dealerMobileNumber: widget
                                                              .distributorList[
                                                                  index]
                                                              .mobileNumber!,
                                                          dealerId: widget
                                                              .distributorList[
                                                                  index]
                                                              .dealerId!));
                                                },
                                                dense: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 8, 0),
                                                horizontalTitleGap: 0,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: -4,
                                                        vertical: 0),
                                                leading: Container(
                                                  height: 40,
                                                  width: 4,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Constant.colorOrange,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                ),
                                                title: Text(
                                                  Constants.DEALER ==
                                                          Constants.AUTH_ROLEID
                                                      ? widget
                                                          .distributorList[
                                                              index]
                                                          .bdoName!
                                                      : widget
                                                          .distributorList[
                                                              index]
                                                          .dealerName!,
                                                  style: TextStyle(
                                                      fontSize:
                                                          Constant.fontSize15,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600),
                                                ),
                                                subtitle: widget
                                                            .distributorList[
                                                                index]
                                                            .mobileNumber !=
                                                        null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                              width: 13,
                                                              height: 16,
                                                              child: Constant
                                                                  .phone),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Text(
                                                                widget
                                                                    .distributorList[
                                                                        index]
                                                                    .mobileNumber!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: Constant
                                                                      .fontSize12,
                                                                  color: Constant
                                                                      .colorLightGray,
                                                                )),
                                                          )
                                                        ],
                                                      )
                                                    : null,
                                                trailing: Text(
                                                    "#" +
                                                        (widget
                                                                .distributorList[
                                                                    index]
                                                                .dealerCode ??
                                                            ""),
                                                    style: TextStyle(
                                                      fontSize:
                                                          Constant.fontSize13,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600,
                                                    )),
                                              ),
                                            );
                                          })
                                  // ListOfNameSub(
                                  //   listOfCustomer: customerList,
                                  //   headFontSz: Constant.fontSize15,
                                  //   headFontCol: Constant.colorBlack,
                                  //   headFontWei: Constant.fontWeight600,
                                  //   subFontSz: Constant.fontSize12,
                                  //   subFontCol: Constant.colorLightGray,
                                  //   amtFontSz: Constant.fontSize13,
                                  //   amtFontCol: Constant.colorBlack,
                                  //   amtFontWei: Constant.fontWeight600,
                                  //   sbIcon: Constant.phone,
                                  //   sbIconColor: Constant.callToCsbCol1,
                                  //   sbIconSize: Constant.fontSize14),
                                  )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              progressBar
            ],
          ),
        )));
  }

  onSearchTextChanged(String text) async {
    widget.distributorSearchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if (Constants.DEALER == Constants.AUTH_ROLEID) {
      for (var distributor in widget.distributorList) {
        if (distributor.bdoName!.toLowerCase().contains(text.toLowerCase())) {
          setState(() {
            widget.distributorSearchList.add(distributor);
          });
        }
        else{

        }
      }
    } else {
      for (var distributor in widget.distributorList) {
        if (distributor.dealerName!
            .toLowerCase()
            .contains(text.toLowerCase())) {
          setState(() {
            widget.distributorSearchList.add(distributor);
          });
        }
        else{

        }
      }
    }
  }

  Future<void> _launchUrl(phoneno) async {
    var url = Uri.parse("tel:" + phoneno);
    if (!await launchUrl(url)) {
      throw 'Could not launch $phoneno';
    }
  }
}
