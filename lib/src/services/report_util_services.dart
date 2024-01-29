class ReportUtilServices {
//Para definir o porte do animal
  static String definirPorte(String? campoSelecionadoPorte) {
    if (campoSelecionadoPorte == "P") {
      return "Porte pequeno.";
    } else if (campoSelecionadoPorte == 'M') {
      return "Porte médio.";
    } else {
      return "Porte grande.";
    }
  }

//Definir se é dócil
  static bool definirDocil(String? campoSelecionadoDocil) {
    if (campoSelecionadoDocil == "") {
      return false;
    } else if (campoSelecionadoDocil == 'S') {
      return true; // É dócil
    } else {
      return false; // Não é dócil
    }
  }

//Definir se está desnutrido
  static bool definirDesnutrido(String? campoSelecionadoDesnutrido) {
    if (campoSelecionadoDesnutrido == "") {
      return false;
    } else if (campoSelecionadoDesnutrido == 'S') {
      return true; //Está desnutrido
    } else {
      return false; //Não está desnutrido
    }
  }

//Definir se está machucado
  static bool definirMachucado(String? campoSelecionadoMachucado) {
    if (campoSelecionadoMachucado == "") {
      return false;
    } else if (campoSelecionadoMachucado == 'S') {
      return true; //Está machucado
    } else {
      return false; //Não está machucado
    }
  }

//Definir se tem coleira
  static bool definirColeira(String? campoSelecionadoColeira) {
    if (campoSelecionadoColeira == "") {
      return false;
    } else if (campoSelecionadoColeira == 'S') {
      return true; //Está com coleira
    } else {
      return false; //Não está com coleira
    }
  }
}
