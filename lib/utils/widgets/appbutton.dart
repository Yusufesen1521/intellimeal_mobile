import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderRadius borderRadius;
  final double width;
  final double height;
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        fixedSize: Size(width.w, height.h),
      ),
      child: child,
    );
  }
}
