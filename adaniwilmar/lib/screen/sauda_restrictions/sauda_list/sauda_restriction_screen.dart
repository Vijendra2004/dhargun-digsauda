import 'package:adaniwilmar/screen/sauda_details/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda_restrictions/sauda_list/bloc/bloc.dart';
import 'package:adaniwilmar/screen/sauda_restrictions/sauda_restiction_add/sauda_add_restriction.dart';
import 'package:adaniwilmar/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constant.dart';
import '../../../models/SaudaRestrictionListModel.dart';
import '../../../widget/ModalRoundedProgressBar.dart';
import '../../../widget/curved_border_box.dart';
import '../../../widget/custom_appbar.dart';
import '../../../widget/floating_button.dart';
import 'bloc/sauda_restriction_list_screen_event.dart';

class SaudaRestrictionScreen extends StatefulWidget {
  const SaudaRestrictionScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SaudaRestrictionScreen());
  }

  @override
  State<SaudaRestrictionScreen> createState() => _SaudaRestrictionScreenState();
}

class _SaudaRestrictionScreenState extends State<SaudaRestrictionScreen> {
  int saudaId = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaRestrictionListScreenBloc()..add(LoadRestrictionList()),
      child: const SaudaRestrictionListScreen(),
    );
  }
}

class SaudaRestrictionListScreen extends StatefulWidget {
  const SaudaRestrictionListScreen({Key? key}) : super(key: key);

  @override
  State<SaudaRestrictionListScreen> createState() =>
      _SaudaRestrictionListScreenState();
}

class _SaudaRestrictionListScreenState
    extends State<SaudaRestrictionListScreen> {
  double totalPrice = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  ProgressBarHandler? _handler;
  List<SaudaItem>? restrictionList = [];

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
    return BlocListener<SaudaRestrictionListScreenBloc,
            SaudaRestrictionListScreenState>(
        listener: (context, state) {
          if (state is OnResSuccess) {
            restrictionList = state.restrictionList;
            setState(() {});
          }
          if (state is OnFailure) {
            //showSuccessDlg(context, "Error", "Error", successText: state.error);
          }
          if (state is ShowRestrictionProgressBar) {
            _handler!.show!();
          }
          if (state is HideRestrictionProgressBar) {
            _handler!.dismiss!();
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
            title: "Sauda Restriction List",
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
              SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CurveBorderBox(
                          boxBgColor: const Color(0xFFFFFBF5),
                          boxShadowColor: const Color(0xFFFFFFFF),
                          boxofWidget: Container(
                            margin: const EdgeInsets.all(5.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: restrictionList?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) =>  SaudaAddRestrictionScreen(saudaItem : restrictionList![index])),
                                    );
                                    if(result == true){
                                      BlocProvider.of<SaudaRestrictionListScreenBloc>(context)
                                          .add(LoadRestrictionList());
                                    }
                                  },
                                  child: Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child:  Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(restrictionList![index].id.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Text("Active: ",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  Icon(
                                                    restrictionList![index].isActive==true
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color:restrictionList![index].isActive==true
                                                ? Colors.green
                                                : Colors.red,
                                            size: 20,
                                          )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(restrictionList![index].startDate.toString().replaceAll("T", " "),
                                                  style: const TextStyle(fontSize: 14)),
                                              const Spacer(),
                                              Text(restrictionList![index].roleName!!,
                                                  style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              )),
              progressBar
            ],
          ),
          floatingActionButton: FloatingButton(
              buttonBgColor: Constant.colorRed,
              buttonIcon: Constant.saudaIcPlus,
              navigationFunction: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  SaudaAddRestrictionScreen()),
                );
                if(result == true){
                  BlocProvider.of<SaudaRestrictionListScreenBloc>(context)
                      .add(LoadRestrictionList());
                }
              },
              buttoniconSize: 20),
        ));
  }
}
