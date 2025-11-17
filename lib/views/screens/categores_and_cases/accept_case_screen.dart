import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/utils/validators.dart';
import 'package:my_doctor/views/widgets/common/loading_indicator.dart';
import '../../../controllers/category_controller.dart';
import '../../../data/models/category.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/input_text.dart';

class AcceptCaseScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

  AcceptCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorApp.backgroundColor,
        body: SafeArea(
          child: Form(
            key: categoryController.formKey2,
            child: Padding(
              padding: EdgeInsets.all(Values.circle),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Hero(
                        //   tag: ImagesUrl.logoPNG,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: ClipOval(
                        //       child: Image.asset(
                        //         ImagesUrl.logoPNG,
                        //         width: 70,
                        //         height: 70,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Image.asset(
                              ImagesUrl.logoPNG,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Values.spacerV),
                            child: BottonsC.actionIcon(
                                size: 40,
                                Icons.arrow_forward_ios_outlined,
                                'رجوع', () {
                              Get.back();
                            }))
                      ]),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(Values.circle),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(Values.circle),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 30),
                        SizedBox(width: Values.circle),
                        Expanded(
                          child: Text(
                            'قبول الحالة وإضافة التشخيص',
                            style: StringStyle.headerStyle.copyWith(
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputText.inputStringValidator(
                      'تشخيص الطبيب', categoryController.diagnose,
                      validator: (p0) =>
                          Validators.notEmpty(p0, 'تشخيص الطبيب')),
                  InputText.inputStringValidator(
                      'ملاحظات إضافية', categoryController.note,
                      validator: (p0) => Validators.notEmpty(p0, 'الملاحظة')),
                  const SizedBox(height: 16),
                  const Text(
                    'اختر الفئة المناسبة للحالة:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Obx(() => categoryController.isLoadingCategory.value
                          ? SizedBox(
                              width: 33, height: 45, child: LoadingIndicator())
                          : IconButton(
                              icon: Icon(Icons.refresh, color: ColorApp.primaryColor),
                              onPressed: () {
                                categoryController.categorySelect.value = null;
                                categoryController.fetchDataCategory();
                              },
                            )),
                      Expanded(
                        child: Obx(() => DropdownButtonFormField<Category>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorApp.subColor.withAlpha(150),
                                        width: 0.5),
                                    borderRadius:
                                        BorderRadius.circular(Values.circle)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            ColorApp.greenColor.withAlpha(150),
                                        width: 0.5),
                                    borderRadius:
                                        BorderRadius.circular(Values.circle)),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Values.circle)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              value: categoryController.categorySelect.value,
                              isExpanded: true,
                              items: categoryController.categores
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category.name),
                                      ))
                                  .toList(),
                              onChanged: (Category? value) {
                                categoryController.categorySelect.value = value;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'يرجى اختيار فئة';
                                }
                                return null;
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Obx(() => categoryController.isLoadingCases.value
                          ? LoadingIndicator()
                          : ElevatedButton.icon(
                              onPressed: categoryController.acceptCase,
                              icon: Icon(Icons.check_circle, color: Colors.white),
                              label: Text(
                                'قبول الحالة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Values.circle),
                                ),
                              ),
                            )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
