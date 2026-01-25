import 'package:data_app/pages/home/ui/widgets/alert_hero_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertFloatingPoint extends StatelessWidget {
  const AlertFloatingPoint({super.key});

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AlertHeroPopup(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize;
    if (screenWidth > 1200) {
      iconSize = 4.sp;
    } else if (screenWidth > 600) {
      iconSize = 8.sp;
    } else {
      iconSize = 12.sp;
    }

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Hero(
        tag: AlertHeroPopup.heroTag,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(1.w),
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: screenWidth > 1200 ? 0.8.w : 2.w,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.question_mark,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
