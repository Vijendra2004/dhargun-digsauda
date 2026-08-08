import 'package:adaniwilmar/models/SaudaRestrictionListModel.dart';
import 'package:adaniwilmar/models/SaveSaudaRestReqmodel.dart';
import 'package:adaniwilmar/models/StateTraderModel.dart';
import 'package:adaniwilmar/screen/quantity_allocation/bloc/bloc.dart';
import 'package:adaniwilmar/screen/quantity_allocation/bloc/quantity_allocation_event.dart';
import 'package:adaniwilmar/screen/sauda_restrictions/sauda_restiction_add/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda_restrictions/sauda_restiction_add/bloc/sauda_restriction_add_screen_event.dart';
import 'package:adaniwilmar/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constant.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/RolesResponse.dart';
import '../../../utils/datetime_utils.dart';
import '../../../widget/ModalRoundedProgressBar.dart';
import '../../../widget/curved_border_box.dart';
import '../../../widget/custom_appbar.dart';
import '../../../widget/floating_button.dart';
import '../../../widget/common_dropdown_button_form_field.dart';
import '../../../widget/multiselect/dialog/mult_select_dialog.dart';
import '../../../widget/multiselect/util/multi_select_item.dart';

class SaudaAddRestrictionScreen extends StatefulWidget {
  final SaudaItem? saudaItem;

  const SaudaAddRestrictionScreen({Key? key, this.saudaItem}) : super(key: key);

  // Constructor with parameter
  const SaudaAddRestrictionScreen.withItem({Key? key, this.saudaItem})
      : super(key: key);

  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SaudaAddRestrictionScreen());
  }

  @override
  State<SaudaAddRestrictionScreen> createState() =>
      _SaudaAddRestrictionScreenState();
}

class _SaudaAddRestrictionScreenState extends State<SaudaAddRestrictionScreen> {
  int saudaId = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SaudaRestrictionAddScreenBloc()..add(LoadRolesList()),
      child: SaudaAddRestrictionPage(saudaItem: widget.saudaItem),
    );
  }
}

class SaudaAddRestrictionPage extends StatefulWidget {
  final SaudaItem? saudaItem;

  const SaudaAddRestrictionPage({Key? key, this.saudaItem}) : super(key: key);

  @override
  State<SaudaAddRestrictionPage> createState() => _SaudaAddRestrictionState();
}

class _SaudaAddRestrictionState extends State<SaudaAddRestrictionPage> {
  double totalPrice = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  ProgressBarHandler? _handler;
  bool isLoading = false;
  List<RoleItem> rolesList = [];
  List<TradersNameItems> tradersNameList = [];
  List<TradersNameItems> oilItemsList = [];
  RoleItem selectedRoleItem = RoleItem();
  List<TradersNameItems> selectedStateTraderItems = [];
  List<TradersNameItems> selectedZoneTraderItems = [];
  List<TradersNameItems> selectedDistributorItems = [];
  List<TradersNameItems> selectedOilTypeItems = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _stateTraderController = TextEditingController();
  final TextEditingController _zoneTraderController = TextEditingController();
  final TextEditingController _distributorController = TextEditingController();
  final TextEditingController _oilTypeController = TextEditingController();
  bool isDisableStateTradersList = true;
  bool isDisableZoneTradersList = true;
  bool isDisableDistributorTradersList = true;
  bool isDisableOilType = true;
  String selectedRoles = "";
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<SaudaRestrictionAddScreenBloc,
            SaudaRestrictionAddScreenState>(
        listener: (context, state) {
          if (state is OnAddResSuccess) {
            rolesList.clear();
            rolesList.add(RoleItem(id: 0, name: "Select Role"));
            rolesList.addAll(state.rolesList ?? []);
            // this block is for editing the items
            if (rolesList.isNotEmpty) {
              if (widget.saudaItem != null &&
                  widget.saudaItem!.roleId != null) {
                isActive = widget.saudaItem!.isActive ?? false;
                _startDateController.text = DateTimeUtils.formatDateFromString(
                    widget.saudaItem!.startDate ?? "",
                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                    toFormat: "dd-MM-yyyy HH:mm:ss");
                selectedRoleItem = rolesList.firstWhere(
                  (item) => item.id == widget.saudaItem!.roleId,
                  orElse: () => rolesList[0], // fallback
                );
              } else {
                // No edit data → default first item
                selectedRoleItem = rolesList[0];
              }
              if (selectedRoleItem.name != null &&
                  selectedRoleItem.name!.contains("State")) {
                BlocProvider.of<SaudaRestrictionAddScreenBloc>(context)
                    .add(LoadStateTraderList());
              } else if (selectedRoleItem.name != null &&
                  selectedRoleItem.name!.contains("Zonal")) {
                BlocProvider.of<SaudaRestrictionAddScreenBloc>(context)
                    .add(LoadZoneTraderList());
              } else if (selectedRoleItem.name != null &&
                  selectedRoleItem.name!.contains("Distributors")) {
                BlocProvider.of<SaudaRestrictionAddScreenBloc>(context)
                    .add(LoadDistributorList());
              }

              setState(() {});
              BlocProvider.of<SaudaRestrictionAddScreenBloc>(context)
                  .add(LoadRestrictionOilType());
            } else {
              selectedRoleItem = RoleItem();
            }
          }
          if (state is OnStateTraderResponse) {
            if (tradersNameList.isNotEmpty) {
              tradersNameList.clear();
            }
            selectedRoles = "State Traders";
            tradersNameList.addAll(state.items ?? []);

            if (tradersNameList.isNotEmpty && widget.saudaItem != null) {
              selectedStateTraderItems = tradersNameList
                  .where((item) => widget.saudaItem!.userIds!.contains(item.id))
                  .toList();
              if (selectedStateTraderItems.isNotEmpty) {
                isDisableStateTradersList = false;
                isDisableOilType = false;
                _stateTraderController.text =
                    selectedStateTraderItems.length.toString() +
                        " State Traders Selected";
              } else {
                _stateTraderController.text = "All State Traders";
              }
            }

            setState(() {});
          }

          if (state is OnZoneTraderResponse) {
            if (tradersNameList.isNotEmpty) {
              tradersNameList.clear();
            }
            selectedRoles = "Zonal Traders";
            tradersNameList.addAll(state.zoneItems ?? []);
            if (tradersNameList.isNotEmpty && widget.saudaItem != null) {
              selectedZoneTraderItems = tradersNameList
                  .where((item) => widget.saudaItem!.userIds!.contains(item.id))
                  .toList();
              if (selectedZoneTraderItems.isNotEmpty) {
                isDisableZoneTradersList = false;
                isDisableOilType = false;
                _zoneTraderController.text =
                    selectedZoneTraderItems.length.toString() +
                        " Zonal Traders Selected";
              } else {
                _zoneTraderController.text = "All State Traders";
              }
            }
            setState(() {});
          }

          if (state is OnDistributorsResponse) {
            if (tradersNameList.isNotEmpty) {
              tradersNameList.clear();
            }
            selectedRoles = "Distributors";
            tradersNameList.addAll(state.distributorsItems ?? []);
            if (tradersNameList.isNotEmpty && widget.saudaItem != null) {
              selectedDistributorItems = tradersNameList
                  .where((item) => widget.saudaItem!.userIds!.contains(item.id))
                  .toList();
              if (selectedDistributorItems.isNotEmpty) {
                isDisableDistributorTradersList = false;
                isDisableOilType = true;
                _distributorController.text =
                    selectedDistributorItems.length.toString() +
                        " Distributors Selected";
              } else {
                _distributorController.text = "All State Traders";
              }
            }
            setState(() {});
          }

          if (state is OnOilResponse) {
            if (oilItemsList.isNotEmpty) {
              oilItemsList.clear();
            }
            oilItemsList.addAll(state.oilItems ?? []);

            if (widget.saudaItem != null) {
              selectedOilTypeItems = oilItemsList
                  .where((element) =>
                      widget.saudaItem!.oilTypeIds!.contains(element.id))
                  .toList();
              if (selectedOilTypeItems.isNotEmpty) {
                _oilTypeController.text =
                    selectedOilTypeItems.length.toString() +
                        " Oil Types Selected";
              } else {
                _oilTypeController.text = "All Oil Types";
              }
            }
            setState(() {});
          }
          if (state is OnRestSaveSuccess) {
            showSuccessDlg(context, state.message,"Success");
          }
          if (state is OnUpdateResponse) {
            showSuccessDlg(context, state.message,"Success");
          }

          if (state is OnResFailure) {
            _showAlertDialog(context, state.errorMessage);
          }
          if (state is ShowAddResProgressBar) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is HideAddResProgressBar) {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Sauda Booking Restriction",
            backArrow: true,
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CurveBorderBox(
                          boxBgColor: const Color(0xFFFFFBF5),
                          boxShadowColor: const Color(0xFFFFFFFF),
                          boxofWidget: Container(
                            margin: const EdgeInsets.all(5.0),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:
                                            CommonDropdownButtonFormField<RoleItem>(
                                          value: selectedRoleItem,
                                          label: "Roles",
                                          onChanged: (RoleItem? newValue) {
                                            if (newValue == null) return;
                                            setState(() {
                                              selectedRoleItem = newValue;
                                            });
                                            GMLogger.v(
                                                "Selected Role: ${selectedRoleItem.id}");
                                            if (selectedRoleItem.name!
                                                .contains("State")) {
                                              BlocProvider.of<
                                                          SaudaRestrictionAddScreenBloc>(
                                                      context)
                                                  .add(LoadStateTraderList());
                                              setState(() {
                                                isDisableZoneTradersList = true;
                                                isDisableOilType = false;
                                                isDisableDistributorTradersList =
                                                    true;
                                                isDisableStateTradersList =
                                                    false;
                                                selectedZoneTraderItems = [];
                                                selectedDistributorItems = [];
                                                selectedOilTypeItems = [];
                                                _zoneTraderController.text = "";
                                                _distributorController.text =
                                                    "";
                                                _oilTypeController.text = "";
                                              });
                                            } else if (selectedRoleItem.name!
                                                .contains("Zonal")) {
                                              BlocProvider.of<
                                                          SaudaRestrictionAddScreenBloc>(
                                                      context)
                                                  .add(LoadZoneTraderList());
                                              setState(() {
                                                isDisableOilType = false;
                                                isDisableZoneTradersList =
                                                    false;
                                                isDisableStateTradersList =
                                                    true;
                                                isDisableDistributorTradersList =
                                                    true;
                                                selectedStateTraderItems = [];
                                                selectedDistributorItems = [];
                                                selectedOilTypeItems = [];
                                                _stateTraderController.text =
                                                    "";
                                                _distributorController.text =
                                                    "";
                                                _oilTypeController.text = "";
                                              });
                                            } else if (selectedRoleItem.name!
                                                .contains("Distributors")) {
                                              BlocProvider.of<
                                                          SaudaRestrictionAddScreenBloc>(
                                                      context)
                                                  .add(LoadDistributorList());
                                              setState(() {
                                                isDisableOilType = true;
                                                isDisableDistributorTradersList =
                                                    false;
                                                isDisableStateTradersList =
                                                    true;
                                                isDisableZoneTradersList = true;
                                                selectedStateTraderItems = [];
                                                selectedZoneTraderItems = [];
                                                selectedOilTypeItems = [];
                                                _zoneTraderController.text = "";
                                                _stateTraderController.text =
                                                    "";
                                                _oilTypeController.text = "";
                                              });
                                            } else {
                                              setState(() {
                                                isDisableStateTradersList =
                                                    true;
                                                isDisableZoneTradersList = true;
                                                isDisableDistributorTradersList =
                                                    true;
                                                selectedStateTraderItems = [];
                                                selectedZoneTraderItems = [];
                                                selectedDistributorItems = [];
                                                selectedOilTypeItems = [];
                                                _stateTraderController.text =
                                                    "";
                                                _zoneTraderController.text = "";
                                                _distributorController.text =
                                                    "";
                                                _oilTypeController.text = "";
                                                isDisableOilType = true;
                                              });
                                            }
                                          },
                                          items: rolesList
                                              .map<DropdownMenuItem<RoleItem>>(
                                                  (value) {
                                            return DropdownMenuItem<RoleItem>(
                                              value: value,
                                              child: Text(value.name != null
                                                  ? value.name!
                                                  : ""),
                                            );
                                          }).toList(),
                                        )),
                                    const SizedBox(height: 15),
                                    InkWell(
                                        onTap: () {
                                          _selectFromDate(
                                              context, _startDateController);
                                        },
                                        child: CommonTextFormField(
                                          labeltxt: "Start Date",
                                          labeltxtColor:
                                              Constant.textFormFieldColor,
                                          labeltxtSize:
                                              Constant.textFormFieldSize,
                                          labeltxtFontWeight:
                                              Constant.textFormFieldSizeFontW,
                                          focuBorColor: Constant.colorBlack,
                                          focuBorWid:
                                              Constant.textFormFocuBorWid,
                                          enaBorColor: Constant.colorBlack,
                                          enaBorWid: Constant.textFormEnaBorWid,
                                          borderRadiusTL:
                                              Constant.textFormborderRadiusTL,
                                          borderRadiusBR:
                                              Constant.textFormborderRadiusBR,
                                          contentPadHor:
                                              Constant.textFormcontentPadHor,
                                          contentPadHVer:
                                              Constant.textFormcontentPadHVer,
                                          controllerTxt: _startDateController,
                                          enabled: false,
                                          calIcon: true,
                                        )),
                                    const SizedBox(height: 15),
                                    Visibility(
                                      visible: !isDisableStateTradersList,
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return MultiSelectDialog<
                                                    TradersNameItems>(
                                                  searchable: true,
                                                  selectAll: true,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.98,
                                                  itemsTextStyle: TextStyle(
                                                      fontFamily: 'Aganè',
                                                      fontSize:
                                                          Constant.fontSize14,
                                                      color:
                                                          Constant.colorBlack),
                                                  selectedItemsTextStyle:
                                                      TextStyle(
                                                          fontFamily: 'Aganè',
                                                          fontSize: Constant
                                                              .fontSize14,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight600),
                                                  items: tradersNameList
                                                      .map((trader) =>
                                                          MultiSelectItem<
                                                                  TradersNameItems>(
                                                              trader,
                                                              trader.name!))
                                                      .toList(),
                                                  initialValue:
                                                      selectedStateTraderItems,
                                                  onConfirm:
                                                      (List<TradersNameItems>
                                                          values) {
                                                    selectedStateTraderItems =
                                                        values;
                                                    if (selectedStateTraderItems
                                                        .isNotEmpty) {
                                                      _stateTraderController
                                                              .text =
                                                          selectedStateTraderItems
                                                                  .length
                                                                  .toString() +
                                                              " State Traders Selected";
                                                    } else {
                                                      _stateTraderController
                                                              .text =
                                                          "All State Traders";
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: CommonTextFormField(
                                            labeltxt: selectedRoles,
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
                                            enaBorWid:
                                                Constant.textFormEnaBorWid,
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
                                            controllerTxt:
                                                _stateTraderController,
                                          )),
                                    ),
                                    Visibility(
                                      visible: !isDisableZoneTradersList,
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return MultiSelectDialog<
                                                    TradersNameItems>(
                                                  searchable: true,
                                                  selectAll: true,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.98,
                                                  itemsTextStyle: TextStyle(
                                                      fontFamily: 'Aganè',
                                                      fontSize:
                                                          Constant.fontSize14,
                                                      color:
                                                          Constant.colorBlack),
                                                  selectedItemsTextStyle:
                                                      TextStyle(
                                                          fontFamily: 'Aganè',
                                                          fontSize: Constant
                                                              .fontSize14,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight600),
                                                  items: tradersNameList
                                                      .map((trader) =>
                                                          MultiSelectItem<
                                                                  TradersNameItems>(
                                                              trader,
                                                              trader.name!))
                                                      .toList(),
                                                  initialValue:
                                                      selectedZoneTraderItems,
                                                  onConfirm:
                                                      (List<TradersNameItems>
                                                          values) {
                                                    selectedZoneTraderItems =
                                                        values;
                                                    if (selectedZoneTraderItems
                                                        .isNotEmpty) {
                                                      _zoneTraderController
                                                              .text =
                                                          selectedZoneTraderItems
                                                                  .length
                                                                  .toString() +
                                                              " Zonal Traders Selected";
                                                    } else {
                                                      _zoneTraderController
                                                              .text =
                                                          "All Zonal Traders";
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: CommonTextFormField(
                                            labeltxt: selectedRoles,
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
                                            enaBorWid:
                                                Constant.textFormEnaBorWid,
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
                                            controllerTxt:
                                                _zoneTraderController,
                                          )),
                                    ),
                                    Visibility(
                                      visible: !isDisableDistributorTradersList,
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return MultiSelectDialog<
                                                    TradersNameItems>(
                                                  searchable: true,
                                                  selectAll: true,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.98,
                                                  itemsTextStyle: TextStyle(
                                                      fontFamily: 'Aganè',
                                                      fontSize:
                                                          Constant.fontSize14,
                                                      color:
                                                          Constant.colorBlack),
                                                  selectedItemsTextStyle:
                                                      TextStyle(
                                                          fontFamily: 'Aganè',
                                                          fontSize: Constant
                                                              .fontSize14,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight600),
                                                  items: tradersNameList
                                                      .map((trader) =>
                                                          MultiSelectItem<
                                                                  TradersNameItems>(
                                                              trader,
                                                              trader.name!))
                                                      .toList(),
                                                  initialValue:
                                                      selectedDistributorItems,
                                                  onConfirm:
                                                      (List<TradersNameItems>
                                                          values) {
                                                    selectedDistributorItems =
                                                        values;
                                                    if (selectedDistributorItems
                                                        .isNotEmpty) {
                                                      _distributorController
                                                              .text =
                                                          selectedDistributorItems
                                                                  .length
                                                                  .toString() +
                                                              " Distributors Selected";
                                                    } else {
                                                      _distributorController
                                                              .text =
                                                          "All Distributors";
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: CommonTextFormField(
                                            labeltxt: selectedRoles,
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
                                            enaBorWid:
                                                Constant.textFormEnaBorWid,
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
                                            controllerTxt:
                                                _distributorController,
                                          )),
                                    ),
                                    const SizedBox(height: 15),
                                    Visibility(
                                      visible: !isDisableOilType,
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return MultiSelectDialog<
                                                    TradersNameItems>(
                                                  searchable: true,
                                                  selectAll: true,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.98,
                                                  itemsTextStyle: TextStyle(
                                                      fontFamily: 'Aganè',
                                                      fontSize:
                                                          Constant.fontSize14,
                                                      color:
                                                          Constant.colorBlack),
                                                  selectedItemsTextStyle:
                                                      TextStyle(
                                                          fontFamily: 'Aganè',
                                                          fontSize: Constant
                                                              .fontSize14,
                                                          color: Constant
                                                              .colorBlack,
                                                          fontWeight: Constant
                                                              .fontWeight600),
                                                  items: oilItemsList
                                                      .map((trader) =>
                                                          MultiSelectItem<
                                                                  TradersNameItems>(
                                                              trader,
                                                              trader.name!))
                                                      .toList(),
                                                  initialValue:
                                                      selectedOilTypeItems,
                                                  onConfirm:
                                                      (List<TradersNameItems>
                                                          values) {
                                                    selectedOilTypeItems =
                                                        values;
                                                    if (selectedOilTypeItems
                                                        .isNotEmpty) {
                                                      _oilTypeController.text =
                                                          selectedOilTypeItems
                                                                  .length
                                                                  .toString() +
                                                              " oil Selected";
                                                    } else {
                                                      _oilTypeController.text =
                                                          "All Oil Types";
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: CommonTextFormField(
                                            labeltxt: "Oil Type",
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
                                            enaBorWid:
                                                Constant.textFormEnaBorWid,
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
                                            controllerTxt: _oilTypeController,
                                          )),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isActive,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isActive = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          "Is Active",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              )),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 15),
                      child: Row(children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.orange)),
                              onPressed: () {
                                if (selectedRoleItem.name!.contains("Select")) {
                                  _showAlertDialog(
                                      context, "Please select a valid Role");
                                  return;
                                }
                                if (_startDateController.text.toString() ==
                                    "") {
                                  _showAlertDialog(
                                      context, "Please select Start Date");
                                  return;
                                }
                                if (selectedRoleItem.name!
                                    .contains("Distributors")) {
                                  if (selectedDistributorItems.isEmpty) {
                                    _showAlertDialog(context,
                                        "Please select at least one Distributor");
                                    return;
                                  }
                                }
                                if (selectedRoleItem.name!.contains("State")) {
                                  if (selectedStateTraderItems.isEmpty) {
                                    _showAlertDialog(context,
                                        "Please select at least one State Trader");
                                    return;
                                  }
                                }
                                if (selectedRoleItem.name!.contains("Zonal")) {
                                  if (selectedZoneTraderItems.isEmpty) {
                                    _showAlertDialog(context,
                                        "Please select at least one Zonal Trader");
                                    return;
                                  }
                                }
                                if (selectedRoleItem.name!.contains("State") ||
                                    selectedRoleItem.name!.contains("Zonal")) {
                                  if (selectedOilTypeItems.isEmpty) {
                                    _showAlertDialog(context,
                                        "Please select at least one Oil Type");
                                    return;
                                  }
                                }

                                if (widget.saudaItem != null &&
                                    widget.saudaItem?.id != null) {
                                  _updateSaudaRestrictionApiCall(
                                      widget.saudaItem?.id,
                                      context,
                                      selectedRoleItem,
                                      _startDateController.text.toString(),
                                      selectedStateTraderItems,
                                      selectedZoneTraderItems,
                                      selectedDistributorItems,
                                      selectedOilTypeItems,
                                      isActive);
                                } else {
                                  _submitSaudaRestrictionAddApiCall(
                                      context,
                                      selectedRoleItem,
                                      _startDateController.text.toString(),
                                      selectedStateTraderItems,
                                      selectedZoneTraderItems,
                                      selectedDistributorItems,
                                      selectedOilTypeItems,
                                      isActive);
                                }
                              },
                              child: Text("Submit",
                                  style: TextStyle(
                                      fontSize: Constant.fontSize18,
                                      fontWeight: Constant.fontWeight600,
                                      color: Colors.white))),
                        )
                      ]),
                    )),
              ),
            ],
          ),
        ));
  }

  void _submitSaudaRestrictionAddApiCall(
      BuildContext context,
      RoleItem selectedRoleItem,
      String date,
      List<TradersNameItems> selectedStateTraderItems,
      List<TradersNameItems> selectedZoneTraderItems,
      List<TradersNameItems> selectedDistributorItems,
      List<TradersNameItems> selectedOilTypeItems,
      bool isActive) {
    List<int> stateTraderIds = selectedStateTraderItems
        .where((item) => item.id != null)
        .map((item) => item.id!)
        .toList();
    List<int> distributosIds = selectedDistributorItems
        .where((item) => item.id != null)
        .map((item) => item.id!)
        .toList();
    List<int> zonalids = selectedZoneTraderItems
        .where((item) => item.id != null)
        .map((item) => item.id!)
        .toList();
    List<int> oilIds = selectedOilTypeItems
        .where((item) => item.id != null)
        .map((item) => item.id!)
        .toList();
    GMLogger.v("selectedItem--${selectedRoleItem.id}");
    SaveSaudaRestReqmodel saudaRestReqmodel = new SaveSaudaRestReqmodel();
    saudaRestReqmodel.roleId = selectedRoleItem.id;
    saudaRestReqmodel.isActive = isActive;
    saudaRestReqmodel.startDate = DateTimeUtils().dateFormatConversion(
        date);
    saudaRestReqmodel.userIdsForDistributor =
        distributosIds.isNotEmpty ? distributosIds : null;
    saudaRestReqmodel.userIdsForStateTrader =
        stateTraderIds.isNotEmpty ? stateTraderIds : null;
    saudaRestReqmodel.userIdsForZonalTrader =
        zonalids.isNotEmpty ? zonalids : null;
    saudaRestReqmodel.oilTypeIds = oilIds.isNotEmpty ? oilIds : null;

    BlocProvider.of<SaudaRestrictionAddScreenBloc>(context)
        .add(OnSaveSaudaRestriction(saudaRestReqmodel));
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
        String? successText = 'Sauda Booking Configuration successfully done',
        Color? titleColor = Colors.white,
        bool? closeScreen = false}) {
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
      title: SizedBox.shrink(),
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
                    child: title == "Error"
                        ? Icon(Icons.error_outlined,
                        size: 70, color: Colors.red)
                        : Icon(Icons.check_circle_sharp,
                        size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title!,
                        style: TextStyle(
                            fontSize: Constant.fontSize20,
                            fontWeight: Constant.fontWeight600)),
                  ),
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(messageValue!,
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
                buttonName: "Ok",
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
                  Navigator.pop(context, true);
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
}

void _updateSaudaRestrictionApiCall(
    int? id,
    BuildContext context,
    RoleItem selectedRoleItem,
    String date,
    List<TradersNameItems> selectedStateTraderItems,
    List<TradersNameItems> selectedZoneTraderItems,
    List<TradersNameItems> selectedDistributorItems,
    List<TradersNameItems> selectedOilTypeItems,
    bool isActive) {
  List<int> stateTraderIds = selectedStateTraderItems
      .where((item) => item.id != null)
      .map((item) => item.id!)
      .toList();
  List<int> distributosIds = selectedDistributorItems
      .where((item) => item.id != null)
      .map((item) => item.id!)
      .toList();
  List<int> zonalids = selectedZoneTraderItems
      .where((item) => item.id != null)
      .map((item) => item.id!)
      .toList();
  List<int> oilIds = selectedOilTypeItems
      .where((item) => item.id != null)
      .map((item) => item.id!)
      .toList();
  GMLogger.v("selectedItem--${selectedRoleItem.id}");
  SaveSaudaRestReqmodel saudaRestReqmodel = new SaveSaudaRestReqmodel();
  saudaRestReqmodel.roleId = selectedRoleItem.id;
  saudaRestReqmodel.id = id ?? 0;
  saudaRestReqmodel.isActive = isActive;
  saudaRestReqmodel.startDate = DateTimeUtils().dateFormatConversion(
      date);
  saudaRestReqmodel.userIdsForDistributor =
      distributosIds.isNotEmpty ? distributosIds : null;
  saudaRestReqmodel.userIdsForStateTrader =
      stateTraderIds.isNotEmpty ? stateTraderIds : null;
  saudaRestReqmodel.userIdsForZonalTrader =
      zonalids.isNotEmpty ? zonalids : null;
  saudaRestReqmodel.oilTypeIds = oilIds.isNotEmpty ? oilIds : null;

  BlocProvider.of<SaudaRestrictionAddScreenBloc>(context)
      .add(OnUpdateSaudaRestriction(saudaRestReqmodel));
}

void _showAlertDialog(BuildContext context, String s) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text(s),
        actions: [
          TextButton(
            onPressed: () {

              // TODO: Add functionality for the "OK" button
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showSuccessDialog(BuildContext mainContext, String s) {
  showDialog(
    context: mainContext,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text(s),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(mainContext, true);
              // TODO: Add functionality for the "OK" button
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

_selectFromDate(
    BuildContext context, TextEditingController startDateController) async {
  TimeOfDay selectedTime = TimeOfDay.now();

  final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: startDateController.text.toString() == ""
          ? DateTime.now()
          : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
              startDateController.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format,
              DateTimeUtils.YYYY_MM_DD_Format)),
      firstDate: DateTime.now(),
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
      selectedTime = picked_s;
    }
    startDateController.text = DateTimeUtils().dateToStringFormat(
        DateTime(selected.year, selected.month, selected.day, selectedTime.hour,
            selectedTime.minute),
        DateTimeUtils.DD_MM_YYYY_HH_MM_24_format);
  }
}
