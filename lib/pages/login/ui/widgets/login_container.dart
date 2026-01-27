import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;

  const LoginContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;

        final borderRadius = isDesktop
            ? 10.r
            : isTablet
            ? 12.r
            : 10.r;
        final borderWidth = isDesktop
            ? 0.75.w
            : isTablet
            ? 1.2.w
            : 1.w;
        final padding = isDesktop
            ? 28.0
            : isTablet
            ? 24.w
            : 24.w;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Color(0xFF424141),
              width: borderWidth,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
