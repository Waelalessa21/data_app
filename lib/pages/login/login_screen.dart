import 'package:data_app/core/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return AppLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            LoginTitle(isLogin: _isLogin),
            SizedBox(height: 24.h),
            LoginContainer(
              child: FormSwitcher(onFormTypeChanged: _onFormTypeChanged),
            ),
          ],
        ),
      ),
    );
  }
}
