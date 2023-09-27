import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/model/tarefa_model.dart';

class TarefaDao {
  Future<Database> createOrGetDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, '/tarefas.db');
    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database database, int version) async {
    await database.execute(
      "CREATE TABLE tarefa ("
      "id INTEGER PRIMARY KEY,"
      "descricao TEXT,"
      "pronta INTEGER"
      ")",
    );
  }

  Future<int> insert(Tarefa tarefa) async {
    var database = await createOrGetDatabase();
    return database.insert(
      'tarefa',
      tarefa.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tarefa>> list() async {
    var database = await createOrGetDatabase();
    var result = await database.query('tarefa');
    List<Tarefa> tarefas = <Tarefa>[];
    for (var i = 0; i < result.length; i++) {
      tarefas.add(Tarefa.fromJson(result[i]));
    }
    return tarefas;
  }

  Future<List<Tarefa>> listFilter(String filter) async {
    var vWhere = "pronta is not null";
    if (filter == 'PE') {
      vWhere = "pronta = 0";
    } else if (filter == 'RE') {
      vWhere = "pronta = 1";
    }
    var database = await createOrGetDatabase();
    var result = await database.query('tarefa', where: vWhere);
    List<Tarefa> tarefas = <Tarefa>[];
    for (var i = 0; i < result.length; i++) {
      tarefas.add(Tarefa.fromJson(result[i]));
    }
    return tarefas;
  }

  Future<void> update(Tarefa tarefa) async {
    var database = await createOrGetDatabase();
    await database.update('tarefa', tarefa.toJson(),
        where: 'id = ?', whereArgs: [tarefa.id]);
  }
}
