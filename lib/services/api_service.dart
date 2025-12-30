import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/storage_controller.dart';
import '../utils/constants/api_constants.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      validateStatus: (status) {
        return status! < 500; // Adjust based on your needs
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (StorageController.checkLoginStatus())
          'Authorization': 'Bearer ${StorageController.getToken()}',
      },
    ),
  );

  static void updateToken() {
    final token = StorageController.getToken();
    print("Updating token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...");
    _dio.options.headers['Authorization'] =
        'Bearer $token';
  }

  // Handle unauthorized access (401) - logout user
  static void _handleUnauthorized() {
    if (StorageController.checkLoginStatus()) {
      print('🔒 Unauthorized access - logging out user');
      StorageController.deleteAllData();
      Get.offAllNamed('/login'); // Navigate to login
    }
  }

  // Handle banned user (403) - logout and show ban dialog
  static void _handleBannedUser(String? banReason) {
    if (StorageController.checkLoginStatus()) {
      print('⛔ Banned user detected - logging out');
      StorageController.deleteAllData();
      Get.offAllNamed('/login');

      // Show ban dialog after navigating to login
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.dialog(
          PopScope(
            canPop: false, // Prevent closing with back button
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(Icons.block, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'حسابك محظور',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'تم حظر حسابك. تواصل مع الدعم للمزيد من المعلومات',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      });
    }
  }

  // دالة GET لجلب البيانات وإرجاعها على شكل Map
  static Future<StateReturnData> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);

      // Check for 401 Unauthorized in successful response (due to validateStatus)
      if (response.statusCode == 401) {
        _handleUnauthorized();
        return StateReturnData(3, {'message': 'Unauthorized'});
      }

      // Check for 403 Forbidden - banned user
      if (response.statusCode == 403) {
        final banReason = response.data['banReason'] as String?;
        _handleBannedUser(banReason);
        return StateReturnData(3, response.data);
      }

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data); // إرجاع البيانات كـ Map
      }
      // return StateReturnData(2, response.data as Map<String, dynamic>);
      return StateReturnData(2, response.data);
    } catch (e) {
      if (e is DioException) {
        // Check for 401 Unauthorized
        if (e.response?.statusCode == 401) {
          _handleUnauthorized();
        }
        // Check for 403 Forbidden - banned user
        if (e.response?.statusCode == 403) {
          final banReason = e.response?.data['banReason'] as String?;
          _handleBannedUser(banReason);
        }
      }
      print('Error in Get request: $e');
      return StateReturnData(3, {}); // إرجاع خريطة فارغة في حال الخطأ
    }
  }

  // دالة POST لإرسال البيانات وإرجاع النتيجة كـ Map
  static Future<StateReturnData> postData(String endpoint, dynamic data) async {
    try {
      // Ensure data is properly formatted for JSON
      final jsonData = data is Map ? data : {'data': data};
      final response = await _dio.post(endpoint, data: jsonData);
      print(response.data);
      print('State Code : ${response.statusCode}');

      // Check for 401 Unauthorized in successful response (due to validateStatus)
      if (response.statusCode == 401) {
        _handleUnauthorized();
        return StateReturnData(3, {'message': 'Unauthorized'});
      }

      // Check for 403 Forbidden - banned user
      if (response.statusCode == 403) {
        final banReason = response.data['banReason'] as String?;
        _handleBannedUser(banReason);
        return StateReturnData(3, response.data);
      }

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data);
      }
      return StateReturnData(3, response.data);
    } catch (e) {
      if (e is DioException) {
        // Check for 401 Unauthorized
        if (e.response?.statusCode == 401) {
          _handleUnauthorized();
        }
        // Check for 403 Forbidden - banned user
        if (e.response?.statusCode == 403) {
          final banReason = e.response?.data['banReason'] as String?;
          _handleBannedUser(banReason);
          return StateReturnData(3, e.response?.data ?? {});
        }
        print('DioError: ${e.response?.data}');
        print('DioError status: ${e.response?.statusCode}');
      } else {
        print('Error: $e');
        return StateReturnData(3, {});
      }
      // showLongMessageDialog('Error: $e');
      print('Error in Post request: $e');

      return StateReturnData(3, e.response?.data ?? {});
    }
  }

  static Future<StateReturnData> putData(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);

      print('_____________');
      print(response.data);
      print('_____________');

      // Check for 401 Unauthorized in successful response (due to validateStatus)
      if (response.statusCode == 401) {
        _handleUnauthorized();
        return StateReturnData(3, {'message': 'Unauthorized'});
      }

      // Check for 403 Forbidden - banned user
      if (response.statusCode == 403) {
        final banReason = response.data['banReason'] as String?;
        _handleBannedUser(banReason);
        return StateReturnData(3, response.data);
      }

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data); // إرجاع البيانات كـ Map
      }
      return StateReturnData(2, response.data);
    } catch (e) {
      if (e is DioException) {
        // Check for 401 Unauthorized
        if (e.response?.statusCode == 401) {
          _handleUnauthorized();
        }
        // Check for 403 Forbidden - banned user
        if (e.response?.statusCode == 403) {
          final banReason = e.response?.data['banReason'] as String?;
          _handleBannedUser(banReason);
          return StateReturnData(3, e.response?.data ?? {});
        }
      }
      print('Error in Update request: $e');
      return StateReturnData(3, {}); // إرجاع خريطة فارغة في حال الخطأ
    }
  }

  static Future<StateReturnData> deleteData(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);

      // Check for 401 Unauthorized in successful response (due to validateStatus)
      if (response.statusCode == 401) {
        _handleUnauthorized();
        return StateReturnData(3, {'message': 'Unauthorized'});
      }

      // Check for 403 Forbidden - banned user
      if (response.statusCode == 403) {
        final banReason = response.data['banReason'] as String?;
        _handleBannedUser(banReason);
        return StateReturnData(3, response.data);
      }

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data); // إرجاع البيانات كـ Map
      }
      return StateReturnData(2, response.data);
    } catch (e) {
      if (e is DioException) {
        // Check for 401 Unauthorized
        if (e.response?.statusCode == 401) {
          _handleUnauthorized();
        }
        // Check for 403 Forbidden - banned user
        if (e.response?.statusCode == 403) {
          final banReason = e.response?.data['banReason'] as String?;
          _handleBannedUser(banReason);
          return StateReturnData(3, e.response?.data ?? {});
        }
      }
      print('Error in DELETE request: $e');
      return StateReturnData(3, {}); // إرجاع خريطة فارغة في حال الخطأ
    }
  }
}

class StateReturnData {
  int isStateSucess;
  // Map<String, dynamic> data;
  var data;
  StateReturnData(this.isStateSucess, this.data);
}
