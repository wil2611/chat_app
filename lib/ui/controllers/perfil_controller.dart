import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Rx<User?> user = Rx<User?>(null);
  Rx<Map<String, dynamic>?> userProfileData = Rx<Map<String, dynamic>?>(null);
  Rx<Map<String, dynamic>?> nameFinder = Rx<Map<String, dynamic>?>(null);
  Rx<Map<String, dynamic>?> locationCheck = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    ever(user, (_) {
      if (user.value != null) {
        // Cuando el usuario cambia, obtenemos su información del perfil
        obtenerInformacionPerfil();
      }
    });
    super.onInit();
  }

  Future<void> obtenerInformacionPerfil() async {
    String uid = user.value!.uid;
    try {
      DataSnapshot dataSnapshot =
          await _databaseRef.child('users').child(uid).get();
      // Cambia la siguiente línea
      // Map<String, dynamic>? userProfile = dataSnapshot.value as Map<String, dynamic>?;

      // a algo como esto
      Map<dynamic, dynamic> userProfileMap =
          dataSnapshot.value as Map<dynamic, dynamic>;
      Map<String, dynamic> userProfile =
          userProfileMap.map((key, value) => MapEntry(key.toString(), value));

      userProfileData.value = userProfile;
    } catch (error) {
      debugPrint('Error al obtener información de perfil: $error');
    }
  }

  Future<String> obtenerNombre(String uid) async {
// Tu método aquí
    try {
      DataSnapshot dataSnapshot =
          await _databaseRef.child('users').child(uid).get();
      Map<dynamic, dynamic> userProfileMap =
          dataSnapshot.value as Map<dynamic, dynamic>;
      Map<String, dynamic> userProfile =
          userProfileMap.map((key, value) => MapEntry(key.toString(), value));

      nameFinder.value = userProfile;

      return nameFinder.value!['username'];
    } catch (error) {
      debugPrint('Error al obtener información de perfil: $error');
      return 'Error';
    }
  }

  Future<void> obtenerLocation(String uid) async {
// Tu método aquí
    try {
      DataSnapshot dataSnapshot =
          await _databaseRef.child('location').child(uid).get();
      Map<dynamic, dynamic> userProfileMap =
          dataSnapshot.value as Map<dynamic, dynamic>;
      Map<String, dynamic> userProfile =
          userProfileMap.map((key, value) => MapEntry(key.toString(), value));

      locationCheck.value = userProfile;

      debugPrint(
          "el usuario $uid esta en linea:${locationCheck.value!['online']}");
    } catch (error) {
      debugPrint('Error al obtener información de perfil: $error');
    }
  }
}
