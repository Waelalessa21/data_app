import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:data_app/core/layout/responsive_utils.dart';

class WarningInfo extends StatelessWidget {
  const WarningInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);
        return Padding(
          padding: EdgeInsets.only(
            top: isLarge ? 12.0 : 16.0,
            bottom: isLarge ? 12.0 : 16.0,
            left: isLarge ? 8.0 : 4.0,
            right: isLarge ? 8.0 : 4.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLarge ? 16.0 : 12.0,
                  vertical: isLarge ? 14.0 : 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: Colors.white,
                          size: isLarge ? 20.0 : 14.0,
                        ),
                        SizedBox(width: isLarge ? 10.0 : 8.0),
                        Text(
                          'Heads up!',
                          style: TextStyle(
                            fontSize: isLarge ? 14.0 : 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isLarge ? 10.0 : 8.0),
                    Text(
                      'This project is still in development under SDAIA AI bootcamp. Please use with caution.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: isLarge ? 13.0 : 10.0,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 500.ms, curve: Curves.easeOutCubic)
                  .slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut)
                  .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.1)),
            ),
          ),
        );
      },
    );
  }
}
