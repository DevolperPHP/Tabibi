import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_app.dart';

class StringStyle {
  static const double fontSize = 1;

  static TextStyle headerStyle = TextStyle(
      fontSize: (18 * fontSize).sp,
      fontWeight: FontWeight.bold,
      color: ColorApp.textPrimaryColor,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent);
  static TextStyle textTable =
      TextStyle(fontSize: (14 * fontSize).sp, color: ColorApp.textPrimaryColor, decoration: TextDecoration.none, decorationColor: Colors.transparent);

  static TextStyle textLabil = TextStyle(
      fontSize: (16 * fontSize).sp, color: ColorApp.textSecondryColor, decoration: TextDecoration.none, decorationColor: Colors.transparent);
  static TextStyle textLabilBold = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: (14 * fontSize).sp,
      color: ColorApp.textSecondryColor,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent);
  static TextStyle textButtom = TextStyle(
      fontSize: (20 * fontSize).sp,
      fontWeight: FontWeight.bold,
      color: ColorApp.textThredColor,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent);
  static TextStyle headLineStyle = TextStyle(
      fontSize: (30 * fontSize).sp,
      fontWeight: FontWeight.bold,
      color: ColorApp.primaryColor,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent);
  static TextStyle headLineStyle2 = TextStyle(
      fontSize: (26 * fontSize).sp,
      fontWeight: FontWeight.bold,
      color: ColorApp.primaryColor,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent);
  // static const titleStyle =
  //     TextStyle(fontSize: 20 * fontSize, color: Colors.white);
  // static const titleBoldStyle = TextStyle(
  //     fontSize: 18 * fontSize,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.black);
  // static const subTitleStyle = TextStyle(
  //     fontSize: 18 * fontSize,
  //     fontWeight: FontWeight.bold,
  //     color: Color.fromARGB(255, 82, 82, 82));
  // static const buttonStyle = TextStyle(
  //     fontSize: 22 * fontSize,
  //     color: ColorApp.whiteColor,
  //     fontWeight: FontWeight.bold);
  // static const buttonStyle3 =
  //     TextStyle(fontSize: 17 * fontSize, color: ColorApp.whiteColor);
  // static const button2Style =
  //     TextStyle(fontSize: 20 * fontSize, color: ColorApp.whiteColor);
  // static const leadingStyle = TextStyle(
  //     fontSize: 14 * fontSize, color: Color.fromARGB(255, 192, 192, 192));
  // static const hintText =
  //     TextStyle(fontSize: 16 * fontSize, color: Color(0xff717171));
}
