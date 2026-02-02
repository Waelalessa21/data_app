import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth > 1200 ? 24.w : 32.w;
    final double containerHeight = 20.h;
    final double thumbSize = 16.h;
    final double thumbPadding = 2.w;
    final double textSize = screenWidth > 1200
        ? 4.sp
        : screenWidth > 600
        ? 6.sp
        : 10.sp;

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
          ),
          SizedBox(width: 8.w),
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
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
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
          ),
        ],
      ),
    );
  }
}
