import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellimeal/models/all_users_model.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/nutritionist/controller/nutritionist_controller.dart';
import 'package:intellimeal/nutritionist/screens/meal_edit_screen.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Hasta Plan Ekranı
/// AI tarafından oluşturulan beslenme planlarını gösterir ve düzenleme imkanı sağlar
class PatientPlanScreen extends StatefulWidget {
  final AllUsersModel patient;

  const PatientPlanScreen({super.key, required this.patient});

  @override
  State<PatientPlanScreen> createState() => _PatientPlanScreenState();
}

class _PatientPlanScreenState extends State<PatientPlanScreen> {
  final NutritionistController controller = Get.find<NutritionistController>();
  int? selectedDayIndex;
  bool isLoading = true;
  List<DailyPlan> dailyPlans = [];

  // Mavi renk paleti
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();
    _loadPatientPlans();
  }

  Future<void> _loadPatientPlans() async {
    setState(() => isLoading = true);
    try {
      final plans = await controller.getPatientDailyPlans(widget.patient.id ?? '');
      setState(() {
        dailyPlans = plans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        dailyPlans = [];
        isLoading = false;
      });
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
          icon: Icon(LucideIcons.arrowLeft, color: AppColors.appBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.patient.name ?? ''} ${widget.patient.surname ?? ''}'.trim(),
          style: TextStyle(
            color: AppColors.appBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? _buildLoading()
                : dailyPlans.isEmpty
                ? _buildEmptyState()
                : _buildPlanList(),
          ),
          // Onayla butonu
          if (!isLoading && dailyPlans.isNotEmpty) _buildApproveButton(),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.appGreen),
          SizedBox(height: 16.h),
          Text(
            'Planlar yükleniyor...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.appBlack.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.calendarX,
              size: 64.sp,
              color: AppColors.appBlack.withOpacity(0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'Henüz beslenme planı bulunmuyor',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.appBlack.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'AI tarafından plan oluşturulduğunda burada görüntülenecek',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.appBlack.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanList() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            'Beslenme Planı',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.appBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'AI tarafından oluşturulan plan',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.appBlack.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 24.h),
          // Plan listesi
          ...dailyPlans.asMap().entries.map((entry) {
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedDayIndex == index) {
                        selectedDayIndex = null;
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
                        color: isSelected ? primaryBlue : AppColors.appBlack.withOpacity(0.1),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.appBlack.withOpacity(0.05),
                          blurRadius: 8.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
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
                                  color: AppColors.appBlack.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: isSelected ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            LucideIcons.chevronDown,
                            size: 24.sp,
                            color: isSelected ? primaryBlue : AppColors.appBlack.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildMealsSection(mealsList, index),
                  crossFadeState: isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                SizedBox(height: 12.h),
              ],
            );
          }),
          SizedBox(height: 80.h), // Onayla butonu için boşluk
        ],
      ),
    );
  }

  Widget _buildMealsSection(List<Meal> mealsList, int dayIndex) {
    if (mealsList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.only(top: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.appWhite,
          border: Border.all(
            color: AppColors.appBlack.withOpacity(0.05),
          ),
        ),
        child: Center(
          child: Text(
            'Bu gün için öğün bulunmuyor',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.appBlack.withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    Map<String, List<Meal>> groupedMeals = {};
    for (var meal in mealsList) {
      String type = meal.mealType ?? 'other';
      if (!groupedMeals.containsKey(type)) {
        groupedMeals[type] = [];
      }
      groupedMeals[type]!.add(meal);
    }

    List<String> mealOrder = ['breakfast', 'lunch', 'dinner', 'snack'];

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.appWhite,
        border: Border.all(
          color: primaryBlue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: mealOrder.where((type) => groupedMeals.containsKey(type)).map((type) {
          final meals = groupedMeals[type]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ...meals.asMap().entries.map((entry) {
                final mealIndex = mealsList.indexOf(entry.value);
                final meal = entry.value;
                return Padding(
                  padding: EdgeInsets.only(left: 26.w, bottom: 8.h),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 2.h),
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBlue.withOpacity(0.5),
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
                                color: AppColors.appBlack.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Düzenle butonu
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealEditScreen(
                                  meal: meal,
                                  patientName: '${widget.patient.name ?? ''} ${widget.patient.surname ?? ''}'.trim(),
                                  patientId: widget.patient.id!,
                                  day: dailyPlans[dayIndex].day ?? (dayIndex + 1),
                                  mealType: meal.mealType!,
                                ),
                              ),
                            );
                            if (result != null && result is Meal) {
                              setState(() {
                                dailyPlans[dayIndex].meals![mealIndex] = result;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Öğün düzenlendi'),
                                  backgroundColor: AppColors.appGreen.withOpacity(0.9),
                                  margin: EdgeInsets.all(16.w),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.appPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              LucideIcons.pencil,
                              size: 16.sp,
                              color: AppColors.appBlack.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 12.h),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildApproveButton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.appBlack.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Plan onaylama API'si eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Plan onaylama özelliği yakında eklenecek'),
                  backgroundColor: AppColors.appBlue.withOpacity(0.9),
                  margin: EdgeInsets.all(16.w),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4CAF50),
                    const Color(0xFF2E7D32),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.circleCheck,
                    size: 22.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Planı Onayla',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
