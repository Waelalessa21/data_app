import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/routing/app_router.dart';
import 'package:data_app/data_app.dart';
import 'package:data_app/pages/chat/ui/chat_screen.dart';
import 'package:data_app/pages/home/ui/home_screen.dart';
import 'package:data_app/pages/loading/loading_screen.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        final isWaiting = snapshot.connectionState == ConnectionState.waiting;
        final user = snapshot.data;
        final isAuthenticated = user != null;

        Widget screen;
        if (isWaiting) {
          screen = const LoadingScreen();
        } else if (isAuthenticated) {
          screen = const ChatScreen();
        } else {
          screen = const HomeScreen();
        }

        return DataApp(
          key: ValueKey(user?.uid ?? 'no_user'),
          appRouter: AppRouter(),
          home: screen,
        );
      },
    );
  }
}
