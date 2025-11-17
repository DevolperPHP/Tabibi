// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/case_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../data/models/profile_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/modern/modern_card.dart';

class StartCase extends StatelessWidget {
  StartCase({super.key});
  CaseController caseController = Get.find<CaseController>();
  ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isExistCase = false;
      Case? currentCase;
      
      if (profileController.userProfile.value != null) {
        isExistCase = profileController.userProfile.value!.userData.inCase;
        // Get the current pending case (most recent case that is not done)
        if (isExistCase && profileController.userProfile.value!.cases.isNotEmpty) {
          // Filter out completed cases and get the most recent one
          final pendingCases = profileController.userProfile.value!.cases
              .where((c) => c.status != 'done')
              .toList();
          
          if (pendingCases.isNotEmpty) {
            // Sort by sortedDate descending (most recent first)
            pendingCases.sort((a, b) {
              final aTime = int.tryParse(a.sortedDate ?? '0') ?? 0;
              final bTime = int.tryParse(b.sortedDate ?? '0') ?? 0;
              return bTime.compareTo(aTime); // Descending order (newest first)
            });
            currentCase = pendingCases.first;
          }
        }
      }
      
      return isExistCase && currentCase != null
          ? _buildCurrentCaseView(currentCase)
          : _buildStartCaseView();
    });
  }

  Widget _buildStartCaseView() {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: ModernTheme.spaceLG, right: ModernTheme.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              
              // Modern header with gradient background
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceLG),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ModernTheme.primaryBlue,
                      ModernTheme.primaryBlue.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: ModernTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon with circular background
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: ModernTheme.spaceMD),
                    
                    // Main title
                    Text(
                      'تبحث عن طبيب أسنان؟',
                      style: ModernTheme.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: ModernTheme.spaceSM),
                    
                    // Subtitle
                    Text(
                      'احصل على استشارة مهنية من أفضل أطباء الأسنان',
                      style: ModernTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: ModernTheme.spaceLG),
              
              // Feature cards
              _buildFeatureCard(
                icon: Icons.speed_rounded,
                title: 'سريع ومباشر',
                description: 'تواصل مع الأطباء المتخصصين فوراً',
              ),
              
              SizedBox(height: ModernTheme.spaceMD),
              
              _buildFeatureCard(
                icon: Icons.card_giftcard_rounded,
                title: 'احصل على العلاج مجاناً',
                description: 'استفد من العروض المجانية للحالات المحددة',
              ),
              
              SizedBox(height: ModernTheme.spaceMD),
              
              _buildFeatureCard(
                icon: Icons.support_agent_rounded,
                title: 'دعم على مدار الساعة',
                description: 'مساعدة متاحة عندما تحتاجها',
              ),
              
              SizedBox(height: ModernTheme.spaceLG),
              
              // Start button
              ModernButton(
                text: 'ابدأ الآن',
                onPressed: caseController.viewCreateCase,
                icon: Icons.arrow_back_rounded,
                isFullWidth: true,
                height: 50,
              ),
              
              SizedBox(height: ModernTheme.spaceMD),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ModernCard(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            ),
            child: Icon(
              icon,
              color: ModernTheme.primaryBlue,
              size: 20,
            ),
          ),
          
          SizedBox(width: ModernTheme.spaceMD),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ModernTheme.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: ModernTheme.bodySmall.copyWith(
                    color: ModernTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCaseView(Case caseData) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh profile data to get latest case status
        await profileController.fetchDataProfile();
      },
      color: ModernTheme.primaryBlue,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), // Enable scroll for refresh indicator
        child: Padding(
          padding: EdgeInsets.all(ModernTheme.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceLG),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ModernTheme.primaryBlue, ModernTheme.primaryBlue.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
                  boxShadow: [
                    BoxShadow(
                      color: ModernTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(height: ModernTheme.spaceMD),
                    Text(
                      'لديك حالة معلقة',
                      style: ModernTheme.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ModernTheme.spaceSM),
                    Text(
                      'سيتم الاتصال بك من قبل فريق المنصة للتاكد من حالتك',
                      style: ModernTheme.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: ModernTheme.spaceLG),

              // Case Summary Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(ModernTheme.spaceMD),
                      decoration: BoxDecoration(
                        color: _getStatusColor(caseData).withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ModernTheme.radiusLG),
                          topRight: Radius.circular(ModernTheme.radiusLG),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(ModernTheme.spaceXS),
                            decoration: BoxDecoration(
                              color: _getStatusColor(caseData),
                              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                            ),
                            child: Icon(
                              _getStatusIcon(caseData),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: ModernTheme.spaceSM),
                          Expanded(
                            child: Text(
                              _getStatusText(caseData),
                              style: ModernTheme.titleMedium.copyWith(
                                color: _getStatusColor(caseData),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ModernTheme.spaceSM,
                              vertical: ModernTheme.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(caseData),
                              borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                            ),
                            child: Text(
                              _getAdminStatusText(caseData.adminStatus ?? 'waiting'),
                              style: ModernTheme.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content - Show doctor info if in-treatment or done, otherwise show patient info
                    Padding(
                      padding: EdgeInsets.all(ModernTheme.spaceMD),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (caseData.status == 'in-treatment' || caseData.status == 'done')
                            ? [
                                // Doctor Info
                                _buildInfoRow('اسم الطبيب', caseData.doctorName ?? 'غير متوفر', Icons.badge),
                                _buildInfoRow('رقم الهاتف', caseData.doctorPhone ?? 'غير متوفر', Icons.phone),
                                _buildInfoRow('حساب التليجرام', caseData.doctorTelegram ?? 'غير متوفر', Icons.send),
                                _buildInfoRow('الجامعة', caseData.doctorUni ?? 'غير متوفر', Icons.school),
                                if (caseData.type != null)
                                  _buildInfoRow('نوع الخدمة', caseData.type!, Icons.medical_services),
                              ]
                            : [
                                // Patient Info
                                _buildInfoRow('اسم المريض', caseData.name, Icons.person),
                                _buildInfoRow('العمر', caseData.age, Icons.cake),
                                if (caseData.type != null)
                                  _buildInfoRow('نوع الخدمة', caseData.type!, Icons.medical_services),
                                _buildInfoRow('تاريخ التقديم', caseData.date ?? '', Icons.calendar_today),
                              ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ModernTheme.spaceLG),

              // View Details Button
              ModernButton(
                text: 'عرض التفاصيل الكاملة',
                onPressed: () {
                  Get.toNamed(AppRoutes.userCaseDetails, arguments: caseData);
                },
                icon: Icons.visibility,
                isFullWidth: true,
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceXS),
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
            ),
            child: Icon(
              icon,
              size: 18,
              color: ModernTheme.primaryBlue,
            ),
          ),
          SizedBox(width: ModernTheme.spaceSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ModernTheme.labelMedium.copyWith(
                    color: ModernTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: ModernTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(Case caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return Colors.red;
    
    // Done - treatment completed
    if (caseData.status == 'done') return Color(0xFF34C759); // iOS Green
    
    // In treatment - doctor is working on it
    if (caseData.status == 'in-treatment') return Color(0xFF007AFF); // iOS Blue
    
    // Accepted but waiting for doctor to take it
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return Color(0xFFFF9500); // iOS Orange - waiting for doctor
    }
    
    // Waiting for admin review
    return Color(0xFFFF9500); // iOS Orange
  }

  IconData _getStatusIcon(Case caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return Icons.cancel;
    
    // Done - treatment completed
    if (caseData.status == 'done') return Icons.check_circle;
    
    // In treatment - doctor is working on it
    if (caseData.status == 'in-treatment') return Icons.medical_services;
    
    // Accepted but waiting for doctor
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return Icons.person_search; // Waiting for doctor icon
    }
    
    // Waiting for admin review
    return Icons.hourglass_empty;
  }

  String _getStatusText(Case caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return 'مرفوضة';
    
    // Done - treatment completed
    if (caseData.status == 'done') return 'تم العلاج';
    
    // In treatment - doctor is working on it
    if (caseData.status == 'in-treatment') return 'جاري تلقي العلاج';
    
    // Accepted but waiting for doctor to take it
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return 'في انتظار طبيب';
    }
    
    // Waiting for admin review
    return 'قيد المراجعة';
  }

  String _getAdminStatusText(String adminStatus) {
    switch (adminStatus) {
      case 'accept': return 'مقبولة';
      case 'reject': return 'مرفوضة';
      case 'waiting':
      default: return 'قيد الانتظار';
    }
  }
}
