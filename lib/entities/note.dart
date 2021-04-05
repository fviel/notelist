class Note {
  int _id;
  String _titulo;
  String _descricao;
  String _data;
  int _prioridade;

  ///Se eu quero que um parm seja opcional para ser informado,
  ///basta colocar entre [].
  ///No exemplo abaixo, a descrição ficou opcional
  Note(this._titulo, this._descricao, this._data, [this._prioridade]);

  //Named constructor, neste caso, estou passando o id
  Note.whithId(this._id, this._titulo, this._descricao, this._data,
      [this._prioridade]);

  ///--- Gets e Sets
  int get prioridade => _prioridade;

  set prioridade(int value) {
    if ((value >= 0) && (value < 3)) {
      _prioridade = value;
    } else {
      _prioridade = 2;
    }
  }

  // ignore: unnecessary_getters_setters
  String get data => _data;

  // ignore: unnecessary_getters_setters
  set data(String value) {
    _data = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    if (value.length <= 256) {
      _descricao = value;
    } else {
      _descricao = value.substring(0, 255);
    }
  }

  String get titulo => _titulo;

  set titulo(String value) {
    //somente seta se o valor informado for menor que 255
    if (value.length <= 256) {
      _titulo = value;
    } else {
      _titulo = value.substring(0, 255);
    }
  }

  ///id  não ter setter, pq o db vai definir
  int get id => _id;

//------

  ///Converte this em map, para usar no BD
  ///o segundo parm é dynamic, pois o map está mapeando para
  ///string e int, ou seja, se fosse só para String, podia
  ///ser map<String, String>
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['titulo'] = _titulo;
    map['descricao'] = _descricao;
    map['prioridade'] = _prioridade;
    map['data'] = _data;
    return map;
  }

  ///Named constructor que extrai o dataset do BD, que
  ///sempre é um map
  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._titulo = map['titulo'];
    this._descricao = map['descricao'];
    this._data = map['data'];
    this._prioridade = map['prioridade'];
  }
}
