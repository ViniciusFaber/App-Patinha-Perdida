import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/model/post_model.dart';
import 'package:patinha_perdida_app/src/services/util_services.dart';

class FeedPostScreen extends StatefulWidget {
  const FeedPostScreen({super.key});

  @override
  State<FeedPostScreen> createState() => _FeedPostScreenState();
}

class _FeedPostScreenState extends State<FeedPostScreen> {
  final UtilsServices utilsServices = UtilsServices();
  var auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  int count = 0;

  List<Widget> _carrossel(List<dynamic> fotos) {
    List<Widget> imagens = List.empty(growable: true);
    for (String imagem in fotos) {
      Padding temp = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Image.network(
          imagem,
          fit: BoxFit.cover,
          height: 200,
        ),
      );
      imagens.add(temp);
    }
    return imagens;
  }

//Retornar o nome do usuário que realizou o post
  Future<String> _getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      // O usuário foi encontrado, retorna o nome
      return userSnapshot['nome'];
    } else {
      // O usuário não foi encontrado, retorna uma mensagem padrão ou tratamento de erro
      return 'Usuário Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],

// Feed de postagens
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("relatos")
                  .orderBy("dataHora", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Erro ao recuperar os dados",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> documentos = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    PostModel postagem =
                        PostModel.fromFirestore(documentos[index]);

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8.0),
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            //Exibir o nome do usuário que registrou
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(postagem.perfil!),
                                    radius: 16,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: FutureBuilder(
                                    future: _getUserName(postagem.usuario!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text("Carregando...");
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            "Erro ao carregar o nome do usuário");
                                      } else {
                                        return Text(
                                          "${snapshot.data}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            //Exibe a data de postagem
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5.0),
                                child: Text(
                                  "Publicado em: ${utilsServices.formatDate(documentos[index]["dataHora"])}",
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 10)),

                            //Exibe a foto do animal se estiver presente
                            postagem.fotos != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: _carrossel(postagem.fotos!),
                                    ),
                                  )
                                : Container(),

                            //Divisor
                            Divider(
                              height: 20,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: CustomColors.customSwatchColor,
                            ),

                            //Botão do like e dislike
                            LikeButton(
                              size: 40,
                              likeCount: 0,
                              mainAxisAlignment: MainAxisAlignment.start,
                              countPostion: CountPostion.right,
                              animationDuration: const Duration(seconds: 1),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Colors.deepPurple,
                                dotSecondaryColor: Colors.purple,
                              ),
                              circleColor: const CircleColor(
                                  start: Colors.purpleAccent, end: Colors.pink),
                              likeBuilder: (isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.grey,
                                  size: 24,
                                );
                              },
                            ),

                            //Dados do animal
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Descrição do animal
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.article_outlined,
                                        color: CustomColors
                                            .customSwatchColorPurple,
                                      ),

                                      // Espaçamento entre o ícone e o texto
                                      const SizedBox(width: 5),
                                      Text(
                                        "Descrição do animal:",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors
                                              .customSwatchColorPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Definição da pelagem
                                  Text(
                                    postagem.corPelagem!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),

                                  //Verifica se o animal possui coleira
                                  if (postagem.coleira == true)
                                    const Text(
                                      "Possui coleira.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  else
                                    const Text(
                                      "Não possui coleira.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),

                                  // Verifica se o animal está desnutrido
                                  if (postagem.desnutrido == true)
                                    Text(
                                      "Aparenta estar desnutrido.",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              CustomColors.customContrastColor),
                                    )
                                  else
                                    const Text(
                                      "Não aparenta estar desnutrido.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),

                                  //Verifica se é docil
                                  if (postagem.docil == true)
                                    const Text(
                                      "Aparenta ser dócil.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  else
                                    const Text(
                                      "Não aparenta ser dócil.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),

                                  //Verifica se está machucado
                                  if (postagem.machucado == true)
                                    Text(
                                      "Aparenta estar machucado.",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              CustomColors.customContrastColor),
                                    )
                                  else
                                    const Text(
                                      "Não aparenta estar machucado.",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),

                                  //Porte do animal
                                  Text(
                                    postagem.porte!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  //Localização do animal
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color:
                                              Color.fromARGB(255, 84, 20, 95),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Localização:",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors
                                                .customSwatchColorPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Localização transformada em endereço de rua
                                  FutureBuilder<String>(
                                    future: utilsServices
                                        .getUserName(postagem.localizacao!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                            "Obtendo endereço...");
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            "Erro ao obter endereço");
                                      } else {
                                        return Text(
                                          snapshot.data!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  //Apresentaro valor de latitude e longitude
                                  Text(
                                    "Lat: ${postagem.localizacao!.latitude} Long: ${postagem.localizacao!.longitude}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
