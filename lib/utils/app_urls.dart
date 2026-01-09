class AppUrls {
  static const String baseUrl = 'http://192.168.1.102:8080/rest/api';
  static const String signInUrl = '/auth/authenticate';
  static const String signUpUrl = '/auth/register';
  static String getUserUrl(String id) => '/users/$id';
}
