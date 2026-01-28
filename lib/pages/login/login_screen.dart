import 'package:data_app/core/layout/app_layout.dart';
import 'package:data_app/core/layout/responsive_utils.dart';
import 'package:flutter/material.dart';

import 'ui/widgets/login_container.dart';
import 'ui/widgets/login_title.dart';
import 'ui/widgets/form_switcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = false;

  void _onFormTypeChanged(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);
    final gap = isLarge ? 32.0 : 24.0;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    return AppLayout(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: gap),
              LoginTitle(isLogin: _isLogin),
              SizedBox(height: gap),
              LoginContainer(
                child: FormSwitcher(onFormTypeChanged: _onFormTypeChanged),
              ),
              SizedBox(height: gap),
            ],
          ),
        ),
      ),
    );
  }
}
