import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/ubi_date.dart';
import 'authentication_controller.dart';

class UbiController extends GetxController {
  final _onlines = <Ubi>[].obs;
  final databaseRef = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> updateEntryStreamSubscription;
  bool isStarted = false;

  void start() {
    _onlines.clear();
    updateEntryStreamSubscription =
        databaseRef.child("location").onChildChanged.listen(_onEntryChanged);
    isStarted = true;
  }

  void stop() {
    updateEntryStreamSubscription.cancel();
    isStarted = false;
  }

  bool get started => isStarted;

  List<Ubi> get onlines => _onlines;

  _onEntryChanged(DatabaseEvent event) {
    final json = event.snapshot.value as Map<dynamic, dynamic>;

    // Busca el índice del elemento en _onlines que tiene la misma clave que el snapshot
    int index = _onlines.indexWhere((ubi) => ubi.key == event.snapshot.key);

    // Verifica si se encontró un índice válido
    if (index != -1) {
      // Actualiza el elemento en la lista con los datos del snapshot
      _onlines[index] = Ubi.fromJson(event.snapshot, json);
    } else {
      // Maneja el caso en el que no se encontró ningún elemento con la clave dada
      print(
          'No se encontró ningún elemento con la clave ${event.snapshot.key}');
    }
  }

  Future<void> obtenerDatosUsuarios() async {
    try {
      AuthenticationController authenticationController = Get.find();
      DatabaseReference locationRef = databaseRef.child('location');

      // Utiliza 'DatabaseEvent' en lugar de 'DataSnapshot'
      DatabaseEvent databaseEvent = await locationRef.once();

      // Accede al 'DataSnapshot' a través de la propiedad 'snapshot'
      DataSnapshot dataSnapshot = databaseEvent.snapshot;

      if (dataSnapshot.value == null || dataSnapshot.value is! Map) {
        logInfo(
            'No hay datos de usuarios disponibles o los datos no tienen el formato esperado');
        return;
      }

      Map<String, dynamic> dataMap =
          (dataSnapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>();

      _onlines.clear();
      int a = 0;
      dataMap.forEach((key, value) {
        String uid = key;
        if (uid != authenticationController.getUid()) {
          String latitude = value['latitud'] ?? '';
          String longitude = value['longitud'] ?? '';
          String online = value['online'] ?? '';

          _onlines.add(Ubi(key, latitude, longitude, online));
          debugPrint("a ${_onlines[a].key} is ${_onlines[a].online}");
          a++;
        }
      });
      debugPrint("numero online: ${onlines.length}");
      logInfo('Datos de usuarios obtenidos correctamente');
    } catch (error) {
      logError('Error al obtener datos de usuarios: $error');
      return Future.error(error);
    }
  }

  Future<void> ubi(
      String uid, String latitud, String longitud, String online) async {
    try {
      // Guardar información adicional en la base de datos
      await databaseRef
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
