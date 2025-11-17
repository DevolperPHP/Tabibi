import 'package:flutter/material.dart';
import '../../../utils/constants/color_app.dart';

// ignore: must_be_immutable
class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({super.key, this.size});
  double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: size ?? 30,
            height: size ?? 30,
            child: Center(
                child: CircularProgressIndicator(
                    color: ColorApp.primaryColor,
                    backgroundColor: ColorApp.backgroundColor))));
  }
}
