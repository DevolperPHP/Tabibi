import 'package:get_secure_storage/get_secure_storage.dart';
import '../data/models/profile_model.dart';
import '../utils/constants/values_constant.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';

class StorageController {
  static bool checkLoginStatus() {
    var data = GetSecureStorage().read(Values.keyStorage);
    print("Token data: $data");
    return data != null && data['token'] != null && data['token'].toString().isNotEmpty;
  }

  static String getToken() {
    var data = GetSecureStorage().read(Values.keyStorage);
    if (data != null && data['token'] != null) {
      return data['token'].toString();
    }
    return '';
  }

  static updateUserData(UserData user) async {
    var data = GetSecureStorage().read(Values.keyStorage);

    data['user'] = user.toJson();

    await GetSecureStorage().write(Values.keyStorage, data);
  }

  static bool isAdmin() {
    var data = GetSecureStorage().read(Values.keyStorage);

    return data['user']['isAdmin'] ?? false;
  }

  static bool isDoctor() {
    var data = GetSecureStorage().read(Values.keyStorage);

    return data['user']['isDoctor'] ?? false;
  }

  static void deleteAllData() {
    GetSecureStorage().remove(Values.keyStorage);
  }

  static Map<String, dynamic> getAllData() {
    var data = GetSecureStorage().read(Values.keyStorage);
    return data ?? {};
  }
  
  static UserData? getUserData() {
    try {
      var data = GetSecureStorage().read(Values.keyStorage);
      if (data != null && data['userData'] != null) {
        return UserData.fromJson(data['userData']);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  static String? getUserId() {
    var data = getUserData();
    return data?.id;
  }

  static String? getStoredUserId() {
    var data = GetSecureStorage().read(Values.keyStorage);
    if (data != null) {
      // Try to get ID from userData first
      if (data['userData'] != null && data['userData']['_id'] != null) {
        return data['userData']['_id'].toString();
      }
      // Or from user object
      if (data['user'] != null && data['user']['id'] != null) {
        return data['user']['id'].toString();
      }
    }
    return null;
  }

  static Future<void> storeData(Map data) async {
    await GetSecureStorage().write(Values.keyStorage, data);
  }

  /// Refreshes user data from the API and updates local storage
  /// Returns true if user data was updated successfully, false otherwise
  static Future<bool> refreshUserDataFromAPI() async {
    try {
      print('🔄 Refreshing user data from API...');

      // Check if user is logged in
      if (!checkLoginStatus()) {
        print('❌ User not logged in, skipping refresh');
        return false;
      }

      // Update token before making request
      ApiService.updateToken();

      // Fetch fresh profile data from API
      final StateReturnData response = await ApiService.getData(ApiConstants.profile);

      if (response.isStateSucess < 3 && response.data != null) {
        // Parse the user data
        final userModel = UserModel.fromJson(response.data);
        final userData = userModel.userData;

        // Update stored user data
        await updateUserData(userData);

        print('✅ User data refreshed successfully');
        print('   isDoctor: ${userData.isDoctor}');
        print('   isAdmin: ${userData.isAdmin}');

        return true;
      } else {
        print('❌ Failed to refresh user data: Invalid response');
        return false;
      }
    } catch (e) {
      print('❌ Error refreshing user data: $e');
      return false;
    }
  }

  // static Future<void> checkLogin() async {
  //   // customer

  //   StateReturnData data = await ApiService.getData(ApiConstants.customer);

  //   if (data.isStateSucess == 1) {
  //     if (data.data['data'] != null) {}
  //   } else if (data.data['message'] == "Unauthenticated.") {
  //     await GetSecureStorage().remove(Values.keyStorage);
  //   }
  // }
}
