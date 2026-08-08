import 'package:adaniwilmar/models/SaudaModApprovalRequest.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaModApproval/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constant.dart';
import '../../../models/SaudaModApprovalModel.dart';
import '../../../models/daily_rate_response.dart';
import '../../../utils/constant.dart';
import '../../../utils/datetime_utils.dart';
import '../../../widget/border_bottom.dart';
import '../../../widget/common-textfield.dart';
import '../../../widget/common_button.dart';
import '../../../widget/common_dropdown_button_form_field.dart';
import '../../../widget/common_text.dart';
import '../../../widget/curve_outer_box.dart';
import '../../../widget/curved_border_box.dart';
import '../../../widget/custom_appbar.dart';
import '../saudaDetails/SaudaModDetailScreen.dart';
import 'bloc/sauda_mod_approval_bloc.dart';
import 'bloc/sauda_mod_aprroval_event.dart';

class SaudaModApprovalScreen extends StatelessWidget {
  const SaudaModApprovalScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaModApprovalScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaModApprovalBloc()
        ..add(LoadModSalesOrganization(id: 0, saudaBookingTypeId: 0))
        ..add(LoadSaudaModApproval(
            userId: Constants.AUTH_USERID,
            fromDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            toDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            salesOrganizationId: 0,
            distributionChannelId: 0,
            divisionId: 0,
            statusId: 1,
            pageNo: 0)),
      child: SaudaModApproval(),
    );
  }
}

class SaudaModApproval extends StatefulWidget {
  SaudaModApproval({Key? key}) : super(key: key);
  int? selectedDiscountType = 1;

  @override
  State<SaudaModApproval> createState() => _SaudaModApprovalState();
}

class _SaudaModApprovalState extends State<SaudaModApproval> {
  int selected = 0 - 1;
  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;
  String fromDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  String toDate = DateTimeUtils()
      .dateToStringFormat(DateTime.now(), DateTimeUtils.DD_MM_YYYY_Format);
  final TextEditingController _commentcontroller = TextEditingController();
  int approvalStatusId = 0;
  final GlobalKey _dialogKey = GlobalKey();
  int selectedCount = 0;
  bool isChecked = false;
  SalesOrganization? selectedSalesOrg;
  DistributionChannel? selectedDistrChannel;
  Vertical? selectedVertical;
  List<SalesOrganization> salesOrgList = [];
  List<DistributionChannel> distrChannels = [];
  List<Vertical> verticals = [];
  List<SaudaModApprovalItem> approvalList = [];
  final Set<int> _selectedIds = {};
  late BuildContext ctxx;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ctxx = context;
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return BlocListener<SaudaModApprovalBloc, SaudaModApprovalState>(
        listener: (context, state) {
          if (state is OnSaudaModApprovalSuccess) {
            if (approvalList.isNotEmpty) {
              approvalList.clear();
            }
            approvalList = state.saudaModApprovalModel;
            _selectedIds.clear();
            setState(() {});
          }
          if (state is OnLoadModSalesOrganization) {
            salesOrgList = state.salesOrganization;
            _fromdatecontroller.text = fromDate;
            _todatecontroller.text = toDate;
            setState(() {});
          }
          if (state is OnModApprovalFailure) {
            showSuccessDlg(context, "Error", "Error",
                successText: state.errorMessage);
          }
          if (state is OnLoadModDistributionChannel) {
            if (_dialogKey.currentState != null &&
                _dialogKey.currentState!.mounted) {
              _dialogKey.currentState!.setState(() {
                selectedDistrChannel = null;
                distrChannels = state.distributionChannel;
              });
            }
            setState(() {});
          }
          if (state is OnLoadModVerticalList) {
            if (_dialogKey.currentState != null &&
                _dialogKey.currentState!.mounted) {
              _dialogKey.currentState!.setState(() {
                selectedVertical = null;
                verticals = state.verticalList;
              });
            }
            setState(() {});
          }
          if (state is ShowModApprovalProgress) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is HideModApprovalProgress) {
            setState(() {
              isLoading = false;
            });
          }
          if (state is OnSaudaSaveRejectSuccess) {
            String msg="";
            /*if(state.statusId == 3){
              msg = "Rejected";
            }else {
              msg = "Approved";
            }*/
            msg = "Approved/Reject sucessfully done";
            showSuccessDlg(
                context, "Sauda Modification ${msg}", "Sauda Modification Approval");
            BlocProvider.of<SaudaModApprovalBloc>(context)
                .add(
                    LoadSaudaModApproval(
                        userId: Constants.AUTH_USERID,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        salesOrganizationId: 0,
                        distributionChannelId: 0,
                        divisionId: 0,
                        statusId: 1,
                        pageNo: 0));
          }
        },
        child: SafeArea(
            child: Scaffold(
                primary: false,
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title: "Sauda Modification Approval",
                  backArrow: true,
                  listOfActions: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showCustomFilterDialog(context, "Filter", "Filter",
                              dialogActionButtonFilter());
                        },
                        icon: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: const EdgeInsets.all(7),
                            child: Constant.filterIc,
                          ),
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
                    SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                            height: screenHeight * 0.980,
                            width: screenWidth,
                            margin: const EdgeInsets.only(
                                top: 60, left: 2, right: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CurveOuterBox(
                                  boxofWidget: Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                          children: [
                                            const Text("Select All"),
                                            Checkbox(
                                              onChanged: (bool? value) {
                                                isChecked = value!;
                                                if (value) {
                                                  selectAllSaudas();
                                                } else {
                                                  unSelectAllSaudas();
                                                }
                                                setState(() {});
                                              },
                                              value: isChecked,
                                              activeColor: Colors.green[600],
                                            )
                                          ],
                                        )),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: CommonText(
                                              name: selectedCount.toString() +
                                                  " Selected ",
                                              fontColor:
                                                  Constant.colorDullGray77,
                                              fontSize: Constant.fontSize12,
                                              fontWeight:
                                                  Constant.fontWeight500),
                                        )
                                      ],
                                    ),
                                    Container(
                                        height: screenHeight * 0.780,
                                        padding: EdgeInsets.zero,
                                        child: approvalList.isNotEmpty
                                            ? ListView.builder(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                itemCount: approvalList.length,
                                                itemBuilder: (context, index) {
                                                  final item =
                                                      approvalList[index];
                                                  final isSelected =
                                                      _selectedIds
                                                          .contains(item.id);
                                                  return CurveOuterBox(
                                                    boxLRPadding: 0,
                                                    boxTBPadding: 2,
                                                    boxofWidget: Theme(
                                                      data: theme,
                                                      child: ExpansionTile(
                                                        initiallyExpanded:
                                                            false,
                                                        tilePadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 2),
                                                        leading: Checkbox(
                                                          value: _selectedIds
                                                              .contains(
                                                                  item.id),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              value == true
                                                                  ? _selectedIds
                                                                      .add(item
                                                                          .id!)
                                                                  : _selectedIds
                                                                      .remove(item
                                                                          .id);
                                                              selectedCount =
                                                                  _selectedIds
                                                                      .length;
                                                            });
                                                          },
                                                        ),
                                                        title: Text(
                                                          item.dealerName ??
                                                              '-',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        children: [
                                                          _saudaDetailCard(
                                                              item),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'No Data Found',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))
                                  ]),
                                ),
                              ],
                            ))),
                    if (isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
                bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth / 2.2,
                          child: CommonButton(
                            buttonName: "Reject",
                            buttonNameSize: Constant.fontSize13,
                            buttonNameColor: Constant.pricbuttonTxtColor,
                            buttonColor: Constant.pricDisBocolor,
                            buttonHeight: 40,
                            buttonRadiusTL: Constant.pricbuttonRadiusTL,
                            buttonRadiusBL: Constant.pricbutRadiusBL,
                            buttonBorder: Colors.transparent,
                            buttonNameWeight: Constant.fontWeight500,
                            buttonFunction: () {
                              approvalStatusId = 3;
                              _commentcontroller.text = "";
                              showCustomAlertDialog(context, {}, 'Reject Sauda',
                                  dialogActionButton(),
                                  hideCancelBtn: true);
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 2.2,
                          child: CommonButton(
                            buttonName: "Approve",
                            buttonNameSize: Constant.fontSize13,
                            buttonNameColor: Constant.pricbuttonTxtColor,
                            buttonColor: Constant.saudaLETBoxColor1,
                            buttonHeight: 40,
                            buttonRadiusTL: Constant.pricbuttonRadiusTL,
                            buttonRadiusBL: Constant.pricbutRadiusBL,
                            buttonBorder: Colors.transparent,
                            buttonNameWeight: Constant.fontWeight500,
                            buttonFunction: () {
                              if (_selectedIds.isEmpty) {
                                showSuccessDlg(context,
                                    "Please select any one of Items", "Error");
                                return;
                              }

                              approvalStatusId = 2;
                              _commentcontroller.text = "";
                              showCustomAlertDialog(
                                  context,
                                  {},
                                  'Approve Sauda Modification',
                                  dialogActionButton(),
                                  hideCancelBtn: true);
                            },
                          ),
                        ),
                      ],
                    )))));
  }

  Widget _saudaDetailCard(SaudaModApprovalItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SaudaModDetailScreen(id: item.id!)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('ID', item.id?.toString()),
                _infoRow('Sauda Number', item.saudaNumber),
                _infoRow(
                  'Bidding Date',
                  item.biddingDate != null
                      ? _formatDate(item.biddingDate!)
                      : 'NA',
                ),
                _infoRow(
                  'Modification Date',
                  item.modificationDate != null
                      ? _formatDate(item.modificationDate!)
                      : 'NA',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  _selectFromDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: _fromdatecontroller.text.toString() == ""
            ? DateTime.now()
            : DateTime.parse(DateTimeUtils().dateToServerToDateFormat(
                _fromdatecontroller.text.toString(),
                DateTimeUtils.DD_MM_YYYY_Format,
                DateTimeUtils.YYYY_MM_DD_Format)),
        firstDate: DateTime.now().add(const Duration(days: -2000)),
        lastDate: DateTime.now());
    if (selected != null) {
      _fromdatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  _selectToDate(BuildContext context) async {
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
        lastDate: DateTime.now().add(const Duration(days: 2000)));
    if (selected != null) {
      _todatecontroller.text = DateTimeUtils()
          .dateToStringFormat(selected, DateTimeUtils.DD_MM_YYYY_Format);
    }
  }

  void showCustomAlertDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
    // set up the button
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                  constraints: const BoxConstraints(),
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
            content: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 24,
              ),
              height: 250.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextFormField(
                      labeltxt: "Remarks",
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
                      contentPadHVer: 10,
                      onTapCallBack: () {},
                      controllerTxt: _commentcontroller,
                      maxLine: 9,
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                children: [footerbutton],
              )
            ],
          );
        });
      },
    );
  }

  Widget dialogActionButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          SizedBox(
            width: screenWidth / 3.5,
            child: CommonButton(
              buttonName: "Cancel",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.saudaLETTxtColor,
              buttonColor: Constant.saudaLETbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Constant.saudaLETbuttonBorder,
              buttonFunction: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: screenWidth / 3.5,
            child: CommonButton(
              buttonName: "Save",
              buttonNameWeight: Constant.fontWeight500,
              buttonNameSize: Constant.fontSize13,
              buttonNameColor: Constant.pricbuttonTxtColor,
              buttonColor: Constant.pricbuttonColor,
              buttonHeight: 40,
              buttonRadiusTL: Constant.pricbuttonRadiusTL,
              buttonRadiusBL: Constant.pricbutRadiusBL,
              buttonBorder: Colors.transparent,
              buttonFunction: () {
                if (_commentcontroller.text.isEmpty) {
                  showSuccessDlg(context, "Remarks Should not empty", "Error");
                  return;
                }
                var request = SaudaModApprovalRequest();
                request.SaudaModificationIds = _selectedIds.toList();
                request.modifiedBy = Constants.AUTH_USERID;
                request.statusId = approvalStatusId;
                request.remarks = _commentcontroller.text.toString();
                request.loginUserId = Constants.AUTH_USERID;

                BlocProvider.of<SaudaModApprovalBloc>(ctxx).add(
                    ApproveRejectSaudaModApproval(
                        saudaModApprovalRequest: request));

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  contBody() {}

  void showSuccessDlg(BuildContext context, messageValue, title,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
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
      // title: Container(
      //   decoration: BoxDecoration(
      //     color: Constant.colorOrange,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(25.0),
      //       topRight: Radius.circular(5.0),
      //       bottomLeft: Radius.circular(0.0),
      //       bottomRight: Radius.circular(0.0),
      //     ),
      //   ),
      //   padding: const EdgeInsets.only(top: 12, bottom: 12),
      //   child: Text(title,
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         color: titleColor,
      //       )),
      // ),
      // content: Text(successText!),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
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
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(messageValue.toString(),
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

  Widget getDialogContent() {
    var ctx = context;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        children: [
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectFromDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "From Date",
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
                  controllerTxt: _fromdatecontroller,
                  enabled: false,
                )),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: InkWell(
                onTap: () {
                  _selectToDate(context);
                },
                child: CommonTextFormField(
                  labeltxt: "To Date",
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
                  controllerTxt: _todatecontroller,
                  enabled: false,
                )),
          ),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          // height: 70,
          child: CommonDropdownButtonFormField<SalesOrganization>(
            value: selectedSalesOrg,
            label: "Sales Organization",
            onChanged: (SalesOrganization? newValue) {
              if (newValue == null) return;
              setState(() {
                selectedSalesOrg = newValue;
              });
              BlocProvider.of<SaudaModApprovalBloc>(ctx)
                  .add(LoadModDistributionChannel(id: selectedSalesOrg!.id!));
            },
            items:
                salesOrgList.map<DropdownMenuItem<SalesOrganization>>((value) {
              return DropdownMenuItem<SalesOrganization>(
                value: value,
                child: Text(value.salesOrganizationName!),
              );
            }).toList(),
          )),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          //height: 70,
          child: CommonDropdownButtonFormField<DistributionChannel>(
            value: selectedDistrChannel,
            label: "Distribution Channel",
            onChanged: (DistributionChannel? newValue) {
              if (newValue == null) return;
              setState(() {
                selectedDistrChannel = newValue;
              });
              BlocProvider.of<SaudaModApprovalBloc>(ctx).add(
                  LoadModVerticalList(
                      distributionId: selectedDistrChannel!.id!));
            },
            items: distrChannels
                .map<DropdownMenuItem<DistributionChannel>>((value) {
              return DropdownMenuItem<DistributionChannel>(
                value: value,
                child: Text(value.distributionChannelName!),
              );
            }).toList(),
          )),
      const SizedBox(height: 16.0),
      SizedBox(
          width: double.infinity,
          //height: 70,
          child: CommonDropdownButtonFormField<Vertical>(
            value: selectedVertical,
            label: "Division",
            onChanged: (Vertical? newValue) {
              if (newValue == null) return;
              setState(() {
                selectedVertical = newValue;
              });
              /* BlocProvider.of<NewSaudaBloc>(
                  context).add(
                  LoadDistributionChannel(
                      id: selectedSalesOrg!
                          .id!));*/
            },
            items: verticals.map<DropdownMenuItem<Vertical>>((value) {
              return DropdownMenuItem<Vertical>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          )),
    ]);
  }

  void showCustomFilterDialog(
      BuildContext context, messageValue, title, footerbutton,
      {bool? hideCancelBtn = false,
      String? successText = 'OK',
      Color? titleColor = Colors.white}) {
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
                      constraints: const BoxConstraints(),
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
                content: Container(
                    height: 300,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: getDialogContent()),
                actions: [
                  Row(
                    children: [footerbutton],
                  )
                ],
              );
            });
      },
    );
  }

  Widget dialogActionButtonFilter() {
    var ct = context;
    return SizedBox(
      // width: screenWidth * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(width: 9),
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
                BlocProvider.of<SaudaModApprovalBloc>(ct).add(
                    LoadSaudaModApproval(
                        userId: Constants.AUTH_USERID,
                        fromDate: DateTimeUtils().dateToServerToDateFormat(
                            _fromdatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        toDate: DateTimeUtils().dateToServerToDateFormat(
                            _todatecontroller.text.toString(),
                            DateTimeUtils.DD_MM_YYYY_Format,
                            DateTimeUtils.YYYY_MM_DD_Format),
                        salesOrganizationId: selectedSalesOrg != null
                            ? selectedSalesOrg!.id!
                            : 0,
                        distributionChannelId: selectedDistrChannel != null
                            ? selectedDistrChannel!.id!
                            : 0,
                        divisionId: selectedVertical != null
                            ? selectedVertical!.id!
                            : 0,
                        statusId: 1,
                        pageNo: 0));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  selectAllSaudas() {
    selectedCount = 0;
    for (SaudaModApprovalItem dealer in approvalList!) {
      selectedCount = selectedCount + approvalList.length;
      _selectedIds.add(dealer.id!);
    }
  }

  unSelectAllSaudas() {
    selectedCount = 0;
    for (SaudaModApprovalItem dealer in approvalList!) {
      _selectedIds.remove(dealer.id!);
    }
  }
}
