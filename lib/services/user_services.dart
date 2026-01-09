import 'package:dio/dio.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/models/user_model.dart';
import 'package:intellimeal/services/dio_instance.dart';
import 'package:intellimeal/utils/app_urls.dart';

class UserService {
  final Dio _dio = DioInstance.dio;

  Future<User> getUser(String id, String token) async {
    try {
      final response = await _dio.get(
        AppUrls.getUserUrl(id),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to get user');
      }
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DailyPlanModel> getDailyPlan(String id, String token) async {
    try {
      final response = await _dio.get(
        AppUrls.getDailyPlanUrl(id),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to get daily plan');
      }
      return DailyPlanModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DailyPlanModel> getMealRecommendation(String id, String token) async {
    try {
      final response = await _dio.post(
        AppUrls.getMealRecommendationUrl(id),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to get meal recommendation');
      }
      return DailyPlanModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createPersonalInfo(
    String id,
    String token,
    String age,
    String weight,
    String height,
    String gender,
    String neckSize,
    String waistSize,
    String hipSize,
    String chestSize,
    String armSize,
    String legSize,
  ) async {
    try {
      final response = await _dio.post(
        AppUrls.createPersonalInfoUrl(id),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'age': age,
          'weight': weight,
          'height': height,
          'gender': gender,
          'neckSize': neckSize,
          'waistSize': waistSize,
          'hipSize': hipSize,
          'chestSize': chestSize,
          'armSize': armSize,
          'legSize': legSize,
        },
      );
      if (response.statusCode != 201) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePersonalInfo(
    String id,
    String token,
    String personalInfoId,
    String age,
    String weight,
    String targetWeight,
    String height,
    String gender,
    String activityLevel,
    String dietaryPreference,
    String goal,
    String healthCondition,
    String neckSize,
    String waistSize,
    String hipSize,
    String chestSize,
    String armSize,
    String legSize,
  ) async {
    try {
      final response = await _dio.put(
        AppUrls.updatePersonalInfoUrl(id, personalInfoId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "age": age,
          "weight": weight,
          "targetWeight": targetWeight,
          "height": height,
          "gender": gender,
          "activityLevel": activityLevel,
          "dietaryPreference": dietaryPreference,
          "goal": goal,
          "healthCondition": healthCondition,
          "neckSize": neckSize,
          "waistSize": waistSize,
          "hipSize": hipSize,
          "chestSize": chestSize,
          "armSize": armSize,
          "legSize": legSize,
        },
      );
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
