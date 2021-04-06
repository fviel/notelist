import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notelist/entities/note.dart';
import 'package:notelist/utils/databasehelper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  //usa pra poder receber o título da appbar vindo da tela que fez o push
  final String tituloAppBar;



  NoteDetail(this.tituloAppBar);
  @override
  _NoteDetailState createState() => _NoteDetailState(this.tituloAppBar);
}

class _NoteDetailState extends State<NoteDetail> {
  //helper do db para chamar o métodos
  final DatabaseHelper dbHelper = DatabaseHelper();

  final List<String> _prioridades = ['Alta', 'Média', 'Baixa'];
  String tituloAppBar;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ///contrutora com parms
  _NoteDetailState(this.tituloAppBar);

  //Método Build() usando métodos separados, fica mais limpo o código
  @override
  Widget build(BuildContext context) {

    return WillPopScope (
      onWillPop: () {
        //caso eu queira fazer alguma ação no ato de voltar
        // do usuário, posso fazer aqui
        debugPrint('Usuário clicou no voltar');
        voltarParaAUltimaTela();
      },
      child: Scaffold(
        appBar: getAppBar(),
        body: getNoteListView(),
      ),
    );
  }

  ///-----------------------

  ///Método para retornar a lista de cards
  Padding getNoteListView() {
    //define um estilo de texto
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: <Widget>[
          ListTile(
              title: DropdownButton(
                hint: Text('Prioridades'),
            icon: Icon(
              Icons.cached,
              color: Colors.red,
            ),
            elevation: 2,
            dropdownColor: Colors.red[100],
            autofocus: true,

            items: _prioridades.map((String valorComoString) {
              return DropdownMenuItem<String>(
                  value: valorComoString, child: Text(valorComoString));
            }).toList(),
            style: textStyle,
            //valor default
            value: 'Baixa',
            onChanged: (valorSelecionado) {
              setState(() {
                debugPrint('Valor selecionado no dropdown: $valorSelecionado');
              });
            },
          )
          ),


          Padding(
            padding: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Título",
                labelStyle: textStyle,
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  gapPadding: 1.0,
                )
              ),
              style: textStyle,
              onChanged: (valor){
                debugPrint('Alterado o título para: $valor');
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: textStyle,
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    gapPadding: 1.0,
                  )
              ),
              style: textStyle,
              onChanged: (valor){
                debugPrint('Alterada a descrição para: $valor');
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: Row(
              children:<Widget>[
                Expanded(
                  child: TextButton(
                    child: Text('Salvar'),
                    onPressed: (){
                      setState(() {
                        debugPrint('Usuário clicou em salvar');
                      });
                    },
                  ),
                ),

                Expanded(
                  child: TextButton(
                    child: Text('Excluir'),
                    onPressed: (){
                      setState(() {
                        debugPrint('Usuário clicou em excluir');
                      });
                    },
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );

    //   return ListView.builder(
    //       itemCount:count,
    //       itemBuilder:(BuildContext context, int position){
    //         return Card(
    //             color: Colors.white,
    //             elevation: 2.0,
    //             child:ListTile(
    //                 leading: CircleAvatar(
    //                   backgroundColor: Colors.yellow,
    //                   child:Icon(Icons.keyboard_arrow_right),
    //                 ),
    //                 title: Text('Teste/Exemplo título', style: textStyle),
    //                 subtitle: Text('teste também'),
    //                 trailing: Icon(Icons.delete,color: Colors.grey),
    //                 onTap:(){
    //                   debugPrint('clicou no card');
    //                 }
    //             )
    //         );
    //       }
    //   );
  }

  //retorna o appBar da tela
  /// Totalmente desnecessário o iconButton, o appBar já faria o pop
  /// automaticamente, mas fiz para poder brincar de retornar outros
  /// itens da stack
  AppBar getAppBar() {
    return AppBar(
      title: Text(tituloAppBar),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed:() async{
          voltarParaAUltimaTela();
        },
      ),
    );
  }

  void voltarParaAUltimaTela() {
    Navigator.pop(context);
  }

  ///Retorna a cor a ser utilizada no card conforme a prioridade
  Color getCorPrioridade(int prioridade){
    Color resposta;
    switch(prioridade){
      case 1: {
      resposta = Colors.red;
      break;
    }
      case 2: {
        resposta = Colors.yellow;
        break;
      }
      case 3: {
        resposta = Colors.green;
        break;
      }
      default:{
        resposta = Colors.green;
        break;
      }
    }
    return resposta;
  }

  ///Retorna a cor a ser utilizada no card conforme a prioridade
  Icon getIconePrioridade(int prioridade){
    Icon resposta;
    switch(prioridade){
      case 1: {
        resposta = Icon(Icons.looks_one);
        break;
      }
      case 2: {
        resposta = Icon(Icons.looks_two);
        break;
      }
      case 3: {
        resposta = Icon(Icons.looks_3);
        break;
      }
      default:{
        resposta = Icon(Icons.looks_3);
        break;
      }
    }
    return resposta;
  }

  void _excluir(BuildContext contex, Note note) async{
    int resultado = await dbHelper.excluirNota(note.id);
    if(resultado != 0 ){
      _showSnackBar(context, 'Nota excluída com sucesso');
      //TODO atualizar o listview
    }
  }

  void _showSnackBar(BuildContext context, String mesg){
    final snackBar = SnackBar(content: Text(mesg));
    //Scaffold.of(context).showSnackBar(snackbar); // deprecado!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



}
