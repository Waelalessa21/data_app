import 'package:flutter/material.dart';

import 'package:data_app/core/layout/responsive_utils.dart';

class AlertHeroPopup extends StatelessWidget {
  const AlertHeroPopup({super.key});

  static const String heroTag = 'alert_floating_point_hero';

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);
    final imageSize = isLarge ? 180.0 : 200.0;
    final padding = isLarge ? 28.0 : 16.0;
    final titleSize = isLarge ? 24.0 : 16.0;
    final bodySize = isLarge ? 18.0 : 12.0;
    final gap = isLarge ? 16.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Hero(
            tag: heroTag,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/user.png",
                          width: imageSize,
                          height: imageSize,
                        ),
                        SizedBox(height: gap),
                        Text(
                          "This project is a work in progress. It is not ready for production.",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: gap),
                        Text(
                          "In here we don't access your data. We only use it to generate a response and represent results in a chat-like interface.",
                          style: TextStyle(
                            fontSize: bodySize,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
