// import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants/color_app.dart';
import '../../utils/constants/shadow_values.dart';
import '../../utils/constants/style_app.dart';
import '../../utils/constants/values_constant.dart';

class InputText {
  static Widget inputString(String name, TextEditingController controller,
          {int isNumber = 0,
          void Function(String)? onFieldSubmitted,
          double w = 300,
          FocusNode? focusNode}) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: Values.circle * 0.3),
        height: 45.h,
        width: w.w,
        child: TextFormField(
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: [
            if (isNumber >= 1) FilteringTextInputFormatter.digitsOnly,
            if (isNumber >= 1) LengthLimitingTextInputFormatter(isNumber),
          ],
          controller: controller,
          decoration: InputDecoration(
              fillColor: ColorApp.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 168, 168, 168), width: 2.w),
                  borderRadius: BorderRadius.circular(Values.circle * 1)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorApp.subColor, width: 2.w),
                  borderRadius: BorderRadius.circular(Values.circle * 0.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Values.circle * 0.5)),
              label: Container(
                  decoration: BoxDecoration(
                      color: ColorApp.backgroundColorContent,
                      borderRadius: BorderRadius.circular(Values.circle)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Text(name, style: StringStyle.textLabil))),
        ),
      );
  static Widget inputStringValidator(
          String name, TextEditingController controller,
          {required String? Function(String?)? validator,
          double w = 300,
          bool isEnable = true,
          int isNumber = 0,
          int maxLine = 1}) =>
      Container(
          margin: EdgeInsets.all(Values.circle * 0.5),
          decoration: BoxDecoration(boxShadow: ShadowValues.shadowValues2),
          width: w.w,
          child: TextFormField(
              enabled: isEnable,
              maxLines: maxLine,
              controller: controller,
              inputFormatters: [
                if (isNumber >= 1) FilteringTextInputFormatter.digitsOnly,
                if (isNumber >= 1) LengthLimitingTextInputFormatter(isNumber),
              ],
              style: StringStyle.textTable,
              decoration: InputDecoration(
                  fillColor: ColorApp.whiteColor,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  // border: OutlineInputBorder(
                  //     borderRadius:
                  //         BorderRadius.circular(Values.circle), // تدوير الحواف
                  //     borderSide: BorderSide.none), // إزالة الحدود
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorApp.subColor.withAlpha(150), width: 0.5),
                      borderRadius: BorderRadius.circular(Values.circle)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorApp.greenColor.withAlpha(150),
                          width: 0.5),
                      borderRadius: BorderRadius.circular(Values.circle)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Values.circle)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorApp.redColor.withAlpha(150), width: 1)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorApp.redColor.withAlpha(150), width: 0.5),
                      borderRadius: BorderRadius.circular(Values.circle)),
                  label: Container(
                      decoration: BoxDecoration(
                          // color: ColorApp.backgroundColor2,
                          borderRadius: BorderRadius.circular(Values.circle)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      child: Text(name,
                          style: StringStyle.textTable
                              .copyWith(color: ColorApp.subColor)))),
              validator: validator));
  static Widget inputStringValidatorIcon(
          String name, TextEditingController controller,
          {required String? Function(String?)? validator,
          String? Function(String?)? onChanged,
          double w = 300,
          int isNumber = 0,
          int maxLine = 1,
          bool isPassword = false,
          required IconData icon}) =>
      Container(
          margin: EdgeInsets.all(Values.circle * 0.5),
          // decoration: BoxDecoration(
          //     boxShadow: ShadowValues.shadowValues2,
          //     borderRadius: BorderRadius.circular(Values.circle)),
          width: w.w,
          child: TextFormField(
              onChanged: onChanged,
              obscureText: isPassword,
              maxLines: maxLine,
              controller: controller,
              inputFormatters: [
                if (isNumber >= 1) FilteringTextInputFormatter.digitsOnly,
                if (isNumber >= 1) LengthLimitingTextInputFormatter(isNumber),
              ],
              style: StringStyle.textTable,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: ColorApp.textSecondryColor),
                fillColor: ColorApp.whiteColor,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                // border: OutlineInputBorder(
                //     borderRadius:
                //         BorderRadius.circular(Values.circle), // تدوير الحواف
                //     borderSide: BorderSide.none), // إزالة الحدود
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.subColor.withAlpha(150), width: 0.5),
                    borderRadius: BorderRadius.circular(Values.circle)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.greenColor.withAlpha(150), width: 0.5),
                    borderRadius: BorderRadius.circular(Values.circle)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Values.circle)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.redColor.withAlpha(150), width: 1)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.redColor.withAlpha(150), width: 0.5),
                    borderRadius: BorderRadius.circular(Values.circle)),
                label: Container(
                    decoration: BoxDecoration(
                        // color: ColorApp.backgroundColor2,
                        borderRadius: BorderRadius.circular(Values.circle)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    child: Text(name,
                        style: StringStyle.textTable
                            .copyWith(color: ColorApp.subColor))),
                filled: true,
                // label: Container(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                //     child: Text(name, style: StringStyle.textLabil))
              ),
              validator: validator));
  // BottonsC.actionIconWithOutColor(
  //             Icons.send, 'ارسال الرابط', () {},
  //             size: 30.h,
  //             color: ColorApp.primaryColor,
  // key: ValueKey('sendButton'))
  static Widget inputStringValidatorIconOutSide(
          String name, TextEditingController controller,
          {required String? Function(String?)? validator,
          double w = 300,
          int isNumber = 0,
          int maxLine = 1,
          bool isPassword = false,
          required IconData icon,
          required void Function()? onPressed}) =>
      Container(
          margin: EdgeInsets.all(Values.circle * 0.5),
          decoration: BoxDecoration(
              color: ColorApp.whiteColor,
              boxShadow: ShadowValues.shadowValues,
              borderRadius: BorderRadius.circular(Values.circle)),
          width: w.w,
          child: TextFormField(
              obscureText: isPassword,
              maxLines: maxLine,
              controller: controller,
              inputFormatters: [
                if (isNumber >= 1) FilteringTextInputFormatter.digitsOnly,
                if (isNumber >= 1) LengthLimitingTextInputFormatter(isNumber)
              ],
              style: StringStyle.textTable,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: onPressed,
                    icon: Icon(icon, color: ColorApp.primaryColor),
                    color: ColorApp.textSecondryColor),

                // border: OutlineInputBorder(
                //     borderRadius:
                //         BorderRadius.circular(Values.circle), // تدوير الحواف
                //     borderSide: BorderSide.none), // إزالة الحدود
                enabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.greenColor.withAlpha(150), width: 0.5),
                    borderRadius: BorderRadius.circular(Values.circle)),
                border: InputBorder.none,
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.redColor.withAlpha(150), width: 1)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorApp.redColor.withAlpha(150), width: 0.5),
                    borderRadius: BorderRadius.circular(Values.circle)),
                label: Container(
                    decoration: BoxDecoration(
                        // color: ColorApp.backgroundColor2,
                        borderRadius: BorderRadius.circular(Values.circle)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    child: Text(name,
                        style: StringStyle.textTable
                            .copyWith(color: ColorApp.subColor))),

                // label: Container(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                //     child: Text(name, style: StringStyle.textLabil))
              ),
              validator: validator));

  static Widget inputString3(String name, TextEditingController controller,
          {int isNumber = 0, void Function(String)? onFieldSubmitted}) =>
      Container(
        margin: EdgeInsets.all(Values.circle * 0.3),
        width: 300.w,
        height: 45.h,
        child: TextField(
          inputFormatters: [
            if (isNumber >= 1) FilteringTextInputFormatter.digitsOnly,
            if (isNumber >= 1) LengthLimitingTextInputFormatter(isNumber),
          ],
          controller: controller,
          decoration: InputDecoration(
              fillColor: ColorApp.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorApp.subColor, width: 2),
                  borderRadius: BorderRadius.circular(Values.circle)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorApp.whiteColor, width: 2),
                  borderRadius: BorderRadius.circular(Values.circle)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Values.circle)),
              label: Container(
                  decoration: BoxDecoration(
                      color: ColorApp.headerColor,
                      borderRadius: BorderRadius.circular(Values.circle)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  child: Text(
                    name,
                    style: StringStyle.textButtom
                        .copyWith(color: ColorApp.blackColor),
                  ))),
        ),
      );
}

 
// class LoactionDropdown extends StatelessWidget {
//   final LocationController controller = Get.find<LocationController>();
//   final String? Function(String?)? validator; // إضافة خاصية التحقق

//   LoactionDropdown({super.key, this.validator});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(Values.circle * 0.5),
//       decoration: BoxDecoration(boxShadow: ShadowValues.shadowValues2),
//       width: 250,
//       child: FormField<String>(
//         validator: (value) {
//           if (controller.selectedLocations.value == null) {
//             return "يرجى اختيار الموقع";
//           }
//           return null;
//         },
//         builder: (state) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropDownSearchField(
//                 displayAllSuggestionWhenTap: false,
//                 isMultiSelectDropdown: false,
//                 textFieldConfiguration: TextFieldConfiguration(
//                     controller: controller.searchController,
//                     autofocus: true,
//                     style: StringStyle.textTable,
//                     decoration: InputDecoration(
//                         fillColor: ColorApp.whiteColor,
//                         filled: true,
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                                 color: Color.fromARGB(255, 168, 168, 168),
//                                 width: 2),
//                             borderRadius:
//                                 BorderRadius.circular(Values.circle * 1)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                                 color: ColorApp.subColor, width: 2),
//                             borderRadius:
//                                 BorderRadius.circular(Values.circle * 0.5)),
//                         border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.circular(Values.circle * 0.5)),
//                         label: Container(
//                             decoration: BoxDecoration(
//                               color: ColorApp.backgroundColorContent,
//                               borderRadius:
//                                   BorderRadius.circular(Values.circle),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 5),
//                             child:
//                                 Text('الموقع', style: StringStyle.textLabil)))),
//                 suggestionsCallback: (pattern) async {
//                   return controller.filterCustomersByText(pattern);
//                 },
//                 itemBuilder: (context, suggestion) {
//                   return ListTile(
//                     leading: const Icon(Icons.person),
//                     title: Text(suggestion.name),
//                     subtitle: Text(suggestion.description ?? ''),
//                   );
//                 },
//                 onSuggestionSelected: (suggestion) {
//                   controller.selectedLocations.value = suggestion;
//                   controller.searchController.text = suggestion.name;
//                   state.didChange(suggestion.name); // تحديث الحالة
//                 },
//               ),
//               if (state.hasError)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5),
//                   child: Text(
//                     state.errorText!,
//                     style: const TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
 