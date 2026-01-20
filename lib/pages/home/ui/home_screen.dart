import 'package:data_app/core/layout/app_layout.dart';
import 'package:data_app/pages/home/ui/widgets/alert_floating_point.dart';
import 'package:data_app/pages/home/ui/widgets/app_name_description.dart';
import 'package:data_app/pages/home/ui/widgets/dont_have_an_account.dart';
import 'package:data_app/pages/home/ui/widgets/search_field.dart';
import 'package:data_app/pages/home/ui/widgets/warning_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      floatingWidget: Positioned(
        left: 16.w,
        bottom: 16.h,
        child: AlertFloatingPoint(),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WarningInfo(),
            SizedBox(height: 24.h),
            AppNameDescription(),
            SizedBox(height: 24.h),
            SearchField(),
            SizedBox(height: 24.h),
            DontHaveAnAccount(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
