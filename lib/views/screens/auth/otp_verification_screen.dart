// OTP Verification Screen - Professional Design
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/message_snak.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  Timer? _resendTimer;
  RxInt countdown = 60.obs;
  RxBool canResend = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startResendTimer();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  void _startResendTimer() {
    canResend.value = false;
    countdown.value = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _onOTPChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (hasError.value) {
      hasError.value = false;
    }

    // Auto-submit when all digits are entered
    if (_getOTPCode().length == 6) {
      Future.delayed(const Duration(milliseconds: 300), _verifyOTP);
    }
  }

  String _getOTPCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOTP() async {
    final otpCode = _getOTPCode();
    if (otpCode.length != 6) {
      _triggerShakeAnimation();
      hasError.value = true;
      MessageSnak.message('يرجى إدخال رمز التحقق المكون من 6 أرقام',
          color: ColorApp.redColor);
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      await _authController.verifyOTP(
        phoneNumber: _authController.pendingRegistrationData['phone'] ?? '',
        otpCode: otpCode,
      );

      if (mounted) {
        isLoading.value = false;
        MessageSnak.message('تم التحقق بنجاح! جاري إنشاء الحساب...',
            color: ColorApp.greenColor);
      }
    } catch (e) {
      if (mounted) {
        isLoading.value = false;
        _triggerShakeAnimation();
        hasError.value = true;
        MessageSnak.message('رمز التحقق غير صحيح', color: ColorApp.redColor);
      }
    }
  }

  void _triggerShakeAnimation() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  Future<void> _resendOTP() async {
    if (!canResend.value) return;

    try {
      isLoading.value = true;
      await _authController.sendOTP(
        phoneNumber: _authController.pendingRegistrationData['phone'] ?? '',
      );

      _startResendTimer();
      hasError.value = false;
      _clearOTP();

      if (mounted) {
        isLoading.value = false;
        MessageSnak.message('تم إعادة إرسال رمز التحقق',
            color: ColorApp.greenColor);
      }
    } catch (e) {
      if (mounted) {
        isLoading.value = false;
        MessageSnak.message('فشل إعادة الإرسال، يرجى المحاولة لاحقاً',
            color: ColorApp.redColor);
      }
    }
  }

  void _clearOTP() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Values.spacerV),
              child: Column(
                children: [
                  // Header Section
                  SizedBox(height: Values.spacerV * 2),
                  _buildHeader(),

                  SizedBox(height: Values.spacerV * 2),

                  // OTP Illustration with Animation
                  _buildIllustration(),

                  SizedBox(height: Values.spacerV * 2),

                  // Description Text
                  _buildDescription(),

                  SizedBox(height: Values.spacerV * 2.5),

                  // PIN Input Field
                  _buildPINInput(),

                  SizedBox(height: Values.spacerV),

                  // Error Message
                  Obx(() => hasError.value
                      ? _buildErrorMessage()
                      : const SizedBox.shrink()),

                  SizedBox(height: Values.spacerV * 2),

                  // Verify Button
                  Obx(() => ModernButton(
                        text: 'تحقق',
                        onPressed: isLoading.value ? null : _verifyOTP,
                        isLoading: isLoading.value,
                        icon: Icons.check_circle_rounded,
                        height: 55.h,
                      )),

                  SizedBox(height: Values.spacerV),

                  // Resend Section
                  _buildResendSection(),

                  SizedBox(height: Values.spacerV),

                  // Change Number Link
                  _buildChangeNumberLink(),

                  SizedBox(height: Values.spacerV),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorApp.subColor.withAlpha(100),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: ColorApp.primaryColor,
                size: 20.w,
              ),
            ),
          ),
        ),
        SizedBox(height: Values.spacerV),
        Text(
          'تحقق من رقم الهاتف',
          style: ModernTheme.headlineLarge.copyWith(
            color: ColorApp.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorApp.primaryColor.withAlpha(25),
                  ColorApp.primaryColor.withAlpha(13),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: ColorApp.primaryColor.withAlpha(50),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ColorApp.primaryColor.withAlpha(38),
                      ColorApp.primaryColor.withAlpha(20),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.sms_outlined,
                  size: 55.w,
                  color: ColorApp.primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription() {
    final phoneNumber =
        _authController.pendingRegistrationData['phone'] ?? '';

    return Column(
      children: [
        Text(
          'تم إرسال رمز تحقق مكون من 6 أرقام إلى',
          style: ModernTheme.bodyLarge.copyWith(
            color: ModernTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          phoneNumber,
          style: ModernTheme.titleLarge.copyWith(
            color: ColorApp.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPINInput() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return _buildOTPField(index);
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Obx(() {
      final hasErrorValue = hasError.value;
      final isFocused = _focusNodes[index].hasFocus;

      return Container(
        width: 48.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: isFocused ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: hasErrorValue
                ? ColorApp.redColor
                : isFocused
                    ? ColorApp.primaryColor
                    : ColorApp.subColor.withAlpha(100),
            width: isFocused ? 2 : 1.5,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: ColorApp.primaryColor.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: ModernTheme.headlineLarge.copyWith(
              fontSize: 24.sp,
              color: ColorApp.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            onChanged: (value) => _onOTPChanged(index, value),
          ),
        ),
      );
    });
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Values.spacerV,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: ColorApp.redColor.withAlpha(13),
        borderRadius: BorderRadius.circular(Values.circle),
        border: Border.all(
          color: ColorApp.redColor.withAlpha(75),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: ColorApp.redColor,
            size: 20.w,
          ),
          SizedBox(width: 8.h),
          Text(
            'رمز التحقق غير صحيح، يرجى المحاولة مرة أخرى',
            style: ModernTheme.bodyMedium.copyWith(
              color: ColorApp.redColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendSection() {
    return Obx(() {
      final canResendValue = canResend.value;
      final countdownValue = countdown.value;

      return Column(
        children: [
          Text(
            'لم تستلم الرمز؟',
            style: ModernTheme.bodyMedium.copyWith(
              color: ModernTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: canResendValue ? _resendOTP : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: Values.spacerV,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: canResendValue
                    ? ColorApp.primaryColor.withAlpha(25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(Values.circle),
                border: canResendValue
                    ? Border.all(
                        color: ColorApp.primaryColor.withAlpha(75),
                        width: 1,
                      )
                    : null,
              ),
              child: Text(
                canResendValue
                    ? 'إعادة الإرسال'
                    : 'إعادة الإرسال (${countdownValue}s)',
                style: ModernTheme.bodyMedium.copyWith(
                  color: canResendValue
                      ? ColorApp.primaryColor
                      : ModernTheme.textTertiary,
                  fontWeight: canResendValue ? FontWeight.bold : FontWeight.normal,
                  decoration:
                      canResendValue ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChangeNumberLink() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Text(
        'تغيير رقم الهاتف',
        style: ModernTheme.bodyMedium.copyWith(
          color: ColorApp.primaryColor,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
