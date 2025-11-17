import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';

class RegisterTest extends StatelessWidget {
  const RegisterTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      appBar: AppBar(
        title: Text('اختبار التصميم الجديد'),
        backgroundColor: ModernTheme.primaryBlue,
        foregroundColor: ModernTheme.surface,
      ),
      body: Padding(
        padding: EdgeInsets.all(ModernTheme.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'اختبار صفحة التسجيل الحديثة',
              style: ModernTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ModernTheme.spaceXL),
            
            Text(
              'تم تصميم صفحة تسجيل جديدة بتصميم عصري مستوحى من Apple مع الميزات التالية:',
              style: ModernTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ModernTheme.spaceLG),
            
            _buildFeatureItem('✓ تصميم عصري بألوان iOS'),
            _buildFeatureItem('✓ حقول إدخال متطورة مع تأثيرات بصرية'),
            _buildFeatureItem('✓ بطاقات معلومات طبية تفاعلية'),
            _buildFeatureItem('✓ منتقي منطقة محسّن مع البحث'),
            _buildFeatureItem('✓ حوار شروط وأحكام عصري'),
            _buildFeatureItem('✓ رسوم متحركة سلسة'),
            _buildFeatureItem('✓ تصميم متجاوب مع RTL'),
            
            SizedBox(height: ModernTheme.spaceXL),
            
            ModernButton(
              text: 'فتح صفحة التسجيل الجديدة',
              onPressed: () => Get.toNamed(AppRoutes.modernRegister),
              icon: Icons.arrow_forward,
            ),
            
            SizedBox(height: ModernTheme.spaceMD),
            
            ModernButton(
              text: 'العودة إلى تسجيل الدخول',
              onPressed: () => Get.back(),
              buttonType: ButtonType.secondary,
              icon: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ModernTheme.spaceSM),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: ModernTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}