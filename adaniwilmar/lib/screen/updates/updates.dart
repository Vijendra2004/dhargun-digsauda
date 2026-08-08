import 'package:adaniwilmar/models/latest_update_response.dart';
import 'package:adaniwilmar/screen/updates/bloc/bloc.dart';
import 'package:adaniwilmar/screen/updates/update_detail.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/list_of_updates.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatesBloc()
        ..add(LoadUpdatesScreen(
          userId: Constants.AUTH_USERID,
          dealerId: 0
        )),
      child: const LatestUpdate(),
    );
  }
}

class LatestUpdate extends StatefulWidget {
  const LatestUpdate({Key? key}) : super(key: key);

  @override
  State<LatestUpdate> createState() => _LatestUpdateState();
}

class _LatestUpdateState extends State<LatestUpdate>{
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  ProgressBarHandler? _handler;
  List<LatestUpdateResponse> updates = [];
  LatestUpdateResponse? update;
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
    return BlocListener<UpdatesBloc, UpdatesState>(
        listener: (context, state) {
          if (state is OnLoadSuccess) {
            updates=state.updates;
            if(updates!=null && updates.isNotEmpty){
              update=updates[0];
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
                      child: Column(
                        children: [
                          Container(height: Constant.containerTopWrapper),
                          SizedBox(
                            width: double.infinity,
                            child: CurveOuterBox(
                              boxofWidget:InkWell(
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateDetailScreen(
                                                )),
                                  );
                                },
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeadingSix(
                                    headingSix: "Latest Updates",
                                    heaingSize: Constant.headingSix,
                                    headingWeight: Constant.fontWeight600,
                                    headingColor: Constant.colorBlack,
                                  ),
                                  const SizedBox(height: 8.0),
                                  SizedBox(
                                    height: screenHeight * 0.2,
                                    width: screenWidth,
                                    child: update!=null && update!.mediaList!=null && update!.mediaList!.length>0?
                                    Image.network(
                                      update!.mediaList![0].mediaPath!+"?${DateTime.now().millisecondsSinceEpoch.toString()}",
                                      fit: BoxFit.contain,
                                    ):Constant.updateImage,
                                  ),
                                ],
                              )),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.all(8),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ListOFUpdateModel.category.length,
                                  itemBuilder: (context, index) {
                                    return Visibility(visible:index>1,child: InkWell(
                                      onTap: () {
                                        // var link;
                                        if (0 == index) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                 CustomerLedger(selectedCustomerLedgerId: Constants.AUTH_DEALER_CODE,)),
                                          );
                                        } else if (1 == index) {
                                        } else if (2 == index) {
                                        } else if (3 == index) {}
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        height: 67.0,
                                        // padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(5.0),
                                            bottomLeft: Radius.circular(5.0),
                                            bottomRight: Radius.circular(25.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x18000000),
                                              offset: Offset(
                                                2.0,
                                                1.0,
                                              ),
                                              blurRadius: 3.0,
                                              spreadRadius: 2.0,
                                            ),
                                            //BoxShadow
                                          ],
                                        ),
                                        child: ListTile(
                                          dense: true,
                                          contentPadding:
                                          EdgeInsets.only(top: 8, left: 16, right: 16),
                                          title: Row(
                                            children: [
                                              SizedBox(
                                                  height: 20,
                                                  width: screenWidth * 0.60,
                                                  child: Text(
                                                      ListOFUpdateModel
                                                          .category[index].name,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: Constant.fontSize16,
                                                      ))),
                                              ListOFUpdateModel.category[index].round ==
                                                  true
                                                  ? Container(
                                                  width: 24.0,
                                                  height: 24.0,
                                                  decoration: BoxDecoration(
                                                    color: Constant.colorRed,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text("1",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                            color:
                                                            Constant.colorWhite,
                                                            fontSize: Constant
                                                                .fontSize12)),
                                                  ))
                                                  : Container(),
                                            ],
                                          ),
                                          trailing: Constant.rightArow,
                                        ), //BoxDecoration
                                      ),
                                    ));
                                  }))
                        ],
                      )),
                  progressBar
                ],
              ),
            )));
  }
}
