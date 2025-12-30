import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/utils/constants/style_app.dart';

import '../../../controllers/doctor_case_controller.dart';
import '../../../data/models/case_model.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/more_widgets.dart';
import '../../widgets/gender_profile_icon.dart';

class OmnCases extends StatelessWidget {
  OmnCases({super.key});
  DoctorCaseController doctorCaseController = Get.find<DoctorCaseController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => doctorCaseController.isLoading.value
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingIndicator(),
                SizedBox(height: 16),
                Text(
                  'جاري تحميل حالاتي...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : doctorCaseController.doctorOmeCases.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'لا توجد حالات مكتملة',
                      style: StringStyle.headerStyle.copyWith(
                        color: ColorApp.primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'حالاتك المكتملة والجارى علاجها ستظهر هنا',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'اسحب لأسفل للتحديث',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  print('🔄 [OmnCases] Pull-to-refresh triggered');
                  // Use the improved refreshCases method to prevent double loading
                  if (!doctorCaseController.isLoading.value) {
                    await doctorCaseController.refreshCases();
                  } else {
                    print('⏳ [OmnCases] Already loading, skipping refresh');
                  }
                },
                color: ModernTheme.primaryBlue,
                child: ListView(
                  padding: EdgeInsets.all(ModernTheme.spaceMD),
                  children: [
                    // In-Treatment Cases Section
                    if (doctorCaseController.doctorOmeCases.where((c) => c.status == 'in-treatment').isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.hourglass_empty, color: Color(0xFFf59e0b), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'قيد العلاج',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFf59e0b),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFFf59e0b),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${doctorCaseController.doctorOmeCases.where((c) => c.status == 'in-treatment').length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...doctorCaseController.doctorOmeCases
                          .where((c) => c.status == 'in-treatment')
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) => _buildModernCaseCard(entry.value, entry.key)),
                      SizedBox(height: 24),
                    ],
                    
                    // Done Cases Section
                    if (doctorCaseController.doctorOmeCases.where((c) => c.status == 'done').isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF10b981), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'الحالات المكتملة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10b981),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF10b981),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${doctorCaseController.doctorOmeCases.where((c) => c.status == 'done').length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...doctorCaseController.doctorOmeCases
                          .where((c) => c.status == 'done')
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) => _buildModernCaseCard(entry.value, entry.key)),
                    ],
                  ],
                ),
              )),
          ),
        ],
      ),
    );
  }

  // Widget viewCases(int index) {
  //   CaseModel doctorCase = doctorCaseController.doctorOmeCases[index];
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
  //             SizedBox(height: Values.circle * 0.8),
  //             Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Text('الاسم : ${doctorCase.name}',
  //                     style: StringStyle.textLabil
  //                         .copyWith(color: ColorApp.primaryColor))),
  //             Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text('الحالة',
  //                         style: StringStyle.textLabil
  //                             .copyWith(color: ColorApp.primaryColor)),
  //                     Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Text(doctorCase.status ?? '',
  //                             style: StringStyle.textLabil
  //                                 .copyWith(color: ColorApp.primaryColor)),
  //                         SizedBox(
  //                           width: 100,
  //                           child: Divider(
  //                             color: doctorCase.status == 'in-treatment'
  //                                 ? ColorApp.primaryColor
  //                                 : ColorApp.greenColor,
  //                             thickness: 2,
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 )),
  //             Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: Values.circle),
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
    // Determine status color and icon
    bool isInTreatment = caseModel.status == 'in-treatment';
    Color statusColor = isInTreatment ? Color(0xFFf59e0b) : Color(0xFF10b981);
    IconData statusIcon = isInTreatment ? Icons.hourglass_empty : Icons.check;
    String statusText = isInTreatment ? 'قيد العلاج' : 'مكتملة';
    
    return GestureDetector(
      onTap: () => doctorCaseController.viewCase(caseModel, ome: true),
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
            // Compact Header with Status Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ModernTheme.spaceMD,
                vertical: ModernTheme.spaceSM,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                caseModel.name ?? 'غير معروف',
                                style: ModernTheme.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                  Icon(Icons.chevron_left, color: statusColor, size: 24),
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
                      if (caseModel.status == 'done')
                        _buildCompactTag('حالة مكتملة', Color(0xFF10b981)),
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

// Auto-sliding Carousel Widget (same as doctor view)
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
                child: imageCached(widget.images[index], enableZoom: false),
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
