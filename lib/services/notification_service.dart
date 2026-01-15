import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

/// Yerel bildirim yönetimi için singleton servis
/// Uygulama içi bildirimleri yönetir
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final logger = Logger();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Bildirim servisini başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android ayarları
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS ayarları
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    logger.d('NotificationService başlatıldı');
  }

  /// Bildirim tıklandığında
  void _onNotificationTapped(NotificationResponse response) {
    logger.d('Bildirim tıklandı: ${response.payload}');
    // İleride bildirime tıklanınca yapılacak işlemler buraya eklenebilir
  }

  /// Onay bildirimi göster (Plan onaylandığında)
  Future<void> showApprovedNotification() async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'plan_approval_channel',
      'Plan Onayları',
      channelDescription: 'Beslenme planı onay bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1, // Notification ID
      'Planınız Onaylandı! 🎉',
      'Beslenme planınız diyetisyen tarafından onaylandı. Hemen görüntülemek için tıklayın.',
      notificationDetails,
      payload: 'approved',
    );

    logger.d('Onay bildirimi gösterildi');
  }

  /// Yeni plan oluşturuldu bildirimi göster (DOCTOR için)
  /// Bir kullanıcı yeni plan oluşturduğunda doktora bildirim gider
  Future<void> showUserGeneratedPlanNotification({
    required String userId,
    required String userName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'doctor_notification_channel',
      'Doktor Bildirimleri',
      channelDescription: 'Doktor için kullanıcı plan bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2, // Notification ID
      'Yeni Plan Onayı Bekliyor 📋',
      '$userName yeni beslenme planı oluşturdu. Onayınızı bekliyor.',
      notificationDetails,
      payload: 'user_generated_plan:$userId',
    );

    logger.d('Yeni plan bildirimi gösterildi (userId: $userId, userName: $userName)');
  }

  /// Genel bildirim göster
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'Genel Bildirimler',
      channelDescription: 'Uygulama bildirimleri',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, notificationDetails, payload: payload);
  }
}
