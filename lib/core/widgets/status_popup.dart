import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:data_app/core/layout/responsive_utils.dart';

enum StatusType { loading, success, error }

class StatusPopup extends StatelessWidget {
  final StatusType type;
  final String? message;

  const StatusPopup({super.key, required this.type, this.message});

  static Future<void> showLoading(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => const _LoadingOverlay(),
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<void> showSuccess(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatusPopup(type: StatusType.success, message: message),
    );
  }

  static Future<void> showError(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => StatusPopup(type: StatusType.error, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);
    final padding = isLarge ? 32.0 : 24.0;
    final borderRadius = isLarge ? 16.0 : 12.0;

    final isSuccess = type == StatusType.success;
    final icon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;
    final iconColor = isSuccess ? Colors.green.shade400 : Colors.red.shade400;
    final title = isSuccess ? 'Connection saved' : 'Something went wrong';
    final body =
        message ??
        (isSuccess
            ? 'Your connection has been saved successfully.'
            : 'Please try again.');

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isLarge ? 32 : 24),
        child: Material(
          color: Colors.transparent,
          child:
              Container(
                    padding: EdgeInsets.all(padding),
                    constraints: BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: const Color(0xFF424141),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: isLarge ? 56 : 48, color: iconColor)
                            .animate()
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1, 1),
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(duration: 300.ms),
                        SizedBox(height: padding),
                        Text(
                              title,
                              style: TextStyle(
                                fontSize: isLarge ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 100.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 300.ms,
                              delay: 100.ms,
                            ),
                        SizedBox(height: 12),
                        Text(
                              body,
                              style: TextStyle(
                                fontSize: isLarge ? 14 : 13,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 150.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 300.ms,
                              delay: 150.ms,
                            ),
                        SizedBox(height: padding),
                        SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Got it',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isLarge ? 16 : 15,
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: 200.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              duration: 300.ms,
                              delay: 200.ms,
                            ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 250.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutCubic,
                  ),
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.sizeOf(context).width > 600;

    return Center(
      child: Material(
        color: Colors.transparent,
        child:
            Container(
                  padding: EdgeInsets.all(isLarge ? 40 : 32),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF424141),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                            width: isLarge ? 48 : 40,
                            height: isLarge ? 48 : 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .shimmer(duration: 1200.ms, color: Colors.white24),
                      SizedBox(height: 20),
                      Text(
                        'Saving connection...',
                        style: TextStyle(
                          fontSize: isLarge ? 16 : 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 200.ms)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutCubic,
                ),
      ),
    );
  }
}
