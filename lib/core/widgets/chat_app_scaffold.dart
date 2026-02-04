import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class ChatAppScaffold extends StatelessWidget {
  final String homeRoute;
  final Widget mainChild;
  final Widget historyChild;
  final bool showDrawerButton;

  const ChatAppScaffold({
    super.key,
    required this.homeRoute,
    required this.mainChild,
    required this.historyChild,
    this.showDrawerButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 700;

    if (isWide) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(context, false),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(flex: 3, child: mainChild),
              Container(
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    left: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: historyChild
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 100.ms)
                    .slideX(
                      begin: 0.3,
                      end: 0,
                      duration: 600.ms,
                      delay: 100.ms,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context, true),
      endDrawer: showDrawerButton
          ? Drawer(
              backgroundColor: Colors.black,
              child: SafeArea(child: historyChild),
            )
          : null,
      body: SafeArea(child: mainChild),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool narrow) {
    return AppBar(
      backgroundColor: Colors.black,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.home, color: Colors.white),
        onPressed: () => Navigator.of(context).pushReplacementNamed(homeRoute),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text('', style: TextStyle(color: Colors.white)),
      actions: narrow && showDrawerButton
          ? [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Iconsax.menu_1),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ]
          : null,
    );
  }
}
