import 'package:adaniwilmar/models/GeoDiscountDetailRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/CitiesList.dart';
import '../../models/geography_discount_list.dart';
import '../../utils/constant.dart';
import '../../utils/datetime_utils.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/common-textfield.dart';
import '../../widget/common_button.dart';
import '../../widget/common_text.dart';
import '../../widget/curve_outer_box.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/floating_button.dart';
import 'bloc/discount_bloc.dart';
import 'bloc/discount_event.dart';
import 'bloc/discount_state.dart';
import 'create_geography_discount.dart';

class GeographyDiscountScreen extends StatelessWidget {
  static const String routeName = '/discount';

  GeographyDiscountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentDate = DateTimeUtils().dateToStringFormat(DateTime.now(), DateTimeUtils.ServerFormat);
    return BlocProvider(
      create: (context) => CreateDiscountBloc()..add(LoadGeographyDiscountList(userId: Constants.AUTH_ROLEID, date: currentDate)),
      child: const GeographyDiscount(),
    );
  }
}

class GeographyDiscount extends StatefulWidget {
  const GeographyDiscount({Key? key}) : super(key: key);

  @override
  State<GeographyDiscount> createState() => _GeographyDiscountState();
}

class _GeographyDiscountState extends State<GeographyDiscount> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<GeographyDiscountList> geographyDiscountRequestList = [];
  ProgressBarHandler? _handler;

  final TextEditingController _filterdatecontroller = TextEditingController();

  final GlobalKey _dialogKey = GlobalKey();

  int pos = -1;

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

    return BlocListener<CreateDiscountBloc, CreateDiscountState>(
      listener: (context, state) {
        if (state is ShowProgressBar) {
          _handler!.show!();
        }
        if (state is HideProgressBar) {
          _handler!.dismiss!();
        }

        if(state is GeographyDetailSuccess){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateGeography(
                  isUpdate: true,
                  isActive:geographyDiscountRequestList[pos].isActive!,
                  id: geographyDiscountRequestList[pos].id!,
                  materialIds: state.geoDiscountDetail!.skuIds!,
                  zoneIds:  state.geoDiscountDetail!.zoneIds!,
                  stateIds: state.geoDiscountDetail!.stateIds!,
                  skuName: geographyDiscountRequestList[pos].skuName!,
                  distributionChannelId: geographyDiscountRequestList[pos].distributionChannelId!,
                  divisionId: geographyDiscountRequestList[pos].divisionId!,
                  salesOrganizationId: geographyDiscountRequestList[pos].salesOrganizationId!,
                  oilPackageTypeId: geographyDiscountRequestList[pos].salesOrganizationId!,
                  oilTypeId: geographyDiscountRequestList[pos].oilTypeId!,
                  packGroupId: geographyDiscountRequestList[pos].packGroupId!,
                  packTypeId: geographyDiscountRequestList[pos].packGroupTypeId ??0,
                  discount: geographyDiscountRequestList[pos].actualDiscount.toString(),
                  discountReason: geographyDiscountRequestList[pos].discountReason!,
                  fromDate: geographyDiscountRequestList[pos].validFrom!,
                  toDate: geographyDiscountRequestList[pos].validTo!,
                  cities:  state.geoDiscountDetail!.cities!,
                )),
          );
        }

      },
      child: BlocBuilder<CreateDiscountBloc, CreateDiscountState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              primary: false,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              floatingActionButton: Visibility(
                visible: Constants.AUTH_ROLEID == Constants.NHMANAGER,
                child: FloatingButton(
                    buttonBgColor: Constant.colorRed,
                    buttonIcon: Constant.saudaIcPlus,
                    navigationFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateGeography(
                                  id: 0,
                                  materialIds: [],
                                  zoneIds: [],
                                  stateIds: [],
                                  isUpdate: false,
                                  oilTypeId: 0,
                                  skuName: "",
                                  packGroupId: "0",
                                  packTypeId: 0,
                                  discount: '',
                              distributionChannelId:0,
                              divisionId:0,
                              isActive: false,
                              salesOrganizationId: 0,
                              oilPackageTypeId: 0,
                                  discountReason: '',
                                  fromDate: '',
                                  toDate: '',
                                  cities: [],
                                )),
                      );
                    },
                    buttoniconSize: 20),
              ),
              body: BlocListener<CreateDiscountBloc, CreateDiscountState>(
                listener: (context, state) {
                  if (state is GeographyDiscountRequestSuccess) {
                    geographyDiscountRequestList = state.geographyDiscountList;
                    GMLogger.v("DataLostt${geographyDiscountRequestList}");
                    setState(() {

                    });
                  }
                  if (state is ShowProgressBar) {
                    _handler!.show!();
                  }
                  if (state is HideProgressBar) {
                    _handler!.dismiss!();
                  }
                },
                child: Stack(
                  // clipBehavior: Clip.none,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      child: Container(
                        child: Constant.bgImgGlobal,
                      ),
                    ),
                    CustomAppBar(
                      title: "Geography Discount",
                      backArrow: true,
                      listOfActions: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showCustomFilterDialog(context, "Filter", "Filter", dialogActionButtonFilter());
                            },
                            icon: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
                                padding: const EdgeInsets.all(7),
                                child: Constant.filterIc,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 60, right: 8, left: 8),
                      height: screenHeight * 0.98,
                      width: screenWidth,
                      child: (geographyDiscountRequestList.isNotEmpty)
                          ? CurveBorderBox(
                              boxLRPadding: 8,
                              boxTOPPadding: 0,
                              boxBOTPadding: 0,
                              boxofWidget: ListView.builder(
                                // itemCount: isFilter ? filterList.length: userDiscountRequestList.length,
                                itemCount: geographyDiscountRequestList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(left: 8, right: 8, top: 14, bottom: 8),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(25.0),
                                              topRight: Radius.circular(5.0),
                                              bottomLeft: Radius.circular(5.0),
                                              bottomRight: Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  pos = index;
                                                  GeoDiscountDetailRequest req = GeoDiscountDetailRequest();
                                                  req.parentId = geographyDiscountRequestList[index].id!;
                                                  req.pageNumber = 1;
                                                  req.pageSize = 10;
                                                  BlocProvider.of<CreateDiscountBloc>(context)
                                                      .add(GeoDiscountDetailsRequest(discountRequest:req ));
                                                },
                                                child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 14),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFFF5F5F5),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(25.0),
                                                        topRight: Radius.circular(5.0),
                                                        bottomLeft: Radius.circular(5.0),
                                                        bottomRight: Radius.circular(0.0),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            geographyDiscountRequestList[index].skuName.toString(),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            softWrap: false,
                                                            style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 3),
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD), width: 0.8))),
                                                      padding: const EdgeInsets.only(bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  CommonText(
                                                                    name: "Discount Amount",
                                                                    fontSize: Constant.fontSize12,
                                                                    fontColor: Constant.colorDullGray77,
                                                                  ),
                                                                  const SizedBox(height: 6.0),
                                                                  CommonText(
                                                                    name: geographyDiscountRequestList[index].actualDiscount.toString(),
                                                                    fontSize: Constant.fontSize12,
                                                                    fontColor: Constant.colorBlack,
                                                                    fontWeight: Constant.fontWeight500,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: <Widget>[
                                                        const Icon(Icons.calendar_month, size: 13, color: Colors.orange),
                                                        const SizedBox(width: 4.0),
                                                        Text(
                                                          "${geographyDiscountRequestList[index].validFrom.toString() ?? ''} - ${geographyDiscountRequestList[index].validTo.toString() ?? ''}",
                                                          style: TextStyle(fontSize: Constant.fontSize13, color: Constant.colorGray45, fontWeight: Constant.fontWeight500),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Align(
                              alignment: Alignment.center,
                              child: CurveOuterBox(
                                boxTBPadding: 30,
                                boxofWidget: Text("No records found"),
                              ),
                            ),
                    ),
                    progressBar,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showCustomFilterDialog(BuildContext context, messageValue, title, footerbutton, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
            key: _dialogKey,
            builder: (context, setState) {
              return AlertDialog(
                // insetPadding: const EdgeInsets.only(left: 20, right: 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                titlePadding: const EdgeInsets.all(0),
                contentPadding: EdgeInsets.zero,
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Constant.colorOrange,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: Constant.fontSize15,
                          fontWeight: Constant.fontWeight500,
                        )),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Constant.colorWhite,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                content: Container(height: 100, width: double.infinity,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 20), child: getDialogContent()),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [footerbutton],
                  )
                ],
              );
            });
      },
    );
  }

  Widget dialogActionButtonFilter() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Cancel",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.saudaLETTxtColor,
              buttonColor: Constant.saudaLETbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: screenWidth / 3.2,
            child: CommonButton(
              buttonName: "Apply",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 50,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                String filterDate = _filterdatecontroller.text.toString();
                BlocProvider.of<CreateDiscountBloc>(context).add(LoadGeographyDiscountList(userId: Constants.AUTH_ROLEID, date: filterDate));
                _filterdatecontroller.clear();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getDialogContent() {
    var ctx = context;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectFilterDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "Filter Date",
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
                  controllerTxt: _filterdatecontroller,
                  enabled: false,
                )),
          ),
        ],
      ),
    ]);
  }

  _selectFilterDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _filterdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(_filterdatecontroller.text.toString(), DateTimeUtils.DD_MM_YYYY_Format, DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _filterdatecontroller.text = DateTimeUtils().dateToStringFormat(selected, DateTimeUtils.ServerFormat);
    }
  }
}
