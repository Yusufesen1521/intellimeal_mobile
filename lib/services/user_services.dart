import 'package:dio/dio.dart';
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
}
