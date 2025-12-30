import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tabibi/controllers/storage_controller.dart';

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
    super.onInit();
    fetchDataPosts();
    _buildNavigationItems();

    // Check for role updates on initialization
    _checkForRoleUpdates();

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

  /// Checks if user role has changed and updates navigation if needed
  Future<void> _checkForRoleUpdates() async {
    print('🔍 Checking for role updates...');

    // Only check if user is logged in
    if (!StorageController.checkLoginStatus()) {
      return;
    }

    try {
      // Store current role status before refresh
      bool wasDoctor = StorageController.isDoctor();
      bool wasAdmin = StorageController.isAdmin();

      // Refresh user data from API
      bool refreshed = await StorageController.refreshUserDataFromAPI();

      if (refreshed) {
        // Check if role changed
        bool isDoctor = StorageController.isDoctor();
        bool isAdmin = StorageController.isAdmin();

        if (wasDoctor != isDoctor || wasAdmin != isAdmin) {
          print('🎉 User role changed! wasDoctor: $wasDoctor -> $isDoctor, wasAdmin: $wasAdmin -> $isAdmin');
          // Refresh navigation items to reflect new role
          refreshNavigationItems();
        }
      }
    } catch (e) {
      print('❌ Error checking role updates: $e');
    }
  }

  /// Rebuilds navigation items based on current user role
  /// Call this method when user role changes (e.g., became doctor)
  void refreshNavigationItems() {
    print('🔄 Refreshing navigation items...');

    // Store current tab name if possible to restore similar tab
    String? currentTabName = bodys.isNotEmpty && currentIndex.value < bodys.length
        ? bodys[currentIndex.value].name
        : null;

    // Rebuild navigation items
    _buildNavigationItems();

    // Try to restore a similar tab, or default to home
    if (currentTabName != null) {
      int newIndex = bodys.indexWhere((item) => item.name == currentTabName);
      if (newIndex >= 0) {
        currentIndex.value = newIndex;
      } else {
        currentIndex.value = 0; // Default to home
      }
    } else {
      currentIndex.value = 0;
    }

    print('✅ Navigation refreshed with ${bodys.length} items');
  }

  /// Builds the navigation items list based on user role
  void _buildNavigationItems() {
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
  }

  Future<void> fetchDataPosts() async {
    isLoading(true);

    try {
      print('🏠 [HomeController] Starting to fetch home posts...');
      print('🌐 [HomeController] API Endpoint: ${ApiConstants.baseUrl}${ApiConstants.homePost}');
      
      final StateReturnData response =
          await ApiService.getData(ApiConstants.homePost);

      print('📡 [HomeController] API Response received');
      print('📊 [HomeController] Response state: ${response.isStateSucess}');
      print('🔍 [HomeController] Response data type: ${response.data.runtimeType}');
      
      if (response.isStateSucess < 3) {
        print('📊 [HomeController] Raw API response: ${response.data}');
        
        // Handle empty response or null data
        if (response.data == null) {
          print('⚠️  [HomeController] No data received from home API (null response)');
          posts([]);
        } else if (response.data is List && response.data.isEmpty) {
          print('📝 [HomeController] Received empty list from API');
          posts([]);
        } else {
          print('🧩 [HomeController] Starting post parsing...');
          try {
            List<Post> newPost = Post.fromJsonList(response.data);
            print('📈 [HomeController] Successfully parsed ${newPost.length} posts');
            
            posts([]);
            posts.addAll(newPost);
            
            if (newPost.isNotEmpty) {
              print('✅ [HomeController] Loaded ${newPost.length} posts successfully');
              print('🎯 [HomeController] First post sample: ${newPost.first.toString()}');
            } else {
              print('ℹ️  [HomeController] No valid posts found in API response');
            }
          } catch (parseError) {
            print('❌ [HomeController] Post parsing error: $parseError');
            print('🔍 [HomeController] Error details: ${parseError.toString()}');
            posts([]);
          }
        }
      } else {
        print('❌ [HomeController] Home API error: State ${response.isStateSucess}');
        print('📊 [HomeController] Error response: ${response.data}');
        posts([]);
      }
    } catch (e) {
      print('❌ [HomeController] Error fetching posts: $e');
      print('🔍 [HomeController] Error type: ${e.runtimeType}');
      print('📝 [HomeController] Error stack: ${e.toString()}');
      posts([]);
      // Show user-friendly error message
      // MessageSnak.message("خطا في تحميل البيانات: $e");
    }

    isLoading.value = false;
    print('🏁 [HomeController] fetchDataPosts() completed');
  }

  Widget getBody() => bodys[currentIndex.value].widget;
}
