import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppNameDescription extends StatelessWidget {
  const AppNameDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 220.w : double.infinity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chat with your SQL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 14.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isDesktop ? 8.h : 8.h),
                Text(
                  'An AI-powered system that enables non-technical users to query relational databases using natural language by automatically generating, validating, and executing SQL queries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 4.sp
                        : isTablet
                        ? 8.sp
                        : 12.sp,
                    color: Colors.white,
                    height: 1.6.h,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
