import 'package:flutter/material.dart';

class QueryItem extends StatelessWidget {
  final String query;

  const QueryItem(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 10, color: Colors.white)),
          Expanded(
            child: Text(
              query,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
