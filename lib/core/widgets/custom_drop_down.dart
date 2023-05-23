import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/styles.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {Key? key,
      this.value,
      required this.items,
      this.validator,
      this.hintText,
      this.onChanged,
      this.radius,
      this.onSaved,
      this.label,
      this.iconData})
      : super(key: key);

  final String? value;
  final List<DropdownMenuItem> items;
  final String? Function(dynamic)? validator;
  final String? hintText;
  final String? label;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onSaved;
  final double? radius;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
      borderRadius: BorderRadius.circular(5),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1,
          ),
        ),
        fillColor: backColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 5),
          borderSide: const BorderSide(color: primaryColor),
        ),
        prefixIconColor: primaryColor,
        suffixIconColor: primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        labelStyle: getCustomTextStyle(context,
            fontSize: 14, fontWeight: FontWeight.w300),
        labelText: label,
        hintText: hintText,
        focusColor: secondaryColor,
        iconColor: Colors.grey,
        hintStyle: getCustomTextStyle(context,
            fontSize: 14, fontWeight: FontWeight.w300),
      ),
      onChanged: onChanged,
      onSaved: onSaved,
      dropdownColor: backColor,
      items: items,
      validator: validator,
      value: value,
      isExpanded: true,
      icon: Icon(
        iconData ?? Icons.arrow_drop_down,
        color: primaryColor,
      ),
    ));
  }
}
