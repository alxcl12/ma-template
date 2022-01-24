// import 'package:non_native/domain/data.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static const _dbName = "BoardGames.db";
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;
//
//   DatabaseHelper._init();
//
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, _dbName);
//
//     return await openDatabase(path, version: 1, onCreate: _onCreate);
//   }
//
//   _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE ${BoardGame.tableBoardGames}(
//     ${BoardGame.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
//     ${BoardGame.colName} TEXT,
//     ${BoardGame.colPrice} INTEGER,
//     ${BoardGame.colMinAge} INTEGER,
//     ${BoardGame.colMaxAge} INTEGER,
//     ${BoardGame.colPublisher} TEXT
//     )
//     ''');
//   }
//
//   Future<int> addBoardGame(BoardGame bg) async {
//     final db = await instance.database;
//     return db.insert(BoardGame.tableBoardGames, bg.toMap());
//   }
//
//   Future<int> updateBoardGame(BoardGame bg) async {
//     var db = await instance.database;
//     return db.update(BoardGame.tableBoardGames, bg.toMap(),
//         where: '${BoardGame.colId}=?', whereArgs: [bg.id]);
//   }
//
//   Future<int> deleteBoardGame(int id) async {
//     var db = await instance.database;
//     return db.delete(BoardGame.tableBoardGames,
//         where: '${BoardGame.colId}=?', whereArgs: [id]);
//   }
//
//   Future<int> deleteDatabase() async {
//     var db = await instance.database;
//     return db.delete(BoardGame.tableBoardGames);
//   }
//
//   Future<List<BoardGame>> getAllBoardGame() async {
//     var db = await instance.database;
//     List<Map> boardGames = await db.query(BoardGame.tableBoardGames);
//     return boardGames.isEmpty
//         ? []
//         : boardGames
//             .map((e) => BoardGame.fromMap(e.cast<String, dynamic>()))
//             .toList();
//   }
//
//   Future<BoardGame> getBoardGame(int id) async {
//     var db = await instance.database;
//     List<Map> bgMap = await db.query(BoardGame.tableBoardGames,
//         where: '${BoardGame.colId}=?', whereArgs: [id]);
//
//     return BoardGame.fromMap(bgMap[0].cast<String, dynamic>());
//   }
// }
