import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertFloatingPoint extends StatelessWidget {
  const AlertFloatingPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize;
    if (screenWidth > 1200) {
      iconSize = 4.sp;
    } else if (screenWidth > 600) {
      iconSize = 4.sp;
    } else {
      iconSize = 12.sp;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      width: 30.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.w),
      ),
      child: Center(
        child: Icon(Icons.question_mark, color: Colors.white, size: iconSize),
      ),
    );
  }
}
