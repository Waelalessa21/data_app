import 'package:flutter/material.dart';

class AppResponsiveness extends StatelessWidget {
  final Widget desktopWidget;
  final Widget mobileWidget;
  final Widget tabletWidget;

  const AppResponsiveness({
    super.key,
    required this.desktopWidget,
    required this.mobileWidget,
    required this.tabletWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return desktopWidget;
        } else if (constraints.maxWidth > 600) {
          return tabletWidget;
        } else {
          return mobileWidget;
        }
      },
    );
  }
}
