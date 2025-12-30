import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        // Header
        Text(
          'لوحة التحكم',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'إدارة النظام',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 24),

        // Navigation Cards
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildSimpleCard(
              icon: Icons.medical_information,
              title: 'الحالات',
              color: Colors.blue,
              index: 2,
            ),
            _buildSimpleCard(
              icon: Icons.category_outlined,
              title: 'الفئات',
              color: Colors.orange,
              index: 4,
            ),
            _buildSimpleCard(
              icon: Icons.people_alt_outlined,
              title: 'الطلبات',
              color: Colors.green,
              index: 3,
            ),
            _buildSimpleCard(
              icon: Icons.article_outlined,
              title: 'المنشورات',
              color: Colors.purple,
              index: 1,
            ),
            _buildBannedUsersCard(),
          ],
        ),
      ],
    );
  }

  Widget _buildSimpleCard({
    required IconData icon,
    required String title,
    required Color color,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<HomeController>();
        controller.changeIndex(index);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannedUsersCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.bannedUsers);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: 48,
                color: Colors.red,
              ),
              SizedBox(height: 12),
              Text(
                'إدارة المستخدمين',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
