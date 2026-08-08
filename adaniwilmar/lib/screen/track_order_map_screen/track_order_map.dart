import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/curve_outer_box.dart';
import '../../widget/curved_border_box.dart';
import '../../widget/custom_appbar.dart';

class TrackOrderMapScreen extends StatefulWidget {
  final String? trackingLink;
  const TrackOrderMapScreen({Key? key, required this.trackingLink}) : super(key: key);

  @override
  State<TrackOrderMapScreen> createState() => _TrackOrderMapScreenState();
}

class _TrackOrderMapScreenState extends State<TrackOrderMapScreen> {
  ProgressBarHandler? _handler;

  var progressBar = ModalRoundedProgressBar(
    handleCallback: (handler) {
      //_handler = handler;
      return () {};
    },
  );

  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int selected = 0 - 1;
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  final GlobalKey _dialogKey = GlobalKey();
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  String trackingLink = "";

  @override
  void initState() {
    trackingLink=  widget.trackingLink??"";
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Track Order - Map",
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
                margin:  EdgeInsets.only(top: 60, right: 10, left: 10),
                height: screenHeight * 0.980,
                width: screenWidth,
                child:  CurveBorderBox(
                  boxLRPadding: 12,
                  boxTOPPadding: 12,
                  boxBOTPadding: 0,
              boxofWidget: Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: CurveOuterBox(
                    boxLRPadding: 0,
                    boxTBPadding: 0,
                    boxofWidget: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(trackingLink)),
                    ),
                  ),
              ),
                ),
              ),
              progressBar
            ],
          ),
        ));
  }








}
