import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedSearchInput extends StatefulWidget {
  final FocusNode focusNode;

  const AnimatedSearchInput({super.key, required this.focusNode});

  @override
  State<AnimatedSearchInput> createState() => _AnimatedSearchInputState();
}

class _AnimatedSearchInputState extends State<AnimatedSearchInput> {
  final TextEditingController _controller = TextEditingController();
  int _currentHintIndex = 0;
  Timer? _hintTimer;
  bool _isFocused = false;

  final List _hints = [
    'Show total sales',
    'Sales by country',
    'Monthly sales trend',
    'Best selled products',
    'Average order value',
  ];

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
    _startHintAnimation();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
    if (_isFocused) {
      _hintTimer?.cancel();
    } else if (_controller.text.isEmpty) {
      _startHintAnimation();
    }
  }

  void _onTextChange() {
    if (_controller.text.isNotEmpty) {
      _hintTimer?.cancel();
    } else if (!_isFocused) {
      _startHintAnimation();
    }
  }

  void _startHintAnimation() {
    _hintTimer?.cancel();
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && !_isFocused && _controller.text.isEmpty) {
        setState(() {
          _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _controller.dispose();
    _hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;

        return Stack(
          children: [
            TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.left,
              cursorHeight: isDesktop
                  ? 1.4.sp
                  : isTablet
                  ? 6.sp
                  : null,
              decoration: InputDecoration(
                hintText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 4.h,
                ),
              ),
              style: TextStyle(
                fontSize: isDesktop
                    ? 1.4.sp
                    : isTablet
                    ? 6.sp
                    : 8.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (_controller.text.isEmpty && !_isFocused)
              Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.topLeft,
                            clipBehavior: Clip.none,
                            children: [
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          final slideAnimation =
                              Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              );

                          return SlideTransition(
                            position: slideAnimation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _hints[_currentHintIndex],
                          key: ValueKey(_currentHintIndex),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: isDesktop
                                ? 1.4.sp
                                : isTablet
                                ? 6.sp
                                : 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
