import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:data_app/core/layout/responsive_utils.dart';

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
        final isLarge = isLargeWidth(constraints.maxWidth);
        final fontSize = isLarge ? 18.0 : 14.0;
        final padding = isLarge ? 12.0 : 4.0;

        return Stack(
          children: [
            TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.left,
              cursorHeight: isLarge ? 20.0 : null,
              decoration: InputDecoration(
                hintText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding,
                ),
              ),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (_controller.text.isEmpty && !_isFocused)
              Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _hints[_currentHintIndex],
                        key: ValueKey(_currentHintIndex),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      )
                          .animate(key: ValueKey(_currentHintIndex))
                          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOutCubic)
                          .blur(begin: const Offset(0, 2), end: Offset.zero, duration: 400.ms),
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
