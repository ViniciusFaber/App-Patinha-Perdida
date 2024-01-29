import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patinha_perdida_app/src/config/custom_text_field_config.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/controller/auth_controller.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';
import 'package:patinha_perdida_app/src/services/validators_services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
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
                          'assets/icon.png',
                          height: 200,
                        ),
                        const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

//Formulário
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
//Email - campo com referência do widget custom_text_field na pasta config
                          CustomTextFieldConfig(
                            icon: Icons.email,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            controller: _controllerEmail,
                            validator: emailValidator,
                          ),

//Senha
                          CustomTextFieldConfig(
                            icon: Icons.lock,
                            label: 'Senha',
                            keyboardType: TextInputType.visiblePassword,
                            isSecret: true,
                            controller: _controllerSenha,
                            validator: passwordValidator,
                          ),

//Botão para entrar na aplicação
                          SizedBox(
                            height: 50,
                            child: GetX<AuthController>(
                              builder: (authController) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        CustomColors.customSwatchColorPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onPressed: authController.isLoading.value
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            String email =
                                                _controllerEmail.text;
                                            String password =
                                                _controllerSenha.text;
//Chamando authController para fazer a validação de login
                                            authController.signIn(
                                                email: email,
                                                password: password);
                                          }
                                        },
                                  child: authController.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),

//Botão esqueceu a senha
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Esqueceu sua senha?',
                                style: TextStyle(
                                  color: CustomColors.customContrastColor,
                                ),
                              ),
                            ),
                          ),

//Divisor
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.withAlpha(90),
                                    thickness: 2,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text('Ou'),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.withAlpha(90),
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),

//Botão de cadastro
                          SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                side: BorderSide(
                                  width: 2,
                                  color: CustomColors.customSwatchColorPurple,
                                ),
                              ),
                              onPressed: () {
                                //O to é equivalente ao push
                                Get.toNamed(PagesRoutes.signUpScreen);
                              },
                              child: const Text(
                                'Criar conta',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

//Botão para voltar
              Positioned(
                left: 10,
                top: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
