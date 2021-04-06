import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notelist/entities/note.dart';
import 'package:notelist/utils/databasehelper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  //usa pra poder receber o título da appbar vindo da tela que fez o push
  final String tituloAppBar;
  final Note note;



  NoteDetail(this.note, this.tituloAppBar);
  @override
  _NoteDetailState createState() => _NoteDetailState(this.note, this.tituloAppBar);
}

class _NoteDetailState extends State<NoteDetail> {
  //helper do db para chamar o métodos
  final DatabaseHelper dbHelper = DatabaseHelper();

  final List<String> _prioridades = ['Alta', 'Média', 'Baixa'];
  String tituloAppBar;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ///contrutora com parms
  _NoteDetailState(this.note, this.tituloAppBar);

  //Método Build() usando métodos separados, fica mais limpo o código
  @override
  Widget build(BuildContext context) {
    //define um estilo de texto
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    //atualiza minhas controllers com os dados recebidos da telas de listar
    titleController.text = note.titulo;
    descriptionController.text = note.descricao;

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
            value: getPrioridadeComoString(note.prioridade),
            onChanged: (valorSelecionadoPeloUsuario) {
              setState(() {
                debugPrint('Valor selecionado no dropdown: $valorSelecionadoPeloUsuario');
                updatePrioridadeComoInt(valorSelecionadoPeloUsuario);
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
                updateTitulo();
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
                //como estou usando a controller, não preciso passar o valor pra função
                updateDescricao();
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

  void updatePrioridadeComoInt(String prioridade){
    int resposta;
    switch(prioridade){
      case 'Alta': {
        note.prioridade = 1;
        break;
      }
      case 'Média': {
        note.prioridade = 2;
        break;
      }
      case 'Baixa': {
        note.prioridade = 3;
        break;
      }
      default:{
        note.prioridade = 3;
        break;
      }
    }
  }

  String getPrioridadeComoString(int prioridade){
    String resposta;
    switch(prioridade){
      case 1: {
        resposta = _prioridades[0];
        break;
      }
      case 2: {
        resposta = _prioridades[1];
        break;
      }
      case 3: {
        resposta = _prioridades[2];
        break;
      }
      default:{
        resposta = _prioridades[2];
        break;
      }
    }
    return resposta;
  }

  void updateTitulo(){
    note.titulo = titleController.text;
  }

  void updateDescricao(){
    note.descricao = descriptionController.text;
  }

  void _saveUpdate() async{
    voltarParaAUltimaTela();

    int resultado;
    if(note.id != null){
      //UPDATE
      resultado = await dbHelper.atualizarNota(note);
    }else{
      //INSERT
      resultado = await dbHelper.adicionarNota(note);
    }

    if(resultado!=0){
      //sucesso
      _showAlertDialog('Status','Anotação salva com sucesso');
    }else{
      //falha
      _showAlertDialog('Status','Falha ao salvar anotação');
    }
  }

  void _showAlertDialog(String titulo, String conteudo){
    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(conteudo),
    );
    showDialog(
      context: context,
      builder: (_) =>alertDialog,
    );
  }

  void _showSnackBar(BuildContext context, String mesg){
    final snackBar = SnackBar(content: Text(mesg));
    //Scaffold.of(context).showSnackBar(snackbar); // deprecado!
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
