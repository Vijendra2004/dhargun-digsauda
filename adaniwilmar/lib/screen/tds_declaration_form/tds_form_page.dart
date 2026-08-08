import 'package:adaniwilmar/screen/tdsDeclaration/tds_declaration_screen.dart';
import 'package:adaniwilmar/screen/tds_declaration_form/bloc/bloc.dart';
import 'package:adaniwilmar/screen/tds_declaration_form/bloc/tds_form_page_event.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/TdsFormModel.dart';
import '../../utils/constant.dart';
import '../../widget/widget.dart';

class TdsFormScreen extends StatelessWidget {
  const TdsFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TdsFormPageBloc()..add(const TdsFormApiEvent()),
      child: const TdsFormPageData(),
    );
  }
}

class TdsFormPageData extends StatefulWidget {
  const TdsFormPageData({Key? key}) : super(key: key);

  @override
  State<TdsFormPageData> createState() => _TdsFormPageState();
}

class _TdsFormPageState extends State<TdsFormPageData> {
  int selected = 0 - 1;
  ProgressBarHandler? _handler;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<TdsFormResponse> tdsFormsList = [];

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
    return BlocListener<TdsFormPageBloc, TdsFormPageState>(
        listener: (context, state) {
          if (state is DisableTdsFormProgressBar) {
            _handler!.dismiss!();
          }
          if (state is LoadTdsFormProgressBar) {
            _handler!.show!();
          }
          if (state is OnTdsFormPageSuccess) {
            if(state.response.isNotEmpty){
              GMLogger.v("response${state.response[0].formName}");
              tdsFormsList = state.response;
              setState(() {});
            }
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Dynamic Forms",
            backArrow: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                Container(
                  height: screenHeight,
                  margin: const EdgeInsets.only(top: 64),
                  child: CurveOuterBox(
                      boxLRPadding: 0,
                      boxTBPadding: 0,
                      boxofWidget: SizedBox(
                        width: screenWidth,
                        height: screenHeight,
                        child: tdsFormsList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
                                itemCount: tdsFormsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () async {
                                      Constants.formId =
                                          tdsFormsList[index].formId;
                                      Constants.formName =
                                          tdsFormsList[index].formName!;
                                      Constants.isSubmitted = tdsFormsList[index].isSubmittedForms!;
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TDSDeclarationScreen(
                                                  argument: Constants.formId),
                                        ),
                                      );

                                      if (result != null) {
                                        BlocProvider.of<TdsFormPageBloc>(
                                                context)
                                            .add(const TdsFormApiEvent());
                                      }
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: Column(children: [
                                        Visibility(
                                          visible: tdsFormsList[index]
                                                      .isSubmittedForms !=
                                                  null &&
                                              tdsFormsList[index]
                                                      .isSubmittedForms ==
                                                  true,
                                          child: const Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5, right: 5),
                                              child: Text("Submitted",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontFamily: 'Aganè',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 12)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      '${tdsFormsList[index].formName}')),
                                              Icon(Icons.arrow_forward)
                                            ],
                                          ),
                                        )
                                      ]),
                                    ),
                                  );
                                })
                            : const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                      )),
                ),
                progressBar
              ],
            ),
          ),
        ));
  }
}
