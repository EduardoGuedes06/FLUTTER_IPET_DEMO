import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocalCache extends ChangeNotifier {
  String _location = "Endereço do Usuario";

  String get location => _location;

  Future<void> updateLocation() async {
    try {
      Position posicao = await Geolocator.getCurrentPosition();
      List<Placemark> locais =
          await placemarkFromCoordinates(posicao.latitude, posicao.longitude);

      if (locais.isNotEmpty) {
        _location = locais[0].street ?? "Endereço desconhecido";
      } else {
        _location = "Nenhum endereço localizado";
      }

      notifyListeners();
    } catch (e) {
      print("Erro ao obter posição: $e");
      _location = "Erro ao obter posição";
      notifyListeners();
    }
  }
}
