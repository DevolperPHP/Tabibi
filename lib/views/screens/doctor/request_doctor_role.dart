import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tabibi/utils/design_system/modern_theme.dart';

import '../../../controllers/request_doctor_role_controller.dart';
import '../../../utils/constants/images_url.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/modern/modern_input_field.dart';

class RequestDoctorRole extends StatelessWidget {
  RequestDoctorRole({super.key});
  RequestDoctorRoleController requestDoctorRoleController =
      Get.put<RequestDoctorRoleController>(RequestDoctorRoleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Header
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF007AFF),
                    Color(0xFF5856D6),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and title on the right
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تقديم على حساب طبيب',
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
                                ImagesUrl.logoPNG,
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
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Obx(
              () => requestDoctorRoleController.userProfile.value == null
                  ? Container(
                      height: 400,
                      child: Center(child: LoadingIndicator()),
                    )
                  : (requestDoctorRoleController.userProfile.value!.role.isNotEmpty && 
                     requestDoctorRoleController.userProfile.value!.role != 'Rejected')
                      ? _buildStatusView()
                      : _buildApplicationForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusView() {
    String role = requestDoctorRoleController.userProfile.value!.role;
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (role == 'hold') {
      statusColor = Color(0xFFFF9500);
      statusText = 'تم التقديم - انتظر الموافقة';
      statusIcon = Icons.hourglass_empty;
    } else if (role == 'Accepted') {
      statusColor = Color(0xFF34C759);
      statusText = 'تم قبول طلب التقديم على حساب طبيب';
      statusIcon = Icons.check_circle;
    } else {
      statusColor = Color(0xFF8E8E93);
      statusText = 'حالة غير معروفة';
      statusIcon = Icons.help_outline;
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(32),
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
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 40,
              ),
            ),
            SizedBox(height: 24),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1C1E),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationForm() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rejection Notice
          if (requestDoctorRoleController.userProfile.value!.role == 'Rejected')
            Container(
              margin: EdgeInsets.only(bottom: 24),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFF3B30).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFFFF3B30).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFFFF3B30),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تم رفض طلبك السابق. يمكنك التقديم مرة أخرى',
                      style: TextStyle(
                        color: Color(0xFFFF3B30),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

          // Form Card
          Container(
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
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: requestDoctorRoleController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form Title
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'معلومات التقديم',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1C1E),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Form Fields
                    ModernInputField(
                      label: 'الاسم الكامل',
                      controller: requestDoctorRoleController.name,
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الاسم مطلوب';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    ModernInputField(
                      label: 'العمر',
                      controller: requestDoctorRoleController.age,
                      prefixIcon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'العمر مطلوب';
                        }
                        int age = int.tryParse(value) ?? 0;
                        if (age < 18 || age > 100) {
                          return 'العمر يجب أن يكون بين 18 و 100';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    ModernInputField(
                      label: 'المحافظة',
                      controller: requestDoctorRoleController.city,
                      prefixIcon: Icons.location_city_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'المحافظة مطلوبة';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    ModernInputField(
                      label: 'حساب Telegram',
                      controller: requestDoctorRoleController.profileTelegram,
                      prefixIcon: Icons.send_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'حساب Telegram مطلوب';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    ModernInputField(
                      label: 'اسم الجامعة',
                      controller: requestDoctorRoleController.uni,
                      prefixIcon: Icons.school_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'اسم الجامعة مطلوب';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Image Upload Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFFE5E5EA),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'صورة الشهادة أو الهوية الجامعية',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          SizedBox(height: 16),
                          
                          GestureDetector(
                            onTap: requestDoctorRoleController.selectImage,
                            child: Obx(
                              () => requestDoctorRoleController.image.value != null
                                  ? Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFF007AFF),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          requestDoctorRoleController.image.value!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFFE5E5EA),
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF007AFF).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: Color(0xFF007AFF),
                                              size: 30,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              'اضغط لإضافة صورة',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF8E8E93),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Submit Button
                    Obx(
                      () => requestDoctorRoleController.isLoading.value
                          ? Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: Color(0xFF007AFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                            )
                          : Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: requestDoctorRoleController.sendRequest,
                                borderRadius: BorderRadius.circular(16),
                                splashColor: Color(0xFF007AFF).withOpacity(0.1),
                                highlightColor: Color(0xFF007AFF).withOpacity(0.05),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF007AFF),
                                        Color(0xFF5856D6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF007AFF).withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        'إرسال الطلب',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
