import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/data/data_post_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/feed/feed_post_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/help/help_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/profile/profile_user_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/search/search_post_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var auth = FirebaseAuth.instance;
  User? _user;

  //Lista de itens do popMenu
  List<String> itensMenu = [
    "Entrar",
    "Cadastrar-se",
    "Sobre nós",
    "Sair",
  ];

//Opções do popMenu
  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Entrar":
        Get.toNamed(PagesRoutes.signInScreen);
        break;
      case "Cadastrar-se":
        Get.toNamed(PagesRoutes.signUpScreen);
        break;
      case "Sobre nós":
        Get.toNamed(PagesRoutes.aboutScreen);
        break;
      case "Sair":

        //Pedir ao usuário se ele realmente tem certeza que quer sair
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar Saída"),
              content: const Text("Tem certeza de que deseja sair do App?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Fechar o diálogo
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Get.back(); // Fechar o diálogo
                    auth.signOut(); //Deslogar o usuário logado
                    SystemNavigator.pop(); // Sair do aplicativo
                  },
                  child: const Text("Sair"),
                ),
              ],
            );
          },
        );
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    // Recuperar o usuário atualmente autenticado, que pode ser nulo
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _auth.currentUser == null
                ? Null
                : Navigator.push(
                    context,
                    PageTransition(
                      child: const ProfileUserScreen(),
                      type: PageTransitionType.size,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 400),
                    ),
                  );
          },
          //verifica se o usuário está logado para mostrar determinado ícone
          icon: _auth.currentUser != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(_user!.photoURL!),
                )
              : const Icon(
                  Icons.pets_outlined,
                  color: Colors.white,
                ),
        ),

        //Título
        title: Text(
          "Patinha Perdida",
          style: GoogleFonts.righteous(
              fontSize: 24, fontWeight: FontWeight.w200, color: Colors.white),
        ),

        //popup
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.dehaze,
            ),
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem(value: item, child: Text(item));
              }).toList();
            },
            onSelected: _escolhaMenuItem,
          )
        ],
      ),

      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          FeedPostScreen(),
          SearchPostScreen(),
          DataPostScreen(),
          HelpScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(
            () {
              currentIndex = index;
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeIn,
              );
            },
          );
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomColors.customSwatchColorPurple.shade600,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(100),
        items: const [
//Botão do home
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),

//Botão de pesquisa
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Pesquisa",
          ),

//Botão da dados
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Dados",
          ),

//Botão do ajuda
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: "Ajuda",
          ),
        ],
      ),

      //Botão de registrar
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: FloatingActionButton(
          backgroundColor: CustomColors.customSwatchColor,
          onPressed: () async {
            if (_auth.currentUser != null) {
// Usuário está logado, redireciona para a tela de Mapa
              Get.toNamed(PagesRoutes.map);
            } else {
// Usuário não está logado, redireciona para a tela de IntroReport
              Get.toNamed(PagesRoutes.reportIntroScreen);
            }
          },
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
