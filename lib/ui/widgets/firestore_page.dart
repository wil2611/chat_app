import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warriors_of_fate/ui/controllers/authentication_controller.dart';
import 'package:warriors_of_fate/ui/controllers/location_controller.dart';
import '../controllers/perfil_controller.dart';

import '../controllers/chat_controller.dart';
import '../controllers/firestore_controller.dart';
import '../controllers/ubi_controller.dart';
import '../controllers/user_controller.dart';
import 'chat_page.dart';

class FireStorePage extends StatefulWidget {
  const FireStorePage({super.key});

  @override
  State<FireStorePage> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireStorePage> {
  final FirestoreController firestoreController = Get.find();
  final ChatController chatController = Get.find();
  LocationController locationController = Get.find();
  UserController userController = Get.find();
  UserProfileController perfilController = Get.find();
  UbiController ubicontroler = Get.find();
  AuthenticationController authenticationController = Get.find();
  @override
  void initState() {
    ubicar();
    firestoreController.suscribeUpdates();
    userController.start();
    super.initState();
  }

  void ubicar() {
    var online = true;
    locationController.getLocation();
    var latitud = locationController.userLocation.value.latitude;
    var longitud = locationController.userLocation.value.longitude;
    debugPrint("latitud: $latitud longitud: $longitud online: $online");
    ubicontroler.ubi(perfilController.user.value!.uid, latitud.toString(),
        longitud.toString(), online.toString());
  }

  @override
  void dispose() {
    firestoreController.suscribeUpdates();
    super.dispose();
  }

  Widget _item(String uid, String email, String name) {
    // Widget usado en la lista de los usuarios
    // Muestra el correo con un ícono
    return Card(
      margin: const EdgeInsets.all(4.0),
      color: const Color(0xFF260B01), // Color de fondo para cada tarjeta
      child: ListTile(
        onTap: () {
          Get.to(() => const ChatPage(), arguments: [
            uid,
            name,
          ]);
        },
        leading: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  late String name;

  Widget _list() {
    return GetX<UserController>(builder: (controller) {
      if (userController.users.isEmpty) {
        return const Center(
          child: Text(
            'No users online',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      return ListView.builder(
        itemCount: userController.users.length,
        itemBuilder: (context, index) {
          perfilController
              .obtenerLocation(authenticationController.getUid().toString());
          var element = userController.users[index];
          var location = ubicontroler.onlines[index];
          for (var i = 0; i < ubicontroler.onlines.length; i++) {
            if (ubicontroler.onlines[i].key == element.uid) {
              location = ubicontroler.onlines[i];
            }
          }
          debugPrint(
              "uid${authenticationController.getUid()} se encuentra en ${perfilController.locationCheck.value!['latitude']},${perfilController.locationCheck.value!['longitud']}");
          return FutureBuilder<String>(
            future: perfilController.obtenerNombre(element.uid),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                name = snapshot.data ?? "No_Name";
                if (location.online == "true" &&
                    haversineDistance(
                            double.parse(location.latitude),
                            double.parse(location.longitude),
                            double.parse(perfilController
                                .locationCheck.value!['latitud']),
                            double.parse(perfilController
                                .locationCheck.value!['longitud'])) <
                        50.0) {
                  return _item(element.uid, element.email, name);
                }
                if (index == userController.users.length - 1) {
                  return const Center(
                    child: Text(
                      'No users around',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      );
    });
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371.0; // Radio de la Tierra en kilómetros

    // Convertir grados a radianes
    lat1 = _degreesToRadians(lat1);
    lon1 = _degreesToRadians(lon1);
    lat2 = _degreesToRadians(lat2);
    lon2 = _degreesToRadians(lon2);
    debugPrint("lat1: $lat1 lon1: $lon1 lat2: $lat2 lon2: $lon2");
    // Diferencias de latitud y longitud
    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    // Fórmula de Haversine
    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c; // Distancia en kilómetros

    // Convertir la distancia a metros
    double distanceMeters = distance;
    debugPrint("distancia: $distanceMeters");
    return distanceMeters;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFD9A76A),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 87, 87, 87),
              Color.fromARGB(255, 100, 100, 100),
              Color.fromARGB(255, 87, 87, 87),
            ],
          ),
        ),
        child: _list(),
      ),
    );
  }
}
