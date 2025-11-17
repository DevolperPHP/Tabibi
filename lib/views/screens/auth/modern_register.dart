import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/design_system/modern_theme.dart';
import '../../../utils/validators.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/modern/modern_button.dart';
import '../../widgets/modern/modern_input_field.dart';
import '../../widgets/modern/modern_selection_card.dart';
import '../../widgets/animated_logo.dart';

class ModernRegister extends StatefulWidget {
  const ModernRegister({super.key});

  @override
  State<ModernRegister> createState() => _ModernRegisterState();
}

class _ModernRegisterState extends State<ModernRegister> {
  final AuthController _authController = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();
  // Use the same form key as AuthController to ensure proper validation
  GlobalKey<FormState> get _formKey => _authController.formKeyRegister;

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header with Logo
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ModernTheme.spaceLG,
                  vertical: ModernTheme.spaceXL,
                ),
                child: Column(
                  children: [
                    // Logo
                    AnimatedLogo(
                      size: 80.h,
                      heroTag: 'register_logo',
                    ),
                    SizedBox(height: ModernTheme.spaceMD),

                    // Welcome Text
                    Text(
                      'إنشاء حساب جديد',
                      style: ModernTheme.headlineMedium,
                    ),
                    SizedBox(height: ModernTheme.spaceSM),
                    Text(
                      'انضم إلينا واحصل على أفضل الرعاية الصحية',
                      style: ModernTheme.bodyMedium.copyWith(
                        color: ModernTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Form Content
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceLG),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      _buildSectionHeader(
                          'المعلومات الشخصية', Icons.person_outline),
                      SizedBox(height: ModernTheme.spaceMD),

                      ModernInputField(
                        label: 'الاسم الكامل',
                        hintText: 'أدخل اسمك الكامل',
                        controller: _authController.fullName,
                        validator: Validators.fullName,
                        prefixIcon: Icons.person_outline,
                      ),

                      SizedBox(height: ModernTheme.spaceMD),

                      ModernInputField(
                        label: 'العمر',
                        hintText: 'أدخل عمرك',
                        controller: _authController.age,
                        validator: Validators.age,
                        isNumber: true,
                        prefixIcon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                      ),

                      SizedBox(height: ModernTheme.spaceMD),

                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: ModernTheme.spaceSM),
                        decoration: BoxDecoration(
                          color: ModernTheme.surface,
                          borderRadius:
                              BorderRadius.circular(ModernTheme.radiusLG),
                          boxShadow: ModernTheme.shadowSM,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(ModernTheme.spaceMD),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.all(ModernTheme.spaceSM),
                                    decoration: BoxDecoration(
                                      color: ModernTheme.primaryBlue
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                          ModernTheme.radiusSM),
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: ModernTheme.primaryBlue,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: ModernTheme.spaceMD),
                                  Expanded(
                                    child: Text(
                                      'الجنس',
                                      style: ModernTheme.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: ModernTheme.spaceSM),

                              // Compact Options
                              Obx(() => Row(
                                    children: ['ذكر', 'أنثى'].map((option) {
                                      final isSelected = (option == 'ذكر' &&
                                              _authController.gender.value ==
                                                  'male') ||
                                          (option == 'أنثى' &&
                                              _authController.gender.value ==
                                                  'female');
                                      return Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: option == 'ذكر'
                                                ? ModernTheme.spaceSM
                                                : 0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () =>
                                                _authController.gender.value =
                                                    option == 'ذكر'
                                                        ? 'male'
                                                        : 'female',
                                            child: Container(
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? ModernTheme.primaryBlue
                                                    : ModernTheme.background,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ModernTheme.radiusMD),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? ModernTheme.primaryBlue
                                                      : ModernTheme.divider,
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      option == 'ذكر'
                                                          ? Icons.male
                                                          : Icons.female,
                                                      size: 14,
                                                      color: isSelected
                                                          ? ModernTheme.surface
                                                          : ModernTheme
                                                              .primaryBlue,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      option,
                                                      style: ModernTheme
                                                          .bodySmall
                                                          .copyWith(
                                                        color: isSelected
                                                            ? ModernTheme
                                                                .surface
                                                            : ModernTheme
                                                                .textPrimary,
                                                        fontWeight: isSelected
                                                            ? FontWeight.w600
                                                            : FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: ModernTheme.spaceLG),

                      // Contact Information Section
                      _buildSectionHeader(
                          'معلومات الاتصال', Icons.phone_outlined),
                      SizedBox(height: ModernTheme.spaceMD),

                      ModernPhoneInputField(
                        label: 'رقم الهاتف',
                        controller: _authController.phone,
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

                      SizedBox(height: ModernTheme.spaceMD),

                      ModernInputField(
                        label: 'حساب تيليجرام',
                        hintText: 'أدخل اسم المستخدم في تيليجرام',
                        controller: _authController.telegram,
                        validator: (v) =>
                            Validators.notEmpty(v, 'حساب تيليجرام'),
                        prefixIcon: Icons.send_outlined,
                      ),

                      SizedBox(height: ModernTheme.spaceMD),

                      ModernInputField(
                        label: 'البريد الإلكتروني',
                        hintText: 'أدخل بريدك الإلكتروني',
                        controller: _authController.email,
                        validator: Validators.email,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: ModernTheme.spaceLG),

                      // Location Information Section
                      _buildSectionHeader(
                          'معلومات الموقع', Icons.location_on_outlined),
                      SizedBox(height: ModernTheme.spaceMD),

                      Obx(() => ModernZoneSelector(
                            selectedZone: _authController.zone.value,
                            onZoneSelected: (zone) =>
                                _authController.zone.value = zone,
                            zones: baghdadZones,
                          )),

                      SizedBox(height: ModernTheme.spaceLG),

                      // Password Section
                      _buildSectionHeader('كلمة المرور', Icons.lock_outline),
                      SizedBox(height: ModernTheme.spaceMD),

                      ModernInputField(
                        label: 'كلمة المرور',
                        hintText: 'أدخل كلمة المرور',
                        controller: _authController.password,
                        validator: Validators.password,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                      ),

                      SizedBox(height: ModernTheme.spaceMD),

                      ModernInputField(
                        label: 'تأكيد كلمة المرور',
                        hintText: 'أعد إدخال كلمة المرور',
                        controller: _authController.confirmPassword,
                        validator: (v) => Validators.confirmPassword(
                            v, _authController.password.text),
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                      ),

                      SizedBox(height: ModernTheme.spaceXL),

                      // Terms and Conditions
                      _buildTermsSection(),

                      SizedBox(height: ModernTheme.spaceXL),

                      // Register Button
                      Obx(() => ModernButton(
                            text: 'إنشاء حساب',
                            onPressed: _submitForm,
                            isLoading: _authController.isLoading.value,
                            icon: Icons.arrow_back,
                          )),

                      SizedBox(height: ModernTheme.spaceLG),

                      // Login Link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'لديك حساب بالفعل؟ ',
                            style: ModernTheme.bodyMedium.copyWith(
                              color: ModernTheme.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'سجل دخول',
                                style: ModernTheme.bodyMedium.copyWith(
                                  color: ModernTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = Get.back,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: ModernTheme.space2XL),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: ModernTheme.primaryBlue,
            size: 24,
          ),
          SizedBox(width: ModernTheme.spaceMD),
          Text(
            title,
            style: ModernTheme.titleLarge.copyWith(
              color: ModernTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Container(
      padding: EdgeInsets.all(ModernTheme.spaceMD),
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.circular(ModernTheme.radiusLG),
        boxShadow: ModernTheme.shadowSM,
        border: Border.all(
          color: ModernTheme.divider,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: ModernTheme.primaryBlue,
                size: 20,
              ),
              SizedBox(width: ModernTheme.spaceMD),
              Expanded(
                child: Text(
                  'الشروط والأحكام',
                  style: ModernTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ModernTheme.spaceMD),
          Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: _authController.acceptTerms.value,
                      onChanged: (value) =>
                          _authController.acceptTerms.value = value ?? false,
                      activeColor: ModernTheme.primaryBlue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ModernTheme.radiusSM),
                      ),
                    ),
                  ),
                  SizedBox(width: ModernTheme.spaceMD),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showTermsDialog(),
                      child: Text.rich(
                        TextSpan(
                          text: 'أوافق على ',
                          style: ModernTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'الشروط والأحكام',
                              style: ModernTheme.bodyMedium.copyWith(
                                color: ModernTheme.primaryBlue,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' و ',
                              style: ModernTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: 'سياسة الخصوصية',
                              style: ModernTheme.bodyMedium.copyWith(
                                color: ModernTheme.primaryBlue,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
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
    );
  }

  void _submitForm() {
    // Validate form fields
    if (_formKey.currentState?.validate() ?? false) {
      // Manual validation for zone
      if (_authController.zone.value.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'يرجى اختيار المنطقة',
          backgroundColor: ModernTheme.warning,
          colorText: ModernTheme.surface,
          icon: Icon(Icons.warning, color: ModernTheme.surface),
        );
        return;
      }

      // Manual validation for gender
      if (_authController.gender.value.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'يرجى اختيار الجنس',
          backgroundColor: ModernTheme.warning,
          colorText: ModernTheme.surface,
          icon: Icon(Icons.warning, color: ModernTheme.surface),
        );
        return;
      }

      // Check terms acceptance
      if (!_authController.acceptTerms.value) {
        Get.snackbar(
          'تنبيه',
          'يجب الموافقة على الشروط والأحكام',
          backgroundColor: ModernTheme.warning,
          colorText: ModernTheme.surface,
          icon: Icon(Icons.warning, color: ModernTheme.surface),
        );
        return;
      }

      _authController.submitFormRegister();
    }
  }

  void _showTermsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModernTermsDialog(),
    );
  }
}

class ModernTermsDialog extends StatefulWidget {
  const ModernTermsDialog({super.key});

  @override
  State<ModernTermsDialog> createState() => _ModernTermsDialogState();
}

class _ModernTermsDialogState extends State<ModernTermsDialog> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: ModernTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ModernTheme.radiusXL),
          topRight: Radius.circular(ModernTheme.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: ModernTheme.spaceMD),
            decoration: BoxDecoration(
              color: ModernTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ModernTheme.spaceSM),
                  decoration: BoxDecoration(
                    color: ModernTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: ModernTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                SizedBox(width: ModernTheme.spaceMD),
                Expanded(
                  child: Text(
                    'شروط وأحكام تطبيق طبيبي',
                    style: ModernTheme.titleLarge,
                  ),
                ),
                ModernIconButton(
                  icon: Icons.close,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الشروط والأحكام لتطبيق طبيبي:',
                    style: ModernTheme.titleMedium.copyWith(
                      color: ModernTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ModernTheme.spaceSM),
                  Text(
                    'يرجى قراءة الشروط والأحكام بعناية قبل التسجيل. باستخدامك للتطبيق، فإنك توافق على الالتزام بهذه الشروط.',
                    style: ModernTheme.bodyMedium.copyWith(
                      color: ModernTheme.textSecondary,
                    ),
                  ),

                  SizedBox(height: ModernTheme.spaceMD),

                  // Expand/Collapse button
                  ModernButton(
                    text: isExpanded ? 'إخفاء التفاصيل' : 'عرض الشروط الكاملة',
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    buttonType: ButtonType.outline,
                    icon: isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),

                  // Detailed terms (expandable)
                  if (isExpanded) ...[
                    SizedBox(height: ModernTheme.spaceMD),
                    _buildTermsContent(),
                  ],
                ],
              ),
            ),
          ),

          // Footer
          Padding(
            padding: EdgeInsets.all(ModernTheme.spaceMD),
            child: ModernButton(
              text: 'إغلاق',
              onPressed: () => Navigator.pop(context),
              buttonType: ButtonType.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('1. التعريف بالمنصة'),
        _buildSectionText(
            'طبيبي هي منصة طبية تسعى إلى تقديم تجربة علاجية متكاملة داخل العيادات الجامعية، تحت إشراف نخبة من الأطباء الاختصاص لضمان جودة الخدمة العلاجية حيث تعمل المنصّة كوسيط بين طلاب طب الأسنان والمرضى لتسهيل الحصول على العلاج ضمن إطار التدريب الجامعي.'),
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
            'يجب التحقق من هوية الطلاب والمستخدمين لضمان أن جميع الحسابات حقيقية، مثل تقديم بطاقة جامعية للطلاب و رقم هاتف موثق للمرضى.'),
        _buildSectionTitle('4. البيانات والمعلومات'),
        _buildSectionText(
            'الطلاب والمرضى مسؤولون عن صحة المعلومات التي يقدمونها. أي خطأ أو كذب يتحمل المستخدم مسؤوليته الكاملة.'),
        _buildSectionText(
            'الصور والمعلومات التي يقدمها المستخدمون تبقى كما هي بدون تعديل، والمسؤولية على الطالب والمريض للتأكد من صحتها قبل الإرسال.'),
        _buildSectionText(
            'يمكن للمنصة استخدام البيانات لتحسين تجربة المستخدم، مع الحفاظ على سرية الهوية.'),
        _buildSectionText(
            'الصور تحفظ لمدة 30 يومًا، بينما يبقى التاريخ الطبي والمعلومات القانونية للمستخدم حسب الحاجة.'),
        _buildSectionText(
            'تلتزم المنصة بحماية بيانات مستخدميها قدر المستطاع.'),
        _buildSectionTitle('5. المسؤولية القانونية'),
        _buildSectionText(
            'وجود المعلومات الطبية على المنصة لا يعفي الطالب من أخذ التاريخ الطبي الكامل للمريض.'),
        _buildSectionText(
            'لا تتحمل المنصّة أي مسؤولية قانونية أو مهنية عن أي تصرفات أو قرارات يتخذها الطالب استنادًا إلى المعلومات أو الخدمات المقدَّمة عبر المنصّة، ويُعتبر الطالب وحده المسؤول عن جميع أفعاله ونتائجها وتؤكد على ان عملها ينطوي فقط على الوصل بين المريض والطالب.'),
        _buildSectionTitle('6. الدفع والاسترداد'),
        _buildSectionText(
            'الطالب يدفع أجور جلب الحالة فقط، ولا توجد أي رسوم إضافية أو اشتراكات.'),
        _buildSectionText(
            'يحق للطالب استرداد أمواله إذا أثبت تخلف المريض وعدم إلتزامه أو عدم تطابق الحالة سريريًا بالأشعة وسيتم إرجاع المبلغ المخصوم له مع خصم رسوم التشغيل الخاصة بالمنصة.مع حد أقصى استرداد مره واحده أسبوعياً.'),
        _buildSectionTitle('7. التزامات المنصة'),
        _buildSectionText(
            'المنصة قد تتوقف مؤقتًا لأغراض الصيانة أو التحديثات.'),
        _buildSectionText(
            'المنصة توفر وسائل التواصل الرسمية مع الدعم عبر قناة تلغرام أو وسائل معتمدة أخرى.'),
        _buildSectionText(
            'المنصة تحافظ على حقها في تعديل الشروط والأحكام في أي وقت دون إشعار مسبق.'),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: ModernTheme.spaceMD,
        bottom: ModernTheme.spaceSM,
      ),
      child: Text(
        title,
        style: ModernTheme.bodyLarge.copyWith(
          color: ModernTheme.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ModernTheme.spaceSM,
        right: ModernTheme.spaceMD,
      ),
      child: Text(
        text,
        style: ModernTheme.bodySmall.copyWith(
          color: ModernTheme.textSecondary,
          height: 1.4,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
