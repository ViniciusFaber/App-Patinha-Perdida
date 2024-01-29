import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

//Para trabalhar com as pages nomeadas com GetX precisamos modificar a MateriarApp para GetMaterialApp
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("pt"),
      ],

      title: "Patinha Perdida",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
//Generalizando a fonte de letras que será usada no aplicativo, no caso é a Poppins do Google fonts
        textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.inter(textStyle: textTheme.bodyMedium),
        ),
//Definindo um Background/cor padrão para o popupMenu e o scaffold
        popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.customSwatchColorPurple.shade700,
          centerTitle: true,
          foregroundColor: Colors.white,
          iconTheme: null,
        ),
      ),
      debugShowCheckedModeBanner: false,

//Chamando a tela de Splash
//Utilizando das páginas nomeadas nós chamamos initialRoute ao invés de home e definimos o getPages
      initialRoute:
          PagesRoutes.splashPage, //Define a rota inicial do aplicativo
      getPages: PagesApp.pages, //Define as páginas disponíveis no aplicativo.
    );
  }
}
