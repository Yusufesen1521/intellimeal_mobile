import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellimeal/models/all_users_model.dart';
import 'package:intellimeal/nutritionist/screens/patient_statistics_screen.dart';
import 'package:intellimeal/nutritionist/screens/patient_plan_screen.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Hasta seçenekleri dialog'u
/// Hasta kartına tıklandığında açılır ve İstatistikler veya Plan seçenekleri sunar
class PatientOptionsDialog extends StatelessWidget {
  final AllUsersModel patient;

  const PatientOptionsDialog({super.key, required this.patient});

  /// Dialog'u göster
  static void show(BuildContext context, AllUsersModel patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PatientOptionsDialog(patient: patient),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = patient.personalInfo?.isNotEmpty == true ? patient.personalInfo!.last : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Çekme göstergesi
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.appBlack.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              // Hasta bilgisi
              Row(
                children: [
                  // Avatar
                  _buildAvatar(),
                  SizedBox(width: 14.w),
                  // İsim ve bilgiler
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${patient.name ?? ''} ${patient.surname ?? ''}'.trim(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appBlack,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        if (personalInfo != null)
                          Text(
                            '${personalInfo.weight?.toStringAsFixed(1) ?? '-'} kg • ${personalInfo.height ?? '-'} cm',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.appBlack.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Durum göstergesi
                  if (patient.isReceived != null && patient.isReceived! > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: patient.isReceived == 1 ? const Color(0xFFE53935).withOpacity(0.1) : const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            patient.isReceived == 1 ? LucideIcons.clock : LucideIcons.check,
                            size: 14.sp,
                            color: patient.isReceived == 1 ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            patient.isReceived == 1 ? 'Onay Bekliyor' : 'Onaylandı',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: patient.isReceived == 1 ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24.h),
              // Seçenekler
              Row(
                children: [
                  // İstatistikler butonu
                  Expanded(
                    child: _buildOptionButton(
                      icon: LucideIcons.chartLine,
                      label: 'İstatistikler',
                      color: AppColors.appBlue,
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => PatientStatisticsScreen(patient: patient));
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Plan butonu
                  Expanded(
                    child: _buildOptionButton(
                      icon: LucideIcons.calendarDays,
                      label: 'Plan',
                      color: AppColors.appGreen,
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => PatientPlanScreen(patient: patient));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    String initials = '';
    if (patient.name != null && patient.name!.isNotEmpty) {
      initials += patient.name![0].toUpperCase();
    }
    if (patient.surname != null && patient.surname!.isNotEmpty) {
      initials += patient.surname![0].toUpperCase();
    }
    if (initials.isEmpty) initials = '?';

    final colors = [
      AppColors.appPurple,
      AppColors.appGreen,
      AppColors.appBlue,
      AppColors.appYellow,
    ];
    final colorIndex = (patient.name?.length ?? 0) % colors.length;

    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: colors[colorIndex],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.appBlack.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28.sp,
                  color: AppColors.appBlack.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
