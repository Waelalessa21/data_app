import 'package:flutter/material.dart';

/// Breakpoint above which we treat as "large" (web/desktop) and use fixed px
/// for layout/sizing to keep text and containers readable.
const double kBreakpointLarge = 600.0;

const double kMaxContentWidth = 800.0;

bool isLargeScreen(BuildContext context) {
  return MediaQuery.sizeOf(context).width > kBreakpointLarge;
}

bool isLargeWidth(double width) => width > kBreakpointLarge;
