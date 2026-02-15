import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum DbType { postgresql, mysql }

class DatabaseTypeSelector extends StatelessWidget {
  final Function(DbType) onTypeSelected;
  final bool isLarge;

  const DatabaseTypeSelector({
    super.key,
    required this.onTypeSelected,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    const types = [(DbType.postgresql, 'PostgreSQL'), (DbType.mysql, 'MySQL')];

    final padding = isLarge ? 36.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
              'Connect your database',
              style: TextStyle(
                fontSize: isLarge ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: 250.ms, delay: 50.ms)
            .slideX(begin: -0.05, end: 0, duration: 250.ms, delay: 50.ms),
        SizedBox(height: padding * 0.5),
        Text(
              'Choose your database type',
              style: TextStyle(
                fontSize: isLarge ? 14 : 13,
                color: Colors.white70,
              ),
            )
            .animate()
            .fadeIn(duration: 250.ms, delay: 100.ms)
            .slideX(begin: -0.03, end: 0, duration: 250.ms, delay: 100.ms),
        SizedBox(height: padding),
        ...types.asMap().entries.map((e) {
          final i = e.key;
          final t = e.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < types.length - 1 ? 10 : 0),
            child:
                GestureDetector(
                      onTap: () => onTypeSelected(t.$1),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isLarge ? 20 : 16,
                          vertical: isLarge ? 16 : 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                t.$2,
                                style: TextStyle(
                                  fontSize: isLarge ? 16 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      duration: 300.ms,
                      delay: Duration(milliseconds: 150 + i * 80),
                    )
                    .slideX(
                      begin: 0.08,
                      end: 0,
                      duration: 300.ms,
                      delay: Duration(milliseconds: 150 + i * 80),
                      curve: Curves.easeOutCubic,
                    ),
          );
        }),
      ],
    );
  }
}
