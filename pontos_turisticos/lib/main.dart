import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pontos_turisticos/repository/dataRepository.dart';
import 'models/pontos_turisticos.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

const BoldStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cadastro de Pontos Turisticos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeList());
  }
}

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _favoritos = Set<String>();
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pontos Turisticos"),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data.documents);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPontosTuristicos();
        },
        tooltip: 'Adicionar Ponto Turistico',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addPontosTuristicos() {
    AlertDialogWidget dialogWidget = AlertDialogWidget();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Adicionar Ponto Turistico"),
              content: dialogWidget,
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancelar")),
                FlatButton(
                    onPressed: () {
                      PontosTuristicos ponto = PontosTuristicos(
                          dialogWidget.ptTuristicoNome,
                          dialogWidget.ptTuristicoAno,
                          dialogWidget.ptTuristicoEnd);
                      repository.addPontoTuristico(ponto);
                      Navigator.of(context).pop();
                    },
                    child: Text("Adicionar")),
              ]);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final ponto = PontosTuristicos.fromSnapshot(snapshot);
    if (ponto == null) {
      return Container();
    }
    /*final Set<String> _favoritos = _loadFavorites();*/
    final alreadySaved = _favoritos.contains(ponto.toString());

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
            child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                trailing: Icon(
                  // NEW from here...
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                ),
                title: Text(ponto.nome == null ? "" : ponto.nome,
                    style: BoldStyle),
                subtitle: Text(
                    ponto.ano == null ? "" : "Inauguração: " + ponto.ano,
                    style: BoldStyle),
                onTap: () {
                  setState(() {
                    if (alreadySaved) {
                      _favoritos.remove(ponto.toString());
                    } else {
                      _favoritos.add(ponto.toString());
                    }
                  });
                },
              ),
              Text(
                "Localização: " + ponto.endereco,
              ),
            ],
          ),
          /*onTap: () {
                _navigate(BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroPonto(ponto),
                      ));
                }

                _navigate(context);
              },*/
          highlightColor: Colors.green,
          splashColor: Colors.blue,
        )));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _favoritos.map(
            (String pontosTuristicos) {
              return ListTile(
                title: Text(
                  pontosTuristicos.substring(17).replaceAll(">", ""),
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Favoritos'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}

class AlertDialogWidget extends StatefulWidget {
  String ptTuristicoNome;
  String ptTuristicoAno;
  String ptTuristicoEnd;

  @override
  _AlertDialogWidgetState createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nome do ponto turistico"),
            onChanged: (text) => widget.ptTuristicoNome = text,
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Ano de Inauguração"),
            onChanged: (text) => widget.ptTuristicoAno = text,
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Localização"),
            onChanged: (text) => widget.ptTuristicoEnd = text,
          ),
        ],
      ),
    );
  }
}
