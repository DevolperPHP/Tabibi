// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../../../utils/validators.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/more_widgets.dart';

class EditPost extends StatelessWidget {
  EditPost({super.key});
  AdminController adminController = Get.find<AdminController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ModernTheme.textPrimary),
          onPressed: () {
            adminController.clearFeilds();
            Get.back();
          },
        ),
        title: Text(
          'تعديل المنشور',
          style: ModernTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: adminController.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ModernTheme.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Section
                _buildImageSection(),
                SizedBox(height: ModernTheme.spaceLG),
                
                // Title Field
                _buildTextField(
                  label: 'عنوان المنشور',
                  controller: adminController.title,
                  validator: (value) => Validators.notEmpty(value, 'عنوان المنشور'),
                  maxLines: 1,
                ),
                SizedBox(height: ModernTheme.spaceMD),
                
                // Description Field
                _buildTextField(
                  label: 'الوصف',
                  controller: adminController.description,
                  validator: (value) => Validators.notEmpty(value, 'الوصف'),
                  maxLines: 5,
                ),
                SizedBox(height: ModernTheme.space2XL),
                
                // Submit Button
                Obx(() => adminController.isLoading.value
                    ? Center(child: LoadingIndicator())
                    : _buildSubmitButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Obx(() {
      return GestureDetector(
        onTap: adminController.selectImage,
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
            border: Border.all(
              color: Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image Display
                if (adminController.image.value != null)
                  // New selected image
                  Image.file(
                    adminController.image.value!,
                    fit: BoxFit.cover,
                  )
                else if (adminController.postSelect.value != null)
                  // Old image with overlay
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: imageCached(
                          adminController.postSelect.value!.image,
                        ),
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  )
                else
                  // Empty state
                  Container(
                    color: Color(0xFFF3F4F6),
                  ),
                
                // Overlay Button
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ModernTheme.spaceLG,
                      vertical: ModernTheme.spaceMD,
                    ),
                    decoration: BoxDecoration(
                      color: ModernTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(ModernTheme.radiusFull),
                      boxShadow: ModernTheme.shadowLG,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          adminController.image.value != null
                              ? Icons.check_circle
                              : Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: ModernTheme.spaceXS),
                        Text(
                          adminController.image.value != null
                              ? 'تم اختيار صورة جديدة'
                              : 'تغيير الصورة',
                          style: ModernTheme.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ModernTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: ModernTheme.textPrimary,
          ),
        ),
        SizedBox(height: ModernTheme.spaceXS),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: ModernTheme.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'أدخل $label',
            hintStyle: ModernTheme.bodyLarge.copyWith(
              color: Color(0xFF9CA3AF),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(
                color: ModernTheme.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ModernTheme.spaceMD,
              vertical: ModernTheme.spaceMD,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: adminController.submitUpdata,
      style: ElevatedButton.styleFrom(
        backgroundColor: ModernTheme.primaryBlue,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 24),
          SizedBox(width: ModernTheme.spaceSM),
          Text(
            'نشر التعديل',
            style: ModernTheme.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
