import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Apptextfield extends StatefulWidget {
  final TextInputType keyboardType;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double maxWidth;
  final double maxHeight;
  final bool isPassword;
  final int? maxLength;
  final Function(String) onChanged;
  const Apptextfield({
    super.key,
    required this.keyboardType,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxWidth = 305,
    this.maxHeight = 50,
    this.isPassword = false,
    this.maxLength = 50,
    required this.onChanged,
  });

  @override
  State<Apptextfield> createState() => _ApptextfieldState();
}

class _ApptextfieldState extends State<Apptextfield> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth.w,
      height: widget.maxHeight.h,
      child: TextFormField(
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        cursorColor: AppColors.appBlack,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon!,
                  color: AppColors.appBlack,
                )
              : null,
          suffixIcon: widget.isPassword && widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    _obscureText ? LucideIcons.eyeClosed : LucideIcons.eye,
                    color: AppColors.appBlack,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : widget.suffixIcon != null
              ? Icon(
                  widget.suffixIcon!,
                  color: AppColors.appBlack,
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: AppColors.appBlack),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: AppColors.appBlack),
          ),

          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.appGray,
          ),
        ),
      ),
    );
  }
}
