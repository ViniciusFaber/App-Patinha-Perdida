import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';
import 'package:patinha_perdida_app/src/services/util_services.dart';
import 'package:patinha_perdida_app/src/services/validators_services.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _formKey = GlobalKey<FormState>();
  final UtilsServices _utilsServices = UtilsServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//Formulário dentro do SingleChildScrollView para evitar overflow
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //Título
                const Text(
                  "Caso tenha alguma duvida ou sugestão, deixe um comentário logo abaixo que iremos responder o mais breve possível! :)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.all(13)),

                //Campo de texto para informar o nome
                TextFormField(
                  validator: nameSuggestionValidator,
                  decoration: InputDecoration(
                    labelText: "Informe seu nome...",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(13)),

                //Campo de texto para informar o email
                TextFormField(
                  validator: emailSuggestionValidator,
                  decoration: InputDecoration(
                    labelText: "Email para entrarmos em contato...",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(13)),

                //Campo de texto para deixar o comentário ou sugestão
                TextFormField(
                  validator: suggestionValidator,
                  decoration: const InputDecoration(
                    hintText: "Comentário ou sugestão",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 9,
                ),
                const Padding(padding: EdgeInsets.all(13)),

                //Texto informativo
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "É muito importante conhecermos sua opinião. Você faz parte do Patinha Perdida!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Botão de enviar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Botão de cancelar
                    OutlinedButton(
                      onPressed: () {
                        _utilsServices.showToast(
                            message: "Comentário cancelado!", isError: true);
                        Get.toNamed(PagesRoutes.baseScreen);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: CustomColors.customSwatchColorPurple),
                      ),
                    ),

                    //Botão de registrar
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Get.toNamed(PagesRoutes.helpInfoScreen);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.customSwatchColorPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Enviar",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
