import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Sobre nós",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Sobre o aplicativo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: Text(
              "Este Aplicativo tem o intuito de possibilitar o registro e apresentação de relatos de animais abandonados na região. Juntos, podemos fazer a diferença na vida desses animais desamparados. Agradecemos sua colaboração!",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Sobre os desenvolvedores",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: Text(
              "Este projeto foi desenvolvido por Jaqueline Gabriele Dias, Vinicius Faber Zamarchi e Gustavo da Glória Favaretto Alves, na disciplina modular de Programação de Software e Aplicativo II do curso de Sistemas de Informação durante o mês de janeiro de 2024.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
