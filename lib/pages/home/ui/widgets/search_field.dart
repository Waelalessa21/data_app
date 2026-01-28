import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:data_app/pages/home/ui/widgets/search_field_container.dart';
import 'package:data_app/pages/home/ui/widgets/animated_search_input.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 20.0 : 16.0,
            vertical: isLarge ? 14.0 : 8.0,
          ),
          child: AnimatedScale(
            scale: _isFocused ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: SearchFieldContainer(
              isFocused: _isFocused,
              child: AnimatedSearchInput(focusNode: _focusNode),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms, curve: Curves.easeOut)
                .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 300.ms, curve: Curves.easeOutCubic)
                .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.1), delay: 500.ms),
          ),
        );
      },
    );
  }
}
