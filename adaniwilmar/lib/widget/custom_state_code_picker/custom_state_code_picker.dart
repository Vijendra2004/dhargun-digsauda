import 'dart:developer';
import 'package:adaniwilmar/models/bdo_list_response.dart';

import '../../gmcore/network/GMLogger.dart';
import 'custom_selection_dialog.dart';
import 'package:flutter/material.dart';


class StateCodePicker extends StatefulWidget {
  final List<dynamic> elementsState;
  late final ValueChanged<dynamic> onChanged;
  final ValueChanged<dynamic> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showStateOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(dynamic) builder;

  final bool showOnlyStateWhenClosed;

  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  /// contains the state codes to load only the specified states.
  final List<String> stateFilter;

  bool isSateCodeReadOnly;

  StateCodePicker({
    required this.elementsState,
    required this.onChanged,
    required this.onInit,
    required this.initialSelection,
    this.favorite = const [],
    this.stateFilter = const [],
    required this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.showStateOnly = true,
    this.searchDecoration = const InputDecoration(),
    required this.searchStyle,
    required this.emptySearchBuilder,
    this.showOnlyStateWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = false,
    required this.builder,
    this.isSateCodeReadOnly = false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _StateCodePickerState();
  }

  // getStateCode() {
  //   List<Map> jsonList = [
  //     {"STATECODE": "TN", "STATENAME": "TAMILNADU", "COUNTRYCODE": "IN"},
  //   ];
  //
  //   List<dynamic> elements = jsonList
  //       .map((s) => dynamic(
  //     stateCode: s['STATECODE'].toString(),
  //     stateName: s['STATENAME'].toString(),
  //     countryCode: s['COUNTRYCODE'].toString(),
  //   ))
  //       .toList();
  //
  //   if (stateFilter.length > 0) {
  //     elements =
  //         elements.where((c) => stateFilter.contains(c.stateCode)).toList();
  //   }
  //
  //   return elements;
  // }
}

class _StateCodePickerState extends State<StateCodePicker> {
 // ProfileController profileControllerData = Get.find();
dynamic selectedItem;

  List<dynamic> favoriteElements = [];

  _StateCodePickerState(/*this.elements*/);

  @override
  Widget build(BuildContext context) {
    Widget _widget;

    _widget = InkWell(
      onTap: _showSelectionDialog,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Container(
          height: 47.0,
          padding: EdgeInsets.only(top: 5.0, left: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItem!=null?selectedItem.employeeName??"":"",
                  style: TextStyle(color: Colors.black),
                ),
                // Container(
                //     padding: EdgeInsets.all(10),
                //     child: Image.asset(
                //       Images.icon_arrow_down,
                //       height: 30,
                //       width: 30,
                //     )),
              ],
            ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey, width: 1)),
        ),
      ),
    );
    // }
    return _widget;
  }

  verticalLine() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 7.0, right: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }

  @override
  initState() {
    super.initState();
  }

  // Future<List> getTheMasterDropDownData() async {
  //   return await FirebaseFirestore.instance
  //       .collection(Collections.masterDropDown)
  //       .doc("countriesAndStates")
  //       .get()
  //       .then((value) async {
  //     DocumentSnapshot document = value;
  //
  //     /// Collect states
  //     return document.get(widget.docName);
  //   });
  // }

  Future<void> _showSelectionDialog() async {
    try {
      showDialog(
          context: context,
          builder: (_) => SelectionDialog(
          widget.elementsState,
            widget.elementsState,
            showStateOnly: widget.showStateOnly,
            emptySearchBuilder: widget.emptySearchBuilder,
            searchDecoration: widget.searchDecoration,
            searchStyle: widget.searchStyle,
            showFlag: widget.showFlag,
            key: Key("state picker key"),
          )).then((e) {
        if (e != null) {
         // profileControllerData.selectedItem.value = e;
          _publishSelection(e);
          setState(() {
            selectedItem = e;
          });
        }
      });
      // }
    } catch (e) {
      GMLogger.v(e.toString());
    }
  }

  void _publishSelection(dynamic e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

  void _onInit(dynamic initialData) {
    if (widget.onInit != null) {
      widget.onInit(initialData);
    }
  }
}