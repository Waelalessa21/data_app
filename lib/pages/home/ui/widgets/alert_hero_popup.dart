import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertHeroPopup extends StatelessWidget {
  const AlertHeroPopup({super.key});

  static const String heroTag = 'alert_floating_point_hero';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double imageSize;
    if (screenWidth > 1200) {
      imageSize = 100.w;
    } else if (screenWidth > 600) {
      imageSize = 200.w;
    } else {
      imageSize = 300.w;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Hero(
            tag: heroTag,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 16.0.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/user.png",
                          width: imageSize,
                          height: imageSize,
                        ),
                        SizedBox(height: 8.0.h),
                        Text(
                          "This project is a work in progress. It is not ready for production.",
                          style: TextStyle(
                            fontSize: screenWidth > 1200 ? 8.sp : 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.0.h),
                        Text(
                          "In here we don't access your data. We only use it to generate a response and represent results in a chat-like interface.",
                          style: TextStyle(
                            fontSize: screenWidth > 1200 ? 6.sp : 12.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
