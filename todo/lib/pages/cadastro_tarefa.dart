import 'package:flutter/material.dart';
import 'package:todo/dao/tarefa_dao.dart';
import 'package:todo/model/tarefa_model.dart';

class CadastroTarefa extends StatefulWidget {
  const CadastroTarefa({Key? key}) : super(key: key);

  @override
  State<CadastroTarefa> createState() => _CadastroTarefaState();
}

class _CadastroTarefaState extends State<CadastroTarefa> {
  final _form = GlobalKey<FormState>();

  Tarefa tarefa = Tarefa();

  TarefaDao tarefaDao = TarefaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tarefas'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: _createForm(context),
      ),
    );
  }

  Form _createForm(context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _createTextField(),
          _buttonSave(context),
        ],
      ),
    );
  }

  TextFormField _createTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Descrição",
        hintText: "Informe a descrição de sua tarefa",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Descrição é obrigatória';
        }
        return null;
      },
      onSaved: (value) {
        tarefa.descricao = value;
      },
    );
  }

  RaisedButton _buttonSave(BuildContext context) {
    return RaisedButton(
      color: Colors.black,
      child: const Text(
        'Salvar',
        style: TextStyle(fontSize: 15.0, color: Colors.white),
      ),
      onPressed: () => _save(context),
    );
  }

  void _save(BuildContext context) async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      tarefa.pronta = false;
      var id = await tarefaDao.insert(tarefa);
      print(id);
      tarefa.id = id;
      Navigator.pop(context, tarefa);
    }
  }
}
