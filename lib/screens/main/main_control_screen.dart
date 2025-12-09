import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intellimeal/controllers/main_navigation_controller.dart';
import 'package:intellimeal/screens/calender/calender_screen.dart';
import 'package:intellimeal/screens/home/home_screen.dart';
import 'package:intellimeal/screens/profile/profile_screen.dart';
import 'package:intellimeal/screens/statistics/statistics_screen.dart';
import 'package:intellimeal/utils/app_colors.dart';

class MainControlScreen extends StatelessWidget {
  MainControlScreen({super.key});

  final MainNavigationController controller = Get.put(
    MainNavigationController(),
  );

  // Pages list matching the index order
  final List<Widget> pages = [
    StatisticsScreen(),
    CalenderScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => _buildBottomNavBar()),
      extendBody: true,
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.appBlack,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: LucideIcons.chartNoAxesCombined,
            index: 0,
          ),
          _buildNavItem(
            icon: LucideIcons.clipboardList,
            index: 1,
          ),
          _buildNavItem(
            icon: LucideIcons.house,
            index: 2,
          ),
          _buildNavItem(
            icon: LucideIcons.user,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    final isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Icon(
          icon,
          size: 24.sp,
          color: isSelected
              ? AppColors.appWhite
              : AppColors.appWhite.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
