import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Giriş Yap',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.appBlack,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            LucideIcons.chevronLeft,
            color: AppColors.appBlack,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Apptextfield(
              keyboardType: TextInputType.phone,
              hintText: 'Telefon Numarası',
              prefixIcon: LucideIcons.phone,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.text,
              isPassword: true,
              hintText: 'Şifre',
              prefixIcon: LucideIcons.lockKeyhole,
              suffixIcon: LucideIcons.eyeClosed,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: () {
                context.push('/signup');
              },
              child: Text('Sign In'),
              backgroundColor: AppColors.appBlack,
              foregroundColor: AppColors.appWhite,
              borderRadius: BorderRadius.circular(20.r),
              width: 305.w,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
