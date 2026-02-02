import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_app/core/layout/grid_background.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final Widget? floatingWidget;
  const AppLayout({super.key, required this.child, this.floatingWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GridBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: child,
            ),
          ),
          if (floatingWidget != null) floatingWidget!,
        ],
      ),
    );
  }
}
