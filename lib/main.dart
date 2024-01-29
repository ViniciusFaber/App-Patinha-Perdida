import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:patinha_perdida_app/home/home.dart';
import 'package:patinha_perdida_app/src/controller/auth_controller.dart';

void main() async {
  const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyAAJ1H_GCVxj5SBbLJqWvb4206Zer0wSZQ",
      appId: "1:1792714838:android:303f7f4a2559243feb33f7",
      messagingSenderId: "1792714838",
      projectId: "app-patinha-perdida-e5e1a",
      storageBucket: "app-patinha-perdida-e5e1a.appspot.com");

  const FirebaseOptions ios = FirebaseOptions(
      apiKey: "AIzaSyDzjRISrBDlu7zNOtfkq2e0WEfmEpZiJV0",
      appId: "1:1792714838:ios:b91c496e441fde7deb33f7",
      messagingSenderId: "1792714838",
      projectId: "app-patinha-perdida-e5e1a",
      storageBucket: "app-patinha-perdida-e5e1a.appspot.com");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: Platform.isAndroid ? android : ios);

//Fazendo injeção na memória
//Essa abordagem facilita a gestão de estado e a obtenção de instâncias
//de controladores em diferentes partes do aplicativo. GetxController
  Get.put(AuthController());

  runApp(const Home());
}
