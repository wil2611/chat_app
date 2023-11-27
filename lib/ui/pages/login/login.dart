import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warriors_of_fate/ui/controllers/ubi_controller.dart';
import 'signup.dart';
import '../../controllers/authentication_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: 'a@a.com');
  final controllerPassword = TextEditingController(text: '123456');
  final AuthenticationController authenticationController = Get.find();
  final UbiController ubiController = Get.find();
  void login(user, password) {
    ubiController.start();
    authenticationController.login(user, password);
    ubiController.obtenerDatosUsuarios();
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
              Color(0xFF0F0417),
              Color.fromARGB(255, 46, 44, 48),
              Color.fromARGB(255, 76, 83, 74),
              Color.fromARGB(255, 99, 82, 62),
              Color.fromARGB(255, 46, 57, 63),
              Color.fromARGB(255, 44, 14, 3),
              Color.fromARGB(255, 29, 9, 2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Inicio de sesión",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      labelText: "Email",
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTextField(
                      labelText: "Password",
                      controller: controllerPassword,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      icon: Icons.lock,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final form = _formKey.currentState;
                        form!.save();
                        login(controllerEmail.text, controllerPassword.text);
                        //ubicar();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(150, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: const Color(0xFF260B01),
                        side: const BorderSide(color: Color(0xFFD9A76A)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Establecer mainAxisSize en MainAxisSize.min
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons
                                .login, // Puedes cambiar este icono según tus necesidades
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(150, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: const Color(0xFF260B01),
                        side: const BorderSide(color: Color(0xFFD9A76A)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Establecer mainAxisSize en MainAxisSize.min
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons
                                .person_add, // Puedes cambiar este icono según tus necesidades
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create Account",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool obscureText = false,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD9A76A), width: 2.0),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return "Enter $labelText";
          } else if (labelText == "Email" && !value.contains('@')) {
            return "Enter valid email address";
          } else if (labelText == "Password" && value.length < 6) {
            return "Password should have at least 6 characters";
          }
          return null;
        },
      ),
    );
  }
}
