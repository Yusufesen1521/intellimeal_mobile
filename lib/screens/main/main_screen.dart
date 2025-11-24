import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: -150.w,
            top: -150.h,
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appGreen,
              ),
            ),
          ),
          Positioned(
            right: 150.w,
            top: 150.h,
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appBlue,
              ),
            ),
          ),
          Positioned(
            bottom: -200.h,
            left: 200.w,

            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appRed,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/intellimeal_logo.png',
                  width: 390.w,
                  height: 390.h,
                ),

                AppButton(
                  onPressed: () {
                    context.push('/signin');
                  },
                  backgroundColor: AppColors.appBlack,
                  foregroundColor: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  width: 335.w,
                  height: 55.h,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appWhite,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                AppButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  backgroundColor: AppColors.appGreen,
                  foregroundColor: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  width: 335.w,
                  height: 55.h,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appBlack,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                AppButton(
                  onPressed: () {
                    context.push('/profile');
                  },
                  backgroundColor: AppColors.appGreen,
                  foregroundColor: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  width: 335.w,
                  height: 55.h,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
