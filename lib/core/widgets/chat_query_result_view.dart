import 'package:flutter/material.dart';

import 'package:data_app/core/models/chat_query_result.dart';

class ChatQueryResultView extends StatelessWidget {
  final ChatQueryResult result;
  final bool isUser;
  final Color textColor;
  final Color backgroundColor;

  const ChatQueryResultView({
    super.key,
    required this.result,
    required this.isUser,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasChart = result.imageUrl != null && result.imageUrl!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasChart) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 320),
              child: Image.network(
                result.imageUrl!,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Failed to load chart',
                    style: TextStyle(color: textColor.withOpacity(0.6)),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (!hasChart) ...[
          if (result.sql.isNotEmpty) _buildSqlBlock(),
          if (result.sql.isNotEmpty && result.rows.isNotEmpty)
            const SizedBox(height: 12),
          if (result.rows.isNotEmpty) _buildDataTable(),
          if (result.rows.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${result.rows.length} row(s)',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildSqlBlock() {
    final blockBg = textColor.withOpacity(0.06);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: blockBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: SelectableText(
        result.sql,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: textColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: textColor.withOpacity(0.15)),
          ),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            TableRow(
              decoration: BoxDecoration(color: textColor.withOpacity(0.1)),
              children: result.headers
                  .map(
                    (h) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Text(
                        h,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            ...result.rows.map(
              (row) => TableRow(
                children: row
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          cell.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.9),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
