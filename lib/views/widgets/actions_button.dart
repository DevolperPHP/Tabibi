import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants/color_app.dart';
import '../../utils/constants/style_app.dart';
import '../../utils/constants/values_constant.dart';

class BottonsC {
  //
  static Widget action1(String name, void Function()? onPressed,
      {Color color = ColorApp.primaryColor, double h = 50, IconData? icon}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Values.circle * 0.2),
        child: MaterialButton(
            color: color,
            height: h.h,
            onPressed: onPressed,
            padding: EdgeInsets.symmetric(horizontal: Values.circle * 4),
            hoverElevation: Values.circle,
            hoverColor: ColorApp.greenColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Values.circle)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(name, style: StringStyle.textButtom),
              if (icon != null)
                Icon(icon, size: 35, color: ColorApp.backgroundColor)
            ])));
  }

  static Widget action2(String name, void Function()? onPressed,
      {Color color = ColorApp.primaryColor,
      double h = 50,
      IconData? icon,
      double iconSize = 35}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Values.circle * 0.2),
        child: MaterialButton(
            color: color,
            height: h.h,
            minWidth: 125.w,
            elevation: 0.5,
            onPressed: onPressed,
            hoverElevation: Values.circle,
            hoverColor: ColorApp.greenColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Values.circle)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(name,
                  style: StringStyle.textButtom
                      .copyWith(color: ColorApp.whiteColor)),
              if (icon != null) SizedBox(width: Values.circle),
              if (icon != null)
                Icon(icon, size: iconSize, color: ColorApp.backgroundColor)
            ])));
  }

//
  static Widget actionIcon(
    IconData icon,
    String name,
    void Function()? onPressed, {
    Color color = ColorApp.primaryColor,
    double size = 30,
    Key? key,
    EdgeInsets? padding,
  }) {
    return Container(
        key: key,
        width: size.w,
        height: size.w,
        margin:
            padding ?? EdgeInsets.symmetric(horizontal: Values.circle * 0.2),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(Values.circle * 0.4)),
        child: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: Icon(icon, size: (size * 0.8).w),
            tooltip: name,
            color: ColorApp.whiteColor));
  }

  static Widget actionIconWithOutColor(
      IconData icon, String name, void Function()? onPressed,
      {Color color = ColorApp.backgroundColorContent,
      Color colorBackgraond = ColorApp.whiteColor,
      double size = 35,
      Key? key}) {
    return Container(
        key: key,
        width: size.w,
        height: size.w,
        margin: EdgeInsets.symmetric(horizontal: Values.circle * 0.2),
        decoration: BoxDecoration(
            color: colorBackgraond,
            borderRadius: BorderRadius.circular(Values.circle * 0.4)),
        child: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: onPressed,
            icon: Icon(icon, size: (size).w, color: color),
            tooltip: name,
            color: ColorApp.whiteColor));
  }
}
