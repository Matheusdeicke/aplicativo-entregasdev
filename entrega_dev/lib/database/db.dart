
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  // Criar um construtor com acesso privado
  Db._();

  static final Db instante = Db._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join (await getDatabasesPath(), 'entrega_dev.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_usuarios);
    await db.execute(_pedidos);
    await db.execute(_lojas);
    await db.execute(_historico);
  }

  String get _usuarios => '''

  ''';

  String get _pedidos => '''

  ''';

  String get _lojas => '''

  ''';

  String get _historico => '''

  ''';
}