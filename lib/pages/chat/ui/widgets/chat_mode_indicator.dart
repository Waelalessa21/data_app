import 'package:data_app/core/models/active_connection_model.dart';
import 'package:data_app/core/services/data_mode_service.dart';
import 'package:data_app/pages/chat/ui/widgets/database_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatModeIndicator extends StatefulWidget {
  const ChatModeIndicator({super.key});

  @override
  State<ChatModeIndicator> createState() => _ChatModeIndicatorState();
}

class _ChatModeIndicatorState extends State<ChatModeIndicator> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isExpanded = true);
      }
    });
  }

  void _openDatabaseSelector() {
    DatabaseSelectorDialog.show(context);
  }

  String _getDisplayText() {
    try {
      final isTestMode = DataModeService.instance.isTestDataMode;
      if (isTestMode) return 'Test Data';

      final activeConn = ActiveConnectionModel.instance.activeConnection;
      if (activeConn == null) return 'My Data';

      final info = activeConn['connection_info'];
      if (info is! Map<String, dynamic>) return 'My Data';

      final dbType = info['db_type'] as String?;
      final host = info['host'] as String?;

      if (dbType != null && host != null) {
        return '${dbType.toUpperCase()} - $host';
      }
      return 'My Data';
    } catch (_) {
      return 'My Data';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        DataModeService.instance,
        ActiveConnectionModel.instance,
      ]),
      builder: (context, child) {
        final displayText = _getDisplayText();

        return GestureDetector(
          onTap: _openDatabaseSelector,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: _isExpanded ? 12 : 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isExpanded)
                  SizedBox(
                    width: 20,
                    height: 14,
                    child: Center(
                      child:
                          Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                  shape: BoxShape.circle,
                                ),
                              )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .scale(
                                duration: 800.ms,
                                begin: const Offset(1, 1),
                                end: const Offset(1.5, 1.5),
                              )
                              .fadeIn(duration: 600.ms),
                    ),
                  ),
                if (_isExpanded) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child:
                        Text(
                              displayText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                            .animate(key: ValueKey(displayText))
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: -0.2, end: 0, duration: 400.ms),
                  ),
                  const SizedBox(width: 8),
                  Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.settings,
                          size: 10,
                          color: Colors.white70,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        delay: 200.ms,
                        curve: Curves.elasticOut,
                      ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
