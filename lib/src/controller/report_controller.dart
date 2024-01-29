import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patinha_perdida_app/src/model/post_model.dart';
import 'package:patinha_perdida_app/src/services/util_services.dart';

class ReportController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UtilsServices _utilsServices = UtilsServices();

// Inserção no Firestore
  Future<void> adicionarRelato(PostModel postagens) async {
    try {
      await _db.collection("postagens").add(postagens.toMap());
    } catch (e) {
      _utilsServices.showToast(
          message: "Erro ao adicionar relato.", isError: true);
    }
  }
}
