import 'dart:io';

import 'package:get/get.dart';

class Instruction {
  final String title;
  final List<String> steps;
  final String imagePath;
  String name;
  Rx<File?> image;
  Instruction({
    required this.title,
    required this.steps,
    required this.imagePath,
    required this.image,
    required this.name,
  });
}
