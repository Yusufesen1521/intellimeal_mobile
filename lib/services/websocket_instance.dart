import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:intellimeal/services/notification_service.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:intellimeal/utils/app_urls.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';

/// WebSocket bağlantı yönetimi için singleton sınıf
/// USER ve DOCTOR rolleri için gerçek zamanlı iletişim sağlar
class WebSocketInstance {
  final logger = Logger();
  static final WebSocketInstance _instance = WebSocketInstance._internal();
  factory WebSocketInstance() => _instance;
  WebSocketInstance._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isConnected = false;

  // Mesaj dinleyicileri
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  // Approved mesajı callback stream'i (USER için)
  final _approvedController = StreamController<void>.broadcast();
  Stream<void> get onApproved => _approvedController.stream;

  // User generated plan callback stream'i (DOCTOR için)
  final _userGeneratedPlanController = StreamController<String>.broadcast();
  Stream<String> get onUserGeneratedPlan => _userGeneratedPlanController.stream;

  // Bağlantı durumu
  bool get isConnected => _isConnected;

  /// WebSocket bağlantısını başlatır
  /// [userId] - Kullanıcı ID'si
  /// [role] - Rol (USER veya DOCTOR)
  Future<bool> connect({required String userId, required String role}) async {
    try {
      // Mevcut bağlantıyı kapat
      await disconnect();

      final uri = Uri.parse('${AppUrls.webSocketUrl}?id=$userId&role=$role');
      logger.d('WebSocket bağlantısı başlatılıyor: $uri');
      _channel = WebSocketChannel.connect(uri);

      // Bağlantıyı dinle
      _subscription = _channel!.stream.listen(
        (data) {
          try {
            final message = jsonDecode(data as String) as Map<String, dynamic>;
            _handleMessage(message);
          } catch (e) {
            print('WebSocket mesaj parse hatası: $e');
          }
        },
        onError: (error) {
          print('WebSocket hatası: $error');
          _isConnected = false;
        },
        onDone: () {
          print('WebSocket bağlantısı kapandı');
          _isConnected = false;
        },
      );

      // Bağlantı onayını bekle
      final completer = Completer<bool>();
      late StreamSubscription<Map<String, dynamic>> tempSubscription;

      tempSubscription = messageStream.listen((message) {
        if (message['type'] == '200') {
          _isConnected = true;
          completer.complete(true);
          tempSubscription.cancel();
        } else if (message['type'] == 'error') {
          completer.complete(false);
          tempSubscription.cancel();
        }
      });

      // 10 saniye timeout
      return await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          tempSubscription.cancel();
          return false;
        },
      );
    } catch (e) {
      print('WebSocket bağlantı hatası: $e');
      return false;
    }
  }

  /// Mesajları işler
  void _handleMessage(Map<String, dynamic> message) {
    _messageController.add(message);

    // Approved mesajı geldiğinde bildirim göster ve stream'e sinyal gönder (USER için)
    if (message['type'] == 'approved') {
      logger.d('Onay mesajı alındı, bildirim gösteriliyor ve stream tetikleniyor');
      NotificationService().showApprovedNotification();
      _approvedController.add(null); // Stream'e sinyal gönder
    }

    // User generated plan mesajı geldiğinde bildirim göster ve stream'e sinyal gönder (DOCTOR için)
    if (message['type'] == 'user_generated_plan') {
      final userId = message['user_id'] as String? ?? '';
      logger.d('Yeni plan mesajı alındı (userId: $userId), kullanıcı bilgisi çekilip bildirim gösterilecek');
      _fetchUserAndShowNotification(userId);
      _userGeneratedPlanController.add(userId); // Stream'e userId gönder
    }
  }

  /// Kullanıcı bilgisini çekip bildirim göster
  Future<void> _fetchUserAndShowNotification(String userId) async {
    try {
      final storage = GetStorage();
      final token = storage.read('token') ?? '';

      if (token.isEmpty || userId.isEmpty) {
        logger.w('Token veya userId boş, bildirim gösterilemedi');
        NotificationService().showUserGeneratedPlanNotification(userId: userId, userName: 'Bilinmeyen Kullanıcı');
        return;
      }

      final user = await UserService().getUser(userId, token);
      final userName = '${user.name ?? ''} ${user.surname ?? ''}'.trim();

      NotificationService().showUserGeneratedPlanNotification(
        userId: userId,
        userName: userName.isNotEmpty ? userName : 'Bilinmeyen Kullanıcı',
      );
    } catch (e) {
      logger.e('Kullanıcı bilgisi çekilemedi: $e');
      NotificationService().showUserGeneratedPlanNotification(userId: userId, userName: 'Bilinmeyen Kullanıcı');
    }
  }

  /// Plan oluşturuldu mesajı gönderir (USER için)
  void sendGenerated() {
    _sendMessage({'type': 'generated'});
  }

  /// Plan onay mesajı gönderir (DOCTOR için)
  void sendApproved(String userId) {
    _sendMessage({
      'type': 'approved',
      'user_id': userId,
    });
  }

  /// Genel mesaj gönderme
  void _sendMessage(Map<String, dynamic> message) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode(message));
    } else {
      print('WebSocket bağlı değil, mesaj gönderilemedi');
    }
  }

  /// Bağlantıyı kapatır
  Future<void> disconnect() async {
    _isConnected = false;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }

  /// Singleton instance'ı dispose eder
  void dispose() {
    disconnect();
    _messageController.close();
    _approvedController.close();
    _userGeneratedPlanController.close();
  }
}
