import 'package:dio/dio.dart';

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
        if (StorageController.checkLoginStatus())
          'Authorization': 'Bearer ${StorageController.getToken()}',
        // 'Content-Type': 'multipart/form-data',
        // 'Content-Type': 'application/json',
      },
    ),
  );

  static void updateToken() {
    final token = StorageController.getToken();
    print("Updating token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...");
    _dio.options.headers['Authorization'] =
        'Bearer $token';
  }

  // دالة GET لجلب البيانات وإرجاعها على شكل Map
  static Future<StateReturnData> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data); // إرجاع البيانات كـ Map
      }
      // return StateReturnData(2, response.data as Map<String, dynamic>);
      return StateReturnData(2, response.data);
    } catch (e) {
      print('Error in Post request: $e');
      return StateReturnData(3, {}); // إرجاع خريطة فارغة في حال الخطأ
    }
  }

  // دالة POST لإرسال البيانات وإرجاع النتيجة كـ Map
  static Future<StateReturnData> postData(String endpoint, dynamic data) async {
    try {
      // FormData formData = FormData.fromMap(data);
      final response = await _dio.post(endpoint, data: data);
      print(response.data);
      print('State Code : ${response.statusCode}');

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data);
      }
      return StateReturnData(3, response.data);
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.response?.data}');
        print('DioError status: ${e.response?.statusCode}');
      } else {
        print('Error: $e');
        return StateReturnData(3, {});
      }
      // showLongMessageDialog('Error: $e');
      print('Error in Post request: $e');

      return StateReturnData(3, e.response!.data);
    }
  }

  static Future<StateReturnData> putData(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);

      print('_____________');
      print(response.data);
      print('_____________');
      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data); // إرجاع البيانات كـ Map
      }
      return StateReturnData(2, response.data);
    } catch (e) {
      print('Error in Update request: $e');
      return StateReturnData(3, {}); // إرجاع خريطة فارغة في حال الخطأ
    }
  }

  static Future<StateReturnData> deleteData(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);

      if (response.statusCode! >= 200 && response.statusCode! <= 202) {
        return StateReturnData(1, response.data); // إرجاع البيانات كـ Map
      }
      return StateReturnData(2, response.data);
    } catch (e) {
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
