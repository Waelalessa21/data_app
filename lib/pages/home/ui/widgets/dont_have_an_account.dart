import 'package:data_app/core/helper/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/routes.dart';

class DontHaveAnAccount extends StatelessWidget {
  const DontHaveAnAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.login);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: "Sign up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
