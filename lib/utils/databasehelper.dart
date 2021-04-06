//import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
//import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:notelist/entities/note.dart';

class DatabaseHelper {
  //Singleton DatabaseHelper
  static DatabaseHelper _databaseHelper;

  //Singleton do DB
  static Database _database;

  //colunas e vars do meu db
  final String noteTable = 'note_table';
  final String colId = 'id';
  final String colTitulo = 'titulo';
  final String colDescricao = 'descricao';
  final String colPrioridade = 'prioridade';
  final String colData = 'data';

  ///Named cosntructor, apenas para criar esta instancia pela var acima e
  ///poder ser usado na factory
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    ///se null a minha var static deste singleton, chama o named constructor
    ///para criar minha instancia atual
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
      print('singleton do dbhelper criado...');
    }
    return _databaseHelper;
  }

  //-----------------------------------------------------------
  //Bloco de métodos para criar o DB e retornar sua instancia
  //-----------------------------------------------------------

  ///Retorna a instancia do singleton do meu database,
  ///instancia se necessário
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Inicializa o database
  Future<Database> initializeDatabase() async {
    //1. Obter o path para o arquivo do DB usando o plugin path
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes_database.db';

    //Abre e cria o db
    var notesDb = await openDatabase(path, onCreate: _createDb, version: 1);
    return notesDb;
  }

  ///Cria a tabela
  void _createDb(Database db, int newVersion) async {
    //roda o SQL de create table
    await db.execute('CREATE TABLE $noteTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitulo TEXT,'
        '$colDescricao TEXT,'
        '$colPrioridade INTEGER,'
        '$colData TEXT)');
  }

//-----------------------------------------------------------
//Bloco de métodos para realizar operações no BD
//-----------------------------------------------------------


//Fetch - Obtem todos os elementos da tabela, ou seja, um list de Map's
  Future<List<Map<String, dynamic>>> listarTodasNotasOrdenandoPorPrioridade() async {
    Database db = await this.database;

    ///Há duas formas de rodar as queries no sqflite, raw comando ou por métodos, passando parms, exemplos:
    ///db.rawQuery('SELECT * FROM $noteTable');
    ///ou
    ///db.query('$noteTable');
    ///...
    ///db.insert(parm1, parm2 ...) VS db.rawInsert(...)
    ///db.delete(parm1, parm2 ...) VS db.rawDelete(...)
    ///db.update(parm1, parm2 ...) VS db.rawUpdate
    ///Tanto faz, dá na mesma...

    //Forma 1 de montar a query - SQL completo na mão
    //var resultadoForma1 = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPrioridade ASC');

    //Forma 2 de montar a query - usando métodos prontos
    var resultadoForma2 =
        await db.query(noteTable, orderBy: '$colPrioridade ASC');
    return resultadoForma2;
  }

  Future<List<Note>> getListaNotes() async{
    var noteMapList = await listarTodasNotasOrdenandoPorPrioridade();
    int count = noteMapList.length;
    List<Note> noteList= <Note>[];
    for(int i = 0; i < count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

//Insert
  Future<int> adicionarNota(Note note) async {
    Database db = await this.database;
    var resultado = await db.insert(noteTable, note.toMap());
    return resultado;
  }

//Update
  Future<int> atualizarNota(Note note) async {
    Database db = await this.database;
    var resultado = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return resultado;
  }

//Delete
  Future<int> excluirNota(int id) async {
    Database db = await this.database;
    var resultado =
        await db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    //var resultado = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return resultado;
  }

//Count
  Future<int> contarNotas() async {
    Database db = await this.database;
    List<Map<String, dynamic>> contagem =
        await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int resultado = Sqflite.firstIntValue(contagem);
    return resultado;
  }
}

//Versão mais moderna de inicialização do db, usando path, não path_provider
// void initializeDatabaseVersaoMaisModerna() async {
//   // Open the database and store the reference.
//   final Future<Database> database = openDatabase(
//     // Set the path to the database. Note: Using the `join` function from the
//     // `path` package is best practice to ensure the path is correctly
//     // constructed for each platform.
//     join(await getDatabasesPath(), 'notes_database.db'),
//     // When the database is first created, create a table to store dogs.
//     onCreate: (db, version) {
//       return db.execute(
//         //"CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
//           'CREATE TABLE $noteTable('
//               '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
//               '$colTitulo TEXT,'
//               '$colDescricao TEXT,'
//               '$colPrioridade INTEGER,'
//               '$colData TEXT)'
//       );
//     },
//     // Set the version. This executes the onCreate function and provides a
//     // path to perform database upgrades and downgrades.
//     version: 1,
//   );
// }
