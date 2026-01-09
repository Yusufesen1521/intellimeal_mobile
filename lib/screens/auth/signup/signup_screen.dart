import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/snackbar_helper.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validasyon
    if (nameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      SnackbarHelper.showWarning(context, 'Lütfen tüm alanları doldurun');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      SnackbarHelper.showError(context, 'Şifreler uyuşmuyor');
      return;
    }

    if (passwordController.text.length < 6) {
      SnackbarHelper.showWarning(context, 'Şifre en az 6 karakter olmalıdır');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await authService.signUp(
        nameController.text,
        surnameController.text,
        phoneNumberController.text,
        emailController.text,
        passwordController.text,
      );

      if (!mounted) return;

      if (result != null) {
        GetStorage().write('token', result.token);
        GetStorage().write('userId', result.user!.id);

        SnackbarHelper.showSuccess(context, 'Kayıt başarılı!');

        context.go(
          '/profile/personal-info',
          extra: {
            'userId': result.user!.id,
            'token': result.token,
          },
        );
      } else {
        SnackbarHelper.showError(context, 'Kayıt başarısız. Bu e-posta zaten kullanılıyor olabilir.');
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
        title: Text('Kayıt Ol'),
        leading: IconButton(
          onPressed: _isLoading ? null : () => context.pop(),
          icon: Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
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
                SizedBox(height: 24.h),
                AppButton(
                  onPressed: _handleSignUp,
                  isLoading: _isLoading,
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
        ),
      ),
    );
  }
}
