import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderRadius borderRadius;
  final double width;
  final double height;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.width,
    required this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoading ? backgroundColor.withOpacity(0.7) : backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        fixedSize: Size(width.w, height.h),
        disabledBackgroundColor: backgroundColor.withOpacity(0.7),
      ),
      child: isLoading
          ? SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          : child,
    );
  }
}
