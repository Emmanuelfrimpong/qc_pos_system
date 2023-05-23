import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getCustomTextStyle(BuildContext context,
    {FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    double? letterSpacing,
    TextDecoration? decoration}) {
  //? get screen size and set font size according to screen size
  final double screenWidth = MediaQuery.of(context).size.width;

  return GoogleFonts.openSans(
    fontSize: fontSize ?? screenWidth * 0.02,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing ?? 0.5,
    color: color,
    decoration: decoration,
  );
}
