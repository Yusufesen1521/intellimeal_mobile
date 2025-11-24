import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimeal/utils/app_colors.dart';
import 'package:intellimeal/utils/widgets/apptextfield.dart';
import 'package:intellimeal/utils/widgets/selectable_expansion_wrap.dart';
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
            SelectableExpansionWrap(
              title: 'Haraket Düzeyi',
              options: const ['Aktif', 'Orta', 'Düzensiz', 'Karışık'],
              multiSelect: false,
              onSelectionChanged: (values) {},
            ),
            SizedBox(height: 20.h),
            SelectableExpansionWrap(
              title: 'Amacınız',
              options: const ['Kilo Vermek', 'Kilo Kaybetmek', 'Kilo Koruma', 'Sağlık'],
              multiSelect: true,
              onSelectionChanged: (values) {},
            ),
          ],
        ),
      ),
    );
  }
}
