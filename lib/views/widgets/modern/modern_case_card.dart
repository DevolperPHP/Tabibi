import 'package:flutter/material.dart';
import '../../../data/models/case_model.dart';
import '../../../utils/design_system/animations.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../more_widgets.dart';

class ModernCaseCard extends StatelessWidget {
  final CaseModel caseModel;
  final VoidCallback onTap;
  final int? index;
  final bool showAdminStatus; // Show adminStatus instead of status

  const ModernCaseCard({
    super.key,
    required this.caseModel,
    required this.onTap,
    this.index,
    this.showAdminStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get available images
    List<String?> images = [
      caseModel.imageTop,
      caseModel.imageBottom,
      caseModel.imageFront,
      caseModel.imageLeft,
      caseModel.imageRight,
      caseModel.imageChock,
      caseModel.imageToung,
      caseModel.imageCheek,
    ].where((img) => img != null && img.isNotEmpty).toList();

    // Calculate animation delay based on index
    final animationDuration = Duration(milliseconds: 350 + ((index ?? 0) * 100));

    return AppAnimations.slideFromRight(
      duration: animationDuration,
      offset: 100,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: ModernTheme.spaceMD),
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
              // Image Preview Section
              if (images.isNotEmpty)
                Stack(
                  children: [
                    // Main Image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ModernTheme.radiusLG),
                        topRight: Radius.circular(ModernTheme.radiusLG),
                      ),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: imageCached(images[0]!),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ModernTheme.radiusLG),
                            topRight: Radius.circular(ModernTheme.radiusLG),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Image Counter
                    Positioned(
                      top: ModernTheme.spaceMD,
                      right: ModernTheme.spaceMD,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ModernTheme.spaceSM,
                          vertical: ModernTheme.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: ModernTheme.spaceXS),
                            Text(
                              '${images.length}',
                              style: ModernTheme.labelMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Status Badge
                    Positioned(
                      top: ModernTheme.spaceMD,
                      left: ModernTheme.spaceMD,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ModernTheme.spaceSM,
                          vertical: ModernTheme.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          gradient: showAdminStatus 
                            ? _getAdminStatusGradient(caseModel.adminStatus ?? 'waiting')
                            : _getStatusGradient(caseModel.status ?? ''),
                          borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                        ),
                        child: Text(
                          showAdminStatus 
                            ? _getAdminStatusText(caseModel.adminStatus ?? 'waiting')
                            : _getStatusText(caseModel.status ?? 'free'),
                          style: ModernTheme.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              
              // Case Info Section
              Padding(
                padding: const EdgeInsets.all(ModernTheme.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Name
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ModernTheme.spaceXS),
                          decoration: BoxDecoration(
                            color: ModernTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: 18,
                            color: ModernTheme.primaryBlue,
                          ),
                        ),
                        SizedBox(width: ModernTheme.spaceSM),
                        Expanded(
                          child: Text(
                            caseModel.name ?? 'غير معروف',
                            style: ModernTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ModernTheme.spaceSM),
                    
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: ModernTheme.textSecondary,
                        ),
                        SizedBox(width: ModernTheme.spaceXS),
                        Text(
                          caseModel.date ?? '',
                          style: ModernTheme.bodyMedium,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: ModernTheme.spaceSM),
                    
                    // Category and Service Type
                    Row(
                      children: [
                        if (caseModel.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ModernTheme.spaceSM,
                              vertical: ModernTheme.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: ModernTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                            ),
                            child: Text(
                              caseModel.category!,
                              style: ModernTheme.labelMedium.copyWith(
                                color: ModernTheme.primaryBlue,
                              ),
                            ),
                          ),
                        if (caseModel.category != null && caseModel.serviceType != null)
                          SizedBox(width: ModernTheme.spaceXS),
                        if (caseModel.serviceType != null && caseModel.serviceType!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ModernTheme.spaceSM,
                              vertical: ModernTheme.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF10b981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.medical_services,
                                  size: 14,
                                  color: Color(0xFF10b981),
                                ),
                                SizedBox(width: ModernTheme.spaceXS),
                                Text(
                                  caseModel.serviceType!,
                                  style: ModernTheme.labelMedium.copyWith(
                                    color: Color(0xFF10b981),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getStatusGradient(String status) {
    switch (status) {
      case 'free':
        // Waiting - Orange gradient (iOS Orange)
        return LinearGradient(
          colors: [Color(0xFFFF9500), Color(0xFFFF7A00)],
        );
      case 'in-treatment':
        // In Treatment - Blue gradient (iOS Blue)
        return LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
        );
      case 'done':
        // Treatment Complete - Green gradient (iOS Green)
        return LinearGradient(
          colors: [Color(0xFF34C759), Color(0xFF28A745)],
        );
      case 'payment-failed':
        // Payment Failed - Red gradient
        return LinearGradient(
          colors: [Color(0xFFFF3B30), Color(0xFFDC2626)],
        );
      default:
        // Unknown - Gray gradient
        return LinearGradient(
          colors: [Color(0xFF8E8E93), Color(0xFF6C6C70)],
        );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'free':
        return 'قيد الانتظار';
      case 'in-treatment':
        return 'قيد العلاج';
      case 'done':
        return 'تم العلاج';
      case 'payment-failed':
        return 'فشل الدفع';
      default:
        return 'غير معروف';
    }
  }

  // Admin status methods - Updated to match correct logic
  LinearGradient _getAdminStatusGradient(String adminStatus) {
    // Rejected by admin - Red
    if (adminStatus == 'reject') {
      return LinearGradient(
        colors: [Color(0xFFef4444), Color(0xFFdc2626)],
      );
    }
    
    // Done - treatment completed - Green
    if (caseModel.status == 'done') {
      return LinearGradient(
        colors: [Color(0xFF34C759), Color(0xFF28A745)], // iOS Green
      );
    }
    
    // In treatment - doctor is working on it - Blue
    if (caseModel.status == 'in-treatment') {
      return LinearGradient(
        colors: [Color(0xFF007AFF), Color(0xFF0051D5)], // iOS Blue
      );
    }
    
    // Accepted but waiting for doctor to take it - Orange
    if (adminStatus == 'accept' && caseModel.status == 'free') {
      return LinearGradient(
        colors: [Color(0xFFFF9500), Color(0xFFFF7A00)], // iOS Orange
      );
    }
    
    // Waiting for admin review - Orange
    return LinearGradient(
      colors: [Color(0xFFFF9500), Color(0xFFFF7A00)], // iOS Orange
    );
  }

  String _getAdminStatusText(String adminStatus) {
    // Rejected by admin
    if (adminStatus == 'reject') return 'مرفوضة';
    
    // Done - treatment completed
    if (caseModel.status == 'done') return 'تم العلاج';
    
    // In treatment - doctor is working on it
    if (caseModel.status == 'in-treatment') return 'جاري تلقي العلاج';
    
    // Accepted but waiting for doctor to take it
    if (adminStatus == 'accept' && caseModel.status == 'free') {
      return 'في انتظار طبيب';
    }
    
    // Waiting for admin review
    return 'قيد المراجعة';
  }
}
