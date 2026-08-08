import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/screen/discount/user_discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/bdo_list_response.dart';
import '../../models/pack_group_list.dart';
import '../../models/state_response.dart';
import '../../models/user_discount_request.dart';
import '../../utils/constant.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/border_bottom.dart';
import '../../widget/common-textfield.dart';
import '../../widget/common_button.dart';
import '../../widget/curve_outer_box.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../discount/bloc/discount_event.dart';
import 'assigned_discount.dart';
import 'bloc/discount_bloc.dart';
import 'bloc/discount_state.dart';

class CreateDiscountScreen extends StatelessWidget {
  static const String routeName = '/';
  bool isUpdate = false;
  int id;
  List<int> materialIds;
  List<int> employeeIds;
  List<int> stateIds;
  String discount;
  String discountReason;
  String state;
  String fromDate;
  String toDate;
  int salesOrganizationId;
  int distributionChannelId;
  int divisionId;
  int stateId;

  // static Route route() {
  //   return MaterialPageRoute(
  //       settings: const RouteSettings(name: routeName),
  //       builder: (_) =>  CreateDiscountScreen());
  // }

  CreateDiscountScreen(
      {required this.isUpdate,
      required this.id,
      required this.materialIds,
      required this.employeeIds,
      required this.stateIds,
      required this.discount,
      required this.discountReason,
      required this.state,
      required this.fromDate,
      required this.toDate,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisionId,
      required this.stateId,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateDiscount(
      isUpdate: isUpdate,
      id: id,
      materialIds: materialIds,
      employeeIds: employeeIds,
      stateIds: stateIds,
      discount: discount,
      discountReason: discountReason,
      state: state,
      fromDate: fromDate,
      toDate: toDate,
      salesOrganizationId: salesOrganizationId,
      distributionChannelId: distributionChannelId,
      divisionId: divisionId,
      stateId: stateId,
    );
  }
}

class CreateDiscount extends StatefulWidget {
  bool isUpdate = false;
  int id;
  List<int> materialIds;
  List<int> employeeIds;
  List<int> stateIds;
  String discount;
  String discountReason;
  String state;
  String fromDate;
  String toDate;
  int salesOrganizationId;
  int distributionChannelId;
  int divisionId;
  int stateId;

  CreateDiscount(
      {required this.isUpdate,
      required this.id,
      required this.materialIds,
      required this.employeeIds,
      required this.stateIds,
      required this.discount,
      required this.discountReason,
      required this.state,
      required this.fromDate,
      required this.toDate,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisionId,
      required this.stateId,
      Key? key})
      : super(key: key);

  @override
  @override
  State<CreateDiscount> createState() => _CreateDiscountState();
}

class _CreateDiscountState extends State<CreateDiscount> {
  TabController? tabController;
  Color? borderColor = Constant.pricDisBocolor;

  List<PackGroupList> packGroups = [];
  PackGroupList? selectedPackGroup;

  List<String> materialGroup = [];
  String? selectedMaterial;

  List<BdoList> employeeList = [];
  List<ZonalEmployeeList> zonalEmployeeList = [];
  List<BdoList> materialList = [];

  List<DistributorList> distributorList = [];
  bool isDistributor = false;

  List<ActiveState> selectedStates = [];
  List<ActiveState> stateList = [];

  // BdoList? selectedEmployee;

  List<BdoList> selectedMaterials = [];
  List<BdoList> selectedEmployees = [];
  List<ZonalEmployeeList> selectedZonalEmployees = [];
  List<DistributorList>? selectedDistributor = [];

  List<int> selectedMaterialIds = [];
  List<int> selectedEmployeeIds = [];
  List<int> selectedStateIds = [];

  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String appBarTitle = "Create User Discount";

  late TextEditingController _reasoncontroller = TextEditingController();
  late TextEditingController _dicountcontroller = TextEditingController();
  late TextEditingController _fromdatecontroller = TextEditingController();
  late TextEditingController _todatecontroller = TextEditingController();
  late TextEditingController _employeeController = TextEditingController();
  late TextEditingController _materialController = TextEditingController();
  late TextEditingController _stateController = TextEditingController();

  String saudaFromDate = DateTimeUtils().dateToStringFormat(DateTime.now().add(const Duration(days: Constants.REPORT_START_DAY)), DateTimeUtils.DD_MM_YYYY_Format);

  TimeOfDay selectedTime = TimeOfDay.now();

  ProgressBarHandler? _handler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();

    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 00);

    _todatecontroller.text =
      DateTimeUtils().dateToStringFormat(
        endOfDay,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24_format,
      );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocProvider(
        create: (context) => CreateDiscountBloc()
          ..add(LoadMaterial(userId: Constants.AUTH_USERID))
          ..add(LoadActiveStates(id: 0)),
        child: BlocListener<CreateDiscountBloc, CreateDiscountState>(listener: (context, state) {
          // if (state is OnLoadPackGroup) {
          //   packGroups = state.packGroups;
          //   setState(() {});
          // }
          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
          if (state is OnLoadZonalHead) {
            selectedEmployees = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.SELECT_DISTRIBUTOR : Constants.SELECT_EMPLOYEES;
            employeeList = state.zonalHeadList;
            if (widget.isUpdate) {
              loadData(employeeList);
              setState(() {
                _stateController.text = widget.stateIds.length.toString() + " Item(s) selected";
              });
            }
          }

          if (state is OnLoadBDO) {
            selectedEmployees = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.SELECT_DISTRIBUTOR : Constants.SELECT_EMPLOYEES;
            employeeList = state.bdoList;
            if (widget.isUpdate) {
              loadData(employeeList);
            }
          }

          if (state is OnLoadZonalEmployees) {
            selectedZonalEmployees = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.SELECT_DISTRIBUTOR : Constants.SELECT_EMPLOYEES;
            zonalEmployeeList = state.zoanlEmpList;
            if (widget.isUpdate) {
              loadZonalEmpData(zonalEmployeeList);
            }
          }

          if (state is OnLoadStates) {
            selectedStates = [];
            _stateController.text = "All States";
            stateList = state.states;
            setState(() {});
          }

          if (state is OnLoadDistributor) {
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.SELECT_DISTRIBUTOR : Constants.SELECT_EMPLOYEES;
            distributorList = state.distributorList;
            isDistributor = true;

            for (var id in widget.employeeIds) {
              var selectedObj = distributorList.firstWhere((x) => x.id == id);
              selectedDistributor?.add(selectedObj);
            }
            setState(() {
              _employeeController.text = widget.employeeIds.length.toString() + " Item(s) selected";
            });
            _dicountcontroller = TextEditingController(text: widget.discount);
            _reasoncontroller = TextEditingController(text: widget.discountReason);
            _fromdatecontroller = TextEditingController(
              text: DateTimeUtils().dateToServerToDateFormat(
                widget.fromDate,
                DateTimeUtils.ServerFormat,
                DateTimeUtils.DD_MM_YYYY_HH_MM_24,
              ),
            );
            _todatecontroller = TextEditingController(
              text: DateTimeUtils().dateToServerToDateFormat(
                widget.toDate,
                DateTimeUtils.ServerFormat,
                DateTimeUtils.DD_MM_YYYY_HH_MM_24,
              ),
            );
          }

          if (state is OnLoadMaterial) {
            selectedMaterials = [];
            materialList = state.metrialList;
            if (widget.isUpdate) {
              selectedMaterialIds = widget.materialIds;
              selectedEmployeeIds = widget.employeeIds;
              selectedStateIds = widget.stateIds;
            }
            for (var id in widget.materialIds) {
              var selectedObj = materialList.firstWhere((x) => x.id == id);
              selectedMaterials.add(selectedObj);
            }
            setState(() {
              if (selectedMaterials.isEmpty) {
                _materialController.text = "Select Materials";
              } else {
                _materialController.text = widget.materialIds.length.toString() + " Item(s) selected";
              }
              // API call for get employees
              if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                BlocProvider.of<CreateDiscountBloc>(context).add(LoadZonalHead(userId: Constants.AUTH_USERID));
              } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
                BlocProvider.of<CreateDiscountBloc>(context)
                    // .add(LoadBDO(userId: Constants.AUTH_USERID));
                    .add(LoadZonalEmployees(
                        userId: Constants.AUTH_USERID,
                        salesOrganizationId: widget.salesOrganizationId,
                        distributionChannelId: widget.distributionChannelId,
                        divisonId: widget.divisionId,
                        stateId: widget.stateId));
                appBarTitle = "Update Assigned Discount";
              } else if (Constants.AUTH_ROLEID == Constants.SALE) {
                BlocProvider.of<CreateDiscountBloc>(context).add(LoadDistributor(userId: Constants.AUTH_USERID, salesOrganizationId: 0, distributionChannelId: 0, divisonId: 0));
                appBarTitle = "Update Distributor Discount";
              }
            });
          }

          if (state is OnSaveUserDiscount) {
            showSuccessDlg(context, "Request Confirmed", "Success", successText: "User Discount Created");
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
        }, child: SafeArea(
          child: BlocBuilder<CreateDiscountBloc, CreateDiscountState>(
            builder: (context, state) {
              return Scaffold(
                primary: false,
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                appBar: CustomAppBar(title: widget.isUpdate ? appBarTitle : appBarTitle, backArrow: true),
                body: Stack(
                  // clipBehavior: Clip.none,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      child: Container(
                        child: Constant.bgImgGlobal,
                      ),
                    ),
                    GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CurveOuterBox(
                                  boxofWidget: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: true,
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            const SizedBox(height: 16),
                                            InkWell(
                                                onTap: () {
                                                  _showMultiSelectMaterial(context);
                                                },
                                                child: CommonTextFormField(
                                                  labeltxt: "Materials",
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
                                                  keyborType: TextInputType.text,
                                                  enabled: false,
                                                  dropdownIcon: true,
                                                  controllerTxt: _materialController,
                                                )),
                                            const SizedBox(height: 16),
                                            InkWell(
                                                onTap: () {
                                                  if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                                                    _showMultiSelectEmployee(context);
                                                  }
                                                  if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
                                                    _showMultiSelectEmployeeZonal(context);
                                                  }
                                                  if (Constants.AUTH_ROLEID == Constants.SALE) {
                                                    _showMultiSelectDistributor(context);
                                                  }
                                                },
                                                child: CommonTextFormField(
                                                  labeltxt: (Constants.AUTH_ROLEID == Constants.SALE) ? "Distributor" : "Employees",
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
                                                  keyborType: TextInputType.text,
                                                  enabled: false,
                                                  dropdownIcon: true,
                                                  controllerTxt: _employeeController,
                                                )),
                                            const SizedBox(height: 16),
                                            Visibility(
                                              visible: Constants.AUTH_ROLEID == Constants.NHMANAGER,
                                              child: InkWell(
                                                  onTap: () {
                                                    _showMultiSelectStates(context);
                                                  },
                                                  child: CommonTextFormField(
                                                    labeltxt: "States",
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
                                                    keyborType: TextInputType.text,
                                                    enabled: false,
                                                    dropdownIcon: true,
                                                    controllerTxt: _stateController,
                                                  )),
                                            ),
                                            Visibility(
                                              visible: Constants.AUTH_ROLEID == Constants.ZHMANAGER,
                                              child: Container(
                                                  decoration: const BoxDecoration(
                                                    border: Border.fromBorderSide(
                                                      BorderSide.none,
                                                    ),
                                                    color: Color(0xFFF5F5F5),
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(15),
                                                      bottomRight: Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: CommonTextFormField(
                                                    labeltxt: "State",
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
                                                    keyborType: TextInputType.number,
                                                    enabled: false,
                                                    controllerTxt: _stateController,
                                                  )),
                                            ),
                                            const SizedBox(height: 18),
                                            Container(
                                                decoration: const BoxDecoration(
                                                  border: Border.fromBorderSide(
                                                    BorderSide.none,
                                                  ),
                                                  color: Color(0xFFF5F5F5),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    bottomRight: Radius.circular(15),
                                                  ),
                                                ),
                                                child: CommonTextFormField(
                                                  labeltxt: "Discount",
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
                                                  keyborType: TextInputType.number,
                                                  controllerTxt: _dicountcontroller,
                                                )),
                                            const SizedBox(height: 18),
                                            CommonTextFormField(
                                              labeltxt: "Reason For Discount ",
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
                                              controllerTxt: _reasoncontroller,
                                            ),
                                            const SizedBox(height: 18),
                                            Container(
                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                width: double.infinity,
                                                height: 70,
                                                child: InkWell(
                                                    onTap: () {
                                                      _selectFromDate(context);
                                                    },
                                                    child: CommonTextFormField(
                                                      labeltxt: "From Date",
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
                                                      controllerTxt: _fromdatecontroller,
                                                      enabled: false,
                                                    ))),
                                            Container(
                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                width: double.infinity,
                                                height: 70,
                                                child: InkWell(
                                                    onTap: () {
                                                      _selectToDate(context);
                                                    },
                                                    child: CommonTextFormField(
                                                      labeltxt: "To Date",
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
                                                      controllerTxt: _todatecontroller,
                                                      enabled: false,
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        }),
                    progressBar
                  ],
                ),
                bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth / 2 - 40,
                          child: CommonButton(
                              buttonName: Constant.saudaLEButtonTxt1,
                              buttonNameSize: Constant.pricbuttonNameSize,
                              buttonNameColor: Constant.saudaLETTxtColor,
                              buttonColor: Constant.saudaLETbuttonColor,
                              buttonHeight: Constant.pricbuttonHeight,
                              buttonRadiusTL: Constant.pricbuttonRadiusTL,
                              buttonRadiusBL: Constant.pricbutRadiusBL,
                              buttonBorder: Constant.saudaLETbuttonBorder,
                              buttonFunction: () {
                                Navigator.pop(this.context);
                              }),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: screenWidth / 2 - 40,
                          child: CommonButton(
                              buttonName: widget.isUpdate ? 'Update' : 'Create',
                              buttonNameSize: Constant.pricbuttonNameSize,
                              buttonNameColor: Constant.pricbuttonTxtColor,
                              buttonColor: Constant.pricbuttonColor,
                              buttonHeight: Constant.pricbuttonHeight,
                              buttonRadiusTL: Constant.pricbuttonRadiusTL,
                              buttonRadiusBL: Constant.pricbutRadiusBL,
                              buttonBorder: Colors.transparent,
                              buttonFunction: () {
                                if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                                  UserDiscountRequest request = UserDiscountRequest();

                                  request.id = widget.isUpdate ? widget.id : 0;
                                  request.loginUserId = Constants.AUTH_USERID;

                                  if (selectedMaterialIds.isNotEmpty || widget.materialIds.isNotEmpty) {
                                    request.skuIds = selectedMaterialIds;
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select Material from the list", closeScreen: false);
                                    return;
                                  }

                                  if (selectedEmployeeIds.isNotEmpty || widget.employeeIds.isNotEmpty) {
                                    request.customerId = selectedEmployeeIds;
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.DIS_ERROR : Constants.EMP_ERROR, closeScreen: false);
                                    return;
                                  }

                                  if (selectedStateIds.isNotEmpty || widget.stateIds.isNotEmpty) {
                                    request.stateIds = selectedStateIds;
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select State from the list", closeScreen: false);
                                    return;
                                  }

                                  if (_dicountcontroller.text.toString().isNotEmpty) {
                                    request.actualDiscount = 0;
                                    if (_dicountcontroller.text.toString() != "") {
                                      request.actualDiscount = double.parse(_dicountcontroller.text.toString());
                                    }
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Enter the Discount amount", closeScreen: false);
                                    return;
                                  }

                                  if (_reasoncontroller.text.toString().isNotEmpty) {
                                    request.discountReason = _reasoncontroller.text.toString();
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Provide the reason for the discount", closeScreen: false);
                                    return;
                                  }

                                  if (_fromdatecontroller.text.toString().isNotEmpty) {
                                    request.validFrom = DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_HH_MM_24, DateTimeUtils.ServerFormat1);
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select From date", closeScreen: false);
                                    return;
                                  }
                                  if (_todatecontroller.text.toString().isNotEmpty) {
                                    request.validTo = DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_HH_MM_24, DateTimeUtils.ServerFormat1);
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select To date", closeScreen: false);
                                    return;
                                  }
                                  BlocProvider.of<CreateDiscountBloc>(context).add(SaveUserDiscount(request: request, isUpdate: widget.isUpdate));
                                } else {
                                  AssignedDiscountRequest request = AssignedDiscountRequest();

                                  request.id = widget.isUpdate ? widget.id : 0;
                                  request.loginUserId = Constants.AUTH_USERID;

                                  if (selectedMaterialIds.isNotEmpty || widget.materialIds.isNotEmpty) {
                                    if (widget.materialIds.isEmpty) {
                                      request.skuIds = selectedMaterialIds;
                                    } else {
                                      request.skuIds = widget.materialIds ?? [];
                                    }
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select Material from the list", closeScreen: false);
                                    return;
                                  }

                                  if (selectedEmployeeIds.isNotEmpty || widget.employeeIds.isNotEmpty) {
                                    if (widget.employeeIds.isEmpty) {
                                      request.customerId = selectedEmployeeIds;
                                    } else {
                                      request.customerId = widget.employeeIds ?? [];
                                    }
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.DIS_ERROR : Constants.EMP_ERROR, closeScreen: false);
                                    return;
                                  }
                                  if (selectedStateIds.isNotEmpty || widget.stateIds.isNotEmpty) {
                                    request.stateId = widget.stateId;
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select State from the list", closeScreen: false);
                                    return;
                                  }

                                  if (_dicountcontroller.text.toString().isNotEmpty) {
                                    request.actualDiscount = 0;
                                    if (_dicountcontroller.text.toString() != "") {
                                      request.actualDiscount = double.parse(_dicountcontroller.text.toString());
                                    }
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Enter the Discount amount", closeScreen: false);
                                    return;
                                  }

                                  if (_reasoncontroller.text.toString().isNotEmpty) {
                                    request.discountReason = _reasoncontroller.text.toString();
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Provide the reason for the discount", closeScreen: false);
                                    return;
                                  }

                                  if (_fromdatecontroller.text.toString().isNotEmpty) {
                                    request.validFrom = DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_HH_MM_24, DateTimeUtils.ServerFormat1);
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select From date", closeScreen: false);
                                    return;
                                  }
                                  if (_todatecontroller.text.toString().isNotEmpty) {
                                    request.validTo = DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_HH_MM_24, DateTimeUtils.ServerFormat1);
                                  } else {
                                    showSuccessDlg(context, "Error", "Error", successText: "Select To date", closeScreen: false);
                                    return;
                                  }
                                  BlocProvider.of<CreateDiscountBloc>(context).add(SaveAssignedUserDiscount(request: request));
                                }
                              }),
                        ),
                      ],
                    )),
              );
            },
          ),
        )));
    // );
  }

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white, bool? closeScreen = false}) {
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
      content: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Table(children: [
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: title == "Error" ? Icon(Icons.error_outlined, size: 70, color: Colors.red) : Icon(Icons.check_circle_sharp, size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(successText!,
                        style: TextStyle(
                          fontSize: Constant.fontSize14,
                        )),
                  ),
                  SizedBox(height: 20),
                  BorderBottom(bordeSize: 1)
                ],
              ),
            ]),
          ])),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
                buttonName: "Done",
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.textFormFieldColor,
                buttonColor: Colors.white,
                buttonHeight: 50,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.black,
                buttonNameWeight: Constant.fontWeight500,
                buttonFunction: () {
                  Navigator.pop(context);
                  if (closeScreen!) {
                    Navigator.pop(context);
                  }
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AssignedDiscountScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserDiscountScreen()),
                    );
                  }
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

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
      if (picked_s != null && picked_s != selectedTime) {
        setState(() {
          selectedTime = picked_s;
        });
      }

      _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(DateTime(selected.year, selected.month, selected.day, selectedTime.hour, selectedTime.minute), DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
    }
  }

  _selectToDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _todatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));

    if (selected != null) {
      final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
      if (picked_s != null && picked_s != selectedTime) {
        setState(() {
          selectedTime = picked_s;
        });
      }
      _todatecontroller.text = DateTimeUtils().dateToStringFormat(DateTime(selected.year, selected.month, selected.day, selectedTime.hour, selectedTime.minute), DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
    }
  }

  void _showMultiSelectMaterial(BuildContext context) async {
    bool isCheck = false;
    if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
      materialList = selectedMaterials;
      isCheck = true;
    }
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
          searchable: true,
          selectAll: true,
          items: materialList.map((dist) => MultiSelectItem<BdoList>(dist, dist.name!)).toList(),
          initialValue: selectedMaterials,
          isUncheck: isCheck,
          onConfirm: (List<BdoList> values) {
            selectedMaterials = values;
            selectedMaterialIds.clear();
            for (BdoList d in values) {
              selectedMaterialIds.add(d.id!);
            }
            setState(() {
              _materialController.text = selectedMaterialIds.length.toString() + " Item(s) selected";
            });
          },
        );
      },
    );
  }

  void _showMultiSelectEmployee(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
            searchable: true,
            items: employeeList.map((dist) => MultiSelectItem<BdoList>(dist, dist.name!)).toList(),
            initialValue: selectedEmployees,
            onConfirm: (List<BdoList> values) {
              selectedEmployees = values;
              selectedEmployeeIds.clear();
              for (BdoList d in values) {
                selectedEmployeeIds.add(d.id!);
              }
              setState(() {
                _employeeController.text = selectedEmployeeIds.length.toString() + " Item(s) selected";
              });
            });
      },
    );
  }

  void _showMultiSelectEmployeeZonal(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<ZonalEmployeeList>(
            searchable: true,
            items: zonalEmployeeList.map((dist) => MultiSelectItem<ZonalEmployeeList>(dist, dist.employeeName!)).toList(),
            initialValue: selectedZonalEmployees,
            onConfirm: (List<ZonalEmployeeList> values) {
              selectedZonalEmployees = values;
              selectedEmployeeIds.clear();
              for (ZonalEmployeeList d in values) {
                selectedEmployeeIds.add(d.id!);
              }
              setState(() {
                _employeeController.text = selectedEmployeeIds.length.toString() + " Item(s) selected";
              });
            });
      },
    );
  }

  void _showMultiSelectDistributor(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<DistributorList>(
            searchable: true,
            selectAll: true,
            items: distributorList.map((dist) => MultiSelectItem<DistributorList>(dist, dist.employeeName.toString())).toList(),
            initialValue: selectedDistributor!,
            onConfirm: (List<DistributorList> values) {
              selectedDistributor = values;
              selectedEmployeeIds.clear();
              for (DistributorList d in values) {
                selectedEmployeeIds.add(d.id!);
              }
              setState(() {
                _employeeController.text = selectedEmployeeIds.length.toString() + " Item(s) selected";
              });
            });
      },
    );
  }

  void _showMultiSelectStates(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<ActiveState>(
          searchable: true,
          items: stateList.map((dist) => MultiSelectItem<ActiveState>(dist, dist.stateName!)).toList(),
          initialValue: selectedStates,
          onConfirm: (List<ActiveState> values) {
            selectedStates = values;
            selectedStateIds.clear();
            for (ActiveState d in values) {
              selectedStateIds.add(d.stateId!);
            }
            if (selectedStates.isNotEmpty) {
              _stateController.text = selectedStateIds.length.toString() + " Item(s) selected";
            } else {
              _stateController.text = "All States";
            }
          },
        );
      },
    );
  }

  void loadData(List<BdoList> employeeList) {
    for (var id in widget.employeeIds) {
      var selectedObj = employeeList.firstWhere((x) => x.id == id);
      selectedEmployees.add(selectedObj);
    }

    for (var id in widget.stateIds) {
      var selectedObj = stateList.firstWhere((x) => x.stateId == id);
      selectedStates.add(selectedObj);
    }

    setState(() {
      _employeeController.text = widget.employeeIds.length.toString() + " Item(s) selected";
    });

    setState(() {
      _stateController.text = widget.stateIds.length.toString() + " Item(s) selected";
    });

    _dicountcontroller = TextEditingController(text: widget.discount);
    _reasoncontroller = TextEditingController(text: widget.discountReason);
    _stateController = TextEditingController(text: widget.state);
    _fromdatecontroller = TextEditingController(
      text: DateTimeUtils().dateToServerToDateFormat(
        widget.fromDate,
        DateTimeUtils.ServerFormat1,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24,
      ),
    );
    _todatecontroller = TextEditingController(
      text: DateTimeUtils().dateToServerToDateFormat(
        widget.toDate,
        DateTimeUtils.ServerFormat1,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24,
      ),
    );
  }

  void loadZonalEmpData(List<ZonalEmployeeList> employeeList) {
    for (var id in widget.employeeIds) {
      var selectedObj = zonalEmployeeList.firstWhere((x) => x.id == id);
      selectedZonalEmployees.add(selectedObj);
    }

    for (var id in widget.stateIds) {
      var selectedObj = stateList.firstWhere((x) => x.stateId == id);
      selectedStates.add(selectedObj);
    }

    setState(() {
      _employeeController.text = widget.employeeIds.length.toString() + " Item(s) selected";
    });

    _dicountcontroller = TextEditingController(text: widget.discount);
    _reasoncontroller = TextEditingController(text: widget.discountReason);
    _stateController = TextEditingController(text: widget.state);
    _fromdatecontroller = TextEditingController(
      text: DateTimeUtils().dateToServerToDateFormat(
        widget.fromDate,
        DateTimeUtils.ServerFormat,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24,
      ),
    );
    _todatecontroller = TextEditingController(
      text: DateTimeUtils().dateToServerToDateFormat(
        widget.toDate,
        DateTimeUtils.ServerFormat,
        DateTimeUtils.DD_MM_YYYY_HH_MM_24,
      ),
    );
  }
}
