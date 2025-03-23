import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui_evo_2/login.dart';
import 'dart:convert';

import 'home_page.dart';
import 'text_feild.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool nameError = false;
  bool emailError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://ui-evolution.onrender.com/auth/signUp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "confirmPassword": confirmPasswordController.text.trim(),
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful!")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String errorMessage = responseData["message"] ?? "Registration failed!";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void validateAndSubmit() {
    setState(() {
      nameError = nameController.text.isEmpty;
      emailError = emailController.text.isEmpty;
      passwordError = passwordController.text.isEmpty;
      confirmPasswordError =
          confirmPasswordController.text.isEmpty ||
          confirmPasswordController.text != passwordController.text;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!nameError && !emailError && !passwordError && !confirmPasswordError) {
      registerUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),

                Text_Field(
                  hintText: 'Name',
                  controller: nameController,
                  borderColor: nameError ? Colors.red : null,
                ),
                const SizedBox(height: 15),

                Text_Field(
                  hintText: 'Email',
                  controller: emailController,
                  borderColor: emailError ? Colors.red : null,
                ),
                const SizedBox(height: 15),

                Text_Field(
                  hintText: 'Password',
                  isPassword: true,
                  controller: passwordController,
                  borderColor: passwordError ? Colors.red : null,
                ),
                const SizedBox(height: 15),

                Text_Field(
                  hintText: 'Confirm Password',
                  isPassword: true,
                  controller: confirmPasswordController,
                  borderColor: confirmPasswordError ? Colors.red : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
