import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/screen/new_special_rate/new_special_rate.dart';
import 'package:adaniwilmar/screen/special_rate_approval/bloc/bloc.dart';
import 'package:adaniwilmar/widget/special_rate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../utils/constant.dart';
import '../../widget/ModalRoundedProgressBar.dart';
import '../../widget/widget.dart';

class SpecialRateApprovalScreen extends StatelessWidget {
  DistributorList? distributor;

  SpecialRateApprovalScreen({this.distributor, Key? key}) : super(key: key);
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(settings: const RouteSettings(name: routeName), builder: (_) => const SpecialRateApprovalDetail());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialRateApprovalBloc()..add(LoadSpecialRateApprovalScreen(userId: Constants.AUTH_USERID, dealerId: (distributor != null ? distributor!.id! : 0))),
      child: const SpecialRateApprovalDetail(),
    );
  }
}

class SpecialRateApprovalDetail extends StatefulWidget {
  const SpecialRateApprovalDetail({Key? key}) : super(key: key);

  @override
  State<SpecialRateApprovalDetail> createState() => _SpecialRateApprovalState();
}

class _SpecialRateApprovalState extends State<SpecialRateApprovalDetail> {
  List<SpecialRateResponse> specialRate = [];
  List<SpecialRateList> dealerSpecialRates = [];
  ProgressBarHandler? _handler;
  double screenHeight = 0;
  double screenWidth = 0;

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
    return BlocListener<SpecialRateApprovalBloc, SpecialRateApprovalState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            specialRate = state.sprateInfo;
            setState(() {});
          }
          if (state is OnLoadDealerSuccess) {
            dealerSpecialRates = state.sprateInfo;
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
                appBar: const CustomAppBar(title: "Special Rate Approval", backArrow: true),
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
                        margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                        child: specialRate == null || specialRate.length == 0
                            ? const Align(alignment: Alignment.center, child: CurveOuterBox(boxTBPadding: 30, boxofWidget: Text("No records found")))
                            : CurveBorderBox(
                                boxLRPadding: 8,
                                boxTOPPadding: 0,
                                boxBOTPadding: 0,
                                boxHeight: screenHeight,
                                boxofWidget: SingleChildScrollView(
                                    child: SpecialRateWidget(
                                        headFontSz: Constant.fontSize16,
                                        headFontCol: Constant.colorBlack,
                                        headFontWei: Constant.fontWeight600,
                                        subFontSz: Constant.fontSize13,
                                        subFontCol: Constant.colorLightGray,
                                        specialRates: specialRate,
                                        dealerSpecialRates: dealerSpecialRates,
                                        sbIcon: Constant.sCIcon1,
                                        sbIconColor: Constant.colorOrange,
                                        sbIconSize: Constant.fontSize14)))),
                    progressBar
                  ],
                ),
                floatingActionButton: Visibility(
                  visible: Constants.AUTH_ROLEID != Constants.DEALER,
                  child: FloatingButton(
                      buttonBgColor: Constant.colorRed,
                      buttonIcon: Constant.saudaIcPlus,
                      navigationFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewSpecialRateScreen()),
                        );
                      },
                      buttoniconSize: 20),
                ))));
  }
}
