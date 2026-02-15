import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSendPressed;
  final bool enabled;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onSendPressed,
    this.enabled = true,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    widget.controller.addListener(() {
      setState(() {
        _hasText = widget.controller.text.trim().isNotEmpty;
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
    return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _isFocused
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.2),
              width: _isFocused ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onSubmitted: widget.onSubmitted,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    fillColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: _hasText && widget.enabled ? 36 : 0,
                height: 36,
                child: _hasText && widget.enabled
                    ? Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onSendPressed,
                          borderRadius: BorderRadius.circular(18),
                          child:
                              Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Iconsax.send_2,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  )
                                  .animate(target: _hasText ? 1 : 0)
                                  .scale(
                                    begin: const Offset(0.8, 0.8),
                                    end: const Offset(1, 1),
                                    duration: 300.ms,
                                    curve: Curves.elasticOut,
                                  )
                                  .fadeIn(duration: 200.ms),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 300.ms)
        .animate(target: _isFocused ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
          duration: 200.ms,
          curve: Curves.easeOut,
        )
        .shimmer(
          duration: 2000.ms,
          color: Colors.white.withOpacity(0.05),
          delay: 1000.ms,
        );
  }
}
