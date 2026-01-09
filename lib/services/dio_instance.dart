import 'package:dio/dio.dart';
import 'package:intellimeal/utils/app_urls.dart';

class DioInstance {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
    ),
  );

  static Dio get dio => _dio;
}
