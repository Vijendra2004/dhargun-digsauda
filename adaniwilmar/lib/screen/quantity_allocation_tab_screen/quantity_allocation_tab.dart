import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/screen/quantity_allocation/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';
import '../assigned_quantity_allocation_list/assigned_qa_list_screen.dart';
import '../quantity_allocation_list/qa_list_screen.dart';

class QuantityAllocationTabScreen extends StatelessWidget {
  const QuantityAllocationTabScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const QuantityAllocationTabScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuantityAllocationBloc()
        ..add(LoadOilType())
        ..add(LoadQuantityAllocationRequest(userId: Constants.AUTH_USERID)),
      child: const QuantityAllocationTab(),
    );
  }
}

class QuantityAllocationTab extends StatefulWidget {
  const QuantityAllocationTab({Key? key}) : super(key: key);

  @override
  State<QuantityAllocationTab> createState() => _QuantityAllocationTabState();
}

class _QuantityAllocationTabState extends State<QuantityAllocationTab> with TickerProviderStateMixin {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = Constants.AUTH_ROLEID == Constants.SALE ? TabController(length: 1, vsync: this) : TabController(length: 2, vsync: this);
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
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    var ctx = context;
    void showCustomAlertDialog(BuildContext context, messageValue, title, handleOk, Null Function() param4,
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      type,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Given Qty",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          givenQty.toString() + "MT",
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              availableQty.toString() + "MT",
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                      inputFormatter: [new FilteringTextInputFormatter.deny(RegExp("[\\-]"))],
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
                  buttonFunction: () {
                    if (_quantitycontroller.text.toString() == "") {
                      return;
                    }
                    BlocProvider.of<QuantityAllocationBloc>(ctx).add(SaveQuantityRequest(
                        userId: Constants.AUTH_USERID, oilTypeId: oilTypeId, specialtyLimitId: specialityLimitId, skuId: skuId, quantity: double.parse(_quantitycontroller.text.toString())));
                  })
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

    return BlocListener<QuantityAllocationBloc, QuantityAllocationState>(
        listener: (context, state) {
          if (state is OnLoadOilType) {
            oilTypes = state.oilTypes;
            setState(() {});
          }
          if (state is OnOverallSuccess) {
            quantityAllocations = state.response;
            setState(() {});
          }
          if (state is OnOverallManagerSuccess) {
            quantityManagerAllocations = state.response;
            setState(() {});
          }
          if (state is OnQuantityAllocationRequestSuccess) {
            quantityRequestList = state.quantityRequestList;
            quantityManagerRequestList = state.quantityManagerRequestList;
            setState(() {});
          }
          if (state is OnSaveSuccess) {
            showSuccessDlg(context, "Quantity Request", "Quantity Request", successText: "Request Confirmed");
          }
          if (state is OnFailure) {
            showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
        },
        child: SafeArea(
            child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
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
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: CurveBorderBox(
                          boxLRPadding: 0,
                          boxofWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.all(1),
                                height: 50,
                                child: TabBar(
                                    indicator: tabController == 1
                                        ? const BoxDecoration(
                                            color: Color(0xFFF68C33),
                                          )
                                        : tabController == 2
                                            ? const BoxDecoration(color: Colors.green)
                                            : const BoxDecoration(
                                                color: Color(0xFFF68C33),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25.0),
                                                  topRight: Radius.circular(5.0),
                                                  bottomLeft: Radius.circular(5.0),
                                                  bottomRight: Radius.circular(25.0),
                                                ),
                                              ),
                                    controller: tabController,
                                    tabAlignment: TabAlignment.start,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    isScrollable: true,
                                    padding: EdgeInsets.zero,
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding: EdgeInsets.zero,
                                    indicatorWeight: 2,
                                    tabs: Constants.AUTH_ROLEID == Constants.SALE
                                        ? [
                                            Tab(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width - 5,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Assigned Quantity ",
                                                    style: TextStyle(color: tabController?.index == 0 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                        : [
                                            Tab(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width / 2.09,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Assigned Quantity",
                                                    style: TextStyle(color: tabController?.index == 0 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width / 2.08,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "User Quantity",
                                                    style: TextStyle(color: tabController?.index == 1 ? Colors.white : Colors.black, fontSize: Constant.fontSize14, fontWeight: Constant.fontWeight600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                              ),
                              SizedBox(
                                height: screenHeight * 0.900,
                                child: TabBarView(
                                  controller: tabController,
                                  children: Constants.AUTH_ROLEID == Constants.SALE
                                      ? [AssignedQAListScreen(false),] :
                                        [
                                          AssignedQAListScreen(false),
                                          const QAListScreen(),
                                        ],
                                ),
                              ),
                            ],
                          )))),
              progressBar
            ],
          ),
        )));
  }

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white}) {
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
      content: Text(successText!),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonButton(
                buttonName: "Ok",
                buttonNameWeight: Constant.fontWeight500,
                buttonNameSize: Constant.fontSize13,
                buttonNameColor: Constant.pricbuttonTxtColor,
                buttonColor: Constant.pricbuttonColor,
                buttonHeight: 48,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
                buttonBorder: Colors.transparent,
                buttonFunction: () {
                  Navigator.pop(context);
                  if (title == "Error") {
                    return;
                  }
                  Navigator.pop(context);
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
