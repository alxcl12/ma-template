import 'package:non_native/domain/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = "localdb.db";
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const _tableName = "bla";

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName(
    id INTEGER,
    name TEXT,
    price INTEGER,
    minAge INTEGER,
    maxAge INTEGER,
    publisher TEXT
    )
    ''');
  }

  Future<int> add(BoardGame entity) async {
    final db = await instance.database;
    return db.insert(_tableName, entity.toMap());
  }

  Future<int> update(BoardGame entity) async {
    var db = await instance.database;
    return db.update(_tableName, entity.toMap(),
        where: 'id=?', whereArgs: [entity.id]);
  }

  Future<int> delete(int id) async {
    var db = await instance.database;
    return db.delete(_tableName,
        where: 'id=?', whereArgs: [id]);
  }

  Future<int> deleteDatabase() async {
    var db = await instance.database;
    return db.delete(_tableName);
  }

  Future<List<BoardGame>> getAll() async {
    var db = await instance.database;
    List<Map> boardGames = await db.query(_tableName);
    return boardGames.isEmpty
        ? []
        : boardGames
            .map((e) => BoardGame.fromMap(e.cast<String, dynamic>()))
            .toList();
  }

  // Future<BoardGame> getBoardGame(int id) async {
  //   var db = await instance.database;
  //   List<Map> bgMap = await db.query(BoardGame.tableBoardGames,
  //       where: '${BoardGame.colId}=?', whereArgs: [id]);
  //
  //   return BoardGame.fromMap(bgMap[0].cast<String, dynamic>());
  // }
}
