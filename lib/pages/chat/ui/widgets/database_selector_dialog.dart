import 'package:data_app/core/auth/auth_service.dart';
import 'package:data_app/core/database/database_service.dart';
import 'package:data_app/core/models/active_connection_model.dart';
import 'package:data_app/core/services/data_mode_service.dart';
import 'package:data_app/core/widgets/connect_data_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DatabaseSelectorDialog extends StatefulWidget {
  const DatabaseSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => const DatabaseSelectorDialog(),
    );
  }

  @override
  State<DatabaseSelectorDialog> createState() => _DatabaseSelectorDialogState();
}

class _DatabaseSelectorDialogState extends State<DatabaseSelectorDialog> {
  List<Map<String, dynamic>> _connections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) return;

      final connections = await DatabaseService.instance
          .getDbConnectionsForUser(user.email ?? '');
      if (mounted) {
        setState(() {
          _connections = connections;
          _isLoading = false;
        });

        if (DataModeService.instance.isConnectedDataMode &&
            connections.isNotEmpty &&
            ActiveConnectionModel.instance.activeConnection == null) {
          ActiveConnectionModel.instance.setActiveConnection(connections.first);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _connections = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addNewConnection() async {
    final result = await ConnectDataPopup.show(context);
    if (result == null || !context.mounted) return;

    final user = AuthService.instance.currentUser;
    await DatabaseService.instance.saveDbConnection(
      userEmail: user?.email ?? '',
      connectionInfo: result,
    );

    await _loadConnections();

    if (_connections.isNotEmpty &&
        ActiveConnectionModel.instance.activeConnection == null) {
      ActiveConnectionModel.instance.setActiveConnection(_connections.last);
    }
  }

  Future<void> _deleteConnection(Map<String, dynamic> conn) async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;

    await DatabaseService.instance.deleteDbConnection(
      conn['id'],
      userEmail: user.email ?? '',
    );
    await _loadConnections();

    final activeConn = ActiveConnectionModel.instance.activeConnection;
    if (activeConn != null && activeConn['id'] == conn['id']) {
      ActiveConnectionModel.instance.clearActiveConnection();
    }
  }

  String _getConnectionLabel(Map<String, dynamic> conn) {
    try {
      final info = conn['connection_info'];
      if (info is! Map<String, dynamic>) return 'Connection';
      final dbType = info['db_type'] as String?;
      final host = info['host'] as String?;
      return '${dbType?.toUpperCase() ?? 'DB'} - ${host ?? 'Unknown'}';
    } catch (_) {
      return 'Connection';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Material(
          color: Colors.transparent,
          child:
              Container(
                    width: 380,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF424141)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Data Source',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white54),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildModeToggle(),
                        const SizedBox(height: 16),
                        ListenableBuilder(
                          listenable: DataModeService.instance,
                          builder: (context, _) {
                            if (!DataModeService.instance.isConnectedDataMode) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Connections',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _isLoading
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      )
                                    : _connections.isEmpty
                                    ? _buildEmptyState()
                                    : ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 200,
                                        ),
                                        child: _buildConnectionsList(),
                                      ),
                                const SizedBox(height: 12),
                                _buildAddButton(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 200.ms)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                  ),
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return ListenableBuilder(
      listenable: DataModeService.instance,
      builder: (context, child) {
        final isTestMode = DataModeService.instance.isTestDataMode;
        return Row(
          children: [
            Expanded(
              child: _buildModeOption(
                'Test Data',
                isTestMode,
                () => DataModeService.instance.enableTestDataMode(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModeOption(
                'My Data',
                !isTestMode,
                () => DataModeService.instance.enableConnectedDataMode(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeOption(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
        if (label == 'My Data' && _connections.isNotEmpty) {
          ActiveConnectionModel.instance.setActiveConnection(
            _connections.first,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          'No connections yet. Add one below.',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildConnectionsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _connections.length,
      itemBuilder: (context, index) {
        final conn = _connections[index];
        return _buildConnectionItem(conn);
      },
    );
  }

  Widget _buildConnectionItem(Map<String, dynamic> conn) {
    return ListenableBuilder(
      listenable: ActiveConnectionModel.instance,
      builder: (context, child) {
        final isActiveNow =
            ActiveConnectionModel.instance.activeConnection?['id'] ==
            conn['id'];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isActiveNow
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActiveNow
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              ActiveConnectionModel.instance.setActiveConnection(conn);
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    isActiveNow
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 18,
                    color: isActiveNow ? Colors.white : Colors.white38,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _getConnectionLabel(conn),
                      style: TextStyle(
                        fontSize: 13,
                        color: isActiveNow ? Colors.white : Colors.white70,
                        fontWeight: isActiveNow
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.red.shade300.withValues(alpha: 0.7),
                    ),
                    onPressed: () => _showDeleteConfirmation(conn),
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> conn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF424141)),
        ),
        title: Text('Delete Connection', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this connection?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteConnection(conn);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addNewConnection,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(Icons.add, size: 18),
        label: Text('Add Connection'),
      ),
    );
  }
}
