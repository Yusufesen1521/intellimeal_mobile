import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/appbutton.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Beslenme planı olmayan kullanıcılar için boş durum ekranı
class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkon container
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.appPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  LucideIcons.utensils,
                  size: 50.sp,
                  color: AppColors.appPurple,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Başlık
            Text(
              'Henüz Beslenme Planınız Yok',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.appBlack,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Açıklama
            Text(
              'Yapay zeka destekli kişiselleştirilmiş beslenme planınızı oluşturmak için aşağıdaki butona tıklayın.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.appBlack.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // Aksiyon butonu
            AppButton(
              onPressed: () {
                context.push('/profile/get-meal-recommendation');
              },
              backgroundColor: AppColors.appGreen,
              foregroundColor: AppColors.appBlack,
              borderRadius: BorderRadius.circular(20.r),
              width: 280.w,
              height: 55.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: 20.sp,
                    color: AppColors.appBlack,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Öğün Önerisi Al',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appBlack,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Alt bilgi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.info,
                  size: 14.sp,
                  color: AppColors.appBlack.withOpacity(0.4),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Yapay zeka size özel plan hazırlayacak',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.appBlack.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
