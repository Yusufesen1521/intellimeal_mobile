import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/local/user_local.dart';
import 'package:intellimeal/services/auth_service.dart';
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
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              prefixIcon: LucideIcons.mail,
              onChanged: (value) {
                emailController.text = value;
              },
            ),
            SizedBox(height: 16.h),
            Apptextfield(
              keyboardType: TextInputType.text,
              isPassword: true,
              hintText: 'Şifre',
              prefixIcon: LucideIcons.lockKeyhole,
              suffixIcon: LucideIcons.eyeClosed,
              onChanged: (value) {
                passwordController.text = value;
              },
            ),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: () async {
                final result = await authService.signIn(
                  emailController.text,
                  passwordController.text,
                );

                if (result != null) {
                  if (context.mounted) {

                    GetStorage().write('token', result.token);
                    GetStorage().write('userId', result.user!.id);

                    if(result.user!.role == 'DOCTOR') {
                      context.push('/nutritionist/main');
                    } else {
                      context.push('/main');
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Giriş başarısız'),
                      ),
                    );
                  }
                }
              },
              child: Text('Giriş Yap'),
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
