import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'pages/content_page.dart';
import 'pages/login/login.dart';

class FirebaseCentral extends StatelessWidget {
  const FirebaseCentral({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    requestPermission();
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ContentPage();
          } else {
            return LoginPage();
          }
        });
  }
}
