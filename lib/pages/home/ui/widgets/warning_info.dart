import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class WarningInfo extends StatelessWidget {
  const WarningInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;
        return Padding(
          padding: EdgeInsets.only(
            top: isDesktop
                ? 16.h
                : isTablet
                ? 8.h
                : 16.h,
            bottom: isDesktop
                ? 0
                : isTablet
                ? 8.h
                : 16.h,
            left: isDesktop ? 0 : 4.w,
            right: isDesktop ? 0 : 4.w,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 220.w),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? 10.w
                      : isTablet
                      ? 8.w
                      : 12.w,
                  vertical: isDesktop
                      ? 6.h
                      : isTablet
                      ? 8.h
                      : 12.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(isDesktop ? 2.sp : 8.sp),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: Colors.white,
                          size: isDesktop
                              ? 8.sp
                              : isTablet
                              ? 12.sp
                              : 14.sp,
                        ),
                        SizedBox(width: isDesktop ? 2.w : 8.w),
                        Text(
                          'Heads up!',
                          style: TextStyle(
                            fontSize: isDesktop
                                ? 4.sp
                                : isTablet
                                ? 6.sp
                                : 8.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isDesktop ? 6.h : 8.h),
                    Text(
                      'This project is still in development under SDAIA AI bootcamp. Please use with caution.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 4.sp
                            : isTablet
                            ? 8.sp
                            : 10.sp,
                        color: Colors.white,

                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
