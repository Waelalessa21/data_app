import 'package:flutter/material.dart';
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

class _FormSwitcherState extends State<FormSwitcher>
    with SingleTickerProviderStateMixin {
  FormType _currentForm = FormType.signup;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormTypeChanged?.call(_currentForm == FormType.login);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchForm() {
    setState(() {
      _currentForm = _currentForm == FormType.signup
          ? FormType.login
          : FormType.signup;
      _errorMessage = null;
    });
    _animationController.forward(from: 0.0);
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
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 600;

        final linkSpacing = isDesktop ? 16.0 : 16.0;
        final linkFontSize = isDesktop
            ? 13.0
            : isTablet
            ? 13.0
            : 14.0;
        final linkButtonSpacing = isDesktop ? 6.0 : 8.0;

        return Column(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _currentForm == FormType.signup
                    ? SignUpForm(
                        onSubmit: _handleSignUp,
                        errorMessage: _errorMessage,
                      )
                    : LoginForm(
                        onSubmit: _handleLogin,
                        errorMessage: _errorMessage,
                      ),
              ),
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
                SizedBox(width: linkButtonSpacing),
                TextButton(
                  onPressed: _switchForm,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 4.0 : 8.0,
                      vertical: isDesktop ? 4.0 : 8.0,
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
