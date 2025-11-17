// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../../../utils/validators.dart';
import '../../widgets/actions_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/input_text.dart';
import '../../widgets/animated_logo.dart';
import '../../widgets/message_snak.dart';

class Register extends StatelessWidget {
  Register({super.key});
  AuthController authController = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Values.spacerV.h),
          child: ListView(children: [
            SizedBox(height: Values.spacerV * 3),
            Center(
              child: AnimatedLogo(
                size: 120,
                heroTag: 'register_old_logo',
              ),
            ),
            SizedBox(height: Values.spacerV * 2),
            Form(
                key: authController.formKeyRegister,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Personal information
                      InputText.inputStringValidatorIcon(
                          'الأسم الكامل', authController.fullName,
                          icon: CupertinoIcons.person,
                          validator: Validators.fullName),
                      SizedBox(height: Values.circle),
                      InputText.inputStringValidatorIcon(
                          'العمر', authController.age,
                          icon: CupertinoIcons.calendar_today,
                          isNumber: 2,
                          validator: (value) =>
                              Validators.notEmpty(value, 'العمر')),
                      SizedBox(height: Values.circle),

                      // Gender Selection - Compact Design
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Values.circle * 0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_outline,
                                    color: ColorApp.primaryColor, size: 16),
                                SizedBox(width: 6),
                                Text('الجنس', style: StringStyle.textLabilBold),
                              ],
                            ),
                            SizedBox(height: 8),
                            Obx(() => Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => authController
                                            .gender.value = 'male',
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                authController.gender.value ==
                                                        'male'
                                                    ? ColorApp.primaryColor
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color:
                                                  authController.gender.value ==
                                                          'male'
                                                      ? ColorApp.primaryColor
                                                      : ColorApp.subColor
                                                          .withAlpha(100),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.male,
                                                color: authController
                                                            .gender.value ==
                                                        'male'
                                                    ? Colors.white
                                                    : ColorApp.primaryColor,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'ذكر',
                                                style: StringStyle.textLabil
                                                    .copyWith(
                                                  color: authController
                                                              .gender.value ==
                                                          'male'
                                                      ? Colors.white
                                                      : ColorApp.textFourColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => authController
                                            .gender.value = 'female',
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                authController.gender.value ==
                                                        'female'
                                                    ? ColorApp.primaryColor
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color:
                                                  authController.gender.value ==
                                                          'female'
                                                      ? ColorApp.primaryColor
                                                      : ColorApp.subColor
                                                          .withAlpha(100),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.female,
                                                color: authController
                                                            .gender.value ==
                                                        'female'
                                                    ? Colors.white
                                                    : ColorApp.primaryColor,
                                                size: 16,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'أنثى',
                                                style: StringStyle.textLabil
                                                    .copyWith(
                                                  color: authController
                                                              .gender.value ==
                                                          'female'
                                                      ? Colors.white
                                                      : ColorApp.textFourColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: Values.circle),

                      // Phone Number
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Values.circle * 0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Phone Icon with container
                                Container(
                                  height: 50,
                                  width: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(Values.circle),
                                      bottomRight:
                                          Radius.circular(Values.circle),
                                    ),
                                    border: Border.all(
                                        color:
                                            ColorApp.subColor.withAlpha(100)),
                                  ),
                                  child: Icon(Icons.phone,
                                      color: ColorApp.primaryColor,
                                      size: 20),
                                ),
                                // Phone Input
                                Expanded(
                                  child: TextFormField(
                                    controller: authController.phone,
                                    keyboardType: TextInputType.number,
                                    maxLength: 11,
                                    decoration: InputDecoration(
                                      hintText: '07XXXXXXXXX',
                                      counterText: '',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Values.circle),
                                          bottomLeft:
                                              Radius.circular(Values.circle),
                                        ),
                                        borderSide: BorderSide(
                                            color: ColorApp.subColor
                                                .withAlpha(100)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Values.circle),
                                          bottomLeft:
                                              Radius.circular(Values.circle),
                                        ),
                                        borderSide: BorderSide(
                                            color: ColorApp.subColor
                                                .withAlpha(100)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Values.circle),
                                          bottomLeft:
                                              Radius.circular(Values.circle),
                                        ),
                                        borderSide: BorderSide(
                                            color: ColorApp.primaryColor,
                                            width: 2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'رقم الهاتف مطلوب';
                                      }
                                      // التحقق من 11 رقم
                                      if (v.trim().length != 11) {
                                        return 'يجب أن يتكون رقم الهاتف من 11 رقم';
                                      }
                                      return Validators.iraqiPhone(v.trim());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Values.circle),

                      InputText.inputStringValidatorIcon(
                          'حساب تيليجرام', authController.telegram,
                          icon: Icons.telegram,
                          validator: (v) =>
                              Validators.notEmpty(v, 'حساب تيليجرام')),
                      SizedBox(height: Values.circle),

                      // Zone Selection in Baghdad
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Values.circle * 0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: ColorApp.primaryColor, size: 18),
                                SizedBox(width: 8),
                                Text('المنطقة في بغداد',
                                    style: StringStyle.textLabilBold),
                              ],
                            ),
                            SizedBox(height: 8),
                            Obx(() => GestureDetector(
                                  onTap: () =>
                                      _showZoneSelectionDialog(context),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius:
                                          BorderRadius.circular(Values.circle),
                                      border: Border.all(
                                          color:
                                              ColorApp.subColor.withAlpha(100)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            authController.zone.value.isEmpty
                                                ? 'اختر منطقتك'
                                                : authController.zone.value,
                                            style:
                                                StringStyle.textLabil.copyWith(
                                              color: authController
                                                      .zone.value.isEmpty
                                                  ? Colors.grey[600]
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down,
                                            color: ColorApp.primaryColor),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: Values.circle),
                      InputText.inputStringValidatorIcon(
                          'البريد الإلكتروني', authController.email,
                          icon: Icons.alternate_email_outlined,
                          validator: Validators.email),
                      SizedBox(height: Values.circle),

                      SizedBox(height: Values.circle),
                      // Select Contres

                      SizedBox(height: Values.circle),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                            color: ColorApp.subColor.withAlpha(150),
                            thickness: 0.8),
                      ),
                      // Password
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('كلمة المرور', style: StringStyle.headerStyle),
                      ),
                      SizedBox(height: Values.circle),
                      InputText.inputStringValidatorIcon(
                          isPassword: true,
                          'كلمة المرور ',
                          authController.password,
                          validator: Validators.password,
                          icon: Icons.password_outlined),
                      SizedBox(height: Values.spacerV),
                      InputText.inputStringValidatorIcon(
                          isPassword: true,
                          'تأكيد كلمة المرور ',
                          authController.confirmPassword,
                          validator: (v) => Validators.confirmPassword(
                              v, authController.password.text),
                          icon: Icons.password_outlined),
                      SizedBox(height: Values.spacerV),

                      // Terms and Conditions
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Values.circle * 0.3),
                        padding: EdgeInsets.all(Values.circle),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(Values.circle),
                          border: Border.all(
                              color: ColorApp.subColor.withAlpha(100)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox with text
                            Obx(() => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: authController.acceptTerms.value,
                                      onChanged: (value) => authController
                                          .acceptTerms.value = value ?? false,
                                      activeColor: ColorApp.primaryColor,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _showTermsDialog(context),
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'أوافق على ',
                                            style: StringStyle.textLabil
                                                .copyWith(fontSize: 14),
                                            children: [
                                              TextSpan(
                                                text: 'الشروط والأحكام',
                                                style: StringStyle.textLabil
                                                    .copyWith(
                                                  fontSize: 14,
                                                  color: ColorApp.primaryColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: Values.spacerV),
                    ])),

            SizedBox(height: Values.spacerV),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Values.spacerV),
              child: Obx(() => authController.isLoading.value
                  ? LoadingIndicator()
                  : BottonsC.action1('حساب جديد', _submitForm,
                      icon: Icons.keyboard_arrow_left_outlined)),
            ),
            //
            SizedBox(height: Values.spacerV),
            Center(
                child: RichText(
                    text: TextSpan(
                        text: 'لديك حساب ؟ ',
                        style: StringStyle.textLabil,
                        children: [
                  TextSpan(
                      text: 'سجل دخول',
                      style: StringStyle.textLabil
                          .copyWith(color: ColorApp.primaryColor),
                      recognizer: TapGestureRecognizer()
                        // هنا يمكنك تحديد ما يحدث عند النقر على النصx
                        ..onTap = Get.back)
                ]))),
            SizedBox(height: Values.spacerV),
          ])),
    );
  }

  void _submitForm() {
    // Validate form fields first
    if (authController.formKeyRegister.currentState?.validate() ?? false) {
      // Manual validation for zone (not a FormField)
      if (authController.zone.value.isEmpty) {
        MessageSnak.message('يرجى اختيار المنطقة', color: ColorApp.redColor);
        return;
      }

      // Manual validation for gender (not a FormField)
      if (authController.gender.value.isEmpty) {
        MessageSnak.message('يرجى اختيار الجنس', color: ColorApp.redColor);
        return;
      }

      // Check terms acceptance
      if (!authController.acceptTerms.value) {
        MessageSnak.message('يجب الموافقة على الشروط والأحكام',
            color: ColorApp.redColor);
        return;
      }

      // All validations passed, submit the form
      authController.submitFormRegister();
    } else {
      MessageSnak.message('يرجى ملء كل الحقول المطلوبة',
          color: ColorApp.redColor);
    }
  }

  Widget _buildOptionButton(
      String label, String value, bool isSelected, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Values.circle * 0.5),
        splashColor: ColorApp.primaryColor.withOpacity(0.2),
        highlightColor: ColorApp.primaryColor.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? ColorApp.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(Values.circle * 0.5),
            border: Border.all(
              color: isSelected
                  ? ColorApp.primaryColor
                  : ColorApp.subColor.withAlpha(150),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ColorApp.primaryColor.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: StringStyle.textLabilBold.copyWith(
                color: isSelected ? Colors.white : ColorApp.textFourColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Values.circle * 0.5, right: Values.circle * 0.5),
      child: Text(
        text,
        style: StringStyle.textLabil.copyWith(
          fontSize: 13,
          color: Colors.grey[700],
          height: 1.4,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TermsDialog();
      },
    );
  }

  void _showZoneSelectionDialog(BuildContext context) {
    final List<String> baghdadZones = [
      'اختر هذا الخيار في حال عدم وجود منطقتك',
      'الكرادة',
      'الزعفرانية',
      'زيونة',
      'بغداد الجديدة',
      'شارع فلسطين',
      'البلديات',
      'مدينة الصدر',
      'أور',
      'الحبيبية',
      'المشتل',
      'الغدير',
      'جميلة',
      'حي تونس',
      'الشعب',
      'حي القاهرة',
      'حي الجزائر',
      'باب الشرقي',
      'باب المعظم',
      'الشورجة',
      'الفضل',
      'ساحة الميدان',
      'البتاوين',
      'المنصور',
      'اليرموك',
      'الغزالية',
      'العامرية',
      'الخضراء',
      'الجامعة',
      'السيدية',
      'الدورة',
      'البياع',
      'حي الجهاد',
      'حي العامل',
      'حي الإعلام',
      'العطيفية',
      'القادسية',
      'حي العدل',
      'حي السلام',
      'حي المخابرات',
      'حي القادسية',
      'حي المأمون',
      'حي الزيتون',
      'النصر والسلام',
      'زيدان',
      'الكرمة',
      'المشاهدة',
      'العبايجي',
      'الطارمية المركز',
      'النهروان',
      'الوحدة',
      'الجعارة',
      'المدائن',
      'اللطيفية',
      'اليوسفية',
      'المحمودية المركز'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ZoneSelectionDialog(
          zones: baghdadZones,
          onZoneSelected: (zone) {
            authController.zone.value = zone;
            Get.back();
          },
        );
      },
    );
  }
}

// Separate widget for Terms Dialog to avoid state management issues
class TermsDialog extends StatefulWidget {
  const TermsDialog({super.key});

  @override
  State<TermsDialog> createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Values.circle),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(Values.circle),
              decoration: BoxDecoration(
                color: ColorApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Values.circle),
                  topRight: Radius.circular(Values.circle),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: ColorApp.primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'شروط وأحكام تطبيق طبيبي',
                    style: StringStyle.headerStyle.copyWith(
                      fontSize: 16,
                      color: ColorApp.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: Container(
                padding: EdgeInsets.all(Values.circle),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary section (always visible)
                      Text(
                        'هذه الشروط والأحكام تحكم استخدامك لتطبيق طبيبي. يرجى قراءتها بعناية قبل التسجيل.',
                        style: StringStyle.textLabil.copyWith(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: Values.circle),

                      // Expand/Collapse button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(Values.circle * 0.5),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                                BorderRadius.circular(Values.circle * 0.5),
                            border: Border.all(
                                color: ColorApp.primaryColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: ColorApp.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                isExpanded
                                    ? 'إخفاء التفاصيل'
                                    : 'عرض الشروط الكاملة',
                                style: StringStyle.textLabilBold.copyWith(
                                  color: ColorApp.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Detailed terms (expandable)
                      if (isExpanded) ...[
                        SizedBox(height: Values.circle),
                        _buildTermsContent(),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(Values.circle),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Values.circle),
                  bottomRight: Radius.circular(Values.circle),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'إغلاق',
                      style: StringStyle.textLabilBold.copyWith(
                        color: ColorApp.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: Values.circle, bottom: Values.circle * 0.5),
      child: Text(
        title,
        style: StringStyle.textLabilBold.copyWith(
          fontSize: 14,
          color: ColorApp.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Values.circle * 0.5, right: Values.circle * 0.5),
      child: Text(
        text,
        style: StringStyle.textLabil.copyWith(
          fontSize: 13,
          color: Colors.grey[700],
          height: 1.4,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('1. التعريف بالمنصة'),
        _buildSectionText(
            'تعمل هذه المنصة كوسيط فقط بين طلاب طب الأسنان والمرضى لتسهيل الحصول على العلاج ضمن إطار التدريب الجامعي، دون أن تتحمل المنصة أو الجامعة أي مسؤولية عن نتائج العلاج أو الأخطاء الطبية.'),
        _buildSectionTitle('2. نطاق الاستخدام'),
        _buildSectionText('المنصة متاحة داخل العراق فقط.'),
        _buildSectionText(
            'العمل عبر المنصة متاح خلال موسم العيادات الجامعية، من 10 أيلول حتى نهاية مايو من كل عام.'),
        _buildSectionTitle('3. التسجيل والاستخدام'),
        _buildSectionText('المستخدمون يجب أن تتراوح أعمارهم بين 18 و70 سنة.'),
        _buildSectionText(
            'الطالب يستخدم المنصة لأغراض التدريب والدراسة فقط، ولا يجوز استخدامه لأي غرض تجاري أو شخصي.'),
        _buildSectionText(
            'الحجز المباشر للمرضى غير متاح، ويتم التواصل مع المرضى من خلال الأطباء فقط.'),
        _buildSectionText(
            'يجب التحقق من هوية الطلاب والمستخدمين لضمان أن جميع الحسابات حقيقية، مثل تقديم بطاقة جامعية للطلاب وبطاقة شخصية أو رقم هاتف موثق للمرضى.'),
        _buildSectionTitle('4. البيانات والمعلومات'),
        _buildSectionText(
            'الطلاب والمرضى مسؤولون عن صحة المعلومات التي يقدمونها. أي خطأ أو كذب يتحمل المستخدم مسؤوليته القانونية الكاملة.'),
        _buildSectionText(
            'الصور والمعلومات التي يقدمها المستخدمون تبقى كما هي بدون تعديل، والمسؤولية على الطالب والمريض للتأكد من صحتها قبل الإرسال.'),
        _buildSectionText(
            'يمكن للمنصة استخدام البيانات لتحسين تجربة المستخدم، مع الحفاظ على سرية الهوية.'),
        _buildSectionText(
            'الصور تحفظ لمدة 30 يومًا، بينما يبقى التاريخ الطبي والمعلومات القانونية للمستخدم حسب الحاجة.'),
        _buildSectionText(
            'المنصة تحمي البيانات بقدر المستطاع، ولكن أي تسريب خارجي ليس من مسؤوليتها.'),
        _buildSectionTitle('5. المسؤولية القانونية'),
        _buildSectionText(
            'الطالب يتحمل كافة التبعات القانونية الناتجة عن أي ضرر أو إهمال أثناء العلاج.'),
        _buildSectionText(
            'وجود المعلومات الطبية على المنصة لا يعفي الطالب من أخذ التاريخ الطبي الكامل للمريض.'),
        _buildSectionText(
            'المنصة لا تتحمل أي مسؤولية عن الأخطاء أو المضاعفات الناتجة عن تصرفات الطالب.'),
        _buildSectionTitle('6. الدفع والاسترداد'),
        _buildSectionText(
            'الطالب يدفع أجور جلب الحالة فقط، ولا توجد أي رسوم إضافية أو اشتراكات.'),
        _buildSectionText(
            'يحق للطالب استرداد أمواله إذا أثبت تخلف المريض عن الموعد أو عدم تطابق الحالة سريريًا بالأشعة، مع حد أقصى استرداد مرتين أسبوعيًا.'),
        _buildSectionTitle('7. التزامات المنصة'),
        _buildSectionText(
            'المنصة قد تتوقف مؤقتًا لأغراض الصيانة أو التحديثات، دون تحمل أي مسؤولية عن توقف الخدمة.'),
        _buildSectionText(
            'المنصة توفر وسائل التواصل الرسمية مع الدعم عبر قناة تلغرام أو وسائل معتمدة أخرى.'),
        _buildSectionText(
            'المنصة تحافظ على حقها في تعديل الشروط والأحكام في أي وقت دون إشعار مسبق.'),
        _buildSectionText(
            'المنصة تسعى لتحسين صحة الفم والأسنان، لكنها لا تضمن أي نتائج علاجية.'),
        _buildSectionText(
            'المنصة تقدم الأدلة والسجلات المتاحة فقط عند حدوث نزاعات، دون اتخاذ قرار قانوني.'),
        _buildSectionTitle('8. حقوق الملكية'),
        _buildSectionText(
            'جميع المحتويات داخل المنصة، بما في ذلك الصور والتعليمات والمعلومات المقدمة من الطلاب والمستخدمين، مملوكة للمنصة أو محفوظة الحقوق لأصحابها.'),
        _buildSectionTitle('9. الانتهاكات'),
        _buildSectionText(
            'في حالة انتهاك أي مستخدم للشروط، يحق للمنصة تعليق الحساب، إيقافه، منعه من الاستخدام مستقبلاً، واللجوء إلى القضاء إذا لزم الأمر.'),
        _buildSectionTitle('10. القوانين والاختصاص'),
        _buildSectionText('أي نزاع قانوني يخضع للقانون العراقي.'),
        _buildSectionTitle('11. الإشعارات والتنبيهات'),
        _buildSectionText(
            'جميع الإشعارات والتنبيهات داخل التطبيق إلزامية ولا يمكن إيقافها.'),
        _buildSectionTitle('12. البنود العامة'),
        _buildSectionText(
            'أي حالة غير مذكورة في هذه الشروط تخضع لتقدير المنصة واتخاذ القرار المناسب.'),
      ],
    );
  }
}

// Zone Selection Dialog Widget
class ZoneSelectionDialog extends StatefulWidget {
  final List<String> zones;
  final Function(String) onZoneSelected;

  const ZoneSelectionDialog({
    super.key,
    required this.zones,
    required this.onZoneSelected,
  });

  @override
  State<ZoneSelectionDialog> createState() => _ZoneSelectionDialogState();
}

class _ZoneSelectionDialogState extends State<ZoneSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredZones = [];

  @override
  void initState() {
    super.initState();
    _filteredZones = List.from(widget.zones);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterZones(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredZones = List.from(widget.zones);
      } else {
        _filteredZones = widget.zones
            .where((zone) => zone.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Values.circle),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(Values.circle),
              decoration: BoxDecoration(
                color: ColorApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Values.circle),
                  topRight: Radius.circular(Values.circle),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: ColorApp.primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'اختر منطقتك في بغداد',
                    style: StringStyle.headerStyle.copyWith(
                      fontSize: 16,
                      color: ColorApp.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: EdgeInsets.all(Values.circle),
              child: TextField(
                controller: _searchController,
                onChanged: _filterZones,
                decoration: InputDecoration(
                  hintText: 'ابحث عن منطقتك...',
                  prefixIcon: Icon(Icons.search, color: ColorApp.primaryColor),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Values.circle),
                    borderSide:
                        BorderSide(color: ColorApp.subColor.withAlpha(100)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Values.circle),
                    borderSide:
                        BorderSide(color: ColorApp.primaryColor, width: 2),
                  ),
                ),
              ),
            ),

            // Zones List
            Expanded(
              child: _filteredZones.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'لم يتم العثور على نتائج',
                            style: StringStyle.textLabil.copyWith(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'حاول تغيير كلمة البحث',
                            style: StringStyle.textLabil.copyWith(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredZones.length,
                      itemBuilder: (context, index) {
                        final zone = _filteredZones[index];
                        return ListTile(
                          title: Text(
                            zone,
                            style: StringStyle.textLabil,
                            textAlign: TextAlign.right,
                          ),
                          onTap: () => widget.onZoneSelected(zone),
                        );
                      },
                    ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(Values.circle),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Values.circle),
                  bottomRight: Radius.circular(Values.circle),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'إلغاء',
                      style: StringStyle.textLabilBold.copyWith(
                        color: ColorApp.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
