import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:data_app/core/models/user_model.dart';

const String _kConnectionsKey = 'user_db_connections';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    await _createUserDbConnectionsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createUserDbConnectionsTable(db);
    }
  }

  Future<void> _createUserDbConnectionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_db_connections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT NOT NULL,
        connection_info TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<int> saveDbConnection({
    required String userEmail,
    required Map<String, dynamic> connectionInfo,
  }) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kConnectionsKey) ?? [];
      final entry = jsonEncode({
        'user_email': userEmail,
        'connection_info': connectionInfo,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
      list.add(entry);
      await prefs.setStringList(_kConnectionsKey, list);
      return list.length;
    }
    final db = await database;
    return db.insert('user_db_connections', {
      'user_email': userEmail,
      'connection_info': jsonEncode(connectionInfo),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getDbConnectionsForUser(
    String userEmail,
  ) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final list = prefs.getStringList(_kConnectionsKey) ?? [];
        final result = <Map<String, dynamic>>[];
        for (final s in list) {
          try {
            final m = jsonDecode(s) as Map<String, dynamic>;
            if (m['user_email'] == userEmail) {
              final connInfo = m['connection_info'];
              final connInfoMap = connInfo is Map<String, dynamic>
                  ? connInfo
                  : (connInfo is String
                        ? (jsonDecode(connInfo) as Map<String, dynamic>)
                        : <String, dynamic>{});
              result.add({
                'id': result.length,
                'user_email': m['user_email'],
                'connection_info': connInfoMap,
                'created_at': m['created_at'],
              });
            }
          } catch (_) {}
        }
        result.sort(
          (a, b) => (b['created_at'] as int).compareTo(a['created_at'] as int),
        );
        return result;
      } catch (_) {
        return [];
      }
    }
    final db = await database;
    final maps = await db.query(
      'user_db_connections',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) {
      final info = m['connection_info'] as String?;
      return {
        'id': m['id'],
        'user_email': m['user_email'],
        'connection_info': info != null
            ? jsonDecode(info) as Map<String, dynamic>
            : <String, dynamic>{},
        'created_at': m['created_at'],
      };
    }).toList();
  }

  Future<void> deleteDbConnection(
    dynamic connectionId, {
    String? userEmail,
  }) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kConnectionsKey) ?? [];
      final targetEmail = userEmail ?? '';

      int userIndex = 0;
      int? indexToRemove;
      for (var i = 0; i < list.length; i++) {
        try {
          final m = jsonDecode(list[i]) as Map<String, dynamic>;
          if (m['user_email'] == targetEmail) {
            if (userIndex == connectionId) {
              indexToRemove = i;
              break;
            }
            userIndex++;
          }
        } catch (_) {}
      }

      if (indexToRemove != null) {
        list.removeAt(indexToRemove);
        await prefs.setStringList(_kConnectionsKey, list);
      }
      return;
    }
    final db = await database;
    await db.delete(
      'user_db_connections',
      where: 'id = ?',
      whereArgs: [connectionId],
    );
  }

  Future<int> createUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
