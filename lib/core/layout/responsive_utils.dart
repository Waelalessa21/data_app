import 'package:flutter/material.dart';

const double kBreakpointLarge = 600.0;

const double kMaxContentWidth = 800.0;

bool isLargeScreen(BuildContext context) {
  return MediaQuery.sizeOf(context).width > kBreakpointLarge;
}

bool isLargeWidth(double width) => width > kBreakpointLarge;
