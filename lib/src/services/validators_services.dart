import 'package:get/get.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return "Digite seu email!";
  }

  if (!email.isEmail) return "Digite um email válido!";

  return null;
}

String? passwordValidator(password) {
  if (password == null || password.isEmpty) {
    return "Digite sua senha!";
  }

  if (password.length < 6) {
    return "Digite uma senha com pelos menos 6 caracteres.";
  }

  return null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return "Digite um nome!";
  }

  final names = name.split(' ');

  if (names.length == 1) return "Digite seu nome completo!";

  return null;
}

String? emailSuggestionValidator(String? email) {
  if (email == null || email.isEmpty) {
    return "Informe seu email para entrarmos em contato!";
  }

  if (!email.isEmail) return "Digite um email válido!";

  return null;
}

String? nameSuggestionValidator(String? name) {
  if (name == null || name.isEmpty) {
    return "Digite seu nome!";
  }

  final names = name.split(" ");

  if (names.length == 1) return "Digite seu nome completo!";

  return null;
}

String? suggestionValidator(String? email) {
  if (email == null || email.isEmpty) {
    return "Deixe uma sugestão ou dúvida!";
  }

  return null;
}

String? porteValidator(porte) {
  if (porte == null || porte.isEmpty) {
    return "Selecione um campo!";
  }
  return null;
}
