import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patinha_perdida_app/src/model/post_model.dart';

class PostDAO {
  final CollectionReference colecao =
      FirebaseFirestore.instance.collection("relatos");

  Future<void> addPost(PostModel post, String doc) {
    return colecao.add(post.toMap());
  }

  Future<List<PostModel>> getPosts(String doc) async {
    final QuerySnapshot resultado = await colecao.get();

    final List<DocumentSnapshot> lista = resultado.docs;

    return lista.map((DocumentSnapshot documento) {
      return PostModel.fromFirestore(documento);
    }).toList();
  }

  Future<int> obterTotalRegistros() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('relatos').get();

      int totalRegistros = querySnapshot.size;
      return totalRegistros;
    } catch (e) {
      print('Erro ao obter total de registros: $e');
      return 0;
    }
  }

  Future<double> obterPorcentagemRegistrosMachucado() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('relatos').get();

    int totalRegistros = querySnapshot.size;

    QuerySnapshot querySnapshots = await FirebaseFirestore.instance
        .collection('relatos')
        .where('machucado', isEqualTo: true)
        .get();
    int totalRegistrosMachucado = querySnapshots.size;

    if (totalRegistrosMachucado == 0) {
      return 0.0;
    }

    double porcentagemMachucado =
        (totalRegistrosMachucado / totalRegistros) * 100.0;

    return porcentagemMachucado;
  }

  Future<double> obterPorcentagemRegistrosDesnutrido() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('relatos').get();

    int totalRegistros = querySnapshot.size;

    QuerySnapshot querySnapshots = await FirebaseFirestore.instance
        .collection('relatos')
        .where('desnutrido', isEqualTo: true)
        .get();
    int totalRegistrosDesnutrido = querySnapshots.size;

    if (totalRegistrosDesnutrido == 0) {
      return 0.0;
    }

    double porcentagemDesnutrido =
        (totalRegistrosDesnutrido / totalRegistros) * 100.0;

    return porcentagemDesnutrido;
  }

  Future<double> obterPorcentagemRegistrosColeira() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('relatos').get();

    int totalRegistros = querySnapshot.size;

    QuerySnapshot querySnapshots = await FirebaseFirestore.instance
        .collection('relatos')
        .where('coleira', isEqualTo: false)
        .get();
    int totalRegistrosColeira = querySnapshots.size;

    if (totalRegistrosColeira == 0) {
      return 0.0;
    }

    double porcentagemColeira = (totalRegistrosColeira / totalRegistros) *
        100.0; //Primeiro a gente pega a quatidade total de registros no firebase por meio do size e depois também pega a quantidade de registros com o where = caleira - false... depois faz a conta (totalRegistrosColeira / totalRegistros) * 100.0 que retorna o valor em doble...

    return porcentagemColeira;
  }

  Future<double> obterPorcentagemRegistrosDocil() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('relatos').get();

    int totalRegistros = querySnapshot.size;

    QuerySnapshot querySnapshots = await FirebaseFirestore.instance
        .collection('relatos')
        .where('docil', isEqualTo: false)
        .get();
    int totalRegistrosDocil = querySnapshots.size;

    if (totalRegistrosDocil == 0) {
      return 0.0;
    }

    double porcentagemColeira = (totalRegistrosDocil / totalRegistros) * 100.0;

    return porcentagemColeira;
  }
}
