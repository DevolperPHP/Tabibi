import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../widgets/modern/modern_case_card.dart';

class CaeseAdminScreen extends StatelessWidget {
  CaeseAdminScreen({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (categoryController.isLoadingCases.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (categoryController.cases.isEmpty) {
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
                  "لا توجد حالات متاحة",
                  style: ModernTheme.titleLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            itemCount: categoryController.cases.length,
            itemBuilder: (context, index) {
              return ModernCaseCard(
                caseModel: categoryController.cases[index],
                onTap: () async => await categoryController.caesSelect(categoryController.cases[index]),
                index: index,
              );
            },
          );
        }
      }),
    );
  }
}
