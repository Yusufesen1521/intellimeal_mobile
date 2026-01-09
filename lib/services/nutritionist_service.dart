import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellimeal/models/all_users_model.dart';
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

  /// Öğün güncelleme - TODO: API endpoint gerekli
  Future<bool> updateMeal(String patientId, Map<String, dynamic> mealData) async {
    // TODO: Backend'de öğün güncelleme endpoint'i oluşturulduğunda implementasyon yapılacak
    logger.w('updateMeal API henüz implement edilmedi');
    return false;
  }
}
