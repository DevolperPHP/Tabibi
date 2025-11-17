import 'package:flutter/material.dart';

import 'color_app.dart';

class ShadowValues {
  static List<BoxShadow> shadowValues = [
    BoxShadow(
        blurRadius: 10,
        spreadRadius: 0,
        color: ColorApp.blackColor.withAlpha(15),
        offset: const Offset(2, 2))
  ];
  static List<BoxShadow> shadowValuesBlur = [
    BoxShadow(
        blurRadius: 40,
        spreadRadius: 0,
        color: ColorApp.blackColor.withAlpha(10),
        offset: const Offset(2, 2))
  ];
  static List<BoxShadow> shadowValues2 = [
    BoxShadow(
        blurRadius: 2,
        spreadRadius: 5,
        color: ColorApp.blackColor.withAlpha(5),
        offset: const Offset(2, 2))
  ];
}
