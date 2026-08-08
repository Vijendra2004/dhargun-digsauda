import 'package:adaniwilmar/widget/common_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';

class CommonDropDown extends StatefulWidget {
  final List? itemsList;
  final double? borderRadiusTLBR;
  final double? borderRadiusTRBL;
  final Color? borderColor;
  final String? labelTxt;
  final String? txtLabe;
  final Color? fillColor;
  final Color? labelTxtCol;
  final double? labelTxtSize;
  final String? varName;
  final String? hintTxt;
  const CommonDropDown(
      {Key? key,
      this.itemsList,
      this.borderRadiusTLBR,
      this.borderRadiusTRBL,
      this.borderColor,
      this.labelTxt,
      this.txtLabe,
      this.fillColor,
      this.labelTxtCol,
      this.labelTxtSize,
      this.varName,
      this.hintTxt})
      : super(key: key);

  @override
  State<CommonDropDown> createState() => _CommonDropDownState();
}

class _CommonDropDownState extends State<CommonDropDown> {
  @override
  Widget build(BuildContext context) {
    return CommonDropdownButtonFormField<String>(
      value: widget.varName,
      icon: const Align(
          alignment: Alignment.topRight,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 16,
          )),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadiusTLBR!),
                  topRight: Radius.circular(widget.borderRadiusTRBL!),
                  bottomLeft: Radius.circular(widget.borderRadiusTRBL!),
                  bottomRight: Radius.circular(widget.borderRadiusTLBR!)),
              borderSide: BorderSide(color: widget.borderColor!, width: 1.0)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadiusTLBR!),
                  topRight: Radius.circular(widget.borderRadiusTRBL!),
                  bottomLeft: Radius.circular(widget.borderRadiusTRBL!),
                  bottomRight: Radius.circular(widget.borderRadiusTLBR!)),
              borderSide: BorderSide(color: widget.borderColor!, width: 1.0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadiusTLBR!),
                  topRight: Radius.circular(widget.borderRadiusTRBL!),
                  bottomLeft: Radius.circular(widget.borderRadiusTRBL!),
                  bottomRight: Radius.circular(widget.borderRadiusTLBR!)),
              borderSide: BorderSide(color: widget.borderColor!, width: 1.0)),
          filled: true,
          // hintStyle: TextStyle(color: Colors.grey[800]),
          labelText: widget.labelTxt,
          labelStyle: TextStyle(
              color: widget.labelTxtCol, fontSize: widget.labelTxtSize),
          fillColor: widget.fillColor),
      onChanged: (String? newValue) {
        setState(() {});
      },
      items: widget.itemsList!.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
