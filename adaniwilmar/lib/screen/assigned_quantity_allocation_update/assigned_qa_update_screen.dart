import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/Quantity_allocation_create_req.dart';
import '../../models/bdo_list_response.dart';
import '../../models/daily_rate_response.dart';
import '../../models/dealer_response.dart';
import '../../models/qa_list_model.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../../widget/widget.dart';
import 'bloc/asigned_qa_update_event.dart';
import 'bloc/assigned_qa_update_bloc.dart';
import 'bloc/assigned_qa_update_state.dart';

class AssignedQAUpdateScreen extends StatelessWidget {
  QAListResponseValue? qa = QAListResponseValue();

  AssignedQAUpdateScreen({Key? key, this.qa}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => AssignedQAUpdateScreen(qa: QAListResponseValue()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child: AssignedQuallityAllocation(qa: qa),
    );
  }

  AssignedQAUpdateBloc _getInitialLoadData() {
    AssignedQAUpdateBloc todayRateBloc = AssignedQAUpdateBloc();
    todayRateBloc.add(LoadSalesOrganization());
    return todayRateBloc;
  }
}

class AssignedQuallityAllocation extends StatefulWidget {
  QAListResponseValue? qa = QAListResponseValue();

  AssignedQuallityAllocation({Key? key, this.qa}) : super(key: key);

  @override
  State<AssignedQuallityAllocation> createState() =>
      _AssignedQuallityAllocationState();
}

class _AssignedQuallityAllocationState extends State<AssignedQuallityAllocation>
    with TickerProviderStateMixin {
  QAListResponseValue listModel = QAListResponseValue();
  String assignedFromDate = "-";
  String assignedToDate = "-";
  TextEditingController? _oilTypeController;
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Oil Type";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  TextEditingController _quantitycontroller = TextEditingController();
  List<int> selectedEmployeeIds = [];
  List<ZonalEmployeeList> selectedZonalEmployees = [];

  get handleOk => null;
  int selectedTab = 0;
  List<DistributionChannel> distrChannels = [];
  List<SalesOrganization> salesOrgList = [];
  List<BdoList> employeeList = [];
  List<ZonalEmployeeList> zonalEmployeeList = [];
  List<BdoList> selectedMaterials = [];
  List<int> selectedMaterialIds = [];

  List<BdoList> selectedEmployees = [];
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _employeeController = TextEditingController();

  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);
    indicatorColor = colors[0];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var ctx = context;
    void showCustomAlertDialog(BuildContext context, messageValue, title,
        handleOk, Null Function() param4,
        {bool? hideCancelBtn = false,
        String? successText = 'OK',
        Color? titleColor = Colors.white,
        String type = "",
        double givenQty = 0,
        double availableQty = 0,
        int specialityLimitId = 0,
        int oilTypeId = 0,
        int skuId = 0}) {
      // set up the button
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
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
        content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Type",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      type,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Given Qty",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              givenQty.toString() + "MT",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ))
                      ]),
                      Visibility(
                          visible: Constants.AUTH_ROLEID != Constants.SALE,
                          child: Column(children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Available Qty",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  availableQty.toString() + "MT",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ))
                          ]))
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CommonTextFormField(
                      labeltxt: "Required Quantity(MT)",
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
                      controllerTxt: _quantitycontroller,
                      keyborType: TextInputType.number,
                      inputFormatter: [
                        new FilteringTextInputFormatter.deny(RegExp("[\\-]"))
                      ],
                    ))
              ],
            )),
        actions: [
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
                  buttonFunction: () {})
            ],
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<AssignedQAUpdateBloc, AssignedQAUpdateState>(
        listener: (context, state) {
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            if ((widget.qa!.id ?? 0) != 0) {
              BlocProvider.of<AssignedQAUpdateBloc>(context)
                  .add(LoadQAItemFetch(id: widget.qa!.id ?? 0));
            }
            setState(() {});
          } else if (state is OnLoadQAItemFetch) {
            listModel = state.listModel;
            assignedFromDate = DateTimeUtils().dateToStringFormat(
                DateTime.parse((listModel.validFrom ?? "").split("T")[0]),
                DateTimeUtils.DD_MM_YYYY_Format);
            assignedToDate = DateTimeUtils().dateToStringFormat(
                DateTime.parse((listModel.validTo ?? "").split("T")[0]),
                DateTimeUtils.DD_MM_YYYY_Format);
            BlocProvider.of<AssignedQAUpdateBloc>(context).add(
                LoadZonalEmployees(
                    salesOrganizationId: listModel.salesOrganizationId ?? 0,
                    distributionChannelId: listModel.distributionChannelId ?? 0,
                    divisonId: listModel.verticleId ?? 0));
            BlocProvider.of<AssignedQAUpdateBloc>(context).add(
                LoadDistributionChannel(
                    id: listModel.salesOrganizationId ?? 0));
            setState(() {});
          } else if (state is OnSaveSuccess) {
            Utils().showSuccessDlg(
                context, "Quantity Assigned", "Quantity Assigned",
                successText: "Successfully", closeScreen: true);
          } else if (state is OnFailure) {
            Utils().showSuccessDlg(context, "Error", "Error",
                successText: state.error);
          } else if (state is ShowProgressBar) {
            _handler!.show!();
          } else if (state is HideProgressBar) {
            _handler!.dismiss!();
          } else if (state is OnLoadZonalEmployees) {
            selectedZonalEmployees = [];
            selectedEmployeeIds = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE)
                ? Constants.SELECT_DISTRIBUTOR
                : Constants.SELECT_EMPLOYEES;
            zonalEmployeeList = state.zoanlEmpList;

            if ((widget.qa!.id ?? 0) != 0) {
              List<String>? result = (listModel.customerId)?.split(",");
              for (var v in result!) {
                ZonalEmployeeList ite = ZonalEmployeeList();
                ite.id = int.parse(v);
                selectedEmployeeIds.add(ite.id ?? 0);
                selectedZonalEmployees.add(ite);
              }
              _employeeController.text =
                  selectedEmployeeIds.length.toString() + " Item(s) selected";
              _quantitycontroller.text = listModel.remainingQuantity.toString();
              _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(
                  DateTime.parse((listModel.validFrom ?? "").split("T")[0]),
                  DateTimeUtils.DD_MM_YYYY_Format);
              _todatecontroller.text = DateTimeUtils().dateToStringFormat(
                  DateTime.parse((listModel.validFrom ?? "").split("T")[0]),
                  DateTimeUtils.DD_MM_YYYY_Format);
            }
            setState(() {});
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Assigned Quantity",
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
                              CommonText(
                                name: "Assigned Quantity Limit",
                                fontColor: Constant.colorBlack,
                                fontSize: Constant.fontSize18,
                              ),
                              quantityDetailTextWidget(
                                  "Sales Organization",
                                  listModel.salesOrganizationName != null
                                      ? listModel.salesOrganizationName
                                          .toString()
                                      : "-"),
                              quantityDetailTextWidget(
                                  "Distribution Channel",
                                  listModel.distributionChannelName != null
                                      ? listModel.distributionChannelName
                                          .toString()
                                      : "-"),
                              quantityDetailTextWidget(
                                  "Division",
                                  listModel.divisionName != null
                                      ? listModel.divisionName.toString()
                                      : "-"),
                              quantityDetailTextWidget(
                                  "Oil Type",
                                  listModel.oilTypeName != null
                                      ? listModel.oilTypeName.toString()
                                      : "-"),
                              quantityDetailTextWidget(
                                  "Quantity Limit (MT)",
                                  listModel.actualDiscount != null
                                      ? listModel.actualDiscount.toString()
                                      : "-"),
                              Container(
                                margin:
                                    EdgeInsets.only(top: Constant.headingSix!),
                                width: screenWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Valid From",
                                            fontColor: Constant.colorDullGray77,
                                            fontSize: Constant.fontSize13,
                                          ),
                                          Container(
                                            width: screenWidth,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.all(
                                                Constant.headingSix!),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.5,
                                                  color: Constant
                                                      .textFormEnaBorCol!,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(10),
                                                  topRight: Radius.circular(Constant
                                                      .textFormborderRadiusBR!),
                                                  bottomLeft: Radius.circular(
                                                      Constant
                                                          .textFormborderRadiusBR!),
                                                  bottomRight:
                                                      const Radius.circular(10),
                                                )),
                                            child: CommonText(
                                              name: assignedFromDate,
                                              fontColor: Colors.grey.withOpacity(0.8),
                                              fontSize: Constant.fontSize13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      flex: 1,
                                    ),
                                    SizedBox(width: Constant.headingSix!),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            name: "Valid To",
                                            fontColor: Constant.colorDullGray77,
                                            fontSize: Constant.fontSize13,
                                          ),
                                          Container(
                                            width: screenWidth,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.all(
                                                Constant.headingSix!),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.5,
                                                  color: Constant
                                                      .textFormEnaBorCol!,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(10),
                                                  topRight: Radius.circular(Constant
                                                      .textFormborderRadiusBR!),
                                                  bottomLeft: Radius.circular(
                                                      Constant
                                                          .textFormborderRadiusBR!),
                                                  bottomRight:
                                                      const Radius.circular(10),
                                                )),
                                            child: CommonText(
                                              name: assignedToDate,
                                              fontColor: Colors.grey.withOpacity(0.8),
                                              fontSize: Constant.fontSize13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              quantityDetailTextWidget(
                                  "Remaining Quantity (MT)",
                                  listModel.remainingQuantity != null
                                      ? listModel.remainingQuantity.toString()
                                      : "-"),
                              const SizedBox(height: 24),
                             Visibility(
                                 visible: Constants.AUTH_ROLEID !=
                                     Constants.SALE,
                                 child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 CommonText(
                                   name: "Assign Quantity Limit",
                                   fontColor: Constant.colorBlack,
                                   fontSize: Constant.fontSize18,
                                 ),
                                 SizedBox(height: Constant.headingSix),
                                 InkWell(
                                     onTap: () {
                                       _showMultiSelectEmployeeZonal(context);
                                     },
                                     child: CommonTextFormField(
                                       labeltxt: "Employees",
                                       labeltxtColor: Constant.textFormFieldColor,
                                       labeltxtSize: Constant.textFormFieldSize,
                                       labeltxtFontWeight:
                                       Constant.textFormFieldSizeFontW,
                                       focuBorColor: Constant.textFormFocuBorCol,
                                       focuBorWid: Constant.textFormFocuBorWid,
                                       enaBorColor: Constant.textFormEnaBorCol,
                                       enaBorWid: Constant.textFormEnaBorWid,
                                       borderRadiusTL:
                                       Constant.textFormborderRadiusTL,
                                       borderRadiusBR:
                                       Constant.textFormborderRadiusBR,
                                       contentPadHor:
                                       Constant.textFormcontentPadHor,
                                       contentPadHVer:
                                       Constant.textFormcontentPadHVer,
                                       keyborType: TextInputType.text,
                                       enabled: false,
                                       dropdownIcon: true,
                                       controllerTxt: _employeeController,
                                     )),
                                 const SizedBox(height: 16),
                                 Row(
                                   children: [
                                     Expanded(
                                       child: InkWell(
                                           onTap: () {
                                             _selectFromDate(context, false,
                                                 _fromdatecontroller, "fromDate");
                                           },
                                           child: CommonTextFormField(
                                             labeltxt: "Valid From",
                                             labeltxtColor:
                                             Constant.textFormFieldColor,
                                             labeltxtSize:
                                             Constant.textFormFieldSize,
                                             labeltxtFontWeight:
                                             Constant.textFormFieldSizeFontW,
                                             focuBorColor:
                                             Constant.textFormFocuBorCol,
                                             focuBorWid:
                                             Constant.textFormFocuBorWid,
                                             enaBorColor:
                                             Constant.textFormEnaBorCol,
                                             enaBorWid: Constant.textFormEnaBorWid,
                                             borderRadiusTL:
                                             Constant.textFormborderRadiusTL,
                                             borderRadiusBR:
                                             Constant.textFormborderRadiusBR,
                                             contentPadHor:
                                             Constant.textFormcontentPadHor,
                                             contentPadHVer:
                                             Constant.textFormcontentPadHVer,
                                             controllerTxt: _fromdatecontroller,
                                             enabled: false,
                                           )),
                                     ),
                                     const SizedBox(width: 16.0),
                                     Expanded(
                                       child: InkWell(
                                           onTap: () {
                                             _selectFromDate(context, false,
                                                 _todatecontroller, "toDate");
                                           },
                                           child: CommonTextFormField(
                                             labeltxt: "Valid To",
                                             labeltxtColor:
                                             Constant.textFormFieldColor,
                                             labeltxtSize:
                                             Constant.textFormFieldSize,
                                             labeltxtFontWeight:
                                             Constant.textFormFieldSizeFontW,
                                             focuBorColor:
                                             Constant.textFormFocuBorCol,
                                             focuBorWid:
                                             Constant.textFormFocuBorWid,
                                             enaBorColor:
                                             Constant.textFormEnaBorCol,
                                             enaBorWid: Constant.textFormEnaBorWid,
                                             borderRadiusTL:
                                             Constant.textFormborderRadiusTL,
                                             borderRadiusBR:
                                             Constant.textFormborderRadiusBR,
                                             contentPadHor:
                                             Constant.textFormcontentPadHor,
                                             contentPadHVer:
                                             Constant.textFormcontentPadHVer,
                                             controllerTxt: _todatecontroller,
                                             enabled: false,
                                           )),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 16),
                                 CommonTextFormField(
                                     labeltxt: "Quantity",
                                     enabled: true,
                                     labeltxtColor: Constant.textFormFieldColor,
                                     labeltxtSize: Constant.textFormFieldSize,
                                     labeltxtFontWeight:
                                     Constant.textFormFieldSizeFontW,
                                     focuBorColor: Constant.textFormFocuBorCol,
                                     focuBorWid: Constant.textFormFocuBorWid,
                                     enaBorColor: Constant.textFormEnaBorCol,
                                     enaBorWid: Constant.textFormEnaBorWid,
                                     borderRadiusTL:
                                     Constant.textFormborderRadiusTL,
                                     borderRadiusBR:
                                     Constant.textFormborderRadiusBR,
                                     contentPadHor: Constant.textFormcontentPadHor,
                                     contentPadHVer:
                                     Constant.textFormcontentPadHVer,
                                     controllerTxt: _quantitycontroller,
                                     keyborType: TextInputType.number,
                                     onChanged: (String? value) {}),
                                 const SizedBox(height: 16.0),
                                 Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceEvenly,
                                   children: [
                                     CommonButton(
                                         buttonName: "Cancel",
                                         buttonNameSize:
                                         Constant.pricbuttonNameSize,
                                         buttonNameColor:
                                         Constant.textFormFieldColor,
                                         buttonColor: Colors.white,
                                         buttonHeight: Constant.pricbuttonHeight,
                                         buttonRadiusTL:
                                         Constant.pricbuttonRadiusTL,
                                         buttonRadiusBL: Constant.pricbutRadiusBL,
                                         buttonBorder: Colors.black,
                                         buttonFunction: () {
                                           Navigator.pop(ctx);
                                           // BlocProvider.of<QuantityAllocationCreateUpdateBloc>(context)
                                           //     .add(LoadQuantityAllocationCreateUpdateRequest());
                                         }),
                                     CommonButton(
                                         buttonName: "Submit",
                                         buttonNameSize:
                                         Constant.pricbuttonNameSize,
                                         buttonNameColor:
                                         Constant.pricbuttonTxtColor,
                                         buttonColor: Constant.pricbuttonColor,
                                         buttonHeight: Constant.pricbuttonHeight,
                                         buttonRadiusTL:
                                         Constant.pricbuttonRadiusTL,
                                         buttonRadiusBL: Constant.pricbutRadiusBL,
                                         buttonBorder: Colors.transparent,
                                         buttonFunction: () {
                                           submitQuantityAllocation();
                                         })
                                   ],
                                 ),
                                 const SizedBox(height: 16),
                               ],
                             )),
                              Constants.AUTH_ROLEID ==
                                  Constants.SALE? SizedBox(height: MediaQuery.of(context).size.height/8):Container(),
                            ],
                          )))),
              progressBar
            ],
          ),
        )));
  }

  void _showMultiSelectEmployeeZonal(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<ZonalEmployeeList>(
            searchable: true,
            items: zonalEmployeeList
                .map((dist) => MultiSelectItem<ZonalEmployeeList>(
                    dist, dist.employeeName!))
                .toList(),
            initialValue: selectedZonalEmployees,
            onConfirm: (List<ZonalEmployeeList> values) {
              selectedZonalEmployees = values;
              selectedEmployeeIds.clear();
              for (ZonalEmployeeList d in values) {
                selectedEmployeeIds.add(d.id!);
              }
              setState(() {
                _employeeController.text =
                    selectedEmployeeIds.length.toString() + " Item(s) selected";
              });
              print(selectedEmployeeIds.toString());
            });
      },
    );
  }

  _selectToDate(BuildContext context, bool popup) async {
    if (!popup) {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _todatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                  _todatecontroller.text.toString(),
                  DateTimeUtils.DD_MM_YYYY_Format,
                  DateTimeUtils.YYYY_MM_DD_Format)),
          firstDate: _todatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                  _todatecontroller.text.toString(),
                  DateTimeUtils.DD_MM_YYYY_Format,
                  DateTimeUtils.YYYY_MM_DD_Format)),
          lastDate: DateTime.now());
      if (selected != null) {
        _todatecontroller.text = DateTimeUtils()
            .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      }
    }
  }

  _selectFromDate(BuildContext context, bool popup,
      TextEditingController dateController, String type) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(listModel.validFrom!.replaceAll("T", " ")),
        firstDate: DateTime.parse(listModel.validFrom!.replaceAll("T", " ")),
        lastDate: DateTime.parse(listModel.validTo!.replaceAll("T", " ")));
    if (selected != null) {
      if (type == "fromDate") {
        if (_todatecontroller.text.isEmpty) {
          dateController.text = DateTimeUtils()
              .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
        } else {
          String differences = DateTimeUtils().compareTwoDates(selected,
              DateTimeUtils().convertDateType(_todatecontroller.text));
          if (differences == ("date1 is later than date2")) {
            Utils().showSuccessDlg(context, "Error", "Error",
                successText: "Please select correct From Date");
          } else {
            dateController.text = DateTimeUtils()
                .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
          }
        }
      } else {
        if (_fromdatecontroller.text.isEmpty) {
          dateController.text = DateTimeUtils()
              .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
        } else {
          String differences = DateTimeUtils().compareTwoDates(
              DateTimeUtils().convertDateType(_fromdatecontroller.text),
              selected);
          if (differences == ("date1 is later than date2")) {
            Utils().showSuccessDlg(context, "Error", "Error",
                successText: "Please select correct To Date");
          } else {
            dateController.text = DateTimeUtils()
                .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
          }
        }
      }
    }
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

  void submitQuantityAllocation() {
    if (selectedEmployeeIds.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Employees");
    } else if (_fromdatecontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please enter the From Date");
    } else if (_todatecontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please enter the To Date");
    } else if (_quantitycontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please enter the Quantity");
    } else if (listModel.remainingQuantity! <
        (double.parse(_quantitycontroller.text) *
            selectedEmployeeIds.length)) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "You entered more then Remaining Quantity (MT).");
    } else {
      QuantityAllocationCreateReq allocationCreateReq =
          QuantityAllocationCreateReq();

      if ((widget.qa!.id ?? 0) != 0) {
        allocationCreateReq.id = widget.qa!.id;
      }

      allocationCreateReq.verticleId = listModel.verticleId;
      allocationCreateReq.salesOrganizationId = listModel.salesOrganizationId;
      allocationCreateReq.distributionChannelId =
          listModel.distributionChannelId;
      allocationCreateReq.oilTypeId = listModel.oilTypeId;

      allocationCreateReq.loginUserId = Constants.AUTH_USERID;
      // allocationCreateReq.skuIds = selectedMaterialIds;
      allocationCreateReq.customerId = selectedEmployeeIds;
      allocationCreateReq.validFrom = DateTimeUtils()
          .convertServerDateType(listModel.validFrom!)
          .toString();
      allocationCreateReq.validTo =
          DateTimeUtils().convertServerDateType(listModel.validTo!).toString();
      allocationCreateReq.empValidFrom = DateTimeUtils()
          .convertServerDateType(_fromdatecontroller.text)
          .toString();
      allocationCreateReq.empValidTo = DateTimeUtils()
          .convertServerDateType(_todatecontroller.text)
          .toString();
      allocationCreateReq.quantityLimit =
          double.parse(_quantitycontroller.text);
      allocationCreateReq.empActualDiscount =
          double.parse(_quantitycontroller.text);
      allocationCreateReq.remainingQuantity = listModel.remainingQuantity;
      allocationCreateReq.remainingQuantityHidden =
          (listModel.remainingQuantity! -
              (double.parse(_quantitycontroller.text) *
                  selectedEmployeeIds.length));
      allocationCreateReq.actualDiscount = listModel.actualDiscount;
      BlocProvider.of<AssignedQAUpdateBloc>(context)
          .add(SaveQuantityRequest(allocationCreateReq: allocationCreateReq));
    }
  }
}
