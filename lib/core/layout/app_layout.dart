import 'package:flutter/material.dart';
import 'package:data_app/core/layout/grid_background.dart';
import 'package:data_app/core/layout/responsive_utils.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final Widget? floatingWidget;
  const AppLayout({super.key, required this.child, this.floatingWidget});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isLarge = isLargeWidth(w);
        final maxWidth = isLarge ? kMaxContentWidth : double.infinity;
        final horizontalPadding = isLarge ? 32.0 : 16.0;
        final verticalPadding = isLarge ? 32.0 : 24.0;

        return Scaffold(
          body: Stack(
            children: [
              const GridBackground(),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
              if (floatingWidget != null) floatingWidget!,
            ],
          ),
        );
      },
    );
  }
}
