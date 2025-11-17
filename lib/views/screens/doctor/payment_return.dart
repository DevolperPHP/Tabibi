import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/color_app.dart';
import '../../../utils/constants/images_url.dart';
import '../../../utils/constants/style_app.dart';
import '../../../utils/constants/values_constant.dart';
import '../../widgets/actions_button.dart';

class PaymentReturn extends StatelessWidget {
  const PaymentReturn({super.key});

  @override
  Widget build(BuildContext context) {
    // You can get payment status from URL parameters if needed
    // For now, showing a success screen
    
    return Scaffold(
      backgroundColor: ColorApp.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Values.circle * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Values.circle * 3),
              
              // Success icon
              Container(
                padding: EdgeInsets.all(Values.circle * 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Colors.green,
                ),
              ),
              
              SizedBox(height: Values.circle * 2),
              
              Text(
                'تم إتمام عملية الدفع',
                textAlign: TextAlign.center,
                style: StringStyle.headerStyle.copyWith(
                  fontSize: 24,
                  color: ColorApp.primaryColor,
                ),
              ),
              
              SizedBox(height: Values.circle),
              
              Text(
                'شكراً لك! تم اختيار الحالة بنجاح',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              
              SizedBox(height: Values.circle * 3),
              
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.primaryColor,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Values.circle),
                  ),
                ),
                child: Text(
                  'العودة للصفحة الرئيسية',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
