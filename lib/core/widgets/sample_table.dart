import 'package:flutter/material.dart';

class SampleTable extends StatelessWidget {
  const SampleTable({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['101', 'Ahmed Mansour', 'Software Engineer', '12000', '1', 'Active'],
      ['102', 'Sara Al-Otaibi', 'Data Analyst', '15000', '3', 'Active'],
      ['103', 'Khalid Al-Fahad', 'Sales Manager', '11000', '2', 'Resigned'],
      ['104', 'Laila Hassan', 'HR Specialist', '9000', '4', 'Active'],
      ['105', 'Omar Bakri', 'ML Engineer', '16500', '3', 'Active'],
    ];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'emp_id | full_name | job_title | salary | dept_id | status',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 4),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '${r[0]} | ${r[1]} | ${r[2]} | ${r[3]} | ${r[4]} | ${r[5]}',
                style: TextStyle(fontSize: 9, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
