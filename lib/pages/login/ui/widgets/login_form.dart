import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:data_app/core/layout/responsive_utils.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onSubmit;
  final String? errorMessage;

  const LoginForm({
    super.key,
    required this.onSubmit,
    this.errorMessage,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);
        final iconSize = isLarge ? 24.0 : 24.0;
        final fieldSpacing = isLarge ? 20.0 : 16.0;
        final fontSize = isLarge ? 18.0 : 16.0;
        final labelFontSize = isLarge ? 16.0 : 14.0;
        final buttonPadding = isLarge ? 18.0 : 16.0;
        final buttonFontSize = isLarge ? 18.0 : 16.0;
        final errorFontSize = isLarge ? 14.0 : 12.0;
        final inputPadding = isLarge ? 18.0 : 16.0;
        const borderRadius = 10.0;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white70, fontSize: labelFontSize),
                  prefixIcon: Icon(Iconsax.sms, color: Colors.white70, size: iconSize),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isLarge ? 18.0 : 16.0,
                    vertical: inputPadding,
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: fontSize),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: fieldSpacing),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white70, fontSize: labelFontSize),
                  prefixIcon: Icon(Iconsax.lock, color: Colors.white70, size: iconSize),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Iconsax.eye : Iconsax.eye_slash,
                      color: Colors.white70,
                      size: iconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isLarge ? 18.0 : 16.0,
                    vertical: inputPadding,
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: fontSize),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              if (widget.errorMessage != null) ...[
                SizedBox(height: isLarge ? 8.0 : 12.0),
                Text(
                  widget.errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: errorFontSize),
                ),
              ],
              SizedBox(height: isLarge ? 16.0 : 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
