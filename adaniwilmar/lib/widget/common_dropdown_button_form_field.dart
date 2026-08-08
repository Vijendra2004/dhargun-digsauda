import 'package:adaniwilmar/config/constant.dart';
import 'package:flutter/material.dart';

class CommonDropdownButtonFormField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final InputDecoration? decoration;
  final bool isExpanded;
  final bool isDense;
  final Widget? icon;
  final int? elevation;
  final TextStyle? style;
  final String? label;

  const CommonDropdownButtonFormField({
    super.key,
    this.value,
    this.items,
    this.onChanged,
    this.decoration,
    this.isExpanded = true,
    this.isDense = true,
    this.icon,
    this.elevation,
    this.style,
    this.label,
  });

  @override
  Widget build(BuildContext context) {

    /// Ensure the selected value exists in the dropdown items
    T? safeValue;

    if (value != null && items != null && items!.isNotEmpty) {
      for (final item in items!) {
        if (item.value == value) {
          safeValue = item.value;
          break;
        }
      }
    }

    final defaultDecoration = InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Constant.textFormFieldColor,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Constant.textFormcontentPadHor,
        vertical: Constant.textFormcontentPadHVer,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constant.textFormborderRadiusTL),
          bottomRight: Radius.circular(Constant.textFormborderRadiusTL),
        ),
        borderSide: BorderSide(
          color: Constant.textFormEnaBorCol,
          width: Constant.textFormEnaBorWid,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constant.textFormborderRadiusTL),
          bottomRight: Radius.circular(Constant.textFormborderRadiusTL),
        ),
        borderSide: BorderSide(
          color: Constant.textFormEnaBorCol,
          width: Constant.textFormEnaBorWid,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constant.textFormborderRadiusTL),
          bottomRight: Radius.circular(Constant.textFormborderRadiusTL),
        ),
        borderSide: BorderSide(
          color: Constant.textFormEnaBorCol,
          width: Constant.textFormFocuBorWid,
        ),
      ),
    );

    return DropdownButtonFormField<T>(
      value: safeValue,
      items: items,
      onChanged: onChanged,
      isExpanded: isExpanded,
      isDense: isDense,
      icon: icon ?? const Icon(Icons.arrow_drop_down_sharp),
      elevation: elevation ?? 8,
      style: style ??
          TextStyle(
            color: Colors.black,
            fontSize: Constant.fontSize15,
          ),
      decoration: decoration ?? defaultDecoration,
    );
  }
}