import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/category_controller.dart';
import '../../../data/models/case_model.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_case_card.dart';
import '../../widgets/modern/app_header.dart';

class AdminCasesScreen extends StatefulWidget {
  const AdminCasesScreen({super.key});

  @override
  State<AdminCasesScreen> createState() => _AdminCasesScreenState();
}

class _AdminCasesScreenState extends State<AdminCasesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Changed from 3 to 4
    // Refresh data when screen loads
    categoryController.fetchDataCeses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F7FA),
      child: Column(
        children: [
          // Tab Bar - directly attached to AppHeader
          Material(
            elevation: 0,
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: ColorApp.primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: ColorApp.primaryColor,
              indicatorWeight: 2.5,
              labelStyle: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: "قيد الانتظار"),
                Tab(text: "مقبولة"),
                Tab(text: "قيد العلاج"),
                Tab(text: "مرفوضة"),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCasesList('waiting'),
                _buildCasesList('accept'),
                _buildCasesList('in-treatment'),
                _buildCasesList('reject'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCasesList(String status) {
    return Obx(() {
        if (categoryController.isLoadingCases.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Filter cases by status
        List<CaseModel> filteredCases;
        if (status == 'accept') {
          // For accepted cases, only show those with status 'free' (awaiting doctor)
          filteredCases = categoryController.cases
              .where((caseItem) =>
                  caseItem.adminStatus == 'accept' && caseItem.status == 'free')
              .toList();
        } else if (status == 'in-treatment') {
          // For in-treatment cases, show those with adminStatus 'accept' and status 'in-treatment'
          filteredCases = categoryController.cases
              .where((caseItem) =>
                  caseItem.adminStatus == 'accept' && caseItem.status == 'in-treatment')
              .toList();
        } else {
          // For other statuses, show all cases with that adminStatus
          filteredCases = categoryController.cases
              .where((caseItem) => caseItem.adminStatus == status)
              .toList();
        }
        
        if (filteredCases.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_information_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                SizedBox(height: ModernTheme.spaceMD),
                Text(
                  _getEmptyMessage(status),
                  style: ModernTheme.titleLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            await categoryController.fetchDataCeses();
          },
          color: ColorApp.primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            itemCount: filteredCases.length,
            itemBuilder: (context, index) {
              return ModernCaseCard(
                caseModel: filteredCases[index],
                onTap: () async => await categoryController.caesSelect(filteredCases[index]),
                index: index,
                showAdminStatus: true, // Show adminStatus badge with colors
              );
            },
          ),
        );
      });
  }
  
  String _getEmptyMessage(String status) {
    switch (status) {
      case 'waiting':
        return 'لا توجد حالات قيد الانتظار';
      case 'accept':
        return 'لا توجد حالات مقبولة';
      case 'in-treatment':
        return 'لا توجد حالات قيد العلاج';
      case 'reject':
        return 'لا توجد حالات مرفوضة';
      default:
        return 'لا توجد حالات';
    }
  }
}
