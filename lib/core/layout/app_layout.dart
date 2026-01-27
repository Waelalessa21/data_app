import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:data_app/core/layout/grid_background.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final Widget? floatingWidget;
  const AppLayout({super.key, required this.child, this.floatingWidget});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 1200;
        final horizontalPadding = isDesktop ? 0.0 : 16.w;

        return Scaffold(
          body: Stack(
            children: [
              const GridBackground(),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 450.0 : double.infinity,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24.h,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
              if (floatingWidget != null) floatingWidget!,
            ],
          ),
        );
      },
    );
  }
}
