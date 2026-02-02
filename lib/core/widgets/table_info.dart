import 'package:flutter/material.dart';

class TableInfo extends StatelessWidget {
  final String name;
  final String purpose;
  final String columns;

  const TableInfo(this.name, this.purpose, this.columns, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            purpose,
            style: TextStyle(fontSize: 10, color: Colors.white70, height: 1.3),
          ),
          Text(
            'Columns: $columns',
            style: TextStyle(
              fontSize: 9,
              color: Colors.white54,
              fontStyle: FontStyle.italic,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
