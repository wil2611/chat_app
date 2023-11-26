import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/perfil_controller.dart';

class UserProfileViewPage extends StatelessWidget {
  UserProfileViewPage({Key? key}) : super(key: key);
  final UserProfileController userProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () {
            if (userProfileController.userProfileData.value != null) {
              Map<String, dynamic> userProfileData =
                  userProfileController.userProfileData.value!;
              return Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        Icons.mail,
                        'Correo',
                        userProfileController.user.value!.email ?? 'N/A',
                      ),
                      _buildInfoCard(
                        Icons.confirmation_number,
                        'UID',
                        userProfileController.user.value!.uid,
                      ),
                      _buildInfoCard(
                        Icons.person,
                        'Nombre',
                        '${userProfileData["firstName"]} ${userProfileData["lastName"]}',
                      ),
                      _buildInfoCard(
                        Icons.account_circle,
                        'Nombre de usuario',
                        userProfileData["username"],
                      ),
                      _buildInfoCard(
                        Icons.cake,
                        'Fecha de nacimiento',
                        userProfileData["birthDate"],
                      ),
                      // Puedes agregar más campos según sea necesario
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey[800],
                ),
                const SizedBox(width: 8.0),
                Text(
                  '$label:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(fontSize: 15.0, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}
