import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intellimeal/controllers/user_controller.dart';
import 'package:intellimeal/models/user_model.dart';
import 'package:intellimeal/utils/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({super.key});

  final UserController userController = Get.put(UserController());

  // PersonalInfo listesinden kilo listesi oluşturur
  List<double> _getWeightList() {
    final personalInfoList = userController.user.value.personalInfo;
    if (personalInfoList == null || personalInfoList.isEmpty) {
      return [];
    }
    return personalInfoList.where((info) => info.weight != null).map((info) => info.weight!).toList();
  }

  // Son PersonalInfo bilgisini alır
  PersonalInfo? _getLatestPersonalInfo() {
    final personalInfoList = userController.user.value.personalInfo;
    if (personalInfoList == null || personalInfoList.isEmpty) {
      return null;
    }
    return personalInfoList.last;
  }

  // Vücut ölçümleri haritasını oluşturur
  Map<String, String> _getBodyMeasures(PersonalInfo? info) {
    if (info == null) {
      return {
        'Boy(cm)': '-',
        'Kilo(kg)': '-',
        'Hedef Kilo(kg)': '-',
        'Boyun Çevresi (cm)': '-',
        'Bel Çevresi (cm)': '-',
        'Kalça Çevresi (cm)': '-',
        'Göğüs Çevresi (cm)': '-',
        'Kol Çevresi (cm)': '-',
        'Bacak Çevresi (cm)': '-',
      };
    }

    return {
      'Boy(cm)': info.height?.toString() ?? '-',
      'Kilo(kg)': info.weight?.toString() ?? '-',
      'Hedef Kilo(kg)': info.targetWeight?.toString() ?? '-',
      'Boyun Çevresi (cm)': info.neckSize?.toString() ?? '-',
      'Bel Çevresi (cm)': info.waistSize?.toString() ?? '-',
      'Kalça Çevresi (cm)': info.hipSize?.toString() ?? '-',
      'Göğüs Çevresi (cm)': info.chestSize?.toString() ?? '-',
      'Kol Çevresi (cm)': info.armSize?.toString() ?? '-',
      'Bacak Çevresi (cm)': info.legSize?.toString() ?? '-',
    };
  }

  // Hedefe kalan kilo mesajını hesaplar
  String _getGoalMessage(PersonalInfo? info) {
    if (info == null || info.weight == null || info.targetWeight == null) {
      return '';
    }
    final difference = (info.weight! - info.targetWeight!).abs();
    return 'Hedefe Ulaşmana Son ${difference.toStringAsFixed(1)} Kg!';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weightList = _getWeightList();
      final latestInfo = _getLatestPersonalInfo();
      final bodyMeasures = _getBodyMeasures(latestInfo);
      final goalMessage = _getGoalMessage(latestInfo);

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
            // Kilo/Gün Grafiği
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.appChartBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kilo / Ay Tablosu',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBlack,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 150.h,
                    child: weightList.isEmpty
                        ? Center(
                            child: Text(
                              'Henüz veri yok',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.appBlack.withOpacity(0.6),
                              ),
                            ),
                          )
                        : _buildWeightChart(weightList),
                  ),
                  if (goalMessage.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Divider(color: AppColors.appWhite, thickness: 1),
                    SizedBox(height: 8.h),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.appBlack,
                          ),
                          children: [
                            TextSpan(text: 'Hedefe Ulaşmana Son '),
                            TextSpan(
                              text: '${(latestInfo!.weight! - latestInfo.targetWeight!).abs().toStringAsFixed(1)} Kg!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Geçen Hafta - Olduğu gibi kalacak
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
            // Vücut Ölçümleri - PersonalInfo.last'ten dolduruluyor
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
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
    });
  }

  // Kilo grafiği widget'ı
  Widget _buildWeightChart(List<double> weights) {
    // Min ve max değerleri hesapla
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final padding = (maxWeight - minWeight) * 0.2;

    // FlSpot listesi oluştur
    final spots = weights.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList();

    return LineChart(
      LineChartData(
        minY: (minWeight - padding).clamp(0, double.infinity),
        maxY: maxWeight + padding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32.w,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.appBlack.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(
              'Kg / Ay',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.appBlack.withOpacity(0.6),
              ),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24.h,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= weights.length || value < 0) {
                  return const SizedBox.shrink();
                }
                return Text(
                  (value.toInt() + 1).toString(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.appBlack.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: const Color(0xFF2DD4BF), // Turkuaz/teal rengi
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2DD4BF).withOpacity(0.3),
                  const Color(0xFF2DD4BF).withOpacity(0.05),
                ],
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF2DD4BF),
                );
              },
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} kg',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
