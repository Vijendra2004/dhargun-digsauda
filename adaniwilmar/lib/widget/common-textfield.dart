import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/strings.dart';

class CommonTextFormField extends StatelessWidget {
  final String? labeltxt;
  final Color? labeltxtColor;
  final double? labeltxtSize;
  final FontWeight? labeltxtFontWeight;
  final Color? focuBorColor;
  final double? focuBorWid;
  final Color? enaBorColor;
  final double? enaBorWid;
  final double? borderRadiusTL;
  final double? borderRadiusBR;
  final double? contentPadHor;
  final double? contentPadHVer;
  final TextEditingController? controllerTxt;
  final FormFieldValidator<String>? validatioFunction;
  final int? maxLine;
  final List<TextInputFormatter>? inputFormatter;
  final bool? enabled;
  final Function? onChanged;
  final Function? onTapCallBack;
  final TextInputType? keyborType;
  final bool? dropdownIcon;
  final bool? calIcon;
  final bool isNonEditable;

  const CommonTextFormField(
      {Key? key,
      this.labeltxt,
      this.labeltxtColor,
      this.focuBorColor,
      this.focuBorWid,
      this.enaBorColor,
      this.enaBorWid,
      this.borderRadiusTL,
      this.borderRadiusBR,
      this.contentPadHor,
      this.contentPadHVer,
      this.labeltxtFontWeight,
      this.labeltxtSize,
      this.controllerTxt,
      this.validatioFunction,
      this.maxLine,
      this.inputFormatter,
      this.enabled,
      this.onChanged,
      this.isNonEditable = false,
        this.onTapCallBack,
      this.keyborType,
      this.dropdownIcon,
      this.calIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: isNonEditable?Colors.grey.withOpacity(0.8):labeltxtColor),
      keyboardType: keyborType,
      controller: controllerTxt,
      maxLines: maxLine,
      inputFormatters: inputFormatter,
      enabled: labeltxt == Strings.invoiceNoStr?true: enabled,
      onChanged: (String? value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      decoration: InputDecoration(
          suffixIcon: calIcon != null && calIcon!
              ? const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                )
              : dropdownIcon != null && dropdownIcon!
                  ? const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                    )
                  : null,
          labelText: labeltxt!,
          labelStyle: TextStyle(
              color: labeltxtColor!,
              fontSize: labeltxtSize,
              fontWeight: labeltxtFontWeight),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focuBorColor!, width: focuBorWid!),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(borderRadiusBR!),
                bottomLeft: Radius.circular(borderRadiusBR!),
                bottomRight: Radius.circular(10),
              )),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: enaBorColor!, width: enaBorWid!),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(borderRadiusBR!),
                bottomLeft: Radius.circular(borderRadiusBR!),
                bottomRight: Radius.circular(10),
              )),
          contentPadding: EdgeInsets.symmetric(
              horizontal: contentPadHor!, vertical: contentPadHVer!)),
      onSaved: (String? value) {},
      onTap: (){
        onTapCallBack!();
      },
      validator: validatioFunction,
    );
  }
}
