// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../../utils/validators.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/input_text.dart';

class RePassword extends StatelessWidget {
  RePassword({super.key});
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Values.spacerV.h),
            child: ListView(children: [
              SizedBox(height: Values.spacerV * 6),
              // SvgPicture.asset(ImagesUrl. ),
              SizedBox(height: Values.spacerV * 2),
              Center(
                  child: Text('إعادة تعيين كلمة المرور',
                      textAlign: TextAlign.center,
                      style: StringStyle.textLabil)),
              SizedBox(height: Values.spacerV * 4),
              Form(
                  key: authController.formKeyRePassword,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputText.inputStringValidatorIcon(
                          isPassword: true,
                          'كلمة المرور ',
                          authController.password,
                          validator: Validators.password,
                          icon: Icons.password_outlined),
                      InputText.inputStringValidatorIcon(
                          isPassword: true,
                          'اعادة كلمة المرور ',
                          authController.confirmPassword,
                          validator: (v) => Validators.confirmPassword(
                              v, authController.password.text),
                          icon: Icons.password_outlined),
                      SizedBox(height: Values.spacerV),
                    ],
                  )),
              SizedBox(height: Values.spacerV * 5),
              Obx(() => authController.isLoading.value
                  ? LoadingIndicator()
                  : BottonsC.action1(
                      'إعادة تعيين', authController.submitFormRePassword,
                      icon: Icons.keyboard_arrow_left_outlined))
            ])));
  }
}
