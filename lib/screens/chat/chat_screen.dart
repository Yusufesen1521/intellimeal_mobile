import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// AI Asistan Chat Ekranı
/// HTTP tabanlı soru-cevap sistemi
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAIThinking = false;

  // Animasyon controller'ları
  late AnimationController _thinkingAnimationController;
  late Animation<double> _thinkingAnimation;

  @override
  void initState() {
    super.initState();
    _thinkingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _thinkingAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _thinkingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Hoş geldin mesajı
    _messages.add(
      ChatMessage(
        text:
            "Merhaba! 👋 Ben senin beslenme asistanınım. Sağlıklı beslenme, diyet planları, kalori hesaplama ve daha fazlası hakkında bana soru sorabilirsin!",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _thinkingAnimationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isAIThinking) return;

    // Kullanıcı mesajını ekle
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isAIThinking = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // TODO: Burada HTTP isteği atılacak
    // AI yanıtı geldiğinde _receiveAIResponse fonksiyonunu çağırın
    _simulateAIResponse();
  }

  /// AI yanıtı geldiğinde bu fonksiyonu çağırın
  void _receiveAIResponse(String response) {
    if (!mounted) return;

    setState(() {
      _isAIThinking = false;
      _messages.add(
        ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
  }

  /// Geçici simülasyon - Gerçek API entegrasyonunda bu fonksiyonu kaldırın
  void _simulateAIResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      _receiveAIResponse("Bu bir örnek yanıttır. API entegrasyonu yapıldığında gerçek yanıtlar burada görünecek.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.appGreen,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.appLightGreen,
                  AppColors.appGreen,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appGreen.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                LucideIcons.bot,
                color: AppColors.appBlack,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Beslenme Asistanı",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appBlack,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Çevrimiçi",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appBlack.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Sohbeti temizle
            _showClearChatDialog();
          },
          icon: Icon(
            LucideIcons.trash2,
            color: AppColors.appBlack.withValues(alpha: 0.7),
            size: 20.sp,
          ),
        ),
      ],
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.appWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Sohbeti Temizle",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlack,
          ),
        ),
        content: Text(
          "Tüm mesajlar silinecek. Devam etmek istiyor musunuz?",
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.appBlack.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "İptal",
              style: TextStyle(
                color: AppColors.appBlack.withValues(alpha: 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    text:
                        "Merhaba! 👋 Ben senin beslenme asistanınım. Sağlıklı beslenme, diyet planları, kalori hesaplama ve daha fazlası hakkında bana soru sorabilirsin!",
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                );
              });
            },
            child: Text(
              "Temizle",
              style: TextStyle(
                color: AppColors.appRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: _messages.length + (_isAIThinking ? 1 : 0),
      itemBuilder: (context, index) {
        // AI düşünüyor animasyonu
        if (_isAIThinking && index == _messages.length) {
          return _buildThinkingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.appLightGreen,
                    AppColors.appGreen,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.bot,
                  color: AppColors.appBlack,
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser ? AppColors.appGreen : AppColors.appWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: isUser ? Radius.circular(18.r) : Radius.circular(4.r),
                  bottomRight: isUser ? Radius.circular(4.r) : Radius.circular(18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appBlack.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appBlack,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.appBlack.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appPurple,
              ),
              child: Center(
                child: Icon(
                  LucideIcons.user,
                  color: AppColors.appBlack,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.appLightGreen,
                  AppColors.appGreen,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                LucideIcons.bot,
                color: AppColors.appBlack,
                size: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(18.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appBlack.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _thinkingAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.appGreen.withValues(alpha: _thinkingAnimation.value),
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.sparkles,
                          color: AppColors.appBlack,
                          size: 12.sp,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Düşünüyorum...",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.appBlack,
                      ),
                    ),
                    Text(
                      "Size yardımcı olmak için hazırlanıyorum",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.appBlack.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                _buildThinkingDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingDots() {
    return AnimatedBuilder(
      animation: _thinkingAnimationController,
      builder: (context, child) {
        return Row(
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_thinkingAnimationController.value + delay) % 1.0;
            final opacity = (1.0 - (value - 0.5).abs() * 2).clamp(0.3, 1.0);

            return Container(
              margin: EdgeInsets.only(left: 2.w),
              width: 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appGreen.withValues(alpha: opacity),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.appGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.appBlack.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hızlı öneriler butonu
          GestureDetector(
            onTap: _showQuickSuggestions,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appWhite,
              ),
              child: Center(
                child: Icon(
                  LucideIcons.lightbulb,
                  color: AppColors.appBlack,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Mesaj giriş alanı
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: _messageController,
                enabled: !_isAIThinking,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.appBlack,
                ),
                decoration: InputDecoration(
                  hintText: _isAIThinking ? "Yanıt bekleniyor..." : "Mesajınızı yazın...",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.appBlack.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Gönder butonu
          GestureDetector(
            onTap: _isAIThinking ? null : _sendMessage,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isAIThinking ? AppColors.appGray : AppColors.appBlack,
                boxShadow: _isAIThinking
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.appBlack.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Icon(
                  LucideIcons.send,
                  color: AppColors.appWhite,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickSuggestions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.appGray,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Hızlı Sorular",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.appBlack,
              ),
            ),
            SizedBox(height: 16.h),
            ..._quickSuggestions.map((suggestion) => _buildSuggestionItem(suggestion)).toList(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  final List<String> _quickSuggestions = [
    "Bugün kaç kalori almalıyım?",
    "Protein açısından zengin yiyecekler nelerdir?",
    "Sağlıklı bir kahvaltı önerisi",
    "Kilo vermek için tavsiyeler",
    "Akşam yemeği için hafif tarif öner",
  ];

  Widget _buildSuggestionItem(String suggestion) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _messageController.text = suggestion;
        _sendMessage();
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.appLightGreen.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.appGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.messageCircle,
              color: AppColors.appBlack.withValues(alpha: 0.6),
              size: 18.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                suggestion,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appBlack,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.appBlack.withValues(alpha: 0.4),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}

/// Chat mesaj modeli
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
