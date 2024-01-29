import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/intro/intro_page1_screen.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/intro/intro_page2_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReportIntroScreen extends StatefulWidget {
  const ReportIntroScreen({super.key});

  @override
  State<ReportIntroScreen> createState() => _ReportIntroScreenState();
}

class _ReportIntroScreenState extends State<ReportIntroScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = (index == 1);
                  });
                },
                children: const [
                  IntroPage1Screen(),
                  IntroPage2Screen(),
                ],
              ),

//Detalhe do indicator
              Container(
                alignment: const Alignment(0, 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Skip
                    GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(-1);
                      },
                      child: Text(
                        "Voltar",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 74, 15, 84),
                        ),
                      ),
                    ),

                    //Indicador
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 2,
                      effect: const WormEffect(
                          paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: Colors.white,
                          activeDotColor: Colors.white),
                    ),

                    //next
                    onLastPage
                        ? GestureDetector(
                            onTap: () {
                              Get.toNamed(PagesRoutes.signInScreen);
                            },
                            child: Text(
                              "Vamos lá!",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 74, 15, 84),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              "Próximo",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 74, 15, 84),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
