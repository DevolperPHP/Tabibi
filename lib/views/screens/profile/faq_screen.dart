import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/design_system/modern_theme.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Header
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF007AFF),
                    Color(0xFF5856D6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and title on the right
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'طبيبي',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Back arrow on the left
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Card
                  Container(
                    margin: EdgeInsets.only(bottom: 24.0),
                    padding: EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF007AFF).withOpacity(0.08),
                          Color(0xFF5856D6).withOpacity(0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF007AFF).withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  'الأسئلة الشائعة',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C1C1E),
                                    letterSpacing: -0.5,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(height: 4),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  'إجابات على الاستفسارات المتكررة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF8E8E93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.help_outline_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // FAQ Sections
                  _buildFAQSection(
                    'أولاً: تخص المرضى',
                    Icons.person,
                    [
                      {
                        'question': 'ليش حالتي انرفضت؟',
                        'answer': 'ممكن تكون الصورة مو واضحة أو الحالة مكررة أو ما تنطبق على متطلبات التدريب. تقدر تعيد إرسالها بعد التعديل.'
                      },
                      {
                        'question': 'الطبيب ما تواصل وياي بعد الطلب؟',
                        'answer': 'انتظر فترة قصيرة، وإذا ما صار تواصل، بلغ الدعم حتى يتابعون الحالة.'
                      },
                      {
                        'question': 'أگدر أأجّل الموعد بعد ما أحدده؟',
                        'answer': 'يفضل إتمام علاجك بأسرع وقت تجنباً لتأخير الأطباء لكناذا كان عندك ظرف طارئ تأجل الموعد بالتفاهم مع الطبيب المسؤول عن علاجك.'
                      },
                      {
                        'question': 'أگدر أبدّل الطبيب أو المريض؟',
                        'answer': 'لا يمكن تبديل الطبيب أو المريض إلا في حالات خاصة يحددها فريق الدعم بعد مراجعة الحالة.'
                      },
                      {
                        'question': 'هل ممكن تستخدمون الصور لأغراض تعليمية؟',
                        'answer': 'نحن ملتزمين بسياسة حماية بيانات مستخدمينا ومنعها من التسرب وفي حال تم استخدام صور لأغراض تعليمية سيتم التأكد من عدم احتوائها على اي معلومات شخصية.'
                      },
                      {
                        'question': 'شلون أبلغ عن مستخدم مسيء؟',
                        'answer': 'سجل معلومات الشخص المسيء سواء كان طبيب أو مريض، وابعثها لفريق الدعم حتى يتابعون الحالة ويتخذون الإجراءات المناسبة.'
                      },
                    ],
                    Color(0xFF34C759),
                  ),

                  _buildFAQSection(
                    'ثانياً: تخص الأطباء (الطلاب)',
                    Icons.medical_services,
                    [
                      {
                        'question': 'شنو سياسة استرجاع المبالغ إذا ما تمت الحالة؟',
                        'answer': 'إذا الحالة ما تمت، نرجع المبلغ بعد خصم رسوم التشغيل وحسب الشروط المذكورة سابقاً.'
                      },
                      {
                        'question': 'شنو المقصود بـ "خصم رسوم التشغيل"؟',
                        'answer': 'هي رسوم لتغطية تكاليف تشغيل المنصة (نظام الحجز، التنبيهات، التحقق...).'
                      },
                      {
                        'question': 'صار سوء فهم أو خلاف على نوع الحالة؟',
                        'answer': 'لا تكمل الحالة، وبلغ الدعم حتى يراجع التفاصيل ويتواصل ويحل المشكلة.'
                      },
                      {
                        'question': 'المريض ما حضر الموعد، شنو أسوي؟',
                        'answer': 'سجل ملاحظة عن الحالة، وإذا تكرر الغياب راجع الدعم.'
                      },
                      {
                        'question': 'شلون أضمن إن الحساب حقيقي والطرف الثاني مو مزيف؟',
                        'answer': 'كل الحسابات يتم التحقق منها داخل المنصة عن طريق الرقم والاتصال وغيرهم من طرق التاكيد.'
                      },
                      {
                        'question': 'أقدر أبدل الطبيب أو المريض؟',
                        'answer': 'لا يمكن تبديل الطبيب أو المريض إلا في حالات خاصة يحددها فريق الدعم بعد مراجعة الحالة'
                      },
                      {
                        'question': 'شلون أبلغ عن مستخدم مسيء؟',
                        'answer': 'سجل معلومات الشخص المسيء سواء كان طبيب أو مريض، وابعثها لفريق الدعم حتى يتابعون الحالة ويتخذون الإجراءات المناسبة.'
                      },
                    ],
                    Color(0xFF007AFF),
                  ),

                  _buildFAQSection(
                    'ثالثاً: الأسئلة العامة والتقنية',
                    Icons.settings,
                    [
                      {
                        'question': 'ما أگدر أدفع، التطبيق يرفض البطاقة أو المحفظة؟',
                        'answer': 'تأكد إن الرصيد كافي والمحفظة مفعلة، وإذا استمر الخطأ جرب وسيلة دفع ثانية أو راسل الدعم.'
                      },
                      {
                        'question': 'دفعت المبلغ وما ظهرت الحالة بالحساب، شنو أسوي؟',
                        'answer': 'انتظر أولاً من 5 إلى 10 دقايق، إذا الحالة ما ظهرت، راسل الدعم واذكر رقم العملية حتى يتحققون منها.'
                      },
                      {
                        'question': 'التطبيق يعلق أو ما يفتح؟',
                        'answer': 'جرّب تسجل خروج وتدخل من جديد، وإذا بقى نفس الشي، حدّث التطبيق أو امسحه ونزله مرة ثانية.'
                      },
                      {
                        'question': 'الصور ما تنرفع أو تظل عالتحميل؟',
                        'answer': 'تأكد الإنترنت قوي، وحاول تقلل حجم الصورة. إذا استمر، راسل الدعم وأرسل صورة من الشاشة.'
                      },
                    ],
                    Color(0xFFFF9500),
                  ),
                  
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFAQSection(String title, IconData icon, List<Map<String, String>> qaList, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: color,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Questions and Answers List
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: qaList.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> qa = entry.value;
                
                return Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Question
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          // Question Number
                          Container(
                            width: 28,
                            height: 28,
                            margin: EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          // Question Text
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                qa['question'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1C1C1E),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Answer
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: color.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            qa['answer'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3C3C43),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}