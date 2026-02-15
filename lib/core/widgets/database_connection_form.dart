import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'database_text_field.dart';
import 'database_type_selector.dart';

class DatabaseConnectionForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DbType dbType;
  final TextEditingController displayNameController;
  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController dbNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onChangeType;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isLarge;

  const DatabaseConnectionForm({
    super.key,
    required this.formKey,
    required this.dbType,
    required this.displayNameController,
    required this.hostController,
    required this.portController,
    required this.dbNameController,
    required this.usernameController,
    required this.passwordController,
    required this.onChangeType,
    required this.onSubmit,
    required this.onCancel,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    final padding = isLarge ? 36.0 : 24.0;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(padding),
          SizedBox(height: padding),
          ..._buildFields(padding),
          SizedBox(height: padding),
          _buildFooterNote(),
          SizedBox(height: padding + 8),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(double padding) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getConnectionTitle(),
              style: TextStyle(
                fontSize: isLarge ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onChangeType,
              child: Text(
                'Change database type',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 200.ms)
        .slideX(begin: -0.05, end: 0, duration: 250.ms);
  }

  List _buildFields(double padding) {
    return [
      DatabaseTextField(
        controller: hostController,
        label: 'Host',
        hint: 'localhost or db.example.com',
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        delay: 100,
        isLarge: isLarge,
      ),
      SizedBox(height: padding),
      DatabaseTextField(
        controller: portController,
        label: 'Port',
        hint: 'PostgreSQL: 5432, MySQL: 3306',
        keyboardType: TextInputType.number,
        delay: 150,
        isLarge: isLarge,
      ),
      SizedBox(height: padding),
      DatabaseTextField(
        controller: dbNameController,
        label: 'Database Name',
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        delay: 200,
        isLarge: isLarge,
      ),
      SizedBox(height: padding),
      DatabaseTextField(
        controller: usernameController,
        label: 'Username',
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        delay: 250,
        isLarge: isLarge,
      ),
      SizedBox(height: padding),
      DatabaseTextField(
        controller: passwordController,
        label: 'Password',
        obscureText: true,
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        delay: 300,
        isLarge: isLarge,
      ),
    ];
  }

  Widget _buildFooterNote() {
    return Text(
      'The system will build the connection URL internally.',
      style: TextStyle(fontSize: isLarge ? 12 : 11, color: Colors.white54),
    ).animate().fadeIn(duration: 200.ms, delay: 380.ms);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child:
              OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  )
                  .animate()
                  .fadeIn(duration: 200.ms, delay: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 200.ms, delay: 400.ms),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child:
              ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 200.ms, delay: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 200.ms, delay: 400.ms),
        ),
      ],
    );
  }

  String _getConnectionTitle() {
    return switch (dbType) {
      DbType.postgresql => 'PostgreSQL Connection',
      DbType.mysql => 'MySQL Connection',
    };
  }
}
