import 'package:flutter/material.dart';
import 'package:todo/dao/tarefa_dao.dart';
import 'package:todo/model/tarefa_model.dart';
import 'package:todo/pages/cadastro_tarefa.dart';

import '../model/tarefa_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Tarefa> tarefas = [];
  TarefaDao tarefaDao = TarefaDao();
  String _filter = 'AM';

  @override
  void initState() {
    _findTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Control'), actions: [_simplePopup()]),
      body: _createList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _routerRegister,
      ),
    );
  }

  void _select(String val) async {
    var res = await tarefaDao.listFilter(val);
    _filter = val;
    setState(() => {tarefas = res});
  }

  Widget _simplePopup() => PopupMenuButton<String>(
        initialValue: 'AM',
        onSelected: _select,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'AM',
            child: Text("Ambas"),
          ),
          PopupMenuItem(
            value: 'PE',
            child: Text("Pendente"),
          ),
          PopupMenuItem(
            value: 'RE',
            child: Text("Realizada"),
          ),
        ],
      );

  ListView _createList() {
    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: _CreateTask,
    );
  }

  Widget _CreateTask(BuildContext context, int index) {
    final tarefa = tarefas[index];
    return _CreateItemList(tarefa);
  }

  CheckboxListTile _CreateItemList(Tarefa tarefa) {
    return CheckboxListTile(
      title: Text(tarefa.descricao!),
      value: tarefa.pronta,
      onChanged: (value) {
        setState(() {
          tarefa.pronta = value;
        });
        tarefaDao.update(tarefa);
      },
    );
  }

  void _routerRegister() async {
    var res = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return CadastroTarefa();
      }),
    );

    if (_filter == 'AM' || _filter == 'PE') {
      var aux = Tarefa();

      aux.id = res.id;
      aux.descricao = res.descricao;
      aux.pronta = false;

      setState(() {
        tarefas.add(aux);
      });
    }
  }

  void _findTask() async {
    var result = await tarefaDao.list();
    setState(() => tarefas = result);
  }
}
