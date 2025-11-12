import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Kayıt Ol'),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Apptextfield(
              keyboardType: TextInputType.text,
              hintText: 'Ad Soyad',
              prefixIcon: LucideIcons.user,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              prefixIcon: LucideIcons.mail,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              hintText: 'Şifre',
              prefixIcon: LucideIcons.lockKeyhole,
              onChanged: (value) {},
              suffixIcon: LucideIcons.eyeClosed,
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              hintText: 'Şifre Tekrar',
              prefixIcon: LucideIcons.lockKeyhole,
              onChanged: (value) {},
              suffixIcon: LucideIcons.eyeClosed,
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.phone,
              hintText: 'Telefon Numarası',
              prefixIcon: LucideIcons.phone,
              onChanged: (value) {},
            ),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: () {},
              backgroundColor: AppColors.appBlack,
              foregroundColor: AppColors.appWhite,
              borderRadius: BorderRadius.circular(20.r),
              width: 295.w,
              height: 50.h,
              child: Text(
                'Kod Gönder',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.appWhite,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.text,
              hintText: 'Onay Kodu',
              prefixIcon: LucideIcons.shieldCheck,
              onChanged: (value) {},
            ),
            SizedBox(
              width: 295.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    textAlign: TextAlign.right,
                    'Tekrar Gönder',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlack,
                    ),
                  ),
                ),
              ),
            ),
            AppButton(
              onPressed: () {},

              backgroundColor: AppColors.appBlack,
              foregroundColor: AppColors.appWhite,
              borderRadius: BorderRadius.circular(20.r),
              width: 295.w,
              height: 50.h,
              child: Text(
                'Kayıt Ol',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.appWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
