import 'package:chat_app/ui/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firestore_controller.dart';

class FireStorePage extends StatefulWidget {
  const FireStorePage({super.key});

  @override
  State<FireStorePage> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireStorePage> {
  final FirestoreController firestoreController = Get.find();
  final ChatController chatController = Get.find();

  @override
  void initState() {
    firestoreController.suscribeUpdates();
    super.initState();
  }

  @override
  void dispose() {
    firestoreController.suscribeUpdates();
    super.dispose();
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
              //Color.fromARGB(255, 20, 20, 20),
              Color.fromARGB(255, 87, 87, 87),
              Color.fromARGB(255, 100, 100, 100),
              Color.fromARGB(255, 87, 87, 87),
              // Color.fromARGB(255, 20, 20, 20),
            ],
          ),
        ),
      ),
    );
  }
}
