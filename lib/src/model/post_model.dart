import 'package:cloud_firestore/cloud_firestore.dart';

//A classe chamada Post modela a estrutura de dados de uma nova publicação.
class PostModel {
  String? id; //Identificador único do post.
  bool? coleira; //Indica se o animal tem uma coleira.
  String? corPelagem; //Cor da pelagem do animal.
  String? porte; //Porte do animal.
  bool? machucado; //Indica se o animal está machucado.
  bool? desnutrido; // Indica se o animal está desnutrido.
  bool? docil; //Indica se o animal é dócil.
  String? usuario; //Nome do usuário que fez o post.
  List<dynamic>? fotos; //URL da foto do animal.
  GeoPoint? localizacao; //GeoPoint representando a localização do animal.
  String? dataHora; //Data e hora em que o post foi criado.
  int? like; //Contagem de curtidas do post.
  int? dislike; //Contagem de descurtidas do post.
  String? perfil;

//Cada instância da classe Post representa uma entrada na coleção do Firestore.
  PostModel(
      {this.id,
      this.coleira,
      this.corPelagem,
      this.porte,
      this.machucado,
      this.desnutrido,
      this.docil,
      this.usuario,
      this.fotos,
      this.localizacao,
      this.dataHora,
      this.like,
      this.dislike,
      this.perfil});

//toMap - Converte um objeto Post para um mapa de atributos, útil ao salvar no Firestore.
  Map<String, dynamic> toMap() {
    return {
      if (coleira != null) "coleira": coleira,
      if (corPelagem != null) "corPelagem": corPelagem,
      if (porte != null) "porte": porte,
      if (machucado != null) "machucado": machucado,
      if (desnutrido != null) "desnutrido": desnutrido,
      if (docil != null) "docil": docil,
      if (usuario != null) "usuario": usuario,
      if (fotos != null) "fotos": fotos,
      if (localizacao != null) "localizacao": localizacao,
      if (dataHora != null) "dataHora": dataHora,
      if (like != null) "like": like,
      if (dislike != null) "dislike": dislike,
      if (perfil != null) "perfil": perfil
    };
  }

//fromJson - Converte um mapa de atributos para um objeto Post, útil ao recuperar dados do Firestore.
  PostModel.fromJson(Map<String, dynamic> json)
      : coleira = json["coleira"],
        corPelagem = json["corPelagem"],
        porte = json["porte"],
        machucado = json["machucado"],
        desnutrido = json["desnutrido"],
        docil = json["docil"],
        usuario = json["usuario"],
        fotos = json["fotos"],
        localizacao = json["localizacao"],
        dataHora = json["dataHora"],
        perfil = json["perfil"];

//fromFirestore - Cria um objeto Post a partir de um DocumentSnapshot do Firestore, útil para trazer dados que esta gravado na colecao do firebase
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return PostModel.fromJson(dados);
  }

//toString - Gera uma representação de string do objeto Post.
  @override
  String toString() {
    return "Coleira: $coleira\n Cor da pelagem: $corPelagem\n Porte: $porte \n Machucado: $machucado\n Desnutrido: $desnutrido\n Dócil: $docil\n Usuário: $usuario\n Localização: $localizacao\n Data e hora: $dataHora\n";
  }
}
