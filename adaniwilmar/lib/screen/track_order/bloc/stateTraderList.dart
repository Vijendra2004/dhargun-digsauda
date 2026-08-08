import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/screen/state_trader_filter/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/common_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/constant.dart';

class NationalFilterListWidget extends StatelessWidget {
  BdoList? selectedBDO;
  Function? resultFunction;
  Function? onLoad;
  bool? showAll;
  bool? selectDefault;
  NationalFilterListWidget(
      {this.selectedBDO,
        this.resultFunction,
        this.onLoad,this.showAll=true,this.selectDefault=false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StateTraderFilterBloc(),
      child: StateTraderFilter(
          selectedBDO: selectedBDO,
          resultFunction: resultFunction,
          onLoad: onLoad,
          showAll: showAll,
          selectDefault:selectDefault
      ),
    );
  }

  BdoList? getSelectedBdo() {
    return selectedBDO;
  }
}

class StateTraderFilter extends StatefulWidget {
  BdoList? selectedBDO;
  Function? resultFunction;
  Function? onLoad;
  bool? showAll;
  bool? selectDefault;
  StateTraderFilter({
    this.selectedBDO,
    this.resultFunction,
    this.onLoad,
    this.showAll=true,
    this.selectDefault=false,
    Key? key,
  }) : super(key: key);
  @override
  State<StateTraderFilter> createState() => StateTraderFilterWidgetState();
}

// Widget nationalFilterListWidget(){
//   return
// }


class StateTraderFilterWidgetState extends State<StateTraderFilter> {

  GlobalKey<FormState> nationalKey = GlobalKey<FormState>();
  List<BdoList> bdoList = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  String? labelTxt = "";
  String txtLabe = "";
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;
  @override
  void initState() {
    // TODO: implement initState
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      BlocProvider.of<StateTraderFilterBloc>(context)
          .add(LoadZonalHead(userId: Constants.AUTH_USERID,showAll: widget.showAll!));
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      BlocProvider.of<StateTraderFilterBloc>(context)
          .add(LoadBDO(userId: Constants.AUTH_USERID,showAll: widget.showAll!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Constants.AUTH_ROLEID == Constants.ZHMANAGER ||
        Constants.AUTH_ROLEID == Constants.NHMANAGER
        ?
    StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 70,
              child: CommonDropdownButtonFormField<BdoList>(
                isExpanded: true,
                value: widget.selectedBDO,
                icon: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 24,
                    )),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 0.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusTLBR),
                            topRight: Radius.circular(borderRadiusTRBL),
                            bottomLeft: Radius.circular(borderRadiusTRBL),
                            bottomRight:
                            Radius.circular(borderRadiusTLBR)),
                        borderSide:
                        BorderSide(color: borderColor!, width: 1.5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusTLBR),
                            topRight: Radius.circular(borderRadiusTRBL),
                            bottomLeft: Radius.circular(borderRadiusTRBL),
                            bottomRight:
                            Radius.circular(borderRadiusTLBR)),
                        borderSide:
                        BorderSide(color: borderColor!, width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadiusTLBR),
                            topRight: Radius.circular(borderRadiusTRBL),
                            bottomLeft: Radius.circular(borderRadiusTRBL),
                            bottomRight:
                            Radius.circular(borderRadiusTLBR)),
                        borderSide:
                        BorderSide(color: borderColor!, width: 1.0)),
                    filled: true,
                    // hintStyle: TextStyle(color: Colors.grey[800]),
                    labelText: labelTxt,
                    labelStyle: TextStyle(
                        color: labelTxtCol, fontSize: labelTxtSize),
                    fillColor: fillColor),
                onChanged: (BdoList? newValue) {
                  setState(() {
                    widget.selectedBDO = newValue!;
                  });
                  if (widget.resultFunction != null) {
                    widget.resultFunction!(newValue);
                  }
                },
                items: bdoList.map<DropdownMenuItem<BdoList>>((value) {
                  return DropdownMenuItem<BdoList>(
                    value: value,
                    child:
                    Text(value.name!, overflow: TextOverflow.visible),
                  );
                }).toList(),
              ));
        })
        : const Visibility(visible: false, child: Text("Not Required"));
  }
}
