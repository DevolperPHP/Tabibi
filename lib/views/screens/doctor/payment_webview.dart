import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../controllers/storage_controller.dart';
import '../../../controllers/doctor_case_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants/color_app.dart';

class PaymentWebView extends StatefulWidget {
  final String caseId;
  
  const PaymentWebView({super.key, required this.caseId});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  bool _hasHandledSuccess = false;

  @override
  void initState() {
    super.initState();
    
    String token = StorageController.getToken();
    String paymentUrl = 'https://www.tabibi-iq.net/doctor/case/pay/${widget.caseId}';
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('🌐 WebView Page Started: $url');
            setState(() {
              isLoading = true;
            });
            
            // Detect custom scheme immediately
            if (url.contains('tabibi://payment-success')) {
              _handlePaymentSuccess();
              return;
            }
          },
          onPageFinished: (String url) {
            print('✅ WebView Page Finished: $url');
            setState(() {
              isLoading = false;
            });
            
            // Check if payment is completed successfully
            if (url.contains('/doctor/payment/return') || 
                url.contains('payment/return') ||
                url.contains('success') || 
                url.contains('completed')) {
              print('🎉 Payment return detected!');
              _handlePaymentSuccess();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            print('📍 Navigation Request: ${request.url}');
            
            // Intercept custom scheme
            if (request.url.contains('tabibi://payment-success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(
        Uri.parse(paymentUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
  }

  void _handlePaymentSuccess() {
    // Prevent duplicate handling
    if (_hasHandledSuccess) return;
    _hasHandledSuccess = true;

    print('💰 Handling payment success...');
    
    // Get the DoctorCaseController to refresh data
    try {
      final DoctorCaseController doctorCaseController = Get.find<DoctorCaseController>();
      
      // Refresh both available cases and doctor's cases
      doctorCaseController.fetchDataCases();
      doctorCaseController.fetchDataOmeCases();
      
      print('✅ Refreshed case lists');
    } catch (e) {
      print('⚠️ Could not find DoctorCaseController: $e');
    }

    // Close the WebView and go back to home with My Cases tab index
    // Pass initialTab: 2 (My Cases for doctors: 0=Home, 1=Cases, 2=My Cases, 3=Profile)
    Get.offAllNamed(AppRoutes.home, arguments: {'initialTab': 2});
    print('🏠 Navigating to home with My Cases tab (index 2)');
    
    // Show success message
    Future.delayed(Duration(milliseconds: 500), () {
      Get.snackbar(
        'نجاح',
        'تم اختيار الحالة بنجاح!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorApp.primaryColor,
        title: Text(
          'بوابة الدفع',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorApp.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
