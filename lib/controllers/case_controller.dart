import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doctor/views/widgets/message_snak.dart';
import 'package:dio/dio.dart' as dio;
import '../data/models/instruction_model.dart';
import '../data/models/case_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/guid_image/app_controller.dart';
import '../services/guid_image/details_view.dart';
import '../services/guid_image/view_list_guid.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/color_app.dart';
import '../views/widgets/more_widgets.dart';
import '../views/screens/profile/prorfile_screen.dart';
import 'home_controller.dart';
import 'profile_controller.dart';
import 'storage_controller.dart';

class CaseController extends GetxController {
  // Dynamic questions based on service type
  
  // Medical history questions (common to all case sheets)
  List<TextAndData> medicalHistoryQuestions = [
    TextAndData('هل تعاني من ارتفاع ضغط الدم ؟', ''.obs, key: 'bp'),
    TextAndData('هل تعاني من السكري ؟', ''.obs, key: 'diabetic'),
    TextAndData('هل لديك مشاكل بالقلب ؟', ''.obs, key: 'heartProblems'),
    TextAndData('هل سبق واجريت عملية جراحية ؟', ''.obs, key: 'surgicalOperations'),
    TextAndData(
      'هل تعاني من اي مرض حالي ؟',
      ''.obs,
      key: 'currentDisease',
      subQuestion: TextAndData(
        'يرجى توضيح المرض',
        ''.obs,
        key: 'currentDiseaseDetails',
      ),
    ),
  ];
  
  // Case sheet for معالجة الاسنان (Dental Treatment)
  List<TextAndData> treatmentQuestions = [
    TextAndData('هل تعاني من ألم مستمر؟', ''.obs, key: 'pain_continues'),
    TextAndData(
      'هل يؤلمك السن عند العض أو الأكل؟', 
      ''.obs, 
      key: 'pain_eat',
      subQuestion: TextAndData(
        'نوع الألم',
        ''.obs,
        key: 'pain_eat_type',
      ),
    ),
    TextAndData(
      'هل تعاني من ألم عند شرب السوائل الباردة؟', 
      ''.obs, 
      key: 'pain_caild_drink',
      subQuestion: TextAndData(
        'مدة الألم',
        ''.obs,
        key: 'pain_caild_drink_type',
      ),
    ),
    TextAndData('هل تعاني من ألم عند شرب السوائل الحارة؟', ''.obs, key: 'pain_hot_drink'),
    TextAndData('ألم يوقظك من النوم أو يمنعك من النوم؟', ''.obs, key: 'pain_sleep'),
    TextAndData('هل تعاني من إلتهاب أو خراج في السن؟', ''.obs, key: 'inflamation'),
    TextAndData('وجود حركة بالأسنان؟', ''.obs, key: 'teeth_movement'),
  ];
  
  // Case sheet for تنظيف الاسنان (Teeth Cleaning)
  List<TextAndData> cleaningQuestions = [
    TextAndData('وجود حركة في الأسنان', ''.obs, key: 'teeth_movement'),
    TextAndData('وجود تكلسات أو جير', ''.obs, key: 'calcifications'),
    TextAndData('وجود تصبغات', ''.obs, key: 'pigmentation'),
    TextAndData('ألم مستمر في اللثة', ''.obs, key: 'pain_continues_gum'),
    TextAndData('ألم في اللثة أثناء الأكل', ''.obs, key: 'pain_eat_gum'),
    TextAndData('نزيف عن التفريش', ''.obs, key: 'bleeding_during_brushing'),
  ];
  
  // Case sheet for تعويض الاسنان (Teeth Replacement)
  List<TextAndData> replacementQuestions = [
    TextAndData('وجود تكلسات أو جير؟', ''.obs, key: 'calcifications'),
    TextAndData('وجود حركة بالأسنان؟', ''.obs, key: 'teeth_movement'),
    TextAndData('وجود جذور اسنان تالفة؟', ''.obs, key: 'roots'),
    TextAndData('وجود التهاب في الفم؟', ''.obs, key: 'mouth_inflammation'),
    TextAndData('وجود تقرحات في الفم؟', ''.obs, key: 'mouth_ulcer'),
    TextAndData('وجود تسوس في الأسنان؟', ''.obs, key: 'tooth_decay'),
  ];
  
  // Computed property to get current questions based on service type
  List<TextAndData> get currentQuestions {
    List<TextAndData> serviceQuestions;
    switch (selectedServiceType.value) {
      case 'معالجة الاسنان':
        serviceQuestions = treatmentQuestions;
        break;
      case 'تنظيف الاسنان':
        serviceQuestions = cleaningQuestions;
        break;
      case 'تعويض الاسنان':
        serviceQuestions = replacementQuestions;
        break;
      default:
        serviceQuestions = treatmentQuestions; // Default fallback
    }
    // Combine medical history questions with service-specific questions
    return [...medicalHistoryQuestions, ...serviceQuestions];
  }
  
  // For backward compatibility - will be empty now
  List<TextAndData> reasonsForVisit = [];
  List<TextAndData> symptoms = [];

  RxBool isLoading = false.obs;
  RxString selectedServiceType = ''.obs; // Store selected service type
  
  // Dynamic instructions based on service type
  RxList<Instruction> currentInstructions = <Instruction>[].obs;
  
  // Store existing image URLs from rejected case (for display purposes)
  Map<String, String?> existingImageUrls = {};
  
  // Track if we're reapplying a rejected case
  String? reapplyingCaseId;
  
  // Track previous service type for reapplication
  String? previousServiceType;
  
  // Flag to indicate if images should be cleared on backend
  bool _shouldClearImages = false;

  void selectAnswer(TextAndData item, String value) {
    item.value(value);
    
    // Clear sub-question value if parent answer is not the trigger value
    if (item.subQuestion != null && value != (item.parentTriggerValue ?? 'نعم')) {
      item.subQuestion!.value('');
    }
  }
  
  void setServiceType(String serviceType) {
    selectedServiceType.value = serviceType;
    // Load dynamic instructions for this service type
    final appController = Get.find<AppController>();
    currentInstructions.value = appController.getInstructionsForServiceType(serviceType);
  }
  
  // Method to handle service type change with confirmation for reapplying cases
  Future<bool> handleServiceTypeChange(String newServiceType) async {
    // Only show warning if we're reapplying a case and changing the type
    if (reapplyingCaseId != null &&
        previousServiceType != null &&
        previousServiceType != newServiceType) {
      
      bool? confirmed = await _showCaseTypeChangeDialog(previousServiceType!, newServiceType);
      
      if (confirmed == true) {
        // User confirmed - clear existing images
        existingImageUrls.clear();
        // Clear all images in current instructions
        for (var instruction in currentInstructions) {
          instruction.image.value = null;
        }
        // Set flag to clear images on backend
        _shouldClearImages = true;
        return true;
      } else {
        // User cancelled - don't change service type
        return false;
      }
    }
    
    // Not a reapplication or same type - proceed normally
    return true;
  }
  
  // Show confirmation dialog when changing case type
  Future<bool?> _showCaseTypeChangeDialog(String oldType, String newType) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('تغيير نوع الحالة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أنت على وشك تغيير نوع الحالة من "$oldType" إلى "$newType"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Text(
              'سيؤدي هذا إلى حذف جميع الصور السابقة. هل تريد المتابعة؟',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'كل نوع حالة يتطلب صوراً محددة ومختلفة',
                      style: TextStyle(fontSize: 12, color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد الحذف'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void nextStep() {
    // تأكد من أن المستخدم أجاب على جميع الأسئلة
    for (var question in currentQuestions) {
      if (question.value.isEmpty) {
        MessageSnak.message('يرجى الإجابة على جميع الأسئلة قبل المتابعة');
        return;
      }
      
      // Check if sub-question should be answered
      if (question.shouldShowSubQuestion && question.subQuestion!.value.isEmpty) {
        MessageSnak.message('يرجى الإجابة على جميع الأسئلة الفرعية');
        return;
      }
    }

    Get.to(() => ViewListGuid());
    MessageSnak.message('تم الحفظ بنجاح', color: ColorApp.greenColor);
  }

  TextEditingController note = TextEditingController();

  // Rx<File?> imageLeft = Rx<File?>(null);
  // Rx<File?> imageRight = Rx<File?>(null);
  // Rx<File?> imageTop = Rx<File?>(null);
  // Rx<File?> imageBottom = Rx<File?>(null);
  Rx<Instruction?> instructionSelect = Rx(null);
  void selectInstruction(Instruction instruction) {
    instructionSelect.value = instruction;
    Get.to(() => DetailsView());
  }

  AppController appController = Get.find<AppController>();
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      instructionSelect.value!.image.value = File(pickedFile.path);
      Get.back();
      Get.back();
      Get.back();

      MessageSnak.message('تم اختيار الصورة بنجاح', color: ColorApp.greenColor);
      // await Future.delayed(Duration(seconds: 2));

      // cropImage(File(pickedFile.path));
    }
    Get.back();
  }

  void selectImage(int indexIamge) {
    showImagePicker(
        onPressedCamera: (() => pickImage(ImageSource.camera)),
        onPressedGallery: () => pickImage(ImageSource.gallery));
  }

  void clearFeilds() {
    //Clear all question types
    for (TextAndData i in medicalHistoryQuestions) {
      i.value('');
    }
    for (TextAndData i in treatmentQuestions) {
      i.value('');
    }
    for (TextAndData i in cleaningQuestions) {
      i.value('');
    }
    for (TextAndData i in replacementQuestions) {
      i.value('');
    }
    // Clear all images in current instructions
    for (var instruction in currentInstructions) {
      instruction.image.value = null;
    }
    note.text = '';
    selectedServiceType.value = '';
    currentInstructions.clear(); // Clear current instructions
    existingImageUrls.clear(); // Clear existing image URLs
    reapplyingCaseId = null; // Clear reapplying case ID
    previousServiceType = null; // Clear previous service type
    _shouldClearImages = false; // Reset clear images flag
  }
  
  // Overload to accept Case from profile
  void prefillFromRejectedCaseSimple(dynamic rejectedCase) {
    // Store case ID for reapplying
    reapplyingCaseId = rejectedCase.id;
    
    // Pre-fill service type and load instructions
    if (rejectedCase.serviceType != null && rejectedCase.serviceType!.isNotEmpty) {
      previousServiceType = rejectedCase.serviceType; // Track original type
      setServiceType(rejectedCase.serviceType!); // This will load the instructions
    }
    
    // Pre-fill note
    if (rejectedCase.note != null && rejectedCase.note!.isNotEmpty) {
      note.text = rejectedCase.note;
    }
    
    // Pre-fill answers based on service type
    _prefillAnswersFromCase(rejectedCase);
    
    // Store existing image URLs (all possible images)
    existingImageUrls = {
      'imageFront': rejectedCase.imageFront,
      'imageChock': rejectedCase.imageChock,
      'imageBottom': rejectedCase.imageBottom,
      'imageTop': rejectedCase.imageTop,
      'imageCheek': rejectedCase.imageCheek,
      'imageToung': rejectedCase.imageToung,
      'imageLeft': rejectedCase.imageLeft,
      'imageRight': rejectedCase.imageRight,
    };
    
    MessageSnak.message('تم تحميل بيانات الحالة المرفوضة. يمكنك تعديل الإجابات والصور', color: ColorApp.greenColor);
  }
  
  void _prefillAnswersFromCase(dynamic rejectedCase) {
    // Helper to convert backend value to Arabic
    String convertValue(String? value) {
      if (value == 'yes') return 'نعم';
      if (value == 'no') return 'لا';
      return 'لا أعلم';
    }
    
    // Get all questions from all types
    final allQuestions = [...medicalHistoryQuestions, ...treatmentQuestions, ...cleaningQuestions, ...replacementQuestions];
    
    for (TextAndData item in allQuestions) {
      dynamic value;
      dynamic subValue;
      
      switch (item.key) {
        case 'bp':
          value = rejectedCase.bp;
          break;
        case 'diabetic':
          value = rejectedCase.diabetic;
          break;
        case 'heartProblems':
          value = rejectedCase.heartProblems;
          break;
        case 'surgicalOperations':
          value = rejectedCase.surgicalOperations;
          break;
        case 'currentDisease':
          value = rejectedCase.currentDisease;
          subValue = rejectedCase.currentDiseaseDetails; // Sub-question value
          break;
        case 'pain_continues':
          value = rejectedCase.painContinues;
          break;
        case 'pain_eat':
          value = rejectedCase.painEat;
          subValue = rejectedCase.painEatType; // Sub-question value
          break;
        case 'pain_caild_drink':
          value = rejectedCase.painCaildDrink;
          subValue = rejectedCase.painCaildDrinkType; // Sub-question value
          break;
        case 'pain_hot_drink':
          value = rejectedCase.painHotDrink;
          break;
        case 'pain_sleep':
          value = rejectedCase.painSleep;
          break;
        case 'inflamation':
          value = rejectedCase.inflamation;
          break;
        case 'teeth_movement':
          value = rejectedCase.teethMovement;
          break;
        case 'calcifications':
          value = rejectedCase.calcifications;
          break;
        case 'pigmentation':
          value = rejectedCase.pigmentation;
          break;
        case 'pain_continues_gum':
          value = rejectedCase.painContinuesGum;
          break;
        case 'pain_eat_gum':
          value = rejectedCase.painEatGum;
          break;
        case 'roots':
          value = rejectedCase.roots;
          break;
        case 'mouth_inflammation':
          value = rejectedCase.mouthInflammation;
          break;
        case 'mouth_ulcer':
          value = rejectedCase.mouthUlcer;
          break;
        case 'tooth_decay':
          value = rejectedCase.toothDecay;
          break;
        case 'bleeding_during_brushing':
          value = rejectedCase.bleedingDuringBrushing;
          break;
      }
      
      if (value != null) {
        item.value(convertValue(value));
      }
      
      // Prefill sub-question value if exists
      if (subValue != null && item.subQuestion != null) {
        item.subQuestion!.value(subValue);
      }
    }
  }
  
  void prefillFromRejectedCase(CaseModel rejectedCase) {
    // Store case ID for reapplying
    reapplyingCaseId = rejectedCase.id;
    
    // Pre-fill service type and load instructions
    if (rejectedCase.serviceType != null && rejectedCase.serviceType!.isNotEmpty) {
      previousServiceType = rejectedCase.serviceType; // Track original type
      setServiceType(rejectedCase.serviceType!); // This will load the instructions
    }
    
    // Pre-fill note
    if (rejectedCase.note != null && rejectedCase.note!.isNotEmpty) {
      note.text = rejectedCase.note!;
    }
    
    // Pre-fill answers based on service type
    _prefillAnswersFromCase(rejectedCase);
    
    // Store existing image URLs (all possible images)
    existingImageUrls = {
      'imageFront': rejectedCase.imageFront,
      'imageChock': rejectedCase.imageChock,
      'imageBottom': rejectedCase.imageBottom,
      'imageTop': rejectedCase.imageTop,
      'imageCheek': rejectedCase.imageCheek,
      'imageToung': rejectedCase.imageToung,
      'imageLeft': rejectedCase.imageLeft,
      'imageRight': rejectedCase.imageRight,
    };
    
    MessageSnak.message('تم تحميل بيانات الحالة المرفوضة. يمكنك تعديل الصور أو الاحتفاظ بها', color: ColorApp.greenColor);
  }

  // void viewCreateCase() => Get.toNamed(AppRoutes.createCase);
  void viewCreateCase() => Get.toNamed(AppRoutes.selectCareRequired);

  void completeData() {
    for (TextAndData i in currentQuestions) {
      if (i.value.isEmpty) {
        MessageSnak.message('يرجى ملأ كل الحقول');
        return;
      }
    }
    // Get.toNamed(AppRoutes.completeCase);
    Get.to(() => ViewListGuid());
  }

  void submitSendInfo() async {
    // Prevent race condition - check if already loading
    if (isLoading.value) {
      return;
    }
    
    for (TextAndData i in currentQuestions) {
      if (i.value.isEmpty) {
        MessageSnak.message('يرجى ملأ كل الحقول');
        return;
      }
    }
    // Check if all images are either captured or exist from rejected case
    for (Instruction image in currentInstructions) {
      bool hasNewImage = image.image.value != null;
      bool hasExistingImage = existingImageUrls[image.name] != null;
      
      if (!hasNewImage && !hasExistingImage) {
        MessageSnak.message('يجب التقاط صورة لكل الاتجاهات');
        return;
      }
    }
    
    isLoading(true);
    try {
      final Map<String, dynamic> dataMap = {
        'note': note.text.trim(),
        'type': selectedServiceType.value, // Add service type to 'type' field
        'clearImages': _shouldClearImages.toString(), // Add flag to clear images on backend
      };
      
      // Debug logging
      print('DEBUG: Submitting case with clearImages flag: $_shouldClearImages');
      print('DEBUG: Previous service type: $previousServiceType');
      print('DEBUG: Current service type: ${selectedServiceType.value}');

      // ✅ إضافة جميع قيم الأسئلة (including medical history + service-specific questions)
      for (TextAndData item in currentQuestions) {
        dataMap[item.key] = item.value.value == 'نعم'
            ? 'yes'
            : item.value.value == 'لا'
                ? 'no'
                : 'unknown';
        
        // Add sub-question value if it exists and is answered
        if (item.subQuestion != null && item.subQuestion!.value.isNotEmpty) {
          dataMap[item.subQuestion!.key] = item.subQuestion!.value.value;
        }
      }
      // Only upload new images (backend will keep existing ones)
      for (Instruction image in currentInstructions) {
        if (image.image.value != null) {
          // New image captured - upload it
          dataMap[image.name] = await dio.MultipartFile.fromFile(
            image.image.value!.path,
            filename: image.image.value!.path.split('/').last,
          );
        }
        // If no new image and we're reapplying, backend will keep the existing one
      }
      final formData = dio.FormData.fromMap(dataMap);

      print(formData.fields);
      print(formData.files);

      // ✅ إرسال الطلب - Use edit endpoint if reapplying, otherwise new
      final StateReturnData data;
      if (reapplyingCaseId != null) {
        // Reapplying rejected case - use PUT edit endpoint
        data = await ApiService.putData(ApiConstants.caseEdit(reapplyingCaseId!), formData);
        print('Reapplying case with ID: $reapplyingCaseId');
      } else {
        // New case - use POST new endpoint
        data = await ApiService.postData(ApiConstants.caseNew, formData);
        print('Creating new case');
      }

      isLoading(true);
      //
      //   dio.FormData formData = dio.FormData.fromMap(data
      //       //   {
      //       //   // 'bp': casesInfos[0].value.value == 'نعم' ? 'yes' : 'no',
      //       //   // 'diabetic': casesInfos[1].value.value == 'نعم' ? 'yes' : 'no',
      //       //   // 'toothRemoved': casesInfos[2].value.value == 'نعم' ? 'yes' : 'no',
      //       //   // 'tf': casesInfos[3].value.value == 'نعم' ? 'yes' : 'no',
      //       //   'note': note.text.trim(),
      //       //   for (Instruction image in appController.instructions)
      //       //     image.name: await dio.MultipartFile.fromFile(image.image.value!.path,
      //       //         filename: image.image.value!.path.split('/').last)
      //       // }
      //       );
      //   print(formData.fields);
      //   print(formData.files);
      //   //Send data

      //   StateReturnData data =
      //       await ApiService.postData(ApiConstants.caseNew, formData);
      if (data.isStateSucess <= 2) {
        ProfileController profileController = Get.find<ProfileController>();
        await profileController.fetchDataProfile();
        
        String successMessage = reapplyingCaseId != null 
            ? 'تم إعادة تقديم الحالة بنجاح' 
            : 'تم اضافة الحالة';
        
        clearFeilds();
        MessageSnak.message(successMessage, color: ColorApp.greenColor);
        // Navigate to home and switch to Apply Case tab
        Get.until((route) => route.isFirst);
        HomeController homeController = Get.find<HomeController>();
        // For regular users, Apply Case tab is at index 1
        // This will show the current case details on the Apply Case screen
        homeController.changeIndex(1);
      } else {
        // MessageSnak.message('حصل خطا', color: ColorApp.greenColor);
        // print(data.data);
        MessageSnak.message('تم رفع حالة مسبقا وما زال العمل عليها');
      }
    } catch (e) {
      MessageSnak.message('تأكد من الاتصال ');
    } finally {
      await Future.delayed(Duration(seconds: 1));
      isLoading(false);
    }
  }
}

class TextAndData {
  String name;
  RxString value;
  String key;
  TextAndData? subQuestion; // Optional sub-question
  String? parentTriggerValue; // Value that triggers sub-question (default: 'نعم')
  
  TextAndData(
    this.name, 
    this.value, 
    {
      required this.key,
      this.subQuestion,
      this.parentTriggerValue = 'نعم',
    }
  );
  
  // Check if sub-question should be visible
  bool get shouldShowSubQuestion => 
      subQuestion != null && value.value == (parentTriggerValue ?? 'نعم');
}
