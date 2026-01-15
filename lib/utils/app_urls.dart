class AppUrls {
  static const String baseUrl = 'http://64.226.81.142:8080/rest/api';
  static String webSocketUrl = 'ws://64.226.81.142:1020/ws';

  static const String signInUrl = '/auth/authenticate';
  static const String signUpUrl = '/auth/register';
  static const String verifyUrl = '/auth/verify';
  static const String chatBotUrl = 'https://diet-ai-rag.onrender.com/chat';
  static String getUserUrl(String id) => '/users/$id';
  static String updateUserUrl(String id) => '/users/$id';
  static String getAllUsersUrl() => '/users';
  static String getDailyPlanUrl(String id) => '/users/$id/daily-plans';
  static String createPersonalInfoUrl(String id) => '/users/$id/personal-info';
  static String updatePersonalInfoUrl(String id, String personalInfoId) => '/users/$id/personal-info/$personalInfoId';
  static String getMealRecommendationUrl(String id) => '/users/$id/daily-plans/generate-from-personal';

  static String updateMealUrl(String id, String dailyPlanDay, String mealType) => '/users/$id/daily-plans/$dailyPlanDay/meals/$mealType';
  static String checkAllDailyPlansUrl(String id) => '/users/$id/daily-plans/check-all';
}
