import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_request.dart';
import 'package:adaniwilmar/screen/sauda/sauda_screen.dart';
import 'package:adaniwilmar/screen/sauda_limit_enhancement/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda_limit_enhancement/sauda_limit_enhancement_history.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/autocomplete/autocompleter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaLimitEnhancementScreen extends StatelessWidget {
  const SaudaLimitEnhancementScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaLimitEnhancementScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaLimitEnhancementBloc()
        // ..add(LoadSaudaLimitEnhancementScreen(userId: Constants.AUTH_USERID))
        ..add(LoadSalesOrganization(id: 0, saudaBookingTypeId: 0)),
      // ..add(LoadOilType()),
      child: const SaudaLimitEnhancementForm(),
    );
  }
}

class SaudaLimitEnhancementForm extends StatefulWidget {
  const SaudaLimitEnhancementForm({Key? key}) : super(key: key);

  @override
  State<SaudaLimitEnhancementForm> createState() =>
      _SaudaLimitEnhancementFormState();
}

class _SaudaLimitEnhancementFormState extends State<SaudaLimitEnhancementForm> {
  List<DistributorList> distributorList = [];
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<BdoList> bdoList = [];
  DealerSaudaDetail saudaDetail = DealerSaudaDetail();
  final TextEditingController _limitcontroller = TextEditingController();
  final TextEditingController _remarkscontroller = TextEditingController();
  DistributorList? selectedDistributor;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  BdoList? selectedBdo;
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
  static String _displayStringForOption(DistributorList option) =>
      option.employeeName!;
  TextEditingController? _distributorcontroller;
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
    return BlocListener<SaudaLimitEnhancementBloc, SaudaLimitEnhancementState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            selectedDistributor = null;
            distributorList = state.distributorList;
            setState(() {});
          }
          if (state is OnLoadSalesOrganization) {
            salesOrgList = state.salesOrganization;
            if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
              BlocProvider.of<SaudaLimitEnhancementBloc>(context)
                  .add(LoadBDO(userId: Constants.AUTH_USERID));
            }
            setState(() {});
          }
          if (state is OnLoadBDO) {
            selectedBdo = null;
            bdoList = state.bdoList;
            setState(() {});
          }
          if (state is OnLoadDealerSaudaDetail) {
            saudaDetail = state.dealerSaudaDetail;
            setState(() {});
          }
          if (state is OnLoadDistributionChannel) {
            selectedDistrChannel = null;
            distrChannels = state.distributionChannel;
            setState(() {});
          }
          if (state is OnLoadVerticalList) {
            selectedVertical = null;
            selectedDistributor = null;
            verticals = state.verticalList;
            setState(() {});
          }
          if (state is OnSaveLimitEnhancement) {
            showSuccessDlg(context, "Request Confirmed", "Success",
                successText:
                    "Your limit enhancement request has been raised successfully");
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
            title: "Sauda Limit Enhancement",
            backArrow: true,
            listOfActions: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SaudaLimitEnhancementHistoryScreen()),
                    );
                  },
                  icon: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        padding: const EdgeInsets.all(1),
                        child: Padding(
                            padding: EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              'assets/images/history.svg',
                              fit: BoxFit.contain,
                            ))),
                  ),
                ),
              ],
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
                      height: screenHeight,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: 50),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return SizedBox(
                                          width: double.infinity,
                                          // height: 70,
                                          child: CommonDropdownButtonFormField<SalesOrganization>(
                                            label: "Sales Organization",
                                            value: selectedSalesOrg,
                                            onChanged:
                                                (SalesOrganization? newValue) {
                                              setState(() {
                                                selectedSalesOrg = newValue!;
                                              });
                                              BlocProvider.of<
                                                          SaudaLimitEnhancementBloc>(
                                                      context)
                                                  .add(LoadDistributionChannel(
                                                      id: selectedSalesOrg!
                                                          .id!));
                                            },
                                            items: salesOrgList.map<
                                                    DropdownMenuItem<
                                                        SalesOrganization>>(
                                                (value) {
                                              return DropdownMenuItem<
                                                  SalesOrganization>(
                                                value: value,
                                                child: Text(value
                                                    .salesOrganizationName!),
                                              );
                                            }).toList(),
                                          ));
                                    }),
                                    const SizedBox(height: 16),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return SizedBox(
                                          width: double.infinity,
                                          //height: 70,
                                          child: CommonDropdownButtonFormField<DistributionChannel>(
                                            label: "Distribution Channel",
                                            value: selectedDistrChannel,
                                            onChanged: (DistributionChannel?
                                                newValue) {
                                              setState(() {
                                                selectedDistrChannel =
                                                    newValue!;
                                              });
                                              BlocProvider.of<
                                                          SaudaLimitEnhancementBloc>(
                                                      context)
                                                  .add(LoadVerticalList(
                                                      distributionId:
                                                          selectedDistrChannel!
                                                              .id!));
                                            },
                                            items: distrChannels.map<
                                                    DropdownMenuItem<
                                                        DistributionChannel>>(
                                                (value) {
                                              return DropdownMenuItem<
                                                  DistributionChannel>(
                                                value: value,
                                                child: Text(value
                                                    .distributionChannelName!),
                                              );
                                            }).toList(),
                                          ));
                                    }),
                                    const SizedBox(height: 16.0),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return SizedBox(
                                          width: double.infinity,
                                          //height: 70,
                                          child:
                                              CommonDropdownButtonFormField<Vertical>(
                                            label: "Division",
                                            value: selectedVertical,
                                            onChanged: (Vertical? newValue) {
                                              setState(() {
                                                selectedVertical = newValue!;
                                              });
                                              if (Constants.AUTH_ROLEID !=
                                                  Constants.ZHMANAGER) {
                                                BlocProvider.of<SaudaLimitEnhancementBloc>(
                                                        context)
                                                    .add(LoadSaudaLimitEnhancementScreen(
                                                        userId:
                                                            Constants
                                                                .AUTH_USERID,
                                                        salesOrganizationId:
                                                            selectedSalesOrg!
                                                                .id!,
                                                        distributionChannelId:
                                                            selectedDistrChannel!
                                                                .id!,
                                                        divisonId:
                                                            selectedVertical!
                                                                .id!,
                                                        bdoId: selectedBdo !=
                                                                null
                                                            ? selectedBdo!.id!
                                                            : 0));
                                              }
                                              if (Constants.AUTH_ROLEID ==
                                                  Constants.DEALER) {
                                                BlocProvider.of<SaudaLimitEnhancementBloc>(
                                                        context)
                                                    .add(LoadDealerSaudaDetail(
                                                        id: Constants
                                                            .AUTH_USERID,
                                                        saudaBookingTypeId: 1,
                                                        salesOrganizationId:
                                                            selectedSalesOrg!
                                                                .id!,
                                                        distributionChannelId:
                                                            selectedDistrChannel!
                                                                .id!,
                                                        divisionId:
                                                            selectedVertical!
                                                                .id!));
                                              }
                                            },
                                            items: verticals.map<
                                                    DropdownMenuItem<Vertical>>(
                                                (value) {
                                              return DropdownMenuItem<Vertical>(
                                                value: value,
                                                child: Text(value.name!),
                                              );
                                            }).toList(),
                                          ));
                                    }),
                                    const SizedBox(height: 16),
                                    Visibility(
                                      visible: Constants.AUTH_ROLEID ==
                                          Constants.ZHMANAGER,
                                      child: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return SizedBox(
                                            width: double.infinity,
                                            // height: 70,
                                            child: CommonDropdownButtonFormField<
                                                BdoList>(
                                              label: "State Trader",
                                              value: selectedBdo,
                                              onChanged: (BdoList? newValue) {
                                                setState(() {
                                                  selectedBdo = newValue!;
                                                });
                                                if (Constants.AUTH_ROLEID ==
                                                    Constants.ZHMANAGER) {
                                                  BlocProvider.of<
                                                              SaudaLimitEnhancementBloc>(
                                                          context)
                                                      .add(LoadSaudaLimitEnhancementScreen(
                                                          userId:
                                                              Constants
                                                                  .AUTH_USERID,
                                                          salesOrganizationId:
                                                              selectedSalesOrg!
                                                                  .id!,
                                                          distributionChannelId:
                                                              selectedDistrChannel!
                                                                  .id!,
                                                          divisonId:
                                                              selectedVertical!
                                                                  .id!,
                                                          bdoId: selectedBdo !=
                                                                  null
                                                              ? selectedBdo!.id!
                                                              : 0));
                                                }
                                              },
                                              items: bdoList.map<
                                                  DropdownMenuItem<
                                                      BdoList>>((value) {
                                                return DropdownMenuItem<
                                                    BdoList>(
                                                  value: value,
                                                  child: Text(value.name!),
                                                );
                                              }).toList(),
                                            ));
                                      }),
                                    ),
                                    Visibility(
                                        visible: Constants.AUTH_ROLEID ==
                                            Constants.ZHMANAGER,
                                        child: const SizedBox(height: 16)),
                                    // StatefulBuilder(builder:
                                    //     (BuildContext context,
                                    //         StateSetter setState) {
                                    //   return SizedBox(
                                    //       width: double.infinity,
                                    //       // height: 70,
                                    //       child: CommonDropdownButtonFormField<
                                    //           DistributorList>(
                                    //         isExpanded: true,
                                    //         value: selectedDistributor,
                                    //         icon: const Align(
                                    //             alignment: Alignment.topRight,
                                    //             child: Icon(
                                    //               Icons.keyboard_arrow_down,
                                    //               size: 24,
                                    //             )),
                                    //         elevation: 16,
                                    //         style: const TextStyle(
                                    //             color: Colors.black),
                                    //         decoration: InputDecoration(
                                    //             contentPadding:
                                    //                 const EdgeInsets.symmetric(
                                    //                     horizontal: 12.0,
                                    //                     vertical: 0.0),
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
                                    //                     topLeft: Radius.circular(borderRadiusTLBR),
                                    //                     topRight: Radius.circular(borderRadiusTRBL),
                                    //                     bottomLeft: Radius.circular(borderRadiusTRBL),
                                    //                     bottomRight: Radius.circular(borderRadiusTLBR)),
                                    //                 borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                    //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                    //             filled: true,
                                    //             // hintStyle: TextStyle(color: Colors.grey[800]),
                                    //             labelText: "Distributor Name",
                                    //             labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                    //             fillColor: fillColor),
                                    //         onChanged:
                                    //             (DistributorList? newValue) {
                                    //           setState(() {
                                    //             selectedDistributor = newValue!;
                                    //           });
                                    //           BlocProvider.of<
                                    //                       SaudaLimitEnhancementBloc>(
                                    //                   context)
                                    //               .add(LoadDealerSaudaDetail(
                                    //                   id: selectedDistributor!
                                    //                       .id!,
                                    //                   saudaBookingTypeId:
                                    //                       selectedDistributor!
                                    //                           .saudaBookingTypeId!,
                                    //                   salesOrganizationId:
                                    //                       selectedSalesOrg!.id!,
                                    //                   distributionChannelId:
                                    //                       selectedDistrChannel!
                                    //                           .id!,
                                    //                   divisionId:
                                    //                       selectedVertical!
                                    //                           .id!));
                                    //         },
                                    //         items: distributorList.map<
                                    //             DropdownMenuItem<
                                    //                 DistributorList>>((value) {
                                    //           return DropdownMenuItem<
                                    //               DistributorList>(
                                    //             value: value,
                                    //             child: Text(value.employeeName!,
                                    //                 overflow:
                                    //                     TextOverflow.visible),
                                    //           );
                                    //         }).toList(),
                                    //       ));
                                    // })
                                    CustomAutocomplete<DistributorList>(
                                      fieldViewBuilder: (
                                          BuildContext context,
                                          TextEditingController fieldTextEditingController,
                                          FocusNode fieldFocusNode,
                                          VoidCallback onFieldSubmitted
                                          ) {
                                        _distributorcontroller=fieldTextEditingController;
                                        return TextField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 1,
                                          decoration:InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 12.0, vertical: 10.0),
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
                                                      bottomLeft: Radius.circular(borderRadiusTRBL),
                                                      bottomRight: Radius.circular(borderRadiusTLBR)),
                                                  borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusTLBR), topRight: Radius.circular(borderRadiusTRBL), bottomLeft: Radius.circular(borderRadiusTRBL), bottomRight: Radius.circular(borderRadiusTLBR)), borderSide: BorderSide(color: borderColor!, width: 1.0)),
                                              filled: true,
                                              // hintStyle: TextStyle(color: Colors.grey[800]),
                                              labelText: "Distributor Name",
                                              labelStyle: TextStyle(color: labelTxtCol, fontSize: labelTxtSize),
                                              fillColor: fillColor),
                                          controller: fieldTextEditingController,
                                          focusNode: fieldFocusNode,
                                          // style: const TextStyle(fontWeight: FontWeight.normal),
                                        );
                                      },
                                      displayStringForOption: _displayStringForOption,
                                      optionsBuilder: (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<DistributorList>.empty();
                                        }
                                        return distributorList.where((DistributorList option) {
                                          return option.employeeName
                                              .toString().toLowerCase()
                                              .contains(textEditingValue.text.toLowerCase());
                                        });
                                      },
                                      onSelected: (DistributorList selection) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        setState(() {
                                          selectedDistributor = selection;
                                        });
                                        BlocProvider.of<SaudaLimitEnhancementBloc>(
                                                          context)
                                                      .add(LoadDealerSaudaDetail(
                                                          id: selectedDistributor!
                                                              .id!,
                                                          saudaBookingTypeId:
                                                              selectedDistributor!
                                                                  .saudaBookingTypeId!,
                                                          salesOrganizationId:
                                                              selectedSalesOrg!.id!,
                                                          distributionChannelId:
                                                              selectedDistrChannel!
                                                                  .id!,
                                                          divisionId:
                                                              selectedVertical!
                                                                  .id!));
                                      },
                                    ),
                                  ])),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth / 2.4,
                                    child: Container(
                                      height: 76,
                                      margin: const EdgeInsets.only(bottom: 0),
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 16,
                                          right: 16),
                                      decoration: BoxDecoration(
                                        color: Constant.saudaLETBoxColor1,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Text(
                                                          Constant
                                                              .saudaLETBox1Txt1!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize10,
                                                                  ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                  (saudaDetail.availableSaudaLimit !=
                                                        null
                                                    ? saudaDetail
                                                        .availableSaudaLimit
                                                        .toString()
                                                    : "0")+" MT",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Constant.fontSize16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  SizedBox(
                                    width: screenWidth / 2.4,
                                    child: Container(
                                      height: 76,
                                      margin: const EdgeInsets.only(bottom: 0),
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 16,
                                          right: 16),
                                      decoration: BoxDecoration(
                                        color: Constant.saudaLETBoxColor2,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Text(
                                                          Constant
                                                              .saudaLETBox2Txt2!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        Constant
                                                                            .fontSize10,
                                                                  ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                  (saudaDetail.totalSaudaLimit !=
                                                        null
                                                    ? saudaDetail
                                                        .totalSaudaLimit
                                                        .toString()
                                                    : "0")+" MT",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Constant.fontSize16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  // CurveBox(
                                  //     boxSize: 2,
                                  //     miniusValue: 27,
                                  //     boxHeight: 76,
                                  //     boxColor: Constant.saudaLETBoxColor1,
                                  //     headingTxt: Constant.saudaLETBox1Txt1,
                                  //     subHeading: saudaDetail != null &&
                                  //             saudaDetail.availableSaudaLimit != null
                                  //         ? saudaDetail.availableSaudaLimit.toString()
                                  //         : "0",
                                  //     headingFontSize: Constant.fontSize13,
                                  //     subHeadingFontSize: Constant.fontSize16,
                                  //     subhHadingFontWeight: FontWeight.w600),
                                  // const SizedBox(width: 13),
                                  // CurveBox(
                                  //     boxSize: 2,
                                  //     miniusValue: 30,
                                  //     boxHeight: 76,
                                  //     boxColor: Constant.saudaLETBoxColor2,
                                  //     headingTxt: Constant.saudaLETBox2Txt2,
                                  //     subHeading: saudaDetail != null &&
                                  //             saudaDetail.totalSaudaLimit != null
                                  //         ? saudaDetail.totalSaudaLimit.toString()
                                  //         : "0",
                                  //     headingFontSize: Constant.fontSize13,
                                  //     subHeadingFontSize: Constant.fontSize16,
                                  //     subhHadingFontWeight: FontWeight.w600)
                                ],
                              ),
                              const SizedBox(height: 16),
                              CommonTextFormField(
                                  labeltxt:
                                      "Required Additional Sauda Limit (MT)",
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
                              CommonTextFormField(
                                maxLine: 4,
                                labeltxt: "Remarks",
                                labeltxtColor: Constant.textFormFieldColor,
                                labeltxtSize: Constant.textFormFieldSize,
                                labeltxtFontWeight:
                                    Constant.textFormFieldSizeFontW,
                                focuBorColor: Constant.textFormFocuBorCol,
                                focuBorWid: Constant.textFormFocuBorWid,
                                enaBorColor: Constant.textFormEnaBorCol,
                                enaBorWid: Constant.textFormEnaBorWid,
                                borderRadiusTL: Constant.textFormborderRadiusTL,
                                borderRadiusBR: Constant.textFormborderRadiusBR,
                                contentPadHor: Constant.textFormcontentPadHor,
                                contentPadHVer: Constant.textFormcontentPadHVer,
                                controllerTxt: _remarkscontroller,
                              ),
                              const SizedBox(height: 16),
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
                          selectedDistributor = null;
                          _limitcontroller.text = "";
                          _remarkscontroller.text = "";
                          saudaDetail = DealerSaudaDetail();
                        }),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: screenWidth / 2 - 40,
                    child: CommonButton(
                        buttonName: "Raise Request",
                        buttonNameSize: Constant.pricbuttonNameSize,
                        buttonNameColor: Constant.pricbuttonTxtColor,
                        buttonColor: Constant.pricbuttonColor,
                        buttonHeight: Constant.pricbuttonHeight,
                        buttonRadiusTL: Constant.pricbuttonRadiusTL,
                        buttonRadiusBL: Constant.pricbutRadiusBL,
                        buttonBorder: Colors.transparent,
                        buttonFunction: () {
                          if (Constants.AUTH_ROLEID != Constants.DEALER) {
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
                            if (selectedDistributor == null) {
                              showSuccessDlg(context, "Error", "Error",
                                  successText:
                                      "Select Distributor from the list",
                                  closeScreen: false);
                              return;
                            }
                          }
                          if (_limitcontroller.text.toString() == "") {
                            showSuccessDlg(context, "Error", "Error",
                                successText: "Enter new limit",
                                closeScreen: false);
                            return;
                          }
                          // if(_remarkscontroller.text.toString()==""){
                          //   showSuccessDlg(context, "Error", "Error",successText: "Enter Remarks",closeScreen: true);
                          //   return;
                          // }
                          LimitEnhancementRequest request =
                              LimitEnhancementRequest();
                          if (Constants.AUTH_ROLEID != Constants.DEALER) {
                            request.dealerId = selectedDistributor!.id!;
                            request.divisionId = selectedVertical!.id!;
                            request.distributionChannelId =
                                selectedDistrChannel!.id!;
                            request.salesOrganizationId = selectedSalesOrg!.id!;
                          } else {
                            request.dealerId = Constants.AUTH_USERID;
                          }
                          request.remarks = _remarkscontroller.text.toString();
                          request.actualLimit = saudaDetail.totalSaudaLimit;
                          request.requestQuantityLimit =
                              double.parse(_limitcontroller.text.toString());
                          request.createdBy = Constants.AUTH_USERID;
                          BlocProvider.of<SaudaLimitEnhancementBloc>(context)
                              .add(SaveLimitEnhancement(request: request));
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
                        builder: (context) =>
                            const SaudaLimitEnhancementHistoryScreen()),
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
}
