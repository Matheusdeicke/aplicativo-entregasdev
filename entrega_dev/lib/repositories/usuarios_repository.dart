import 'package:entrega_dev/models/usuario.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqlite_api.dart';

class UsuariosRepository extends ChangeNotifier {
  late Database db;
  List<Usuario> usuarios = [];
}