import 'package:data_app/core/layout/app_layout.dart';
import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:data_app/pages/home/ui/widgets/alert_floating_point.dart';
import 'package:data_app/pages/home/ui/widgets/app_name_description.dart';
import 'package:data_app/pages/home/ui/widgets/dont_have_an_account.dart';
import 'package:data_app/pages/home/ui/widgets/mode_container.dart';
import 'package:data_app/pages/home/ui/widgets/search_field.dart';
import 'package:data_app/pages/home/ui/widgets/warning_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);
    final gap = isLarge ? 32.0 : 24.0;
    final smallGap = isLarge ? 14.0 : 10.0;
    final floatLeft = isLarge ? 32.0 : 16.0;
    final floatBottom = isLarge ? 32.0 : 16.0;

    return AppLayout(
      floatingWidget: Positioned(
        left: floatLeft,
        bottom: floatBottom,
        child: AlertFloatingPoint(),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            WarningInfo(),
            SizedBox(height: gap),
            AppNameDescription(),
            SizedBox(height: gap),
            SearchField(),
            SizedBox(height: smallGap),
            ModeContainer(),
            SizedBox(height: gap),
            DontHaveAnAccount(),
            SizedBox(height: gap),
          ],
        ),
      ),
    );
  }
}
