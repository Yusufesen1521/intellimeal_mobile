import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intellimeal/models/all_users_model.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Hasta İstatistik Ekranı
/// Diyetisyen için hasta istatistiklerini gösterir
class PatientStatisticsScreen extends StatefulWidget {
  final AllUsersModel patient;

  const PatientStatisticsScreen({super.key, required this.patient});

  @override
  State<PatientStatisticsScreen> createState() => _PatientStatisticsScreenState();
}

class _PatientStatisticsScreenState extends State<PatientStatisticsScreen> {
  bool showHistory = false;

  // PersonalInfo listesinden kilo listesi oluşturur
  List<double> _getWeightList() {
    final personalInfoList = widget.patient.personalInfo;
    if (personalInfoList == null || personalInfoList.isEmpty) {
      return [];
    }
    return personalInfoList.where((info) => info.weight != null).map((info) => info.weight!).toList();
  }

  // Son PersonalInfo bilgisini alır
  PersonalInfo? _getLatestPersonalInfo() {
    final personalInfoList = widget.patient.personalInfo;
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

  @override
  Widget build(BuildContext context) {
    final weightList = _getWeightList();
    final latestInfo = _getLatestPersonalInfo();
    final bodyMeasures = _getBodyMeasures(latestInfo);

    return Scaffold(
      backgroundColor: AppColors.appWhite,
      appBar: AppBar(
        backgroundColor: AppColors.appWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: AppColors.appBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.patient.name ?? ''} ${widget.patient.surname ?? ''}'.trim(),
          style: TextStyle(
            color: AppColors.appBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Text(
              'İstatistikler',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.appBlack,
              ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kilo / Ay Tablosu',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.appBlack,
                        ),
                      ),
                      // Geçmiş butonu
                      _buildHistoryButton(),
                    ],
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
                  if (latestInfo != null && latestInfo.weight != null && latestInfo.targetWeight != null) ...[
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
                            const TextSpan(text: 'Hedefe Ulaşmasına Son '),
                            TextSpan(
                              text: '${(latestInfo.weight! - latestInfo.targetWeight!).abs().toStringAsFixed(1)} Kg!',
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
            // Geçmiş veriler (açılabilir)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildHistorySection(),
              crossFadeState: showHistory ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            // Vücut Ölçümleri
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
                    physics: const NeverScrollableScrollPhysics(),
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
                        return const SizedBox.shrink();
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
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            showHistory = !showHistory;
          });
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: showHistory ? AppColors.appBlue : AppColors.appBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.history,
                size: 14.sp,
                color: showHistory ? Colors.white : AppColors.appBlack.withOpacity(0.7),
              ),
              SizedBox(width: 6.w),
              Text(
                'Geçmiş',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: showHistory ? Colors.white : AppColors.appBlack.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    final personalInfoList = widget.patient.personalInfo ?? [];
    if (personalInfoList.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.appPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text(
              'Geçmiş veri bulunamadı',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.appBlack.withOpacity(0.6),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appPurple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Icon(LucideIcons.history, size: 18.sp, color: AppColors.appBlack.withOpacity(0.7)),
                  SizedBox(width: 8.w),
                  Text(
                    'Geçmiş Kayıtlar',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appBlack,
                    ),
                  ),
                ],
              ),
            ),
            // Kayıt listesi
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              itemCount: personalInfoList.length,
              itemBuilder: (context, index) {
                // Ters sırada göster (en yeni en üstte)
                final info = personalInfoList[personalInfoList.length - 1 - index];
                final dateStr = info.date != null
                    ? '${info.date!.day.toString().padLeft(2, '0')}.${info.date!.month.toString().padLeft(2, '0')}.${info.date!.year}'
                    : 'Tarih yok';
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.appPurple.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.calendarDays,
                          size: 16.sp,
                          color: AppColors.appBlack.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateStr,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.appBlack,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Kilo: ${info.weight?.toStringAsFixed(1) ?? '-'} kg',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.appBlack.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Değişim göstergesi
                      if (index < personalInfoList.length - 1) _buildWeightChange(info, personalInfoList[personalInfoList.length - 2 - index]),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChange(PersonalInfo current, PersonalInfo previous) {
    if (current.weight == null || previous.weight == null) {
      return const SizedBox.shrink();
    }

    final diff = current.weight! - previous.weight!;
    final isLoss = diff < 0;
    final color = isLoss ? const Color(0xFF4CAF50) : const Color(0xFFE53935);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLoss ? LucideIcons.trendingDown : LucideIcons.trendingUp,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            '${diff.abs().toStringAsFixed(1)} kg',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(List<double> weights) {
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final padding = (maxWeight - minWeight) * 0.2;

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
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: const Color(0xFF2DD4BF),
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
