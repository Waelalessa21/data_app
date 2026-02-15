import 'package:flutter/foundation.dart';

class ActiveConnectionModel extends ChangeNotifier {
  ActiveConnectionModel._();
  static final ActiveConnectionModel instance = ActiveConnectionModel._();

  Map<String, dynamic>? _activeConnection;

  Map<String, dynamic>? get activeConnection => _activeConnection;
  bool get hasActiveConnection => _activeConnection != null;

  void setActiveConnection(Map<String, dynamic>? connection) {
    _activeConnection = connection;
    notifyListeners();
  }

  void clearActiveConnection() {
    _activeConnection = null;
    notifyListeners();
  }

  String getConnectionLabel() {
    if (_activeConnection == null) return 'No connection';
    final dbType = _activeConnection!['db_type'] as String?;
    final host = _activeConnection!['host'] as String?;
    return '${dbType?.toUpperCase() ?? 'DB'} - ${host ?? 'Unknown'}';
  }
}
