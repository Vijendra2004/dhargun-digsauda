import 'dart:io';

import 'package:adaniwilmar/models/AccountStatementRequest.dart';
import 'package:adaniwilmar/screen/account_statement/bloc/account_statement_bloc.dart';
import 'package:adaniwilmar/screen/account_statement/bloc/account_statement_state.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/AccountStatementResponse.dart';
import '../../utils/constant.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/widget.dart';
import 'bloc/account_statement_event.dart';

class AccountStatementScreen extends StatelessWidget {
  const AccountStatementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountStatementBloc()
        ..add(AccountDataEvent())
        ..add(AccountStatementCountEvent()),
      child: const AccountStatementData(),
    );
  }
}

class AccountStatementData extends StatefulWidget {
  const AccountStatementData({Key? key}) : super(key: key);

  @override
  State<AccountStatementData> createState() => _AccountStatementDataState();
}

class _AccountStatementDataState extends State<AccountStatementData> {
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  var companyCodeController = TextEditingController();
  var customerCodeController = TextEditingController();
  var currencyController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  String? dateValidationDays;

  bool checkedValuePDF = false;
  bool checkedValueExcel = false;
  bool isSubmit = false;
  int requestId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fromDateController.text = DateTimeUtils()
        .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);

    _toDateController.text = DateTimeUtils()
        .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    companyCodeController.text = Constants.awlAgriBussiness;
    customerCodeController.text = Constants.AUTH_USER_NAME;
    currencyController.text = "INR";
    //9010



    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<AccountStatementBloc, AccountStatementState>(
        listener: (context, state) {
          if (state is AccountStatementLoadProgress) {
            _handler!.show!();
          }
          if (state is AccountStatementHideProgress) {
            _handler!.dismiss!();
          }
          if (state is LoadAccountStatementData) {
            _handler!.dismiss!();
            /* dateValidationDays = state.response.value!;
            if (dateValidationDays != null) {
              DateTime myDate = DateTime.now();
              DateTime myDateWithSixMonthsAdded =
                  myDate.add(Duration(days: -int.parse(dateValidationDays!)));
              _fromDateController.text = DateTimeUtils().dateToStringFormat(
                  myDateWithSixMonthsAdded, DateTimeUtils.DD_MM_YYYY_Format);
            }*/

            // setState(() {});
          }

          if (state is AccountStatementCountUpdate) {
            BlocProvider.of<AccountStatementBloc>(context)
                .add(AccountStatementCountEvent());

            CustomerStatement customerStatement = CustomerStatement();
            customerStatement.requestID = "$requestId";
            customerStatement.companyCode = "9010";
            customerStatement.customer = Constants.AUTH_DEALER_CODE;
            customerStatement.dateFrom = DateFormat('yyyy-MM-dd').format(
                DateFormat('dd-MM-yyyy')
                    .parse(_fromDateController.text.toString()));
            customerStatement.dateTo = DateFormat('yyyy-MM-dd').format(
                DateFormat('dd-MM-yyyy')
                    .parse(_toDateController.text.toString()));
            customerStatement.currency = currencyController.text.toString();

            customerStatement.withoutSpecialGL = "";
            customerStatement.withSpecialGL = "";
            customerStatement.withSpecialGLAOnly = "";
            customerStatement.withSpecialGLHOnly = "";
            customerStatement.withSpecialGL3Only = "";
            customerStatement.withSpecialGL4Only = "";

            customerStatement.email = "";
            customerStatement.excel = "";
            customerStatement.pDF = "";

            BlocProvider.of<AccountStatementBloc>(context).add(
                CustomerStatementEvent(customerStatement: customerStatement));
          }

          if (state is AccountStatementSubmitResponse) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Statement request sent successfully")));
            Navigator.pop(context);
          }

          if (state is LoanAccountStatementDataCount) {
            AccountStatements accountStatements =
                state.response.accountStatements ?? AccountStatements();
            if (accountStatements.countLimit != null) {
              int totalCount = accountStatements.totalcount ?? 0;
              String countLimit = accountStatements.countLimit ?? "0";
              requestId = accountStatements.requestId ?? 0;
              int countLimitInt = int.parse(countLimit);

              GMLogger.v("totalCount is $totalCount");
              GMLogger.v("countLimitInt is $countLimitInt");

              setState(() {
                if (totalCount >= countLimitInt) {
                  isSubmit = false;
                } else {
                  isSubmit = true;
                }
                //isSubmit = true;
              });
            }
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Account Statement",
            backArrow: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                // Visibility(
                //   visible: false,
                //   child: Center(
                //     child: Image.asset(
                //       'assets/images/underConstruction.png',
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: true,
                  child: Container(
                    height: screenHeight,
                    margin: EdgeInsets.only(top: Platform.isIOS ? 90 : 70),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: CurveOuterBox(
                          boxLRPadding: 0,
                          boxTBPadding: 0,
                          boxofWidget: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Company Name",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: Constant.fontWeight600,
                                        fontFamily: 'Aganè')),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: companyCodeController,
                                  onChanged: (value) {},
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: Constant.fontWeight400),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text("Customer Name",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: Constant.fontWeight600,
                                        fontFamily: 'Aganè')),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: customerCodeController,
                                  onChanged: (value) {},
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: Constant.fontWeight400),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("From Date",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                  fontFamily: 'Aganè')),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _selectFromDate(context);
                                            },
                                            child: TextFormField(
                                              controller: _fromDateController,
                                              onChanged: (value) {},
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      Constant.fontWeight400),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1),
                                                ),
                                                enabled: false,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("To Date",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      Constant.fontWeight600,
                                                  fontFamily: 'Aganè')),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _selectToDate(context);
                                            },
                                            child: TextFormField(
                                              controller: _toDateController,
                                              onChanged: (value) {},
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      Constant.fontWeight400),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1),
                                                ),
                                                enabled: false,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text("Currency",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: Constant.fontWeight600,
                                        fontFamily: 'Aganè')),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: currencyController,
                                  onChanged: (value) {},
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: Constant.fontWeight400),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Radio<String>(
                                      activeColor: Colors.orange,
                                      value: "Without Special GL",
                                      groupValue: "Without Special GL",
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                    Text("Without Special GL",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: Constant.fontWeight400,
                                            fontFamily: 'Aganè')),
                                  ],
                                ),
                                Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                              activeColor: Colors.orange,
                                              checkColor: Colors.white,
                                              value: checkedValuePDF,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkedValuePDF = value!;
                                                  checkedValueExcel = !value;
                                                });
                                              }),
                                          Text("PDF",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      Constant.fontWeight400,
                                                  fontFamily: 'Aganè')),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                              value: checkedValueExcel,
                                              activeColor: Colors.orange,
                                              checkColor: Colors.white,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkedValueExcel = value!;
                                                  checkedValuePDF = !value;
                                                });
                                              }),
                                          Text("Excel",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      Constant.fontWeight400,
                                                  fontFamily: 'Aganè')),
                                        ],
                                      ),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: SizedBox(
                                    width: screenWidth,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.orange)),
                                        onPressed: () {
                                          if (!checkedValuePDF &&
                                              !checkedValueExcel) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Please choose Document type")));
                                          }else if(_fromDateController.text.isEmpty || _toDateController.text.isEmpty){
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please choose From/To date")));
                                          }
                                          else {
                                            AccountStatementRequest request =
                                                AccountStatementRequest();
                                            request.id = Constants.AUTH_USERID;
                                            request.loginUserId =
                                                Constants.AUTH_USERID;
                                            request.fromDate =
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateFormat('dd-MM-yyyy')
                                                        .parse(
                                                            _fromDateController
                                                                .text
                                                                .toString()));
                                            request.toDate =
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateFormat('dd-MM-yyyy')
                                                        .parse(_toDateController
                                                            .text
                                                            .toString()));

                                            request.companyName =
                                                companyCodeController.text
                                                    .toString();
                                            request.customerName =
                                                customerCodeController.text
                                                    .toString();
                                            request.currency =
                                                currencyController.text
                                                    .toString();
                                            request.isWithoutSpecialGL = true;
                                            request.isActive = false;
                                            request.documentType =
                                                checkedValuePDF ? 1 : 2;

                                            BlocProvider.of<
                                                        AccountStatementBloc>(
                                                    context)
                                                .add(AccountStatementSubmit(
                                                    accountStatementRequest:
                                                        request));
                                          }
                                        },
                                        child: const Text("Submit")),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ),

                progressBar
              ],
            ),
          ),
        ));
  }

  _selectFromDate(BuildContext context) async {
    DateTime? toDate = _toDateController.text.isNotEmpty?DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
        _toDateController.text.toString(),
        DateTimeUtils.DD_MM_YYYY_Format,
        DateTimeUtils.YYYY_MM_DD_Format)) : DateTime.now();
    DateTime? fromDateVal = _fromDateController.text.isNotEmpty?DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
        _fromDateController.text.toString(),
        DateTimeUtils.DD_MM_YYYY_Format,
        DateTimeUtils.YYYY_MM_DD_Format)) : DateTime.now().subtract(const Duration(days: 10));
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate:fromDateVal ,
        firstDate: DateTime(2000),
        lastDate: _toDateController.text.isNotEmpty
            ? toDate
            : DateTime.now().add(const Duration(days: 0)));
    if (selected != null) {
      _fromDateController.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      _toDateController.text = "";

      /*if (dateValidationDays != null) {
        DateTime today = DateTime.now();
        DateTime dateWithValidateDays =
            selected.add(Duration(days: int.parse(dateValidationDays!)));
        if (today.compareTo(dateWithValidateDays) == 0) {
          _toDateController.text = DateTimeUtils()
              .dateToStringFormat(today, DateTimeUtils.DD_MM_YYYY_Format);
        }

        if (today.compareTo(dateWithValidateDays) < 0) {
          _toDateController.text = DateTimeUtils()
              .dateToStringFormat(today, DateTimeUtils.DD_MM_YYYY_Format);
        }

        if (today.compareTo(dateWithValidateDays) > 0) {
          _toDateController.text = DateTimeUtils().dateToStringFormat(
              dateWithValidateDays, DateTimeUtils.DD_MM_YYYY_Format);
        }
      }*/
    }
  }

  _selectToDate(BuildContext context) async {
    bool isAfter = false;
    DateTime fromDate = DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
        _fromDateController.text.toString(),
        DateTimeUtils.DD_MM_YYYY_Format,
        DateTimeUtils.YYYY_MM_DD_Format));

    DateTime fromAfter366Days = fromDate.add(Duration(days: 366));

    if(fromAfter366Days.isAfter(DateTime.now())){
      isAfter = true;
    }else {
      isAfter = false;
    }

    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromDateController.text.isNotEmpty
            ? fromDate
            : DateTime.now(), // Default initial date if fromDate is empty

        firstDate:
            _fromDateController.text.isNotEmpty ? fromDate : DateTime.now(),
        lastDate:isAfter?DateTime.now():
        _fromDateController.text.isNotEmpty
            ? fromDate.add(Duration(days: 366))
            : DateTime.now());

    if (selected != null) {
      _toDateController.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);

      DateTime today = DateTime.now();
    }
  }
}
