import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/snackbar_helper.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:intellimeal/utils/widgets/selectable_expansion_wrap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String userId;
  final String token;
  const PersonalInfoScreen({super.key, required this.userId, required this.token});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController neckSizeController = TextEditingController();
  final TextEditingController waistSizeController = TextEditingController();
  final TextEditingController hipSizeController = TextEditingController();
  final TextEditingController chestSizeController = TextEditingController();
  final TextEditingController armSizeController = TextEditingController();
  final TextEditingController legSizeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    genderController.dispose();
    neckSizeController.dispose();
    waistSizeController.dispose();
    hipSizeController.dispose();
    chestSizeController.dispose();
    armSizeController.dispose();
    legSizeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // Validasyon
    if (ageController.text.isEmpty || weightController.text.isEmpty || heightController.text.isEmpty || genderController.text.isEmpty) {
      SnackbarHelper.showWarning(context, 'Lütfen zorunlu alanları doldurun');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await UserService().createPersonalInfo(
        widget.userId,
        widget.token,
        ageController.text,
        weightController.text,
        heightController.text,
        genderController.text,
        neckSizeController.text,
        waistSizeController.text,
        hipSizeController.text,
        chestSizeController.text,
        armSizeController.text,
        legSizeController.text,
      );

      if (!mounted) return;

      if (success) {
        // UserController'ı güncelle
        if (Get.isRegistered<UserController>()) {
          Get.find<UserController>().refreshTokens();
        }

        SnackbarHelper.showSuccess(context, 'Bilgileriniz kaydedildi!');
        context.go('/main');
      } else {
        SnackbarHelper.showError(context, 'Bir hata oluştu. Lütfen tekrar deneyin.');
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
          'Kişisel Bilgiler',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.appBlack,
          ),
        ),
        leading: IconButton(
          onPressed: _isLoading ? null : () => context.pop(),
          icon: Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Yaşınız *',
                onChanged: (value) {
                  ageController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Kilonuz (kg) *',
                onChanged: (value) {
                  weightController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Boyunuz (cm) *',
                onChanged: (value) {
                  heightController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              SelectableExpansionWrap(
                title: 'Cinsiyet *',
                options: [
                  "Erkek",
                  "Kadın",
                ],
                multiSelect: false,
                onSelectionChanged: (value) {
                  genderController.text = value.first;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Boyun Çevresi (cm)',
                onChanged: (value) {
                  neckSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Bel Çevresi (cm)',
                onChanged: (value) {
                  waistSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Kalça Çevresi (cm)',
                onChanged: (value) {
                  hipSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Göğüs Çevresi (cm)',
                onChanged: (value) {
                  chestSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Kol Çevresi (cm)',
                onChanged: (value) {
                  armSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Bacak Çevresi (cm)',
                onChanged: (value) {
                  legSizeController.text = value;
                },
              ),
              SizedBox(height: 24.h),
              AppButton(
                onPressed: _handleSave,
                isLoading: _isLoading,
                backgroundColor: AppColors.appGreen,
                foregroundColor: AppColors.appWhite,
                borderRadius: BorderRadius.circular(20.r),
                width: 335.w,
                height: 50.h,
                child: Text(
                  'Kaydet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
