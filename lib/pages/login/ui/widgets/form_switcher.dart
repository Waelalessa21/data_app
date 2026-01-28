import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:data_app/pages/login/ui/widgets/signup_form.dart';
import 'package:data_app/pages/login/ui/widgets/login_form.dart';
import 'package:data_app/core/database/database_service.dart';
import 'package:data_app/core/models/user_model.dart';

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

  void _handleSignUp(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final dbService = DatabaseService.instance;
      final existingUser = await dbService.getUserByEmail(email);
      final existingUsername = await dbService.getUserByUsername(username);

      if (existingUser != null) {
        setState(() {
          _errorMessage = 'Email already exists';
        });
        return;
      }

      if (existingUsername != null) {
        setState(() {
          _errorMessage = 'Username already exists';
        });
        return;
      }

      final user = UserModel(
        username: username,
        email: email,
        password: password,
      );

      await dbService.createUser(user);
      _switchForm();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating account. Please try again.';
      });
    }
  }

  void _handleLogin(String email, String password) async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final dbService = DatabaseService.instance;
      final user = await dbService.getUserByEmail(email);

      if (user == null || user.password != password) {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error logging in. Please try again.';
      });
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
                      )
                    : LoginForm(
                        onSubmit: _handleLogin,
                        errorMessage: _errorMessage,
                      ))
                .animate(key: ValueKey(_currentForm))
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .slideX(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOutCubic)
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 350.ms),
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
