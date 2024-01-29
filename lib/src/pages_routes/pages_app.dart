import 'package:get/get.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/about/about_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/base/base_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/help/help_info_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/help/help_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/report/report_intro_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/sign/sign_in_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/sign/sign_up_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/splash/splash_page.dart';
import 'package:patinha_perdida_app/src/view/map/map.dart';

//Criando uma classe abstrata
abstract class PagesApp {
//Utilizando no pacote GetX

  static final pages = <GetPage>[
//Aqui dentro estamos colocando nossas instâcias do tipo GetPage
//Estamos criando uma instância de GetPage e dentro
//dela colocando instância de telas as quais estamos mapeando
//Ele tem dois atributos obrigatórios, name - que vai ser como vamos chamar essa tela e page - o nome da nossa page

    GetPage(
      page: () => const SplashPage(),
      name: PagesRoutes.splashPage,
    ),

    GetPage(
      page: () => const SignUpScreen(),
      name: PagesRoutes.signUpScreen,
    ),

    GetPage(
      page: () => const SignInScreen(),
      name: PagesRoutes.signInScreen,
    ),

    GetPage(
      page: () => const BaseScreen(),
      name: PagesRoutes.baseScreen,
    ),

    GetPage(
      page: () => const Map(),
      name: PagesRoutes.map,
    ),

    GetPage(
      page: () => const AboutScreen(),
      name: PagesRoutes.aboutScreen,
    ),

    GetPage(
      page: () => const HelpScreen(),
      name: PagesRoutes.helpScreen,
    ),

    GetPage(
      page: () => const HelpInfoScreen(),
      name: PagesRoutes.helpInfoScreen,
    ),

    GetPage(
      page: () => const ReportIntroScreen(),
      name: PagesRoutes.reportIntroScreen,
    ),
  ];
}

//Criando outra classe para acessar os atributos e renomea-los a fim de evitar erro de digitação
abstract class PagesRoutes {
  static const String splashPage = "/splash";
  static const String signUpScreen = "/signupscreen";
  static const String signInScreen = "/signin";
  static const String baseScreen = "/basescreen";
  static const String map = "/map";
  static const String aboutScreen = "/aboutscreen";
  static const String helpScreen = "/helpscreen";
  static const String helpInfoScreen = "/helpinfoscreen";
  static const String reportIntroScreen = "/reportintroscreen";
  static const String reportScreen = "/reportscreen";
}
