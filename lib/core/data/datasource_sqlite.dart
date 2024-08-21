import 'package:sqflite/sqflite.dart';

import '../application/datasources/datasource.dart';

final class DatasourceSqlite implements Datasource {
  final file = 'ff81150b-d03c-4f01-bea4-c560821a7138.db';
  final placesTable = 'places';

  String _getPlacesSchema() {
    return '''
      CREATE TABLE $placesTable (
        guid TEXT NOT NULL DEFAULT '',
        tipo TEXT NOT NULL DEFAULT '',
        titulo TEXT NOT NULL DEFAULT '',
        descricao TEXT NOT NULL DEFAULT '',
        lat REAL NOT NULL DEFAULT 0,
        long REAL NOT NULL DEFAULT 0,
        criadoEm TEXT NOT NULL DEFAULT ''
      );
    ''';
  }

  Future<void> _createDb(Database db, int version) async {
    return await db.execute(_getPlacesSchema());
  }

  Future<Database> _getDb() async {
    final sqlitePath = await getDatabasesPath();
    final dbPath = '$sqlitePath/$file';
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDb,
    );
  }

  @override
  Future<void> save(Map<String, dynamic> data) async {
    final db = await _getDb();
    await db.insert(placesTable, data);
    await db.close();
  }

  @override
  Future<void> remove(String key, String value) async {
    final db = await _getDb();
    await db.delete(placesTable, where: '$key = ?', whereArgs: [value]);
    await db.close();
  }

  @override
  Future<List<Map<String, dynamic>>> list() async {
    final db = await _getDb();
    final data = await db.query(placesTable);
    await db.close();
    if (data.isEmpty) return [];
    return data;
  }
}
