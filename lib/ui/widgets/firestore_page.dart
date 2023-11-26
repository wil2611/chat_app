import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/perfil_controller.dart';

import '../controllers/chat_controller.dart';
import '../controllers/firestore_controller.dart';
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
  UserController userController = Get.find();
  UserProfileController perfilController = Get.find();

  @override
  void initState() {
    firestoreController.suscribeUpdates();
    userController.start();
    super.initState();
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
            email,
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
            'No users',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      return ListView.builder(
        itemCount: userController.users.length,
        itemBuilder: (context, index) {
          var element = userController.users[index];
          return FutureBuilder<String>(
            future: perfilController.obtenerNombre(element.uid),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                name = snapshot.data ?? "No_Name";
                return _item(element.uid, element.email, name);
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      );
    });
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
