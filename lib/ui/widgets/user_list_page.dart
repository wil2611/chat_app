
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/app_user.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/user_controller.dart';
import 'chat_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // Obtén la instancia de los controladores
  AuthenticationController authenticationController = Get.find();
  ChatController chatController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    // Suscribe al userController a los streams
    userController.start();
    super.initState();
  }

  @override
  void dispose() {
    // Cierra los streams del userController
    userController.stop();
    super.dispose();
  }

  _logout() async {
    try {
      await authenticationController.logout();
    } catch (e) {
      logError(e);
    }
  }

  Widget _item(AppUser element) {
    // Widget usado en la lista de los usuarios
    // Muestra el correo con un ícono
    return Card(
      margin: const EdgeInsets.all(4.0),
      color: Color(0xFF260B01), // Color de fondo para cada tarjeta
      child: ListTile(
        onTap: () {
          Get.to(() => const ChatPage(), arguments: [
            element.uid,
            element.email,
          ]);
        },
        leading: const Icon(
          Icons.email,
          color: Colors.white,
        ),
        title: Text(
          element.email,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _list() {
    // Un widget con La lista de los usuarios con una validación para cuándo la misma está vacía
    // La lista de usuarios se obtiene del userController
    return GetX<UserController>(builder: (controller) {
      if (userController.users.isEmpty) {
        return Center(
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
          return _item(element);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              //Color.fromARGB(255, 20, 20, 20),
              Color.fromARGB(255, 87, 87, 87),
              Color.fromARGB(255, 100, 100, 100),
              Color.fromARGB(255, 87, 87, 87),
              // Color.fromARGB(255, 20, 20, 20),
            ],
          ),
        ),
        child: _list(),
      ),
    );
  }
}
