import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/routing/routes.dart';

class DontHaveAnAccount extends StatelessWidget {
  const DontHaveAnAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = AuthService.instance.currentUser != null;

    if (isAuthenticated) {
      return InkWell(
            onTap: () => AuthService.instance.signOut(),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Signed in as ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: AuthService.instance.currentUser?.email ?? '',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: ' · ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: 'Sign out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 600.ms, delay: 400.ms)
          .slideY(
            begin: 0.2,
            end: 0,
            duration: 600.ms,
            delay: 400.ms,
            curve: Curves.easeOut,
          )
          .shimmer(
            duration: 2000.ms,
            color: Colors.white.withOpacity(0.2),
            delay: 1000.ms,
          );
    }

    return InkWell(
          onTap: () => context.pushNamed(Routes.login),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          delay: 400.ms,
          curve: Curves.easeOut,
        )
        .shimmer(
          duration: 2000.ms,
          color: Colors.white.withOpacity(0.2),
          delay: 1000.ms,
        );
  }
}
