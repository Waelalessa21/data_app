import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SignUpForm extends StatefulWidget {
  final Function(String, String, String, String) onSubmit;
  final String? errorMessage;

  const SignUpForm({
    super.key,
    required this.onSubmit,
    this.errorMessage,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  int _currentStep = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
      } else {
        widget.onSubmit(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _confirmPasswordController.text,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildStepIndicator() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final indicatorSize = isDesktop ? 6.0 : 8.0;
        final spacing = isDesktop ? 6.0 : 8.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Row(
              children: [
                Container(
                  width: indicatorSize,
                  height: indicatorSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= _currentStep
                        ? Colors.white
                        : Colors.white38,
                  ),
                ),
                if (index < 3) SizedBox(width: spacing),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildCurrentStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;

        final iconSize = isDesktop ? 18.0 : isTablet ? 20.0 : 24.0;
        final fontSize = isDesktop ? 14.0 : isTablet ? 15.0 : 16.0;
        final labelFontSize = isDesktop ? 13.0 : isTablet ? 13.5 : 14.0;
        final buttonPadding = isDesktop ? 11.0 : isTablet ? 14.0 : 16.0;
        final buttonFontSize = isDesktop ? 14.0 : isTablet ? 15.0 : 16.0;
        final errorFontSize = isDesktop ? 11.0 : isTablet ? 11.5 : 12.0;
        final inputPadding = isDesktop ? 14.0 : isTablet ? 15.0 : 16.0;

        Widget field;

        switch (_currentStep) {
          case 0:
            field = TextFormField(
              controller: _usernameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white70, fontSize: labelFontSize),
                prefixIcon: Icon(Iconsax.user, color: Colors.white70, size: iconSize),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 14.0 : 16.0,
                  vertical: isDesktop ? inputPadding : 16.0,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: fontSize),
              validator: _validateUsername,
              onFieldSubmitted: (_) => _nextStep(),
            );
            break;
          case 1:
            field = TextFormField(
              controller: _emailController,
              autofocus: true,
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
              validator: _validateEmail,
              onFieldSubmitted: (_) => _nextStep(),
            );
            break;
          case 2:
            field = TextFormField(
              controller: _passwordController,
              autofocus: true,
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
              validator: _validatePassword,
              onFieldSubmitted: (_) => _nextStep(),
            );
            break;
          case 3:
            field = TextFormField(
              controller: _confirmPasswordController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.white70, fontSize: labelFontSize),
                prefixIcon: Icon(Iconsax.lock_1, color: Colors.white70, size: iconSize),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Iconsax.eye : Iconsax.eye_slash,
                    color: Colors.white70,
                    size: iconSize,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 14.0 : 16.0,
                  vertical: isDesktop ? inputPadding : 16.0,
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: fontSize),
              obscureText: _obscureConfirmPassword,
              validator: _validateConfirmPassword,
              onFieldSubmitted: (_) => _nextStep(),
            );
            break;
          default:
            field = SizedBox();
        }

        return Column(
          children: [
            _buildStepIndicator(),
            SizedBox(height: isDesktop ? 20.0 : 24.0),
            field,
            if (widget.errorMessage != null) ...[
              SizedBox(height: isDesktop ? 12.0 : 16.0),
              Text(
                widget.errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: errorFontSize),
              ),
            ],
            SizedBox(height: isDesktop ? 20.0 : 24.0),
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white54),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(fontSize: buttonFontSize),
                      ),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: isDesktop ? 12.0 : 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Sign Up' : 'Next',
                      style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _buildCurrentStep(),
    );
  }
}
