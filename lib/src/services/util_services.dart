import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class UtilsServices {
//Formatar as datas
  String formatDate(String dateString) {
    try {
      // Converter a string para DateTime
      DateTime dateTime = DateTime.parse(dateString);

      // Formatar a data como string
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

      return formattedDate;
    } catch (e) {
      return 'Data inválida';
    }
  }

//Apresentar o endereço com base nas coordenadas de latitude e longitude
  Future<String> getUserName(GeoPoint location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];

        String address = getAddressFromPlacemark(placemark);
        return address;
      }
    } catch (e) {
      showToast(message: "Erro ao obter endereço!", isError: true);
    }

    return "Endereço não encontrado";
  }

// Função para compor um endereço mais completo
  String getAddressFromPlacemark(Placemark placemark) {
    List<String> addressComponents = [];

    if (placemark.thoroughfare != null) {
      addressComponents.add(placemark.thoroughfare!);
    }
    if (placemark.subLocality != null) {
      addressComponents.add(placemark.subLocality!);
    }

    return addressComponents.join(", ");
  }

//Apresentar o toast de mensagem
  void showToast({
    required String message,
    bool isError = false,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: isError ? Colors.red : Colors.white,
      textColor: isError ? Colors.white : Colors.black,
      fontSize: 18,
    );
  }
}
