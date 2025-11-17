import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_doctor/views/widgets/common/loading_indicator.dart';

import '../../../controllers/request_admin_role_controller.dart';
import '../../../data/models/role_lists.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/more_widgets.dart';

class ViewDetailsRole extends StatelessWidget {
  ViewDetailsRole({super.key});
  final RequestAdminRoleController requestAdminRoleController =
      Get.find<RequestAdminRoleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorApp.primaryColor,
                  ColorApp.primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                            onPressed: Get.back,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                ImagesUrl.logoPNG,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تفاصيل طلب الانضمام',
                                style: StringStyle.headerStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'مراجعة بيانات الطبيب',
                                style: StringStyle.textLabil.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
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
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Information Card
                  _buildInfoCard(
                    context,
                    'معلومات الطبيب',
                    FontAwesomeIcons.userDoctor,
                    [
                      _buildInfoRow('الاسم الكامل', requestAdminRoleController.role.value?.name ?? ''),
                      _buildInfoRow('البريد الإلكتروني', requestAdminRoleController.role.value?.email ?? ''),
                      _buildInfoRow('رقم الهاتف', requestAdminRoleController.role.value?.phone ?? ''),
                      _buildInfoRow('معرف تيليجرام', '@${requestAdminRoleController.role.value?.telegram ?? ''}'),
                      _buildInfoRow('الجنس', requestAdminRoleController.role.value?.gender ?? ''),
                      _buildInfoRow('العمر', '${requestAdminRoleController.role.value?.age ?? ''} سنة'),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Location Information Card
                  _buildInfoCard(
                    context,
                    'معلومات الموقع',
                    FontAwesomeIcons.locationDot,
                    [
                      _buildInfoRow('المحافظة', requestAdminRoleController.role.value?.city ?? ''),
                      _buildInfoRow('المنطقة', requestAdminRoleController.role.value?.zone ?? 'غير محدد'),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Academic Information Card
                  _buildInfoCard(
                    context,
                    'معلومات أكاديمية',
                    FontAwesomeIcons.graduationCap,
                    [
                      _buildInfoRow('الجامعة', requestAdminRoleController.role.value?.uni ?? 'غير محدد'),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Request Information Card
                  _buildInfoCard(
                    context,
                    'معلومات الطلب',
                    FontAwesomeIcons.clock,
                    [
                      _buildInfoRow('تاريخ التقديم', requestAdminRoleController.role.value?.date ?? ''),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // ID Card Section
                  _buildIdCardSection(context),
                  
                  const SizedBox(height: 30),
                  
                    // Action Buttons
                    _buildActionButtons(context),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorApp.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: ColorApp.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: StringStyle.headerStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: StringStyle.textLabil.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(' : ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'غير محدد',
              style: StringStyle.textLabil.copyWith(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCardSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorApp.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.idCard,
                    color: ColorApp.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  'صورة بطاقة الهوية',
                  style: StringStyle.headerStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorApp.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageCached(requestAdminRoleController.role.value?.idCard ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Obx(
      () => requestAdminRoleController.isLoading.value
          ? Center(child: LoadingIndicator())
          : Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.green.withValues(alpha: 0.8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => requestAdminRoleController.sendChaneRole(true),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'قبول الطلب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.red.withValues(alpha: 0.8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => requestAdminRoleController.sendChaneRole(false),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'رفض الطلب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
