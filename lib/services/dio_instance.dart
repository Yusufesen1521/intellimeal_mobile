import 'package:dio/dio.dart';
import 'package:intellimeal/utils/app_urls.dart';

class DioInstance {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  static Dio get dio => _dio;
}
