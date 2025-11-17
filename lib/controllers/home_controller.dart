import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_doctor/controllers/storage_controller.dart';

import '../data/models/post_model.dart';
import '../services/api_service.dart';
import '../utils/constants/api_constants.dart';
import '../views/screens/admin/admin_cases_screen.dart';
import '../views/screens/admin/admin_dashboard.dart';
import '../views/screens/admin/posts_view.dart';
import '../views/screens/admin/request_role_view.dart';
import '../views/screens/categores_and_cases/categores_screen.dart';
import '../views/screens/doctor/omn_cases.dart';
import '../views/screens/doctor/start_case.dart';
import '../views/screens/doctor/view_cases.dart';
import '../views/screens/home/posts_view_all.dart';
import '../views/screens/profile/prorfile_screen.dart';
import 'category_controller.dart';

class NavBarModel {
  String name;
  IconData icon;
  Widget widget;
  NavBarModel(this.icon, this.name, this.widget);
}

class HomeController extends GetxController {
  RxList<Post> posts = RxList<Post>([]);
  RxBool isLoading = RxBool(false);

  RxInt currentIndex = RxInt(0);
  RxList<NavBarModel> bodys = RxList<NavBarModel>([]);
  void changeIndex(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
    if (bodys[currentIndex.value].widget is CategoresScreen) {
      final CategoryController categoryController =
          Get.find<CategoryController>();
      categoryController.fetchDataCategory();
    }
  }

//  BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.house), label: 'Home'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.magnifyingGlass), label: 'Search'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.bandage), label: 'Ome Cases'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.userDoctor), label: 'Profile'),
  @override
  void onInit() {
    fetchDataPosts();

    super.onInit();
    bodys([
      if (StorageController.isAdmin())
        NavBarModel(FontAwesomeIcons.house, 'الرئيسية', AdminDashboard())
      else
        NavBarModel(FontAwesomeIcons.house, 'الرئيسية', PostsViewAll()),
      if (StorageController.isAdmin())
        NavBarModel(FontAwesomeIcons.newspaper, 'مقالاتي', PostsView()),
      if (StorageController.isDoctor())
        NavBarModel(FontAwesomeIcons.bandage, 'الحالات', ViewCases()),
      if (!StorageController.isAdmin() && !StorageController.isDoctor())
        NavBarModel(FontAwesomeIcons.bandage, 'تقديم طلب', StartCase()),
      if (StorageController.isAdmin())
        NavBarModel(Icons.medical_information, 'الحالات', AdminCasesScreen()),
      if (StorageController.isAdmin())
        NavBarModel(FontAwesomeIcons.userDoctor, 'الطلبات', RequestRoleView()),
      if (StorageController.isAdmin())
        NavBarModel(Icons.category_outlined, 'الفئات', CategoresScreen()),
      if (StorageController.isDoctor())
        NavBarModel(FontAwesomeIcons.folderOpen, 'حالاتي', OmnCases()),
      NavBarModel(FontAwesomeIcons.userDoctor, 'الملف', ProrfileScreen()),
    ]);
    
    // Check if initialTab was passed as argument (e.g., from payment success)
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map && arguments.containsKey('initialTab')) {
      final int initialTab = arguments['initialTab'];
      if (initialTab >= 0 && initialTab < bodys.length) {
        currentIndex.value = initialTab;
        print('🎯 Set initial tab to index $initialTab');
        return; // Skip default logic below
      }
    }
    
    // Set default page: for regular users (patients), start with "Apply case" page
    if (!StorageController.isAdmin() && !StorageController.isDoctor()) {
      currentIndex.value = 1; // Index 1 is "Apply case" for regular users
    }
    //  ViewCases(), PostsView(), OmnCases(), StartCase()
  }

  Future<void> fetchDataPosts() async {
    isLoading(true);

    try {
      final StateReturnData response =
          await ApiService.getData(ApiConstants.homePost);

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

  Widget getBody() => bodys[currentIndex.value].widget;
}
