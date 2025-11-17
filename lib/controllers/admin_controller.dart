import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../data/models/post_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';
import '../views/widgets/message_snak.dart';
import '../views/widgets/more_widgets.dart';
import 'home_controller.dart';

class AdminController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  Rx<File?> image = Rx<File?>(null);
  RxBool isLoading = RxBool(false);
  final formKey = GlobalKey<FormState>();
  RxList<Post> posts = RxList<Post>([]);
  Rx<Post?> postSelect = Rx(null);
  //
  void selectPost(Post post) {
    postSelect(post);
    Get.toNamed(AppRoutes.postView);
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataPosts();
  }

  Future<void> fetchDataPosts() async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.posts);

      if (response.isStateSucess < 3) {
        List<Post> newPost = Post.fromJsonList(response.data);
        posts([]);
        posts.addAll(newPost);
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);

      // cropImage(File(pickedFile.path));
    }
    Get.back();
  }

  void selectImage() {
    showImagePicker(
        onPressedCamera: (() => pickImage(ImageSource.camera)),
        onPressedGallery: () => pickImage(ImageSource.gallery));
  }

  void clearFeilds() {
    //
    title.clear();
    description.clear();
    image.value = null;
    postSelect.value = null;

    Get.back();
  }

  void clearFieldsWithoutNavigation() {
    //
    title.clear();
    description.clear();
    image.value = null;
    postSelect.value = null;
  }

  void submit() async {
    if (formKey.currentState!.validate() && image.value != null) {
      if (image.value != null) {
        isLoading(true);
        try {
          dio.FormData formData = dio.FormData.fromMap({
            'title': title.text.trim(),
            'des': description.text.trim(),
            "image": await dio.MultipartFile.fromFile(image.value!.path,
                filename: image.value!.path.split('/').last)
          });

          StateReturnData data =
              await ApiService.postData(ApiConstants.postNew, formData);
          if (data.isStateSucess <= 2) {
            MessageSnak.message('تم اضافة المنشور', color: ColorApp.greenColor);
            await fetchDataPosts();
            
            // Navigate to My Posts page (مقالاتي) (index 1 for admin)
            Get.find<HomeController>().changeIndex(1);
            
            // Clear fields without navigating back
            clearFieldsWithoutNavigation();
          } else {
            // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
            // print(data.data);
            MessageSnak.message('لم يتم  رفع المنشور');
          }
        } catch (e) {
          MessageSnak.message('تأكد من الاتصال ');
        } finally {
          await Future.delayed(Duration(seconds: 1));
          isLoading(false);
        }
      } else {
        MessageSnak.message('يجيب اضافة صورة');
      }
    }
  }

  void fullUpdata() {
    if (postSelect.value == null) {
      print('Error: No post selected');
      return;
    }
    title.text = postSelect.value!.title;
    description.text = postSelect.value!.description;
    image.value = null; // Clear image to allow optional update
    Get.toNamed(AppRoutes.postEdit);
  }

  void submitUpdata() async {
    if (formKey.currentState!.validate()) {
      // Check if post is selected
      if (postSelect.value == null) {
        MessageSnak.message('خطأ: لم يتم اختيار منشور');
        return;
      }
      
      isLoading(true);
      try {
        dio.FormData formData = dio.FormData.fromMap({
          'title': title.text.trim(),
          'des': description.text.trim(),
          if (image.value != null)
            "image": await dio.MultipartFile.fromFile(image.value!.path,
                filename: image.value!.path.split('/').last)
        });

        StateReturnData data = await ApiService.putData(
            ApiConstants.postsEditId(postSelect.value!.id), formData);
        if (data.isStateSucess <= 2) {
          // Stop loading immediately
          isLoading(false);
          
          // Show success message
          MessageSnak.message('تم تعديل المنشور', color: ColorApp.greenColor);
          
          // Navigate back to home screen first
          Get.until((route) => route.isFirst);
          
          // Then refresh posts data
          await fetchDataPosts();
          
          // Clear fields after navigation
          title.clear();
          description.clear();
          image.value = null;
          postSelect.value = null;
        } else {
          MessageSnak.message('لم يتم  رفع المنشور');
          isLoading(false);
        }
      } catch (e) {
        MessageSnak.message('تأكد من الاتصال: $e');
        print('Error updating post: $e');
        isLoading(false);
      }
    }
  }

  Future<void> submitDelete() async {
    try {
      StateReturnData data = await ApiService.deleteData(
          ApiConstants.postsDeleteId(postSelect.value!.id));
      if (data.isStateSucess <= 2) {
        MessageSnak.message('تم حذف المنشور', color: ColorApp.greenColor);
        clearFeilds();
        fetchDataPosts();
      } else {
        // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
        // print(data.data);
        MessageSnak.message('لم يتم  حذف المنشور');
      }
    } catch (e) {
      MessageSnak.message('تأكد من الاتصال ');
    } finally {
      await Future.delayed(Duration(seconds: 1));
      isLoading(false);
    }
  }

  void deletePost() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد أنك تريد حذف المنشور'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('إلغاء'),
          ),
          Obx(() {
            return isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: () async {
                      isLoading(true);
                      submitDelete();
                      isLoading(false);
                      Get.back();
                      Get.back();
                    },
                    child: const Text('حذف'),
                  );
          }),
        ],
      ),
    );
  }
}
