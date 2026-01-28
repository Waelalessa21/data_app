import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:data_app/core/layout/responsive_utils.dart';

class AppNameDescription extends StatelessWidget {
  const AppNameDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLarge ? 700.0 : double.infinity,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chat with your SQL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isLarge ? 32.0 : 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .slideY(begin: -0.3, end: 0, duration: 700.ms, curve: Curves.easeOutCubic)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 600.ms, curve: Curves.elasticOut)
                    .blur(begin: const Offset(4, 4), end: Offset.zero, duration: 500.ms),
                SizedBox(height: isLarge ? 12.0 : 8.0),
                Text(
                  'An AI-powered system that enables non-technical users to query relational databases using natural language by automatically generating, validating, and executing SQL queries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isLarge ? 16.0 : 12.0,
                    color: Colors.white,
                    height: isLarge ? 1.5 : 1.6,
                  ),
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .slideY(begin: 0.2, end: 0, duration: 700.ms, curve: Curves.easeOutCubic)
                    .blur(begin: const Offset(2, 2), end: Offset.zero, duration: 500.ms),
              ],
            ),
          ),
        );
      },
    );
  }
}
