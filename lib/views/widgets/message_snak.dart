import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSnak {
  static SnackbarController message(String message,
          {Color color = Colors.red}) =>
      Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 4),
          backgroundColor: color,
          message: message));
}
