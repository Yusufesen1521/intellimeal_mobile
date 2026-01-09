import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/screens/home/empty_screen.dart';
import 'package:intellimeal/screens/home/ingredients_screen.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDayIndex = 0;
  int selectedMealIndex = 0;

  // Öğün tipi çevirisi
  String _getMealTypeName(String? mealType) {
    switch (mealType) {
      case 'breakfast':
        return 'Kahvaltı';
      case 'lunch':
        return 'Öğle Yemeği';
      case 'dinner':
        return 'Akşam Yemeği';
      case 'snack':
        return 'Ara Öğün';
      default:
        return mealType ?? '';
    }
  }

  UserController userController = Get.put(UserController());

  String _getDayName(int? weekday) {
    switch (weekday) {
      case 1:
        return 'Pzt';
      case 2:
        return 'Sal';
      case 3:
        return 'Çar';
      case 4:
        return 'Per';
      case 5:
        return 'Cum';
      case 6:
        return 'Cts';
      case 7:
        return 'Paz';
      default:
        return '';
    }
  }

  Widget _buildNutritionBadge(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.appPurple.withValues(alpha: 0.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.appPurple),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.appBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.appGreen.withValues(alpha: 0.2),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: Color(0xFF7CB342),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.appBlack.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlack,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    userController.loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading durumu
      if (userController.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.appGreen,
              ),
              SizedBox(height: 16.h),
              Text(
                'Veriler yükleniyor...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.appBlack.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }

      // Hata durumu
      if (userController.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.circleAlert,
                size: 48.sp,
                color: AppColors.appRed,
              ),
              SizedBox(height: 16.h),
              Text(
                userController.errorMessage.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.appBlack.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              AppButton(
                onPressed: () => userController.loadAllData(),
                backgroundColor: AppColors.appGreen,
                foregroundColor: AppColors.appBlack,
                borderRadius: BorderRadius.circular(20.r),
                width: 150.w,
                height: 45.h,
                child: Text('Tekrar Dene'),
              ),
            ],
          ),
        );
      }

      // Boş durum
      if (userController.dailyPlanList.value.isEmpty) {
        return EmptyScreen();
      }

      // Normal içerik
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  return Text(
                    'Hoş geldin, \n${userController.user.value.name ?? ""}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlack,
                    ),
                  );
                }),
                IconButton(
                  onPressed: () {
                    userController.getUser();
                  },
                  icon: Icon(LucideIcons.bell),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Obx(() {
              final bool isChecked = userController.dailyPlanList.value.first.checked!;
              if (isChecked) {
                return SizedBox.shrink();
              } else {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Plan Onay"),
                              content: Text(
                                "Bu Plan Yapay Zeka Tarafından Oluşturulmuştur! Lütfen bu beslenme programını uygulamak için diyetisyeninizden onay bekleyiniz.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Tamam"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.appRed,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "Planınız Diyetisyeniniz Tarafından Onaylanmamıştır!",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appWhite,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                );
              }
            }),
            Obx(() {
              final plans = userController.dailyPlanList.value;
              if (plans.isEmpty) {
                return SizedBox.shrink();
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: plans.asMap().entries.map((entry) {
                    final index = entry.key;
                    final plan = entry.value;
                    final date = plan.date;
                    final dayName = _getDayName(date?.weekday);
                    final dayNumber = date?.day.toString().padLeft(2, '0') ?? '';
                    final isSelected = index == selectedDayIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                          selectedMealIndex = 0; // Gün değiştiğinde ilk öğünü seç
                        });
                        userController.setSelectedDailyPlan(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        margin: EdgeInsets.only(right: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: isSelected ? AppColors.appBlack : AppColors.appWhite,
                          border: Border.all(
                            color: AppColors.appBlack,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: isSelected ? AppColors.appWhite : AppColors.appBlack,
                              ),
                            ),
                            Text(
                              dayNumber,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? AppColors.appWhite : AppColors.appBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            SizedBox(height: 20.h),
            Obx(() {
              final plans = userController.dailyPlanList.value;
              if (plans.isEmpty || selectedDayIndex >= plans.length) {
                return SizedBox.shrink();
              }
              final selectedPlan = plans[selectedDayIndex];
              final mealsList = selectedPlan.meals ?? [];
              final selectedMeal = mealsList.isNotEmpty && selectedMealIndex < mealsList.length ? mealsList[selectedMealIndex] : null;

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.appWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appBlack.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Öğün çipleri
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: mealsList.asMap().entries.map((entry) {
                            final index = entry.key;
                            final meal = entry.value;
                            final isSelected = index == selectedMealIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMealIndex = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                margin: EdgeInsets.only(right: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: isSelected ? AppColors.appBlack : AppColors.appWhite,
                                  border: Border.all(
                                    color: isSelected ? AppColors.appBlack : AppColors.appBlack,
                                  ),
                                ),
                                child: Text(
                                  _getMealTypeName(meal.mealType),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    color: isSelected ? AppColors.appWhite : AppColors.appBlack,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Seçili öğünün yemeği
                      if (selectedMeal != null) ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IngredientsScreen(
                                  initialExpandedMealName: selectedMeal.mealName,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: AppColors.appPurple.withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppColors.appPurple.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12.w,
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.appPurple,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        selectedMeal.mealName ?? '',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.appBlack,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      LucideIcons.chevronRight,
                                      size: 20.sp,
                                      color: AppColors.appBlack.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    _buildNutritionBadge(
                                      '${selectedMeal.totalCalories ?? 0} kcal',
                                      LucideIcons.flame,
                                    ),
                                    SizedBox(width: 8.w),
                                    _buildNutritionBadge(
                                      '${selectedMeal.totalProteinG ?? 0}g protein',
                                      LucideIcons.beef,
                                    ),
                                  ],
                                ),
                                if (selectedMeal.healthBenefitNote != null && selectedMeal.healthBenefitNote!.isNotEmpty) ...[
                                  SizedBox(height: 12.h),
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: AppColors.appWhite,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          LucideIcons.heartPulse,
                                          size: 16.sp,
                                          color: AppColors.appPurple,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            selectedMeal.healthBenefitNote!,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.appBlack.withValues(alpha: 0.7),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: Text(
                              'Bu gün için öğün bulunmuyor',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.appBlack.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 20.h),
            Obx(() {
              final personalInfo = userController.user.value.personalInfo;
              if (personalInfo == null || personalInfo.isEmpty) {
                return SizedBox.shrink();
              }
              final info = personalInfo.last;
              final currentWeight = info.weight ?? 0.0;
              final targetWeight = info.targetWeight ?? 0.0;
              final goal = info.goal ?? '';

              // Hedefe ulaşma durumunu hesapla
              double weightDifference;
              double progress;
              bool isGoalReached;
              String statusMessage;

              // Kilo Vermek/Kaybetmek için: anlık kilo <= hedef kilo ise hedefe ulaştın
              // Kilo Almak için: anlık kilo >= hedef kilo ise hedefe ulaştın
              if (goal == 'Kilo Vermek' || goal == 'Kilo Kaybetmek') {
                weightDifference = currentWeight - targetWeight;
                isGoalReached = currentWeight <= targetWeight;
                // Progress: Başlangıçtan hedefe ne kadar yaklaştık (0-1 arası)
                // Başlangıç kilosu bilinmediği için mevcut farka göre hesaplıyoruz
                if (weightDifference <= 0) {
                  progress = 1.0;
                } else if (weightDifference > 20) {
                  progress = 0.1;
                } else {
                  progress = 1.0 - (weightDifference / 20.0).clamp(0.0, 0.9);
                }
              } else if (goal == 'Kilo Almak') {
                weightDifference = targetWeight - currentWeight;
                isGoalReached = currentWeight >= targetWeight;
                if (weightDifference <= 0) {
                  progress = 1.0;
                } else if (weightDifference > 20) {
                  progress = 0.1;
                } else {
                  progress = 1.0 - (weightDifference / 20.0).clamp(0.0, 0.9);
                }
              } else {
                // Kilo Koruma veya diğer hedefler
                weightDifference = (currentWeight - targetWeight).abs();
                isGoalReached = weightDifference <= 1.0;
                progress = isGoalReached ? 1.0 : 0.8;
              }

              // Durum mesajını belirle
              if (isGoalReached) {
                statusMessage = 'Tebrikler! Hedefe ulaştın! 🎉';
              } else if (progress >= 0.9) {
                statusMessage = 'Hedefe neredeyse ulaştın!';
              } else if (progress >= 0.7) {
                statusMessage = 'Harika gidiyorsun!';
              } else if (progress >= 0.5) {
                statusMessage = 'Yarı yoldasın, devam et!';
              } else {
                statusMessage = 'Hedefe doğru ilerliyorsun!';
              }

              // Kilo farkı için işaret
              String weightDiffText;
              if (goal == 'Kilo Vermek' || goal == 'Kilo Kaybetmek') {
                weightDiffText = weightDifference > 0 ? '-${weightDifference.toStringAsFixed(1)} Kg' : '${weightDifference.abs().toStringAsFixed(1)} Kg';
              } else if (goal == 'Kilo Almak') {
                weightDiffText = weightDifference > 0 ? '+${weightDifference.toStringAsFixed(1)} Kg' : '${weightDifference.abs().toStringAsFixed(1)} Kg';
              } else {
                weightDiffText = '${weightDifference.toStringAsFixed(1)} Kg';
              }

              return Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.appWhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appBlack.withValues(alpha: 0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Yarım daire progress göstergesi
                    SizedBox(
                      width: 160.w,
                      height: 100.h,
                      child: CustomPaint(
                        painter: _GoalProgressPainter(
                          progress: progress,
                          isGoalReached: isGoalReached,
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 55.h),
                            child: Text(
                              weightDiffText,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Durum mesajı
                    Text(
                      statusMessage,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isGoalReached ? Color(0xFF4CAF50) : Color(0xFF7CB342),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    // Kilo bilgileri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeightInfo(
                          'Mevcut',
                          '${currentWeight.toStringAsFixed(1)} kg',
                          LucideIcons.scale,
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: AppColors.appGray,
                        ),
                        _buildWeightInfo(
                          'Hedef',
                          '${targetWeight.toStringAsFixed(1)} kg',
                          LucideIcons.target,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20.h),
            AppButton(
              width: double.infinity,
              height: 50.h,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IngredientsScreen(),
                  ),
                );
              },

              backgroundColor: AppColors.appPurple,
              foregroundColor: AppColors.appBlack,
              borderRadius: BorderRadius.circular(20.r),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.tableOfContents,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Porsiyon İçerikleri',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlack,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
    });
  }
}

// Yarım daire progress göstergesi için CustomPainter
class _GoalProgressPainter extends CustomPainter {
  final double progress;
  final bool isGoalReached;

  _GoalProgressPainter({
    required this.progress,
    required this.isGoalReached,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;
    final strokeWidth = 12.0;

    // Arka plan yayı (gri)
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // Başlangıç açısı (180 derece = PI)
      3.14159, // Yay açısı (180 derece = yarım daire)
      false,
      backgroundPaint,
    );

    // İlerleme yayı (yeşil gradient)
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Gradient renk
    if (isGoalReached) {
      progressPaint.color = const Color(0xFF4CAF50); // Parlak yeşil
    } else {
      progressPaint.color = const Color(0xFF7CB342); // Açık yeşil
    }

    // İlerleme yayını çiz
    final sweepAngle = 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      sweepAngle,
      false,
      progressPaint,
    );

    // Başlangıç noktasına küçük daire ekle
    final startPoint = Offset(
      center.dx - radius,
      center.dy,
    );

    // Başlangıç noktası
    final dotPaint = Paint()
      ..color = const Color(0xFF7CB342)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(startPoint, strokeWidth / 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _GoalProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isGoalReached != isGoalReached;
  }
}
