import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 58.w
                : isTablet
                ? 32.w
                : 16.w,
            vertical: 8.h,
          ),
          child: SearchFieldContainer(
            isFocused: _isFocused,
            child: AnimatedSearchInput(focusNode: _focusNode),
          ),
        );
      },
    );
  }
}
