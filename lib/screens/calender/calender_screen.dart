import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final UserController userController = Get.find<UserController>();
  int? selectedDayIndex; // Seçili gün indeksi

  // Mavi renk paleti
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF1565C0);

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

  // Gün adını döndür
  String _getDayName(int? weekday) {
    switch (weekday) {
      case 1:
        return 'Pazartesi';
      case 2:
        return 'Salı';
      case 3:
        return 'Çarşamba';
      case 4:
        return 'Perşembe';
      case 5:
        return 'Cuma';
      case 6:
        return 'Cumartesi';
      case 7:
        return 'Pazar';
      default:
        return '';
    }
  }

  // Kısa gün adı
  String _getShortDayName(int? weekday) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            'Takvim',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.appBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Geçmiş beslenme planınız',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.appBlack.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 24.h),
          // Günlerin listesi
          Obx(() {
            final plans = userController.dailyPlanList.value;
            if (plans.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.h),
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.calendarDays,
                        size: 64.sp,
                        color: AppColors.appBlack.withValues(alpha: 0.2),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Henüz beslenme planı bulunmuyor',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.appBlack.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: plans.asMap().entries.map((entry) {
                final index = entry.key;
                final plan = entry.value;
                final date = plan.date;
                final dayName = _getDayName(date?.weekday);
                final shortDayName = _getShortDayName(date?.weekday);
                final dayNumber = date?.day.toString().padLeft(2, '0') ?? '';
                final isSelected = index == selectedDayIndex;
                final mealsList = plan.meals ?? [];
                final totalCalories = mealsList.fold<int>(0, (sum, meal) => sum + (meal.totalCalories ?? 0));

                return Column(
                  children: [
                    // Gün kartı
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedDayIndex == index) {
                            selectedDayIndex = null; // Kapama
                          } else {
                            selectedDayIndex = index;
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: isSelected ? lightBlue : AppColors.appWhite,
                          border: Border.all(
                            color: isSelected ? primaryBlue : AppColors.appBlack.withValues(alpha: 0.1),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.appBlack.withValues(alpha: 0.05),
                              blurRadius: 8.r,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Tarih göstergesi
                            Container(
                              width: 56.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: isSelected ? primaryBlue : darkBlue,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    shortDayName,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.appWhite,
                                    ),
                                  ),
                                  Text(
                                    dayNumber,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.appWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            // Gün bilgileri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.appBlack,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${mealsList.length} öğün • $totalCalories kcal',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.appBlack.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Açılır/kapanır ikon
                            AnimatedRotation(
                              turns: isSelected ? 0.5 : 0,
                              duration: Duration(milliseconds: 200),
                              child: Icon(
                                LucideIcons.chevronDown,
                                size: 24.sp,
                                color: isSelected ? primaryBlue : AppColors.appBlack.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Yemek listesi (genişletilebilir)
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: _buildMealsSection(mealsList),
                      crossFadeState: isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                    SizedBox(height: 12.h),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  // Yemekler bölümü - liste olarak alt alta
  Widget _buildMealsSection(List mealsList) {
    if (mealsList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.only(top: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.appWhite,
          border: Border.all(
            color: AppColors.appBlack.withValues(alpha: 0.05),
          ),
        ),
        child: Center(
          child: Text(
            'Bu gün için öğün bulunmuyor',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.appBlack.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    // Öğünleri grupla (breakfast, lunch, dinner, snack)
    Map<String, List> groupedMeals = {};
    for (var meal in mealsList) {
      String type = meal.mealType ?? 'other';
      if (!groupedMeals.containsKey(type)) {
        groupedMeals[type] = [];
      }
      groupedMeals[type]!.add(meal);
    }

    // Sıralama için öğün tipleri
    List<String> mealOrder = ['breakfast', 'lunch', 'dinner', 'snack'];

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.appWhite,
        border: Border.all(
          color: primaryBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: mealOrder.where((type) => groupedMeals.containsKey(type)).map((type) {
          final meals = groupedMeals[type]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Öğün tipi başlığı
              Row(
                children: [
                  Icon(
                    _getMealIcon(type),
                    size: 18.sp,
                    color: primaryBlue,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _getMealTypeName(type),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Yemek isimleri
              ...meals.map(
                (meal) => Padding(
                  padding: EdgeInsets.only(left: 26.w, bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 6.h),
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBlue.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.mealName ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appBlack,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${meal.totalCalories ?? 0} kcal • ${meal.totalProteinG ?? 0}g protein',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.appBlack.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Öğün tipi ikonu
  IconData _getMealIcon(String? mealType) {
    switch (mealType) {
      case 'breakfast':
        return LucideIcons.coffee;
      case 'lunch':
        return LucideIcons.utensils;
      case 'dinner':
        return LucideIcons.chefHat;
      case 'snack':
        return LucideIcons.apple;
      default:
        return LucideIcons.utensils;
    }
  }
}
