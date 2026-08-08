import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../models/qa_list_model.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';
import '../request_quantity_approve/request_quantity_approve_screen.dart';
import '../request_quantity_create/request_quantity_create_screen.dart';
import 'bloc/requested_qa_list_bloc.dart';
import 'bloc/requested_qa_list_event.dart';
import 'bloc/requested_qa_list_state.dart';

class RequestedQAListScreen extends StatelessWidget {
  const RequestedQAListScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => RequestedQAListScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getInitialLoadData(),
      child: QualityAllocation(),
    );
  }

  RequestedQAListBloc _getInitialLoadData() {
    RequestedQAListBloc todayRateBloc = RequestedQAListBloc();
    todayRateBloc.add(const LoadQuantityAllocationCreateUpdateRequest());
    return todayRateBloc;
  }
}

class QualityAllocation extends StatefulWidget {
  QualityAllocation({Key? key}) : super(key: key);

  @override
  State<QualityAllocation> createState() => _QualityAllocationState();
}

class _QualityAllocationState extends State<QualityAllocation>
    with TickerProviderStateMixin {
  List<QAListResponseValue> listModel = <QAListResponseValue>[];
  TabController? tabController;
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

  get handleOk => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(_handleTabSelection);
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
    return BlocListener<RequestedQAListBloc, RequestedQAListState>(
        listener: (context, state) {
          if (state is onLoadQuantityRequestList) {
            listModel = state.listModel;
            setState(() {});
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
          body: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
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
                                if(listModel[i].isRequestedUser == false && (listModel[i].statusId == Constants.PENDING_REQUEST || listModel[i].statusId == Constants.REQUEST_FOR_APPROVAL)){
                                  var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RequestedQuantityApproveScreen(
                                                qa: listModel[i])),
                                  );
                                  if (res != null) {
                                    BlocProvider.of<RequestedQAListBloc>(context).add(
                                        const LoadQuantityAllocationCreateUpdateRequest());
                                  }
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
                                                  child: Text("Requested Quantity",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Constant
                                                              .colorLightGray,
                                                          fontWeight: Constant
                                                              .fontWeight400)),
                                                ),
                                                Text(
                                                    listModel[i]
                                                            .quantity
                                                            .toString() ??
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
                                                child: Text("Requested By",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Constant
                                                            .colorLightGray,
                                                        fontWeight: Constant
                                                            .fontWeight400)),
                                              ),
                                              Text(
                                                  (listModel[i].createdBy ?? "")
                                                      .split("T")[0],
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
                                                  child: Text("Status",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Constant
                                                              .colorLightGray,
                                                          fontWeight: Constant
                                                              .fontWeight400)),
                                                ),
                                                Text(listModel[i].status ?? "",
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
}
