import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AiTypingIndicator extends StatelessWidget {
  const AiTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0),
        const SizedBox(width: 6),
        _buildDot(150),
        const SizedBox(width: 6),
        _buildDot(300),
      ],
    );
  }

  Widget _buildDot(int delay) {
    return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white54,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          delay: Duration(milliseconds: delay),
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.8),
        )
        .scale(
          delay: Duration(milliseconds: delay),
          duration: 1500.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
        );
  }
}
