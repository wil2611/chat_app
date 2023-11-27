import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'controllers/location_controller.dart';
import 'controllers/perfil_controller.dart';
import 'controllers/ubi_controller.dart';
import 'pages/content_page.dart';
import 'pages/login/login.dart';

class FirebaseCentral extends StatelessWidget {
  FirebaseCentral({Key? key}) : super(key: key);

  void requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Los permisos están denegados permanentemente, manejamos esto.
        requestPermission();
        return;
      }

      if (permission == LocationPermission.denied) {
        // Los permisos están denegados pero no permanentemente. Podemos solicitar los permisos nuevamente en un próximo ciclo.
        requestPermission();
        return;
      }
    }
  }

  final LocationController locationController = Get.find();
  final UserProfileController perfilController = Get.find();
  final UbiController ubiController = Get.find();
  void ubicar() {
    var online = true;
    locationController.getLocation();
    var latitud = locationController.userLocation.value.latitude;
    var longitud = locationController.userLocation.value.longitude;
    debugPrint("latitud: $latitud longitud: $longitud online: $online");
    ubiController.ubi(perfilController.user.value!.uid, latitud.toString(),
        longitud.toString(), online.toString());
  }

  @override
  Widget build(BuildContext context) {
    requestPermission();
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ubicar();
            return const ContentPage();
          } else {
            return LoginPage();
          }
        });
  }
}
