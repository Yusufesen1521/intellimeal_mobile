class AppUrls {
  static const String baseUrl = 'http://192.168.1.102:8080/rest/api';

  static const String signInUrl = '/auth/authenticate';
  static const String signUpUrl = '/auth/register';
  static String getUserUrl(String id) => '/users/$id';
  static String getDailyPlanUrl(String id) => '/users/$id/daily-plans';
  static String createPersonalInfoUrl(String id) => '/users/$id/personal-info';
  static String updatePersonalInfoUrl(String id, String personalInfoId) => '/users/$id/personal-info/$personalInfoId';
  static String getMealRecommendationUrl(String id) => '/users/$id/daily-plans/generate-from-personal';
}
