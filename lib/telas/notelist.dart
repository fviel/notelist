import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notelist/telas/notedetail.dart';
import 'package:notelist/entities/note.dart';
import 'package:notelist/utils/databasehelper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  //helper do db para chamar o métodos
  final DatabaseHelper dbHelper = DatabaseHelper();

  //lista de notas a serem exibidas
  List<Note> noteList;
  int count = 0;

  //usando métodos separados, fica mais limpo o código da tela
  @override
  Widget build(BuildContext context) {
    //inicialização da list de notas
    if (noteList == null) {
      noteList = <Note>[];
    }
    return Scaffold(
      appBar: getAppBar(),
      body: getNoteListView(),
      floatingActionButton: getFloatingButton(),
    );
  }

  ///Método para retornar a lista de cards
  ListView getNoteListView() {
    //define um stylo de texto
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      getCorPrioridade(this.noteList[position].prioridade),
                  child: getIconePrioridade(this.noteList[position].prioridade),
                ),
                title: Text(this.noteList[position].titulo, style: titleStyle),
                subtitle: Text(this.noteList[position].descricao),

                ///O GestureDetector consegue identificar eventos no elemento
                ///que originalmente não os detecta
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey),
                  onTap: () {
                    _excluir(context, this.noteList[position]);
                  },
                ),
                onTap: () {
                  debugPrint('clicou no card');
                  navegarParaDetalhesCard('Editar a anotação');
                },
              ));
        });
  }

  ///Método para retornar o floating button da página e limpar o código do style
  FloatingActionButton getFloatingButton() {
    return FloatingActionButton(
        onPressed: () {
          debugPrint('clicou no floating');
          // await Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return NoteDetail();
          // }));
          navegarParaDetalhesCard('Nova anotação');
        },
        tooltip: 'Adicionar nota',
        child: Icon(
          Icons.add,
        ));
  }

  //retorna o appBar da tela
  AppBar getAppBar() {
    return AppBar(
      title: Text('Note List'),
    );
  }

  void navegarParaDetalhesCard(String tituloAppBar) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(tituloAppBar);
    }));
  }

  ///Retorna a cor a ser utilizada no card conforme a prioridade
  Color getCorPrioridade(int prioridade) {
    Color resposta;
    switch (prioridade) {
      case 1:
        {
          resposta = Colors.red;
          break;
        }
      case 2:
        {
          resposta = Colors.yellow;
          break;
        }
      case 3:
        {
          resposta = Colors.green;
          break;
        }
      default:
        {
          resposta = Colors.green;
          break;
        }
    }
    return resposta;
  }

  ///Retorna a cor a ser utilizada no card conforme a prioridade
  Icon getIconePrioridade(int prioridade) {
    Icon resposta;
    switch (prioridade) {
      case 1:
        {
          resposta = Icon(Icons.looks_one);
          break;
        }
      case 2:
        {
          resposta = Icon(Icons.looks_two);
          break;
        }
      case 3:
        {
          resposta = Icon(Icons.looks_3);
          break;
        }
      default:
        {
          resposta = Icon(Icons.looks_3);
          break;
        }
    }
    return resposta;
  }

  void _excluir(BuildContext context, Note note) async {
    int resultado = await dbHelper.excluirNota(note.id);
    if (resultado != 0) {
      _showSnackBar(context, 'Nota excluída com sucesso');
      //TODO atualizar o listview
    }
  }

  void _showSnackBar(BuildContext context, String mesg) {
    final snackBar = SnackBar(content: Text(mesg));
    //Scaffold.of(context).showSnackBar(snackbar); // deprecado!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
