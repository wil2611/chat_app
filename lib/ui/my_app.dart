import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'controllers/location_controller.dart';
import '../use_case/locator_service.dart';
import 'controllers/authentication_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/firestore_controller.dart';
import 'controllers/perfil_controller.dart';
import 'controllers/singup_controller.dart';
import 'controllers/ubi_controller.dart';
import 'controllers/user_controller.dart';
import 'firebase_cental.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
    Get.put(LocatorService());
    Get.put(FirestoreController());
    Get.put(AuthenticationController());
    Get.put(ChatController());
    Get.put(UserController());
    Get.put(UserProfileController());
    Get.put(SingupController());
    Get.put(LocationController());
    Get.put(UbiController());
    requestPermission();
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirebaseCentral());
  }
}
