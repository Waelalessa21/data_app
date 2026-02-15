import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:data_app/pages/home/ui/widgets/alert_hero_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlertFloatingPoint extends StatelessWidget {
  const AlertFloatingPoint({super.key});

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AlertHeroPopup(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);
    final size = isLarge ? 56.0 : 30.0;
    final iconSize = isLarge ? 28.0 : 14.0;
    final borderWidth = isLarge ? 2.5 : 2.0;
    final padding = isLarge ? 3.0 : 2.0;

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Hero(
        tag: AlertHeroPopup.heroTag,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(padding),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: borderWidth,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.question_mark,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1500.ms, curve: Curves.easeInOut)
              .then()
              .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 1500.ms, curve: Curves.easeInOut)
              .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
        ),
      ),
    );
  }
}
