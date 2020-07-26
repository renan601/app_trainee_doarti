import 'package:cloud_firestore/cloud_firestore.dart';

class PontosTuristicos {
  String nome;
  String ano;
  String endereco;
  DocumentReference reference;

  PontosTuristicos(this.nome, this.ano, this.endereco, {this.reference});

  factory PontosTuristicos.fromSnapshot(DocumentSnapshot snapshot) {
    PontosTuristicos novoPonto = PontosTuristicos.fromJson(snapshot.data);
    novoPonto.reference = snapshot.reference;
    return novoPonto;
  }

  factory PontosTuristicos.fromJson(Map<dynamic, dynamic> json) =>
      _pontosTuristicosFromJson(json);

  Map<String, dynamic> toJson() => _pontosTuristicosToJson(this);
  @override
  String toString() => "PontosTuristicos<$nome>";
}

PontosTuristicos _pontosTuristicosFromJson(Map<dynamic, dynamic> json) {
  return PontosTuristicos(
    json['nome'] as String,
    json['ano'] as String,
    json['endereco'] as String,
  );
}

Map<String, dynamic> _pontosTuristicosToJson(PontosTuristicos instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'ano': instance.ano,
      'endereco': instance.endereco,
    };
