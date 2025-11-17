import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/case_controller.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/common/loading_indicator.dart';

class CreateCase extends StatelessWidget {
  CreateCase({super.key});
  final CaseController controller = Get.find<CaseController>();

  final List<String> options = ['نعم', 'لا', 'لا أعلم'];

  @override
  Widget build(BuildContext context) {
    int totalQuestions = controller.currentQuestions.length;
    
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Header with Progress
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 140,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF007AFF),
                    const Color(0xFF0051D5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Column(
                    children: [
                      // App navigation - Logo on right, arrow on left
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo and title on the right
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'طبيبي',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Back arrow on the left
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Progress Section
                      Obx(() {
                        int answeredCount = controller.currentQuestions
                            .where((item) => item.value.isNotEmpty)
                            .length;
                        double progress = answeredCount / totalQuestions;
                        bool isComplete = answeredCount == totalQuestions;
                        
                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Progress header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'تقدم الاستمارة',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isComplete
                                        ? Color(0xFF34C759).withOpacity(0.2)
                                        : Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${(progress * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 8),

                              // Progress bar - RTL direction (right to left)
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      // Background track
                                      Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      // Progress fill from right to left
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          width: constraints.maxWidth * progress,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isComplete
                                                ? [Color(0xFF34C759), Color(0xFF30D158)]
                                                : [Colors.white, Colors.white.withOpacity(0.8)],
                                            ),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form Title Card
                  Obx(() => Container(
                    margin: EdgeInsets.only(bottom: 32.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF007AFF).withOpacity(0.08),
                          Color(0xFF0051D5).withOpacity(0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF007AFF).withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.medical_services_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'استمارة التشخيص',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF8E8E93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  controller.selectedServiceType.value.isEmpty
                                    ? 'اختر نوع الحالة'
                                    : controller.selectedServiceType.value,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C1C1E),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  
                  // Section 1: General Health Questions
                  _buildSectionHeader(
                    'الأسئلة الصحية العامة',
                    'معلومات حول حالتك الصحية العامة',
                    Icons.health_and_safety_rounded,
                    Color(0xFFFF9500),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // General Health Questions - Combined in one card
                  Obx(() => _buildQuestionsCard(
                    controller.medicalHistoryQuestions,
                    Color(0xFFFF9500),
                    0,
                  )),
                  
                  SizedBox(height: 32),
                  
                  // Section 2: Teeth Case Questions
                  Obx(() => _buildSectionHeader(
                    'اسئلة حالة الاسنان',
                    'أسئلة متخصصة حسب نوع الحالة المختارة',
                    Icons.sentiment_very_satisfied_rounded,
                    Color(0xFF007AFF),
                    controller.selectedServiceType.value.isEmpty
                      ? 'اختر نوع الحالة'
                      : controller.selectedServiceType.value,
                  )),
                  
                  SizedBox(height: 16),
                  
                  // Teeth Case Questions - Combined in one card
                  Obx(() {
                    List<TextAndData> serviceQuestions = [];
                    switch (controller.selectedServiceType.value) {
                      case 'معالجة الاسنان':
                        serviceQuestions = controller.treatmentQuestions;
                        break;
                      case 'تنظيف الاسنان':
                        serviceQuestions = controller.cleaningQuestions;
                        break;
                      case 'تعويض الاسنان':
                        serviceQuestions = controller.replacementQuestions;
                        break;
                      default:
                        serviceQuestions = controller.treatmentQuestions;
                    }
                    
                    return _buildQuestionsCard(
                      serviceQuestions,
                      Color(0xFF007AFF),
                      controller.medicalHistoryQuestions.length,
                    );
                  }),
                  
                  SizedBox(height: 40),
                  
                  // Submit Button
                  Obx(() {
                    int answeredCount = controller.currentQuestions
                        .where((item) => item.value.isNotEmpty)
                        .length;
                    int totalQuestions = controller.currentQuestions.length;
                    bool isFormComplete = answeredCount == totalQuestions;
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 40),
                      child: controller.isLoading.value
                        ? Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: LoadingIndicator(),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'جاري حفظ البيانات...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF8E8E93),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: isFormComplete 
                                ? LinearGradient(
                                    colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
                                  )
                                : null,
                              color: isFormComplete ? null : Color(0xFFD1D1D6),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isFormComplete ? [
                                BoxShadow(
                                  color: Color(0xFF007AFF).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ] : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: isFormComplete ? controller.nextStep : null,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'التالي',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: isFormComplete ? Colors.white : Color(0xFF8E8E93),
                                        ),
                                      ),
                                      if (isFormComplete) ...[
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(String title, String subtitle, IconData icon, Color color, [String? serviceType]) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                if (serviceType != null) ...[
                  Text(
                    serviceType.isEmpty
                      ? 'اختر نوع الحالة'
                      : serviceType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E93),
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

  // Combined Questions Card - Apple-style design
  Widget _buildQuestionsCard(List<TextAndData> questions, Color sectionColor, int startIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Options header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: sectionColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'السؤال',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ),
                  ...options.map((option) => Expanded(
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  )).toList(),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Questions list - Apple-style layout
            ...questions.asMap().entries.map((entry) {
              int index = entry.key;
              TextAndData item = entry.value;
              
              return Column(
                children: [
                  // Question row - Question text and number only
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.transparent : sectionColor.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question number
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [sectionColor, sectionColor.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${startIndex + index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        
                        // Question text - Full width
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1C1E),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Radio buttons row - Separate row below question with streamlined wide buttons
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.transparent : sectionColor.withOpacity(0.02),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: options.map((option) {
                        bool isSelected = item.value.value == option;
                        return Expanded(
                          flex: 5, // Keep buttons extremely wide
                          child: GestureDetector(
                            onTap: () => controller.selectAnswer(item, option),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: 38, // Reduced height for less bulky appearance
                              margin: EdgeInsets.symmetric(horizontal: 4), // Minimal gap between buttons
                              decoration: BoxDecoration(
                                gradient: isSelected
                                  ? LinearGradient(
                                      colors: [sectionColor, sectionColor.withOpacity(0.8)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(12), // Smaller border radius for sleeker look
                                border: Border.all(
                                  color: isSelected ? sectionColor : Color(0xFFE5E5EA),
                                  width: 1.5, // Slightly thinner border
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: sectionColor.withOpacity(0.2), // Reduced shadow intensity
                                    blurRadius: 4, // Smaller blur radius
                                    offset: Offset(0, 2), // Smaller offset
                                  ),
                                ] : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03), // Subtle shadow
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15, // Slightly smaller font for proportion
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Color(0xFF1C1C1E),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Sub-question (if exists and parent is 'نعم')
                  Obx(() {
                    final parentValue = item.value.value;
                    final hasSubQuestion = item.subQuestion != null;
                    final triggerValue = item.parentTriggerValue ?? 'نعم';
                   
                    if (hasSubQuestion && parentValue == triggerValue) {
                      return Padding(
                        padding: EdgeInsets.only(left: 68, right: 20, bottom: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: _buildSubQuestionCard(item.subQuestion!, sectionColor),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                  
                  // Add spacing between questions
                  if (index < questions.length - 1) SizedBox(height: 8),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Sub-question Card - Apple-style layout
  Widget _buildSubQuestionCard(TextAndData subItem, Color parentColor) {
    List<String> subOptions = [];
    if (subItem.key == 'pain_eat_type') {
      subOptions = ['ألم حاد ومستمر', 'ألم بسيط ويختفي'];
    } else if (subItem.key == 'pain_caild_drink_type') {
      subOptions = ['يستمر بعد بلع الماء البارد', 'ينقطع بعد بلع الماء البارد'];
    } else if (subItem.key == 'currentDiseaseDetails') {
      // This is a text input field, not a dropdown
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              parentColor.withOpacity(0.05),
              parentColor.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: parentColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question row - Question text and indicator only
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: parentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.subdirectory_arrow_right,
                      color: parentColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      subItem.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: parentColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Text input field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _RtlTextInputWidget(
                subItem: subItem,
                parentColor: parentColor,
              ),
            ),
            
            SizedBox(height: 8),
          ],
        ),
      );
    }
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            parentColor.withOpacity(0.05),
            parentColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: parentColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question row - Question text and indicator only
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: parentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.subdirectory_arrow_right,
                    color: parentColor,
                    size: 18,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    subItem.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: parentColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Dropdown row - Full width dropdown
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFE5E5EA),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() => DropdownButton<String>(
                isExpanded: true,
                value: subItem.value.value.isEmpty ? null : subItem.value.value,
                hint: Text(
                  'اختر الإجابة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E93),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                items: subOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1C1C1E),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  );
                }).toList(),
                onChanged: (val) => subItem.value(val ?? ''),
                underline: SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: parentColor,
                  size: 20,
                ),
                dropdownColor: Colors.white,
                menuMaxHeight: 200,
                itemHeight: 48,
              )),
            ),
          ),
          
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Stateful widget for proper RTL text input handling
class _RtlTextInputWidget extends StatefulWidget {
  final TextAndData subItem;
  final Color parentColor;

  const _RtlTextInputWidget({
    required this.subItem,
    required this.parentColor,
  });

  @override
  State<_RtlTextInputWidget> createState() => _RtlTextInputWidgetState();
}

class _RtlTextInputWidgetState extends State<_RtlTextInputWidget> {
  late TextEditingController _controller;
  bool _isUpdatingFromController = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.subItem.value.value);
    _controller.addListener(_onTextChanged);

    // Watch for external changes to RxString value
    ever(widget.subItem.value, (newValue) {
      if (!_isUpdatingFromController && _controller.text != newValue) {
        _controller.text = newValue;
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _isUpdatingFromController = true;
    widget.subItem.value(_controller.text);
    _isUpdatingFromController = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE5E5EA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLength: 150,
        decoration: InputDecoration(
          hintText: 'يرجى توضيح المرض',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFF8E8E93),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '',
        ),
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF1C1C1E),
          fontWeight: FontWeight.w500,
        ),
        maxLines: 3,
        minLines: 1,
      ),
    );
  }
}
