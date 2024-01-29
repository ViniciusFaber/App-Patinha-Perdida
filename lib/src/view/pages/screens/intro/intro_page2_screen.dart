import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage2Screen extends StatelessWidget {
  const IntroPage2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/caminho.png',
                width: 250,
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Entre em sua conta!:)',
                      style: GoogleFonts.righteous(
                        fontSize: 35,
                        color: const Color.fromARGB(255, 74, 15, 84),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      'Para poder registrar um novo relato de animal abandonado você precisa fazer login em nosso aplicativo ou criar uma nova conta.',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 74, 15, 84),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
