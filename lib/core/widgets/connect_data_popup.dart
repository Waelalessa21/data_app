import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:data_app/core/layout/responsive_utils.dart';

import 'database_type_selector.dart';
import 'database_connection_form.dart';

export 'database_type_selector.dart' show DbType;

class ConnectDataPopup extends StatefulWidget {
  const ConnectDataPopup({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      useRootNavigator: true,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (context) => const ConnectDataPopup(),
    );
  }

  @override
  State<ConnectDataPopup> createState() => _ConnectDataPopupState();
}

class _ConnectDataPopupState extends State<ConnectDataPopup> {
  final _formKey = GlobalKey<FormState>();
  DbType? _selectedDbType;
  final _displayNameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _dbNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _dbNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onDbTypeSelected(DbType value) {
    setState(() {
      _selectedDbType = value;
      _portController.text = '${_defaultPortFor(value)}';
    });
  }

  void _onChangeType() {
    setState(() => _selectedDbType = null);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_buildConnectionInfo());
    }
  }

  int _defaultPortFor(DbType t) {
    return switch (t) {
      DbType.postgresql => 5432,
      DbType.mysql => 3306,
    };
  }

  Map<String, dynamic> _buildConnectionInfo() {
    final dbType = _selectedDbType!;
    final typeStr = switch (dbType) {
      DbType.postgresql => 'postgresql',
      DbType.mysql => 'mysql',
    };

    return {
      'db_type': typeStr,
      'host': _hostController.text.trim(),
      'port': _portController.text.trim(),
      'database_name': _dbNameController.text.trim(),
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = isLargeScreen(context);
    final maxW = isLarge ? 440.0 : MediaQuery.sizeOf(context).width - 32;
    final maxH = MediaQuery.sizeOf(context).height * 0.9;
    final padding = isLarge ? 36.0 : 24.0;
    final borderRadius = isLarge ? 16.0 : 10.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isLarge ? 24 : 16),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: maxW,
            constraints: BoxConstraints(maxHeight: maxH),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: const Color(0xFF424141), width: 1),
            ),
            child:
                SingleChildScrollView(
                      child: _selectedDbType == null
                          ? DatabaseTypeSelector(
                              onTypeSelected: _onDbTypeSelected,
                              isLarge: isLarge,
                            )
                          : DatabaseConnectionForm(
                              formKey: _formKey,
                              dbType: _selectedDbType!,
                              displayNameController: _displayNameController,
                              hostController: _hostController,
                              portController: _portController,
                              dbNameController: _dbNameController,
                              usernameController: _usernameController,
                              passwordController: _passwordController,
                              onChangeType: _onChangeType,
                              onSubmit: _submit,
                              onCancel: () => Navigator.of(context).pop(),
                              isLarge: isLarge,
                            ),
                    )
                    .animate()
                    .fadeIn(duration: 200.ms)
                    .scale(
                      begin: const Offset(0.96, 0.96),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutCubic,
                    ),
          ),
        ),
      ),
    );
  }
}
