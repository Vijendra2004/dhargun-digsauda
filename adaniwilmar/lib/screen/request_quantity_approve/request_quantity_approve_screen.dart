import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/daily_rate_response.dart';
import '../../models/qa_list_model.dart';
import '../../models/request_quantity_status_update_req.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';
import 'bloc/request_quantity_approve_bloc.dart';
import 'bloc/request_quantity_approve_event.dart';
import 'bloc/request_quantity_approve_state.dart';

class RequestedQuantityApproveScreen extends StatelessWidget {
  QAListResponseValue? qa = QAListResponseValue();

  RequestedQuantityApproveScreen({Key? key, this.qa}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => RequestedQuantityApproveScreen(qa: QAListResponseValue()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child: AssignedQuallityAllocation(qa: qa),
    );
  }

  RequestedQuantityApproveBloc _getInitialLoadData() {
    RequestedQuantityApproveBloc todayRateBloc = RequestedQuantityApproveBloc();
    return todayRateBloc;
  }
}

class AssignedQuallityAllocation extends StatefulWidget {
  QAListResponseValue? qa = QAListResponseValue();

  AssignedQuallityAllocation({Key? key, this.qa}) : super(key: key);

  @override
  State<AssignedQuallityAllocation> createState() => _AssignedQuallityAllocationState();
}

class _AssignedQuallityAllocationState extends State<AssignedQuallityAllocation> with TickerProviderStateMixin {
  String assignedFromDate = "-";
  String assignedToDate = "-";
  TabController? tabController;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  SalesOrganization? selectedStatus;
  final _quantityController = TextEditingController();

  get handleOk => null;
  int selectedTab = 0;
  List<SalesOrganization> statusList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);
    statusList.add(SalesOrganization(id: 0, salesOrganizationName: "Select Status"));
    statusList.add(SalesOrganization(id: Constants.APPROVED_REQUEST, salesOrganizationName: "Approve"));
    statusList.add(SalesOrganization(id: Constants.REJECTED_REQUEST, salesOrganizationName: "Reject"));
    if (Constants.NHMANAGER != Constants.AUTH_ROLEID) {
      statusList.add(SalesOrganization(id: Constants.REQUEST_FOR_APPROVAL, salesOrganizationName: "Request for Approval"));
    }
    selectedStatus = statusList[0];

    _quantityController.text = widget.qa!.quantity != null ? widget.qa!.quantity.toString() : "";
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var ctx = context;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<RequestedQuantityApproveBloc, RequestedQuantityApproveState>(
        listener: (context, state) {
          if (state is OnSaveSuccess) {
            Utils().showSuccessDlg(context, "Quantity Requested", "Quantity Requested Status", successText: "Updated Successfully", closeScreen: true);
          } else if (state is OnFailure) {
            Utils().showSuccessDlg(context, "Error", "Error", successText: state.error);
          } else if (state is ShowProgressBar) {
            _handler!.show!();
          } else if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Request Quantity Approval",
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
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: SingleChildScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      child: CurveBorderBox(
                          boxLRPadding: 10,
                          boxofWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              quantityDetailTextWidget("Oil Type", widget.qa?.oilTypeName != null ? widget.qa!.oilTypeName.toString() : "-"),
                              Constants.AUTH_ROLEID == Constants.ZHMANAGER || Constants.AUTH_ROLEID == Constants.NHMANAGER
                                  ? Column(children: [
                                      SizedBox(height: Constant.headingSix),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: CommonText(
                                          name: "Quantity",
                                          fontColor: Constant.colorDullGray77,
                                          fontSize: Constant.fontSize13,
                                        ),
                                      ),
                                      SizedBox(height: Constant.headingSix),
                                      TextFormField(
                                          controller: _quantityController,
                                          keyboardType: const TextInputType.numberWithOptions(
                                            decimal: true,
                                            signed: false,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                            TextInputFormatter.withFunction((oldValue, newValue) {
                                              final text = newValue.text;
                                              return text.isEmpty
                                                  ? newValue
                                                  : double.tryParse(text) == null
                                                  ? oldValue
                                                  : newValue;
                                            }),
                                          ],
                                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: Constant.fontWeight400),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                                              borderSide: BorderSide(color: Colors.black, width: 1),
                                            ),
                                            enabled: true,
                                          )),
                                    ])
                                  : quantityDetailTextWidget("Quantity", widget.qa?.quantity != null ? widget.qa!.quantity.toString() : "-"),
                              quantityDetailTextWidget("Request By", widget.qa?.createdBy != null ? widget.qa!.createdBy.toString() : "-"),
                              quantityDetailTextWidget("Requested Status", widget.qa?.status != null ? widget.qa!.status.toString() : "-"),
                              const SizedBox(height: 16),
                              AbsorbPointer(
                                  absorbing: ((widget.qa!.id ?? 0) != 0) ? true : false,
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: CommonDropdownButtonFormField<SalesOrganization>(
                                        label: "Status",
                                        value: selectedStatus,
                                        onChanged: (SalesOrganization? newValue) {
                                          setState(() {
                                            selectedStatus = newValue!;
                                          });
                                        },
                                        items: statusList.map<DropdownMenuItem<SalesOrganization>>((value) {
                                          return DropdownMenuItem<SalesOrganization>(
                                            value: value,
                                            child: Text(value.salesOrganizationName ?? ""),
                                          );
                                        }).toList(),
                                      ))),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CommonButton(
                                      buttonName: "Cancel",
                                      buttonNameSize: Constant.pricbuttonNameSize,
                                      buttonNameColor: Constant.textFormFieldColor,
                                      buttonColor: Colors.white,
                                      buttonHeight: Constant.pricbuttonHeight,
                                      buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                      buttonRadiusBL: Constant.pricbutRadiusBL,
                                      buttonBorder: Colors.black,
                                      buttonFunction: () {
                                        Navigator.pop(ctx);
                                      }),
                                  CommonButton(
                                      buttonName: "Submit",
                                      buttonNameSize: Constant.pricbuttonNameSize,
                                      buttonNameColor: Constant.pricbuttonTxtColor,
                                      buttonColor: Constant.pricbuttonColor,
                                      buttonHeight: Constant.pricbuttonHeight,
                                      buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                      buttonRadiusBL: Constant.pricbutRadiusBL,
                                      buttonBorder: Colors.transparent,
                                      buttonFunction: () {
                                        submitRequestQuantity();
                                      })
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          )))),
              progressBar
            ],
          ),
        )));
  }

  Widget quantityDetailTextWidget(String heading, String contentValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: Constant.headingSix),
        CommonText(
          name: heading,
          fontColor: Constant.colorDullGray77,
          fontSize: Constant.fontSize13,
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(Constant.headingSix!),
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Constant.textFormEnaBorCol!,
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                bottomRight: const Radius.circular(10),
              )),
          child: CommonText(
            name: contentValue,
            fontColor: Colors.grey.withOpacity(0.8),
            fontSize: Constant.fontSize13,
          ),
        ),
      ],
    );
  }

  void submitRequestQuantity() {
    if (selectedStatus?.salesOrganizationName == statusList[0].salesOrganizationName) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select status");
    } else {
      double updateQuantity = double.parse(_quantityController.text.isNotEmpty ? _quantityController.text.toString() : "0");
      RequestQuantityStatusUpdateReq requestQuantityStatusUpdateReq = RequestQuantityStatusUpdateReq();
      List<int> quantityIds = [];
      quantityIds.add(widget.qa!.id!);
      requestQuantityStatusUpdateReq.statusId = selectedStatus?.id;
      requestQuantityStatusUpdateReq.quantityRequestIds = quantityIds;
      requestQuantityStatusUpdateReq.loginUserId = Constants.AUTH_USERID;
      requestQuantityStatusUpdateReq.roleId = Constants.AUTH_ROLEID;
      requestQuantityStatusUpdateReq.parentQuantityId = 0;
      requestQuantityStatusUpdateReq.remainingQuantity = 0;
      requestQuantityStatusUpdateReq.remarks = "";
      requestQuantityStatusUpdateReq.updateQuantity = updateQuantity;
      BlocProvider.of<RequestedQuantityApproveBloc>(context).add(SaveQuantityRequest(requestQuantityStatusUpdateReq: requestQuantityStatusUpdateReq));
    }
  }
}
