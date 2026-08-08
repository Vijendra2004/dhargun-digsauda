import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/bdo_list_response.dart';
import '../../models/daily_rate_response.dart';
import '../../models/qa_list_model.dart';
import '../../models/request_quantity_create_req.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';
import 'bloc/request_quantity_create_bloc.dart';
import 'bloc/request_quantity_create_state.dart';
import 'bloc/request_quantity_create_event.dart';

class RequestQuantityCreateScreen extends StatelessWidget {
  QAListResponseValue? qa = QAListResponseValue();

  RequestQuantityCreateScreen({Key? key, this.qa}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => RequestQuantityCreateScreen(qa: QAListResponseValue()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child:  AssignedQuallityAllocation(qa:qa),
    );
  }

  RequestQuantityCreateBloc _getInitialLoadData() {
    RequestQuantityCreateBloc todayRateBloc = RequestQuantityCreateBloc();
    todayRateBloc.add(LoadSalesOrganization());
    return todayRateBloc;
  }
}

class AssignedQuallityAllocation extends StatefulWidget {
  QAListResponseValue? qa = QAListResponseValue();

   AssignedQuallityAllocation( {Key? key, this.qa}) : super(key: key);

  @override
  State<AssignedQuallityAllocation> createState() => _AssignedQuallityAllocationState();
}

class _AssignedQuallityAllocationState extends State<AssignedQuallityAllocation>
    with TickerProviderStateMixin {
  String assignedFromDate = "-";
  String assignedToDate = "-";
  TextEditingController? _oilTypeController;
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;
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
  TextEditingController _quantitycontroller = TextEditingController();
  List<int> selectedEmployeeIds = [];
  List<ZonalEmployeeList> selectedZonalEmployees = [];

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
    return BlocListener<RequestQuantityCreateBloc, RequestQuantityCreateState>(
        listener: (context, state) {
          if (state is OnSaveSuccess) {
            Utils().showSuccessDlg(
                context, "Quantity Requested", "Quantity Requested",
                successText: "Successfully", closeScreen: true);
          } else if (state is OnFailure) {
            Utils().showSuccessDlg(context, "Error", "Error",
                successText: state.error);
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
            title: "Request Quantity",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              quantityDetailTextWidget("Oil Type",widget.qa?.oilTypeName != null?widget.qa!.oilTypeName.toString():"-"),
                              quantityDetailTextWidget("Assigned Quantity",widget.qa?.quantityLimit != null?widget.qa!.quantityLimit.toString():"-"),
                              SizedBox(height: Constant.headingSix),
                              CommonText(
                                name: "Request Quantity",
                                fontColor: Constant.colorDullGray77,
                                fontSize: Constant.fontSize13,
                              ), const SizedBox(height: 16,),
                              CommonTextFormField(
                                  labeltxt: "",
                                  enabled: true,
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
                                  controllerTxt: _quantitycontroller,
                                  keyborType: TextInputType.number,
                                  onChanged: (String? value) {
                                  }),
                              const SizedBox(height: 16.0),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CommonButton(
                                      buttonName: "Cancel",
                                      buttonNameSize:
                                          Constant.pricbuttonNameSize,
                                      buttonNameColor:
                                          Constant.textFormFieldColor,
                                      buttonColor: Colors.white,
                                      buttonHeight: Constant.pricbuttonHeight,
                                      buttonRadiusTL:
                                          Constant.pricbuttonRadiusTL,
                                      buttonRadiusBL: Constant.pricbutRadiusBL,
                                      buttonBorder: Colors.black,
                                      buttonFunction: () {
                                        Navigator.pop(ctx);
                                      }),
                                  CommonButton(
                                      buttonName: "Submit",
                                      buttonNameSize:
                                          Constant.pricbuttonNameSize,
                                      buttonNameColor:
                                          Constant.pricbuttonTxtColor,
                                      buttonColor: Constant.pricbuttonColor,
                                      buttonHeight: Constant.pricbuttonHeight,
                                      buttonRadiusTL:
                                          Constant.pricbuttonRadiusTL,
                                      buttonRadiusBL: Constant.pricbutRadiusBL,
                                      buttonBorder: Colors.transparent,
                                      buttonFunction: () {
                                        submitRequestQuantity();
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

  Widget quantityDetailTextWidget(String heading, String contentValue){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: Constant.headingSix),
        CommonText(
          name: heading,
          fontColor: Constant.colorDullGray77,
          fontSize: Constant.fontSize13,
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(Constant.headingSix!),
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Constant.textFormEnaBorCol!,
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: Radius.circular(Constant.textFormborderRadiusBR!),
                bottomLeft: Radius.circular(Constant.textFormborderRadiusBR!),
                bottomRight: const Radius.circular(10),
              )
          ),
          child: CommonText(
            name: contentValue,
            fontColor: Colors.grey.withOpacity(0.8),
            fontSize: Constant.fontSize13,
          ),
        ),
      ],
    );
  }

  void submitRequestQuantity() {
     if (_quantitycontroller.text.isEmpty) {
      Utils().showSuccessDlg(context, "Error", "Error",
          successText: "Please enter the Quantity");
    } else {
       RequestQuantityCreateReq requestQuantityCreateReq =
       RequestQuantityCreateReq();
      requestQuantityCreateReq.skuId = widget.qa?.skuId;
      requestQuantityCreateReq.statusId = 0;
      requestQuantityCreateReq.oiltypeId = widget.qa?.oilTypeId;
      requestQuantityCreateReq.specialtyFatQuantityLimitId = widget.qa?.id;
      requestQuantityCreateReq.userId = Constants.AUTH_USERID;
      requestQuantityCreateReq.loginUserId = Constants.AUTH_USERID;
      requestQuantityCreateReq.quantity =
          double.parse(_quantitycontroller.text);
      BlocProvider.of<RequestQuantityCreateBloc>(context)
          .add(SaveQuantityRequest(requestQuantityCreateReq: requestQuantityCreateReq));
    }
  }
}
