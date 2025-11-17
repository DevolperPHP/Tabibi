// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/validators.dart';
import '../../../utils/design_system/animations.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/input_text.dart';
import '../../widgets/animated_logo.dart';

class Login extends StatelessWidget {
  Login({super.key});
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: ModernTheme.space2XL),
                
                // Animated Pulsing Logo
                AppAnimations.scaleIn(
                  duration: const Duration(milliseconds: 600),
                  child: Center(
                    child: AnimatedLogo(
                      size: 100,
                      heroTag: 'login_logo',
                    ),
                  ),
                ),
                
                SizedBox(height: ModernTheme.spaceLG),
                
                // Welcome Text with animation
                AppAnimations.fadeSlideIn(
                  duration: const Duration(milliseconds: 700),
                  child: Column(
                    children: [
                      Text(
                        'مرحباً بك',
                        style: ModernTheme.headlineMedium.copyWith(
                          color: ModernTheme.primaryBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ModernTheme.spaceSM),
                      Text(
                        'سجل دخولك للمتابعة',
                        style: ModernTheme.bodyLarge.copyWith(
                          color: ModernTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: ModernTheme.spaceXL),
                // Form with animations
                AppAnimations.fadeSlideIn(
                  duration: const Duration(milliseconds: 800),
                  offset: 40,
                  child: Form(
                    key: authController.formKeyLogin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        InputText.inputStringValidatorIcon(
                          'البريد الإلكتروني',
                          authController.email,
                          icon: Icons.alternate_email_outlined,
                          validator: Validators.email,
                        ),
                        
                        SizedBox(height: ModernTheme.spaceMD),
                        
                        // Password Field
                        InputText.inputStringValidatorIcon(
                          isPassword: true,
                          'كلمة المرور',
                          authController.password,
                          validator: Validators.password,
                          icon: Icons.lock_outline,
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: ModernTheme.spaceMD),
                
                // Forgot Password with animation
                
                
                SizedBox(height: ModernTheme.spaceXL),
                
                // Login Button with animation
                AppAnimations.fadeSlideIn(
                  duration: const Duration(milliseconds: 1000),
                  offset: 30,
                  child: Obx(
                    () => ModernButton(
                      text: 'تسجيل الدخول',
                      onPressed: authController.submitFormLogin,
                      isLoading: authController.isLoading.value,
                      icon: Icons.login_rounded,
                      width: double.infinity,
                    ),
                  ),
                ),
                
                SizedBox(height: ModernTheme.spaceXL),
                
                // Register link with animation
                AppAnimations.fadeIn(
                  duration: const Duration(milliseconds: 1100),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'عضو جديد؟ ',
                        style: ModernTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'سجل الآن',
                            style: ModernTheme.bodyMedium.copyWith(
                              color: ModernTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed(AppRoutes.modernRegister),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: ModernTheme.spaceXL),
              ],
            ),
          ),
        ));
  }
}
