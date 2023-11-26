// quiero crear un controlador para el formulario de registro la informacion la quiero guardar en una base de datos

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'user_controller.dart';

class SingupController extends GetxController {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required String birthDate,
  }) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential uc = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserController userController = Get.find();
      await userController.createUser(email, uc.user!.uid);

      // Obtener el UID del usuario recién creado
      String uid = uc.user!.uid;

      // Guardar información adicional en la base de datos
      await _databaseRef.child('users').child(uid).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'birthDate': birthDate,
      });

      logInfo('User signed up successfully');
    } catch (error) {
      logError('Error during sign up: $error');
      return Future.error(error);
    }
  }
}
