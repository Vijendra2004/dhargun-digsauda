import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/screen/state_trader_filter/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/common_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';

class StateTraderFilterWidget extends StatelessWidget {
  BdoList? selectedBDO;
  Function? resultFunction;
  Function? onLoad;
  bool? showAll;
  bool? selectDefault;
  StateTraderFilterWidget(
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

class StateTraderFilterWidgetState extends State<StateTraderFilter> {
  List<BdoList> bdoList = [];
  double borderRadiusTLBR = 10.0;
  double borderRadiusTRBL = 5.0;
  Color? borderColor = Constant.pricDisBocolor;
  Color? fillColor = Constant.pricFIledCOl;
  Color? labelTxtCol = Constant.pricTxtCOl;
  double? labelTxtSize = Constant.pricTxtCOlSize;

  String? labelTxt = "";
  String txtLabe = "";
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
    return BlocListener<StateTraderFilterBloc, StateTraderFilterState>(
        listener: (context, state) {
          if (state is OnLoadBDO) {
            widget.selectedBDO = null;
            bdoList = state.bdoList;
            if (bdoList.isNotEmpty) {
              if(widget.selectDefault! && widget.showAll!){
                if(bdoList.length>1) {
                  widget.selectedBDO = bdoList[1];
                }else{
                  widget.selectedBDO = bdoList[0];
                }
              }else {
                widget.selectedBDO = bdoList[0];
              }
              if (widget.onLoad != null) {
                widget.onLoad!(widget.selectedBDO);
              }
            }
            setState(() {});
          }
          if (state is OnLoadZonalHead) {
            widget.selectedBDO = null;
            bdoList = state.zonalHeadList;
            if (bdoList.isNotEmpty) {
              if(widget.selectDefault! && widget.showAll!){
                if(bdoList.length>1) {
                  widget.selectedBDO = bdoList[1];
                }else{
                  widget.selectedBDO = bdoList[0];
                }
              }else {
                widget.selectedBDO = bdoList[0];
              }
              if (widget.onLoad != null) {
                widget.onLoad!(widget.selectedBDO);
              }
            }
            setState(() {});
          }
        },
        child: Constants.AUTH_ROLEID == Constants.ZHMANAGER ||
                Constants.AUTH_ROLEID == Constants.NHMANAGER
            ?
        StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                return Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: 70,
                    child: CommonDropdownButtonFormField<BdoList>(
                      value: widget.selectedBDO,
                      label: labelTxt ?? "Select State Trader",
                      onChanged: (BdoList? newValue) {
                        setState(() {
                          widget.selectedBDO = newValue!;
                        });

                        if (widget.resultFunction != null) {
                          widget.resultFunction!(newValue);
                        }
                      },
                      items: bdoList.map((value) {
                        return DropdownMenuItem<BdoList>(
                          value: value,
                          child: Text(value.name ?? ""),
                        );
                      }).toList(),
                    ));
              })
            : const Visibility(visible: false, child: Text("Not Required")));
  }
}
