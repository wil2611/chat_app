import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../controllers/singup_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _FirebaseSignUpState();
}

class _FirebaseSignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: 'a@a.com');
  final controllerPassword = TextEditingController(text: '123456');
  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerBirthDate = TextEditingController();
  final controllerUsername = TextEditingController();
  SingupController signupController = SingupController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      controllerBirthDate.text = "${picked.day}/${picked.month}/${picked.year}";
    }
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
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: const Color(0xFFD9A76A),
                          iconSize: 50,
                          onPressed: () {
                            Get.back(); // Navegar hacia atrás cuando se presiona el botón de retroceso
                          },
                        ),
                      ],
                    ),
                    const Text(
                      "Information",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTextField(
                      labelText: "Email address",
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      labelText: "Password",
                      controller: controllerPassword,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      icon: Icons.lock,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      labelText: "First Name",
                      controller: controllerFirstName,
                      keyboardType: TextInputType.text,
                      icon: Icons.person,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      labelText: "Last Name",
                      controller: controllerLastName,
                      keyboardType: TextInputType.text,
                      icon: Icons.person,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      labelText: "Username",
                      controller: controllerUsername,
                      keyboardType: TextInputType.text,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextField(
                      labelText: "Birth Date",
                      controller: controllerBirthDate,
                      keyboardType: TextInputType.text,
                      icon: Icons.date_range,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final form = _formKey.currentState;
                        form!.save();

                        // Cierra el teclado
                        FocusScope.of(context).requestFocus(FocusNode());

                        if (form.validate()) {
                          try {
                            await signupController.signUp(
                              email: controllerEmail.text,
                              password: controllerPassword.text,
                              firstName: controllerFirstName.text,
                              lastName: controllerLastName.text,
                              username: controllerUsername.text,
                              birthDate: controllerBirthDate.text,
                            );

                            logInfo('SignUp successful');
                            Get.back(); // Navegar hacia atrás después del registro exitoso
                          } catch (error) {
                            logError('Error during sign up: $error');
                            // Puedes manejar el error de alguna manera, por ejemplo, mostrar un mensaje al usuario
                          }
                        } else {
                          logError('SignUp validation failed');
                        }
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
            ),
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
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        onTap: onTap,
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
          } else if (labelText == "Email address" && !value.contains('@')) {
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

bool isValidDateFormat(String input) {
  const datePattern = r'^\d{2}/\d{2}/\d{4}$';
  if (RegExp(datePattern).hasMatch(input)) {
    final parts = input.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day != null && month != null && year != null) {
      if (day >= 1 && day <= 31 && month >= 1 && month <= 12) {
        // Consider checking for valid years, e.g., if you want to restrict the range.
        return true;
      }
    }
  }
  return false;
}
