import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/utils/constants/style_app.dart';

import '../../../controllers/doctor_case_controller.dart';
import '../../../data/models/case_model.dart';
import '../../../data/models/category.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/more_widgets.dart';
import '../../widgets/modern/quick_filter_bar.dart';
import '../../widgets/modern/advanced_filter_panel.dart';
import '../../widgets/gender_profile_icon.dart';


class ViewCases extends StatelessWidget {
  ViewCases({super.key});
  DoctorCaseController doctorCaseController = Get.find<DoctorCaseController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Obx(() => doctorCaseController.isLoading.value
        ? _buildLoadingState()
        : _buildContent()),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'جاري تحميل الحالات...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent() {
    final statusBarHeight = MediaQuery.of(Get.context!).padding.top;
    
    return RefreshIndicator(
      displacement: 40.0,
      onRefresh: () async {
        await doctorCaseController.fetchDataCases();
        await doctorCaseController.fetchDataOmeCases();
      },
      color: ModernTheme.primaryBlue,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceSM),
        children: [
          SizedBox(height: 25),
          // Quick Filter Bar as a regular card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceSM),
            child: QuickFilterBar(
              availableZones: doctorCaseController.availableZones,
              availableCategories: doctorCaseController.categores.where((c) => c.id.isNotEmpty).toList(),
              selectedZone: doctorCaseController.zoneFilter.value,
              selectedCategory: doctorCaseController.categorySelect.value?.id == ''
                  ? null
                  : doctorCaseController.categorySelect.value,
              selectedGender: doctorCaseController.genderFilter.value,
              onZoneChanged: doctorCaseController.setZoneFilter,
              onCategoryChanged: doctorCaseController.setCategoryFilter,
              onGenderChanged: doctorCaseController.setGenderFilter,
              onShowAdvancedFilters: () => _showAdvancedFiltersBottomSheet(),
              onClearFilters: doctorCaseController.clearAllFilters,
              hasActiveFilters: doctorCaseController.hasActiveFilters,
            ),
          ),
          
          SizedBox(height: ModernTheme.spaceMD),
          
          // Cases List OR Empty State
          doctorCaseController.doctorCases.isEmpty
              ? _buildEmptyState()
              : _buildCasesList(),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceSM),
      child: Column(
        children: [
          SizedBox(height: 80),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_information_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 16),
                Text(
                  'لا توجد حالات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  doctorCaseController.hasActiveFilters
                      ? 'جرب تغيير الفلاتر أو مسحها'
                      : 'لا توجد حالات متاحة حالياً',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                if (doctorCaseController.hasActiveFilters)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: doctorCaseController.clearAllFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ModernTheme.primaryBlue,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                        ),
                      ),
                      child: Text(
                        'مسح الفلاتر',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCasesList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceSM),
      child: Column(
        children: List.generate(
          doctorCaseController.doctorCases.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: ModernTheme.spaceSM),
            child: _buildModernCaseCard(doctorCaseController.doctorCases[index], index),
          ),
        ),
      ),
    );
  }
  
  void _showAdvancedFiltersBottomSheet() {
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ModernTheme.radiusXL),
              topRight: Radius.circular(ModernTheme.radiusXL),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(ModernTheme.spaceMD),
                child: Row(
                  children: [
                    Text(
                      'الفلاتر المتقدمة',
                      style: ModernTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Advanced Filter Panel
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
                  child: Obx(() => AdvancedFilterPanel(
                    availableZones: doctorCaseController.availableZones,
                    availableCategories: doctorCaseController.categores.where((c) => c.id.isNotEmpty).toList(),
                    selectedZone: doctorCaseController.zoneFilter.value,
                    selectedCategory: doctorCaseController.categorySelect.value?.id == ''
                        ? null
                        : doctorCaseController.categorySelect.value,
                    selectedGender: doctorCaseController.genderFilter.value,
                    onZoneChanged: doctorCaseController.setZoneFilter,
                    onCategoryChanged: doctorCaseController.setCategoryFilter,
                    onGenderChanged: doctorCaseController.setGenderFilter,
                    onClearFilters: () {
                      doctorCaseController.clearAllFilters();
                      Get.back();
                    },
                    hasActiveFilters: doctorCaseController.hasActiveFilters,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Widget viewCases(int index) {
  //   CaseModel doctorCase = doctorCaseController.doctorCases[index];
  //   return Padding(
  //     padding: EdgeInsets.all(Values.circle),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(Values.circle),
  //       // viewDoctorCase
  //       onTap: () => doctorCaseController.viewCase(doctorCase),
  //       splashColor: ColorApp.primaryColor,
  //       child: Container(
  //         margin: EdgeInsets.all(Values.circle * 0.1),
  //         decoration: BoxDecoration(
  //             border: Border.all(color: ColorApp.borderColor),
  //             borderRadius: BorderRadius.circular(Values.circle),
  //             color: ColorApp.backgroundColor,
  //             boxShadow: ShadowValues.shadowValues),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Hero(
  //                 tag: doctorCase.image ?? '',
  //                 child: imageCached(doctorCase.image ?? '')),
  //             Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text('التشخيص',
  //                     style: StringStyle.textButtom
  //                         .copyWith(color: ColorApp.primaryColor))),
  //             Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(doctorCase.diagnose ?? ''))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildModernCaseCard(CaseModel caseModel, int index) {
    return GestureDetector(
      onTap: () => doctorCaseController.viewCase(caseModel),
      child: Container(
        margin: EdgeInsets.only(bottom: ModernTheme.spaceSM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
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
            // Compact Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ModernTheme.spaceMD,
                vertical: ModernTheme.spaceSM,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ModernTheme.radiusMD),
                  topRight: Radius.circular(ModernTheme.radiusMD),
                ),
              ),
              child: Row(
                children: [
                  GenderProfileIcon(
                    caseModel: caseModel,
                    size: 28,
                  ),
                  SizedBox(width: ModernTheme.spaceSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caseModel.diagnose ?? 'بدون تشخيص',
                          style: ModernTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (caseModel.date != null)
                          Text(
                            caseModel.date!,
                            style: ModernTheme.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_left, color: ModernTheme.primaryBlue, size: 24),
                ],
              ),
            ),
            
            // Compact Carousel
            Container(
              height: 160,
              child: _AutoSlidingCarousel(
                images: [
                  caseModel.imageTop,
                  caseModel.imageBottom,
                  caseModel.imageFront,
                  caseModel.imageLeft,
                  caseModel.imageRight,
                  caseModel.imageChock,
                  caseModel.imageToung,
                  caseModel.imageCheek,
                ].where((img) => img != null && img.isNotEmpty).cast<String>().toList(),
              ),
            ),
            
            // Medical Basic Info Section
            Container(
              padding: EdgeInsets.all(ModernTheme.spaceSM),
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المعلومات الطبية الاساسية',
                    style: ModernTheme.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: ModernTheme.spaceXS),
                  Wrap(
                    spacing: ModernTheme.spaceXS,
                    runSpacing: ModernTheme.spaceXS,
                    children: [
                      if (caseModel.zone != null && caseModel.zone!.isNotEmpty)
                        _buildCompactTag('المنطقة: ${caseModel.zone}', ModernTheme.primaryBlue),
                      if (caseModel.bp != null && caseModel.bp!.toLowerCase() == 'yes')
                        _buildCompactTag('ضغط الدم', Color(0xFFef4444)),
                      if (caseModel.diabetic != null && caseModel.diabetic!.toLowerCase() == 'yes')
                        _buildCompactTag('السكري', Color(0xFFf59e0b)),
                      if (caseModel.toothRemoved != null && caseModel.toothRemoved!.toLowerCase() == 'yes')
                        _buildCompactTag('قلع سن', Color(0xFF8b5cf6)),
                      if (caseModel.tf != null && caseModel.tf!.toLowerCase() == 'yes')
                        _buildCompactTag('حشوة سن', Color(0xFF06b6d4)),
                      if (caseModel.category != null)
                        _buildCompactTag(caseModel.category!, ModernTheme.primaryBlue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCompactTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  

}

// Auto-sliding Carousel Widget
class _AutoSlidingCarousel extends StatefulWidget {
  final List<String> images;

  const _AutoSlidingCarousel({required this.images});

  @override
  State<_AutoSlidingCarousel> createState() => _AutoSlidingCarouselState();
}

class _AutoSlidingCarouselState extends State<_AutoSlidingCarousel> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    if (widget.images.isNotEmpty) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
        ),
      );
    }
    

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageCached(widget.images[index]),
              ),
            );
          },
        ),
        // Page Indicators
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? ModernTheme.primaryBlue
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
