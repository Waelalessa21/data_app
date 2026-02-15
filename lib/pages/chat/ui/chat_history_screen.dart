import 'package:data_app/pages/chat/ui/widgets/chat_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Chat History', style: TextStyle(color: Colors.white))
            .animate()
            .fadeIn(duration: 300.ms)
            .slideX(begin: -0.2, end: 0, duration: 400.ms),
      ),
      body: SafeArea(
        child: const ChatHistoryList()
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 100.ms),
      ),
    );
  }
}
