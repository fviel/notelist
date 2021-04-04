import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  String tituloAppBar;
  NoteDetail(this.tituloAppBar);
  @override
  _NoteDetailState createState() => _NoteDetailState(this.tituloAppBar);
}

class _NoteDetailState extends State<NoteDetail> {
  int count = 0;
  final List<String> _prioridades = ['Alta', 'Média', 'Baixa'];
  String tituloAppBar;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ///contrutora com parms
  _NoteDetailState(this.tituloAppBar);

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
          await voltarParaAUltimaTela();
        },
      ),
    );
  }

  void voltarParaAUltimaTela() async{
    await Navigator.pop(context);
  }

  //usando métodos separados, fica mais limpo o código do build
  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: () async{
        //caso eu queira fazer alguma ação no ato de voltar
        // do usuário, posso fazer aqui
        debugPrint('Usuário clicou no voltar');
        await voltarParaAUltimaTela();
      },
      child: Scaffold(
        appBar: getAppBar(),
        body: getNoteListView(),
      ),
    );
  }
}
