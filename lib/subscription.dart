import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'about.dart';
import 'build_nav_button.dart';
import 'contact.dart';
import 'home_page.dart';
import 'profile.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  _AboutSubscriptionState createState() => _AboutSubscriptionState();
}

class _AboutSubscriptionState extends State<Subscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Simple, Transparent Pricing',
          style: TextStyle(color: Colors.blue, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              PriceDetails(
                title: 'Starter',
                price: '29',
                duration: '/month',
                features: [
                  'Up to 5 projects',
                  'Basic Components',
                  'Email Support',
                ],
              ),
              PriceDetails(
                title: 'Pro',
                price: '59',
                duration: '/month',
                features: [
                  'Up to 10 projects',
                  'Advanced Components',
                  'Priority Support',
                  'Collaboration Tools',
                ],
              ),
              PriceDetails(
                title: 'Enterprise',
                price: '99',
                duration: '/month',
                features: [
                  'Unlimited projects',
                  'All Components',
                  'Dedicated Support',
                  'Custom Solutions',
                ],
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

class PriceDetails extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final List<String> features;

  const PriceDetails({
    Key? key,
    required this.title,
    required this.price,
    required this.duration,
    required this.features,
  }) : super(key: key);

  void sendSubscription(BuildContext context) async {
    final url = Uri.parse("https://ui-evolution.onrender.com/home/subscribe");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"plan": title, "price": price, "duration": duration}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Subscription Successful: $title")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subscription Failed, Try Again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(color: Colors.black, fontSize: 22),
              ),
              Text(
                duration,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '* $feature',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 280,
            child: ElevatedButton(
              onPressed: () => sendSubscription(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
