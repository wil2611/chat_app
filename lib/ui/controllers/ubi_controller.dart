import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class UbiController extends GetxController {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<void> ubi(
      String uid, String latitud, String longitud, String online) async {
    try {
      // Guardar información adicional en la base de datos
      await _databaseRef
          .child('location')
          .child(uid)
          .set({'latitud': latitud, 'longitud': longitud, 'online': online});

      logInfo('location up successfully');
    } catch (error) {
      logError('Error during location up: $error');
      return Future.error(error);
    }
  }
}
