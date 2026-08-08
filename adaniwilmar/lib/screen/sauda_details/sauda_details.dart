import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/network/GMCore.dart';
import 'package:adaniwilmar/models/customer_audio_file.dart';
import 'package:adaniwilmar/models/dealer_visit_request.dart';
import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/screen/sauda_details/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:adaniwilmar/utils/url_utils.dart';
import 'package:adaniwilmar/widget/multiselect/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SaudaDetailScreen extends StatelessWidget {
  int saudaId = 0;

  SaudaDetailScreen({required this.saudaId, Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SaudaDetailScreen(
              saudaId: 0,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaDetailBloc()..add(LoadSaudaDetailScreen(userId: Constants.AUTH_USERID, saudaId: saudaId)),
      child: const SaudaDetail(),
    );
  }
}

class SaudaDetail extends StatefulWidget {
  const SaudaDetail({Key? key}) : super(key: key);

  @override
  State<SaudaDetail> createState() => _SaudaDetailState();
}

class _SaudaDetailState extends State<SaudaDetail> {
  SaudaDetailResponse saudaDetailResponse = SaudaDetailResponse();
  double totalPrice = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  ProgressBarHandler? _handler;
  List<FileList> fileList = [];
  List<CustomerAudioFile> audioFiles = [];
  List<CustomerAudioFile> selectedAudioFiles = [];
  final ImagePicker _picker = ImagePicker();

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
    return BlocListener<SaudaDetailBloc, SaudaDetailState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            saudaDetailResponse = state.saudaDetailResponse;
            for (SaudaOrderDetail d in saudaDetailResponse.saudaOrders!) {
              totalPrice = totalPrice + d.bidPrice!;
            }
            BlocProvider.of<SaudaDetailBloc>(context).add(LoadCustomerAudioList(dealerId: saudaDetailResponse.dealerId!, brokerId: saudaDetailResponse.brokerId!));
            setState(() {});
          }
          if (state is OnLoadCustomerAudio) {
            audioFiles = state.audioResponse;
            if (saudaDetailResponse.audiofileDetailIds != null) {
              for (int audioId in saudaDetailResponse.audiofileDetailIds!) {
                if (audioFiles.where((element) => element.audioFileDetailId == audioId) != null) {
                  selectedAudioFiles.add(audioFiles.where((element) => element.audioFileDetailId == audioId).first);
                }
              }
            }
          }
          if (state is OnSaveSuccess) {
            showSuccessDlg(context, "Sauda Detail", "Sauda Detail", successText: state.response);
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
            title: "Sauda Detail -" + (saudaDetailResponse.saudaNumber ?? ""),
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
              Container(
                  height: screenHeight * 0.980,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: SingleChildScrollView(
                      child: CurveBorderBox(
                    boxLRPadding: 0,
                    boxTOPPadding: 0,
                    boxofWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurveBorderBox(
                            boxBgColor: const Color(0xFFFFFBF7),
                            boxShadowColor: const Color(0xFFFFFFFF),
                            boxofWidget: Container(
                              margin: EdgeInsets.only(top: 14, left: 8, right: 8),
                              width: MediaQuery.of(context).size.width,
                              height: screenHeight * 0.08,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonText(
                                              name: "Distributor Name",
                                              fontSize: Constant.fontSize13,
                                              fontColor: Constant.colorDullGray77,
                                            ),
                                            CommonText(
                                              name: saudaDetailResponse.dealerName ?? "",
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight: Constant.fontWeight600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: CommonLabel(
                                            bgColor: saudaDetailResponse.statusId != null
                                                ? (saudaDetailResponse.statusId == 1
                                                    ? Constant.statusPendingColor
                                                    : saudaDetailResponse.statusId == 2
                                                        ? Constant.statusCompletedColor
                                                        : Constant.statusRejectedColor)
                                                : Constant.statusPendingColor,
                                            name: saudaDetailResponse.status ?? "",
                                            fontSize: Constant.fontSize11,
                                            fontColor: Constant.colorWhite,
                                            imageic: Constant.checkIc,
                                            imagetrue: true,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 8),
                        Container(padding: const EdgeInsets.all(10),child: const Text("Displays the original quantity. The updated quantity will appear after approval", style: TextStyle(color: Colors.red, fontSize: 12),)),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(name: "Bidding Request Date", fontSize: Constant.fontSize12, fontColor: Constant.colorDullGray77),
                              const SizedBox(height: 4),
                              CommonText(
                                  name: saudaDetailResponse.biddingDate != null
                                      ? DateTimeUtils().dateToServerToDateFormat(saudaDetailResponse.biddingDate!, DateTimeUtils.YYYY_MM_DD_Format, DateTimeUtils.DD_MM_YYYY_Format)
                                      : "",
                                  fontSize: Constant.fontSize12,
                                  fontColor: Constant.colorBlack,
                                  fontWeight: Constant.fontWeight500),
                              const SizedBox(height: 16),
                              CommonText(name: "Price Details", fontSize: Constant.fontSize12, fontColor: Constant.colorBlack, fontWeight: Constant.fontWeight600),
                              const SizedBox(height: 8),
                              Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 9, bottom: 9),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                        color: const Color(0xFFffffff),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(0),
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: saudaDetailResponse.saudaOrders != null ? saudaDetailResponse.saudaOrders!.length : 0,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                const SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                        child: CommonText(
                                                                      name: saudaDetailResponse.saudaOrders![index].skuName,
                                                                      fontColor: Constant.colorBlack,
                                                                      fontSize: Constant.fontSize10,
                                                                      fontWeight: Constant.fontWeight600,
                                                                    )),
                                                                    const SizedBox(width: 6),
                                                                    Expanded(
                                                                        child: CommonText(
                                                                      name: "(" + saudaDetailResponse.saudaOrders![index].bidQuantity.toString() + " MT)",
                                                                      fontColor: Constant.colorRed,
                                                                      fontSize: Constant.fontSize12,
                                                                      fontWeight: Constant.fontWeight600,
                                                                    )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                              alignment: Alignment.centerRight,
                                                              child: CommonText(
                                                                name: saudaDetailResponse.saudaOrders![index].bidQuantityCases.toString() + " ",
                                                                fontSize: Constant.fontSize11,
                                                                fontColor: Constant.colorOrange,
                                                                fontWeight: Constant.fontWeight500,
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  CommonText(
                                                                    name: saudaDetailResponse.saudaOrders![index].plantDepot ?? "",
                                                                    fontSize: Constant.fontSize11,
                                                                    fontColor: Constant.colorBlack,
                                                                    fontWeight: Constant.fontWeight500,
                                                                  ),
                                                                  CommonText(
                                                                    name: "Rs." + saudaDetailResponse.saudaOrders![index].bidPricePerCase!.toStringAsFixed(2) + " ",
                                                                    fontSize: Constant.fontSize10,
                                                                    fontColor: Constant.colorDullGray77,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: CommonText(
                                                                name: "Rs." + (saudaDetailResponse.saudaOrders![index].bidPrice!).toStringAsFixed(2),
                                                                fontSize: Constant.fontSize15,
                                                                fontColor: Constant.colorBlack,
                                                                fontWeight: Constant.fontWeight600,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                      top: BorderSide(
                                                        color: Color(0xFFD5D5D5),
                                                        width: 0.8,
                                                      ),
                                                    )),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(child: Container()),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Row(
                                                  children: [
                                                    CommonText(
                                                      name: "Basic Value",
                                                      fontSize: Constant.fontSize11,
                                                      fontColor: Constant.colorDullGray77,
                                                      fontWeight: Constant.fontWeight500,
                                                    ),
                                                    const SizedBox(width: 24),
                                                    CommonText(
                                                      name: "Rs. " + totalPrice.toStringAsFixed(2),
                                                      fontSize: Constant.fontSize15,
                                                      fontColor: Constant.colorGreencc,
                                                      fontWeight: Constant.fontWeight600,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 12)
                                ],
                              ),
                              Visibility(
                                  visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "",
                                  child: CommonText(
                                    name: "Remarks",
                                    fontSize: Constant.fontSize12,
                                    fontColor: Constant.colorBlack,
                                    fontWeight: Constant.fontWeight600,
                                  )),
                              Visibility(visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "", child: const SizedBox(height: 16)),
                              Visibility(
                                visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "",
                                child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   border: Border.all(
                                    //       width: 1.0,
                                    //       color: const Color(0xFFDEDEDE)),
                                    //   borderRadius: const BorderRadius.all(
                                    //       Radius.circular(8)),
                                    // ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonText(
                                          name: saudaDetailResponse.remarks ?? "",
                                          fontSize: Constant.fontSize14,
                                          fontColor: Constant.colorBlack,
                                        ),
                                      ],
                                    )),
                              ),
                              Visibility(visible: saudaDetailResponse.remarks != null && saudaDetailResponse.remarks != "", child: const SizedBox(height: 16)),
                              Visibility(
                                  visible: (Constants.AUTH_ROLEID == Constants.SALE || Constants.AUTH_ROLEID == Constants.DEALER || Constants.AUTH_ROLEID == Constants.ZHMANAGER),
                                  child: Column(children: [
                                    CommonText(
                                      name: "Attach Call Recordings",
                                      fontSize: Constant.fontSize12,
                                      fontColor: Constant.colorBlack,
                                      fontWeight: Constant.fontWeight600,
                                    ),
                                    const SizedBox(height: 16),
                                    InkWell(
                                        onTap: () {
                                          _showMultiSelectAudio(context);
                                        },
                                        child: Container(
                                          height: 100,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFBFBFB),
                                            border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          ),
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Constant.cameraIc,
                                              ),
                                              CommonText(
                                                name: "Click here to upload audio recording",
                                                fontSize: Constant.fontSize11,
                                                fontColor: Constant.colorBlack,
                                                fontWeight: Constant.fontWeight500,
                                              ),
                                            ],
                                          )),
                                        )),
                                    const SizedBox(height: 16),
                                    ListView.builder(
                                      key: Key('builderaudiofile'),
                                      //attention
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int idx) {
                                        return Column(children: [
                                          Row(children: [
                                            Expanded(
                                                child: CommonText(
                                              name: selectedAudioFiles[idx].callRecordedFileName!,
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight: Constant.fontWeight600,
                                            )),
                                            InkWell(
                                                onTap: () {
                                                  selectedAudioFiles.removeAt(idx);
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: SizedBox(width: 25, height: 25, child: Icon(Icons.delete, color: Constant.colorGray45)),
                                                    )))
                                          ]),
                                          BorderBottom()
                                        ]);
                                      },
                                      itemCount: selectedAudioFiles.length,
                                    ),
                                    const SizedBox(height: 16),
                                    InkWell(
                                        onTap: () async {
                                          XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            FileList f = FileList();
                                            f.filePath = pickedFile.path;
                                            f.fileName = pickedFile.name;
                                            f.id = 1;
                                            f.fileExtention = pickedFile.name.substring(pickedFile.name.lastIndexOf(".") + 1);
                                            GMAPIService service = GMAPIService();
                                            Meta metaImage = await service.imageUpload(URLUtils().getSaudaImageUploadUrl(), pickedFile.path, Constants.AUTH_TOKEN);
                                            GMLogger.v(metaImage.statusMsg);
                                            if (metaImage.statusCode == 200) {
                                              f.fileName = jsonDecode(metaImage.statusMsg)["response"];
                                              fileList.add(f);
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          height: 100,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFBFBFB),
                                            border: Border.all(width: 1.0, color: const Color(0xFFDEDEDE)),
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          ),
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Constant.headphoneIc,
                                              ),
                                              CommonText(
                                                name: "Click here to upload image",
                                                fontSize: Constant.fontSize11,
                                                fontColor: Constant.colorBlack,
                                                fontWeight: Constant.fontWeight500,
                                              ),
                                            ],
                                          )),
                                        )),
                                    const SizedBox(height: 16),
                                    Visibility(
                                        visible: fileList != null && fileList.length > 0,
                                        child: CommonText(
                                          name: "Selected Images",
                                          fontSize: Constant.fontSize11,
                                          fontColor: Constant.colorBlack,
                                          fontWeight: Constant.fontWeight500,
                                        )),
                                    const SizedBox(height: 16),
                                    ListView.builder(
                                      key: Key('builderimagefiles'),
                                      //attention
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int idx) {
                                        return Column(children: [
                                          Row(children: [
                                            Expanded(
                                                child: CommonText(
                                              name: fileList[idx].fileName!,
                                              fontSize: Constant.fontSize12,
                                              fontColor: Constant.colorBlack,
                                              fontWeight: Constant.fontWeight600,
                                            )),
                                            InkWell(
                                                onTap: () {
                                                  fileList.removeAt(idx);
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: SizedBox(width: 25, height: 25, child: Icon(Icons.delete, color: Constant.colorGray45)),
                                                    )))
                                          ]),
                                          SizedBox(height: 200, width: 200, child: Image.file(File(fileList[idx].filePath!))),
                                          BorderBottom()
                                        ]);
                                      },
                                      itemCount: fileList.length,
                                    ),
                                    const SizedBox(height: 16),
                                    Visibility(
                                        visible: saudaDetailResponse.imagePaths != null && saudaDetailResponse.imagePaths!.length > 0,
                                        child: CommonText(
                                          name: "Saved Images",
                                          fontSize: Constant.fontSize11,
                                          fontColor: Constant.colorBlack,
                                          fontWeight: Constant.fontWeight500,
                                        )),
                                    const SizedBox(height: 16),
                                    ListView.builder(
                                      key: Key('builderfile'),
                                      //attention
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int idx) {
                                        return Stack(children: [SizedBox(height: 200, width: 200, child: Image.network(saudaDetailResponse.imagePaths![idx]))]);
                                      },
                                      itemCount: saudaDetailResponse.imagePaths != null ? saudaDetailResponse.imagePaths!.length : 0,
                                    )
                                  ]))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
              progressBar
            ],
          ),
          bottomNavigationBar: Visibility(
              visible: (Constants.AUTH_ROLEID == Constants.SALE || Constants.AUTH_ROLEID == Constants.ZHMANAGER),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CommonButton(
                  buttonName: "Save",
                  buttonNameSize: Constant.fontSize13,
                  buttonNameColor: Constant.pricbuttonTxtColor,
                  buttonColor: Constant.pricbuttonColor,
                  buttonHeight: Constant.pricbuttonHeight,
                  buttonRadiusTL: Constant.pricbuttonRadiusTL,
                  buttonRadiusBL: Constant.pricbutRadiusBL,
                  buttonNameWeight: Constant.fontWeight600,
                  buttonBorder: Colors.transparent,
                  buttonFunction: () {
                    SaveAudioRequest request = SaveAudioRequest();
                    request.dealerId = saudaDetailResponse.dealerId;
                    request.saudaId = saudaDetailResponse.saudaId!;
                    request.loginUserId = Constants.AUTH_USERID;
                    request.audioFileDetailIds = [];
                    for (CustomerAudioFile c in selectedAudioFiles) {
                      AudioFileDetailIds ids = AudioFileDetailIds();
                      ids.audioFileDetailId = c.audioFileDetailId;
                      ids.userId = c.dealerId;
                      request.audioFileDetailIds!.add(ids);
                    }
                    request.imagePaths = [];
                    for (FileList img in fileList) {
                      request.imagePaths!.add(img.fileName!);
                    }
                    BlocProvider.of<SaudaDetailBloc>(context).add(SaveAudioList(request: request));
                  },
                ),
              )),
        )));
  }

  void _showMultiSelectAudio(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<CustomerAudioFile>(
          searchable: true,
          width: MediaQuery.of(context).size.width * 0.98,
          itemsTextStyle: TextStyle(fontFamily: 'Aganè', fontSize: Constant.fontSize14, color: Constant.colorBlack),
          selectedItemsTextStyle: TextStyle(fontFamily: 'Aganè', fontSize: Constant.fontSize14, color: Constant.colorBlack, fontWeight: Constant.fontWeight600),
          items: audioFiles.map((dist) => MultiSelectItem<CustomerAudioFile>(dist, dist.callRecordedFileName!)).toList(),
          initialValue: selectedAudioFiles,
          onConfirm: (List<CustomerAudioFile> values) {
            selectedAudioFiles = values;
            setState(() {});
          },
        );
      },
    );
  }

  void showSuccessDlg(BuildContext context, messageValue, title, {bool? hideCancelBtn = false, String? successText = 'OK', Color? titleColor = Colors.white, bool? closeScreen = false}) {
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
                    child: title == "Error" ? Icon(Icons.error_outlined, size: 70, color: Colors.red) : Icon(Icons.check_circle_sharp, size: 70, color: Colors.green),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(title, style: TextStyle(fontSize: Constant.fontSize20, fontWeight: Constant.fontWeight600)),
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
                buttonName: "Done",
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
                  fileList = [];
                  BlocProvider.of<SaudaDetailBloc>(context).add(LoadSaudaDetailScreen(userId: Constants.AUTH_USERID, saudaId: saudaDetailResponse.saudaId!));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SaudaScreen()),
                  // );
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
