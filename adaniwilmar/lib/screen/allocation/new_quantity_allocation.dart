import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_request.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/screen/allocation/allocation.dart';
import 'package:adaniwilmar/screen/sauda/sauda_screen.dart';
import 'package:adaniwilmar/screen/allocation/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class NewQuantityAllocationScreen extends StatelessWidget {
  const NewQuantityAllocationScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const NewQuantityAllocationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllocationBloc()
        // ..add(LoadNewQuantityAllocationScreen(userId: Constants.AUTH_USERID))
        ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0))
        ..add(LoadZonalHead(userId: Constants.AUTH_USERID)),
      child: const NewQuantityAllocationForm(),
    );
  }
}

class NewQuantityAllocationForm extends StatefulWidget {
  const NewQuantityAllocationForm({Key? key}) : super(key: key);

  @override
  State<NewQuantityAllocationForm> createState() =>
      _NewQuantityAllocationFormState();
}

class _NewQuantityAllocationFormState extends State<NewQuantityAllocationForm> {
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<OilType> oilTypes = [];
  List<BdoList> skuList = [];
  List<BdoList> zhList = [];
  DealerSaudaDetail saudaDetail = DealerSaudaDetail();
  final TextEditingController _limitcontroller = TextEditingController();
  final TextEditingController _remarkscontroller = TextEditingController();
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  TextEditingController? _oiltypecontroller;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  OilType? selectedOilType;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor Name";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  double screenWidth = 0;
  double screenHeight = 0;
  ProgressBarHandler? _handler;
  bool isChecked = false;
  bool isZhChecked = false;

  static String _displayStringForOilTypeOption(OilType option) => option.name!;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    Widget listOfForm = Column(
      children: [
        CommonTextFormField(
          labeltxt: Constant.saudaLETxt1,
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
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CurveBox(
                boxSize: 2,
                miniusValue: 29,
                boxHeight: 76,
                boxColor: Constant.saudaLETBoxColor1,
                headingTxt: Constant.saudaLETBox1Txt1,
                subHeading: Constant.saudaLETBox1SubTxt1,
                headingFontSize: Constant.fontSize13,
                subHeadingFontSize: Constant.fontSize16,
                subhHadingFontWeight: FontWeight.w600),
            const SizedBox(width: 13),
            CurveBox(
                boxSize: 2,
                miniusValue: 29,
                boxHeight: 76,
                boxColor: Constant.saudaLETBoxColor2,
                headingTxt: Constant.saudaLETBox2Txt2,
                subHeading: Constant.saudaLETBox2SubTxt2,
                headingFontSize: Constant.fontSize13,
                subHeadingFontSize: Constant.fontSize16,
                subhHadingFontWeight: FontWeight.w600)
          ],
        ),
        const SizedBox(height: 16.0),
        CommonTextFormField(
          labeltxt: Constant.saudaLETxt2,
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
        ),
        const SizedBox(height: 16.0),
        CommonTextFormField(
          labeltxt: Constant.saudaLETxt3,
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
          maxLine: Constant.saudaLETxt3MaxLine,
        ),
      ],
    );
    return BlocListener<AllocationBloc, AllocationState>(
        listener: (context, state) {
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            setState(() {});
          }
          if (state is OnLoadZhList) {
            zhList = state.zhList;
            setState(() {});
          }
          if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            selectedVertical = null;
            verticals = state.verticalList;
            setState(() {});
          }
          if (state is OnLoadOilType) {
            selectedOilType = null;
            if (_oiltypecontroller != null) {
              _oiltypecontroller!.text = "";
            }
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnLoadSKUDetails) {
            skuList = state.skuList;
            setState(() {});
          }
          if (state is OnSaveQuantityLimit) {
            showSuccessDlg(context, "Request Confirmed", "Success",
                successText:
                    "Your quantity limit request has been raised successfully");
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
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
            title: "Create Quantity Limit",
            backArrow: true,
            listOfActions: Row(
              children: [],
            ),
          ),
          body: Stack(
            clipBehavior: Clip.none,
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
                                  visible:
                                      Constants.AUTH_ROLEID != Constants.DEALER,
                                  child: Column(children: [
                                    const SizedBox(height: 16),
                                    CommonDropdownButtonFormField<SalesOrganization>(
                                      value: salesOrgList
                                              .contains(selectedSalesOrg)
                                          ? selectedSalesOrg
                                          : null,
                                      label: "Sales Organization",
                                      onChanged: (SalesOrganization? newValue) {
                                        if (newValue == null) return;
                                        setState(() {
                                          selectedSalesOrg = newValue;
                                        });
                                        BlocProvider.of<AllocationBloc>(context)
                                            .add(LoadDistributionChannel(
                                                id: newValue.id!));
                                      },
                                      items: salesOrgList.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                              value.salesOrganizationName!),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 16),
                                    CommonDropdownButtonFormField<
                                        DistributionChannel>(
                                      value: distrChannels
                                              .contains(selectedDistrChannel)
                                          ? selectedDistrChannel
                                          : null,
                                      label: "Distribution Channel",
                                      onChanged: (DistributionChannel? newValue) {
                                        if (newValue == null) return;
                                        setState(() {
                                          selectedDistrChannel = newValue;
                                        });
                                        BlocProvider.of<AllocationBloc>(context)
                                            .add(LoadVerticalList(
                                                distributionId: newValue.id!));
                                      },
                                      items: distrChannels.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                              value.distributionChannelName!),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 16.0),
                                    CommonDropdownButtonFormField<Vertical>(
                                      value: verticals
                                              .contains(selectedVertical)
                                          ? selectedVertical
                                          : null,
                                      label: "Division",
                                      onChanged: (Vertical? newValue) {
                                        if (newValue == null) return;
                                        setState(() {
                                          selectedVertical = newValue;
                                        });
                                        BlocProvider.of<AllocationBloc>(context)
                                            .add(LoadOilType(
                                                userId: Constants.AUTH_USERID,
                                                salesOrganizationId:
                                                    selectedSalesOrg!.id!,
                                                distributionChannelId:
                                                    selectedDistrChannel!.id!,
                                                divisonId: newValue.id!));
                                      },
                                      items: verticals.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 16),
                                    CustomAutocomplete<OilType>(
                                      fieldViewBuilder: (BuildContext context,
                                          TextEditingController
                                              fieldTextEditingController,
                                          FocusNode fieldFocusNode,
                                          VoidCallback onFieldSubmitted) {
                                        _oiltypecontroller =
                                            fieldTextEditingController;
                                        return TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 0.0),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          borderRadiusTLBR),
                                                      topRight: Radius.circular(
                                                          borderRadiusTRBL),
                                                      bottomLeft: Radius.circular(
                                                          borderRadiusTRBL),
                                                      bottomRight: Radius.circular(
                                                          borderRadiusTLBR)),
                                                  borderSide: BorderSide(
                                                      color: borderColor!,
                                                      width: 1.0)),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(borderRadiusTLBR),
                                                      topRight: Radius.circular(borderRadiusTRBL),
                                                      bottomLeft: Radius.circular(borderRadiusTRBL),
                                                      bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              filled: true,
                                              // hintStyle: TextStyle(color: Colors.grey[800]),
                                              labelText: "Oil Type",
                                              labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                              fillColor: fillColor),
                                          controller:
                                              fieldTextEditingController,
                                          focusNode: fieldFocusNode,
                                          // style: const TextStyle(fontWeight: FontWeight.normal),
                                        );
                                      },
                                      displayStringForOption:
                                          _displayStringForOilTypeOption,
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<
                                              OilType>.empty();
                                        }
                                        return oilTypes.where((OilType option) {
                                          return option.name
                                              .toString()
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (OilType selection) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        setState(() {
                                          selectedOilType = selection;
                                        });
                                        BlocProvider.of<AllocationBloc>(context)
                                            .add(LoadSKUDetails(
                                                userId: Constants.AUTH_USERID,
                                                oilTypeId:
                                                    selectedOilType!.id!));
                                      },
                                    )
                                    // StatefulBuilder(builder:
                                    //     (BuildContext context, StateSetter setState) {
                                    //   return SizedBox(
                                    //       width: double.infinity,
                                    //       //height: 70,
                                    //       child: CommonDropdownButtonFormField<OilType>(
                                    //         isExpanded: true,
                                    //         value: selectedOilType,
                                    //         icon: const Align(
                                    //             alignment: Alignment.topRight,
                                    //             child: Icon(
                                    //               Icons.arrow_drop_down_sharp,
                                    //               size: 24,
                                    //             )),
                                    //         elevation: 16,
                                    //         style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: Constant.fontSize15),
                                    //         decoration: InputDecoration(
                                    //             contentPadding: const EdgeInsets.symmetric(
                                    //                 horizontal: 10.0, vertical: 0.0),
                                    //             focusedBorder: OutlineInputBorder(
                                    //                 borderRadius: BorderRadius.only(
                                    //                     topLeft: Radius.circular(
                                    //                         borderRadiusTLBR),
                                    //                     topRight: Radius.circular(
                                    //                         borderRadiusTRBL),
                                    //                     bottomLeft: Radius.circular(
                                    //                         borderRadiusTRBL),
                                    //                     bottomRight: Radius.circular(
                                    //                         borderRadiusTLBR)),
                                    //                 borderSide: BorderSide(
                                    //                     color: borderColor!,
                                    //                     width: 1.0)),
                                    //             border: OutlineInputBorder(
                                    //                 borderRadius: BorderRadius.only(
                                    //                     topLeft: Radius.circular(
                                    //                         borderRadiusTLBR),
                                    //                     topRight:
                                    //                     Radius.circular(borderRadiusTRBL),
                                    //                     bottomLeft: Radius.circular(borderRadiusTRBL),
                                    //                     bottomRight: Radius.circular(borderRadiusTLBR)),
                                    //                 borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                    //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                    //             filled: true,
                                    //             // hintStyle: TextStyle(color: Colors.grey[800]),
                                    //             labelText: "Oil Type",
                                    //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                    //             fillColor: fillColor),
                                    //         onChanged: (OilType? newValue) {
                                    //           setState(() {
                                    //             selectedOilType = newValue!;
                                    //           });
                                    //           BlocProvider.of<AllocationBloc>(context)
                                    //               .add(LoadSKUDetails(
                                    //               userId: Constants.AUTH_USERID,
                                    //               oilTypeId: selectedOilType!.id!));
                                    //         },
                                    //         items: oilTypes
                                    //             .map<DropdownMenuItem<OilType>>(
                                    //                 (value) {
                                    //               return DropdownMenuItem<OilType>(
                                    //                 value: value,
                                    //                 child: Text(value.name!),
                                    //               );
                                    //             }).toList(),
                                    //       ));
                                    // })
                                  ])),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text("Select All"),
                                  Checkbox(
                                    onChanged: (bool? value) {
                                      isChecked = value!;
                                      if (value) {
                                        selectAllSkus();
                                      } else {
                                        unselectAllSkus();
                                      }
                                      setState(() {});
                                    },
                                    value: isChecked,
                                    activeColor: Colors.green[600],
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: skuList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Checkbox(
                                              onChanged: (bool? value) {
                                                skuList[index].selected = value;
                                                setState(() {});
                                              },
                                              value: skuList[index].selected!,
                                              activeColor: Colors.green,
                                            )),
                                        Expanded(
                                            child: Text(
                                          skuList[index].name!,
                                          style: TextStyle(
                                            fontSize: Constant.fontSize14,
                                            color: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                        )),
                                      ]),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              CommonTextFormField(
                                  labeltxt: "Quantity (MT)",
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
                                  controllerTxt: _limitcontroller,
                                  keyborType: TextInputType.number,
                                  onChanged: (String? value) {
                                    setState(() {});
                                  }),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          _selectFromDate(context, false);
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
                                          _selectToDate(context, false);
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
                              Row(
                                children: [
                                  const Text("Select All"),
                                  Checkbox(
                                    onChanged: (bool? value) {
                                      isZhChecked = value!;
                                      if (value) {
                                        selectAllZh();
                                      } else {
                                        unselectAllZh();
                                      }
                                      setState(() {});
                                    },
                                    value: isZhChecked,
                                    activeColor: Colors.green[600],
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: zhList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Checkbox(
                                              onChanged: (bool? value) {
                                                zhList[index].selected = value;
                                                setState(() {});
                                              },
                                              value: zhList[index].selected!,
                                              activeColor: Colors.green,
                                            )),
                                        Expanded(
                                            child: Text(
                                          zhList[index].name!,
                                          style: TextStyle(
                                            fontSize: Constant.fontSize14,
                                            color: Constant.colorBlack,
                                            fontWeight: Constant.fontWeight500,
                                          ),
                                        )),
                                      ]),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )),
                        ],
                      ))),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }),
              progressBar
            ],
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 16, bottom: 16),
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
                          _limitcontroller.text = "";
                          _remarkscontroller.text = "";
                          saudaDetail = DealerSaudaDetail();
                        }),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: screenWidth / 2 - 40,
                    child: CommonButton(
                        buttonName: Constant.saudaLEButtonTxt2,
                        buttonNameSize: Constant.pricbuttonNameSize,
                        buttonNameColor: Constant.pricbuttonTxtColor,
                        buttonColor: Constant.pricbuttonColor,
                        buttonHeight: Constant.pricbuttonHeight,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Colors.transparent,
                        buttonFunction: () {
                          if (selectedSalesOrg == null) {
                            showSuccessDlg(context, "Error", "Error",
                                successText:
                                    "Select Sales Organization from the list",
                                closeScreen: false);
                            return;
                          }
                          if (selectedDistrChannel == null) {
                            showSuccessDlg(context, "Error", "Error",
                                successText:
                                    "Select Distribution Channel from the list",
                                closeScreen: false);
                            return;
                          }
                          if (selectedVertical == null) {
                            showSuccessDlg(context, "Error", "Error",
                                successText: "Select Division from the list",
                                closeScreen: false);
                            return;
                          }
                          if (_limitcontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error",
                                successText: "Enter Quantity",
                                closeScreen: false);
                            return;
                          }
                          if (_fromdatecontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error",
                                successText: "Enter Valid From",
                                closeScreen: false);
                            return;
                          }
                          if (_todatecontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error",
                                successText: "Enter Valid To",
                                closeScreen: false);
                            return;
                          }
                          CreateQuantityLimitRequest request =
                              CreateQuantityLimitRequest();
                          request.oilTypeId = selectedOilType!.id!;
                          request.loginUserId = Constants.AUTH_USERID;
                          request.quantityLimit =
                              double.parse(_limitcontroller.text.toString());
                          if (_fromdatecontroller.text.toString() != "") {
                            request.validFrom = DateTimeUtils()
                                .dateToServerToDateFormat(
                                    _fromdatecontroller.text.toString(),
                                    DateTimeUtils.DD_MM_YYYY_Format,
                                    DateTimeUtils.YYYY_MM_DD_Format);
                          } else {
                            request.validFrom = "";
                          }
                          if (_todatecontroller.text.toString() != "") {
                            request.validTo = DateTimeUtils()
                                .dateToServerToDateFormat(
                                    _todatecontroller.text.toString(),
                                    DateTimeUtils.DD_MM_YYYY_Format,
                                    DateTimeUtils.YYYY_MM_DD_Format);
                          } else {
                            request.validTo = "";
                          }
                          request.skuIds = [];
                          for (BdoList s in skuList) {
                            if (s.selected!) {
                              request.skuIds!.add(s.id!);
                            }
                          }
                          if (request.skuIds!.length == 0) {
                            showSuccessDlg(context, "Error", "Error",
                                successText: "Select Sku from the list",
                                closeScreen: false);
                            return;
                          }
                          request.customerId = [];
                          for (BdoList s in zhList) {
                            if (s.selected!) {
                              request.customerId!.add(s.id!);
                            }
                          }
                          if (request.customerId!.length == 0) {
                            showSuccessDlg(context, "Error", "Error",
                                successText:
                                    "Select Zonal Trader from the list",
                                closeScreen: false);
                            return;
                          }
                          BlocProvider.of<AllocationBloc>(context)
                              .add(SaveQuantityLimit(request: request));
                        }),
                  ),
                ],
              )),
        )));
  }

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
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
                buttonName: "Cancel",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllocationScreen()),
                  );
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

  _selectFromDate(BuildContext context, bool popup) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -365)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
      if (saudaDetail != null && saudaDetail.saudaValidityPeriod != null) {
        _todatecontroller.text = DateTimeUtils().dateToStringFormat(
            selected.add(Duration(days: saudaDetail.saudaValidityPeriod!)),
            DateTimeUtils.DD_MM_YYYY_Format);
      }
    }
  }

  _selectToDate(BuildContext context, bool popup) async {
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
        lastDate: DateTime.now().add(Duration(days: 2000)));
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  selectAllSkus() {
    for (BdoList sku in skuList) {
      sku.selected = true;
    }
  }

  unselectAllSkus() {
    for (BdoList sku in skuList) {
      sku.selected = false;
    }
  }

  selectAllZh() {
    for (BdoList z in zhList) {
      z.selected = true;
    }
  }

  unselectAllZh() {
    for (BdoList z in zhList) {
      z.selected = false;
    }
  }
}
