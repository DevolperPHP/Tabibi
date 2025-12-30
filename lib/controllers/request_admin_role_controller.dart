import 'package:get/get.dart';
import 'package:tabibi/routes/app_routes.dart';
import 'package:tabibi/views/widgets/message_snak.dart';
import '../data/models/role_lists.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';

class RequestAdminRoleController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<RoleLists> roleLists = RxList([]);
  Rx<RoleLists?> role = Rx(null);
  @override
  void onInit() {
    super.onInit();
    fetchDataRouls();
  }

  void selectRole(RoleLists r) {
    role.value = r;
    fetchRoleDetails(r.id);
    Get.toNamed(AppRoutes.viewDetailsRole);
  }

  Future<void> fetchRoleDetails(String roleId) async {
    isLoading(true);
    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.roleRequestsGet(roleId));

      if (response.isStateSucess < 3) {
        // Update the selected role with detailed data
        role.value = RoleLists.fromJson(response.data);
      }
    } catch (e) {
      print("خطأ في تحميل تفاصيل الدور: $e");
    }
    isLoading.value = false;
  }

  Future<void> fetchDataRouls() async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.roleRequests);

      // print(response.data);
      if (response.isStateSucess < 3) {
        List<RoleLists> newPhotos = RoleLists.fromJsonList(response.data);
        roleLists([]);
        roleLists.addAll(newPhotos);
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }

  void sendChaneRole(bool isAccept) async {
    isLoading(true);
    try {
      // dio.FormData formData = dio.FormData.fromMap({
      //   'telegram': profileTelegram.text.trim(),
      //   "image": await dio.MultipartFile.fromFile(image.value!.path,
      //       filename: image.value!.path.split('/').last)
      // });

      StateReturnData data = await ApiService.putData(
          isAccept
              ? ApiConstants.roleAccept(role.value!.id)
              : ApiConstants.roleReject(role.value!.id),
          {});
      if (data.isStateSucess <= 2) {
        Get.back();
        MessageSnak.message('تم العملية', color: ColorApp.greenColor);

        await fetchDataRouls();
      } else {
        // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
        // print(data.data);
        MessageSnak.message('تم رفض العملية');
      }
    } catch (e) {
      MessageSnak.message('تأكد من الاتصال ');
    } finally {
      isLoading(false);
    }

    isLoading(false);
  }
}
