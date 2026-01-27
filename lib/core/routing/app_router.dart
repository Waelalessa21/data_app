import 'package:data_app/core/routing/routes.dart';
import 'package:data_app/pages/home/ui/home_screen.dart';
import 'package:data_app/pages/login/login_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return null;
    }
  }
}
