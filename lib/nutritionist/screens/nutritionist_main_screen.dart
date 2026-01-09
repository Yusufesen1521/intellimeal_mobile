import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellimeal/models/all_users_model.dart';
import 'package:intellimeal/nutritionist/controller/nutritionist_controller.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Diyetisyen Ana Sayfası
/// Tüm hastaları listeler ve arama/filtreleme yapar
class NutritionistMainScreen extends StatefulWidget {
  const NutritionistMainScreen({super.key});

  @override
  State<NutritionistMainScreen> createState() => _NutritionistMainScreenState();
}

class _NutritionistMainScreenState extends State<NutritionistMainScreen> {
  final NutritionistController controller = Get.put(NutritionistController());
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshPatients,
          color: AppColors.appGreen,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık ve sayaç
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hastalarım',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.appBlack,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Obx(
                                () => Text(
                                  '${controller.filteredPatients.value.length} hasta',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.appBlack.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Yenile butonu
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.appPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: IconButton(
                              onPressed: controller.refreshPatients,
                              icon: Icon(
                                LucideIcons.refreshCw,
                                color: AppColors.appBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Arama kutusu
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.appBlack.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: controller.searchPatients,
                          decoration: InputDecoration(
                            hintText: 'Hasta ara...',
                            hintStyle: TextStyle(
                              color: AppColors.appBlack.withOpacity(0.4),
                              fontSize: 15.sp,
                            ),
                            prefixIcon: Icon(
                              LucideIcons.search,
                              color: AppColors.appBlack.withOpacity(0.4),
                            ),
                            suffixIcon: Obx(
                              () => controller.searchQuery.value.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        searchController.clear();
                                        controller.searchPatients('');
                                      },
                                      icon: Icon(
                                        LucideIcons.x,
                                        color: AppColors.appBlack.withOpacity(0.4),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Hasta listesi
              Obx(() {
                if (controller.isLoading.value) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.appGreen,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Hastalar yükleniyor...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.appBlack.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.filteredPatients.value.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final patient = controller.filteredPatients.value[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildPatientCard(patient),
                        );
                      },
                      childCount: controller.filteredPatients.value.length,
                    ),
                  ),
                );
              }),
              // Alt boşluk
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hasta kartı widget'ı
  Widget _buildPatientCard(AllUsersModel patient) {
    final personalInfo = patient.personalInfo?.isNotEmpty == true ? patient.personalInfo!.last : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.appBlack.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {
            // TODO: Hasta detay sayfasına git
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar ve bildirim göstergesi
                    Stack(
                      children: [
                        _buildAvatar(patient),
                        // isReceived durumuna göre bildirim göstergesi
                        if (patient.isReceived != null && patient.isReceived! > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 18.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: patient.isReceived == 1
                                    ? const Color(0xFFE53935) // Kırmızı - Onay bekliyor
                                    : const Color(0xFF4CAF50), // Yeşil - Onaylandı
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (patient.isReceived == 1 ? const Color(0xFFE53935) : const Color(0xFF4CAF50)).withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                patient.isReceived == 1
                                    ? LucideIcons
                                          .clock // Beklemede ikonu
                                    : LucideIcons.check, // Onay ikonu
                                size: 10.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 14.w),
                    // İsim ve iletişim bilgileri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${patient.name ?? ''} ${patient.surname ?? ''}'.trim(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          if (patient.email != null)
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.mail,
                                  size: 14.sp,
                                  color: AppColors.appBlack.withOpacity(0.5),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    patient.email!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.appBlack.withOpacity(0.6),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (patient.phoneNumber != null) ...[
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.phone,
                                  size: 14.sp,
                                  color: AppColors.appBlack.withOpacity(0.5),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  patient.phoneNumber!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.appBlack.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Chevron
                    Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.appBlack.withOpacity(0.3),
                    ),
                  ],
                ),
                // Kilo ve hedef bilgileri
                if (personalInfo != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.appPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoChip(
                          icon: LucideIcons.scale,
                          label: 'Kilo',
                          value: '${personalInfo.weight?.toStringAsFixed(1) ?? '-'} kg',
                          color: AppColors.appGreen,
                        ),
                        Container(
                          width: 1,
                          height: 30.h,
                          color: AppColors.appBlack.withOpacity(0.1),
                        ),
                        _buildInfoChip(
                          icon: LucideIcons.target,
                          label: 'Hedef',
                          value: '${personalInfo.targetWeight ?? '-'} kg',
                          color: AppColors.appBlue,
                        ),
                        Container(
                          width: 1,
                          height: 30.h,
                          color: AppColors.appBlack.withOpacity(0.1),
                        ),
                        _buildInfoChip(
                          icon: LucideIcons.ruler,
                          label: 'Boy',
                          value: '${personalInfo.height ?? '-'} cm',
                          color: AppColors.appYellow,
                        ),
                      ],
                    ),
                  ),
                  // Hedef bilgisi
                  if (personalInfo.goal != null) ...[
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.appLightGreen.withOpacity(0.5),
                            AppColors.appGreen.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.goal,
                            size: 16.sp,
                            color: const Color(0xFF4CAF50),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            personalInfo.goal!,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appBlack.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Avatar widget'ı
  Widget _buildAvatar(AllUsersModel patient) {
    final initials = _getInitials(patient.name, patient.surname);
    // Renk paletinden rastgele renk seç
    final colors = [
      AppColors.appPurple,
      AppColors.appGreen,
      AppColors.appBlue,
      AppColors.appYellow,
      AppColors.appLightGreen,
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

  /// İsim baş harflerini al
  String _getInitials(String? name, String? surname) {
    String initials = '';
    if (name != null && name.isNotEmpty) {
      initials += name[0].toUpperCase();
    }
    if (surname != null && surname.isNotEmpty) {
      initials += surname[0].toUpperCase();
    }
    return initials.isEmpty ? '?' : initials;
  }

  /// Bilgi çipi widget'ı
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14.sp,
            color: AppColors.appBlack.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.appBlack.withOpacity(0.5),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlack,
          ),
        ),
      ],
    );
  }

  /// Boş durum widget'ı
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.appPurple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.users,
              size: 48.sp,
              color: AppColors.appBlack.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            controller.searchQuery.value.isNotEmpty ? 'Arama sonucu bulunamadı' : 'Henüz hasta bulunmuyor',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.appBlack.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.searchQuery.value.isNotEmpty ? 'Farklı bir arama terimi deneyin' : 'Hastalar sisteme eklendiğinde burada listelenecek',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.appBlack.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
