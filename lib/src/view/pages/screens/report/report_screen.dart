import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/dao/post_dao.dart';
import 'package:patinha_perdida_app/src/model/post_model.dart';
import 'package:patinha_perdida_app/src/pages_routes/pages_app.dart';
import 'package:patinha_perdida_app/src/services/report_util_services.dart';
import 'package:patinha_perdida_app/src/services/util_services.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({required this.selectedLocation, super.key});
  final LatLng selectedLocation;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late LatLng _selectedLocation;
  Location location = Location();
  final UtilsServices _utilsServices = UtilsServices();
  final TextEditingController _controllerCorPelagem = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  PostModel? _post;
  bool? _resultColeira;
  String? _campoSelecionadoColeira = "";
  bool? _resultMachucado;
  String? _campoSelecionadoMachucado = "";
  bool? _resultDesnutrido;
  String? _campoSelecionadoDesnutrido = "";
  bool? _resultDocil;
  String? _campoSelecionadoDocil = "";
  String? _resultPorte;
  String? _campoSelecionadoPorte = "";
  int? contagem = 0;
  String? dataHora = DateTime.now().toString();
  bool _carregando = false;
  bool _adicionarFotos = false;
  XFile? _imagem;
  final List<File> _imagens = List.empty(growable: true);

  var db = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;

//Verificar se o usuário informou que o animal contém coleira ou não e definir um valor para o _resultColeira
  void _coleira() {
    if (mounted) {
      _resultColeira =
          ReportUtilServices.definirColeira(_campoSelecionadoColeira);
    }
  }

//Verificar se o usuário informou que o animal está machucado ou não e definir um valor para o _resultMachucado
  void _machucado() {
    if (mounted) {
      setState(() {
        _resultMachucado =
            ReportUtilServices.definirMachucado(_campoSelecionadoMachucado);
      });
    }
  }

//Verificar se o usuário informou que animal está desnutrido ou não e definir um valor para o _resultDesnutrido
  void _desnutrido() {
    if (mounted) {
      setState(() {
        _resultDesnutrido =
            ReportUtilServices.definirDesnutrido(_campoSelecionadoDesnutrido);
      });
    }
  }

//Verificar se o usuário informou que o animal é dócil ou não e definir um valor para _resultDocil
  void _docil() {
    if (mounted) {
      setState(() {
        _resultDocil = ReportUtilServices.definirDocil(_campoSelecionadoDocil);
      });
    }
  }

//Verfificar qual é o porte do animal, escolhido pelo usuário e definir um valor para _resultPorte
  void _selecaoPorte() {
    if (mounted) {
      setState(() {
        _resultPorte = ReportUtilServices.definirPorte(_campoSelecionadoPorte);
      });
    }
  }

//Função para capturar a imagem do animal, sendo por meio da câmera ou da galeria de imagens do dispositivo
  _capturarFoto({bool camera = true}) async {
    XFile? temp;

    final ImagePicker picker = ImagePicker();
    if (camera) {
      temp = await picker.pickImage(source: ImageSource.camera);
    } else {
      temp = await picker.pickImage(source: ImageSource.gallery);
    }

    if (temp != null) {
      setState(() {
        _imagem = temp;
      });
    }
  }

  _adicionarFoto() {
    setState(() {
      _imagens.add(File(_imagem!.path));
    });
  }

  List<Widget> _carrossel() {
    List<Widget> imagens = List.empty(growable: true);
    for (File imagem in _imagens) {
      Padding temp = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Image.file(
          imagem,
          fit: BoxFit.cover,
          height: 150,
        ),
      );
      imagens.add(temp);
    }
    return imagens;
  }

  String _gerarNome() {
    final agora = DateTime.now();

    return agora.millisecondsSinceEpoch.toString();
  }

  Future<List<String>?> _salvarFoto(String id) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference pastaFotos = pastaRaiz.child(id).child("fotos");
    Reference arquivo;
    List<String> temp = List.empty(growable: true);

    try {
      for (File foto in _imagens) {
        arquivo = pastaFotos.child("${_gerarNome()}.jpg");
        TaskSnapshot task = await arquivo.putFile(foto);
        String url = await task.ref.getDownloadURL();
        temp.add(url);
      }
      return temp;
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      print(e);
      return null;
    }
  }

  _salvarPost({PostModel? post}) async {
    setState(() {
      _carregando = true;
    });
    _coleira();
    _machucado();
    _desnutrido();
    _docil();
    _selecaoPorte();
    //Recuperar a localização passada por parâmetro para então inserir na postagem
    GeoPoint localizacao = GeoPoint(
      _selectedLocation.latitude,
      _selectedLocation.longitude,
    );
    final FirebaseAuth auth = FirebaseAuth.instance;
    String uID = auth.currentUser!.uid;
    String? perfil = auth.currentUser!.photoURL;

    String corPelagem = _controllerCorPelagem.text;
    List<String>? fotos = await _salvarFoto(uID);

    if (post == null) {
      PostModel postagem = PostModel(
        coleira: _resultColeira,
        corPelagem: corPelagem,
        porte: _resultPorte,
        machucado: _resultMachucado,
        desnutrido: _resultDesnutrido,
        docil: _resultDocil,
        usuario: uID,
        localizacao: localizacao,
        dataHora: dataHora,
        fotos: fotos,
        like: contagem,
        dislike: contagem,
        perfil: perfil,
      );
      PostDAO().addPost(postagem, uID);
    } else {
      _utilsServices.showToast(
          message: "Não foi possível realizar o relato.", isError: true);
    }
    setState(() {
      _carregando = false;
    });
    _utilsServices.showToast(message: "Relato realizado!");
    Get.toNamed(PagesRoutes.baseScreen);
  }

  Future<bool?> _info() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
//Título
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Text(
                          "Realizar novo relato",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.customSwatchColorPurple),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Ajude-nos a registrar um novo caso de abandono animal. Descreva as características do animal encontrado, fornecendo informações essenciais para sua identificação e resgate. Inclua detalhes como a cor da pelagem, a presença de uma coleira, evidências de ferimentos ou sinais de desnutrição. Avalie o comportamento do animal, indicando se ele parece ser dócil ou assustado. Para facilitar sua identificação, solicitamos que envie algumas fotos do animal.",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
//Ao inicializar, pegar por parâmetro a latitude e longitude definida pelo usuário na tela do mapa
    _selectedLocation = widget.selectedLocation;
  }

  @override
  void dispose() {
    _controllerCorPelagem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Relato",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                _info();
              },
              icon: const Icon(Icons.info),
            ),
          )
        ],
      ),
//Formulário
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Cor da pelagem
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Descreva a pelagem desse animal:",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.edit,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        controller: _controllerCorPelagem,
                      ),
                    ),

                    //Porte do animal
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      "Porte do animal:",
                      style: TextStyle(fontSize: 18),
                    ),
                    //Para animal pequeno
                    RadioListTile(
                        title: const Text(
                          "Pequeno",
                          style: TextStyle(fontSize: 16),
                        ),
                        value: "P",
                        groupValue: _campoSelecionadoPorte,
                        onChanged: (String? resultado) {
                          setState(() {
                            _campoSelecionadoPorte = resultado;
                          });
                        }),
                    //Para animal médio
                    RadioListTile(
                        title: const Text(
                          "Médio",
                          style: TextStyle(fontSize: 16),
                        ),
                        value: "M",
                        groupValue: _campoSelecionadoPorte,
                        onChanged: (String? resultado) {
                          setState(() {
                            _campoSelecionadoPorte = resultado;
                          });
                        }),
                    //Para animal grande
                    RadioListTile(
                        title: const Text(
                          "Grande",
                          style: TextStyle(fontSize: 16),
                        ),
                        value: "G",
                        groupValue: _campoSelecionadoPorte,
                        onChanged: (String? resultado) {
                          setState(() {
                            _campoSelecionadoPorte = resultado;
                          });
                        }),

                    //Divisor no tela
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: CustomColors.customSwatchColorPurple,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    //Seleção de animal com coleira ou não
                    const Text(
                      "O animal possui coleira?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        //Possui coleira
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Sim",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "S",
                              groupValue: _campoSelecionadoColeira,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoColeira = resultado;
                                });
                              }),
                        ),
                        //Não possui coleira
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Não",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "N",
                              groupValue: _campoSelecionadoColeira,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoColeira = resultado;
                                });
                              }),
                        ),
                      ],
                    ),

                    //Divisor na tela
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: CustomColors.customSwatchColorPurple,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    //Seleção de animal machucado ou não
                    const Text(
                      "O animal aparenta estar machucado?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        //Machucado
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Sim",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "S",
                              groupValue: _campoSelecionadoMachucado,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoMachucado = resultado;
                                });
                              }),
                        ),
                        //Não está machucado
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Não",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "N",
                              groupValue: _campoSelecionadoMachucado,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoMachucado = resultado;
                                });
                              }),
                        ),
                      ],
                    ),

                    //Divisor na tela
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: CustomColors.customSwatchColorPurple,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    //Seleção de animal desnutrido ou não
                    const Text(
                      "O animal aparenta estar desnutrido?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        //desnutrido
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Sim",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "S",
                              groupValue: _campoSelecionadoDesnutrido,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoDesnutrido = resultado;
                                });
                              }),
                        ),
                        //Não está desnutrido
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Não",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "N",
                              groupValue: _campoSelecionadoDesnutrido,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoDesnutrido = resultado;
                                });
                              }),
                        ),
                      ],
                    ),

                    //Divisor na tela
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: CustomColors.customSwatchColorPurple,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    //Seleção de animal dócil ou não
                    const Text(
                      "O animal aparenta ser dócil?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        //É dócil
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Sim",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "S",
                              groupValue: _campoSelecionadoDocil,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoDocil = resultado;
                                });
                              }),
                        ),
                        //Não é dócil
                        Expanded(
                          child: RadioListTile(
                              title: const Text(
                                "Não",
                                style: TextStyle(fontSize: 16),
                              ),
                              value: "N",
                              groupValue: _campoSelecionadoDocil,
                              onChanged: (String? resultado) {
                                setState(() {
                                  _campoSelecionadoDocil = resultado;
                                });
                              }),
                        ),
                      ],
                    ),

                    //Divisor na tela
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: CustomColors.customSwatchColorPurple,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    //Registro de foto desse animal
                    const Text(
                      "Registre algumas fotos desse animal:",
                      style: TextStyle(fontSize: 18),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _carrossel(),
                              ),
                            ),
                          ),
                          _adicionarFotos == false
                              ? Container()
                              : const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Você pode adicionar mais fotos ao seu relato.",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //Seleção de foto da galeria do dispositivo do usuário
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.image,
                                color: CustomColors.customSwatchColorPurple,
                              ),
                              onPressed: () async {
                                await _capturarFoto(camera: false);
                                _adicionarFoto();
                                _adicionarFotos = true;
                              },
                              iconSize: 40,
                            ),
                            const Text(
                              "Da galeria",
                            ),
                          ],
                        ),
                        //Seleção de foto por meio da câmera do dispositivo do usuário
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: CustomColors.customSwatchColorPurple,
                              ),
                              onPressed: () {
                                _capturarFoto();
                                _adicionarFoto();
                                _adicionarFotos = true;
                              },
                              iconSize: 40,
                            ),
                            const Text("Tirar uma foto")
                          ],
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),

                    //Divisor na tela
                    Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: CustomColors.customSwatchColorPurple,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),

                    //Botões de cancelar ou de registrar
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Botão de cancelar
                          OutlinedButton(
                            onPressed: () {
                              _utilsServices.showToast(
                                  message: "Relato cancelado!", isError: true);
                              Get.toNamed(PagesRoutes.baseScreen);
                            },
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
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
                              _salvarPost(post: _post);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  CustomColors.customSwatchColorPurple,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Publicar",
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.white,
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
          ),
          if (_carregando)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black,
              ),
            ),
          if (_carregando)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
        ],
      ),
    );
  }
}
