import 'dart:math' as logger;

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:tabibi/routes/app_routes.dart';
import 'package:tabibi/views/widgets/message_snak.dart';

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

  // Manual refresh method for the "الحالات" screen
  Future<void> refreshCases() async {
    print('🔄 [DoctorCaseController] Manual refresh triggered');
    
    // Prevent double loading
    if (isLoading.value) {
      print('⏳ [DoctorCaseController] Already loading, skipping refresh');
      return;
    }
    
    // Set loading state once for the entire refresh operation
    isLoading(true);
    
    try {
      // Load available cases first
      await fetchDataCases();
      print('✅ [DoctorCaseController] Available cases refreshed');
      
      // Then load my cases with a small delay to avoid conflicts
      await Future.delayed(Duration(milliseconds: 500));
      await fetchDataOmeCases();
      print('✅ [DoctorCaseController] My cases refreshed');
      
      print('🎉 [DoctorCaseController] Full refresh completed successfully');
    } catch (e) {
      print('❌ [DoctorCaseController] Error during refresh: $e');
    } finally {
      isLoading.value = false;
    }
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
    print('🏥 [DoctorCaseController] Initializing controller...');
    
    // Don't auto-load here to avoid double loading
    // Data will be loaded when screens request it
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
    print('📋 [DoctorCaseController] Fetching available cases...');
    // Don't set loading state here - it's handled by refreshCases method

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

      print('🌐 [DoctorCaseController] API Endpoint: $apiCases');
      final StateReturnData response = await ApiService.getData(apiCases);

      print('📊 [DoctorCaseController] Cases Response Status: ${response.isStateSucess}');
      
      if (response.isStateSucess < 3) {
        print('📊 [DoctorCaseController] Response data type: ${response.data.runtimeType}');
        
        // Check if response has the expected structure
        if (response.data is Map<String, dynamic> && 
            response.data.containsKey('cases') && 
            response.data.containsKey('category')) {
          
          List<CaseModel> newCases = CaseModel.fromJsonList(response.data['cases']);
          print('📈 [DoctorCaseController] Parsed ${newCases.length} available cases');
          
          allDoctorCases([]);
          allDoctorCases.addAll(newCases);
          
          // Extract available zones from cases
          _extractAvailableZones(newCases);
          
          applyFilters();
          
          // Load categories if not already loaded
          if (categores.isEmpty) {
            isLoadingCategory(true);
            List<Category> newCategory = Category.fromJsonList(response.data['category']);
            print('📂 [DoctorCaseController] Loaded ${newCategory.length} categories');

            categores.add(Category(id: '', name: 'جميع الفئات'));
            categores.addAll(newCategory);
          }
          
          print('✅ [DoctorCaseController] Available cases loaded successfully');
          
        } else {
          print('❌ [DoctorCaseController] Unexpected response format');
          print('📊 [DoctorCaseController] Response data: ${response.data}');
          
          // Try to parse as direct list (fallback)
          if (response.data is List) {
            List<CaseModel> newCases = CaseModel.fromJsonList(response.data);
            allDoctorCases([]);
            allDoctorCases.addAll(newCases);
            applyFilters();
            print('✅ [DoctorCaseController] Loaded ${newCases.length} cases (fallback)');
          } else {
            print('❌ [DoctorCaseController] Cannot parse response data');
            allDoctorCases([]);
          }
        }
      } else {
        print('❌ [DoctorCaseController] API request failed with status: ${response.isStateSucess}');
        print('📊 [DoctorCaseController] Error response: ${response.data}');
        allDoctorCases([]);
      }
    } catch (e, stackTrace) {
      print('❌ [DoctorCaseController] Error fetching cases: $e');
      print('🔍 [DoctorCaseController] Stack trace: $stackTrace');
      allDoctorCases([]);
      // Don't show error to user for network issues
    }

    // Don't set loading state here - it's handled by refreshCases method
    isLoadingCategory.value = false;
    print('🏁 [DoctorCaseController] fetchDataCases completed');
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
    // Don't set loading state here - it's handled by refreshCases method

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.doctorOmeCases);

      print("📱 My Cases Response Type: ${response.data.runtimeType}");
      print("📱 My Cases Response: ${response.data}");
      print("📱 My Cases Status: ${response.isStateSucess}");
      
      if (response.isStateSucess < 3) {
        // Handle different response types gracefully
        if (response.data is List) {
          // Normal case: backend returns a list
          List<CaseModel> newCases = CaseModel.fromJsonList(response.data);
          doctorOmeCases([]);
          doctorOmeCases.addAll(newCases);
          print("✅ Loaded ${newCases.length} cases in My Cases");
          
          if (newCases.isNotEmpty) {
            print("📄 First case: ${newCases[0].name}, Status: ${newCases[0].status}, Doctor: ${newCases[0].doctor}");
          }
        } else if (response.data is Map<String, dynamic>) {
          // Handle error responses or different API formats
          final dataMap = response.data as Map<String, dynamic>;
          
          if (dataMap.containsKey('message')) {
            // This is likely an error message (like "Access denied")
            final message = dataMap['message'];
            if (message.toString().contains('Access denied') || 
                message.toString().contains('No token')) {
              print("🔐 Authentication error - clearing cases list");
              doctorOmeCases([]);
              // Don't show error for auth issues, just clear the list
              return;
            } else {
              print("❌ API returned error message: $message");
              MessageSnak.message("خطأ في تحميل الحالات: $message");
            }
          } else {
            print("❌ Unknown response format: ${response.data}");
            MessageSnak.message("خطأ في تنسيق البيانات");
          }
        } else {
          print("❌ Unexpected response type: ${response.data.runtimeType}");
          print("📊 Response content: ${response.data}");
          
          // Check if it's an authentication error by content
          final dataStr = response.data.toString().toLowerCase();
          if (dataStr.contains('access denied') || 
              dataStr.contains('no token') || 
              dataStr.contains('unauthorized')) {
            print("🔐 Authentication error detected - clearing cases");
            doctorOmeCases([]);
            return;
          } else {
            MessageSnak.message("خطأ في تحميل الحالات");
          }
        }
      } else {
        print("❌ Request failed with status: ${response.isStateSucess}");
        print("📊 Error response: ${response.data}");
        MessageSnak.message("فشل في تحميل الحالات");
      }
    } catch (e, stackTrace) {
      print("❌ Error loading My Cases: $e");
      print("Stack trace: $stackTrace");
      
      // Don't show user-facing error for network issues, just log
      doctorOmeCases([]);
      print("🔄 Cleared cases list due to error");
    }

    // Don't set loading state here - it's handled by refreshCases method
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
