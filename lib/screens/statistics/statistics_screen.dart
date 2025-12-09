import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({super.key});

  final Map<String, String> bodyMeasures = {
    'Boy(cm)': '180',
    'Kilo(kg)': '70',
    'Beden Kitle Endeksi': '22',
    'Yağ Oranı (Kg)': '1.75',
    'Yağ Oranı (%)': '%25',
    'Kas Oranı (%)': '%25',
    'Bel Çevresi (cm)': '80',
    'Bacak Çevresi (cm)': '80',
    'Kol Çevresi (cm)': '80',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İstatistikler',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.appBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.appChartBlue,
            ),
            child: Column(
              children: [
                Text(
                  'Kilo/Ay Tablosu',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Geçen Hafta',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.appBlack,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.appPurple.withOpacity(0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kaybedilen Toplam Kilo',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack,
                  ),
                ),
                Text(
                  'Kaybedilen Yağ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appBlack,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.appYellow,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    'Vücut Ölçümleri',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlack,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  itemCount: bodyMeasures.length,
                  itemBuilder: (context, index) {
                    final entry = bodyMeasures.entries.elementAt(index);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appBlack,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.appBlack,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    if (index == bodyMeasures.length - 1) {
                      return SizedBox.shrink();
                    }
                    return Divider(
                      height: 24.h,
                      color: AppColors.appWhite,
                      indent: 0,
                      endIndent: 0,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
