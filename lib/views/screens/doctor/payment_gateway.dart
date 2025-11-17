import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/payment_getway_controller.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/modern/modern_card.dart';
import '../../widgets/common/loading_indicator.dart';

class PaymentGateway extends StatelessWidget {
  PaymentGateway({super.key});
  final PaymentGetwayController paymentGetwayController =
      Get.find<PaymentGetwayController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            _buildModernHeader(context),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(ModernTheme.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Summary Card
                    _buildPaymentSummaryCard(),
                    
                    SizedBox(height: ModernTheme.spaceLG),
                    
                    // Terms and Conditions Card
                    _buildTermsCard(),
                    
                    SizedBox(height: ModernTheme.spaceLG),
                    
                    // Agreement Checkbox
                    _buildAgreementSection(),
                    
                    SizedBox(height: ModernTheme.spaceXL),
                    
                    // Payment Button
                    _buildPaymentButton(),
                    
                    SizedBox(height: ModernTheme.spaceXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        boxShadow: ModernTheme.shadowSM,
        border: Border(
          bottom: BorderSide(
            color: ModernTheme.divider.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          ModernIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: Get.back,
            tooltip: 'رجوع',
            backgroundColor: ModernTheme.surfaceVariant,
            iconColor: ModernTheme.textPrimary,
          ),
          
          SizedBox(width: ModernTheme.spaceMD),
          
          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بوابة الدفع الآمنة',
                  style: ModernTheme.headlineMedium.copyWith(
                    color: ModernTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ModernTheme.spaceXS),
                Text(
                  'إتمام عملية الدفع بشكل آمن وسريع',
                  style: ModernTheme.bodySmall.copyWith(
                    color: ModernTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Security Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ModernTheme.spaceSM,
              vertical: ModernTheme.spaceXS,
            ),
            decoration: BoxDecoration(
              color: ModernTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
              border: Border.all(
                color: ModernTheme.success.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: ModernTheme.success,
                  size: 16,
                ),
                SizedBox(width: ModernTheme.spaceXS),
                Text(
                  'آمن',
                  style: ModernTheme.labelMedium.copyWith(
                    color: ModernTheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                ),
                child: Icon(
                  Icons.payment_rounded,
                  color: ModernTheme.primaryBlue,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملخص الدفع',
                      style: ModernTheme.titleLarge.copyWith(
                        color: ModernTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'تفاصيل المعاملة المالية',
                      style: ModernTheme.bodySmall.copyWith(
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Divider
          Divider(
            color: ModernTheme.divider,
            thickness: 1,
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Payment Details
          _buildPaymentDetailRow(
            'نوع الخدمة',
            'حالة طبية',
            Icons.medical_services_rounded,
          ),
          
          _buildPaymentDetailRow(
            'حالة الدفع',
            'معلق',
            Icons.pending_rounded,
            valueColor: ModernTheme.warning,
          ),
          
          _buildPaymentDetailRow(
            'طريقة الدفع',
            'بطاقة ائتمانية',
            Icons.credit_card_rounded,
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Total Amount
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              border: Border.all(
                color: ModernTheme.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المبلغ الإجمالي',
                  style: ModernTheme.titleMedium.copyWith(
                    color: ModernTheme.textPrimary,
                  ),
                ),
                Text(
                  '10,000 IQD',
                  style: ModernTheme.headlineMedium.copyWith(
                    color: ModernTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceSM),
      child: Row(
        children: [
          Icon(
            icon,
            color: ModernTheme.textTertiary,
            size: 20,
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Expanded(
            child: Text(
              label,
              style: ModernTheme.bodyMedium.copyWith(
                color: ModernTheme.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: ModernTheme.bodyMedium.copyWith(
              color: valueColor ?? ModernTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: ModernTheme.info,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شروط الاستخدام',
                      style: ModernTheme.titleLarge.copyWith(
                        color: ModernTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'يرجى قراءة الشروط بعناية',
                      style: ModernTheme.bodySmall.copyWith(
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Divider
          Divider(
            color: ModernTheme.divider,
            thickness: 1,
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Terms Content
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              border: Border.all(
                color: ModernTheme.divider.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTermItem(
                  '1',
                  'على الطالب التأكد من الحالة قبل الدفع',
                  Icons.check_circle_outline_rounded,
                ),
                _buildTermItem(
                  '2',
                  'عند الدفع وفي حال ثبوت خلل في الحالة يحق للطالب المطالبة بالسعر حسب القوانين',
                  Icons.gavel_rounded,
                ),
                _buildTermItem(
                  '3',
                  'في حال ثبت ان الحالة غير مطابقة سيتم إعادة مبلغ الحالة مع خصم تكاليف التشغيل',
                  Icons.refresh_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String number, String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: ModernTheme.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
              border: Border.all(
                color: ModernTheme.primaryBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: ModernTheme.labelMedium.copyWith(
                  color: ModernTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Expanded(
            child: Text(
              text,
              style: ModernTheme.bodyMedium.copyWith(
                color: ModernTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementSection() {
    return ModernCard(
      child: Column(
        children: [
          // Agreement Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: ModernTheme.warning,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Expanded(
                child: Text(
                  'موافقة على الشروط',
                  style: ModernTheme.titleMedium.copyWith(
                    color: ModernTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Checkbox with modern design
          Obx(
            () => InkWell(
              onTap: () {
                paymentGetwayController.agreedToTerms.value = 
                    !paymentGetwayController.agreedToTerms.value;
              },
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              child: Container(
                padding: EdgeInsets.all(ModernTheme.spaceMD),
                decoration: BoxDecoration(
                  color: paymentGetwayController.agreedToTerms.value
                      ? ModernTheme.primaryBlue.withOpacity(0.05)
                      : ModernTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                  border: Border.all(
                    color: paymentGetwayController.agreedToTerms.value
                        ? ModernTheme.primaryBlue.withOpacity(0.3)
                        : ModernTheme.divider,
                    width: paymentGetwayController.agreedToTerms.value ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Custom Checkbox
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: paymentGetwayController.agreedToTerms.value
                            ? ModernTheme.primaryBlue
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                        border: Border.all(
                          color: paymentGetwayController.agreedToTerms.value
                              ? ModernTheme.primaryBlue
                              : ModernTheme.textSecondary,
                          width: 2,
                        ),
                      ),
                      child: paymentGetwayController.agreedToTerms.value
                          ? Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    
                    SizedBox(width: ModernTheme.spaceMD),
                    
                    // Agreement Text
                    Expanded(
                      child: Text(
                        'أوافق على شروط الاستخدام والأحكام المذكورة أعلاه',
                        style: ModernTheme.bodyMedium.copyWith(
                          color: paymentGetwayController.agreedToTerms.value
                              ? ModernTheme.primaryBlue
                              : ModernTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Obx(
      () => Column(
        children: [
          // Security Note
          if (!paymentGetwayController.agreedToTerms.value)
            Container(
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              margin: EdgeInsets.only(bottom: ModernTheme.spaceMD),
              decoration: BoxDecoration(
                color: ModernTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                border: Border.all(
                  color: ModernTheme.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: ModernTheme.error,
                    size: 20,
                  ),
                  SizedBox(width: ModernTheme.spaceSM),
                  Expanded(
                    child: Text(
                      'يجب الموافقة على الشروط والأحكام للمتابعة',
                      style: ModernTheme.bodySmall.copyWith(
                        color: ModernTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Payment Button
          ModernButton(
            text: paymentGetwayController.isLoading.value
                ? 'جاري المعالجة...'
                : 'إكمال الدفع الآمن',
            onPressed: paymentGetwayController.agreedToTerms.value
                ? paymentGetwayController.completeOrder
                : null,
            isLoading: paymentGetwayController.isLoading.value,
            icon: paymentGetwayController.isLoading.value
                ? null
                : Icons.lock_rounded,
            buttonType: ButtonType.primary,
            height: 56.h,
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Security Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSecurityBadge('SSL', Icons.security_rounded),
              SizedBox(width: ModernTheme.spaceMD),
              _buildSecurityBadge('PCI-DSS', Icons.verified_rounded),
              SizedBox(width: ModernTheme.spaceMD),
              _buildSecurityBadge('3D-Secure', Icons.fingerprint_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ModernTheme.spaceSM,
        vertical: ModernTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: ModernTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
        border: Border.all(
          color: ModernTheme.divider,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: ModernTheme.textTertiary,
            size: 14,
          ),
          SizedBox(width: ModernTheme.spaceXS),
          Text(
            label,
            style: ModernTheme.labelMedium.copyWith(
              color: ModernTheme.textTertiary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
