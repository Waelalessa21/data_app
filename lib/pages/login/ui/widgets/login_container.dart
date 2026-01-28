import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:data_app/core/layout/responsive_utils.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;

  const LoginContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);
        final borderRadius = isLarge ? 16.0 : 10.0;
        final borderWidth = 1.0;
        final padding = isLarge ? 36.0 : 24.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: const Color(0xFF424141),
              width: borderWidth,
            ),
          ),
          child: child,
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms, curve: Curves.easeOut, begin: 0.3)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 500.ms, delay: 200.ms);
      },
    );
  }
}
