import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;

  ///Método para retornar a lista de cards
  ListView getNoteListView(){
    //define um stylo de texto
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount:count,
      itemBuilder:(BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child:ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child:Icon(Icons.keyboard_arrow_right),
            ),
            title: Text('Teste/Exemplo título', style: titleStyle),
            subtitle: Text('teste também'),
            trailing: Icon(Icons.delete,color: Colors.grey),
            onTap:(){
              debugPrint('clicou no card');
            }
          )
        );
      }
    );
  }

  ///Método para retornar o floating button da página e limpar o código do style
  FloatingActionButton getFloatingButton(){
    return FloatingActionButton(
        onPressed: (){
          debugPrint('clicou no floating');
        },
        tooltip: 'Adicionar nota',
        child: Icon(
          Icons.add,
        )
    );
  }

  //retorna o appBar da tela
  AppBar getAppBar(){
    return AppBar(
      title: Text('Note List'),
    );
  }


  //usando métodos separados, fica mais limpo o código da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getNoteListView(),
      floatingActionButton: getFloatingButton(),
    );
  }
}
