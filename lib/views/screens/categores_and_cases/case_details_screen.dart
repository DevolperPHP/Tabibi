import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/routes/app_routes.dart';
import '../../../controllers/category_controller.dart';
import '../../../data/models/case_model.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/more_widgets.dart';
import '../../widgets/image_carousel.dart';
import '../../widgets/zoomable_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../utils/constants/api_constants.dart';

class CaseDetailsScreen extends StatelessWidget {
  CaseDetailsScreen({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: Obx(() {
        if (categoryController.isLoadingCaseDetails.value) {
          return Center(
            child: CircularProgressIndicator(
              color: ModernTheme.primaryBlue,
            ),
          );
        }
        
        if (categoryController.caseSelect.value == null) {
          return Center(
            child: Text(
              'لم يتم العثور على بيانات الحالة',
              style: ModernTheme.titleLarge,
            ),
          );
        }
        
        return CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: ModernTheme.primaryBlue,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'تفاصيل الحالة',
                  style: ModernTheme.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(ModernTheme.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Card
                    _buildStatusCard(categoryController.caseSelect.value!),
                    SizedBox(height: ModernTheme.spaceLG),

                    // Service Type Card
                    if (categoryController.caseSelect.value!.serviceType != null && 
                        categoryController.caseSelect.value!.serviceType!.isNotEmpty)
                      _buildServiceTypeCard(categoryController.caseSelect.value!),
                    
                    if (categoryController.caseSelect.value!.serviceType != null && 
                        categoryController.caseSelect.value!.serviceType!.isNotEmpty)
                      SizedBox(height: ModernTheme.spaceLG),

                    // Patient Info Card
                    _buildPatientInfoCard(categoryController.caseSelect.value!),
                    SizedBox(height: ModernTheme.spaceLG),

                    // Medical History Card
                    _buildMedicalHistoryCard(categoryController.caseSelect.value!),
                    SizedBox(height: ModernTheme.spaceLG),

                    // Service Details Card
                    _buildServiceDetailsCard(categoryController.caseSelect.value!),
                    SizedBox(height: ModernTheme.spaceLG),

                    // Doctor Info Card (for in-treatment cases)
                    if (categoryController.caseSelect.value!.status == 'in-treatment')
                      _buildDoctorInfoCard(categoryController.caseSelect.value!),

                    if (categoryController.caseSelect.value!.status == 'in-treatment')
                      SizedBox(height: ModernTheme.spaceLG),

                    // Images Card
                    _buildImagesCard(context, categoryController.caseSelect.value!),
                    SizedBox(height: ModernTheme.spaceLG),

                    // Patient Notes Card
                    if (categoryController.caseSelect.value!.note != null && 
                        categoryController.caseSelect.value!.note!.isNotEmpty) ...[
                      _buildNotesCard(categoryController.caseSelect.value!),
                      SizedBox(height: ModernTheme.spaceLG),
                    ],

                    // Action Buttons
                    _buildActionButtons(categoryController.caseSelect.value!),

                    SizedBox(height: ModernTheme.space2XL),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Status Card with beautiful gradient
  Widget _buildStatusCard(CaseModel caseData) {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceLG),
      decoration: BoxDecoration(
        gradient: _getStatusGradient(caseData),
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(caseData).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getStatusIcon(caseData),
            color: Colors.white,
            size: 48,
          ),
          SizedBox(height: ModernTheme.spaceMD),
          Text(
            _getStatusTitle(caseData),
            style: ModernTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ModernTheme.spaceSM),
          Text(
            _getStatusDescription(caseData),
            style: ModernTheme.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          if (caseData.adminStatus == 'reject' && caseData.rejectNote != null && caseData.rejectNote!.isNotEmpty) ...[
            SizedBox(height: ModernTheme.spaceMD),
            Container(
              padding: EdgeInsets.all(ModernTheme.spaceMD),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سبب الرفض:',
                    style: ModernTheme.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ModernTheme.spaceXS),
                  Text(
                    caseData.rejectNote!,
                    style: ModernTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.95),
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

  // Service Type Card
  Widget _buildServiceTypeCard(CaseModel caseData) {
    return _buildCard(
      title: 'نوع الخدمة',
      icon: Icons.medical_services,
      gradient: LinearGradient(
        colors: [ModernTheme.primaryBlue.withOpacity(0.1), ModernTheme.primaryBlue.withOpacity(0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      children: [
        Container(
          padding: EdgeInsets.all(ModernTheme.spaceMD),
          decoration: BoxDecoration(
            color: ModernTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            border: Border.all(color: ModernTheme.primaryBlue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.medical_services, color: ModernTheme.primaryBlue, size: 24),
              SizedBox(width: ModernTheme.spaceSM),
              Expanded(
                child: Text(
                  caseData.serviceType!,
                  style: ModernTheme.titleMedium.copyWith(
                    color: ModernTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Patient Info Card
  Widget _buildPatientInfoCard(CaseModel caseData) {
    return _buildCard(
      title: 'معلومات المريض',
      icon: Icons.person,
      children: [
        _buildInfoRow('الاسم', caseData.name ?? 'غير معروف', Icons.badge),
        _buildInfoRow('العمر', caseData.age != null ? '${caseData.age} سنة' : 'غير متوفر', Icons.cake),
        _buildInfoRow('الجنس', _translateGender(caseData.gender), Icons.wc),
        _buildInfoRow('المنطقة', caseData.zone ?? 'غير متوفر', Icons.location_on),
        _buildInfoRow('رقم الهاتف', caseData.phone ?? 'غير متوفر', Icons.phone),
        _buildInfoRow('حساب التليجرام', caseData.telegram ?? 'غير متوفر', Icons.send),
        _buildInfoRow('تاريخ التقديم', caseData.date ?? 'غير متوفر', Icons.calendar_today),
      ],
    );
  }

  // Medical History Card
  Widget _buildMedicalHistoryCard(CaseModel caseData) {
    return _buildCard(
      title: 'التاريخ الطبي',
      icon: Icons.medical_services,
      children: [
        _buildMedicalRow('ضغط الدم', caseData.bp),
        _buildMedicalRow('السكري', caseData.diabetic),
        _buildMedicalRow('هل لديك مشاكل بالقلب؟', caseData.heartProblems),
        _buildMedicalRow('هل سبق واجريت عملية جراحية؟', caseData.surgicalOperations),
        _buildMedicalRow('هل تعاني من اي مرض حالي؟', caseData.currentDisease),
        if (caseData.currentDisease == 'yes' && caseData.currentDiseaseDetails != null && caseData.currentDiseaseDetails!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: ModernTheme.spaceSM, right: ModernTheme.spaceLG),
            child: Row(
              children: [
                Icon(Icons.subdirectory_arrow_right, color: ModernTheme.primaryBlue.withOpacity(0.7), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تفاصيل المرض: ${caseData.currentDiseaseDetails}',
                    style: ModernTheme.bodyMedium.copyWith(
                      color: ModernTheme.primaryBlue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Service Details Card
  Widget _buildServiceDetailsCard(CaseModel caseData) {
    return _buildCard(
      title: 'تفاصيل الخدمة',
      icon: Icons.medical_information,
      children: [
        SizedBox(height: ModernTheme.spaceSM),
        Text(
          'الأعراض والحالة:',
          style: ModernTheme.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: ModernTheme.textPrimary,
          ),
        ),
        SizedBox(height: ModernTheme.spaceSM),
        ..._buildSymptomsList(caseData),
      ],
    );
  }

  // Images Card
  Widget _buildImagesCard(BuildContext context, CaseModel caseData) {
    List<MapEntry<String, String>> images = _getAvailableImages(caseData);
    
    if (images.isEmpty) {
      return SizedBox.shrink();
    }

    return _buildCard(
      title: 'صور الحالة',
      icon: Icons.photo_library,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: ModernTheme.spaceMD,
            mainAxisSpacing: ModernTheme.spaceMD,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (ctx, index) {
            return _buildImageTile(context, images[index].key, images[index].value);
          },
        ),
      ],
    );
  }

  // Notes Card
  Widget _buildNotesCard(CaseModel caseData) {
    return _buildCard(
      title: 'ملاحظات المريض',
      icon: Icons.note,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(ModernTheme.spaceMD),
          decoration: BoxDecoration(
            color: ModernTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            border: Border.all(color: ModernTheme.divider),
          ),
          child: Text(
            caseData.note!,
            style: ModernTheme.bodyLarge.copyWith(
              color: ModernTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // Helper: Build Card Container
  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Gradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.05),
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
                    color: ModernTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: ModernTheme.spaceSM),
                Text(
                  title,
                  style: ModernTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ModernTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Card Content
          Padding(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Build Info Row
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: ModernTheme.primaryBlue.withOpacity(0.7)),
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
                    color: ModernTheme.textPrimary,
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

  // Helper: Build Medical Row
  Widget _buildMedicalRow(String label, String? value) {
    bool isYes = value?.toLowerCase() == 'yes';
    bool isNo = value?.toLowerCase() == 'no';
    
    return Padding(
      padding: EdgeInsets.only(bottom: ModernTheme.spaceSM),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isYes 
                  ? Colors.red[50] 
                  : isNo 
                      ? Colors.green[50] 
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
            ),
            child: Icon(
              isYes 
                  ? Icons.warning_amber_rounded 
                  : isNo 
                      ? Icons.check_circle 
                      : Icons.help_outline,
              size: 20,
              color: isYes 
                  ? Colors.red[700] 
                  : isNo 
                      ? Colors.green[700] 
                      : Colors.grey[600],
            ),
          ),
          SizedBox(width: ModernTheme.spaceSM),
          Expanded(
            child: Text(
              label,
              style: ModernTheme.bodyMedium.copyWith(
                color: ModernTheme.textPrimary,
              ),
            ),
          ),
          Text(
            isYes ? 'نعم' : isNo ? 'لا' : 'غير محدد',
            style: ModernTheme.labelLarge.copyWith(
              color: isYes 
                  ? Colors.red[700] 
                  : isNo 
                      ? Colors.green[700] 
                      : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Build Symptoms List
  List<Widget> _buildSymptomsList(CaseModel caseData) {
    List<Widget> symptoms = [];
    
    // Map of all possible symptoms with their Arabic labels
    Map<String, String> symptomLabels = {
      'painContinues': 'ألم مستمر',
      'painEat': 'ألم عند الأكل',
      'painCaildDrink': 'ألم مع المشروبات الباردة',
      'painHotDrink': 'ألم مع المشروبات الساخنة',
      'painSleep': 'ألم يمنع النوم',
      'inflamation': 'التهاب',
      'teethMovement': 'حركة الأسنان',
      'calcifications': 'تكلسات',
      'pigmentation': 'تصبغات',
      'painContinuesGum': 'ألم مستمر في اللثة',
      'painEatGum': 'ألم في اللثة عند الأكل',
      'bleedingDuringBrushing': 'نزيف عن التفريش',
      'roots': 'جذور',
      'mouthInflammation': 'التهاب الفم',
      'mouthUlcer': 'تقرحات الفم',
      'toothDecay': 'تسوس الأسنان',
    };

    // Check each symptom
    symptomLabels.forEach((key, label) {
      String? value;
      switch (key) {
        case 'painContinues':
          value = caseData.painContinues;
          break;
        case 'painEat':
          value = caseData.painEat;
          break;
        case 'painCaildDrink':
          value = caseData.painCaildDrink;
          break;
        case 'painHotDrink':
          value = caseData.painHotDrink;
          break;
        case 'painSleep':
          value = caseData.painSleep;
          break;
        case 'inflamation':
          value = caseData.inflamation;
          break;
        case 'teethMovement':
          value = caseData.teethMovement;
          break;
        case 'calcifications':
          value = caseData.calcifications;
          break;
        case 'pigmentation':
          value = caseData.pigmentation;
          break;
        case 'painContinuesGum':
          value = caseData.painContinuesGum;
          break;
        case 'painEatGum':
          value = caseData.painEatGum;
          break;
        case 'bleedingDuringBrushing':
          value = caseData.bleedingDuringBrushing;
          break;
        case 'roots':
          value = caseData.roots;
          break;
        case 'mouthInflammation':
          value = caseData.mouthInflammation;
          break;
        case 'mouthUlcer':
          value = caseData.mouthUlcer;
          break;
        case 'toothDecay':
          value = caseData.toothDecay;
          break;
      }

      if (value != null && value.toLowerCase() == 'yes') {
        symptoms.add(_buildSymptomChip(label));
        
        // Add sub-question if exists
        if (key == 'painEat' && caseData.painEatType != null) {
          symptoms.add(_buildSubSymptomChip(caseData.painEatType!));
        }
        if (key == 'painCaildDrink' && caseData.painCaildDrinkType != null) {
          symptoms.add(_buildSubSymptomChip(caseData.painCaildDrinkType!));
        }
      }
    });

    if (symptoms.isEmpty) {
      symptoms.add(
        Text(
          'لا توجد أعراض محددة',
          style: ModernTheme.bodyMedium.copyWith(
            color: ModernTheme.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return symptoms;
  }

  // Helper: Build Symptom Chip
  Widget _buildSymptomChip(String label) {
    return Container(
      margin: EdgeInsets.only(bottom: ModernTheme.spaceXS),
      padding: EdgeInsets.symmetric(
        horizontal: ModernTheme.spaceSM,
        vertical: ModernTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.red[700]),
          SizedBox(width: ModernTheme.spaceXS),
          Text(
            label,
            style: ModernTheme.bodyMedium.copyWith(
              color: Colors.red[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Build Sub-Symptom Chip
  Widget _buildSubSymptomChip(String label) {
    return Container(
      margin: EdgeInsets.only(bottom: ModernTheme.spaceXS, right: ModernTheme.spaceLG),
      padding: EdgeInsets.symmetric(
        horizontal: ModernTheme.spaceSM,
        vertical: ModernTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.subdirectory_arrow_left, size: 16, color: Colors.orange[700]),
          SizedBox(width: ModernTheme.spaceXS),
          Flexible(
            child: Text(
              label,
              style: ModernTheme.bodySmall.copyWith(
                color: Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Build Image Tile
  Widget _buildImageTile(BuildContext context, String label, String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Show zoomable full image - pass only the image filename
        showZoomableImage(context, imageUrl, title: label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
          boxShadow: ModernTheme.shadowSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ModernTheme.radiusMD),
                  topRight: Radius.circular(ModernTheme.radiusMD),
                ),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConstants.baseUrlImage}${imageUrl.trim()}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ModernTheme.primaryBlue,
                      ),
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ModernTheme.spaceXS),
              child: Text(
                label,
                style: ModernTheme.labelMedium.copyWith(
                  color: ModernTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Get Available Images
  List<MapEntry<String, String>> _getAvailableImages(CaseModel caseData) {
    List<MapEntry<String, String>> images = [];
    
    Map<String, String> imageLabels = {
      'imageFront': 'الأسنان الأمامية',
      'imageChock': 'السطح الماضغ',
      'imageCheek': 'السطح الخدي',
      'imageToung': 'السطح اللساني',
      'imageLeft': 'الجانب الأيسر',
      'imageRight': 'الجانب الأيمن',
      'imageTop': 'الأسنان العلوية',
      'imageBottom': 'الأسنان السفلية',
    };

    imageLabels.forEach((key, label) {
      String? imageUrl;
      switch (key) {
        case 'imageFront':
          imageUrl = caseData.imageFront;
          break;
        case 'imageChock':
          imageUrl = caseData.imageChock;
          break;
        case 'imageCheek':
          imageUrl = caseData.imageCheek;
          break;
        case 'imageToung':
          imageUrl = caseData.imageToung;
          break;
        case 'imageLeft':
          imageUrl = caseData.imageLeft;
          break;
        case 'imageRight':
          imageUrl = caseData.imageRight;
          break;
        case 'imageTop':
          imageUrl = caseData.imageTop;
          break;
        case 'imageBottom':
          imageUrl = caseData.imageBottom;
          break;
      }

      if (imageUrl != null && imageUrl.isNotEmpty) {
        images.add(MapEntry(label, imageUrl));
      }
    });

    return images;
  }

  // Helper: Get Status Gradient
  LinearGradient _getStatusGradient(CaseModel caseData) {
    // Rejected by admin - Red
    if (caseData.adminStatus == 'reject') {
      return LinearGradient(
        colors: [Color(0xFFef4444), Color(0xFFdc2626)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    
    // Accepted by admin - Green
    if (caseData.adminStatus == 'accept') {
      return LinearGradient(
        colors: [Color(0xFF34C759), Color(0xFF28A745)], // iOS Green
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    
    // Waiting for admin review - Orange
    return LinearGradient(
      colors: [Color(0xFFFF9500), Color(0xFFFF7A00)], // iOS Orange
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Helper: Get Status Color
  Color _getStatusColor(CaseModel caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return Color(0xFFef4444);
    
    // Accepted by admin
    if (caseData.adminStatus == 'accept') return Color(0xFF34C759); // iOS Green
    
    // Waiting for admin review
    return Color(0xFFFF9500); // iOS Orange
  }

  // Helper: Get Status Icon
  IconData _getStatusIcon(CaseModel caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return Icons.cancel;
    
    // Accepted by admin
    if (caseData.adminStatus == 'accept') return Icons.check_circle;
    
    // Waiting for admin review
    return Icons.hourglass_empty;
  }

  // Helper: Get Status Title
  String _getStatusTitle(CaseModel caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return 'تم رفض الحالة';
    
    // Accepted by admin
    if (caseData.adminStatus == 'accept') return 'تم قبول الحالة';
    
    // Waiting for admin review
    return 'في انتظار الموافقة';
  }

  // Helper: Get Status Description
  String _getStatusDescription(CaseModel caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') {
      return 'تم رفض الحالة من قبل الإدارة.';
    }
    
    // Accepted by admin
    if (caseData.adminStatus == 'accept') {
      return 'تم قبول الحالة من قبل الإدارة وهي متاحة للأطباء.';
    }
    
    // Waiting for admin review
    return 'تم استلام الحالة وجاري مراجعتها من قبل الإدارة.';
  }

  // Helper: Build Action Buttons
  Widget _buildActionButtons(CaseModel caseData) {
    // Different buttons based on adminStatus
    if (caseData.adminStatus == 'waiting') {
      // Waiting cases: Accept/Reject
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.acceptCaseScreen);
                  },
                  icon: Icon(Icons.check_circle, color: Colors.white, size: 24),
                  label: Text(
                    'قبول',
                    style: ModernTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ModernTheme.success,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.rejectCaseScreen);
                  },
                  icon: Icon(Icons.cancel, color: Colors.white, size: 24),
                  label: Text(
                    'رفض',
                    style: ModernTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ModernTheme.error,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          // Delete button for waiting cases
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => categoryController.deleteCase(caseData),
              icon: Icon(Icons.delete_outline, color: Colors.white, size: 24),
              label: Text(
                'حذف الحالة',
                style: ModernTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.redColor,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      );
    } else if (caseData.adminStatus == 'accept') {
      // Accepted cases: Re-Review button
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => categoryController.reReviewCase(caseData),
              icon: Icon(Icons.refresh, color: Colors.white, size: 24),
              label: Text(
                'إعادة المراجعة',
                style: ModernTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.orangeColor,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      );
    } else if (caseData.adminStatus == 'reject') {
      // Rejected cases: Delete and Accept buttons on top, Re-Review button full width below
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First row: Delete and Accept buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => categoryController.deleteCase(caseData),
                  icon: Icon(Icons.delete_outline, color: Colors.white, size: 20),
                  label: Text(
                    'حذف',
                    style: ModernTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.redColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              SizedBox(width: ModernTheme.spaceSM),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => categoryController.reAcceptCase(caseData),
                  icon: Icon(Icons.check_circle, color: Colors.white, size: 20),
                  label: Text(
                    'قبول',
                    style: ModernTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.greenColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceSM),
          // Second row: Re-Review button full width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => categoryController.reReviewCase(caseData),
              icon: Icon(Icons.refresh, color: Colors.white, size: 24),
              label: Text(
                'إعادة المراجعة',
                style: ModernTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.orangeColor,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      );
    }

    // For other statuses, show nothing
    return SizedBox.shrink();
  }

  // Build Doctor Info Card
  Widget _buildDoctorInfoCard(CaseModel caseData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ModernTheme.spaceLG),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ModernTheme.spaceSM),
                decoration: BoxDecoration(
                  color: ModernTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: ModernTheme.primaryBlue,
                  size: 24,
                ),
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Text(
                'معلومات الطبيب',
                style: ModernTheme.titleLarge.copyWith(
                  color: ModernTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),

          // Doctor Details
          if (caseData.doctor != null && caseData.doctor!.isNotEmpty) ...[
            _buildInfoRow('الاسم', caseData.doctor!, Icons.person),
            SizedBox(height: ModernTheme.spaceSM),
          ],
          if (caseData.doctorPhone != null && caseData.doctorPhone!.isNotEmpty) ...[
            _buildInfoRow('الهاتف', caseData.doctorPhone!, Icons.phone),
            SizedBox(height: ModernTheme.spaceSM),
          ],
          if (caseData.doctorTelegram != null && caseData.doctorTelegram!.isNotEmpty) ...[
            _buildInfoRow('التيليجرام', caseData.doctorTelegram!, Icons.send),
            SizedBox(height: ModernTheme.spaceSM),
          ],
          if (caseData.doctorUni != null && caseData.doctorUni!.isNotEmpty) ...[
            _buildInfoRow('الجامعة', caseData.doctorUni!, Icons.school),
            SizedBox(height: ModernTheme.spaceSM),
          ],
          if (caseData.startDate != null && caseData.startDate!.isNotEmpty) ...[
            _buildInfoRow('تاريخ بداية العلاج', caseData.startDate!, Icons.calendar_today),
          ],
        ],
      ),
    );
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
