import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AiThinkingAnimation extends StatefulWidget {
  const AiThinkingAnimation({super.key});

  @override
  State<AiThinkingAnimation> createState() => _AiThinkingAnimationState();
}

class _AiThinkingAnimationState extends State<AiThinkingAnimation> {
  int _currentStep = 0;

  final _steps = [
    'Taking your query',
    'Searching your data',
    'Finding results',
  ];

  @override
  void initState() {
    super.initState();
    _startStepAnimation();
  }

  void _startStepAnimation() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _currentStep = 1);
    });
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() => _currentStep = 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = _currentStep >= index;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _steps.length - 1 ? 8 : 16,
            ),
            child:
                Row(
                      children: [
                        Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.white : Colors.white38,
                                shape: BoxShape.circle,
                              ),
                            )
                            .animate(target: isActive ? 1 : 0)
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1, 1),
                              duration: 300.ms,
                            )
                            .fadeIn(duration: 200.ms),
                        const SizedBox(width: 10),
                        Text(
                              step,
                              style: TextStyle(
                                fontSize: 13,
                                color: isActive ? Colors.white : Colors.white38,
                                height: 1.4,
                              ),
                            )
                            .animate(target: isActive ? 1 : 0)
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: -0.05, end: 0, duration: 300.ms),
                      ],
                    )
                    .animate(delay: Duration(milliseconds: index * 150))
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms),
          );
        }),
        Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                'We help you to talk with your DATA!!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
            .animate(delay: 600.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms),
      ],
    );
  }
}
