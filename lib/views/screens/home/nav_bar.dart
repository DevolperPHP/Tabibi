import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/home_controller.dart';
import '../../../utils/design_system/modern_theme.dart';

// ignore: must_be_immutable
class NavBar extends StatelessWidget {
  NavBar({super.key});
  HomeController homeController = Get.find<HomeController>();
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(
              horizontal: ModernTheme.spaceMD,
              vertical: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: homeController.bodys.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = homeController.currentIndex.value == index;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => homeController.changeIndex(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Active indicator
                              if (isSelected)
                                Container(
                                  width: 42,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: ModernTheme.primaryBlue.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
                                  ),
                                ),
                              // Icon
                              Icon(
                                item.icon,
                                size: 22,
                                color: isSelected
                                    ? ModernTheme.primaryBlue
                                    : ModernTheme.textTertiary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Label
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.cairo(
                              fontSize: isSelected ? 11 : 10,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? ModernTheme.primaryBlue
                                  : ModernTheme.textTertiary,
                              height: 1.0,
                            ),
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
