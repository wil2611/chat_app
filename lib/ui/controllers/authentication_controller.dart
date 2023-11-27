import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_controller.dart';

class AuthenticationController extends GetxController {
  final databaseRef = FirebaseDatabase.instance.ref();

  Future<void> login(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return Future.value();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error("User not found");
      } else if (e.code == 'wrong-password') {
        return Future.error("Wrong password");
      }
    }
  }

  Future<void> signup(email, password) async {
    try {
      UserCredential uc = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserController userController = Get.find();
      await userController.createUser(email, uc.user!.uid);

      return Future.value();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error("The password is too weak");
      } else if (e.code == 'email-already-in-use') {
        return Future.error("The email is taken");
      }
    }
  }

  logout() async {
    try {
      debugPrint("logout");
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return Future.error("Logout error");
    }
  }

  String userEmail() {
    String email = FirebaseAuth.instance.currentUser!.email ?? "a@a.com";
    return email;
  }

  String getUid() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Verificar si currentUser es nulo
    if (currentUser != null) {
      String uid = currentUser.uid;
      return uid;
    } else {
      // Manejar el caso en el que currentUser es nulo
      // Puedes devolver un valor predeterminado o lanzar un error, según tus necesidades.
      return 'Usuario no autenticado';
    }
  }
}
