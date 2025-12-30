import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/routes/app_routes.dart';
import '../../../controllers/case_controller.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/modern/app_header.dart';

class SelectCareRequired extends StatelessWidget {
  SelectCareRequired({super.key});
  
  final List<CareRequired> careRequireies = [
    CareRequired(
      name: 'معالجة الاسنان',
      description: 'حشوات ضوئية - حشوات جذور - قلع الاسنان و الجذور التالفة',
      icon: Icons.healing,
      color: const Color(0xFF2196F3),
      image: 'assets/images/Required care1.png',
      page: AppRoutes.createCase,
    ),
    CareRequired(
      name: 'تنظيف الاسنان',
      description: 'تبييض الاسنان و ازالة التلكسات و التصبغات',
      icon: Icons.cleaning_services,
      color: const Color(0xFF4CAF50),
      image: 'assets/images/Required care2.png',
      page: AppRoutes.createCase,
    ),
    CareRequired(
      name: 'تعويض الاسنان',
      description: 'تعويض الاسنان المفقودة بطقم جزئي او كامل',
      icon: Icons.medical_services,
      color: const Color(0xFFFF9800),
      image: 'assets/images/Required care3.png',
      page: AppRoutes.createCase,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Fixed App Header
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2196F3),
                    const Color(0xFF1976D2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'طبيبي',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 0.0),
                  
                  // Premium Apple-style header card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        // Primary shadow for elevation
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.05),
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
                        child: Column(
                          children: [
                            // Premium icon container with glassmorphism effect
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4A90E2),
                                    Color(0xFF2196F3),
                                    Color(0xFF1976D2),
                                  ],
                                  begin: Alignment(-1.0, -1.0),
                                  end: Alignment(1.0, 1.0),
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  // Inner shadow for depth
                                  BoxShadow(
                                    color: Color(0xFF1976D2).withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                  // Outer glow effect
                                  BoxShadow(
                                    color: Color(0xFF2196F3).withOpacity(0.2),
                                    blurRadius: 32,
                                    offset: Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.medical_services_rounded,
                                  size: 42,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 24.0),
                            
                            // Title with premium typography
                            Text(
                              'اختر نوع الرعاية المطلوبة',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFF1D1D1F),
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            SizedBox(height: 12.0),
                            
                            // Subtitle with refined styling
                            Text(
                              'اختر الخدمة المناسبة لحالتك',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF86868B),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.0),
                  
                  // Service cards
                  ...careRequireies.asMap().entries.map((entry) {
                    int index = entry.key;
                    CareRequired care = entry.value;
                    return _buildServiceCard(care, index + 1);
                  }).toList(),
                  
                  SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(CareRequired care, int number) {
    return GestureDetector(
      onTap: () async {
        final caseController = Get.find<CaseController>();
        
        // Check if user is reapplying and changing case type
        bool canProceed = await caseController.handleServiceTypeChange(care.name);
        
        if (canProceed) {
          caseController.setServiceType(care.name);
          Get.toNamed(care.page);
        }
      },
      child: Container(
        height: 220,
        margin: EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full background image
              Image.asset(
                care.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          care.color.withOpacity(0.2),
                          care.color.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      care.icon,
                      size: 60,
                      color: care.color.withOpacity(0.8),
                    ),
                  );
                },
              ),
              
              // Gradient overlay for better text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              
              // Content overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Number badge and title row
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: care.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: care.color.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '$number',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              care.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8.0),
                      
                      // Description
                      Text(
                        care.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 16.0),
                      
                      // Arrow indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: care.color.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: care.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'اختر',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 16,
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
            ],
          ),
        ),
      ),
    );
  }
}

class CareRequired {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String image;
  final String page;
  
  const CareRequired({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.image,
    required this.page,
  });
}
