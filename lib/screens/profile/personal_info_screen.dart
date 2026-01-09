import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/services/dio_instance.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/app_urls.dart';
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
  final UserController userController = UserController();
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
          onPressed: () {
            context.pop();
          },
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
                hintText: 'Yaşınız',
                onChanged: (value) {
                  ageController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Kilonuz',
                onChanged: (value) {
                  weightController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Boyunuz',
                onChanged: (value) {
                  heightController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              SelectableExpansionWrap(
                title: 'Cinsiyet',
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
                hintText: 'Boyun Genişliği',
                onChanged: (value) {
                  neckSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Bel Genişliği',
                onChanged: (value) {
                  waistSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Kalça Genişliği',
                onChanged: (value) {
                  hipSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Göğüs Genişliği',
                onChanged: (value) {
                  chestSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Kol Genişliği',
                onChanged: (value) {
                  armSizeController.text = value;
                },
              ),
              SizedBox(height: 20.h),
              Apptextfield(
                maxWidth: MediaQuery.of(context).size.width,
                keyboardType: TextInputType.number,
                hintText: 'Bacak Genişliği',
                onChanged: (value) {
                  legSizeController.text = value;
                },
              ),

              SizedBox(height: 20.h),
              AppButton(
                onPressed: () async {
                  await UserService()
                      .createPersonalInfo(
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
                      )
                      .then((value) {
                        if (value) {
                          userController.getUser();
                          context.go('/main');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bir hata oluştu'),
                            ),
                          );
                        }
                      });
                },
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
