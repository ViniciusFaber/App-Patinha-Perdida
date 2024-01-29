import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';

class HelpInfoScreen extends StatefulWidget {
  const HelpInfoScreen({super.key});

  @override
  State<HelpInfoScreen> createState() => _HelpInfoScreenState();
}

class _HelpInfoScreenState extends State<HelpInfoScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 7), () {
//Ao invés de usar o Navigator, pushReplacement e a MaterialPageRoute nós usamos apenas Get.offNamed
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
              CustomColors.customSwatchColor.shade50,
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
                    "Comentário enviado!",
                    style: GoogleFonts.righteous(
                      fontSize: 38,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SpinKitPouringHourGlassRefined(
                    color: CustomColors.customSwatchColorPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
