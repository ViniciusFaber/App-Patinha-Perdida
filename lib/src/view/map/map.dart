import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:patinha_perdida_app/src/view/pages/screens/report/report_screen.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Set<Marker> _marcadores = {};

//Informando uma posição inicial fixa da câmera
  CameraPosition _posicaoCamera = const CameraPosition(
    target: LatLng(-26.4894305372459, -51.99414953665105),
    zoom: 18,
  );

// Função para redirecionar para a tela de relato de animal abandonado
  Future<void> _navigateToReportScreen(
      BuildContext context, LatLng selectedLocation) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(selectedLocation: selectedLocation),
      ),
    );
  }

// Função para criar o mapa do Google
  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

// Função para capturar no mapa a localização setada pelo usuário
  Future<void> _adicionarMarcador(LatLng latLng) async {
    if (!mounted) return; // Verifica se o widget ainda está montado

    List<Placemark> enderecos =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (!mounted) return; // Verifica novamente após a operação assíncrona

    if (enderecos.isNotEmpty) {
      Placemark endereco = enderecos[0];
      String? rua =
          endereco.thoroughfare; //Para armazenar o nome da rua/endereço

      Marker marcador = Marker(
        markerId: MarkerId("marcador-${latLng.latitude}-${latLng.longitude}"),
        position: latLng,
        infoWindow: InfoWindow(
            title: rua), //Para mostrar o nome da rua no Marker do mapa
      );

// Adiciona o marcador ao conjunto de marcadores
      if (mounted) {
        setState(() {
          _marcadores.add(marcador);
        });
      }

// Obtém o controller do GoogleMap
      GoogleMapController googleMapController = await _controller.future;

      if (!mounted) return; // Verifica novamente antes de chamar setState

// Aguarda um curto período para garantir que o marcador seja adicionado completamente
      await Future.delayed(const Duration(milliseconds: 100));

// Exibe a janela de informações do marcador
      if (mounted) {
        googleMapController.showMarkerInfoWindow(marcador.markerId);
      }

// Adia a chamada para navegar para a tela de relato até que a janela de informações seja exibida
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
//Chama a função _navigateToReportScreen passando a longitude e latitude
          _navigateToReportScreen(context, latLng);
        }
      });
    }
  }

// Função para movimentar a câmera no mapa
  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;

//Pegando a nova posição da câmera e atualizando a _posicaoCamera
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

// Função para pegar a posição atual do usuário e ir atualizando no mapa
  _adicionarListenerLocalizacao() async {
//LocationPermission é usado para verificar se o usuário deu permissão para acessar a localização do dispositivo
    LocationPermission permissao;

// Aqui verifica se o usuário deu permissão para acessar a localização
    permissao = await Geolocator.checkPermission();

// Caso não tenha aceitado, a mensagem pedindo para que ele aceite é exibida
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

//Aqui é pegado a localização atual do dispositivo e armazenado na váriavel position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

//Então é usado o setState para alterar no mapa apresentado para o usuário a localização atual
    if (mounted) {
      setState(() {
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        );
        _movimentarCamera();
      });
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position newPosition) {
      // Atualize a posição da câmera sempre que a posição do usuário for alterada
      if (mounted) {
        setState(() {
          _posicaoCamera = CameraPosition(
            target: LatLng(newPosition.latitude, newPosition.longitude),
            zoom: 15,
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerLocalizacao();
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
          "Localização do animal",
        ),
      ),
      body: GoogleMap(
        markers: _marcadores,
        mapType: MapType.normal,
        initialCameraPosition: _posicaoCamera,
        onMapCreated: _onMapCreated,
        onLongPress: _adicionarMarcador,
        myLocationEnabled: true,
      ),
    );
  }
}
