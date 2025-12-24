import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserController controller = UserController();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profilim',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.appBlack,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(LucideIcons.settings),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Stats cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.appPurple,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kilo",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.appBlack,
                        ),
                      ),
                      Obx(
                        () {
                          if (controller.user.personalInfo.isEmpty) {
                            return Text(
                              "0 kg",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appBlack,
                              ),
                            );
                          }
                          return Text(
                            "${controller.user.personalInfo.first.weight.toString()} kg",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appBlack,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.r),
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.appYellow,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vücut Yağ Oranı',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.appBlack,
                        ),
                      ),
                      Text(
                        "20%",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.appBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.r),
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.appLightBlue,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vücut Kitle Endeksi',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.appBlack,
                        ),
                      ),
                      Obx(
                        () {
                          if (controller.user.personalInfo.isEmpty) {
                            return Text(
                              "0",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appBlack,
                              ),
                            );
                          }
                          return Text(
                            calculateBodyFatPercentage(
                              controller.user.personalInfo.first.weight,
                              controller.user.personalInfo.first.height
                                  .toDouble(),
                            ).toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appBlack,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: AppButton(
              onPressed: () {
                context.push('/profile/get-meal-recommendation');
              },
              backgroundColor: AppColors.appGreen,
              foregroundColor: AppColors.appWhite,
              borderRadius: BorderRadius.circular(20.r),
              width: 335.w,
              height: 50.h,
              child: Text(
                'Öğün Önerisi Al',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.appBlack,
                ),
              ),
            ),
          ),
          // Add bottom padding for navbar
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

double calculateBodyFatPercentage(double weight, double height) {
  return weight / (height * height);
}
