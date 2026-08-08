import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/screen/new_sauda/new_saudu.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';

import '../../config/constant.dart';
import '../../utils/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';
import 'bloc/todayrate_bloc.dart';
import 'bloc/todayrate_event.dart';
import 'bloc/todayrate_state.dart';

class TodayRateScreen extends StatelessWidget {
  const TodayRateScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const TodayRateScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child: const TodayRate(),
    );
  }

  TodayRateBloc _getInitialLoadData() {
    TodayRateBloc todayRateBloc = TodayRateBloc();
    if (!((Constants.AUTH_ROLEID == Constants.SALE) ||
        (Constants.AUTH_ROLEID == Constants.ZHMANAGER))) {
      todayRateBloc.add(LoadStates(id: 0));
    } else {
      todayRateBloc.add(LoadPlant(stateId: 0));
    }
    todayRateBloc.add(LoadIncoTerms());
    if (Constants.AUTH_ROLEID == Constants.SALE ||
        (Constants.AUTH_ROLEID == Constants.ZHMANAGER)) {
      todayRateBloc.add(LoadSalesOrganization(id: 0));
    }
    return todayRateBloc;
  }

}

class TodayRate extends StatefulWidget {
  const TodayRate({Key? key}) : super(key: key);

  @override
  State<TodayRate> createState() => _TodayRateState();
}

class _TodayRateState extends State<TodayRate> {
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<IncoTerms> incoTerms = [];
  List<PlanDepotList> plants = [];
  List<DailyRate> dailyRates = [];
  List<OilType> oilTypes = [];
  List<ActiveState> stateList = [];
  TextEditingController? _plantcontroller;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  IncoTerms? selectedIncoTerms;
  PlanDepotList? selectedPlant;
  OilType? selectedOilType;
  ActiveState? selectedState;
  static String _displayPlantForOption(PlanDepotList option) =>
      option.name!;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "Distributor";
  String txtLabe = "Palm";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  ProgressBarHandler? _handler;
  bool isActive = false;

  double screenWidth = 0.0;
  double screenHeight = 0.0;
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
    return BlocListener<TodayRateBloc, TodayRateState>(
        listener: (context, state) {
          if (state is OnLoadStates) {
            stateList = state.states;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            selectedSalesOrg = null;
            salesOrgList = state.salesOrganization;
            setState(() {});
          }
          if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            setState(() {});
          }
          if (state is OnLoadIncoTerms) {
            incoTerms = state.incoTerms;
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            selectedVertical = null;
            verticals = state.verticalList;
            setState(() {});
          }
          if (state is OnLoadPlant) {
            selectedPlant = null;
            plants = state.plantList;
            if(Constants.AUTH_ROLEID==Constants.DEALER){
              BlocProvider.of<TodayRateBloc>(context).add(
                  LoadDealerDetail(
                      id: Constants.AUTH_USERID,
                      saudaBookingTypeId: 1,
                      salesOrganizationId: 0,
                      distributionChannelId: 0,
                      divisionId: 0));
            }
            setState(() {});
          }
          if (state is OnLoadOilType) {
            selectedOilType = null;
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnOverallSuccess) {
            dailyRates = state.response;
            setState(() {});
          }

          if (state is OnLoadDealerSaudaDetail) {
              selectedPlant = null;
              plants = state.dealerSaudaDetail.plantDepotListNew!;
              if(plants!=null && plants.length>0){
                if(state.dealerSaudaDetail.highestBookedPlantId!=null && state.dealerSaudaDetail.highestBookedPlantId!>0){
                  if(plants
                      .where((element) => element.id == state.dealerSaudaDetail.highestBookedPlantId!).isNotEmpty){
                    selectedPlant=plants
                        .where((element) => element.id == state.dealerSaudaDetail.highestBookedPlantId!).first;
                  }
                }else {
                  selectedPlant = plants[0];
                }
              }
            setState(() {});
          }
          if (state is GetTodayRateBooking) {
            isActive = state.todayRateBookingStatus.isActive!;
            setState(() {});
          }

          if (state is ShowProgressBar) {
            _handler!.show!();
          }
          if (state is HideProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: FocusDetector(
          onFocusGained: () {
            BlocProvider.of<TodayRateBloc>(context)
                .add(GetTodayCreationStatus(userId: Constants.AUTH_USERID));
          },
          child: SafeArea(
              child: Scaffold(
            primary: false,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: const CustomAppBar(title: "Today's Rate", backArrow: true),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      CurveOuterBox(
                          boxofWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(visible: (!((Constants.AUTH_ROLEID ==
                              Constants.SALE) ||
                              (Constants.AUTH_ROLEID == Constants.ZHMANAGER))),
                              child: Column(children: [
                            StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<ActiveState>(
                                  value: selectedState,
                                  label: "State",
                                  onChanged: (ActiveState? newValue) {
                                    setState(() {
                                      selectedState = newValue!;
                                    });
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadSalesOrganization(
                                            id: selectedState!.stateId!));
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadPlant(
                                            stateId: selectedState!.stateId!));
                                  },
                                  items: stateList
                                      .map<DropdownMenuItem<ActiveState>>(
                                          (value) {
                                    return DropdownMenuItem<ActiveState>(
                                      value: value,
                                      child: Text(value.stateName!),
                                    );
                                  }).toList(),
                                ));
                              })
                          ])
                          ),
                          const SizedBox(height: 16),
                          Visibility(visible:Constants.AUTH_ROLEID!=Constants.DEALER,child: Column(children:[
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<SalesOrganization>(
                                  value: selectedSalesOrg,
                                  label: "Sales Organization",
                                  onChanged: (SalesOrganization? newValue) {
                                    setState(() {
                                      selectedSalesOrg = newValue!;
                                    });
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadDistributionChannel(
                                            id: selectedSalesOrg!.id!));
                                  },
                                  items: salesOrgList
                                      .map<DropdownMenuItem<SalesOrganization>>(
                                          (value) {
                                    return DropdownMenuItem<SalesOrganization>(
                                      value: value,
                                      child: Text(value.salesOrganizationName!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          const SizedBox(height: 16),
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                // height: 70,
                                child:
                                    CommonDropdownButtonFormField<DistributionChannel>(
                                  value: selectedDistrChannel,
                                  label: "Distribution Channel",
                                  onChanged: (DistributionChannel? newValue) {
                                    setState(() {
                                      selectedDistrChannel = newValue!;
                                    });
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadVerticalList(
                                            distributionId:
                                                selectedDistrChannel!.id!));
                                  },
                                  items: distrChannels
                                      .map<DropdownMenuItem<DistributionChannel>>(
                                          (value) {
                                    return DropdownMenuItem<DistributionChannel>(
                                      value: value,
                                      child: Text(value.distributionChannelName!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          const SizedBox(height: 16.0),
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<Vertical>(
                                  value: selectedVertical,
                                  label: "Division",
                                  onChanged: (Vertical? newValue) {
                                    setState(() {
                                      selectedVertical = newValue!;
                                    });
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadOilType(
                                            userId: Constants.AUTH_USERID,
                                            salesOrganizationId:
                                                selectedSalesOrg!.id!,
                                            distributionChannelId:
                                                selectedDistrChannel!.id!,
                                            divisonId: selectedVertical!.id!));
                                  },
                                  items: verticals
                                      .map<DropdownMenuItem<Vertical>>((value) {
                                    return DropdownMenuItem<Vertical>(
                                      value: value,
                                      child: Text(value.name!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          const SizedBox(height: 16.0)])),
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<IncoTerms>(
                                  value: selectedIncoTerms,
                                  label: "Incoterm",
                                  onChanged: (IncoTerms? newValue) {
                                    setState(() {
                                      selectedIncoTerms = newValue!;
                                    });
                                    if(Constants.AUTH_ROLEID==Constants.DEALER) {
                                      BlocProvider.of<TodayRateBloc>(context).add(
                                          LoadOverallData(
                                              userId: Constants.AUTH_USERID,
                                              oilTypeId: 0,
                                              plantId: selectedPlant!.id!,
                                              incoTermId: newValue!.id!,
                                              verticalId: 0,
                                              salesOrgId: 0,
                                              distrChannelId: 0
                                          ));
                                    }
                                  },
                                  items: incoTerms
                                      .map<DropdownMenuItem<IncoTerms>>((value) {
                                    return DropdownMenuItem<IncoTerms>(
                                      value: value,
                                      child: Text(value.name!),
                                    );
                                  }).toList(),
                                ));
                          }),
                          const SizedBox(height: 16.0),
                          Column(children: [
                            CustomAutocomplete<
                                PlanDepotList>(
                              fieldViewBuilder: (
                                  BuildContext context,
                                  TextEditingController fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted,
                                  ) {
                                _plantcontroller = fieldTextEditingController;

                                if (selectedPlant != null &&
                                    _plantcontroller!.text != _displayPlantForOption(selectedPlant!)) {
                                  _plantcontroller!.text = _displayPlantForOption(selectedPlant!);
                                }

                                return TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(borderRadiusTLBR),
                                        topRight: Radius.circular(borderRadiusTRBL),
                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                        bottomRight: Radius.circular(borderRadiusTLBR),
                                      ),
                                      borderSide: BorderSide(color: borderColor!, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(borderRadiusTLBR),
                                        topRight: Radius.circular(borderRadiusTRBL),
                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                        bottomRight: Radius.circular(borderRadiusTLBR),
                                      ),
                                      borderSide: BorderSide(color: borderColor!, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(borderRadiusTLBR),
                                        topRight: Radius.circular(borderRadiusTRBL),
                                        bottomLeft: Radius.circular(borderRadiusTRBL),
                                        bottomRight: Radius.circular(borderRadiusTLBR),
                                      ),
                                      borderSide: BorderSide(color: borderColor!, width: 1.0),
                                    ),
                                    filled: true,
                                    labelText: "Plant",
                                    labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                    fillColor: fillColor,
                                  ),
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                );
                              },

                              displayStringForOption: _displayPlantForOption,
                              optionsBuilder: (
                                  TextEditingValue textEditingValue) {
                                if (textEditingValue
                                    .text == '') {
                                  return const Iterable<
                                      PlanDepotList>.empty();
                                }
                                return plants
                                    .where((
                                    PlanDepotList option) {
                                  return option
                                      .name
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                      textEditingValue
                                          .text
                                          .toLowerCase());
                                });
                              },
                              onSelected: (
                                  PlanDepotList selection) {
                                FocusManager.instance
                                    .primaryFocus
                                    ?.unfocus();
                                setState(() {
                                  selectedPlant =
                                      selection;
                                });


                                BlocProvider.of<TodayRateBloc>(context).add(
                                    LoadOverallData(
                                        userId: Constants.AUTH_USERID,
                                        oilTypeId: selectedOilType!.id!,
                                        plantId: selectedPlant!
                                            .id!,
                                        incoTermId: selectedIncoTerms!.id!,
                                        verticalId: (selectedVertical == null
                                            ? 0
                                            : selectedVertical!.id!),
                                        salesOrgId: (selectedSalesOrg == null
                                            ? 0
                                            : selectedSalesOrg!.id!),
                                        distrChannelId:
                                        (selectedDistrChannel == null
                                            ? 0
                                            : selectedDistrChannel!
                                            .id!)));
                              },
                            ),
                            const SizedBox(height: 16),
                          ]),
                          /*StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                //height: 70,
                                child: CommonDropdownButtonFormField<PlanDepotList>(
                                  isExpanded: true,
                                  value: selectedPlant,
                                  icon: const Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16,
                                      )),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 0.0),
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
                                              color: borderColor!, width: 1.0)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  borderRadiusTLBR),
                                              topRight: Radius.circular(
                                                  borderRadiusTRBL),
                                              bottomLeft: Radius.circular(
                                                  borderRadiusTRBL),
                                              bottomRight: Radius.circular(borderRadiusTLBR)),
                                          borderSide: BorderSide(color: borderColor!, width: 2.0)),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                      filled: true,
                                      // hintStyle: TextStyle(color: Colors.grey[800]),
                                      labelText: "Plant",
                                      labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                      fillColor: fillColor),
                                  onChanged: (PlanDepotList? newValue) {
                                    setState(() {
                                      selectedPlant = newValue!;
                                    });
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadOverallData(
                                            userId: Constants.AUTH_USERID,
                                            oilTypeId: selectedOilType!.id!,
                                            plantId: newValue!.id!,
                                            incoTermId: selectedIncoTerms!.id!,
                                            verticalId: (selectedVertical == null
                                                ? 0
                                                : selectedVertical!.id!),
                                            salesOrgId: (selectedSalesOrg == null
                                                ? 0
                                                : selectedSalesOrg!.id!),
                                            distrChannelId:
                                            (selectedDistrChannel == null
                                                ? 0
                                                : selectedDistrChannel!
                                                .id!)));

                                  },
                                  items: plants
                                      .map<DropdownMenuItem<PlanDepotList>>(
                                          (value) {
                                    return DropdownMenuItem<PlanDepotList>(
                                      value: value,
                                      child: Text(value.name!),
                                    );
                                  }).toList(),
                                ));
                          }),
                    Visibility(visible:Constants.AUTH_ROLEID!=Constants.DEALER,child:const SizedBox(height: 16.0)),*/
                    Visibility(visible:Constants.AUTH_ROLEID!=Constants.DEALER,child:StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                                width: double.infinity,
                                // height: 70,
                                child: CommonDropdownButtonFormField<OilType>(
                                  value: selectedOilType,
                                  label: "Oil Type",
                                  onChanged: (OilType? newValue) {
                                    setState(() {
                                      selectedOilType = newValue!;
                                    });
                                    BlocProvider.of<TodayRateBloc>(context).add(
                                        LoadOverallData(
                                            userId: Constants.AUTH_USERID,
                                            oilTypeId: newValue!.id!,
                                            plantId: selectedPlant!.id!,
                                            incoTermId: selectedIncoTerms!.id!,
                                            verticalId: (selectedVertical == null
                                                ? 0
                                                : selectedVertical!.id!),
                                            salesOrgId: (selectedSalesOrg == null
                                                ? 0
                                                : selectedSalesOrg!.id!),
                                            distrChannelId:
                                                (selectedDistrChannel == null
                                                    ? 0
                                                    : selectedDistrChannel!
                                                        .id!)));
                                  },
                                  items: oilTypes
                                      .map<DropdownMenuItem<OilType>>((value) {
                                    return DropdownMenuItem<OilType>(
                                      value: value,
                                      child: Text(value.name!),
                                    );
                                  }).toList(),
                                ));
                          })),
                          const SizedBox(height: 16.0),
                        ],
                      )),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 0, right: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 4,
                                decoration: BoxDecoration(
                                    color: Constant.colorOrange,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                              ),
                              CommonText(
                                name: "SKU List",
                                fontSize: Constant.fontSize14,
                                fontColor: Constant.colorBlack,
                                fontWeight: Constant.fontWeight600,
                              )
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        color: const Color(0xFFECECEC),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              name: "Oil Type",
                              fontSize: Constant.fontSize12,
                              fontColor: Constant.colorBlack,
                              fontWeight: Constant.fontWeight600,
                            ),
                            CommonText(
                              name: "Basic Price(Rs)",
                              fontSize: Constant.fontSize13,
                              fontColor: Constant.colorBlack,
                              fontWeight: Constant.fontWeight600,
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dailyRates.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: CommonText(
                                  name: dailyRates[index].skuName,
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500,
                                )),
                                CommonText(
                                  name: "Rs." +
                                      dailyRates[index].finalPrice.toString(),
                                  fontSize: Constant.fontSize13,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500,
                                ),
                                // Expanded(
                                //     child: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //
                                //   ],
                                // )),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: Expanded(
                                //     child:
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  )),
                ),
                progressBar
              ],
            ),
            bottomNavigationBar: Visibility(
              visible:  isActive,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 16, bottom: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth / 1 - 67,
                        child: CommonButton(
                          buttonName: Constant.todayRateTxt1,
                          buttonNameSize: Constant.fontSize13,
                          buttonNameColor: Constant.pricbuttonTxtColor,
                          buttonColor: Constant.pricbuttonColor,
                          buttonHeight: 50,
                          buttonRadiusTL: Constant.pricbuttonRadiusTL,
                          buttonRadiusBL: Constant.pricbutRadiusBL,
                          buttonBorder: Colors.transparent,
                          buttonNameWeight: Constant.fontWeight500,
                          buttonFunction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NewSauduScreen()));
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          )),
        ));
  }
}
