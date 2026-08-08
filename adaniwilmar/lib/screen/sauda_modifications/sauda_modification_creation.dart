import 'package:adaniwilmar/models/ContractNoModel.dart';
import 'package:adaniwilmar/models/ModOilMaterialResponse.dart';
import 'package:adaniwilmar/models/OilResponseModel.dart';
import 'package:adaniwilmar/models/ToSKUUpdateModel.dart';
import 'package:adaniwilmar/models/toSkuResponseModel.dart';
import 'package:adaniwilmar/screen/sauda_modifications/bloc/bloc.dart';
import 'package:adaniwilmar/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constant.dart';
import '../../../widget/ModalRoundedProgressBar.dart';
import '../../../widget/custom_appbar.dart';
import '../../models/DistributorListModel.dart';
import '../../models/SaudaModificationCreationModel.dart';
import '../../models/SaudaRestrictionListModel.dart';
import '../../models/ToSkuArrayItem.dart';
import '../../utils/constant.dart';
import '../../widget/common_dropdown_button_form_field.dart';
import '../../widget/autocomplete/autocompleter.dart';

class SaudaModificationCreation extends StatefulWidget {
  final SaudaItem? saudaItem;

  const SaudaModificationCreation({Key? key, this.saudaItem}) : super(key: key);

  // Constructor with parameter
  const SaudaModificationCreation.withItem({Key? key, this.saudaItem})
      : super(key: key);

  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaModificationCreation());
  }

  @override
  State<SaudaModificationCreation> createState() =>
      _SaudaModificationCreationState();
}

class _SaudaModificationCreationState extends State<SaudaModificationCreation> {
  int saudaId = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaModAddScreenBloc()..add(LoadModDealersList()),
      child: SaudaModificationScreen(/*saudaItem: widget.saudaItem*/),
    );
  }
}

class SaudaModificationScreen extends StatefulWidget {
  final SaudaItem? saudaItem;

  const SaudaModificationScreen({Key? key, this.saudaItem}) : super(key: key);

  @override
  State<SaudaModificationScreen> createState() => _SaudaModCreationState();
}

class _SaudaModCreationState extends State<SaudaModificationScreen> {
  double totalPrice = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  ProgressBarHandler? _handler;
  bool isLoading = false;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  TextEditingController _distributorcontroller = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  final TextEditingController _fromSkuCaseController = TextEditingController();
  final TextEditingController _fromSkuinMTController = TextEditingController();
  final TextEditingController _mtDifferenceController =
      TextEditingController(text: "0");
  final TextEditingController _commonController = TextEditingController();
  late TextEditingController _toSkuCaseController;
  late TextEditingController _toSkuinMTController;
  late TextEditingController _toMaterialController;

  String MTdifference = "0";
  List<DistributorListItem> distList = [];
  List<ContractNoItem> contractItem = [];
  List<ModOilMaterial> oilListItems = [];
  List<OilType> oilNoList = [];
  List<ModOilMaterialItem> oilMaterialItems = [];
  List<ToSkuItemResp> toSkuItems = [];
  DistributorListItem selectedDistItem = DistributorListItem();
  ContractNoItem selectedContractItem = ContractNoItem();
  ModOilMaterial selectedOilItem = ModOilMaterial();
  OilType selectedOilNoList = OilType();
  ToSkuItemResp selectedToSkuItem = ToSkuItemResp();
  ModOilMaterialItem selectedMaterialItem = ModOilMaterialItem();
  String selectedMaterialQtyCase = "";
  String selectedToMaterialQtyCase = "";
  List<ToSkuArrayItem> toSkuArrayItems = [];
  List<ToSKUItem> toSkuItemList = [];
  ToSKUItem selectedUpdatedToSkuItem = ToSKUItem();
  int isEditSkuArrayItems = -1;

  static String _displayStringForOption(DistributorListItem option) =>
      option.name!;

  static String _displaytoSkuStringForOption(ToSKUItem option) =>
      option.skuName!;

  static String _displayStringForOptionMaterial(ModOilMaterialItem option) =>
      option.skuName!;

  static String _displayStringForOptionTOMaterial(ToSkuItemResp option) =>
      option.skuName!;

  @override
  void dispose() {
    _toMaterialController.dispose();
    _toSkuCaseController.dispose();
    _toSkuinMTController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _toSkuCaseController = TextEditingController();
    _toSkuinMTController = TextEditingController();
    _toMaterialController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<SaudaModAddScreenBloc, SaudaModificationAddScreenState>(
        listener: (context, state) {
          if (state is OnModResFailure) {
            _showAlertDialog(context, state.errorMessage);
          }
          if (state is ShowModProgressBar) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is HideModProgressBar) {
            setState(() {
              isLoading = false;
            });
          }
          if (state is OnDisModSuccess) {
            distList.clear();
            distList.add(DistributorListItem(
                id: 0, name: "Select Distributor", code: "-1"));
            distList.addAll(state.distItems ?? []);
            selectedDistItem = distList[0];
            setState(() {});
          }

          if (state is onLoadContractNumbers) {
            contractItem.clear();
            contractItem.add(
                ContractNoItem(id: 0, saudaNumber: "Select Contract Number"));
            contractItem.addAll(state.contractItem ?? []);
            selectedContractItem = contractItem[0];
            setState(() {});
          }

          if (state is OnLoadModOilList) {
            oilListItems.clear();
            oilListItems.add(
                ModOilMaterial(oilTypeId: 0, oilTypeName: "Select Oil Type"));
            oilListItems.addAll(state.oiltItems ?? []);
            selectedOilItem = oilListItems[0];
            setState(() {});
          }

          if (state is onLoadToSkuItems) {
            toSkuItems.clear();
            toSkuItems
                .add(ToSkuItemResp(skuId: 0, skuName: "Select To SKU Name"));
            toSkuItems.addAll(state.toSkuItems ?? []);
            selectedToSkuItem = toSkuItems[0];
            setState(() {});
          }

          if (state is OnLoadOilListItems) {
            oilNoList.clear();
            oilNoList.addAll(state.oilNoItems ?? []);
            if (oilNoList.isNotEmpty) {
              selectedOilNoList = oilNoList[0];
            }
            setState(() {});
          }

          if (state is OnSaudaModificationToSku) {
            toSkuItemList.clear();
            toSkuItemList
                .add(ToSKUItem(skuId: 0, skuName: "Select To SKU Name"));
            toSkuItemList.addAll(state.skuItem ?? []);
            selectedUpdatedToSkuItem = toSkuItemList[0];
            setState(() {});
          }

          if (state is OnSaudaModCreationSuccess) {
            showSuccessDlg(context, state.message, "Success");
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Sauda Modification",
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
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SizedBox(
                                            child: CustomAutocomplete<
                                                DistributorListItem>(
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              TextEditingController
                                                  fieldTextEditingController,
                                              FocusNode fieldFocusNode,
                                              VoidCallback onFieldSubmitted) {
                                            _distributorcontroller =
                                                fieldTextEditingController;
                                            return TextField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 10.0),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(
                                                              borderRadiusTLBR),
                                                          topRight: Radius.circular(
                                                              borderRadiusTRBL),
                                                          bottomLeft: Radius.circular(
                                                              borderRadiusTRBL),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  borderRadiusTLBR)),
                                                      borderSide: BorderSide(
                                                          color: borderColor!,
                                                          width: 1.0)),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(borderRadiusTLBR),
                                                          topRight: Radius.circular(borderRadiusTRBL),
                                                          bottomLeft: Radius.circular(borderRadiusTRBL),
                                                          bottomRight: Radius.circular(borderRadiusTLBR)),
                                                      borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                  filled: true,
                                                  // hintStyle: TextStyle(color: Colors.grey[800]),
                                                  labelText: "Distributor",
                                                  labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                                  fillColor: fillColor),
                                              controller:
                                                  fieldTextEditingController,
                                              focusNode: fieldFocusNode,
                                              // style: const TextStyle(fontWeight: FontWeight.normal),
                                            );
                                          },
                                          displayStringForOption:
                                              _displayStringForOption,
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return const Iterable<
                                                  DistributorListItem>.empty();
                                            }
                                            return distList.where(
                                                (DistributorListItem option) {
                                              return option.name
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(textEditingValue
                                                      .text
                                                      .toLowerCase());
                                            });
                                          },
                                          onSelected:
                                              (DistributorListItem selection) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() {
                                              selectedDistItem = selection;
                                              selectedContractItem =
                                                  ContractNoItem();
                                              contractItem.clear();
                                            });
                                            BlocProvider.of<
                                                        SaudaModAddScreenBloc>(
                                                    context)
                                                .add(LoadContractNumbers(
                                                    selectedDistItem.id!));
                                          },
                                        ))),
                                    const SizedBox(height: 15),
                                    Visibility(
                                      visible:
                                          true /*selectedDistItem.id != null &&
                                          selectedDistItem.id! > 0*/
                                      ,
                                      child: SizedBox(
                                        width: screenWidth,
                                        child: SizedBox(
                                          child: CommonDropdownButtonFormField<ContractNoItem>(
                                            value: selectedContractItem,
                                            label: "Contract Number",
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                                              labelText: "Contract Number",
                                              labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                              fillColor: fillColor,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                            ),
                                            onChanged: (ContractNoItem? newValue) {
                                              if (newValue == null) return;
                                              setState(() {
                                                selectedContractItem = newValue;
                                              });
                                              /*BlocProvider.of<
                                                              SaudaModAddScreenBloc>(
                                                          context)
                                                      .add(LoadOilAndMaterialAPI(
                                                          selectedContractItem
                                                              .saudaNumber!
                                                              .split("-")[0]));*/

                                              BlocProvider.of<SaudaModAddScreenBloc>(context).add(LoadListofOilItems(
                                                  selectedContractItem.saudaNumber!.split("-")[0]));
                                            },
                                            items: contractItem.map<DropdownMenuItem<ContractNoItem>>((value) {
                                              return DropdownMenuItem<ContractNoItem>(
                                                value: value,
                                                child: Text(value.saudaNumber!),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "Available Sku's",
                                      style: TextStyle(
                                          fontWeight: Constant.fontWeight700),
                                    ),
                                    const SizedBox(height: 10),
                                    _loadOilNumberList(),
                                    const SizedBox(height: 10),
                                    Visibility(
                                      visible: false
                                      /*selectedContractItem.id != null &&
                                              selectedContractItem.id! > 0*/
                                      ,
                                      child: SizedBox(
                                        width: screenWidth,
                                        child: SizedBox(
                                          child: CommonDropdownButtonFormField<ModOilMaterial>(
                                            value: selectedOilItem,
                                            label: "Oil Type",
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                                              labelText: "Oil Type",
                                              labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                              fillColor: fillColor,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                            ),
                                            onChanged: (ModOilMaterial? newValue) {
                                              if (newValue == null) return;
                                              setState(() {
                                                selectedOilItem = newValue;
                                                oilMaterialItems = selectedOilItem.materials ?? [];
                                                _materialController.text = "";
                                                _fromSkuCaseController.text = "";
                                                _fromSkuinMTController.text = "";
                                                selectedMaterialItem = ModOilMaterialItem();
                                                selectedMaterialQtyCase = "";
                                              });
                                            },
                                            items: oilListItems.map<DropdownMenuItem<ModOilMaterial>>((value) {
                                              return DropdownMenuItem<ModOilMaterial>(
                                                value: value,
                                                child: Text(value.oilTypeName!),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          false /*selectedOilItem.oilTypeId != null &&
                                          selectedOilItem.oilTypeId! > 0 &&
                                          selectedContractItem.id != null && selectedContractItem.id! > 0*/
                                      ,
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: SizedBox(
                                              child: CustomAutocomplete<
                                                  ModOilMaterialItem>(
                                            fieldViewBuilder: (BuildContext
                                                    context,
                                                TextEditingController
                                                    fieldTextEditingController,
                                                FocusNode fieldFocusNode,
                                                VoidCallback onFieldSubmitted) {
                                              _materialController =
                                                  fieldTextEditingController;
                                              return TextField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 12.0,
                                                            vertical: 10.0),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(
                                                                borderRadiusTLBR),
                                                            topRight: Radius.circular(
                                                                borderRadiusTRBL),
                                                            bottomLeft: Radius.circular(
                                                                borderRadiusTRBL),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    borderRadiusTLBR)),
                                                        borderSide: BorderSide(
                                                            color: borderColor!,
                                                            width: 1.0)),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(borderRadiusTLBR),
                                                            topRight: Radius.circular(borderRadiusTRBL),
                                                            bottomLeft: Radius.circular(borderRadiusTRBL),
                                                            bottomRight: Radius.circular(borderRadiusTLBR)),
                                                        borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                                    filled: true,
                                                    // hintStyle: TextStyle(color: Colors.grey[800]),
                                                    labelText: "From SKU Name",
                                                    labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                                    fillColor: fillColor),
                                                controller:
                                                    fieldTextEditingController,
                                                focusNode: fieldFocusNode,
                                                // style: const TextStyle(fontWeight: FontWeight.normal),
                                              );
                                            },
                                            displayStringForOption:
                                                _displayStringForOptionMaterial,
                                            optionsBuilder: (TextEditingValue
                                                textEditingValue) {
                                              if (textEditingValue.text == '') {
                                                return const Iterable<
                                                    ModOilMaterialItem>.empty();
                                              }
                                              return oilMaterialItems.where(
                                                  (ModOilMaterialItem option) {
                                                return option.skuName
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(textEditingValue
                                                        .text
                                                        .toLowerCase());
                                              });
                                            },
                                            onSelected:
                                                (ModOilMaterialItem selection) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              setState(() {
                                                selectedMaterialItem =
                                                    selection;
                                                selectedMaterialQtyCase =
                                                    double.parse(selection
                                                            .pendingQuantityInCase
                                                            .toString())
                                                        .toStringAsFixed(3);
                                                _fromSkuCaseController.text =
                                                    double.parse(selection
                                                            .pendingQuantityInCase
                                                            .toString())
                                                        .toStringAsFixed(3);
                                                _fromSkuinMTController
                                                    .text = (double.parse(
                                                            selectedMaterialItem
                                                                .caseToMetricTonValue
                                                                .toString()) *
                                                        double.parse(double.parse(
                                                                selectedMaterialQtyCase)
                                                            .toStringAsFixed(
                                                                3)))
                                                    .toString();
                                              });
                                              BlocProvider.of<
                                                          SaudaModAddScreenBloc>(
                                                      context)
                                                  .add(LoadToSkuFromOIL(
                                                      selectedOilItem.oilTypeId,
                                                      selectedMaterialItem.id));
                                            },
                                          ))),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: Container(),
                                      /*child: CommonTextFormField(
                                        labeltxt: "From SKU Case",
                                        labeltxtColor:
                                            Constant.textFormFieldColor,
                                        labeltxtSize:
                                            Constant.textFormFieldSize,
                                        labeltxtFontWeight:
                                            Constant.textFormFieldSizeFontW,
                                        focuBorColor:
                                            Constant.textFormFocuBorCol,
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
                                        enabled: true,
                                        dropdownIcon: false,
                                        onChanged: (String val) {
                                          if (val.isEmpty) {
                                            _fromSkuinMTController.text = "0";
                                            return;
                                          }
                                          if (double.parse(val) >
                                              double.parse(
                                                  selectedMaterialQtyCase)) {
                                            _showAlertDialog(context,
                                                "Enter valid case quantity");
                                            _fromSkuCaseController.text =
                                                selectedMaterialQtyCase;
                                          }
                                          setState(() {
                                            _fromSkuinMTController
                                                .text = (double.parse(
                                                        selectedMaterialItem
                                                            .caseToMetricTonValue
                                                            .toString()) *
                                                    double.parse(
                                                        _fromSkuCaseController
                                                            .text
                                                            .toString()))
                                                .toString();
                                          });
                                        },
                                        controllerTxt: _fromSkuCaseController,
                                      ),*/
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: Row(
                                        children: [
                                          /* Expanded(
                                            child: CommonTextFormField(
                                              labeltxt: "From SKU in MT",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormFocuBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
                                              borderRadiusTL: Constant
                                                  .textFormborderRadiusTL,
                                              borderRadiusBR: Constant
                                                  .textFormborderRadiusBR,
                                              contentPadHor: Constant
                                                  .textFormcontentPadHor,
                                              contentPadHVer: Constant
                                                  .textFormcontentPadHVer,
                                              keyborType: TextInputType.text,
                                              enabled: false,
                                              dropdownIcon: false,
                                              controllerTxt:
                                                  _fromSkuinMTController,
                                            ),
                                          ),*/
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          /*Expanded(
                                            child: CommonTextFormField(
                                              labeltxt: "MT Difference",
                                              labeltxtColor:
                                                  Constant.textFormFieldColor,
                                              labeltxtSize:
                                                  Constant.textFormFieldSize,
                                              labeltxtFontWeight: Constant
                                                  .textFormFieldSizeFontW,
                                              focuBorColor:
                                                  Constant.textFormFocuBorCol,
                                              focuBorWid:
                                                  Constant.textFormFocuBorWid,
                                              enaBorColor:
                                                  Constant.textFormEnaBorCol,
                                              enaBorWid:
                                                  Constant.textFormEnaBorWid,
                                              borderRadiusTL: Constant
                                                  .textFormborderRadiusTL,
                                              borderRadiusBR: Constant
                                                  .textFormborderRadiusBR,
                                              contentPadHor: Constant
                                                  .textFormcontentPadHor,
                                              contentPadHVer: Constant
                                                  .textFormcontentPadHVer,
                                              keyborType: TextInputType.text,
                                              enabled: false,
                                              dropdownIcon: false,
                                              controllerTxt:
                                                  _mtDifferenceController,
                                            ),
                                          )*/
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          // Background color
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.blue.shade200),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Required To SKU's",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (_fromSkuinMTController
                                                    .text.isNotEmpty) {
                                                  if (double.parse(
                                                          _mtDifferenceController
                                                              .text) <=
                                                      0) {
                                                    if (toSkuArrayItems
                                                        .isEmpty) {
                                                      _showRequiredSkuAlert(
                                                          context, -1);
                                                    } else {
                                                      _showAlertDialog(context,
                                                          "MT Difference should be greater than 0 to add To SKU");
                                                    }
                                                    return;
                                                  } else {
                                                    _showRequiredSkuAlert(
                                                        context, -1);
                                                  }
                                                } else {
                                                  _showAlertDialog(context,
                                                      "Please select From SKU Material and enter valid case quantity");
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  // Button background
                                                  shape: BoxShape
                                                      .circle, // Circle shape
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: toSkuArrayItems.length,
                                      padding: const EdgeInsets.only(top: 5),
                                      itemBuilder: (context, index) {
                                        final item = toSkuArrayItems[index];

                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.toSkuName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "(${item.toSkuMt.toStringAsFixed(3)} MT)",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .blue.shade800),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 0),
                                                            // space between text and underline
                                                            decoration:
                                                                const BoxDecoration(
                                                              border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 0),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              item.toSkuCase
                                                                  .toStringAsFixed(
                                                                      3),
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                        const TextSpan(
                                                          text: "  Case",
                                                          // word part
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .black, // underline only "Case"
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      _showRequiredSkuAlert(
                                                          context, index);
                                                    },
                                                    child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      toSkuArrayItems
                                                          .removeAt(index);
                                                      _mtDifferenceController
                                                          .text = (double.parse(
                                                                  _fromSkuinMTController
                                                                      .text) -
                                                              toSkuArrayItems.fold(
                                                                  0,
                                                                  (sum, item) =>
                                                                      sum +
                                                                      item.toSkuMt))
                                                          .toStringAsFixed(3);
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 15, right: 15, bottom: 15),
                            child: Row(children: [
                              Expanded(
                                child: CommonButton(
                                  buttonName: Constant.saudaLEButtonTxt2,
                                  buttonNameSize: Constant.fontSize13,
                                  buttonNameColor: Constant.pricbuttonTxtColor,
                                  buttonHeight: 48,
                                  buttonColor:
                                      selectedContractItem.saudaNumber !=
                                                  null &&
                                              selectedContractItem.id != 0
                                          ? Constant.pricbuttonColor
                                          : Constant.textFormEnaBorCol,
                                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                                  buttonRadiusBL: Constant.pricbutRadiusBL,
                                  buttonBorder: Colors.transparent,
                                  buttonNameWeight: Constant.fontWeight500,
                                  buttonFunction: () {
                                    if (selectedContractItem.saudaNumber !=
                                        null) {
                                      SaudaModificationCreationModel model =
                                          SaudaModificationCreationModel(
                                              dealerId: selectedDistItem.id!,
                                              loginUserId:
                                                  Constants.AUTH_USERID,
                                              saudaNumber: int.parse(
                                                  selectedContractItem
                                                      .saudaNumber!
                                                      .split("-")[0]),
                                              oilTypes: oilNoList);

                                      BlocProvider.of<SaudaModAddScreenBloc>(
                                              context)
                                          .add(CreateSaudaModificationEvent(
                                              model));
                                    }
                                    //
                                  },
                                ),

                                /* ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.orange)),
                                        onPressed: () {
                                          if (_validationSuccess()) {
                                            List<
                                                SaudaConvertedToSku> toFinalList =
                                            [];
                                            for (var i = 0;
                                            i < toSkuArrayItems.length;
                                            i++) {
                                              SaudaConvertedToSku toSkuItem =
                                              SaudaConvertedToSku();
                                              toSkuItem.quantityInSku =
                                                  toSkuArrayItems[i]
                                                      .toSkuCase
                                                      .round();
                                              toSkuItem.skuId = int.parse(
                                                  toSkuArrayItems[i].toSkuId);
                                              toSkuItem.quantityInMt =
                                                  toSkuArrayItems[i].toSkuMt;
                                              toFinalList.add(toSkuItem);
                                            }
                                            SaudaModificationCreationModel model =
                                            SaudaModificationCreationModel(
                                                dealerId: selectedDistItem.id!,
                                                loginUserId:
                                                Constants.AUTH_USERID,
                                                quantityInMt: double.parse(
                                                    _fromSkuinMTController
                                                        .text),
                                                saudaNumber: int.parse(
                                                    selectedContractItem
                                                        .saudaNumber!
                                                        .split("-")[0]),
                                                oilTypeId:
                                                selectedOilItem.oilTypeId!,
                                                skuId: selectedMaterialItem.id!,
                                                quantityInSku: double.parse(
                                                    _fromSkuCaseController
                                                        .text
                                                        .toString())
                                                    .toInt(),
                                                saudaConvertedToSkuList:
                                                toFinalList);

                                            BlocProvider.of<
                                                SaudaModAddScreenBloc>(
                                                context)
                                                .add(
                                                CreateSaudaModificationEvent(
                                                    model));
                                          }
                                        },
                                    ),*/
                              )
                            ]),
                          )),
                    ),
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
            ],
          ),
        ));
  }

  _addToSku(BuildContext context, PackType pack, OilType oil) {
    /*setState(() {
      toSkuItemList.removeWhere((toSku) =>
          pack.skus!.any((packSku) => packSku.skuId == toSku.skuId)
      );
    });*/

    TextEditingController toSkuNameController = TextEditingController(text: "");
    TextEditingController toSkuCaseController = TextEditingController(text: "");
    TextEditingController toSkuMTController = TextEditingController(text: "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "To SKU's",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AUTOCOMPLETE FIELD
              SizedBox(
                  child: CustomAutocomplete<ToSKUItem>(
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  toSkuNameController = fieldTextEditingController;
                  return TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(borderRadiusTLBR),
                                topRight: Radius.circular(borderRadiusTRBL),
                                bottomLeft: Radius.circular(borderRadiusTRBL),
                                bottomRight: Radius.circular(borderRadiusTLBR)),
                            borderSide:
                                BorderSide(color: borderColor!, width: 1.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(borderRadiusTLBR),
                                topRight: Radius.circular(borderRadiusTRBL),
                                bottomLeft: Radius.circular(borderRadiusTRBL),
                                bottomRight: Radius.circular(borderRadiusTLBR)),
                            borderSide:
                                BorderSide(color: borderColor!, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(borderRadiusTLBR),
                                topRight: Radius.circular(borderRadiusTRBL),
                                bottomLeft: Radius.circular(borderRadiusTRBL),
                                bottomRight: Radius.circular(borderRadiusTLBR)),
                            borderSide:
                                BorderSide(color: borderColor!, width: 1.0)),
                        filled: true,
                        // hintStyle: TextStyle(color: Colors.grey[800]),
                        labelText: "To Sku Name",
                        labelStyle: TextStyle(
                            color: labelTxtCol, fontSize: labelTxtSize),
                        fillColor: fillColor),
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    // style: const TextStyle(fontWeight: FontWeight.normal),
                  );
                },
                displayStringForOption: _displaytoSkuStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<ToSKUItem>.empty();
                  }
                  return toSkuItemList.where((ToSKUItem option) {
                    return option.skuName
                        .toString()
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (ToSKUItem selection) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    selectedToMaterialQtyCase = "";
                    selectedUpdatedToSkuItem = selection;
                    final double fromCase = pack.originalMT ?? 0;
                    final double? caseToMT = selection.caseToMetricTonValue;

                    double remainingMt = fromCase;
                    if (pack.skus!.isNotEmpty) {
                      final double totalToSkuMt = pack.skus!
                          .fold(0, (sum, item) => sum + item.saudaQuantity!);
                      remainingMt = fromCase - totalToSkuMt;
                    }

                    if (remainingMt > 0 && caseToMT! > 0) {
                      selectedToMaterialQtyCase =
                          (remainingMt / caseToMT).toInt().toString();
                    } else {
                      selectedToMaterialQtyCase = "0";
                    }

                    toSkuCaseController.text =
                        selectedToMaterialQtyCase.toString();
                    toSkuMTController.text =
                        (double.parse(selectedToMaterialQtyCase) * caseToMT!)
                            .toStringAsFixed(3);
                  });
                },
              )),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CommonTextFormField(
                      labeltxt: "To SKU Cases",
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
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onTapCallBack: () {},
                      enabled: true,
                      dropdownIcon: false,
                      onChanged: (String val) {
                        if (val.isEmpty) {
                          toSkuMTController.text = "0";
                          return;
                        }
                        if (double.parse(val) >
                            double.parse(selectedToMaterialQtyCase)) {
                          _showAlertDialog(
                              context, "Enter valid case quantity");
                          toSkuCaseController.text = selectedToMaterialQtyCase;
                        }
                        setState(() {
                          toSkuMTController.text =
                              (double.parse(toSkuCaseController.text) *
                                      selectedUpdatedToSkuItem
                                          .caseToMetricTonValue!)
                                  .toStringAsFixed(3);
                        });
                      },
                      controllerTxt: toSkuCaseController,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CommonTextFormField(
                      labeltxt: "To SKU in MT",
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
                      dropdownIcon: false,
                      onChanged: (String val) {},
                      controllerTxt: toSkuMTController,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                toSkuMTController.text = "";
                toSkuCaseController.text = "";
                toSkuNameController.text = "";
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (toSkuCaseController.text.isEmpty ||
                      toSkuMTController.text.isEmpty) {
                    _showAlertDialog(
                        context, "Please fill the mandatory fields");
                    return;
                  }
                  Sku newSkuItem = Sku();
                  newSkuItem.skuName = selectedUpdatedToSkuItem.skuName;
                  newSkuItem.skuId = selectedUpdatedToSkuItem.skuId;
                  newSkuItem.caseToMetricTonValue =
                      selectedUpdatedToSkuItem.caseToMetricTonValue;
                  newSkuItem.pendingQuantityInCase =
                      double.parse(toSkuCaseController.text);
                  newSkuItem.saudaQuantity =
                      double.parse(toSkuCaseController.text) *
                          selectedUpdatedToSkuItem.caseToMetricTonValue!;
                  newSkuItem.pendingQuantityInCaseCopy =
                      pack.skus![0].pendingQuantityInCaseCopy;
                  newSkuItem.isDelete = true;
                  newSkuItem.basicRate = 0;
                  newSkuItem.skuCode = "";
                  newSkuItem.price = selectedUpdatedToSkuItem.price ?? 0;
                  newSkuItem.employeeSkuDiscount =
                      selectedUpdatedToSkuItem.employeeSkuDiscount ?? 0;
                  pack.skus!.add(newSkuItem);

                  double difference = pack.originalMT! -
                      pack.skus!
                          .fold(0, (sum, item) => sum + item.saudaQuantity!);

                  pack.differenceMT =
                      double.parse(difference.toStringAsFixed(3));

                  toSkuMTController.text = "";
                  toSkuCaseController.text = "";
                  toSkuNameController.text = "";
                  selectedToMaterialQtyCase = "";
                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  _editAvailableSku(BuildContext context, Sku skuItem, PackType pack) {
    TextEditingController availSkuNameController =
        TextEditingController(text: "");
    TextEditingController availtoSkuCaseController =
        TextEditingController(text: "");
    TextEditingController availtoSkuMTController =
        TextEditingController(text: "");
    String selectedQtyConversion = skuItem.caseToMetricTonValue!.toString();
    double actualCase = skuItem.pendingQuantityInCaseCopy!;
    availSkuNameController.text = skuItem.skuName ?? "";
    availtoSkuCaseController.text =
        skuItem.pendingQuantityInCase!.toInt().toString();
    if (skuItem.saudaQuantity != null) {
      availtoSkuMTController.text = skuItem.saudaQuantity!.toStringAsFixed(3);
    }
    double remainingCaseToAdded = 0.0;
    double availCase = pack.skus!
        .fold(0, (sum, item) => sum + item.pendingQuantityInCase!);
    double totalCase = pack.skus!.fold(0,
      (sum, item) =>
          sum +
          ((item.isDelete == false) ? (item.pendingQuantityInCaseCopy ?? 0) : 0),
    );
    remainingCaseToAdded = (totalCase - availCase) + skuItem.pendingQuantityInCase!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "To SKU's",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AUTOCOMPLETE FIELD
              CommonTextFormField(
                labeltxt: "SKU Name",
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
                dropdownIcon: false,
                onChanged: (String val) {},
                controllerTxt: availSkuNameController,
              ),
              const SizedBox(height: 15),

              // CASES AND MT ROW
              Row(
                children: [
                  Expanded(
                    child: CommonTextFormField(
                      labeltxt: "SKU Cases",
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
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onTapCallBack: () {},
                      enabled: true,
                      dropdownIcon: false,
                      onChanged: (String val) {
                        if (val.isEmpty) {
                          availtoSkuMTController.text = "0";
                          return;
                        }
                        if (double.parse(val) >
                            double.parse(remainingCaseToAdded.toStringAsFixed(3))) {
                          _showAlertDialog(
                              context, "Enter valid case quantity");
                          availtoSkuCaseController.text =
                              skuItem.pendingQuantityInCase!.toInt().toString();
                        }
                        setState(() {
                          availtoSkuMTController.text =
                              (double.parse(availtoSkuCaseController.text) *
                                      double.parse(selectedQtyConversion))
                                  .toStringAsFixed(3);
                        });
                      },
                      controllerTxt: availtoSkuCaseController,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CommonTextFormField(
                      labeltxt: "SKU in MT",
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
                      dropdownIcon: false,
                      onChanged: (String val) {},
                      controllerTxt: availtoSkuMTController,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                availtoSkuMTController.text = "";
                availtoSkuCaseController.text = "";
                availSkuNameController.text = "";
                selectedQtyConversion = "";
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  skuItem.skuName = availSkuNameController.text.toString();
                  skuItem.pendingQuantityInCase =
                      double.parse(availtoSkuCaseController.text.toString());
                  skuItem.saudaQuantity =
                      double.parse(availtoSkuMTController.text.toString());
                  if (skuItem.isDelete!) {
                    skuItem.isDelete = true;
                  } else {
                    skuItem.isDelete = false;
                  }
                  skuItem.price = skuItem.basicRate;
                });

                setState(() {
                  double difference = pack.originalMT! -
                      pack.skus!
                          .fold(0, (sum, item) => sum + item.saudaQuantity!);
                  pack.differenceMT =
                      double.parse(difference.toStringAsFixed(3));
                  availtoSkuMTController.text = "";
                  availtoSkuCaseController.text = "";
                  availSkuNameController.text = "";
                  selectedQtyConversion = "";
                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  _showRequiredSkuAlert(BuildContext context, int index) {
    isEditSkuArrayItems = index;
    if (index != -1) {
      final item = toSkuArrayItems[index];
      if (toSkuItems.isNotEmpty) {
        selectedToSkuItem = toSkuItems
            .firstWhere((element) => element.skuName == item.toSkuName);
      }
      selectedToMaterialQtyCase = item.toSkuCase.toString();
      _toMaterialController.text = item.toSkuName;
      _toSkuCaseController.text = item.toSkuCase.toString();
      _toSkuinMTController.text = item.toSkuMt.toString();
    } else {
      _toMaterialController.clear();
      _toSkuCaseController.clear();
      _toSkuinMTController.clear();
      selectedToSkuItem = ToSkuItemResp();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "To SKU's",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // AUTOCOMPLETE FIELD
                CustomAutocomplete<ToSkuItemResp>(
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    // _toMaterialController = fieldTextEditingController;
                    fieldTextEditingController.text =
                        _toMaterialController.text;
                    fieldTextEditingController.addListener(() {
                      _toMaterialController.text =
                          fieldTextEditingController.text;
                      _toMaterialController.selection =
                          fieldTextEditingController.selection;
                    });
                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: const InputDecoration(
                        labelText: "To SKU Name",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    );
                  },
                  displayStringForOption: (ToSkuItemResp option) =>
                      option.skuName ?? "",
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<ToSkuItemResp>.empty();
                    }
                    return toSkuItems.where((ToSkuItemResp option) => option
                        .skuName!
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (ToSkuItemResp selection) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      selectedToSkuItem = selection;

                      final double fromCase =
                          double.tryParse(_fromSkuinMTController.text.trim()) ??
                              0;
                      final double? caseToMT = selection.caseToMetricTonValue;

                      double remainingMt = fromCase;
                      if (toSkuArrayItems.isNotEmpty) {
                        final double totalToSkuMt = toSkuArrayItems.fold(
                            0, (sum, item) => sum + item.toSkuMt);
                        remainingMt = fromCase - totalToSkuMt;
                      }

                      if (remainingMt > 0 && caseToMT! > 0) {
                        selectedToMaterialQtyCase =
                            (remainingMt / caseToMT).toStringAsFixed(3);
                      } else {
                        selectedToMaterialQtyCase = "0.000";
                      }

                      _toSkuCaseController.text =
                          int.parse(selectedToMaterialQtyCase).toString();
                      _toSkuinMTController.text =
                          (double.parse(selectedToMaterialQtyCase) * caseToMT!)
                              .toString();
                    });
                  },
                ),
                const SizedBox(height: 15),

                // CASES AND MT ROW
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFormField(
                        labeltxt: "To SKU Cases",
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
                        enabled: true,
                        dropdownIcon: false,
                        onChanged: (String val) {
                          if (val.isEmpty) {
                            _toSkuinMTController.text = "0";
                            return;
                          }
                          if (double.parse(val) >
                              double.parse(selectedToMaterialQtyCase)) {
                            _showAlertDialog(
                                context, "Enter valid case quantity");
                            _toSkuCaseController.text =
                                selectedToMaterialQtyCase;
                          }
                          setState(() {
                            _toSkuinMTController.text =
                                (double.parse(_toSkuCaseController.text) *
                                        selectedToSkuItem.caseToMetricTonValue!)
                                    .toStringAsFixed(3);
                          });
                        },
                        controllerTxt: _toSkuCaseController,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CommonTextFormField(
                        labeltxt: "To SKU in MT",
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
                        enabled: true,
                        dropdownIcon: false,
                        onChanged: (String val) {},
                        controllerTxt: _toSkuinMTController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _toSkuCaseController.text = "";
                _toSkuinMTController.text = "";
                _toMaterialController.text = "";
                selectedToSkuItem = ToSkuItemResp();
                selectedToMaterialQtyCase = "";
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final double caseVal =
                      double.tryParse(_toSkuCaseController.text) ?? 0;
                  final double mtVal =
                      double.tryParse(_toSkuinMTController.text) ?? 0;

                  final newItem = ToSkuArrayItem(
                    toSkuCase: caseVal,
                    toSkuMt: mtVal,
                    toSkuName: selectedToSkuItem.skuName!,
                    toSkuId: selectedToSkuItem.skuId!.toString(),
                    toCasetoMTValue: selectedToSkuItem.caseToMetricTonValue!,
                  );

                  if (isEditSkuArrayItems == -1) {
                    toSkuArrayItems.add(newItem);
                  } else {
                    toSkuArrayItems[isEditSkuArrayItems] = newItem;
                  }

                  _toSkuCaseController.text = "";
                  _toSkuinMTController.text = "";
                  _toMaterialController.text = "";
                  isEditSkuArrayItems = -1;
                  selectedToSkuItem = ToSkuItemResp();
                  selectedToMaterialQtyCase = "";

                  _mtDifferenceController.text =
                      (double.parse(_fromSkuinMTController.text) -
                              toSkuArrayItems.fold(
                                  0, (sum, item) => sum + item.toSkuMt))
                          .toStringAsFixed(3);

                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  bool _validationSuccess() {
    bool isValid = true;
    if (selectedDistItem.id == null || selectedDistItem.id == 0) {
      _showAlertDialog(context, "Please select Distributor");
      isValid = false;
      return isValid;
    }
    if (selectedContractItem.id == null || selectedContractItem.id == 0) {
      _showAlertDialog(context, "Please select Contract");
      isValid = false;
      return isValid;
    }
    if (selectedOilItem.oilTypeId == null || selectedOilItem.oilTypeId == 0) {
      _showAlertDialog(context, "Please select Oil Type");
      isValid = false;
      return isValid;
    }
    if (selectedMaterialItem.id == null || selectedMaterialItem.id == 0) {
      _showAlertDialog(context, "Please select From SKU Material");
      isValid = false;
      return isValid;
    }
    if (_fromSkuCaseController.text.isEmpty ||
        double.parse(_fromSkuCaseController.text) == 0) {
      _showAlertDialog(context, "From SKU in MT cannot be empty or zero");
      isValid = false;
      return isValid;
    }
    if (toSkuArrayItems.isEmpty) {
      _showAlertDialog(context, "Please add at least one To SKU item");
      isValid = false;
    }
    /*if(double.parse(_mtDifferenceController.text)>0) {
      _showAlertDialog(context, "Please add at least one To SKU item");
      isValid = false;
    }*/
    return isValid;
  }

  double pendingQtyCase = 0.0;

  Widget _loadOilNumberList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: oilNoList.length,
      itemBuilder: (context, index) {
        final oil = oilNoList[index];

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: ExpansionTile(
                title: Row(
                  children: [
                    Text(
                      oil.oilTypeName ?? "",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                children: [
                  const Divider(thickness: 1),
                  // Show PackTypes + SKUs
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: oil.packTypes?.length ?? 0,
                    itemBuilder: (context, pIndex) {
                      final pack = oil.packTypes![pIndex];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            child: Row(children: [
                              Text(
                                "Pack Type: ${pack.packTypeName}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Text(
                                "Total MT: ${pack.originalMT}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  if (pack.differenceMT! <= 0) {
                                    _showAlertDialog(
                                        context, "Cases are already filled");
                                  } else {
                                    BlocProvider.of<SaudaModAddScreenBloc>(
                                            context)
                                        .add(GetToSkuList(
                                            oil.oilTypeId!,
                                            pack.packTypeId!,
                                            int.parse(selectedContractItem
                                                .saudaNumber!
                                                .split("-")[0]),
                                            selectedDistItem.id!));

                                    Future.delayed(
                                        const Duration(milliseconds: 1000), () {
                                      _addToSku(context, pack, oil);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    // Button background
                                    shape: BoxShape.circle, // Circle shape
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              )
                            ]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                            child: Text(
                              "Difference In MT : ${pack.differenceMT}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // SKUs
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pack.skus?.length ?? 0,
                            itemBuilder: (context, sIndex) {
                              final sku = pack.skus![sIndex];
                              pendingQtyCase =
                                  pendingQtyCase + sku.pendingQuantityInCase!;
                              if (pack.skus!.isNotEmpty &&
                                  pack.skus?.length == sIndex + 1) {
                                pendingQtyCase = 0.0;
                              }
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                    bottom: 10, left: 5, right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sku.skuName ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "(${sku.saudaQuantity?.toStringAsFixed(3)} MT)",
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.red),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 0),
                                                  // space between text and underline
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    sku.pendingQuantityInCase!
                                                        .toStringAsFixed(3),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.orange),
                                                  ),
                                                ),
                                              ),
                                              const TextSpan(
                                                text: "  Case",
                                                // word part
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors
                                                      .black, // underline only "Case"
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            _editAvailableSku(
                                                context, sku, pack);
                                          },
                                          child: const Icon(Icons.edit,
                                              color: Colors.orange),
                                        ),
                                        const SizedBox(width: 10),
                                        Visibility(
                                          visible: sku.isDelete!,
                                          child: InkWell(
                                            onTap: () {
                                              pack.skus!.remove(sku);
                                              double difference = pack
                                                      .originalMT! -
                                                  pack.skus!.fold(
                                                      0,
                                                      (sum, item) =>
                                                          sum +
                                                          item.saudaQuantity!);
                                              pack.differenceMT = double.parse(
                                                  difference
                                                      .toStringAsFixed(3));
                                              setState(() {});
                                            },
                                            child: const Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      visible: sku.isDelete!,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Base Rate (per qty)",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Spacer(),
                                          Text(
                                            "Rs.${sku.price ?? 0.toString()}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                        visible: sku.isDelete!,
                                        child: SizedBox(
                                          height: 10,
                                        )),
                                    Visibility(
                                      visible: sku.isDelete!,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Discount (per qty)",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Spacer(),
                                          Text(
                                            "Rs.${sku.employeeSkuDiscount ?? 0.toString()}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
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
              Navigator.of(context).pop();
              // TODO: Add functionality for the "OK" button
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showSuccessDlg(BuildContext context, messageValue, title,
    {bool? hideCancelBtn = false,
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
    title: const SizedBox.shrink(),
    content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Table(children: [
          TableRow(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: title == "Error"
                      ? const Icon(Icons.error_outlined,
                          size: 70, color: Colors.red)
                      : const Icon(Icons.check_circle_sharp,
                          size: 70, color: Colors.green),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(title!,
                      style: TextStyle(
                          fontSize: Constant.fontSize20,
                          fontWeight: Constant.fontWeight600)),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: Text(messageValue!,
                      style: TextStyle(
                        fontSize: Constant.fontSize14,
                      )),
                ),
                const SizedBox(height: 20),
                const BorderBottom(bordeSize: 1)
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
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
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
