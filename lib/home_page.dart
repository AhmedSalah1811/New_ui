import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about.dart';
import 'build_nav_button.dart';
import 'chat_bot.dart';
import 'contact.dart';
import 'login.dart';
import 'subscription.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
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

  void navigateToOutputPage(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatBot()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 270,
              width: double.infinity,
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              color: Colors.white30,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            navigateToOutputPage(context);
                          } else {
                            setState(() {
                              errorMessage = "";
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text(
                          "Start Generate",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      if (userToken == null) ...[
                        const SizedBox(height: 9),
                        RichText(
                          text: TextSpan(
                            text: 'You have 3 free prompts, want more? ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const LoginPage(),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 70),
                        const Center(
                          child: Text(
                            'Why Choose UI Evolution?',
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          children: const [
                            Features(
                              title: 'Speed',
                              features: [
                                'Generate complete UI in seconds not hours. Streamline your development ',
                              ],
                            ),
                            Features(
                              title: 'Customization',
                              features: [
                                'Tailor every aspect of your UI to match your brand and requirements perfectly',
                              ],
                            ),
                            Features(
                              title: 'Professional',
                              features: [
                                'Get production-ready code that follows best practices and modern standards',
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
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
              buildNavButton(
                context,
                "assets/images/home.png",
                const HomePage(),
                widget.runtimeType,
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
                "assets/images/login.png",
                const LoginPage(),
                widget.runtimeType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
