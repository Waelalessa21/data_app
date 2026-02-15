import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatHistoryHeader extends StatelessWidget {
  final int conversationCount;

  const ChatHistoryHeader({super.key, required this.conversationCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                'Chat History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideX(begin: 0.2, end: 0, duration: 500.ms, delay: 100.ms),
          const SizedBox(height: 4),
          Text(
                '$conversationCount saved conversation${conversationCount != 1 ? 's' : ''}',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideX(begin: 0.2, end: 0, duration: 500.ms, delay: 200.ms),
        ],
      ),
    );
  }
}
