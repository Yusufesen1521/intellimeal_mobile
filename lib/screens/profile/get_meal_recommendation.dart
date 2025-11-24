import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GetMealRecommendation extends StatefulWidget {
  const GetMealRecommendation({super.key});

  @override
  State<GetMealRecommendation> createState() => _GetMealRecommendationState();
}

class _GetMealRecommendationState extends State<GetMealRecommendation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Öğün Önerisi Al',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.appBlack,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(LucideIcons.chevronLeft),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Apptextfield(
              maxWidth: MediaQuery.of(context).size.width,
              keyboardType: TextInputType.number,
              hintText: 'Yaşınız',
              onChanged: (value) {},
            ),
            Apptextfield(
              maxWidth: MediaQuery.of(context).size.width,
              keyboardType: TextInputType.number,
              hintText: 'Yaşınız',
              onChanged: (value) {},
            ),
            Apptextfield(
              maxWidth: MediaQuery.of(context).size.width,
              keyboardType: TextInputType.number,
              hintText: 'Yaşınız',
              onChanged: (value) {},
            ),
            SizedBox(height: 20.h),
            ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppColors.appBlack),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppColors.appBlack),
              ),
              title: Text('Haraket Düzeyi'),
              trailing: Icon(LucideIcons.chevronDown),
              childrenPadding: EdgeInsets.symmetric(vertical: 10.h),
              children: [
                Wrap(
                  spacing: 10.w,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Aktif'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Orta'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Düzensiz'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Karışık'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppColors.appBlack),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppColors.appBlack),
              ),
              title: Text('Amacınız'),
              trailing: Icon(LucideIcons.chevronDown),
              childrenPadding: EdgeInsets.symmetric(vertical: 10.h),
              children: [
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Kilo Vermek'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Kilo Kaybetmek'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Kilo Koruma'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.appBlack),
                      ),
                      child: Text('Sağlık'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
