import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DatabaseTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int delay;
  final bool isLarge;

  const DatabaseTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    required this.delay,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 13 : 12,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: TextStyle(
                fontSize: isLarge ? 15 : 14,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontSize: isLarge ? 14 : 13,
                ),
                filled: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF424141)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF424141)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white54,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade300),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isLarge ? 16 : 14,
                  vertical: isLarge ? 14 : 12,
                ),
              ),
            )
            .animate()
            .fadeIn(
              duration: 200.ms,
              delay: Duration(milliseconds: delay),
            )
            .slideX(
              begin: -0.02,
              end: 0,
              duration: 200.ms,
              delay: Duration(milliseconds: delay),
            ),
      ],
    );
  }
}
