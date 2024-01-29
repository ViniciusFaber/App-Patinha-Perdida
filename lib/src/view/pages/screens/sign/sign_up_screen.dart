import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patinha_perdida_app/src/config/custom_text_field_config.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/controller/auth_controller.dart';
import 'package:patinha_perdida_app/src/services/validators_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  XFile? _arquivoImagem;

  var db = FirebaseFirestore.instance;
  //Instanciando conexão com o FirebaseAuth para verificar quem é o usuário logado que está realizando a postagem para pegar o id desse usuário e gravar na coleção de postagem
  var auth = FirebaseAuth.instance;

  Future<XFile?> _capturaFoto() async {
    final ImagePicker picker = ImagePicker();
    XFile? imagem;

    imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        _arquivoImagem = imagem;
      });
    }
    return null;
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerNome.dispose();
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
                          'Patinha Perdida',
                          style: GoogleFonts.righteous(
                            fontSize: 38,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Cadastro',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                          ),
                        )
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

//Campos do formulário
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Stack(
                              children: [
//Imagem da foto e decoração do container
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1),
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                    image: _arquivoImagem != null
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                File(_arquivoImagem!.path)),
                                          )
                                        : const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 0,
                                        color: Colors.white,
                                      ),
                                      color: CustomColors.customSwatchColor,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add_circle),
                                      color: Colors.white,
                                      onPressed: () {
                                        _capturaFoto();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          //Nome
                          CustomTextFieldConfig(
                            icon: Icons.person,
                            label: 'Nome completo',
                            keyboardType: TextInputType.text,
                            controller: _controllerNome,
                            validator: nameValidator,
                          ),

                          //Email
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
                            isSecret: true,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _controllerSenha,
                            validator: passwordValidator,
                          ),

                          //Botão de cadastro
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
                                            String nome = _controllerNome.text;

//Chamando authController para fazer a validação de cadastro
                                            authController.signUp(
                                              email: email,
                                              password: password,
                                              nome: nome,
                                              foto: _arquivoImagem,
                                            );
                                          }
                                        },
                                  child: authController.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Cadastrar',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                );
                              },
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
