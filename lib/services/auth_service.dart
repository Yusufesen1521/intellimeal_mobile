import 'package:dio/dio.dart';
import 'package:intellimeal/models/user_model.dart';
import 'package:intellimeal/services/dio_instance.dart';
import 'package:intellimeal/utils/app_urls.dart';

class AuthService {
  final Dio _dio = DioInstance.dio;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        AppUrls.signInUrl,
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode != 200) {
        return null;
      }
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> signUp(
    String name,
    String surname,
    String phoneNumber,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        AppUrls.signUpUrl,
        data: {
          "name": name,
          "surname": surname,
          "phoneNumber": phoneNumber,
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode != 200) {
        return null;
      }
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
