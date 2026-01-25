import 'package:flutter/material.dart';

import 'package:data_app/core/widgets/query_item.dart';
import 'package:data_app/core/widgets/sample_table.dart';
import 'package:data_app/core/widgets/section_title.dart';
import 'package:data_app/core/widgets/table_info.dart';

class TestDataModePopup extends StatelessWidget {
  const TestDataModePopup({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (context) => const TestDataModePopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.8;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 360,
            constraints: BoxConstraints(maxHeight: maxH),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle('1. Tables and their purpose'),
                  const SizedBox(height: 6),
                  TableInfo(
                    'Departments',
                    'Different departments in the company.',
                    'dept_id, dept_name, location (city)',
                  ),
                  TableInfo(
                    'Employees',
                    'Employees and their department.',
                    'emp_id, full_name, job_title, salary, hire_date, dept_id, employment_type, status',
                  ),
                  TableInfo(
                    'Projects',
                    'Projects per department.',
                    'project_id, project_name, budget, dept_id, start_date, status',
                  ),
                  const SizedBox(height: 12),
                  SectionTitle('2. Sample data (Employees)'),
                  const SizedBox(height: 6),
                  const SampleTable(),
                  const SizedBox(height: 12),
                  SectionTitle('3. Example queries to try'),
                  const SizedBox(height: 6),
                  QueryItem(
                    'List all employees in Riyadh earning more than 12,000',
                  ),
                  QueryItem(
                    'Show all active projects in the Engineering department',
                  ),
                  QueryItem('Count the number of employees in each department'),
                  QueryItem('Find employees who are on contract employment'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Got it'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
