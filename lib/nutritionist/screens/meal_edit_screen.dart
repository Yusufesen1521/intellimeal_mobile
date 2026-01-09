import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/services/nutritionist_service.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Öğün Düzenleme Ekranı
/// Diyetisyen tek bir öğünü düzenleyebilir
class MealEditScreen extends StatefulWidget {
  final String patientId;
  final int day;
  final String mealType;
  final Meal meal;
  final String patientName;

  const MealEditScreen({
    super.key,
    required this.patientId,
    required this.day,
    required this.mealType,
    required this.meal,
    required this.patientName,
  });

  @override
  State<MealEditScreen> createState() => _MealEditScreenState();
}

class _MealEditScreenState extends State<MealEditScreen> {
  final Logger logger = Logger();
  late TextEditingController mealNameController;
  late TextEditingController caloriesController;
  late TextEditingController proteinController;
  late TextEditingController healthBenefitController;
  late List<TextEditingController> ingredientControllers;

  @override
  void initState() {
    super.initState();
    mealNameController = TextEditingController(text: widget.meal.mealName ?? '');
    caloriesController = TextEditingController(text: widget.meal.totalCalories?.toString() ?? '');
    proteinController = TextEditingController(text: widget.meal.totalProteinG?.toString() ?? '');
    healthBenefitController = TextEditingController(text: widget.meal.healthBenefitNote ?? '');
    ingredientControllers = (widget.meal.ingredients ?? []).map((i) => TextEditingController(text: i)).toList();
    if (ingredientControllers.isEmpty) {
      ingredientControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    mealNameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    healthBenefitController.dispose();
    for (var c in ingredientControllers) {
      c.dispose();
    }
    super.dispose();
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
        return mealType ?? 'Öğün';
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

  void _addIngredient() {
    setState(() {
      ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    if (ingredientControllers.length > 1) {
      setState(() {
        ingredientControllers[index].dispose();
        ingredientControllers.removeAt(index);
      });
    }
  }

  Meal _buildUpdatedMeal() {
    return Meal(
      mealType: widget.meal.mealType,
      mealName: mealNameController.text,
      ingredients: ingredientControllers.map((c) => c.text).where((text) => text.isNotEmpty).toList(),
      totalCalories: int.tryParse(caloriesController.text),
      totalProteinG: double.tryParse(proteinController.text),
      healthBenefitNote: healthBenefitController.text.isEmpty ? "" : healthBenefitController.text,
    );
  }

  void _saveChanges() {
    final updatedMeal = _buildUpdatedMeal();
    NutritionistService().updateMeal(widget.patientId, widget.day, widget.mealType, updatedMeal);
    Navigator.pop(context, updatedMeal);
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
          'Öğün Düzenle',
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Öğün tipi başlığı
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.appBlue.withOpacity(0.2),
                          AppColors.appBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.appBlue.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getMealIcon(widget.meal.mealType),
                            size: 24.sp,
                            color: AppColors.appBlack.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getMealTypeName(widget.meal.mealType),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appBlack,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              widget.patientName,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.appBlack.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Yemek adı
                  _buildSectionTitle('Yemek Adı'),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    controller: mealNameController,
                    hint: 'Yemek adını girin',
                    icon: LucideIcons.utensils,
                  ),
                  SizedBox(height: 20.h),
                  // Kalori ve Protein
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Kalori'),
                            SizedBox(height: 8.h),
                            _buildTextField(
                              controller: caloriesController,
                              hint: 'kcal',
                              icon: LucideIcons.flame,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Protein'),
                            SizedBox(height: 8.h),
                            _buildTextField(
                              controller: proteinController,
                              hint: 'gram',
                              icon: LucideIcons.beef,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Malzemeler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Malzemeler'),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _addIngredient,
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.appGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.plus, size: 14.sp, color: AppColors.appBlack.withOpacity(0.7)),
                                SizedBox(width: 4.w),
                                Text(
                                  'Ekle',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.appBlack.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ...ingredientControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: controller,
                              hint: 'Malzeme ${index + 1}',
                              icon: LucideIcons.leafyGreen,
                            ),
                          ),
                          if (ingredientControllers.length > 1)
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _removeIngredient(index),
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      LucideIcons.trash2,
                                      size: 18.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),
                  // Sağlık notu
                  _buildSectionTitle('Sağlık Faydası Notu'),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    controller: healthBenefitController,
                    hint: 'Bu öğünün sağlık faydalarını yazın (opsiyonel)',
                    icon: LucideIcons.heart,
                    maxLines: 3,
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
          // Kaydet butonu
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.appBlack,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.appBlack.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.appBlack.withOpacity(0.4),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.appBlack.withOpacity(0.4),
            size: 20.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.appBlack.withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.appBlack.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.appBlue,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
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
            onTap: _saveChanges,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.appBlue,
                    const Color(0xFF1565C0),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appBlue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.save,
                    size: 22.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Değişiklikleri Kaydet',
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
