import 'package:cloud_firestore/cloud_firestore.dart';

//A classe chamada Usuario modela a estrutura de dados de um novo usuário no app
class UsuarioModel {
  String? id; //Identificador único do usuário.
  String? nome; //Nome do usuário.
  String? email; //Endereço de e-mail do usuário.
  String? senha; //Senha do usuário.
  final String? fotoUrl;

//Cada instância da classe Usuario representa um usuário na coleção do Firestore.
  UsuarioModel({
    this.id,
    this.nome,
    this.email,
    this.senha,
    this.fotoUrl,
  });

//toMap - Converte um objeto Usuario para um mapa de atributos, útil ao salvar no Firestore.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      if (nome != null) "nome": nome,
      if (email != null) "email": email,
      if (senha != null) "senha": senha,
      if (fotoUrl != null) "fotoUrl": fotoUrl,
    };
  }

//fromJson - Converte um mapa de atributos para um objeto Usuario, útil ao recuperar dados do Firestore.
  UsuarioModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        nome = json["nome"],
        email = json["email"],
        senha = json["senha"],
        fotoUrl = json["fotoUrl"];

//fromDocument - Cria um objeto Usuario a partir de um DocumentSnapshot do Firestore.
//Útil para trazer os dados que estão gravados no firebase...
  factory UsuarioModel.fromDocument(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return UsuarioModel.fromJson(dados);
  }

  @override
  String toString() {
    return "Email: $email\n Senha: $senha";
  }
}
