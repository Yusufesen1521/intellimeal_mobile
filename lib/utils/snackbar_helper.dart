import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Uygulama genelinde tutarlı snackbar gösterimi için yardımcı sınıf
/// GetX kullanmadan, BuildContext ile çalışır
class SnackbarHelper {
  /// Başarı mesajı göster (yeşil)
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: AppColors.appGreen,
      icon: LucideIcons.circleCheck,
    );
  }

  /// Hata mesajı göster (kırmızı)
  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: AppColors.appRed,
      icon: LucideIcons.circleAlert,
    );
  }

  /// Bilgi mesajı göster (mavi)
  static void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: AppColors.appBlue,
      icon: LucideIcons.info,
    );
  }

  /// Uyarı mesajı göster (sarı)
  static void showWarning(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: AppColors.appYellow,
      icon: LucideIcons.triangleAlert,
      textColor: AppColors.appBlack,
    );
  }

  /// Genel snackbar gösterici
  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Önce mevcut snackbar'ları kapat
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
