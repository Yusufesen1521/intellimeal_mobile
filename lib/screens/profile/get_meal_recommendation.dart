import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/services/dio_instance.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/loading_Screen.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:intellimeal/utils/widgets/selectable_expansion_wrap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GetMealRecommendation extends StatefulWidget {
  const GetMealRecommendation({super.key});

  @override
  State<GetMealRecommendation> createState() => _GetMealRecommendationState();
}

class _GetMealRecommendationState extends State<GetMealRecommendation> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController _goalWeightController = TextEditingController();
  List<String> _activityLevel = [];
  List<String> _eatingHabits = [];
  List<String> _goals = [];
  List<String> _diseases = [];
  List<String> _allergies = [];
  var _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _isLoading.value
          ? const LoadingScreen(
              isWaitingAI: true,
            )
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Öğün Önerisi Al',
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
                        hintText: 'Hedef Kilo',
                        onChanged: (value) {
                          _goalWeightController.text = value;
                        },
                      ),

                      SizedBox(height: 20.h),
                      SelectableExpansionWrap(
                        title: 'Haraket Düzeyi',
                        options: const [
                          'Çok Aktif',
                          'Orta Aktif',
                          'Az Aktif',
                          'Haraketsiz',
                        ],
                        multiSelect: false,
                        onSelectionChanged: (values) {
                          _activityLevel = values;
                        },
                      ),
                      SizedBox(height: 20.h),
                      SelectableExpansionWrap(
                        title: 'Beslenme Alışkanlığı',
                        options: const [
                          'Vegan',
                          'Vejeteryan',
                          'Etçil',
                          'Hepçil',
                        ],
                        multiSelect: false,
                        onSelectionChanged: (values) {
                          _eatingHabits = values;
                        },
                      ),
                      SizedBox(height: 20.h),
                      SelectableExpansionWrap(
                        title: 'Amacınız',
                        options: const [
                          'Kilo Vermek',
                          'Kilo Almak',
                          'Kas Kazanmak',
                          'Kilo Korumak',
                        ],
                        multiSelect: false,
                        onSelectionChanged: (values) {
                          _goals = values;
                        },
                      ),
                      SizedBox(height: 20.h),
                      SelectableExpansionWrap(
                        title: 'Hastalıklarınız',
                        options: const [
                          'Diabet',
                          'Obesite',
                          'Kolesterol',
                          'Tansiyon',
                        ],
                        multiSelect: true,
                        onSelectionChanged: (values) {
                          _diseases = values;
                        },
                      ),
                      SizedBox(height: 20.h),
                      SelectableExpansionWrap(
                        title: 'Alerjenleriniz (Birden fazla seçebilirsiniz)',
                        options: const [
                          'Fıstık',
                          'Balık',
                          'Kereviz',
                          'Kabuklular',
                          'Mısır',
                          'Susam',
                          'Yumurta',
                          'Gluten',
                          'Laktose',
                          'Baklagil',
                        ],
                        multiSelect: true,
                        onSelectionChanged: (values) {
                          _allergies = values;
                        },
                      ),
                      SizedBox(height: 32.h),
                      AppButton(
                        onPressed: () async {
                          _isLoading.value = true;
                          await UserService()
                              .updatePersonalInfo(
                                userController.user.value.id!,
                                userController.token,
                                userController.user.value.personalInfo!.last.id!,
                                userController.user.value.personalInfo!.last.age!.toString(),
                                userController.user.value.personalInfo!.last.weight!.toString(),
                                _goalWeightController.text,
                                userController.user.value.personalInfo!.last.height!.toString(),
                                userController.user.value.personalInfo!.last.gender!.toString(),
                                _activityLevel.isNotEmpty ? _activityLevel.first : '',
                                _eatingHabits.join(','),
                                _goals.isNotEmpty ? _goals.first : '',
                                _diseases.join(','),
                                userController.user.value.personalInfo!.last.neckSize!.toString(),
                                userController.user.value.personalInfo!.last.waistSize!.toString(),
                                userController.user.value.personalInfo!.last.hipSize!.toString(),
                                userController.user.value.personalInfo!.last.chestSize!.toString(),
                                userController.user.value.personalInfo!.last.armSize!.toString(),
                                userController.user.value.personalInfo!.last.legSize!.toString(),
                              )
                              .then((value) {
                                if (value) {
                                  UserService()
                                      .getMealRecommendation(
                                        userController.user.value.id!,
                                        userController.token,
                                      )
                                      .then((value) {
                                        if (value.dailyPlans!.isNotEmpty) {
                                          userController.dailyPlanList.value = value.dailyPlans!;
                                          _isLoading.value = false;
                                          context.go('/main');
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Öğün önerisi alınamadı')),
                                          );
                                          print(value);
                                          _isLoading.value = false;
                                        }
                                      });
                                }
                              });
                        },
                        backgroundColor: AppColors.appGreen,
                        foregroundColor: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        width: 335.w,
                        height: 50.h,
                        child: Text(
                          'Öğün Önerisi Al',
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
            ),
    );
  }
}
