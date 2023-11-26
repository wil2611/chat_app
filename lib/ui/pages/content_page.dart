import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../controllers/authentication_controller.dart';
import '../controllers/perfil_controller.dart';
import '../widgets/firestore_page.dart';
import '../widgets/perfil_page.dart';
import '../widgets/user_list_page.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  int _selectIndex = 0;
  AuthenticationController authenticationController = Get.find();
  UserProfileController userProfileController =
      Get.put(UserProfileController());

  static final List<Widget> _widgets = <Widget>[
    const FireStorePage(),
    const UserListPage(),
    UserProfileViewPage(),
  ];

  _logout() async {
    try {
      await authenticationController.logout();
    } catch (e) {
      logError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0417),
        title: Text("Welcome ${authenticationController.userEmail()}"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              size: 30,
            ),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Container(
        child: _widgets.elementAt(_selectIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xFF111111),
          buttonBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          color: const Color(0xFF111111),
          height: 50,
          index: _selectIndex,
          items: <Widget>[
            Icon(
              Icons.sports_martial_arts,
              size: 35,
              color: _selectIndex == 0 ? Colors.black : Colors.white,
            ),
            Icon(
              Icons.chat,
              size: 35,
              color: _selectIndex == 1 ? Colors.black : Colors.white,
            ),
            Icon(
              Icons.assignment_ind,
              size: 35,
              color: _selectIndex == 2 ? Colors.black : Colors.white,
            ),
          ],
          letIndexChange: (index) {
            return true;
          },
          animationCurve: Curves.bounceInOut,
          animationDuration: const Duration(milliseconds: 170),
          onTap: (index) {
            setState(() {
              _selectIndex = index;
            });
          }),
    );
  }
}
