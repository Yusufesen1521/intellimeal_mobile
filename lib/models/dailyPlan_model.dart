// To parse this JSON data, do
//
//     final dailyPlanModel = dailyPlanModelFromJson(jsonString);

import 'dart:convert';

DailyPlanModel dailyPlanModelFromJson(String str) => DailyPlanModel.fromJson(json.decode(str));

String dailyPlanModelToJson(DailyPlanModel data) => json.encode(data.toJson());

class DailyPlanModel {
  List<DailyPlan>? dailyPlans;

  DailyPlanModel({
    this.dailyPlans,
  });

  factory DailyPlanModel.fromJson(Map<String, dynamic> json) => DailyPlanModel(
    dailyPlans: json["daily_plans"] == null ? [] : List<DailyPlan>.from(json["daily_plans"]!.map((x) => DailyPlan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "daily_plans": dailyPlans == null ? [] : List<dynamic>.from(dailyPlans!.map((x) => x.toJson())),
  };
}

class DailyPlan {
  int? day;
  DateTime? date;
  bool? checked;
  List<Meal>? meals;
  DaySummary? daySummary;

  DailyPlan({
    this.day,
    this.date,
    this.checked,
    this.meals,
    this.daySummary,
  });

  factory DailyPlan.fromJson(Map<String, dynamic> json) => DailyPlan(
    day: json["day"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    checked: json["checked"],
    meals: json["meals"] == null ? [] : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
    daySummary: json["day_summary"] == null ? null : DaySummary.fromJson(json["day_summary"]),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "checked": checked,
    "meals": meals == null ? [] : List<dynamic>.from(meals!.map((x) => x.toJson())),
    "day_summary": daySummary?.toJson(),
  };
}

class DaySummary {
  int? totalCalories;
  double? totalProteinG;

  DaySummary({
    this.totalCalories,
    this.totalProteinG,
  });

  factory DaySummary.fromJson(Map<String, dynamic> json) => DaySummary(
    totalCalories: json["total_calories"],
    totalProteinG: json["total_protein_g"],
  );

  Map<String, dynamic> toJson() => {
    "total_calories": totalCalories,
    "total_protein_g": totalProteinG,
  };
}

class Meal {
  String? mealType;
  String? mealName;
  List<String>? ingredients;
  int? totalCalories;
  double? totalProteinG;
  String? healthBenefitNote;

  Meal({
    this.mealType,
    this.mealName,
    this.ingredients,
    this.totalCalories,
    this.totalProteinG,
    this.healthBenefitNote,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    mealType: json["meal_type"],
    mealName: json["meal_name"],
    ingredients: json["ingredients"] == null ? [] : List<String>.from(json["ingredients"]!.map((x) => x)),
    totalCalories: json["total_calories"],
    totalProteinG: json["total_protein_g"]?.toDouble(),
    healthBenefitNote: json["health_benefit_note"],
  );

  Map<String, dynamic> toJson() => {
    "meal_type": mealType,
    "meal_name": mealName,
    "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x)),
    "total_calories": totalCalories,
    "total_protein_g": totalProteinG,
    "health_benefit_note": healthBenefitNote,
  };
}
