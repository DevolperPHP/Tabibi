import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controllers/request_admin_role_controller.dart';
import '../../../data/models/role_lists.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';

class RequestRoleView extends StatelessWidget {
  RequestRoleView({super.key});
  final RequestAdminRoleController requestAdminRoleController =
      Get.find<RequestAdminRoleController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Column(
            children: [
              // Header Section
              _buildHeader(),
              
              // Requests List
              Expanded(
                child: Obx(() {
                  if (requestAdminRoleController.isLoading.value) {
                    return _buildLoadingState();
                  } else if (requestAdminRoleController.roleLists.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await requestAdminRoleController.fetchDataRouls();
                      },
                      color: ModernTheme.primaryBlue,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 3,
                          bottom: 100,
                        ),
                        itemBuilder: (context, index) =>
                            _buildRequestCard(
                              requestAdminRoleController.roleLists[index],
                              index,
                            ),
                        itemCount: requestAdminRoleController.roleLists.length,
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
        
        // Floating Refresh Button
        Positioned(
          bottom: 24,
          left: 20,
          child: _buildRefreshButton(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلبات الأطباء',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D1D1F),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Obx(() => Text(
                      '${requestAdminRoleController.roleLists.length} طلب',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 16,
            color: ModernTheme.primaryBlue,
          ),
          SizedBox(height: 16),
          Text(
            'جاري التحميل...',
            style: ModernTheme.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: ModernTheme.primaryBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.folder_open_rounded,
              size: 60,
              color: ModernTheme.primaryBlue.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'لا توجد طلبات',
            style: ModernTheme.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ستظهر طلبات الأطباء هنا',
            style: ModernTheme.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => requestAdminRoleController.fetchDataRouls(),
          customBorder: CircleBorder(),
          child: Center(
            child: Icon(
              Icons.refresh_rounded,
              color: ModernTheme.primaryBlue,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(RoleLists role, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => requestAdminRoleController.selectRole(role),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Doctor Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF007AFF).withOpacity(0.15),
                              Color(0xFF007AFF).withOpacity(0.08),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFF007AFF),
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      
                      // Doctor Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              role.name ?? 'غير محدد',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF9500).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'قيد الانتظار',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF9500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // View Details Button
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(0xFF007AFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 14),
                  
                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey[100],
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Info Row
                  Row(
                    children: [
                      // Date Info
                      Expanded(
                        child: _buildInfoItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'التاريخ',
                          value: role.date ?? '--',
                        ),
                      ),
                      
                      // Vertical Divider
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[200],
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      
                      // City Info
                      Expanded(
                        child: _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          label: 'المحافظة',
                          value: role.city ?? '--',
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
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.grey[500],
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1F),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
