import 'package:flutter/material.dart';

class Tarefa {
  int? id;

  @required
  String? descricao;

  @required
  bool? pronta;

  Tarefa({id, descricao, pronta});

  Tarefa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];

    if (json['pronta'] == 0) {
      pronta = false;
    } else if (json['pronta'] == 1) {
      pronta = true;
    } else {
      pronta = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['descricao'] = descricao;
    json['pronta'] = pronta! ? 1 : 0;
    return json;
  }
}
