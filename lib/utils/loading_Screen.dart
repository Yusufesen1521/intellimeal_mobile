import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/utils/app_colors.dart';

/// Modern ve şık loading ekranı
/// Blurlu arka plan ve gradyan efektleri ile zenginleştirilmiş
class LoadingScreen extends StatefulWidget {
  final bool isWaitingAI;

  const LoadingScreen({super.key, this.isWaitingAI = false});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  // AI bekleme mesajları için
  late AnimationController _textAnimationController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  Timer? _textChangeTimer;
  int _currentTextIndex = 0;

  final List<String> _aiWaitingTexts = [
    'Yapay zeka beslenme planınızı oluşturuyor...',
    'Besin değerleri analiz ediliyor...',
    'Kişisel ihtiyaçlarınız hesaplanıyor...',
    'Size özel tarifler hazırlanıyor...',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    // Text animasyonu için controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // AI bekleme modundaysa text değişim timer'ını başlat
    if (widget.isWaitingAI) {
      _textAnimationController.forward();
      _startTextChangeTimer();
    }
  }

  void _startTextChangeTimer() {
    _textChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _changeText();
    });
  }

  void _changeText() async {
    // Fade out
    await _textAnimationController.reverse();

    if (mounted) {
      setState(() {
        _currentTextIndex = (_currentTextIndex + 1) % _aiWaitingTexts.length;
      });

      // Fade in with slide
      _textAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationController.dispose();
    _textChangeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradyan arka plan
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.appPurple,
                  AppColors.appLightBlue,
                  AppColors.appYellow.withOpacity(0.6),
                  AppColors.appLightGreen.withOpacity(0.5),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Dekoratif daireler (blur edilecek)
          Positioned(
            top: -80.h,
            left: -60.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appPurple.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: 200.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appBlue.withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            bottom: -100.h,
            left: -50.w,
            child: Container(
              width: 280.w,
              height: 280.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appGreen.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 150.h,
            right: -80.w,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.appYellow.withOpacity(0.5),
              ),
            ),
          ),

          // Blur efekti
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(
              color: Colors.transparent,
            ),
          ),

          // İçerik
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animasyonlu logo/icon alanı
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.appWhite.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.appPurple.withOpacity(0.3),
                              blurRadius: 30.r,
                              spreadRadius: 10.r,
                            ),
                            BoxShadow(
                              color: AppColors.appBlue.withOpacity(0.2),
                              blurRadius: 50.r,
                              spreadRadius: 20.r,
                            ),
                          ],
                        ),
                        child: Center(
                          child: widget.isWaitingAI
                              ? Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 50.sp,
                                  color: AppColors.appBlack,
                                )
                              : Icon(
                                  Icons.restaurant_menu_rounded,
                                  size: 50.sp,
                                  color: AppColors.appBlack,
                                ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40.h),

                // Uygulama adı
                Text(
                  'IntelliMeal',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBlack,
                    letterSpacing: 1.5,
                  ),
                ),

                SizedBox(height: 8.h),

                // Slogan veya AI bekleme mesajı
                SizedBox(
                  height: 50.h,
                  child: widget.isWaitingAI
                      ? AnimatedBuilder(
                          animation: _textAnimationController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _textSlideAnimation,
                              child: FadeTransition(
                                opacity: _textFadeAnimation,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.appWhite.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    _aiWaitingTexts[_currentTextIndex],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.appBlack.withOpacity(0.8),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Text(
                          'Akıllı Beslenme Asistanınız',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appBlack.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                ),

                SizedBox(height: 50.h),

                // Modern loading göstergesi
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dış halka
                        Transform.rotate(
                          angle: _rotationAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.appGray.withOpacity(0.3),
                                width: 3.w,
                              ),
                            ),
                            child: CustomPaint(
                              painter: ArcPainter(
                                color: AppColors.appBlack,
                                strokeWidth: 3.w,
                              ),
                            ),
                          ),
                        ),
                        // İç nokta
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.appBlack,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // Yükleniyor yazısı
                Text(
                  widget.isWaitingAI ? 'Lütfen bekleyin...' : 'Yükleniyor...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Arc çizen custom painter
class ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  ArcPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, -0.5, 2.0, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
