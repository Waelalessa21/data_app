import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTitle extends StatelessWidget {
  final bool isLogin;

  const LoginTitle({super.key, this.isLogin = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 1200;
        final isTablet = screenWidth > 600 && screenWidth <= 1200;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLogin ? 'Welcome back' : 'Create your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop
                    ? 24.0
                    : isTablet
                    ? 24.sp
                    : 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isDesktop ? 6.0 : 8.h),
            Text(
              isLogin ? 'Sign in to continue' : 'Sign up to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktop
                    ? 14.0
                    : isTablet
                    ? 14.sp
                    : 16.sp,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        );
      },
    );
  }
}
