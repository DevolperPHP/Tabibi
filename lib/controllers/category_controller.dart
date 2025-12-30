import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/routes/app_routes.dart';

import '../data/models/case_model.dart';
import '../data/models/category.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';
import '../views/widgets/message_snak.dart';
import 'home_controller.dart';

class CategoryController extends GetxController {
  RxBool isLoadingCategory = RxBool(false);
  RxBool isLoadingCases = RxBool(false);
  RxList<Category> categores = RxList([]);
  RxList<CaseModel> cases = RxList([]);
  Rx<CaseModel?> caseSelect = Rx<CaseModel?>(null);
  TextEditingController categoryName = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController diagnose = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  Rx<Category?> categorySelect = Rx<Category?>(null);
  RxBool isLoadingCaseDetails = RxBool(false);
  
  Future<void> caesSelect(CaseModel caes) async {
    isLoadingCaseDetails(true);
    try {
      // Fetch full case details including gender
      final StateReturnData response = await ApiService.getData(ApiConstants.adminCasesGet(caes.id));
      if (response.isStateSucess < 3) {
        // Update the case with the full details from the backend
        final updatedCase = CaseModel.fromJson(response.data['case_data']);
        caseSelect.value = updatedCase;
        note.text = updatedCase.note ?? '';
        diagnose.text = '';
        Get.toNamed(AppRoutes.caseDetailsScreen);
      } else {
        // Fallback to using the case from the list if fetch fails
        caseSelect.value = caes;
        note.text = caes.note ?? '';
        diagnose.text = '';
        Get.toNamed(AppRoutes.caseDetailsScreen);
      }
    } catch (e) {
      // Fallback to using the case from the list if fetch fails
      caseSelect.value = caes;
      note.text = caes.note ?? '';
      diagnose.text = '';
      Get.toNamed(AppRoutes.caseDetailsScreen);
      print("Error fetching case details: $e");
    } finally {
      isLoadingCaseDetails(false);
    }
  }

  //
  @override
  void onInit() {
    super.onInit();
    fetchDataCategory();
    fetchDataCeses();
  }

  Future<void> fetchDataCategory() async {
    isLoadingCategory(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.casesAndCategory);
      if (response.isStateSucess < 3) {
        List<Category> newPhotos =
            Category.fromJsonList(response.data['category']);
        categores([]);
        categores.addAll(newPhotos);
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoadingCategory.value = false;
  }

  Future<void> fetchDataCeses() async {
    isLoadingCases(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.adminCases);
      print(response.data);
      if (response.isStateSucess < 3) {
        List<CaseModel> newPhotos = CaseModel.fromJsonList(response.data);
        cases([]);
        cases.addAll(newPhotos);
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoadingCases.value = false;
  }

  Future<void> addCategory() async {
    try {
      if (formKey.currentState!.validate()) {
        isLoadingCategory(true);
        final StateReturnData response = await ApiService.postData(
            ApiConstants.categoryNew, {'name': categoryName.text});
        if (response.isStateSucess < 3) {
          Get.back();

          MessageSnak.message("تمت الإضافة بنجاح", color: ColorApp.greenColor);
          categoryName.text = '';
          await fetchDataCategory();
        }
      }
    } catch (e) {
      MessageSnak.message("خطأ في تحميل البيانات: $e");
    }

    isLoadingCategory.value = false;
  }

  void edtitCategorySelect(Category category) {
    categorySelect.value = category;
    categoryName.text = category.name;
    Get.toNamed(AppRoutes.editCategory);
  }

  Future<void> editCategory() async {
    try {
      if (formKey.currentState!.validate()) {
        isLoadingCategory(true);
        final StateReturnData response = await ApiService.putData(
            ApiConstants.categoryEdit(categorySelect.value!.id),
            {'name': categoryName.text});
        if (response.isStateSucess < 3) {
          Get.back();

          MessageSnak.message("تمت الإضافة بنجاح", color: ColorApp.greenColor);
          categoryName.text = '';
          await fetchDataCategory();
        }
      }
    } catch (e) {
      MessageSnak.message("خطأ في تحميل البيانات: $e");
    }

    isLoadingCategory.value = false;
  }

  Future<void> acceptCase() async {
    if (!formKey2.currentState!.validate() || categorySelect.value == null) {
      MessageSnak.message("يرجى اختيار فئة");
      return;
    }
    
    isLoadingCases(true);
    try {
      final StateReturnData response = await ApiService.putData(
          ApiConstants.adminCasesAccept(caseSelect.value!.id), {
        'note': note.text.trim(),
        'diagnose': diagnose.text.trim(),
        'category': categorySelect.value!.name.trim()
      });
      
      if (response.isStateSucess < 3) {
        categoryName.text = '';
        diagnose.text = '';
        note.text = '';
        
        // Close all dialogs and screens
        Get.back(); // Close accept dialog
        Get.back(); // Close case details
        
        // Refresh cases
        await fetchDataCeses();
        
        MessageSnak.message("تمت القبول بنجاح", color: ColorApp.greenColor);
      } else {
        Get.back(); // Close dialog on failure
        MessageSnak.message("فشل قبول الحالة");
      }
    } catch (e) {
      Get.back(); // Close dialog on error
      MessageSnak.message("خطأ في قبول الحالة: $e");
      print("خطأ في قبول الحالة: $e");
    } finally {
      isLoadingCases.value = false;
    }
  }

  Future<void> rejectCase() async {
    if (!formKey2.currentState!.validate()) {
      return;
    }
    
    isLoadingCases(true);
    try {
      final StateReturnData response = await ApiService.putData(
          ApiConstants.adminCasesReject(caseSelect.value!.id),
          {'rejectNote': diagnose.text});
      
      if (response.isStateSucess < 3) {
        diagnose.text = '';
        note.text = '';
        
        // Close all dialogs and screens
        Get.back(); // Close reject dialog
        Get.back(); // Close case details
        
        // Refresh cases
        await fetchDataCeses();
        
        MessageSnak.message("تمت رفض الحالة بنجاح",
            color: ColorApp.greenColor);
      } else {
        Get.back(); // Close dialog even on failure
        MessageSnak.message("فشل رفض الحالة");
      }
    } catch (e) {
      Get.back(); // Close dialog on error
      MessageSnak.message("خطأ في رفض الحالة: $e");
      print("خطأ في رفض الحالة: $e");
    } finally {
      isLoadingCases.value = false;
    }
  }

  Future<void> deleteCategory(String id) async {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد أنك تريد حذف هذا التصنيف؟",
      textConfirm: "نعم",
      textCancel: "إلغاء",
      confirmTextColor: ColorApp.whiteColor,
      onConfirm: () async {
        Get.back(); // يغلق الديالوج أولاً
        try {
          isLoadingCategory(true);
          final StateReturnData response =
              await ApiService.deleteData(ApiConstants.categoryDelete(id));
          print(response.data);
          if (response.isStateSucess < 3) {
            Get.back();
            MessageSnak.message("تم الحذف بنجاح", color: ColorApp.greenColor);
            categoryName.text = '';
            await fetchDataCategory();
          }
        } catch (e) {
          MessageSnak.message("خطأ في تحميل البيانات: $e");
        }
        isLoadingCategory.value = false;
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  // Delete a case (for waiting cases)
  Future<void> deleteCase(CaseModel caseModel) async {
    Get.defaultDialog(
      title: 'حذف الحالة',
      middleText: 'هل أنت متأكد من حذف هذه الحالة نهائياً؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      cancelTextColor: ColorApp.primaryColor,
      buttonColor: ColorApp.redColor,
      onConfirm: () async {
        Get.back();
        try {
          isLoadingCases(true);
          final StateReturnData response =
              await ApiService.deleteData(ApiConstants.adminCasesDelete(caseModel.id));

          if (response.isStateSucess < 3) {
            MessageSnak.message("تم حذف الحالة بنجاح", color: ColorApp.greenColor);
            await fetchDataCeses();
            // Navigate back to home screen with AdminCasesScreen (الحالات) tab selected
            Get.until((route) => Get.currentRoute == AppRoutes.home);
            Get.toNamed(AppRoutes.home, arguments: {'initialTab': 2});
          } else {
            MessageSnak.message("فشل حذف الحالة");
          }
        } catch (e) {
          MessageSnak.message("خطأ في حذف الحالة: $e");
        } finally {
          isLoadingCases.value = false;
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  // Move case back to waiting/review (for accepted cases)
  Future<void> reReviewCase(CaseModel caseModel) async {
    Get.defaultDialog(
      title: 'إعادة المراجعة',
      middleText: 'هل تريد إعادة هذه الحالة إلى قائمة المراجعة؟',
      textConfirm: 'نعم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      cancelTextColor: ColorApp.primaryColor,
      buttonColor: ColorApp.orangeColor,
      onConfirm: () async {
        Get.back();
        try {
          isLoadingCases(true);
          final StateReturnData response =
              await ApiService.putData(ApiConstants.adminCasesReReview(caseModel.id), {});

          if (response.isStateSucess < 3) {
            MessageSnak.message("تمت إعادة المراجعة بنجاح", color: ColorApp.greenColor);
            await fetchDataCeses();
            // Navigate back to home screen with AdminCasesScreen (الحالات) tab selected
            Get.until((route) => Get.currentRoute == AppRoutes.home);
            Get.toNamed(AppRoutes.home, arguments: {'initialTab': 2});
          } else {
            MessageSnak.message("فشل إعادة المراجعة");
          }
        } catch (e) {
          MessageSnak.message("خطأ في إعادة المراجعة: $e");
        } finally {
          isLoadingCases.value = false;
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  // Move rejected case back to waiting (re-accept)
  Future<void> reAcceptCase(CaseModel caseModel) async {
    Get.defaultDialog(
      title: 'قبول الحالة',
      middleText: 'هل تريد إعادة قبول هذه الحالة؟',
      textConfirm: 'نعم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      cancelTextColor: ColorApp.primaryColor,
      buttonColor: ColorApp.primaryColor,
      onConfirm: () async {
        Get.back();
        try {
          isLoadingCases(true);
          final StateReturnData response =
              await ApiService.putData(ApiConstants.adminCasesReAccept(caseModel.id), {});

          if (response.isStateSucess < 3) {
            MessageSnak.message("تم قبول الحالة بنجاح", color: ColorApp.greenColor);
            await fetchDataCeses();
            // Navigate back to home screen with AdminCasesScreen (الحالات) tab selected
            Get.until((route) => Get.currentRoute == AppRoutes.home);
            Get.toNamed(AppRoutes.home, arguments: {'initialTab': 2});
          } else {
            MessageSnak.message("فشل قبول الحالة");
          }
        } catch (e) {
          MessageSnak.message("خطأ في قبول الحالة: $e");
        } finally {
          isLoadingCases.value = false;
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
