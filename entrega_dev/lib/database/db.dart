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
      join(await getDatabasesPath(), 'entrega_dev.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_usuarios);
    await db.execute(_pedidos);
    await db.execute(_lojas);

    await db.execute(_insertUsuarios);
    await db.execute(_insertLojas);
    await db.execute(_insertPedidos);
  }

  String get _usuarios => '''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      senha TEXT NOT NULL
    );
  ''';

  String get _pedidos => '''
    CREATE TABLE pedidos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_loja INTEGER NOT NULL,
      id_usuario_entregador INTEGER, -- Pode ser nulo se PENDENTE
      status TEXT NOT NULL, -- 'PENDENTE', 'ACEITO', 'FINALIZADO'
      local_entrega TEXT NOT NULL,
      endereco_entrega TEXT NOT NULL,
      distancia_loja TEXT NOT NULL,
      valor REAL NOT NULL,

      FOREIGN KEY (id_loja) REFERENCES lojas (id),
      FOREIGN KEY (id_usuario_entregador) REFERENCES usuarios (id)
    );
  ''';

  String get _lojas => '''
    CREATE TABLE lojas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      endereco TEXT NOT NULL
    );
  ''';

  String get _insertUsuarios => '''
    INSERT INTO usuarios (nome, email, senha) VALUES
      ('Matheus', 'matheus@email.com', '123456'); 
      ('Pedro', 'pedro@email.com', '123456'); 
  ''';

  String get _insertLojas => '''
    INSERT INTO lojas (nome, endereco) VALUES
      ('Subway', 'Rua 28 de Setembro, 120');
  ''';

  String get _insertPedidos => '''
    INSERT INTO pedidos (id_loja, status, local_entrega, endereco_entrega, distancia_loja, valor) VALUES
      (
        1,
        'PENDENTE', 
        'Local de entrega - Centro',
        'Rua Imply, 518',
        '8 km até a loja',
        25.00
      );
  ''';
}
