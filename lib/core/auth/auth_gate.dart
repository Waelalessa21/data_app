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
        String screenKey;
        if (isWaiting) {
          screen = const LoadingScreen();
          screenKey = 'loading';
        } else if (isAuthenticated) {
          screen = const ChatScreen();
          screenKey = 'chat';
        } else {
          screen = const HomeScreen();
          screenKey = 'home';
        }

        return DataApp(
          appRouter: AppRouter(),
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            child: KeyedSubtree(
              key: ValueKey(screenKey),
              child: screen,
            ),
          ),
        );
      },
    );
  }
}
