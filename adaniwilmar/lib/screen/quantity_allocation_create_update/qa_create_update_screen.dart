import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:flutter/material.dart';
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
import 'bloc/qa_create_update_bloc.dart';
import 'bloc/qa_create_update_event.dart';
import 'bloc/qa_create_update_state.dart';

class QACreateUpdateScreen extends StatelessWidget {
  QAListResponseValue? qa = QAListResponseValue();

  QACreateUpdateScreen({Key? key, this.qa}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => QACreateUpdateScreen(qa: QAListResponseValue()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child: QualityAllocation(qa: qa),
    );
  }

  QACreateUpdateBloc _getInitialLoadData() {
    QACreateUpdateBloc todayRateBloc = QACreateUpdateBloc();
    todayRateBloc.add(LoadSalesOrganization());
    return todayRateBloc;
  }
}

class QualityAllocation extends StatefulWidget {
  QAListResponseValue? qa = QAListResponseValue();

  QualityAllocation({Key? key, this.qa}) : super(key: key);

  @override
  State<QualityAllocation> createState() => _QualityAllocationState();
}

class _QualityAllocationState extends State<QualityAllocation> with TickerProviderStateMixin {
  List<int> selectedEmployeeIds = [];
  List<BdoList> materialList = [];
  List<DistributorList> distributorList = [];
  List<ZonalEmployeeList> selectedZonalEmployees = [];
  List<DistributorList>? selectedDistributor = [];

  DistributionChannel? selectedDistrChannel;
  SalesOrganization? selectedSalesOrg;

  Vertical? selectedVertical;
  List<Vertical> verticals = [];
  QAListResponseValue listModel = QAListResponseValue();

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
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  final TextEditingController _quantitycontroller = TextEditingController();

  get handleOk => null;
  int selectedTab = 0;
  List<DistributionChannel> distrChannels = [];
  List<SalesOrganization> salesOrgList = [];
  List<BdoList> employeeList = [];
  List<ZonalEmployeeList> zonalEmployeeList = [];
  List<BdoList> selectedMaterials = [];
  List<int> selectedMaterialIds = [];

  List<BdoList> selectedEmployees = [];
  final TextEditingController _employeeController = TextEditingController();

  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();

  TimeOfDay selectedFromTime = TimeOfDay.now();
  TimeOfDay selectedToTime = const TimeOfDay(hour: 23, minute: 59);

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
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var ctx = context;

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<QACreateUpdateBloc, QACreateUpdateState>(
        listener: (context, state) {
          if (state is OnLoadSalesOrganization) {
            selectedSalesOrg = null;
            salesOrgList = state.salesOrganization;
            if ((widget.qa!.id ?? 0) != 0) {
              BlocProvider.of<QACreateUpdateBloc>(context).add(LoadQAItemFetch(id: widget.qa!.id ?? 0));
            }
            setState(() {});
          } else if (state is OnLoadQAItemFetch) {
            listModel = state.listModel;
            selectedSalesOrg = SalesOrganization();
            for (var v in salesOrgList) {
              if (v.id == state.listModel.salesOrganizationId) {
                selectedSalesOrg = v;
                BlocProvider.of<QACreateUpdateBloc>(context).add(LoadDistributionChannel(id: selectedSalesOrg!.id ?? 0));
                break;
              }
            }
            setState(() {});
          } else if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            if ((widget.qa!.id ?? 0) != 0) {
              for (var v in state.distributionChannel) {
                if (v.id == listModel.distributionChannelId) {
                  selectedDistrChannel = v;

                  BlocProvider.of<QACreateUpdateBloc>(context).add(LoadVerticalList(distributionId: selectedDistrChannel!.id!));

                  break;
                }
              }
            }

            setState(() {});
          } else if (state is OnLoadVerticalList) {
            selectedVertical = null;
            verticals = state.verticalList;

            if ((widget.qa!.id ?? 0) != 0) {
              for (var v in state.verticalList) {
                if (v.id == listModel.verticleId) {
                  selectedVertical = v;

                  BlocProvider.of<QACreateUpdateBloc>(context).add(OnLoadOilType(divisonId: selectedVertical!.id!));

                  break;
                }
              }
            }

            setState(() {});
          } else if (state is OnLoadOilTypes) {
            selectedOilType = null;
            oilTypes = state.oilTypes;

            if ((widget.qa!.id ?? 0) != 0) {
              for (var v in state.oilTypes) {
                if (v.id == listModel.oilTypeId) {
                  selectedOilType = v;

                  BlocProvider.of<QACreateUpdateBloc>(context)
                      .add(LoadZonalEmployees(salesOrganizationId: selectedSalesOrg!.id ?? 0, distributionChannelId: selectedDistrChannel!.id ?? 0, divisonId: selectedVertical!.id ?? 0));

                  break;
                }
              }
            }

            setState(() {});
          } else if (state is OnLoadZonalEmployees) {
            selectedZonalEmployees = [];
            selectedEmployeeIds = [];
            _employeeController.text = (Constants.AUTH_ROLEID == Constants.SALE) ? Constants.SELECT_DISTRIBUTOR : Constants.SELECT_EMPLOYEES;
            zonalEmployeeList = state.zoanlEmpList;

            if ((widget.qa!.id ?? 0) != 0) {
              List<String> result = (listModel.customerId)!.split(",");
              for (var v in result) {
                ZonalEmployeeList ite = ZonalEmployeeList();
                ite.id = int.parse(v);
                selectedEmployeeIds.add(ite.id ?? 0);
                selectedZonalEmployees.add(ite);
              }

              _employeeController.text = listModel.customerName != null
                  ? listModel.customerName.toString()
                  : selectedEmployeeIds.length.toString() + (selectedEmployeeIds.length > 1 ? " Employees selected" : " Employee selected");
              _quantitycontroller.text = listModel.remainingQuantity.toString();
              _fromdatecontroller.text = DateTimeUtils().dateToStringFormat(DateTime.parse((listModel.validFrom ?? "").split("T")[0]), DateTimeUtils.DD_MM_YYYY_Format);

              _todatecontroller.text = DateTimeUtils().dateToStringFormat(DateTime.parse((listModel.validTo ?? "").split("T")[0]), DateTimeUtils.DD_MM_YYYY_Format);
            }
            setState(() {});
          } else if (state is OnLoadSubCategoryItems) {
            // selectedVertical = null;
            // verticals = state.verticalList;
            // setState(() {});
          } else if (state is OnLoadMaterial) {
            selectedMaterials = [];
            materialList = state.metrialList;
          } else if (state is OnSaveSuccess) {
            Utils().showSuccessDlg(context, "Quantity Request", "Quantity Request", successText: "Request Confirmed", closeScreen: true);
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
            title: "Quantity Allocation",
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
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: CommonDropdownButtonFormField<SalesOrganization>(
                                    value: selectedSalesOrg,
                                    label: "Sales Organization",
                                    onChanged: ((widget.qa!.id ?? 0) != 0)
                                        ? null
                                        : (SalesOrganization? newValue) {
                                            setState(() {
                                              selectedSalesOrg = newValue!;
                                            });
                                            BlocProvider.of<QACreateUpdateBloc>(context).add(LoadDistributionChannel(id: selectedSalesOrg!.id ?? 0));
                                          },
                                    items: salesOrgList.map<DropdownMenuItem<SalesOrganization>>((value) {
                                      return DropdownMenuItem<SalesOrganization>(
                                        value: value,
                                        child: Text(
                                          value.salesOrganizationName ?? "",
                                        ),
                                      );
                                    }).toList(),
                                  )),
                              const SizedBox(height: 16),
                              SizedBox(
                                  width: double.infinity,
                                  child: CommonDropdownButtonFormField<DistributionChannel>(
                                    value: selectedDistrChannel,
                                    label: "Distribution Channel",
                                    onChanged: ((widget.qa!.id ?? 0) != 0)
                                        ? null
                                        : (DistributionChannel? newValue) {
                                            setState(() {
                                              selectedDistrChannel = newValue!;
                                            });
                                            BlocProvider.of<QACreateUpdateBloc>(context).add(LoadVerticalList(distributionId: selectedDistrChannel!.id!));
                                          },
                                    items: distrChannels.map<DropdownMenuItem<DistributionChannel>>((value) {
                                      return DropdownMenuItem<DistributionChannel>(
                                        value: value,
                                        child: Text(value.distributionChannelName ?? ""),
                                      );
                                    }).toList(),
                                  )),
                              const SizedBox(height: 16),
                              SizedBox(
                                  width: double.infinity,
                                  child: CommonDropdownButtonFormField<Vertical>(
                                    value: selectedVertical,
                                    label: "Division",
                                    onChanged: ((widget.qa!.id ?? 0) != 0)
                                        ? null
                                        : (Vertical? newValue) {
                                            setState(() {
                                              selectedVertical = newValue!;
                                            });
                                            BlocProvider.of<QACreateUpdateBloc>(context).add(OnLoadOilType(
                                                // userId: Constants.AUTH_USERID,
                                                // salesOrganizationId:
                                                // selectedSalesOrg!.id!,
                                                // distributionChannelId:
                                                // selectedDistrChannel!.id!,
                                                divisonId: selectedVertical!.id!));
                                          },
                                    items: verticals.map<DropdownMenuItem<Vertical>>((value) {
                                      return DropdownMenuItem<Vertical>(
                                        value: value,
                                        child: Text(value.name ?? ""),
                                      );
                                    }).toList(),
                                  )),
                              const SizedBox(height: 16),
                              SizedBox(
                                  width: double.infinity,
                                  child: CommonDropdownButtonFormField<OilType>(
                                    value: selectedOilType,
                                    label: "Oil Type",
                                    onChanged: ((widget.qa!.id ?? 0) != 0)
                                        ? null
                                        : (OilType? newValue) {
                                              setState(() {
                                                selectedOilType = newValue!;
                                              });
                                              // BlocProvider.of<TodayRateBloc>(context).add(
                                              //     LoadOverallData(
                                              //         userId: Constants.AUTH_USERID,
                                              //         oilTypeId: newValue!.id!,
                                              //         plantId: selectedPlant!.id!,
                                              //         incoTermId: selectedIncoTerms!.id!,
                                              //         verticalId: (selectedVertical == null
                                              //             ? 0
                                              //             : selectedVertical!.id!),
                                              //         salesOrgId: (selectedSalesOrg == null
                                              //             ? 0
                                              //             : selectedSalesOrg!.id!),
                                              //         distrChannelId:
                                              //         (selectedDistrChannel == null
                                              //             ? 0
                                              //             : selectedDistrChannel!
                                              //             .id!)));

                                              /*BlocProvider.of<QACreateUpdateBloc>(
                                                context)
                                            .add(OnLoadMaterialDDList(
                                                oilTypeId: (newValue!.id ?? 0)
                                                    .toString()));*/

                                              BlocProvider.of<QACreateUpdateBloc>(context).add(LoadZonalEmployees(
                                                  salesOrganizationId: selectedSalesOrg!.id ?? 0, distributionChannelId: selectedDistrChannel!.id ?? 0, divisonId: selectedVertical!.id ?? 0));
                                            },
                                      items: oilTypes.map<DropdownMenuItem<OilType>>((value) {
                                        return DropdownMenuItem<OilType>(
                                          value: value,
                                          child: Text(value.name ?? ""),
                                        );
                                      }).toList(),
                                    )),
                              Visibility(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: Constant.headingSix),
                                        CommonText(
                                          name: "Quantity",
                                          fontColor: Constant.colorDullGray77,
                                          fontSize: Constant.fontSize13,
                                        ),
                                        Container(
                                          width: screenWidth,
                                          margin: const EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.all(Constant.headingSix!),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 0.2,
                                                color: Constant.textFormEnaBorCol!,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(10),
                                                topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                                                bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                                                bottomRight: const Radius.circular(10),
                                              )),
                                          child: CommonText(
                                            name: widget.qa!.quantityLimit.toString(),
                                            fontColor: Colors.grey.withOpacity(0.8),
                                            fontSize: Constant.fontSize14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    /*    Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Constant.headingSix),
                                      CommonText(
                                        name: "Remaining Quantity",
                                        fontColor: Constant.colorDullGray77,
                                        fontSize: Constant.fontSize13,
                                      ),
                                      Container(
                                        width: screenWidth,
                                        margin: const EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.all(Constant.headingSix!),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.2,
                                              color: Constant.textFormEnaBorCol!,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(10),
                                              topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                                              bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                                              bottomRight: const Radius.circular(10),
                                            )),
                                        child: CommonText(
                                          name: widget.qa!.remainingQuantity.toString(),
                                          fontColor: Constant.colorBlack,
                                          fontSize: Constant.fontSize13,
                                        ),
                                      ),
                                    ],
                                  ),
                              */
                                  ],
                                ),
                                visible: widget.qa!.id != null,
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                  onTap: () {
                                    if ((widget.qa!.id ?? 0) == 0) {
                                      _showMultiSelectEmployeeZonal(context);
                                    }
                                  },
                                  child: CommonTextFormField(
                                    labeltxt: (Constants.AUTH_ROLEID == Constants.SALE) ? "Distributor" : "Employees",
                                    labeltxtColor: Constant.textFormFieldColor,
                                    isNonEditable: widget.qa!.id != null,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          if ((widget.qa!.id ?? 0) == 0) {
                                            _selectFromDate(context, false, _fromdatecontroller, "fromDate");
                                          }
                                        },
                                        child: CommonTextFormField(
                                          labeltxt: "Valid From",
                                          labeltxtColor: Constant.textFormFieldColor,
                                          isNonEditable: widget.qa!.id != null,
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
                                        )),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          if ((widget.qa!.id ?? 0) == 0) {
                                            _selectFromDate(context, false, _todatecontroller, "toDate");
                                          }
                                        },
                                        child: CommonTextFormField(
                                          labeltxt: "Valid To",
                                          labeltxtColor: Constant.textFormFieldColor,
                                          isNonEditable: widget.qa!.id != null,
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
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CommonTextFormField(
                                  labeltxt: "Quantity",
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
                                  onChanged: (String? value) {
                                    // calculatePrice();
                                    setState(() {});
                                  }),
                              const SizedBox(height: 16.0),
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
                                        // BlocProvider.of<QuantityAllocationCreateUpdateBloc>(context)
                                        //     .add(LoadQuantityAllocationCreateUpdateRequest());
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
                                        submitQuantityAllocation();
                                        // if (_quantitycontroller.text
                                        //     .toString() == "") {
                                        //   return;
                                        // }
                                        //   BlocProvider.of<QuantityAllocationBloc>(ctx).add(
                                        //       SaveQuantityRequest(
                                        //           userId: Constants.AUTH_USERID,
                                        //           oilTypeId: oilTypeId,
                                        //           specialtyLimitId: specialityLimitId,
                                        //           skuId: skuId,
                                        //           quantity: double.parse(
                                        //               _quantitycontroller.text.toString())));
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
                _employeeController.text = listModel.customerName != null
                    ? listModel.customerName.toString()
                    : selectedEmployeeIds.length.toString() + (selectedEmployeeIds.length > 1 ? " Employees selected" : " Employee selected");
              });
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
            items: distributorList.map((dist) => MultiSelectItem<DistributorList>(dist, dist.employeeName.toString())).toList(),
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

  _selectFromDate(BuildContext context, bool popup, TextEditingController dateController, String type) async {
    DateTime initialDate = dateController.text.toString() == "" ? DateTime.now() : DateTimeUtils().convertDateType(dateController.text);

    final DateTime? selected = await showDatePicker(context: context, initialDate: initialDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));

    if (selected != null) {
      if (type == "fromDate") {
        final TimeOfDay? pickedS = await showTimePicker(
          context: context,
          initialTime: selectedFromTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            );
          },
        );
        if (pickedS != null && pickedS != selectedFromTime) {
          setState(() {
            selectedFromTime = pickedS;
          });
        }

        if (_todatecontroller.text.isEmpty) {
          dateController.text =
              DateTimeUtils().dateToStringFormat(DateTime(selected.year, selected.month, selected.day, selectedFromTime.hour, selectedFromTime.minute), DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
        } else {
          String differences = DateTimeUtils().compareTwoDates(selected, DateTimeUtils().convertDateType(_todatecontroller.text));
          if (differences == ("date1 is later than date2")) {
            Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select correct From Date");
          } else {
            dateController.text =
                DateTimeUtils().dateToStringFormat(DateTime(selected.year, selected.month, selected.day, selectedFromTime.hour, selectedFromTime.minute), DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
          }
        }
      } else {
        final TimeOfDay? pickedS = await showTimePicker(
          context: context,
          initialTime: selectedToTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            );
          },
        );
        if (pickedS != null && pickedS != selectedToTime) {
          setState(() {
            selectedToTime = pickedS;
          });
        }

        if (_fromdatecontroller.text.isEmpty) {
          dateController.text =
              DateTimeUtils().dateToStringFormat(DateTime(selected.year, selected.month, selected.day, selectedToTime.hour, selectedToTime.minute), DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
        } else {
          String differences = DateTimeUtils().compareTwoDates(DateTimeUtils().convertDateType(_fromdatecontroller.text), selected);
          if (differences == ("date1 is later than date2")) {
            Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select correct To Date");
          } else {
            dateController.text =
                DateTimeUtils().dateToStringFormat(DateTime(selected.year, selected.month, selected.day, selectedToTime.hour, selectedToTime.minute), DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
          }
        }
      }
    }
  }

  void submitQuantityAllocation() {
    if ((selectedSalesOrg == null) || (selectedSalesOrg!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select the Sales Organization");
    } else if ((selectedDistrChannel == null) || (selectedDistrChannel!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select the Distribution Channel");
    } else if ((selectedVertical == null) || (selectedVertical!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select the Division");
    } else if ((selectedOilType == null) || (selectedOilType!.id ?? 0) == 0) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select the Oil Type");
    }
    /* else if (selectedMaterialIds.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please select the Materials");
    }*/
    else if (selectedEmployeeIds.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please select the Employees");
    } else if (_fromdatecontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please enter the From Date");
    } else if (_todatecontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please enter the To Date");
    } else if (_quantitycontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error", successText: "Please enter the Quantity");
    } else {
      QuantityAllocationCreateReq allocationCreateReq = QuantityAllocationCreateReq();

      if ((widget.qa!.id ?? 0) != 0) {
        allocationCreateReq.id = widget.qa!.id;
      }

      allocationCreateReq.verticleId = selectedVertical!.id;
      allocationCreateReq.salesOrganizationId = selectedSalesOrg!.id;
      allocationCreateReq.distributionChannelId = selectedDistrChannel!.id;
      allocationCreateReq.oilTypeId = selectedOilType!.id;

      allocationCreateReq.loginUserId = Constants.AUTH_USERID;
      // allocationCreateReq.skuIds = selectedMaterialIds;
      allocationCreateReq.customerId = selectedEmployeeIds;

      allocationCreateReq.validFrom = DateTimeUtils().dateToServerToDateFormat(_fromdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_HH_MM_24, DateTimeUtils.ServerFormat1);
      allocationCreateReq.validTo = DateTimeUtils().dateToServerToDateFormat(_todatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_HH_MM_24, DateTimeUtils.ServerFormat1);

      // allocationCreateReq.validFrom =
      //     DateTimeUtils().convertDateType(_fromdatecontroller.text).toString();
      // allocationCreateReq.validTo =
      //     DateTimeUtils().convertDateType(_todatecontroller.text).toString();

      allocationCreateReq.quantityLimit = double.parse(_quantitycontroller.text);

      BlocProvider.of<QACreateUpdateBloc>(context).add(SaveQuantityRequest(allocationCreateReq: allocationCreateReq));
    }
  }
}
