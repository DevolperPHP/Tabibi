import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/views/widgets/common/loading_indicator.dart';
import 'package:tabibi/views/widgets/input_text.dart';

import '../../../controllers/category_controller.dart';
import '../../../../utils/validators.dart';
import '../../widgets/actions_button.dart';

class EditCategory extends StatelessWidget {
  EditCategory({super.key});
  CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('تعديل الفئة'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                      key: categoryController.formKey,
                      child: InputText.inputStringValidator(
                          'اسم الفئة', categoryController.categoryName,
                          validator: (value) =>
                              Validators.notEmpty(value, 'اسم الفئة'))),
                  SizedBox(height: 16),
                  Spacer(),
                  Center(
                      child: SizedBox(
                          width: 250,
                          child: Obx(() =>
                              categoryController.isLoadingCategory.value
                                  ? LoadingIndicator()
                                  : BottonsC.action1(
                                      h: 40,
                                      'تعديل',
                                      categoryController.editCategory)))),
                ])));
  }
}
