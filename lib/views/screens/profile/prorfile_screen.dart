import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_doctor/routes/app_routes.dart';

import '../../../controllers/profile_controller.dart';
import '../../../controllers/case_controller.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/models/case_model.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_case_card.dart';
import '../../widgets/message_snak.dart';
import 'faq_screen.dart';

class ProrfileScreen extends StatelessWidget {
  ProrfileScreen({super.key});
  ProfileController profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Modern Profile Header
          Obx(() => _buildModernProfileHeader()),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Role Status (if applicable)
          if (profileController.userProfile.value != null &&
              !profileController.userProfile.value!.userData.isAdmin &&
              !profileController.userProfile.value!.userData.isDoctor)
            Obx(() => _buildRoleStatusCard()),
          
          SizedBox(height: ModernTheme.spaceLG),
          
          // Modern Apple-style Support Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF007AFF), // iOS Blue
                      Color(0xFF5856D6), // iOS Purple
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Support Icon with Glow Effect
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.headset_mic_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Title with Subtle Shadow
                      Text(
                        'نحن هنا لمساعدتك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'فريق الدعم الفني متاح للإجابة على استفساراتك',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Modern Contact Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final Uri url = Uri.parse('https://t.me/TabibiIQ');
                            if (!await launchUrl(url)) {
                              Get.snackbar(
                                'خطأ',
                                'لا يمكن فتح الرابط',
                                backgroundColor: Colors.red.withOpacity(0.9),
                                colorText: Colors.white,
                                icon: Icon(Icons.error_outline, color: Colors.white),
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.all(16),
                                borderRadius: 12,
                                duration: Duration(seconds: 3),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.1),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Telegram Icon with Background
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0088CC), // Telegram Blue
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                
                                SizedBox(width: 12),
                                
                                // Button Text
                                Text(
                                  'تواصل معنا عبر تليجرام',
                                  style: TextStyle(
                                    color: Color(0xFF1D1D1F), // iOS Dark Text
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                
                                Spacer(),
                                
                                // Arrow Icon
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFF86868B), // iOS Gray
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Additional Support Options
                      Row(
                        children: [
                          Expanded(
                            child: _buildSupportOption(
                              'الأسئلة الشائعة',
                              Icons.help_outline_rounded,
                              () {
                                // Navigate to FAQ
                                Get.toNamed(AppRoutes.faqScreen);
                              },
                            ),
                          ),
                          
                          SizedBox(width: 12),
                          
                          Expanded(
                            child: _buildSupportOption(
                              'البريد الإلكتروني',
                              Icons.email_outlined,
                              () {
                                // Show email dialog
                                Get.dialog(
                                  AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(Icons.email, color: ModernTheme.primaryBlue),
                                        SizedBox(width: 8),
                                        Text('البريد الإلكتروني'),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'تواصل معنا عبر البريد الإلكتروني:',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 12),
                                        SelectableText(
                                          'info@tabibi-iq.com',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: ModernTheme.primaryBlue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'يمكنك نسخ البريد الإلكتروني واستخدامه للتواصل معنا',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text('حسناً'),
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  barrierDismissible: true,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: ModernTheme.spaceXL),
          
          // Medical History Header
          Text(
            'السجل الطبي',
            style: ModernTheme.headlineMedium.copyWith(
              color: ModernTheme.primaryBlue,
            ),
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Cases List
          Obx(() => _buildCasesList()),
        ],
      ),
    );
  }
  
  Widget _buildModernProfileHeader() {
    if (profileController.userProfile.value == null) {
      if (profileController.isError.value) {
        // Show error state with retry button
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[300],
              ),
              SizedBox(height: 16),
              Text(
                'خطأ في تحميل البيانات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكد من اتصالك بالإنترنت',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => profileController.fetchDataProfile(),
                icon: Icon(Icons.refresh, size: 18),
                label: Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ModernTheme.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      } else {
        // Show loading state
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text(
                  'جاري تحميل البيانات...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    UserData userModel = profileController.userProfile.value!.userData;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header with Avatar
            Row(
              children: [
                // Modern Avatar
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF007AFF),
                        Color(0xFF5856D6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF007AFF).withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(width: 16),
                
                // User Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name with iOS Typography
                      Text(
                        userModel.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F), // iOS Dark Text
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // User Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'المدينة',
                    userModel.city,
                    Icons.location_on_rounded,
                    Color(0xFFFF9500), // iOS Orange
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'العمر',
                    '${userModel.age} سنة',
                    Icons.cake_rounded,
                    Color(0xFFAF52DE), // iOS Purple
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Modern Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildModernActionButton(
                    'تعديل',
                    Icons.edit_rounded,
                    profileController.fullDataUpdate,
                    Color(0xFF007AFF), // iOS Blue
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildModernActionButton(
                    'تسجيل الخروج',
                    Icons.logout_rounded,
                    profileController.logoutConfig,
                    Color(0xFFFF3B30), // iOS Red
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1F),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8E8E93),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernActionButton(
    String title,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
  Widget _buildRoleStatusCard() {
    if (profileController.userProfile.value == null) {
      return SizedBox.shrink();
    }
    UserData userModel = profileController.userProfile.value!.userData;
    
    return Container(
      decoration: BoxDecoration(
        gradient: ModernTheme.primaryGradient,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowLG,
      ),
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.badge,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: ModernTheme.spaceSM),
              Expanded(
                child: Text(
                  'حساب الطبيب',
                  style: ModernTheme.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (userModel.role.isEmpty || userModel.role == 'Rejected')
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.requestDoctorRole),
                  icon: Icon(Icons.add, size: 18, color: ModernTheme.primaryBlue),
                  label: Text(
                    userModel.role == 'Rejected' ? 'إعادة التقديم' : 'تقديم',
                    style: TextStyle(color: ModernTheme.primaryBlue),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                    ),
                  ),
                ),
            ],
          ),
          if (userModel.role == 'hold' || userModel.role == 'Accepted') ...[
            SizedBox(height: ModernTheme.spaceSM),
            Container(
              padding: EdgeInsets.all(ModernTheme.spaceSM),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
              ),
              child: Row(
                children: [
                  Icon(
                    userModel.role == 'hold'
                        ? Icons.hourglass_empty
                        : Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: ModernTheme.spaceSM),
                  Expanded(
                    child: Text(
                      userModel.role == 'hold'
                          ? 'تم التقديم - انتظر الموافقة'
                          : 'تم قبول الطلب',
                      style: ModernTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (userModel.role == 'Rejected') ...[
            SizedBox(height: ModernTheme.spaceSM),
            Container(
              padding: EdgeInsets.all(ModernTheme.spaceSM),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                border: Border.all(color: Colors.red.shade200, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: ModernTheme.spaceSM),
                  Expanded(
                    child: Text(
                      'تم رفض الطلب - يمكنك إعادة التقديم',
                      style: ModernTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCasesList() {
    if (profileController.userProfile.value == null) {
      if (profileController.isError.value) {
        // Show error state for cases section
        return Container(
          padding: EdgeInsets.all(ModernTheme.space2XL),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[300],
              ),
              SizedBox(height: 16),
              Text(
                'خطأ في تحميل السجل الطبي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'انقر لإعادة المحاولة',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      } else {
        // Show loading state for cases
        return Container(
          padding: EdgeInsets.all(ModernTheme.space2XL),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text(
                  'جاري تحميل السجل الطبي...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    List<Case> cases = profileController.userProfile.value!.cases;
    
    if (cases.isEmpty) {
      return Container(
        padding: EdgeInsets.all(ModernTheme.space2XL),
        child: Column(
          children: [
            Icon(
              Icons.medical_information_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: ModernTheme.spaceMD),
            Text(
              'لا توجد حالات',
              style: ModernTheme.titleLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    // Sort cases from newest to oldest using sortedDate timestamp
    List<Case> sortedCases = List.from(cases);
    sortedCases.sort((a, b) {
      // Parse sortedDate strings to integers for comparison
      int aTime = int.tryParse(a.sortedDate ?? '0') ?? 0;
      int bTime = int.tryParse(b.sortedDate ?? '0') ?? 0;
      return bTime.compareTo(aTime); // Descending order (newest first)
    });
    
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh the user profile data
        await profileController.fetchDataProfile();
      },
      child: Column(
        children: sortedCases.asMap().entries.map((entry) {
          int index = entry.key;
          Case caseItem = entry.value;
          // Convert Case to CaseModel for modern card
          CaseModel caseModel = CaseModel.fromProfileCase(caseItem);
          
          return ModernCaseCard(
            caseModel: caseModel,
            onTap: () {
              // Navigate to case details screen
              Get.toNamed(AppRoutes.userCaseDetails, arguments: caseItem);
            },
            index: index,
            showAdminStatus: true, // Show admin status (waiting/accept/reject) with colors
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildSupportOption(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
