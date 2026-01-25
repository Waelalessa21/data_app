import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFieldContainer extends StatelessWidget {
  final bool isFocused;
  final Widget child;

  const SearchFieldContainer({
    super.key,
    required this.isFocused,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isFocused
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: isFocused ? 2.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white.withOpacity(0.1),
      ),
      child: child,
    );
  }
}
