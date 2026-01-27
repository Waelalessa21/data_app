import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

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
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;
        
        final iconSize = isDesktop ? 18.0 : isTablet ? 20.0 : 24.0;
        final fieldSpacing = isDesktop ? 14.0 : 16.0;
        final fontSize = isDesktop ? 14.0 : isTablet ? 15.0 : 16.0;
        final labelFontSize = isDesktop ? 13.0 : isTablet ? 13.5 : 14.0;
        final buttonPadding = isDesktop ? 11.0 : isTablet ? 14.0 : 16.0;
        final buttonFontSize = isDesktop ? 14.0 : isTablet ? 15.0 : 16.0;
        final errorFontSize = isDesktop ? 11.0 : isTablet ? 11.5 : 12.0;
        final inputPadding = isDesktop ? 14.0 : isTablet ? 15.0 : 16.0;

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
                    horizontal: isDesktop ? 14.0 : 16.0,
                    vertical: isDesktop ? inputPadding : 16.0,
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
                    horizontal: isDesktop ? 14.0 : 16.0,
                    vertical: isDesktop ? inputPadding : 16.0,
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
                SizedBox(height: isDesktop ? 8.0 : 12.0),
                Text(
                  widget.errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: errorFontSize),
                ),
              ],
              SizedBox(height: isDesktop ? 16.0 : 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
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
