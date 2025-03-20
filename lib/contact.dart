import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'about.dart';
import 'build_nav_button.dart';
import 'home_page.dart';
import 'profile.dart';
import 'subscription.dart';
import 'text_feild.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<ContactPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  // دالة إرسال الفيدباك إلى السيرفر
  void sendFeedback() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String message = messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final url = Uri.parse("https://ui-evolution.onrender.com/home/feedback");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "message": message}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback sent successfully!")),
      );
      nameController.clear();
      emailController.clear();
      messageController.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send feedback")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Center(
                child: Text(
                  'Get in Touch',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Have a question? We would love to hear from you.\nSend us a message and we will respond soon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 50),

              // Name Field
              const Text(
                "Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text_Field(
                hintText: 'Enter your name',
                controller: nameController,
              ),

              const SizedBox(height: 20),

              // Email Field
              const Text(
                "Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text_Field(
                hintText: 'Enter your email',
                controller: emailController,
              ),

              const SizedBox(height: 20),

              // Message Field
              const Text(
                "Message",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 120,
                child: Text_Field(
                  hintText: 'Enter your message',
                  controller: messageController,
                ),
              ),

              const SizedBox(height: 30),

              // Send Button
              Center(
                child: ElevatedButton(
                  onPressed: sendFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // زر الهوم
              IconButton(
                icon: Image.asset("assets/images/home.png"),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('user_token');
                  if (token != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
              ),

              buildNavButton(
                context,
                "assets/images/about.png",
                AboutPage(),
                widget.runtimeType,
              ),
              buildNavButton(
                context,
                "assets/images/subscrption.png",
                const Subscription(),
                widget.runtimeType,
              ),
              buildNavButton(
                context,
                "assets/images/contact.png",
                const ContactPage(),
                widget.runtimeType,
              ),
              buildNavButton(
                context,
                "assets/images/profile.png",
                const ProfilePage(),
                widget.runtimeType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
