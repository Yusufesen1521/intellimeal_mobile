import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellimeal/models/all_users_model.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/services/dio_instance.dart';
import 'package:intellimeal/utils/app_urls.dart';
import 'package:logger/logger.dart';

class NutritionistService {
  final Logger logger = Logger();
  final String token = GetStorage().read('token');
  final Dio _dio = DioInstance.dio;

  Future<List<AllUsersModel>> getAllUsers() async {
    try {
      final response = await _dio.get(
        AppUrls.getAllUsersUrl(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        logger.e('Hastalar yüklenirken hata: ${response.statusCode}');
        return [];
      }
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((e) => AllUsersModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      logger.e('Hastalar yüklenirken hata: $e');
      return [];
    }
  }

  /// Hasta günlük planlarını getir
  Future<Map<String, dynamic>?> getPatientDailyPlans(String patientId) async {
    try {
      final response = await _dio.get(
        AppUrls.getDailyPlanUrl(patientId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        logger.e('Hasta planları yüklenirken hata: ${response.statusCode}');
        return null;
      }
      return response.data as Map<String, dynamic>;
    } catch (e) {
      logger.e('Hasta planları yüklenirken hata: $e');
      return null;
    }
  }

  /// Plan onaylama - TODO: API endpoint gerekli
  Future<bool> approvePlan(String patientId) async {
    // TODO: Backend'de plan onaylama endpoint'i oluşturulduğunda implementasyon yapılacak
    logger.w('approvePlan API henüz implement edilmedi');
    return false;
  }

  /// Öğün güncelleme
  Future<bool> updateMeal(String patientId, int day, String mealType, Meal meal) async {
    try {
      final response = await _dio.put(
        AppUrls.updateMealUrl(patientId, day.toString(), mealType),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "meal_type": mealType,
          "meal_name": meal.mealName,
          "ingredients": meal.ingredients,
          "total_calories": meal.totalCalories,
          "total_protein_g": meal.totalProteinG,
          "health_benefit_note": meal.healthBenefitNote ?? "",
        },
      );
      if (response.statusCode != 200) {
        logger.e('Öğün güncellenirken hata: ${response.statusCode}');
        return false;
      }
      return true;
    } catch (e) {
      logger.e('Öğün güncellenirken hata: $e');
      return false;
    }
  }
}
