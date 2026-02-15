import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Icon(Iconsax.flash_1, size: 18, color: Colors.black),
            )
            .animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 400.ms),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                  'SQL Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .slideX(begin: -0.2, end: 0, duration: 500.ms, delay: 100.ms),
            const SizedBox(height: 2),
            const Text(
                  'Chat with your SQL',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideX(begin: -0.2, end: 0, duration: 500.ms, delay: 200.ms),
          ],
        ),
      ],
    );
  }
}
