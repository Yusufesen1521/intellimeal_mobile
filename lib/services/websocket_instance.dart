import 'dart:async';
import 'dart:convert';
import 'package:intellimeal/utils/app_urls.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket bağlantı yönetimi için singleton sınıf
/// USER ve DOCTOR rolleri için gerçek zamanlı iletişim sağlar
class WebSocketInstance {
  static final WebSocketInstance _instance = WebSocketInstance._internal();
  factory WebSocketInstance() => _instance;
  WebSocketInstance._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isConnected = false;

  // Mesaj dinleyicileri
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

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
  }
}
