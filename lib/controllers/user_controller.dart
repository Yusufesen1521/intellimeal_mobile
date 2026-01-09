import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/models/user_model.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:logger/logger.dart';

/// Kullanıcı verileri ve durumu için controller
/// Loading ve error state'leri ile zenginleştirilmiş
class UserController extends GetxController {
  var logger = Logger();
  String token = GetStorage().read('token') ?? '';
  String userId = GetStorage().read('userId') ?? '';

  // Kullanıcı verileri
  final user = Rx<User>(User());
  final dailyPlanList = Rx<List<DailyPlan>>([]);
  var selectedDailyPlan = Rx<DailyPlan?>(null);

  // Loading ve error state'leri
  final isLoading = false.obs;
  final isUserLoading = false.obs;
  final isDailyPlanLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Token'ları yeniden oku (controller tekrar kullanıldığında güncel olsun)
    token = GetStorage().read('token') ?? '';
    userId = GetStorage().read('userId') ?? '';
  }

  /// Kullanıcı bilgilerini getir
  Future<void> getUser() async {
    if (userId.isEmpty) {
      logger.w('UserController: userId boş, getUser atlandı');
      return;
    }

    isUserLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final userData = await UserService().getUser(userId, token);
      user.value = userData;
      logger.d('Kullanıcı yüklendi: ${userData.name}');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Kullanıcı bilgileri yüklenemedi';
      logger.e('getUser hatası: $e');
    } finally {
      isUserLoading.value = false;
      _updateOverallLoadingState();
    }
  }

  /// Günlük planları getir
  Future<void> getDailyPlan() async {
    if (userId.isEmpty) {
      logger.w('UserController: userId boş, getDailyPlan atlandı');
      return;
    }

    isDailyPlanLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final planData = await UserService().getDailyPlan(userId, token);
      dailyPlanList.value = planData.dailyPlans ?? [];
      logger.d('Günlük planlar yüklendi: ${dailyPlanList.value.length} plan');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Beslenme planı yüklenemedi';
      logger.e('getDailyPlan hatası: $e');
    } finally {
      isDailyPlanLoading.value = false;
      _updateOverallLoadingState();
    }
  }

  /// Hem kullanıcı hem de planları yükle
  Future<void> loadAllData() async {
    isLoading.value = true;
    await Future.wait([
      getUser(),
      getDailyPlan(),
    ]);
    isLoading.value = false;
  }

  /// Seçili günlük planı ayarla
  void setSelectedDailyPlan(int index) {
    if (index >= 0 && index < dailyPlanList.value.length) {
      selectedDailyPlan.value = dailyPlanList.value[index];
    }
  }

  /// Token'ları yenile (login sonrası kullanılır)
  void refreshTokens() {
    token = GetStorage().read('token') ?? '';
    userId = GetStorage().read('userId') ?? '';
  }

  /// Genel loading state'i güncelle
  void _updateOverallLoadingState() {
    isLoading.value = isUserLoading.value || isDailyPlanLoading.value;
  }

  /// Hata durumunu temizle
  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }
}
