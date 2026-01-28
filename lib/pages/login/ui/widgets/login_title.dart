import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:data_app/core/layout/responsive_utils.dart';

class LoginTitle extends StatelessWidget {
  final bool isLogin;

  const LoginTitle({super.key, this.isLogin = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);
        final titleSize = isLarge ? 36.0 : 28.0;
        final subtitleSize = isLarge ? 18.0 : 16.0;
        final gap = isLarge ? 12.0 : 8.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLogin ? 'Welcome back' : 'Create your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                .animate(key: ValueKey('title-$isLogin'))
                .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                .slideY(begin: -0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic)
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 400.ms),
            SizedBox(height: gap),
            Text(
              isLogin ? 'Sign in to continue' : 'Sign up to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subtitleSize,
                color: Colors.white70,
                height: 1.5,
              ),
            )
                .animate(key: ValueKey('subtitle-$isLogin'))
                .fadeIn(duration: 400.ms, delay: 100.ms, curve: Curves.easeOut)
                .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 100.ms, curve: Curves.easeOutCubic),
          ],
        );
      },
    );
  }
}
