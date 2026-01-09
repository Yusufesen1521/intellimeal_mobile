import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class IngredientsScreen extends StatefulWidget {
  final String? initialExpandedMealName;

  const IngredientsScreen({
    super.key,
    this.initialExpandedMealName,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final UserController userController = Get.find<UserController>();
  Set<String> expandedMeals = {};

  @override
  void initState() {
    super.initState();
    // Eğer başlangıçta açılması gereken bir yemek varsa ekle
    if (widget.initialExpandedMealName != null) {
      expandedMeals.add(widget.initialExpandedMealName!);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        backgroundColor: AppColors.appWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(LucideIcons.arrowLeft, color: AppColors.appBlack),
        ),
        title: Text(
          'Porsiyon İçerikleri',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final plans = userController.dailyPlanList.value;
        if (plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.utensils,
                  size: 64.sp,
                  color: AppColors.appBlack.withValues(alpha: 0.2),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Henüz yemek planı bulunmuyor',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.appBlack.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }

        // Tüm günlerin tüm yemeklerini topla
        List<Meal> allMeals = [];
        for (var plan in plans) {
          if (plan.meals != null) {
            allMeals.addAll(plan.meals!);
          }
        }

        // Benzersiz yemekleri al (aynı isimli yemekler tekrar etmesin)
        Map<String, Meal> uniqueMeals = {};
        for (var meal in allMeals) {
          if (meal.mealName != null) {
            uniqueMeals[meal.mealName!] = meal;
          }
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: uniqueMeals.length,
          itemBuilder: (context, index) {
            final meal = uniqueMeals.values.elementAt(index);
            final isExpanded = expandedMeals.contains(meal.mealName);

            return _buildMealCard(meal, isExpanded);
          },
        );
      }),
    );
  }

  Widget _buildMealCard(Meal meal, bool isExpanded) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.appWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.appBlack.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Başlık kısmı (tıklanabilir)
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedMeals.remove(meal.mealName);
                } else {
                  expandedMeals.add(meal.mealName!);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: isExpanded ? BorderRadius.vertical(top: Radius.circular(16.r)) : BorderRadius.circular(16.r),
                color: isExpanded ? AppColors.appPurple.withValues(alpha: 0.1) : AppColors.appWhite,
              ),
              child: Row(
                children: [
                  // Yemek tipi ikonu
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.appPurple.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      _getMealIcon(meal.mealType),
                      size: 22.sp,
                      color: AppColors.appPurple,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Yemek bilgileri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getMealTypeName(meal.mealType),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appPurple,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          meal.mealName ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appBlack,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Kalori badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.appPurple.withValues(alpha: 0.15),
                    ),
                    child: Text(
                      '${meal.totalCalories ?? 0} kcal',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appPurple,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Açılır/kapanır ikon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      LucideIcons.chevronDown,
                      size: 20.sp,
                      color: AppColors.appBlack.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // İçerik kısmı (expandable)
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: _buildExpandedContent(meal),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Meal meal) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.appPurple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.appPurple.withValues(alpha: 0.2)),
          SizedBox(height: 8.h),
          // Besin değerleri
          Row(
            children: [
              _buildNutrientInfo(
                'Kalori',
                '${meal.totalCalories ?? 0}',
                'kcal',
                LucideIcons.flame,
              ),
              SizedBox(width: 16.w),
              _buildNutrientInfo(
                'Protein',
                '${meal.totalProteinG ?? 0}',
                'g',
                LucideIcons.beef,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // İçindekiler başlığı
          Row(
            children: [
              Icon(
                LucideIcons.chefHat,
                size: 16.sp,
                color: AppColors.appPurple,
              ),
              SizedBox(width: 8.w),
              Text(
                'İçindekiler',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // İçerik listesi
          if (meal.ingredients != null) ...meal.ingredients!.map((ingredient) => _buildIngredientItem(ingredient)),
          // Sağlık notu
          if (meal.healthBenefitNote != null && meal.healthBenefitNote!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.green.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.heartPulse,
                    size: 18.sp,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sağlık Faydası',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          meal.healthBenefitNote!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appBlack.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.appWhite,
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appPurple.withValues(alpha: 0.15),
              ),
              child: Icon(icon, size: 18.sp, color: AppColors.appPurple),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appBlack.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  '$value $unit',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appBlack,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.appPurple,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              ingredient,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.appBlack.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
