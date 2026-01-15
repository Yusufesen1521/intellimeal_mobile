import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/services/auth_service.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String userId;
  final String token;
  const VerificationScreen({super.key, required this.email, required this.userId, required this.token});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _verificationCodeController = TextEditingController();
  bool _isLoading = false;

  Future<bool> _handleVerification(String email, String code) async {
    setState(() {
      _isLoading = true;
    });
    bool result = await AuthService().verify(code, email);

    setState(() {
      _isLoading = false;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doğrulama'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Apptextfield(
                  keyboardType: TextInputType.number,
                  hintText: 'Doğrulama Kodu',
                  prefixIcon: LucideIcons.user,
                  maxLength: 6,
                  onChanged: (value) {
                    _verificationCodeController.text = value;
                  },
                ),
                SizedBox(height: 16.h),
                AppButton(
                  onPressed: () async {
                    bool result = await _handleVerification(widget.email, _verificationCodeController.text);
                    if (result) {
                      context.go(
                        '/profile/personal-info',
                        extra: {
                          'userId': widget.userId,
                          'token': widget.token,
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Doğrulama kodu yanlış'),
                        ),
                      );
                    }
                  },
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
