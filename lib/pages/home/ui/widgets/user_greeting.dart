import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final displayName =
        user.displayName ?? user.email?.split('@').first ?? 'User';
    final isLarge = isLargeScreen(context);
    final fontSize = isLarge ? 28.0 : 22.0;

    return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '👋 Hi, $displayName',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(
          begin: -0.2,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
