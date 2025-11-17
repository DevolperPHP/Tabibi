import 'dart:math' as logger;

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:my_doctor/routes/app_routes.dart';
import 'package:my_doctor/views/widgets/message_snak.dart';

import '../data/models/case_model.dart';
import '../data/models/category.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';

class DoctorCaseController extends GetxController {
  RxBool isLoading = RxBool(false);
  RxBool isLoadingCategory = RxBool(false);
  RxList<CaseModel> doctorCases = RxList([]);
  RxList<CaseModel> doctorOmeCases = RxList([]);
  Rx<CaseModel?> doctorCase = Rx(null);
  RxList<Category> categores = RxList([]);
  Rx<Category?> categorySelect = Rx<Category?>(null);
  RxString genderFilter = RxString('all'); // 'all', 'male', 'female'
  RxString zoneFilter = RxString(''); // '' for all, or specific zone
  RxList<String> availableZones = RxList([]); // List of available zones
  RxList<CaseModel> allDoctorCases = RxList([]); // Store all cases for filtering
  //
  fechFilterCases(Category category) {
    if (categorySelect.value == category) return;
    categorySelect.value = category;
    fetchDataCases();
  }
  
  void setGenderFilter(String gender) {
    genderFilter.value = gender;
    applyFilters();
  }
  
  void setZoneFilter(String zone) {
    zoneFilter.value = zone;
    applyFilters();
  }
  
  void setCategoryFilter(Category? category) {
    categorySelect.value = category;
    fetchDataCases();
  }
  
  void clearAllFilters() {
    genderFilter.value = 'all';
    zoneFilter.value = '';
    categorySelect.value = null;
    fetchDataCases();
  }
  
  bool get hasActiveFilters {
    return genderFilter.value != 'all' ||
           zoneFilter.value.isNotEmpty ||
           categorySelect.value != null;
  }
  
  void applyFilters() {
    List<CaseModel> filtered = allDoctorCases.toList();
    
    // Apply gender filter
    if (genderFilter.value != 'all') {
      filtered = filtered.where((caseModel) {
        return caseModel.gender?.toLowerCase() == genderFilter.value.toLowerCase();
      }).toList();
    }
    
    // Apply zone filter
    if (zoneFilter.value.isNotEmpty) {
      filtered = filtered.where((caseModel) {
        return caseModel.zone?.toLowerCase() == zoneFilter.value.toLowerCase();
      }).toList();
    }
    
    doctorCases.value = filtered;
  }
  
  void _extractAvailableZones(List<CaseModel> cases) {
    final Set<String> zones = {};
    for (final caseModel in cases) {
      if (caseModel.zone != null && caseModel.zone!.isNotEmpty) {
        zones.add(caseModel.zone!);
      }
    }
    availableZones.value = zones.toList()..sort();
  }

  @override
  void onInit() {
    super.onInit();
    fetchDataCases();
    fetchDataOmeCases();
  }

  RxBool isOme = RxBool(false);
  void viewCase(CaseModel dCase, {bool ome = false}) {
    print('📋 viewCase called - Case: ${dCase.name}, isOme: $ome');
    doctorCase.value = dCase;
    isOme.value = ome;
    print('📋 doctorCase set - Value is null: ${doctorCase.value == null}');
    print('📋 isOme.value set to: ${isOme.value}');
    
    // Pass data as arguments to prevent loss during navigation
    Get.toNamed(
      AppRoutes.viewDoctorCase,
      arguments: {
        'case': dCase,
        'isOme': ome,
      },
    );
  }

//Cases
  Future<void> fetchDataCases() async {
    isLoading(true);

    try {
      String apiCases = ApiConstants.doctorCases;

      if (categorySelect.value != null) {
        if (categorySelect.value!.id == '') {
          apiCases = ApiConstants.doctorCases;
        } else {
          apiCases =
              ApiConstants.casesByCategory(categorySelect.value!.name).trim();
        }
      }

      final StateReturnData response = await ApiService.getData(apiCases);

      if (response.isStateSucess < 3) {
        List<CaseModel> newCases =
            CaseModel.fromJsonList(response.data['cases']);
        allDoctorCases([]);
        allDoctorCases.addAll(newCases);
        
        // Extract available zones from cases
        _extractAvailableZones(newCases);
        
        applyFilters();
        //
        if (categores.isEmpty) {
          isLoadingCategory(true);
          List<Category> newCategory =
              Category.fromJsonList(response.data['category']);

          categores.add(Category(id: '', name: 'جميع الفئات'));
          categores.addAll(newCategory);
        }
      }
    } catch (e) {
      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
    isLoadingCategory.value = false;
  }

//Take Case
  Future<void> takeCase() async {
    if (doctorCase.value == null) {
      MessageSnak.message('لا توجد حالة مختارة');
      return;
    }

    isLoading(true);

    try {
      final StateReturnData response = await ApiService.putData(
          ApiConstants.doctorTakeCase(doctorCase.value!.id), {});

      if (response.isStateSucess < 3) {
        await fetchDataCases();
        await fetchDataOmeCases();
        MessageSnak.message('تمت  أضافة الحالة', color: ColorApp.greenColor);
      }
    } catch (e) {
      MessageSnak.message('لم يتم أضافة الحالة');

      // MessageSnak.message("خطأ في تحميل البيانات: $e");
      print("خطأ في تحميل البيانات: $e");
    }

    isLoading.value = false;
  }

//Ome  Cases
  Future<void> fetchDataOmeCases() async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.doctorOmeCases);

      print("📱 My Cases Response Type: ${response.data.runtimeType}");
      print("📱 My Cases Response: ${response.data}");
      print("📱 My Cases Status: ${response.isStateSucess}");
      
      if (response.isStateSucess < 3) {
        // Backend returns array directly, not wrapped in object
        if (response.data is List) {
          List<CaseModel> newCases = CaseModel.fromJsonList(response.data);
          doctorOmeCases([]);
          doctorOmeCases.addAll(newCases);
          print("✅ Loaded ${newCases.length} cases in My Cases");
          
          if (newCases.isNotEmpty) {
            print("📄 First case: ${newCases[0].name}, Status: ${newCases[0].status}, Doctor: ${newCases[0].doctor}");
          }
        } else {
          print("❌ Response is not a list: ${response.data}");
          MessageSnak.message("خطأ في تنسيق البيانات");
        }
      } else {
        print("❌ Request failed with status: ${response.isStateSucess}");
        MessageSnak.message("فشل في تحميل الحالات");
      }
    } catch (e, stackTrace) {
      MessageSnak.message("خطأ في تحميل الحالات: $e");
      print("❌ Error loading My Cases: $e");
      print("Stack trace: $stackTrace");
    }

    isLoading.value = false;
  }

//Mark Case as Done with confirmation
  void markCaseAsDone() {
    if (doctorCase.value == null) {
      MessageSnak.message('لا توجد حالة مختارة');
      return;
    }
    
    Get.dialog(
      AlertDialog(
        title: Text('تأكيد إنهاء الحالة'),
        content: Text('هل أنت متأكد من إنهاء هذه الحالة؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              _confirmMarkCaseAsDone();
            },
            child: Text('تأكيد', style: TextStyle(color: ColorApp.greenColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmMarkCaseAsDone() async {
    if (doctorCase.value == null) {
      MessageSnak.message('لا توجد حالة مختارة');
      return;
    }

    isLoading(true);

    try {
      final StateReturnData response = await ApiService.putData(
          ApiConstants.doctorMarkCaseDone(doctorCase.value!.id),
          {
            'report': doctorCase.value!.diagnose ?? '',
            'diagnose': doctorCase.value!.diagnose ?? ''
          });

      if (response.isStateSucess < 3) {
        await fetchDataOmeCases();
        Get.back();
        MessageSnak.message('تم إنهاء الحالة بنجاح', color: ColorApp.greenColor);
      } else {
        MessageSnak.message('فشل في إنهاء الحالة');
      }
    } catch (e) {
      MessageSnak.message('حدث خطأ أثناء إنهاء الحالة');
      print("خطأ في إنهاء الحالة: $e");
    }

    isLoading.value = false;
  }
}
