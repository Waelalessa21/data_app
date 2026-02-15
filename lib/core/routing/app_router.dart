import 'package:data_app/core/routing/routes.dart';
import 'package:data_app/pages/chat/ui/chat_history_screen.dart';
import 'package:data_app/pages/chat/ui/chat_screen.dart';
import 'package:data_app/pages/home/ui/home_screen.dart';
import 'package:data_app/pages/loading/loading_screen.dart';
import 'package:data_app/pages/login/ui/login_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.loading:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case Routes.chat:
        final args = settings.arguments;
        String prompt = '';
        String? conversationId;

        if (args is String) {
          prompt = args;
        } else if (args is Map<String, dynamic>) {
          prompt = args['initialPrompt'] as String? ?? '';
          conversationId = args['conversationId'] as String?;
        }

        return MaterialPageRoute(
          builder: (_) =>
              ChatScreen(initialPrompt: prompt, conversationId: conversationId),
        );
      case Routes.chatHistory:
        return MaterialPageRoute(builder: (_) => const ChatHistoryScreen());
      default:
        return null;
    }
  }
}
