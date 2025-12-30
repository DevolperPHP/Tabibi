import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/utils/validators.dart';
import 'package:tabibi/views/widgets/common/loading_indicator.dart';
import '../../../controllers/category_controller.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/input_text.dart';

class RejectCaseScreen extends StatelessWidget {
  final CategoryController categoryController = Get.find<CategoryController>();

  RejectCaseScreen({super.key});

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
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(Values.circle),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 30),
                        SizedBox(width: Values.circle),
                        Expanded(
                          child: Text(
                            'رفض الحالة مع سبب الرفض',
                            style: StringStyle.headerStyle.copyWith(
                              color: Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputText.inputStringValidator(
                      'سبب الرفض', categoryController.diagnose,
                      validator: (p0) => Validators.notEmpty(p0, 'سبب الرفض')),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Obx(() => categoryController.isLoadingCases.value
                          ? LoadingIndicator()
                          : ElevatedButton.icon(
                              onPressed: categoryController.rejectCase,
                              icon: Icon(Icons.cancel, color: Colors.white),
                              label: Text(
                                'رفض الحالة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
