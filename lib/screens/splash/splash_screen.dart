import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/services/user_services.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'dart:ui';

/// Uygulama açılış ekranı
/// Kayıtlı kullanıcı kontrolü yapar ve uygun sayfaya yönlendirir
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuthAndNavigate();
  }

  void _setupAnimations() {
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
  }

  /// Oturum durumunu kontrol et ve uygun sayfaya yönlendir
  Future<void> _checkAuthAndNavigate() async {
    // Minimum splash süresi (animasyonun görünmesi için)
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final storage = GetStorage();
    final String? token = storage.read('token');
    final String? userId = storage.read('userId');

    // Token veya userId yoksa giriş ekranına yönlendir
    if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
      if (mounted) {
        context.go('/');
      }
      return;
    }

    // Token var, kullanıcı bilgilerini çekmeye çalış
    try {
      final userService = UserService();
      final user = await userService.getUser(userId, token);

      if (!mounted) return;

      // Kullanıcı rolüne göre yönlendir
      if (user.role == 'DOCTOR') {
        context.go('/nutritionist/main');
      } else {
        context.go('/main');
      }
    } catch (e) {
      // Hata durumunda (token geçersiz olabilir), giriş ekranına yönlendir
      if (mounted) {
        // Token'ları temizle
        storage.remove('token');
        storage.remove('userId');
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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

          // Dekoratif daireler
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
                // Animasyonlu logo
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
                          child: Image.asset(
                            'assets/intellimeal_logo.png',
                            width: 80.w,
                            height: 80.h,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.restaurant_menu_rounded,
                                size: 50.sp,
                                color: AppColors.appBlack,
                              );
                            },
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

                // Slogan
                Text(
                  'Akıllı Beslenme Asistanınız',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appBlack.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: 50.h),

                // Loading göstergesi
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
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
                              painter: _ArcPainter(
                                color: AppColors.appBlack,
                                strokeWidth: 3.w,
                              ),
                            ),
                          ),
                        ),
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

                Text(
                  'Yükleniyor...',
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
class _ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _ArcPainter({required this.color, required this.strokeWidth});

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
