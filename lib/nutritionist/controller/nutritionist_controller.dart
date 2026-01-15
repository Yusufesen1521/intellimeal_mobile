import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intellimeal/models/all_users_model.dart';
import 'package:intellimeal/models/dailyPlan_model.dart';
import 'package:intellimeal/services/nutritionist_service.dart';
import 'package:intellimeal/services/websocket_instance.dart';
import 'package:logger/logger.dart';

/// Diyetisyen için hasta yönetimi controller'ı
/// Tüm hastaları listeler, arama ve filtreleme yapar
class NutritionistController extends GetxController {
  var logger = Logger();
  final NutritionistService _nutritionistService = NutritionistService();

  // Tüm hastalar
  final allPatients = Rx<List<AllUsersModel>>([]);
  // Filtrelenmiş hastalar
  final filteredPatients = Rx<List<AllUsersModel>>([]);
  // Arama sorgusu
  final searchQuery = ''.obs;
  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPatients();
    _connectWebSocket();
  }

  /// DOCTOR olarak WebSocket bağlantısı kur
  void _connectWebSocket() {
    final storage = GetStorage();
    final doctorId = storage.read('userId') ?? '';
    if (doctorId.isNotEmpty) {
      WebSocketInstance().connect(userId: doctorId, role: 'DOCTOR');
      logger.d('DOCTOR WebSocket bağlantısı başlatıldı: doctorId=$doctorId');

      // User generated plan mesajı geldiğinde hasta listesini yenile (DOCTOR için)
      WebSocketInstance().onUserGeneratedPlan.listen((userId) {
        logger.d('WebSocket: Yeni plan mesajı alındı (userId: $userId), hasta listesi yenileniyor');
        refreshPatients();
      });
    } else {
      logger.w('DOCTOR WebSocket bağlantısı kurulamadı: userId bulunamadı');
    }
  }

  /// Tüm hastaları API'den çeker
  Future<void> fetchAllPatients() async {
    isLoading.value = true;
    try {
      final patients = await _nutritionistService.getAllUsers();
      // Sadece 'USER' rolündeki kullanıcıları filtrele (opsiyonel)
      allPatients.value = patients.where((p) => p.role == 'USER').toList();
      filteredPatients.value = allPatients.value;
      logger.d('${allPatients.value.length} hasta yüklendi');
    } catch (e) {
      logger.e('Hastalar yüklenirken hata: $e');
      allPatients.value = [];
      filteredPatients.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Hasta arama/filtreleme
  void searchPatients(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPatients.value = allPatients.value;
    } else {
      final lowercaseQuery = query.toLowerCase();
      filteredPatients.value = allPatients.value.where((patient) {
        final name = patient.name?.toLowerCase() ?? '';
        final surname = patient.surname?.toLowerCase() ?? '';
        final email = patient.email?.toLowerCase() ?? '';
        final phone = patient.phoneNumber?.toLowerCase() ?? '';
        return name.contains(lowercaseQuery) || surname.contains(lowercaseQuery) || email.contains(lowercaseQuery) || phone.contains(lowercaseQuery);
      }).toList();
    }
  }

  /// Hastaları yenile
  Future<void> refreshPatients() async {
    await fetchAllPatients();
    if (searchQuery.value.isNotEmpty) {
      searchPatients(searchQuery.value);
    }
  }

  /// Hasta günlük planlarını getir
  Future<List<DailyPlan>> getPatientDailyPlans(String patientId) async {
    try {
      final data = await _nutritionistService.getPatientDailyPlans(patientId);
      if (data != null) {
        final dailyPlanModel = DailyPlanModel.fromJson(data);
        return dailyPlanModel.dailyPlans ?? [];
      }
      return [];
    } catch (e) {
      logger.e('Hasta planları yüklenirken hata: $e');
      return [];
    }
  }

  /// Plan onaylama
  Future<bool> approvePlan(String patientId) async {
    return await _nutritionistService.checkAllDailyPlans(patientId);
  }
}
