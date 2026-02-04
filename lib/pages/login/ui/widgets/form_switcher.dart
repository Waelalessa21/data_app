import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:data_app/pages/login/ui/widgets/signup_form.dart';
import 'package:data_app/pages/login/ui/widgets/login_form.dart';

enum FormType { signup, login }

class FormSwitcher extends StatefulWidget {
  final Function(bool)? onFormTypeChanged;

  const FormSwitcher({super.key, this.onFormTypeChanged});

  @override
  State<FormSwitcher> createState() => _FormSwitcherState();
}

class _FormSwitcherState extends State<FormSwitcher> {
  FormType _currentForm = FormType.signup;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormTypeChanged?.call(_currentForm == FormType.login);
    });
  }

  void _switchForm() {
    setState(() {
      _currentForm = _currentForm == FormType.signup
          ? FormType.login
          : FormType.signup;
      _errorMessage = null;
    });
    widget.onFormTypeChanged?.call(_currentForm == FormType.login);
  }

  Future<void> _handleSignUp(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await AuthService.instance.signUp(
        email: email,
        password: password,
        displayName: username,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error creating account. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await AuthService.instance.signIn(email: email, password: password);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error logging in. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = isLargeWidth(constraints.maxWidth);
        final linkSpacing = isLarge ? 20.0 : 16.0;
        final linkFontSize = isLarge ? 16.0 : 14.0;
        final linkPadding = isLarge ? 8.0 : 8.0;

        return Column(
          children: [
            (_currentForm == FormType.signup
                    ? SignUpForm(
                        onSubmit: _handleSignUp,
                        errorMessage: _errorMessage,
                        isLoading: _isLoading,
                      )
                    : LoginForm(
                        onSubmit: _handleLogin,
                        errorMessage: _errorMessage,
                        isLoading: _isLoading,
                      ))
                .animate(key: ValueKey(_currentForm))
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .slideX(
                  begin: 0.3,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                )
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                  duration: 350.ms,
                ),
            SizedBox(height: linkSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentForm == FormType.signup
                      ? 'Already have an account?'
                      : "Don't have an account?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: linkFontSize,
                  ),
                ),
                SizedBox(width: linkPadding),
                TextButton(
                  onPressed: _switchForm,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: linkPadding,
                      vertical: linkPadding,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _currentForm == FormType.signup ? 'Sign In' : 'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: linkFontSize,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
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
}
