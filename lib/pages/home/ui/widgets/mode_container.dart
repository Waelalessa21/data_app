import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:data_app/core/widgets/test_data_mode_popup.dart';

class ModeContainer extends StatefulWidget {
  const ModeContainer({super.key});

  @override
  State<ModeContainer> createState() => _ModeContainerState();
}

class _ModeContainerState extends State<ModeContainer> {
  bool _isTestDataMode = false;

  @override
  Widget build(BuildContext context) {
    final bool isConnectModeActive = !_isTestDataMode;
    final bool isTestDataModeActive = _isTestDataMode;
    final w = MediaQuery.sizeOf(context).width;
    final isLarge = isLargeWidth(w);
    final double containerWidth = isLarge ? 56.0 : 32.0;
    final double containerHeight = isLarge ? 32.0 : 20.0;
    final double thumbSize = isLarge ? 26.0 : 16.0;
    final double thumbPadding = isLarge ? 5.0 : 2.0;
    final double textSize = isLarge ? 16.0 : 12.0;
    final double gap = isLarge ? 14.0 : 8.0;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Connect to my data",
            style: TextStyle(
              fontSize: textSize,
              fontWeight: isConnectModeActive
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isConnectModeActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
            ),
          )
              .animate(target: isConnectModeActive ? 1 : 0)
              .fadeIn(duration: 200.ms)
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms),
          SizedBox(width: gap),
          GestureDetector(
            onTap: () {
              final willEnableTestData = !_isTestDataMode;
              setState(() {
                _isTestDataMode = willEnableTestData;
              });
              if (willEnableTestData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    TestDataModePopup.show(context);
                  }
                });
              }
            },
            child: Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: isTestDataModeActive
                    ? Colors.white
                    : Colors.grey.shade700,
                borderRadius: BorderRadius.circular(containerHeight / 2),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    left: isTestDataModeActive ? null : thumbPadding,
                    right: isTestDataModeActive ? thumbPadding : null,
                    top: (containerHeight - thumbSize) / 2,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: isTestDataModeActive
                            ? Colors.black87
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    )
                        .animate(target: isTestDataModeActive ? 1 : 0)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 300.ms, curve: Curves.elasticOut)
                        .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.3)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: gap),
          Text(
            "Work on test data",
            style: TextStyle(
              fontSize: textSize,
              fontWeight: isTestDataModeActive
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isTestDataModeActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
            ),
          )
              .animate(target: isTestDataModeActive ? 1 : 0)
              .fadeIn(duration: 200.ms)
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms),
        ],
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: 400.ms, curve: Curves.easeOut)
          .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}
