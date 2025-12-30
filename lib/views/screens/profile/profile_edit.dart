import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tabibi/views/widgets/common/loading_indicator.dart';

import '../../../controllers/profile_controller.dart';
import '../../../utils/constants/modern_theme.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../../utils/validators.dart';
import '../../widgets/modern/modern_input_field.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/modern/modern_app_bar.dart';
import '../../widgets/modern/modern_card.dart';
import '../../widgets/modern/modern_selection_card.dart';

class ProfileEdit extends StatelessWidget {
  ProfileEdit({super.key});
  final ProfileController profileController = Get.find<ProfileController>();
  
  final List<String> baghdadZones = [
    'اختر هذا الخيار في حال عدم وجود منطقتك',
    'الكرادة',
    'الزعفرانية',
    'زيونة',
    'بغداد الجديدة',
    'شارع فلسطين',
    'البلديات',
    'مدينة الصدر',
    'أور',
    'الحبيبية',
    'المشتل',
    'الغدير',
    'جميلة',
    'حي تونس',
    'الشعب',
    'حي القاهرة',
    'حي الجزائر',
    'باب الشرقي',
    'باب المعظم',
    'الشورجة',
    'الفضل',
    'ساحة الميدان',
    'البتاوين',
    'المنصور',
    'اليرموك',
    'الغزالية',
    'العامرية',
    'الخضراء',
    'الجامعة',
    'السيدية',
    'الدورة',
    'البياع',
    'حي الجهاد',
    'حي العامل',
    'حي الإعلام',
    'العطيفية',
    'القادسية',
    'حي العدل',
    'حي السلام',
    'حي المخابرات',
    'حي القادسية',
    'حي المأمون',
    'حي الزيتون',
    'النصر والسلام',
    'زيدان',
    'الكرمة',
    'المشاهدة',
    'العبايجي',
    'الطارمية المركز',
    'النهروان',
    'الوحدة',
    'الجعارة',
    'المدائن',
    'اللطيفية',
    'اليوسفية',
    'المحمودية المركز'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      appBar: ModernAppBar(
        title: 'تعديل المعلومات',
        showLogo: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: ModernTheme.spaceMD),
            child: ModernIconButton(
              icon: Icons.arrow_forward_ios,
              tooltip: 'رجوع',
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value && profileController.name.value.text.isEmpty) {
          return Center(child: LoadingIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(ModernTheme.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              ModernCard(
                padding: const EdgeInsets.all(ModernTheme.spaceLG),
                child: Column(
                  children: [
                    // Profile Avatar
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: ModernTheme.primaryGradient,
                          boxShadow: ModernTheme.mediumShadow,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: ModernTheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: ModernTheme.spaceMD),
                    Text(
                      'معلومات شخصية',
                      style: ModernTheme.headline4,
                    ),
                    const SizedBox(height: ModernTheme.spaceXS),
                    Text(
                      'قم بتحديث معلوماتك الشخصية',
                      style: ModernTheme.bodyMedium.copyWith(
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: ModernTheme.spaceLG),
              
              // Personal Information Section
              _buildSectionHeader('المعلومات الشخصية', Icons.person_outline),
              const SizedBox(height: ModernTheme.spaceMD),
              
              ModernCard(
                padding: const EdgeInsets.all(ModernTheme.spaceLG),
                child: Form(
                  key: profileController.formKey,
                  child: Column(
                    children: [
                      ModernInputField(
                        label: 'الاسم الكامل',
                        controller: profileController.name,
                        prefixIcon: Icons.person,
                        validator: (value) => Validators.notEmpty(value, 'الاسم الكامل مطلوب'),
                      ),
                      const SizedBox(height: ModernTheme.spaceMD),
                      
                      ModernInputField(
                        label: 'العمر',
                        controller: profileController.age,
                        prefixIcon: Icons.cake,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: (value) => Validators.notEmpty(value, 'العمر مطلوب'),
                      ),
                      const SizedBox(height: ModernTheme.spaceMD),
                      
                      ModernInputField(
                        label: 'رقم الهاتف',
                        controller: profileController.phone,
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: (value) => Validators.notEmpty(value, 'رقم الهاتف مطلوب'),
                      ),
                      const SizedBox(height: ModernTheme.spaceMD),
                      
                      ModernInputField(
                        label: 'حساب التليجرام',
                        controller: profileController.telegram,
                        prefixIcon: Icons.send,
                        validator: (value) => Validators.notEmpty(value, 'حساب التليجرام مطلوب'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: ModernTheme.spaceLG),
              
              // Location Information Section
              _buildSectionHeader('معلومات الموقع', Icons.location_on_outlined),
              const SizedBox(height: ModernTheme.spaceMD),
              
              ModernCard(
                padding: const EdgeInsets.all(ModernTheme.spaceLG),
                child: Column(
                  children: [
                    // City Display (Fixed: Baghdad)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(ModernTheme.spaceMD),
                      decoration: BoxDecoration(
                        color: ModernTheme.background,
                        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                        border: Border.all(color: ModernTheme.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: ModernTheme.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: ModernTheme.spaceMD),
                          Text(
                            'بغداد',
                            style: ModernTheme.bodyMedium.copyWith(
                              color: ModernTheme.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.lock_outline,
                            color: ModernTheme.textTertiary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: ModernTheme.spaceMD),
                    
                    // Zone Selector
                    Obx(() => ModernZoneSelector(
                      selectedZone: profileController.zone.value,
                      onZoneSelected: (zone) => profileController.zone.value = zone,
                      zones: baghdadZones,
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: ModernTheme.spaceXL),
              
              // Action Buttons
              ModernCard(
                padding: const EdgeInsets.all(ModernTheme.spaceLG),
                child: Column(
                  children: [
                    // Save Button
                    ModernButton(
                      text: 'حفظ التغييرات',
                      onPressed: profileController.updataProfile,
                      isLoading: profileController.isLoading.value,
                      icon: Icons.save_outlined,
                      height: 50,
                    ),
                    
                    const SizedBox(height: ModernTheme.spaceMD),
                    
                    // Delete Account Button
                    ModernTextButton(
                      text: 'حذف الحساب',
                      onPressed: profileController.deleteConfig,
                      textColor: ModernTheme.error,
                      icon: Icons.delete_outline,
                      isUnderlined: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: ModernTheme.spaceXXL),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: ModernTheme.spaceSM),
      child: Row(
        children: [
          Icon(
            icon,
            color: ModernTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: ModernTheme.spaceSM),
          Text(
            title,
            style: ModernTheme.headline4.copyWith(
              color: ModernTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
