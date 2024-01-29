import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
//Ao invés de usar o Navigator.pop, Navigator.push, pushReplacement e a MaterialPageRoute nós usamos apenas Get.offNamed
      Get.offNamed(PagesRoutes.baseScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomColors.customSwatchColorPurple,
              CustomColors.customSwatchColorPurple.shade50,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Patinha Perdida",
                    style: GoogleFonts.righteous(
                      fontSize: 38,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset(
                    "assets/icon.png",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
