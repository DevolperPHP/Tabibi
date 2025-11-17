import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/shadow_values.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/more_widgets.dart';

class PostView extends StatelessWidget {
  PostView({super.key});
  AdminController adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(children: [
        Row(
          children: [
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
            Spacer(),
            BottonsC.actionIconWithOutColor(
                Icons.arrow_forward_ios_rounded, 'رجوع', Get.back),
          ],
        ),
        // doctorCaseController

        Container(
          margin: EdgeInsets.all(Values.circle),
          decoration: BoxDecoration(
              border: Border.all(color: ColorApp.borderColor),
              borderRadius: BorderRadius.circular(Values.circle),
              color: ColorApp.backgroundColor,
              boxShadow: ShadowValues.shadowValues),
          child: imageCached(adminController.postSelect.value!.image),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(adminController.postSelect.value!.title,
                  style: StringStyle.textButtom
                      .copyWith(color: ColorApp.primaryColor)),
              SizedBox(height: Values.circle),
              SizedBox(
                  width: 150,
                  child: Divider(
                      color: ColorApp.textFourColor, thickness: 2, height: 0)),
            ])),

        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(adminController.postSelect.value!.description)),
        SizedBox(height: 150),
      ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: Values.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BottonsC.action2(
                    h: 40, 'تعديل', () => adminController.fullUpdata()),
              ),
              SizedBox(width: Values.circle),
              Expanded(
                  child: BottonsC.action2(
                      h: 40,
                      color: ColorApp.redColor,
                      'حذف',
                      adminController.deletePost)),
            ],
          )),
    );
  }
}
