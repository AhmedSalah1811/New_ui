import 'package:flutter/material.dart';

import 'build_nav_button.dart';
import 'home_page.dart';
import 'login.dart';

import 'subscription.dart';
import 'contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? userToken;

  @override
  void initState() {
    super.initState();
    _checkUserToken();
  }

  Future<void> _checkUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavButton(
                context,
                "assets/images/home.png",
                const HomePage(),
                widget.runtimeType,
              ),
              buildNavButton(
                context,
                "assets/images/about.png",
                const AboutPage(),
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
              if (userToken == null)
                buildNavButton(
                  context,
                  "assets/images/login.png",
                  const LoginPage(),
                  widget.runtimeType,
                ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Features',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              'assets/images/logo.png',
              height: 280,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FeaturesBox(
                      title: 'Component Library',
                      description:
                          'Access a vast library of pre-built components ready to use in your project.',
                    ),
                    FeaturesBox(
                      title: 'Responsive Design',
                      description:
                          'All generated UIs are fully responsive and work perfectly on any device.',
                    ),
                    FeaturesBox(
                      title: 'Theme Customization',
                      description:
                          'Customize colors, fonts, and styles to match your brand identity.',
                    ),
                    FeaturesBox(
                      title: 'Export Options',
                      description:
                          'Export your UI in multiple formats including Flutter, React, and HTML.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturesBox extends StatelessWidget {
  final String title;
  final String description;

  const FeaturesBox({Key? key, required this.title, required this.description})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
