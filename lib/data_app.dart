import 'package:data_app/core/routing/app_router.dart';
import 'package:flutter/material.dart';

class DataApp extends StatelessWidget {
  final AppRouter appRouter;
  final Widget home;

  const DataApp({super.key, required this.appRouter, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home,
      onGenerateRoute: appRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'roboto',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withOpacity(0.1),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}
