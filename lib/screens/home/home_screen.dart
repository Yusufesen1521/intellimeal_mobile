import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/screens/profile/personal_info_screen.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, String> chips = {
    'Pzt': '09',
    'Sal': '10',
    'Çar': '11',
    'Per': '12',
    'Cum': '13',
    'Cts': '14',
    'Paz': '15',
  };

  final List<String> meals = [
    'Kahvaltı',
    'Öğle Yemeği',
    'Aksam Yemeği',
    'Yatış Yemeği',
  ];

  UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    userController.getUser();
    userController.getDailyPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return Text(
                  'Hoş geldin, \n${userController.user.value.name ?? ""}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack,
                  ),
                );
              }),
              IconButton(
                onPressed: () {},
                icon: Icon(LucideIcons.bell),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips.entries.map((entry) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  margin: EdgeInsets.only(right: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.appWhite,
                    border: Border.all(
                      color: AppColors.appBlack,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.appBlack,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.appBlack,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.appWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.appBlack.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: meals.map((meal) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        margin: EdgeInsets.only(right: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.appWhite,
                          border: Border.all(
                            color: AppColors.appBlack,
                          ),
                        ),
                        child: Text(
                          meal,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appBlack,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.appWhite,
                          border: Border.all(
                            color: AppColors.appBlack,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Yemekler',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.appBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.appWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.appBlack.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          AppButton(
            width: double.infinity,
            height: 50.h,
            onPressed: () {},

            backgroundColor: AppColors.appPurple,
            foregroundColor: AppColors.appBlack,
            borderRadius: BorderRadius.circular(20.r),
            child: Row(
              children: [
                Icon(
                  LucideIcons.tableOfContents,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Porsiyon Tablosu',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack,
                  ),
                ),
                Spacer(),
                Icon(
                  LucideIcons.chevronRight,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
