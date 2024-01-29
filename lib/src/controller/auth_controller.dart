import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patinha_perdida_app/src/model/user_model.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';
import 'package:patinha_perdida_app/src/services/util_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  final utilsServices = UtilsServices();
  var auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;

//Função para realizar login no aplicativo
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 2));

      utilsServices.showToast(message: "Login realizado com sucesso!");

      //Navegar para a página de mapa
      Get.offNamed(PagesRoutes.map);

      isLoading.value = false;
    } on FirebaseAuthException catch (_) {
      utilsServices.showToast(
          message: "Email ou senha inválidos!", isError: true);
      isLoading.value = false;
    }
  }

//Função para realizar cadastro no aplicativo
  Future<void> signUp({
    required String email,
    required String password,
    required String nome,
    XFile? foto,
  }) async {
    isLoading.value = true;

    try {
      var usuario = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Atualiza o perfil do usuário com o nome
      await usuario.user!.updateDisplayName(nome);

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference pastaRaiz = storage.ref();
      Reference arquivo = pastaRaiz
          .child("perfil")
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      // Envio do arquivo para o serviço de armazenamento
      await arquivo.putFile(File(foto!.path));

      // Obtenha a URL do arquivo específico
      var fotoUrl = await arquivo.getDownloadURL();
      await usuario.user!.updatePhotoURL(fotoUrl);

      await Future.delayed(const Duration(seconds: 2));

      utilsServices.showToast(message: "Cadastro realizado com sucesso!");

      // Navegar para a página de mapa
      Get.offNamed(PagesRoutes.map);

      isLoading.value = false;

      // Adiciona esse usuário no firestore
      UsuarioModel user = UsuarioModel(
        id: usuario.user!.uid,
        nome: nome,
        email: email,
        senha: password,
        fotoUrl: fotoUrl,
      );
      await db.collection("usuarios").doc(usuario.user!.uid).set(user.toMap());
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        utilsServices.showToast(message: "Email já em uso!", isError: true);
      } else if (e.code == "weak-password") {
        utilsServices.showToast(
            message: "Escolha uma senha mais complexa!", isError: true);
      }
    } catch (e) {
      utilsServices.showToast(
          message: "Não foi possível realizar o cadastro.", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
