import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../widgets/modern/app_header.dart';
import 'nav_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            // Main content
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 60), // Space for header
                  Expanded(child: Obx(() => homeController.getBody()))
                ]),
            // Header positioned on top
            AppHeader(),
          ],
        ),
        bottomNavigationBar: NavBar());
  }
}
