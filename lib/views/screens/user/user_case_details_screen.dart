import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/controllers/case_controller.dart';
import 'package:my_doctor/controllers/home_controller.dart';
import 'package:my_doctor/controllers/profile_controller.dart';
import 'package:my_doctor/data/models/profile_model.dart';
import 'package:my_doctor/routes/app_routes.dart';
import 'package:my_doctor/services/api_service.dart';
import 'package:my_doctor/utils/constants/color_app.dart';
import 'package:my_doctor/utils/design_system/modern_theme.dart';
import 'package:my_doctor/views/widgets/message_snak.dart';
import 'package:my_doctor/views/widgets/zoomable_image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_doctor/utils/constants/api_constants.dart';

class UserCaseDetailsScreen extends StatefulWidget {
  const UserCaseDetailsScreen({super.key});

  @override
  State<UserCaseDetailsScreen> createState() => _UserCaseDetailsScreenState();
}

class _UserCaseDetailsScreenState extends State<UserCaseDetailsScreen> {
  Case? caseData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCaseDetails();
  }

  Future<void> _fetchCaseDetails() async {
    try {
      // Get case ID from arguments
      final Case initialCaseData = Get.arguments as Case;
      final String caseId = initialCaseData.id;
      
      // Fetch fresh case data with gender information
      final response = await ApiService.getData(ApiConstants.caseEdit(caseId));
      
      if (response.isStateSucess < 3) {
        setState(() {
          caseData = Case.fromJson(response.data);
          isLoading = false;
        });
      } else {
        // Fallback to initial data if fetch fails
        setState(() {
          caseData = initialCaseData;
          isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to initial data if fetch fails
      final Case initialCaseData = Get.arguments as Case;
      setState(() {
        caseData = initialCaseData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: ModernTheme.background,
        body: Center(
          child: CircularProgressIndicator(
            color: ModernTheme.primaryBlue,
          ),
        ),
      );
    }
    
    if (caseData == null) {
      return Scaffold(
        backgroundColor: ModernTheme.background,
        body: Center(
          child: Text(
            'فشل تحميل بيانات الحالة',
            style: ModernTheme.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: CustomScrollView(
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
                  _buildStatusCard(caseData!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Doctor Info Card (if case is acquired by doctor) - MOVED TO TOP
                  if (caseData!.status == 'in-treatment' || caseData!.status == 'done') ...[
                    _buildDoctorInfoCard(caseData!),
                    SizedBox(height: ModernTheme.spaceLG),
                  ],

                  // Patient Info Card
                  _buildPatientInfoCard(caseData!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Medical History Card
                  _buildMedicalHistoryCard(caseData!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Service Type & Questions Card
                  _buildServiceDetailsCard(caseData!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Images Card
                  _buildImagesCard(context, caseData!),
                  SizedBox(height: ModernTheme.spaceLG),

                  // Action Buttons
                  _buildActionButtons(caseData!),

                  SizedBox(height: ModernTheme.space2XL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Status Card with beautiful gradient
  Widget _buildStatusCard(Case caseData) {
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

  // Patient Info Card
  Widget _buildPatientInfoCard(Case caseData) {
    return _buildCard(
      title: 'معلومات المريض',
      icon: Icons.person,
      children: [
        _buildInfoRow('الاسم', caseData.name, Icons.badge),
        _buildInfoRow('العمر', '${caseData.age} سنة', Icons.cake),
        _buildInfoRow('الجنس', _translateGender(caseData.gender), Icons.wc),
        _buildInfoRow('المنطقة', caseData.zone ?? 'غير متوفر', Icons.location_on),
        _buildInfoRow('رقم الهاتف', caseData.phone ?? 'غير متوفر', Icons.phone),
        _buildInfoRow('حساب التليجرام', caseData.telegram ?? 'غير متوفر', Icons.send),
        _buildInfoRow('تاريخ التقديم', caseData.date ?? 'غير متوفر', Icons.calendar_today),
      ],
    );
  }

  // Medical History Card
  Widget _buildMedicalHistoryCard(Case caseData) {
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
  Widget _buildServiceDetailsCard(Case caseData) {
    return _buildCard(
      title: 'تفاصيل الخدمة',
      icon: Icons.medical_information,
      children: [
        _buildInfoRow('نوع الخدمة', caseData.type ?? 'غير محدد', Icons.category),
        if (caseData.note != null && caseData.note!.isNotEmpty)
          _buildInfoRow('ملاحظات', caseData.note!, Icons.note),
        SizedBox(height: ModernTheme.spaceSM),
        Divider(),
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
  Widget _buildImagesCard(BuildContext context, Case caseData) {
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

  // Doctor Info Card
  Widget _buildDoctorInfoCard(Case caseData) {
    return _buildCard(
      title: 'معلومات الطبيب المعالج',
      icon: Icons.medical_services_outlined,
      children: [
        _buildInfoRow('اسم الطبيب', caseData.doctorName ?? 'غير متوفر', Icons.badge),
        _buildInfoRow('رقم الهاتف', caseData.doctorPhone ?? 'غير متوفر', Icons.phone),
        _buildInfoRow('حساب التليجرام', caseData.doctorTelegram ?? 'غير متوفر', Icons.send),
        _buildInfoRow('الجامعة', caseData.doctorUni ?? 'غير متوفر', Icons.school),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
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
  List<Widget> _buildSymptomsList(Case caseData) {
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
        // Show zoomable full image
        showZoomableImage(context, imageUrl, title: label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
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
                  imageUrl: '${ApiConstants.baseUrlImage}$imageUrl',
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
  List<MapEntry<String, String>> _getAvailableImages(Case caseData) {
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
  LinearGradient _getStatusGradient(Case caseData) {
    // Rejected by admin - Red
    if (caseData.adminStatus == 'reject') {
      return LinearGradient(
        colors: [Color(0xFFef4444), Color(0xFFdc2626)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    
    // Done - treatment completed - Green
    if (caseData.status == 'done') {
      return LinearGradient(
        colors: [Color(0xFF34C759), Color(0xFF28A745)], // iOS Green
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    
    // In treatment - doctor is working on it - Blue
    if (caseData.status == 'in-treatment') {
      return LinearGradient(
        colors: [Color(0xFF007AFF), Color(0xFF0051D5)], // iOS Blue
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    
    // Accepted but waiting for doctor to take it - Orange
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return LinearGradient(
        colors: [Color(0xFFFF9500), Color(0xFFFF7A00)], // iOS Orange
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
  Color _getStatusColor(Case caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return Color(0xFFef4444);
    
    // Done - treatment completed
    if (caseData.status == 'done') return Color(0xFF34C759); // iOS Green
    
    // In treatment - doctor is working on it
    if (caseData.status == 'in-treatment') return Color(0xFF007AFF); // iOS Blue
    
    // Accepted but waiting for doctor to take it
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return Color(0xFFFF9500); // iOS Orange
    }
    
    // Waiting for admin review
    return Color(0xFFFF9500); // iOS Orange
  }

  // Helper: Get Status Icon
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

  // Helper: Get Status Title
  String _getStatusTitle(Case caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') return 'تم رفض الحالة';
    
    // Done - treatment completed
    if (caseData.status == 'done') return 'تم العلاج';
    
    // In treatment - doctor is working on it
    if (caseData.status == 'in-treatment') return 'جاري تلقي العلاج';
    
    // Accepted but waiting for doctor to take it
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return 'في انتظار طبيب';
    }
    
    // Waiting for admin review
    return 'في انتظار الموافقة';
  }

  // Helper: Get Status Description
  String _getStatusDescription(Case caseData) {
    // Rejected by admin
    if (caseData.adminStatus == 'reject') {
      return 'تم رفض حالتك من قبل الإدارة. يمكنك إعادة التقديم بعد تعديل المعلومات.';
    }
    
    // Done - treatment completed
    if (caseData.status == 'done') {
      return 'تم إنهاء علاج حالتك بنجاح. نتمنى لك الشفاء العاجل.';
    }
    
    // In treatment - doctor is working on it
    if (caseData.status == 'in-treatment') {
      return 'تم اختيار حالتك من قبل طبيب وجاري العمل على علاجها.';
    }
    
    // Accepted but waiting for doctor to take it
    if (caseData.adminStatus == 'accept' && caseData.status == 'free') {
      return 'تم قبول حالتك من قبل الإدارة. في انتظار اختيار طبيب للحالة.';
    }
    
    // Waiting for admin review
    return 'تم استلام طلبك وجاري مراجعته من قبل الإدارة.';
  }

  // Helper: Build Action Buttons
  Widget _buildActionButtons(Case caseData) {
    bool canCancel = (caseData.adminStatus == 'waiting' || caseData.adminStatus == 'accept') && 
                     (caseData.status == 'free');
    bool canReapply = caseData.adminStatus == 'reject';

    // If no actions available, return empty widget
    if (!canCancel && !canReapply) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Reapply button for rejected cases
        if (canReapply)
          ElevatedButton.icon(
            onPressed: () {
              // Pre-fill data from rejected case
              final caseController = Get.find<CaseController>();
              caseController.prefillFromRejectedCaseSimple(caseData);
              // Navigate to create new case (user can retake photos)
              Get.toNamed(AppRoutes.selectCareRequired);
            },
            icon: Icon(Icons.refresh, color: Colors.white, size: 24),
            label: Text(
              'إعادة التقديم',
              style: ModernTheme.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF10b981),
              minimumSize: Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
              elevation: 2,
            ),
          ),
        
        if (canReapply && canCancel)
          SizedBox(height: ModernTheme.spaceMD),
        
        // Cancel button for pending cases
        if (canCancel)
          ElevatedButton.icon(
            onPressed: () => _showCancelDialog(caseData.id),
            icon: Icon(Icons.cancel, color: Colors.white, size: 24),
            label: Text(
              'إلغاء الحالة',
              style: ModernTheme.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
              elevation: 2,
            ),
          ),
      ],
    );
  }

  // Helper: Show Cancel Confirmation Dialog
  void _showCancelDialog(String caseId) {
    Get.defaultDialog(
      title: 'تأكيد الإلغاء',
      titleStyle: ModernTheme.headlineMedium.copyWith(
        color: ModernTheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      middleText: 'هل أنت متأكد من إلغاء هذه الحالة؟\nلن تتمكن من التراجع عن هذا الإجراء.',
      middleTextStyle: ModernTheme.bodyLarge.copyWith(
        color: ModernTheme.textSecondary,
      ),
      textConfirm: 'نعم، إلغاء',
      textCancel: 'رجوع',
      confirmTextColor: Colors.white,
      cancelTextColor: ModernTheme.textPrimary,
      buttonColor: Colors.orange,
      radius: ModernTheme.radiusMD,
      onConfirm: () async {
        Get.back(); // Close dialog
        final profileController = Get.find<ProfileController>();
        await profileController.cancelCase(caseId);
        
        // Navigate to home and switch to Apply Case tab (index 1)
        Get.until((route) => route.isFirst);
        final homeController = Get.find<HomeController>();
        homeController.changeIndex(1); // Apply Case tab
      },
    );
  }

  // Helper: Translate Gender
  String _translateGender(String? gender) {
    if (gender == null || gender.isEmpty || gender == 'undefined') return 'غير محدد';
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
