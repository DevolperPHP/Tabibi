import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/style_app.dart';

class ShowModalBottomSheetC {
  static void showCupertinoBottomSheet({
    required List<String> data,
    required String title,
    required Function(String name) onTap,
  }) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(title, style: StringStyle.headerStyle),
          actions: data
              .map((item) => CupertinoActionSheetAction(
                    onPressed: () {
                      onTap(item);
                      Get.back();
                    },
                    child: Text(
                      item,
                      style: StringStyle.headerStyle
                          .copyWith(color: ColorApp.primaryColor),
                    ),
                  ))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
        );
      },
    );
  }

  // static void showCustomBottomSheet2({
  //   required List<String> data,
  //   required String title,
  //   required Function(String name) onTap,
  // }) {
  //   if (Platform.isIOS) {
  //     // iOS: Show Cupertino Action Sheet
  //     showCupertinoModalPopup(
  //       context: Get.context!,
  //       barrierDismissible: true,
  //       builder: (context) {
  //         return CupertinoActionSheet(
  //           title: Text(title, style: StringStyle.headerStyle),
  //           actions: data
  //               .map((item) => CupertinoActionSheetAction(
  //                     onPressed: () {
  //                       onTap(item);
  //                       Get.back();
  //                     },
  //                     child: Text(
  //                       item,
  //                       style: StringStyle.headerStyle
  //                           .copyWith(color: ColorApp.primaryColor),
  //                     ),
  //                   ))
  //               .toList(),
  //           cancelButton: CupertinoActionSheetAction(
  //             isDefaultAction: true,
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("إلغاء"),
  //           ),
  //         );
  //       },
  //     );
  //   } else if (Platform.isAndroid) {
  //     // Android: Show Material Bottom Sheet
  //     showModalBottomSheet(
  //       context: Get.context!,
  //       isScrollControlled: false,
  //       builder: (context) {
  //         return Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(title, style: StringStyle.headerStyle),
  //               ...data.map((item) {
  //                 return ListTile(
  //                   title: Text(
  //                     item,
  //                     style: StringStyle.headerStyle
  //                         .copyWith(color: ColorApp.primaryColor),
  //                   ),
  //                   onTap: () {
  //                     onTap(item);
  //                     Navigator.pop(context);
  //                   },
  //                 );
  //               }),
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text("إلغاء"),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }
}
