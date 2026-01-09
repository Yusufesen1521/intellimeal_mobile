import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intellimeal/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
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
              hintText: 'Ad',
              prefixIcon: LucideIcons.user,
              onChanged: (value) {
                nameController.text = value;
              },
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.text,
              hintText: 'Soyad',
              prefixIcon: LucideIcons.user,
              onChanged: (value) {
                surnameController.text = value;
              },
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              prefixIcon: LucideIcons.mail,
              onChanged: (value) {
                emailController.text = value;
              },
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              hintText: 'Şifre',
              prefixIcon: LucideIcons.lockKeyhole,
              onChanged: (value) {
                passwordController.text = value;
              },
              suffixIcon: LucideIcons.eyeClosed,
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              hintText: 'Şifre Tekrar',
              prefixIcon: LucideIcons.lockKeyhole,
              onChanged: (value) {
                confirmPasswordController.text = value;
              },
              suffixIcon: LucideIcons.eyeClosed,
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.phone,
              hintText: 'Telefon Numarası',
              prefixIcon: LucideIcons.phone,
              onChanged: (value) {
                phoneNumberController.text = value;
              },
            ),
            SizedBox(height: 16.h),
            // AppButton(
            //   onPressed: () {},
            //   backgroundColor: AppColors.appBlack,
            //   foregroundColor: AppColors.appWhite,
            //   borderRadius: BorderRadius.circular(20.r),
            //   width: 295.w,
            //   height: 50.h,
            //   child: Text(
            //     'Kod Gönder',
            //     style: TextStyle(
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.w500,
            //       color: AppColors.appWhite,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 16.h),
            // Apptextfield(
            //   keyboardType: TextInputType.text,
            //   hintText: 'Onay Kodu',
            //   prefixIcon: LucideIcons.shieldCheck,
            //   onChanged: (value) {},
            // ),
            // SizedBox(
            //   width: 295.w,
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: TextButton(
            //       onPressed: () {},
            //       child: Text(
            //         textAlign: TextAlign.right,
            //         'Tekrar Gönder',
            //         style: TextStyle(
            //           fontSize: 16.sp,
            //           fontWeight: FontWeight.w500,
            //           color: AppColors.appBlack,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            AppButton(
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  print('Şifreler uyuşmuyor');
                  return;
                }
                final result = await authService.signUp(
                  nameController.text,
                  surnameController.text,
                  phoneNumberController.text,
                  emailController.text,
                  passwordController.text,
                );

                if (result != null) {
                  GetStorage().write('token', result.token);
                  GetStorage().write('userId', result.user!.id);
                  context.go(
                    '/profile/personal-info',
                    extra: {
                      'userId': result.user!.id,
                      'token': result.token,
                    },
                  );
                } else {
                  print(result);
                }
              },

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
