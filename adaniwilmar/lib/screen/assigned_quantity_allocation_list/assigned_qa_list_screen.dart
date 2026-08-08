import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/screen/assigned_quantity_allocation_update/assigned_qa_update_screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/Quantity_allocation_create_req.dart';
import '../../models/bdo_list_response.dart';
import '../../models/daily_rate_response.dart';
import '../../models/dealer_response.dart';
import '../../models/qa_list_model.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../../widget/widget.dart';
import '../quantity_allocation_create_update/qa_create_update_screen.dart';
import '../request_quantity_create/request_quantity_create_screen.dart';
import 'bloc/assigned_qa_list_bloc.dart';
import 'bloc/assigned_qa_list_event.dart';
import 'bloc/assigned_qa_list_state.dart';

class AssignedQAListScreen extends StatelessWidget {
  bool isFromRequestFlow;

  AssignedQAListScreen(this.isFromRequestFlow, {Key? key}) : super(key: key);
  static const String routeName = '/';

  Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => AssignedQAListScreen(isFromRequestFlow));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child: QualityAllocation(isFromRequestFlow),
    );
  }

  AssignedQAListBloc _getInitialLoadData() {
    AssignedQAListBloc todayRateBloc = AssignedQAListBloc();
    todayRateBloc.add(LoadQuantityAllocationCreateUpdateRequest());
    return todayRateBloc;
  }
}

class QualityAllocation extends StatefulWidget {
  bool isFromRequestFlow;

  QualityAllocation(this.isFromRequestFlow, {Key? key}) : super(key: key);

  @override
  State<QualityAllocation> createState() => _QualityAllocationState();
}

class _QualityAllocationState extends State<QualityAllocation>
    with TickerProviderStateMixin {
  List<int> selectedEmployeeIds = [];
  List<BdoList> materialList = [];
  List<DistributorList> distributorList = [];
  List<ZonalEmployeeList> selectedZonalEmployees = [];
  List<DistributorList>? selectedDistributor = [];

  DistributionChannel? selectedDistrChannel;
  SalesOrganization? selectedSalesOrg;

  Vertical? selectedVertical;
  List<Vertical> verticals = [];
  List<QAListResponseValue> listModel = <QAListResponseValue>[];

  String _displayStringForOilTypeOption(OilType option) => option.name!;
  TextEditingController? _oilTypeController;
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
  List<OilType> oilTypes = [];
  OilType? selectedOilType;
  List<DailySFQuantityAllocation> quantityAllocations = [];
  List<QuantityRequestList> quantityManagerAllocations = [];
  List<SpecialtyFatQuantityRequestsList> quantityRequestList = [];
  List<SpecialtyFatQuantityRequestsList> quantityManagerRequestList = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Oil Type";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  TextEditingController _quantitycontroller = TextEditingController();

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
  final TextEditingController _pfromdatecontroller = TextEditingController();
  final TextEditingController _ptodatecontroller = TextEditingController();

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

  Widget contBody() {
    return const Text("jai");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

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
    return BlocListener<AssignedQAListBloc, AssignedQAListState>(
        listener: (context, state) {
          if (state is OnLoadSalesOrganization) {
            selectedSalesOrg = null;
            salesOrgList = state.salesOrganization;
            setState(() {});
          } else if (state is OnLoadVerticalList) {
            selectedVertical = null;
            verticals = state.verticalList;
            setState(() {});
          } else if (state is onLoadQuantityRequestList) {
            listModel = state.listModel;
            setState(() {});
          } else if (state is OnLoadZonalEmployees) {
            selectedZonalEmployees = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE)
                ? Constants.SELECT_DISTRIBUTOR
                : Constants.SELECT_EMPLOYEES;
            zonalEmployeeList = state.zoanlEmpList;
            // if (widget.isUpdate) {
            //   loadZonalEmpData(zonalEmployeeList);
            // }
          }

          /*if (state is OnLoadZonalHead) {
            // print(state.props);
            selectedEmployees = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE)
                ? Constants.SELECT_DISTRIBUTOR
                : Constants.SELECT_EMPLOYEES;
            employeeList = state.zonalHeadList;
            if (widget.isUpdate) {
              loadData(employeeList);
              setState(() {
                _stateController.text =
                    widget.stateIds.length.toString() + " Item(s) selected";
              });
            }
          }*/

          else if (state is OnLoadSubCategoryItems) {
            // selectedVertical = null;
            // verticals = state.verticalList;
            // setState(() {});
          } else if (state is OnLoadOilTypes) {
            selectedOilType = null;
            oilTypes = state.oilTypes;
            setState(() {});
          }

          /* else if (state is OnLoadMaterial) {
            // print(state.props);
            selectedMaterials = [];
            materialList = state.metrialList;
            // if (widget.isUpdate) {
            //   selectedMaterialIds = widget.materialIds;
            //   selectedEmployeeIds = widget.employeeIds;
            //   selectedStateIds = widget.stateIds;
            // }
            // for (var id in widget.materialIds) {
            //   var selectedObj = materialList.firstWhere((x) => x.id == id);
            //   selectedMaterials.add(selectedObj);
            // }
            setState(() {
              if (selectedMaterials.isEmpty) {
                _materialController.text = "Select Materials";
              } else {
                // _materialController.text =
                //     widget.materialIds.length.toString() + " Item(s) selected";
              }
              // API call for get employees
              if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
                // BlocProvider.of<CreateDiscountBloc>(context)
                //     .add(LoadZonalHead(userId: Constants.AUTH_USERID));
              }
            });
          }*/

          else if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            setState(() {});
          } else if (state is OnLoadMaterial) {
            selectedMaterials = [];
            materialList = state.metrialList;
          } else if (state is OnSaveSuccess) {
            Utils().showSuccessDlg(
                context, "Quantity Request", "Quantity Request",
                successText: "Request Confirmed");
          } else if (state is OnFailure) {
            Utils().showSuccessDlg(context, "Error", "Error",
                successText: state.error);
          } else if (state is ShowProgressBar) {
            _handler!.show!();
          } else if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: Scaffold(
          primary: false,
          // extendBodyBehindAppBar: true,
          // backgroundColor: Colors.white,
          // appBar: const CustomAppBar(
          //   title: "Quantity Allocation",
          //   backArrow: true,
          // ),
          body: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Positioned(
              //   child: Container(
              //     child: Constant.bgImgGlobal,
              //   ),
              // ),
              Container(
                  // height: screenHeight * 0.980,
                  width: screenWidth,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: listModel.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: listModel.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () async {
                                if (!widget.isFromRequestFlow) {
                                  var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AssignedQAUpdateScreen(
                                                qa: listModel[i])),
                                  );

                                  if (res != null) {
                                    BlocProvider.of<AssignedQAListBloc>(context)
                                        .add(
                                            LoadQuantityAllocationCreateUpdateRequest());
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RequestQuantityCreateScreen(
                                                qa: listModel[i])),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 5, right: 5, top: 10, bottom: 10),
                                child: CurveBorderBox(
                                  boxLRPadding: 10,
                                  boxofWidget: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 10),
                                                child: Text("Oil Type",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Constant
                                                            .colorLightGray,
                                                        fontWeight: Constant
                                                            .fontWeight400)),
                                              ),
                                              Text(
                                                  (listModel[i].oilTypeName ??
                                                      ""),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600)),
                                            ]),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6, bottom: 10),
                                                  child: Text("Employee Name",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Constant
                                                              .colorLightGray,
                                                          fontWeight: Constant
                                                              .fontWeight400)),
                                                ),
                                                Text(
                                                    listModel[i].employeeName ??
                                                        "-",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight600)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6, bottom: 10),
                                                child: Text("Valid From",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Constant
                                                            .colorLightGray,
                                                        fontWeight: Constant
                                                            .fontWeight400)),
                                              ),
                                              Text(
                                                  DateTimeUtils().displayFormat(listModel[i].validFrom ?? ""),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Constant.colorBlack,
                                                      fontWeight: Constant
                                                          .fontWeight600)),
                                            ]),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6, bottom: 10),
                                                  child: Text("Valid To",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Constant
                                                              .colorLightGray,
                                                          fontWeight: Constant
                                                              .fontWeight400)),
                                                ),
                                                Text(
                                                    DateTimeUtils().displayFormat(listModel[i].validTo ?? "") ,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Constant.colorBlack,
                                                        fontWeight: Constant
                                                            .fontWeight600)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : const Center(
                          child: Text(
                            "No data found",
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
              progressBar
            ],
          ),
        ));
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
              GMLogger.v(selectedEmployeeIds.toString());
            });
      },
    );
  }

  void _showMultiSelectEmployee(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
            searchable: true,
            items: employeeList
                .map((dist) => MultiSelectItem<BdoList>(dist, dist.name!))
                .toList(),
            initialValue: selectedEmployees,
            onConfirm: (List<BdoList> values) {
              selectedEmployees = values;
              selectedEmployeeIds.clear();
              for (BdoList d in values) {
                selectedEmployeeIds.add(d.id!);
              }
              setState(() {
                _employeeController.text =
                    selectedEmployeeIds.length.toString() + " Item(s) selected";
              });
              // print(selectedEmployeeIds.toString());
            });
      },
    );
  }

  showMultiSelectDistributor(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<DistributorList>(
            searchable: true,
            selectAll: true,
            items: distributorList
                .map((dist) => MultiSelectItem<DistributorList>(
                    dist, dist.employeeName.toString()))
                .toList(),
            initialValue: selectedDistributor!,
            onConfirm: (List<DistributorList> values) {
              // selectedDistributor = values;
              // selectedEmployeeIds.clear();
              // for (DistributorList d in values) {
              //   selectedEmployeeIds.add(d.id!);
              // }
              // setState(() {
              //   _employeeController.text =
              //       selectedEmployeeIds.length.toString() + " Item(s) selected";
              // });
              // print(selectedEmployeeIds.toString());
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
    } else {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: _ptodatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                  _ptodatecontroller.text.toString(),
                  DateTimeUtils.DD_MM_YYYY_Format,
                  DateTimeUtils.YYYY_MM_DD_Format)),
          firstDate: _ptodatecontroller.text.toString() == ""
              ? DateTime.now()
              : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                  _ptodatecontroller.text.toString(),
                  DateTimeUtils.DD_MM_YYYY_Format,
                  DateTimeUtils.YYYY_MM_DD_Format)),
          lastDate: DateTime.now());
      if (selected != null) {
        _ptodatecontroller.text = DateTimeUtils()
            .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      }
    }
  }

  _selectFromDate(BuildContext context, bool popup,
      TextEditingController dateController, String type) async {
    DateTime initialDate = dateController.text.toString() == ""
        ? DateTime.now()
        : DateTimeUtils().convertDateType(dateController.text);

    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

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

      // if(saudaDetail.saudaValidityPeriod!=null){
      //   _todatecontroller.text = DateTimeUtils()
      //       .dateToStringFormat(selected.add(Duration(days:saudaDetail.saudaValidityPeriod!)), DateTimeUtils.DD_MM_YYYY_Format);
      // }
    }
  }

  void _showMultiSelectMaterial(BuildContext context) async {
    bool isCheck = false;
    // if (Constants.AUTH_ROLEID != Constants.NHMANAGER) {
    //   materialList = selectedMaterials;
    //   isCheck = true;
    // }
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<BdoList>(
          searchable: true,
          selectAll: true,
          items: materialList
              .map((dist) => MultiSelectItem<BdoList>(dist, dist.name!))
              .toList(),
          initialValue: selectedMaterials,
          isUncheck: false,
          onConfirm: (List<BdoList> values) {
            print('print');
            selectedMaterials = values;
            selectedMaterialIds.clear();
            for (BdoList d in values) {
              selectedMaterialIds.add(d.id!);
            }
            setState(() {
              _materialController.text =
                  selectedMaterialIds.length.toString() + " Item(s) selected";
            });
            print(selectedMaterialIds.toString());

            BlocProvider.of<AssignedQAListBloc>(context).add(LoadZonalEmployees(
                salesOrganizationId: selectedSalesOrg!.id ?? 0,
                distributionChannelId: selectedDistrChannel!.id ?? 0,
                divisonId: selectedVertical!.id ?? 0));
          },
        );
      },
    );
  }

  void submitQuantityAllocation() {
    if ((selectedSalesOrg == null) || (selectedSalesOrg!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Sales Organization");
    } else if ((selectedDistrChannel == null) ||
        (selectedDistrChannel!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Distribution Channel");
    } else if ((selectedVertical == null) || (selectedVertical!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Division");
    } else if ((selectedOilType == null) || (selectedOilType!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Oil Type");
    } else if (selectedMaterialIds.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Materials");
    } else if (selectedEmployeeIds.isEmpty) {
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
    } else {
      QuantityAllocationCreateReq allocationCreateReq =
          QuantityAllocationCreateReq();

      allocationCreateReq.id = 0;
      allocationCreateReq.verticleId = selectedVertical!.id;
      allocationCreateReq.salesOrganizationId = selectedSalesOrg!.id;
      allocationCreateReq.distributionChannelId = selectedDistrChannel!.id;
      allocationCreateReq.oilTypeId = selectedOilType!.id;
      allocationCreateReq.oilTypeId = selectedOilType!.id;
      allocationCreateReq.oilTypeName = selectedOilType!.name;
      allocationCreateReq.oilTypeCode = selectedOilType!.dealerCode;

      allocationCreateReq.loginUserId = Constants.AUTH_USERID;
      allocationCreateReq.skuIds = selectedEmployeeIds;
      allocationCreateReq.customerId = selectedEmployeeIds;
      allocationCreateReq.validFrom =
          DateTimeUtils().convertDateType(_fromdatecontroller.text).toString();
      allocationCreateReq.validTo =
          DateTimeUtils().convertDateType(_todatecontroller.text).toString();
      allocationCreateReq.quantityLimit =
          double.parse(_quantitycontroller.text);

      BlocProvider.of<AssignedQAListBloc>(context)
          .add(SaveQuantityRequest(allocationCreateReq: allocationCreateReq));
    }
  }

/* Widget quantityAllocationCommonButton({  String? buttonName,
    double? buttonNameSize,
    Color? buttonNameColor,
    Color? buttonColor,
    double? buttonHeight,
    double? buttonRadiusTL,
    double? buttonRadiusBL,
    Color? buttonBorder,
    Function? buttonFunction,
    FontWeight? buttonNameWeight}) */ /*extends StatelessWidget */ /*{

    */ /*const CommonButton(
      {Key? key,
      this.buttonName,
      this.buttonColor,
      this.buttonHeight,
      this.buttonRadiusTL,
      this.buttonRadiusBL,
      this.buttonNameColor,
      this.buttonNameSize,
      this.buttonBorder,
      this.buttonFunction,
      this.buttonNameWeight})
      : super(key: key);*/ /*

    // @override
    // Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: buttonHeight,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: buttonBorder!),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(buttonRadiusTL!),
              topRight: Radius.circular(buttonRadiusBL!),
              bottomLeft: Radius.circular(buttonRadiusBL!),
              bottomRight: Radius.circular(buttonRadiusTL!))),
      onPressed: () {
        // if (buttonFunction != null) {

        // }
        submitQuantityAllocation();
      },
      child: Text(
        buttonName!,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: buttonNameSize,
            color: buttonNameColor,
            fontWeight: buttonNameWeight),
      ),
      color: buttonColor,
    );
  }*/
}
