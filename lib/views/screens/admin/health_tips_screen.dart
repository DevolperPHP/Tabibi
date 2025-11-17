import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_doctor/controllers/notification_controller.dart';
import 'package:my_doctor/services/api_service.dart';
import 'package:my_doctor/utils/constants/api_constants.dart';
import 'package:my_doctor/views/widgets/message_snak.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final NotificationController notificationController = Get.put(NotificationController());

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إرسال نصائح صحية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2196F3),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إنشاء نصيحة صحية جديدة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان النصيحة',
                        hintText: 'مثال: نصيحة يومية لصحة الأسنان',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.title),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: bodyController,
                      decoration: InputDecoration(
                        labelText: 'محتوى النصيحة',
                        hintText: 'اكتب النصيحة الصحية هنا...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.message),
                      ),
                      maxLines: 5,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _sendHealthTip(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2196F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'إرسال لجميع المستخدمين',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'نصائح سريعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            _buildQuickTipCard(
              'تنظيف الأسنان',
              'تذكر أن تنظف أسنانك مرتين يومياً لمدة دقيقتين على الأقل باستخدام معجون أسنان يحتوي على الفلورايد.',
            ),
            _buildQuickTipCard(
              'استخدام خيط الأسنان',
              'استخدم خيط الأسنان يومياً لإزالة البلاك والطعام المتبقي بين الأسنان.',
            ),
            _buildQuickTipCard(
              'زيارة طبيب الأسنان',
              'قم بزيارة طبيب الأسنان كل 6 أشهر للفحص والتنظيف الدوري.',
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to notifications screen
          Get.toNamed('/notifications');
        },
        backgroundColor: Color(0xFF2196F3),
        child: Icon(Icons.notifications, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickTipCard(String title, String content) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: Icon(Icons.send, color: Color(0xFF2196F3)),
          onPressed: () {
            titleController.text = 'نصيحة يومية لصحة الأسنان';
            bodyController.text = content;
          },
        ),
      ),
    );
  }

  Future<void> _sendHealthTip() async {
    if (titleController.text.trim().isEmpty) {
      MessageSnak.message('يرجى إدخال عنوان النصيحة', color: Colors.red);
      return;
    }

    if (bodyController.text.trim().isEmpty) {
      MessageSnak.message('يرجى إدخال محتوى النصيحة', color: Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.postData(
        ApiConstants.healthTipsSendToAll(),
        {
          'title': titleController.text.trim(),
          'body': bodyController.text.trim(),
        },
      );

      if (response.isStateSucess == 1) {
        MessageSnak.message(
          'تم إرسال النصيحة بنجاح إلى جميع المستخدمين',
          color: Colors.green,
        );
        titleController.clear();
        bodyController.clear();
      } else {
        MessageSnak.message(
          'فشل في إرسال النصيحة: ${response.data?['message'] ?? 'Unknown error'}',
          color: Colors.red,
        );
      }
    } catch (e) {
      MessageSnak.message('حدث خطأ: ${e.toString()}', color: Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
