import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/models/latest_update_response.dart';
import 'package:adaniwilmar/screen/updates/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/constant.dart';
import '../../widget/widget.dart';

class UpdateDetailScreen extends StatelessWidget {
  const UpdateDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      UpdatesBloc()
        ..add(LoadUpdatesScreen(userId: Constants.AUTH_USERID, dealerId: 0)),
      child: const LatestUpdateDetail(),
    );
  }
}

class LatestUpdateDetail extends StatefulWidget {
  const LatestUpdateDetail({Key? key}) : super(key: key);

  @override
  State<LatestUpdateDetail> createState() => _LatestUpdateDetailState();
}

class _LatestUpdateDetailState extends State<LatestUpdateDetail> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  List<LatestUpdateResponse> updates = [];
  LatestUpdateResponse? update;
  WebViewController? _con;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height - MediaQuery
        .of(context)
        .padding
        .top - Constant.appBarHeight;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );
    return BlocListener<UpdatesBloc, UpdatesState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            updates = state.updates;
            if (updates != null && updates.isNotEmpty) {
              update = updates[0];
            }
            setState(() {});
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
              appBar: const CustomAppBar(title: "Updates", backArrow: true),
              body: Stack(
                // overflow: Overflow.visible,
                children: [
                  Positioned(
                    child: Container(
                      child: Constant.bgImgGlobal,
                    ),
                  ),
                  SingleChildScrollView(
                      child: update != null
                          ? Column(
                        children: [
                          Container(height: Constant.containerTopWrapper),
                          SizedBox(
                            width: double.infinity,
                            child: CurveOuterBox(
                              boxofWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: HeadingSix(
                                        headingSix: update!.title!,
                                        heaingSize: Constant.fontSize20,
                                        headingWeight: Constant.fontWeight600,
                                        headingColor: Constant.colorBlack,
                                      )),
                                  const SizedBox(height: 8.0),
                                  SizedBox(
                                    height: screenHeight * 0.2,
                                    width: screenWidth,
                                    child: update != null &&
                                        update!.mediaList != null &&
                                        update!.mediaList!.length > 0
                                        ? Image.network(
                                      update!.mediaList![0].mediaPath! +
                                          "?${DateTime
                                              .now()
                                              .millisecondsSinceEpoch
                                              .toString()}",
                                      fit: BoxFit.contain,
                                    )
                                        : Constant.updateImage,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.60,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.98,
                                      margin: const EdgeInsets.all(8),
                                      child: Column(children: [
                                        Expanded(
                                            child: getHtml(update!.content!))
                                      ]))
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                          : Text("")),
                  progressBar
                ],
              ),
            )));
  }

  Widget getHtml(String description) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            GMLogger.v("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            GMLogger.v('Page started loading: $url');
          },
          onPageFinished: (String url) {
            GMLogger.v('Page finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              GMLogger.v('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            GMLogger.v('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );

    controller.loadHtmlString(
      "<html><body><div style='font-size:60px'>"
          "${HtmlUnescape().convert(description)}"
          "</div></body></html>",
    );

    return WebViewWidget(
      controller: controller,
    );
  }
}
