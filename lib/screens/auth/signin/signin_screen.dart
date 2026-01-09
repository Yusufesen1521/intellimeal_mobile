import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/services/auth_service.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/snackbar_helper.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    // Validasyon
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackbarHelper.showWarning(context, 'Lütfen tüm alanları doldurun');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (!mounted) return;

      if (result != null) {
        GetStorage().write('token', result.token);
        GetStorage().write('userId', result.user!.id);

        SnackbarHelper.showSuccess(context, 'Giriş başarılı!');

        if (result.user!.role == 'DOCTOR') {
          context.go('/nutritionist/main');
        } else {
          context.go('/main');
        }
      } else {
        SnackbarHelper.showError(context, 'E-posta veya şifre hatalı');
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, 'Bağlantı hatası. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
          onPressed: _isLoading ? null : () => context.pop(),
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
              onPressed: _handleSignIn,
              isLoading: _isLoading,
              backgroundColor: AppColors.appBlack,
              foregroundColor: AppColors.appWhite,
              borderRadius: BorderRadius.circular(20.r),
              width: 305.w,
              height: 50.h,
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
