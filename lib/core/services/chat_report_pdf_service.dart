import 'dart:typed_data';

import 'package:data_app/core/models/chat_message.dart';
import 'package:data_app/core/models/chat_query_result.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

enum PdfExportStatus { success, reduced, failure }

class PdfExportResult {
  final PdfExportStatus status;
  final String? message;

  const PdfExportResult._(this.status, this.message);

  const PdfExportResult.success() : this._(PdfExportStatus.success, null);

  const PdfExportResult.reduced(String msg)
    : this._(PdfExportStatus.reduced, msg);

  const PdfExportResult.failure(String msg)
    : this._(PdfExportStatus.failure, msg);
}

const int kMaxQueryResultsInReducedPdf = 10;
const int kMaxRowsPerTableInReducedPdf = 100;

class ChatReportPdfService {
  ChatReportPdfService._();
  static final ChatReportPdfService instance = ChatReportPdfService._();

  Future<Uint8List> generatePdf({
    required String chatTitle,
    required List<ChatMessage> messages,
    int? maxQueryResults,
    int? maxRowsPerTable,
  }) async {
    final baseFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto_Condensed-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto_Condensed-Bold.ttf'),
    );
    final theme = pw.ThemeData.withFont(base: baseFont, bold: boldFont);
    final pdf = pw.Document(theme: theme);

    String heading = chatTitle;
    try {
      final firstUser = messages.firstWhere((m) => m.sender == ChatSender.user);
      heading = firstUser.text;
    } catch (_) {}

    var queryResults = messages
        .where((m) => m.sender == ChatSender.system && m.queryResult != null)
        .map((m) => m.queryResult!)
        .toList();

    if (maxQueryResults != null && queryResults.length > maxQueryResults) {
      queryResults = queryResults.take(maxQueryResults).toList();
    }
    final maxRows = maxRowsPerTable;
    if (maxRows != null) {
      queryResults = queryResults
          .map(
            (r) => ChatQueryResult(
              sql: r.sql,
              headers: r.headers,
              rows: r.rows.take(maxRows).toList(),
              imageUrl: r.imageUrl,
            ),
          )
          .toList();
    }

    if (queryResults.isEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          maxPages: 20,
          build: (context) => [
            _buildTitle(chatTitle),
            pw.SizedBox(height: 24),
            _buildHeading(heading),
            pw.SizedBox(height: 16),
            pw.Text('No query results to export.'),
          ],
        ),
      );
    } else {
      final chartImages = <pw.MemoryImage?>[];
      for (final r in queryResults) {
        if (r.imageUrl != null && r.imageUrl!.isNotEmpty) {
          chartImages.add(await _fetchImageForPdf(r.imageUrl!));
        }
      }
      var chartIndex = 0;
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          maxPages: 20,
          build: (context) {
            final widgets = <pw.Widget>[
              _buildTitle(chatTitle),
              pw.SizedBox(height: 24),
              _buildHeading(heading),
              pw.SizedBox(height: 20),
            ];

            for (var i = 0; i < queryResults.length; i++) {
              final result = queryResults[i];
              if (result.imageUrl != null && result.imageUrl!.isNotEmpty) {
                final chartImage = chartImages[chartIndex++];
                if (chartImage != null) {
                  widgets.add(pw.Image(chartImage, width: 400, height: 280));
                  widgets.add(pw.SizedBox(height: 24));
                }
              } else {
                widgets.add(_buildSqlBlock(result.sql));
                widgets.add(pw.SizedBox(height: 12));
                widgets.add(_buildTable('Table ${i + 1}', result));
                widgets.add(pw.SizedBox(height: 24));
              }
            }

            if (queryResults.length > 20) {
              return [
                ...widgets,
                pw.Text(
                  'The chat report is too long to export. Please shorten the chat.',
                ),
              ];
            }
            return widgets;
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<void> exportAndShare({
    required String chatTitle,
    required List<ChatMessage> messages,
  }) async {
    final pdfBytes = await generatePdf(
      chatTitle: chatTitle,
      messages: messages,
    );
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '${_sanitizeFilename(chatTitle)}.pdf',
    );
  }

  /// Exports PDF; on failure (e.g. data too large), retries with limited data.
  /// Returns a result so the UI can show a message in chat when export was reduced or failed.
  Future<PdfExportResult> exportAndShareWithFallback({
    required String chatTitle,
    required List<ChatMessage> messages,
  }) async {
    try {
      await exportAndShare(chatTitle: chatTitle, messages: messages);
      return const PdfExportResult.success();
    } catch (e) {
      try {
        final pdfBytes = await generatePdf(
          chatTitle: chatTitle,
          messages: messages,
          maxQueryResults: kMaxQueryResultsInReducedPdf,
          maxRowsPerTable: kMaxRowsPerTableInReducedPdf,
        );
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: '${_sanitizeFilename(chatTitle)}_reduced.pdf',
        );
        return PdfExportResult.reduced(
          'Report exported with reduced data (first $kMaxQueryResultsInReducedPdf query results, up to $kMaxRowsPerTableInReducedPdf rows per table) because the full report was too large.',
        );
      } catch (_) {
        return PdfExportResult.failure(
          'Could not export report. Maximum supported size is '
          '$kMaxQueryResultsInReducedPdf query results and '
          '$kMaxRowsPerTableInReducedPdf rows per table. Try with fewer results.',
        );
      }
    }
  }

  pw.Widget _buildTitle(String title) {
    return pw.Text(title);
  }

  pw.Widget _buildHeading(String heading) {
    return pw.Text(heading);
  }

  pw.Widget _buildSqlBlock(String sql) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(sql),
    );
  }

  pw.Widget _buildTable(String label, ChatQueryResult result) {
    if (result.headers.isEmpty && result.rows.isEmpty) {
      return pw.Text('$label: (no data)');
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: _buildColumnWidths(result),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: result.headers
                  .map(
                    (h) => pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(h),
                    ),
                  )
                  .toList(),
            ),
            ...result.rows.map(
              (row) => pw.TableRow(
                children: row
                    .map(
                      (cell) => pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(cell.toString()),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<int, pw.TableColumnWidth> _buildColumnWidths(ChatQueryResult result) {
    final count = result.headers.length;
    if (count == 0) return {};
    final flexWidth = 1.0 / count;
    return Map.fromIterables(
      List.generate(count, (i) => i),
      List.generate(count, (_) => pw.FlexColumnWidth(flexWidth)),
    );
  }

  Future<pw.MemoryImage?> _fetchImageForPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return pw.MemoryImage(response.bodyBytes);
      }
    } catch (_) {}
    return null;
  }

  String _sanitizeFilename(String name) {
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
  }
}
