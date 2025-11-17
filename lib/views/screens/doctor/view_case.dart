import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/doctor_case_controller.dart';
import '../../../data/models/case_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/image_carousel.dart';
import '../../widgets/more_widgets.dart';

class ViewCase extends StatelessWidget {
  ViewCase({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorCaseController doctorCaseController =
        Get.find<DoctorCaseController>();

    // Read from arguments first (most reliable)
    final arguments = Get.arguments;
    CaseModel? caseModel;
    bool isOme = false;

    if (arguments != null && arguments is Map) {
      caseModel = arguments['case'] as CaseModel?;
      isOme = arguments['isOme'] as bool? ?? false;

      // Set controller values from arguments
      if (caseModel != null) {
        doctorCaseController.doctorCase.value = caseModel;
        doctorCaseController.isOme.value = isOme;
      }
    } else {
      // Fallback to controller values
      caseModel = doctorCaseController.doctorCase.value;
      isOme = doctorCaseController.isOme.value;
    }

    if (caseModel == null) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('تفاصيل الحالة'),
              floating: true,
              elevation: 0,
              backgroundColor: ModernTheme.surface,
              foregroundColor: ModernTheme.textPrimary,
            ),
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد بيانات',
                      style: ModernTheme.bodyLarge
                          .copyWith(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ModernTheme.primaryButtonStyle,
                      child: Text('العودة'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: ModernTheme.primaryBlue,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: ModernTheme.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 16.w, bottom: 16.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.medical_services,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'تفاصيل الحالة',
                                    style: ModernTheme.headlineMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (caseModel != null)
                                    Text(
                                      caseModel!.name ?? 'مريض',
                                      style: ModernTheme.bodyMedium.copyWith(
                                        color: Colors.white.withOpacity(0.9),
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
                ),
              ),
            ),
            actions: [],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  _buildStatusCard(caseModel!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Patient Information Card
                  _buildPatientInfoCard(caseModel!, isOme),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Service Type Card
                  _buildServiceTypeCard(caseModel!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Images Section
                  _buildImagesSection(caseModel!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Medical History Section
                  _buildMedicalHistorySection(caseModel!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Case Form Section
                  _buildCaseFormSection(caseModel!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Patient Notes Section
                  _buildPatientNotesSection(caseModel!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Diagnosis Section (if exists)
                  if (caseModel!.diagnose != null &&
                      caseModel!.diagnose!.isNotEmpty) ...[
                    _buildDiagnosisSection(caseModel!),
                    SizedBox(height: ModernTheme.spaceLG),
                  ],

                  // Bottom padding for floating button
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _buildActionButton(caseModel!, isOme, doctorCaseController),
    );
  }

  Widget _buildStatusCard(CaseModel caseModel) {
    Color statusColor;
    String statusText;
    IconData statusIcon;
    LinearGradient statusGradient;

    switch (caseModel.status) {
      case 'pending':
        statusColor = ModernTheme.warning;
        statusText = 'في الانتظار';
        statusIcon = Icons.pending;
        statusGradient = LinearGradient(
          colors: [ModernTheme.warning, Colors.orange[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'in-treatment':
        statusColor = ModernTheme.info;
        statusText = 'قيد العلاج';
        statusIcon = Icons.medical_services;
        statusGradient = LinearGradient(
          colors: [ModernTheme.info, Colors.blue[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case 'completed':
        statusColor = ModernTheme.success;
        statusText = 'مكتمل';
        statusIcon = Icons.check_circle;
        statusGradient = ModernTheme.successGradient;
        break;
      case 'rejected':
        statusColor = ModernTheme.error;
        statusText = 'مرفوض';
        statusIcon = Icons.cancel;
        statusGradient = LinearGradient(
          colors: [ModernTheme.error, Colors.red[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      default:
        statusColor = Colors.amber[600]!;
        statusText = 'حالة متاحة';
        statusIcon = Icons.check_circle_outline;
        statusGradient = LinearGradient(
          colors: [Colors.amber[600]!, Colors.amber[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        gradient: statusGradient,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowMD,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceSM),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            ),
            child: Icon(
              statusIcon,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة الحالة',
                  style: ModernTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  statusText,
                  style: ModernTheme.headlineMedium.copyWith(
                    color: Colors.white,
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

  Widget _buildPatientInfoCard(CaseModel caseModel, bool isOme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                child: Icon(
                  Icons.person,
                  color: ModernTheme.primaryBlue,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Text(
                'معلومات المريض',
                style: ModernTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          if (isOme) ...[
            _buildInfoRow(Icons.person, 'الاسم', caseModel.name ?? 'غير معروف'),
            _buildInfoRow(
                Icons.wc, 'الجنس', _translateGender(caseModel.gender)),
            _buildInfoRow(
                Icons.cake, 'العمر', '${caseModel.age ?? 'غير محدد'} سنة'),
            _buildInfoRow(
                Icons.location_on, 'المنطقة', caseModel.zone ?? 'غير محدد'),
            if (caseModel.phone != null && caseModel.phone!.isNotEmpty)
              _buildInfoRow(Icons.phone, 'الهاتف', caseModel.phone,
                  isSelectable: true),
            if (caseModel.telegram != null && caseModel.telegram!.isNotEmpty)
              _buildInfoRow(Icons.telegram, 'التيليجرام', caseModel.telegram,
                  isSelectable: true),
          ] else ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              decoration: BoxDecoration(
                color: ModernTheme.primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                border:
                    Border.all(color: ModernTheme.primaryBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    color: ModernTheme.primaryBlue,
                    size: 20,
                  ),
                  SizedBox(width: ModernTheme.spaceSM),
                  Expanded(
                    child: Text(
                      'معلومات المريض الشخصية (الاسم، الهاتف، التيليجرام) ستظهر بعد طلب الحالة',
                      style: ModernTheme.bodyMedium.copyWith(
                        color: ModernTheme.primaryBlue,
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

  Widget _buildInfoRow(IconData icon, String label, String? value,
      {bool isSelectable = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      child: Row(
        children: [
          Icon(
            icon,
            color: ModernTheme.primaryBlue,
            size: 18,
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Text(
            '$label: ',
            style: ModernTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: isSelectable
                ? SelectableText(
                    value ?? 'غير محدد',
                    style: ModernTheme.bodyMedium.copyWith(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    value ?? 'غير محدد',
                    style: ModernTheme.bodyMedium,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard(CaseModel caseModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              gradient: ModernTheme.primaryGradient,
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            ),
            child: Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نوع الخدمة',
                  style: ModernTheme.bodyMedium.copyWith(
                    color: ModernTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  caseModel.serviceType ?? 'معالجة الاسنان',
                  style: ModernTheme.titleLarge.copyWith(
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

  Widget _buildImagesSection(CaseModel caseModel) {
    List<String?> allImages = [
      caseModel.imageTop,
      caseModel.imageBottom,
      caseModel.imageFront,
      caseModel.imageLeft,
      caseModel.imageRight,
      caseModel.imageChock,
      caseModel.imageToung,
      caseModel.imageCheek,
    ];

    // Filter out null images
    List<String> validImages = allImages
        .where((img) => img != null && img.isNotEmpty)
        .cast<String>()
        .toList();

    if (validImages.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(ModernTheme.spaceMD),
        decoration: BoxDecoration(
          color: ModernTheme.surface,
          borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
          boxShadow: ModernTheme.shadowSM,
        ),
        child: Column(
          children: [
            Icon(
              Icons.image_not_supported,
              size: 48,
              color: ModernTheme.textTertiary,
            ),
            SizedBox(height: ModernTheme.spaceSM),
            Text(
              'لا توجد صور متاحة',
              style: ModernTheme.bodyMedium.copyWith(
                color: ModernTheme.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ModernTheme.spaceSM),
                  decoration: BoxDecoration(
                    color: ModernTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: ModernTheme.primaryBlue,
                    size: 24,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Text(
                  'صور الحالة',
                  style: ModernTheme.titleLarge,
                ),
              ],
            ),
          ),
          Container(
            height: 250.h,
            margin: EdgeInsets.only(bottom: ModernTheme.spaceMD),
            child: PageView.builder(
              itemCount: validImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (validImages.isNotEmpty &&
                        index < validImages.length &&
                        validImages[index] != null) {
                      showImageCarousel(context, validImages,
                          initialIndex: index);
                    }
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                      boxShadow: ModernTheme.shadowSM,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          imageCached(validImages[index]),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.all(ModernTheme.spaceSM),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(
                                    ModernTheme.radiusFull),
                              ),
                              child: Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ModernTheme.spaceMD,
                                vertical: ModernTheme.spaceSM,
                              ),
                              decoration: BoxDecoration(
                                color: ModernTheme.primaryBlue.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(
                                    ModernTheme.radiusFull),
                              ),
                              child: Text(
                                '${index + 1} / ${validImages.length}',
                                style: ModernTheme.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: ModernTheme.spaceMD),
            child: Text(
              'اسحب لعرض المزيد من الصور',
              style: ModernTheme.bodySmall.copyWith(
                color: ModernTheme.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalHistorySection(CaseModel caseModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                child: Icon(
                  Icons.favorite,
                  color: ModernTheme.error,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Text(
                'التاريخ الطبي',
                style: ModernTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),

          // Medical History Questions
          _buildMedicalQuestion(
            'هل تعاني من ارتفاع ضغط الدم؟',
            caseModel.bp ?? '',
            Icons.favorite_border,
          ),
          _buildMedicalQuestion(
            'هل تعاني من السكري؟',
            caseModel.diabetic ?? '',
            Icons.opacity,
          ),
          _buildMedicalQuestion(
            'هل لديك مشاكل بالقلب؟',
            caseModel.heartProblems ?? '',
            Icons.favorite,
          ),
          _buildMedicalQuestion(
            'هل سبق واجريت عملية جراحية؟',
            caseModel.surgicalOperations ?? '',
            Icons.local_hospital,
          ),
          _buildMedicalQuestion(
            'هل تعاني من اي مرض حالي؟',
            caseModel.currentDisease ?? '',
            Icons.sick,
          ),

          // Current disease details if exists
          if (caseModel.currentDisease?.toLowerCase() == 'yes' &&
              caseModel.currentDiseaseDetails != null &&
              caseModel.currentDiseaseDetails!.isNotEmpty) ...[
            SizedBox(height: ModernTheme.spaceSM),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              decoration: BoxDecoration(
                color: ModernTheme.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                border: Border.all(color: ModernTheme.error.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تفاصيل المرض الحالي:',
                    style: ModernTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ModernTheme.error,
                    ),
                  ),
                  SizedBox(height: ModernTheme.spaceSM),
                  Text(
                    caseModel.currentDiseaseDetails!,
                    style: ModernTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicalQuestion(String question, String? answer, IconData icon) {
    String translatedAnswer = _translateAnswer(answer);
    Color answerColor;
    IconData answerIcon;

    // Determine color and icon based on answer
    switch (answer?.toLowerCase()) {
      case 'yes':
        answerColor = ModernTheme.error;
        answerIcon = Icons.check_circle;
        break;
      case 'no':
        answerColor = ModernTheme.success;
        answerIcon = Icons.cancel;
        break;
      case 'unknown':
        answerColor = ModernTheme.warning;
        answerIcon = Icons.help;
        break;
      default:
        answerColor = ModernTheme.textSecondary;
        answerIcon = Icons.info;
    }

    return Container(
      margin: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceSM),
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
            ),
            child: Icon(
              icon,
              color: ModernTheme.primaryBlue,
              size: 20,
            ),
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Expanded(
            child: Text(
              question,
              style: ModernTheme.bodyMedium,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ModernTheme.spaceSM,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: answerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  answerIcon,
                  color: answerColor,
                  size: 16,
                ),
                SizedBox(width: 4.w),
                Text(
                  translatedAnswer,
                  style: ModernTheme.bodySmall.copyWith(
                    color: answerColor,
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

  Widget _buildCaseFormSection(CaseModel caseModel) {
    // Determine service type from case
    String serviceType = caseModel.serviceType ?? 'معالجة الاسنان';

    // Build service-specific question list
    List<Map<String, dynamic>> serviceQuestions = [];

    if (serviceType == 'معالجة الاسنان') {
      serviceQuestions = [
        {
          'question': 'هل تعاني من ألم مستمر؟',
          'answer': caseModel.painContinues ?? ''
        },
        {
          'question': 'هل يؤلمك السن عند العض أو الأكل؟',
          'answer': caseModel.painEat ?? ''
        },
        if (caseModel.painEat?.toLowerCase() == 'yes' &&
            caseModel.painEatType != null)
          {'question': 'نوع الألم', 'answer': caseModel.painEatType ?? ''},
        {
          'question': 'هل تعاني من ألم عند شرب السوائل الباردة؟',
          'answer': caseModel.painCaildDrink ?? ''
        },
        if (caseModel.painCaildDrink?.toLowerCase() == 'yes' &&
            caseModel.painCaildDrinkType != null)
          {
            'question': 'مدة الألم',
            'answer': caseModel.painCaildDrinkType ?? ''
          },
        {
          'question': 'هل تعاني من ألم عند شرب السوائل الحارة؟',
          'answer': caseModel.painHotDrink ?? ''
        },
        {
          'question': 'ألم يوقظك من النوم أو يمنعك من النوم؟',
          'answer': caseModel.painSleep ?? ''
        },
        {
          'question': 'هل تعاني من إلتهاب أو خراج في السن؟',
          'answer': caseModel.inflamation ?? ''
        },
        {
          'question': 'وجود حركة بالأسنان؟',
          'answer': caseModel.teethMovement ?? ''
        },
      ];
    } else if (serviceType == 'تنظيف الاسنان') {
      serviceQuestions = [
        {
          'question': 'وجود حركة في الأسنان',
          'answer': caseModel.teethMovement ?? ''
        },
        {
          'question': 'وجود تكلسات أو جير',
          'answer': caseModel.calcifications ?? ''
        },
        {'question': 'وجود تصبغات', 'answer': caseModel.pigmentation ?? ''},
        {
          'question': 'ألم مستمر في اللثة',
          'answer': caseModel.painContinuesGum ?? ''
        },
        {
          'question': 'ألم في اللثة أثناء الأكل',
          'answer': caseModel.painEatGum ?? ''
        },
        {
          'question': 'نزيف عن التفريش',
          'answer': caseModel.bleedingDuringBrushing ?? ''
        },
      ];
    } else if (serviceType == 'تعويض الاسنان') {
      serviceQuestions = [
        {
          'question': 'وجود تكلسات أو جير؟',
          'answer': caseModel.calcifications ?? ''
        },
        {
          'question': 'وجود حركة بالأسنان؟',
          'answer': caseModel.teethMovement ?? ''
        },
        {'question': 'وجود جذور اسنان تالفة؟', 'answer': caseModel.roots ?? ''},
        {
          'question': 'وجود التهاب في الفم؟',
          'answer': caseModel.mouthInflammation ?? ''
        },
        {
          'question': 'وجود تقرحات في الفم؟',
          'answer': caseModel.mouthUlcer ?? ''
        },
        {
          'question': 'وجود تسوس في الأسنان؟',
          'answer': caseModel.toothDecay ?? ''
        },
      ];
    }

    if (serviceQuestions.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                child: Icon(
                  Icons.assignment,
                  color: ModernTheme.info,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Text(
                'استمارة $serviceType',
                style: ModernTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          ...serviceQuestions
              .map((q) => _buildFormQuestion(q['question'], q['answer']))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildFormQuestion(String question, String? answer) {
    String translatedAnswer = _translateAnswer(answer);
    Color answerColor;

    // Determine color based on answer
    switch (answer?.toLowerCase()) {
      case 'yes':
        answerColor = ModernTheme.error;
        break;
      case 'no':
        answerColor = ModernTheme.success;
        break;
      case 'unknown':
        answerColor = ModernTheme.warning;
        break;
      default:
        answerColor = ModernTheme.textSecondary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              question,
              style: ModernTheme.bodyMedium,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ModernTheme.spaceSM,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: answerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
            ),
            child: Text(
              translatedAnswer,
              style: ModernTheme.bodySmall.copyWith(
                color: answerColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientNotesSection(CaseModel caseModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                child: Icon(
                  Icons.note,
                  color: ModernTheme.warning,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Text(
                'ملاحظات الطبيب',
                style: ModernTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            ),
            child: Text(
              caseModel.note ?? 'لا توجد ملاحظات',
              style: ModernTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisSection(CaseModel caseModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                child: Icon(
                  Icons.medical_information,
                  color: ModernTheme.success,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Text(
                'التشخيص',
                style: ModernTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.success.withOpacity(0.05),
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              border: Border.all(color: ModernTheme.success.withOpacity(0.2)),
            ),
            child: Text(
              caseModel.diagnose ?? '',
              style: ModernTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(CaseModel caseModel, bool isOme,
      DoctorCaseController doctorCaseController) {
    if (isOme) {
      if (caseModel.status == 'in-treatment') {
        return Container(
          height: 50.h,
          margin: EdgeInsets.symmetric(horizontal: ModernTheme.spaceLG),
          decoration: BoxDecoration(
            gradient: ModernTheme.successGradient,
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            boxShadow: ModernTheme.shadowMD,
          ),
          child: ElevatedButton(
            onPressed: () => doctorCaseController.markCaseAsDone(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: ModernTheme.spaceSM),
                Text(
                  'إنهاء الحالة',
                  style: ModernTheme.titleMedium.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    } else {
      return Container(
        height: 50.h,
        margin: EdgeInsets.symmetric(horizontal: ModernTheme.spaceLG),
        decoration: BoxDecoration(
          gradient: ModernTheme.primaryGradient,
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
          boxShadow: ModernTheme.shadowMD,
        ),
        child: ElevatedButton(
          onPressed: () => Get.toNamed(AppRoutes.paymentGateway),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, color: Colors.white),
              SizedBox(width: ModernTheme.spaceSM),
              Text(
                'اختيار الحالة',
                style: ModernTheme.titleMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }

  String _translateAnswer(String? answer) {
    if (answer == null || answer.isEmpty) return 'غير محدد';
    switch (answer.toLowerCase()) {
      case 'yes':
        return 'نعم';
      case 'no':
        return 'لا';
      case 'unknown':
        return 'لا أعلم';
      default:
        return answer;
    }
  }

  String _translateGender(String? gender) {
    if (gender == null || gender.isEmpty) return 'غير محدد';
    switch (gender.toLowerCase()) {
      case 'male':
        return 'ذكر';
      case 'female':
        return 'أنثى';
      default:
        return gender;
    }
  }
}
