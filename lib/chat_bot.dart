import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController promptController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;
  String? authToken;
  String? loginPromptMessage;
  int attemptCount = 0;

  @override
  void initState() {
    super.initState();
    loadTokenAndAttempts();
  }

  Future<void> loadTokenAndAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('user_token');
      attemptCount = prefs.getInt('attempt_count') ?? 0;

      if (authToken == null) {
        attemptCount = 0;
        prefs.setInt('attempt_count', 0);
      }
    });
  }

  Future<void> saveAttemptCount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('attempt_count', attemptCount);
  }

  Future<void> sendMessage() async {
    if (promptController.text.isEmpty) return;

    if (authToken == null && attemptCount >= 3) {
      setState(() {
        loginPromptMessage = "You have reached 3 prompts. Want more, please ";
      });
      return;
    }

    String userMessage = promptController.text;

    setState(() {
      messages.add({"role": "user", "message": userMessage});
      isLoading = true;
      loginPromptMessage = null;

      if (authToken == null) {
        attemptCount++;
        saveAttemptCount();
      }
    });

    promptController.clear();

    try {
      print('Sending message with token: $authToken');
      http.Response response;
      if (authToken != null) {
        response = await http.post(
          Uri.parse('https://aa77-196-129-117-75.ngrok-free.app/home/tryer'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $authToken",
            "ngrok-skip-browser-warning": "true",
          },
          body: jsonEncode({"message": userMessage}),
        );
      } else {
        response = await http.post(
          Uri.parse('https://aa77-196-129-117-75.ngrok-free.app/home/tryer'),
          headers: {
            "Content-Type": "application/json",
            "ngrok-skip-browser-warning": "true",
          },
          body: jsonEncode({"message": userMessage}),
        );
      }

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Image URL received: ${data['url']}');

        if (data['url'] != null && data['url'].isNotEmpty) {
          setState(() {
            messages.add({
              "role": "bot",
              "message": data['url'],
              "type": "image",
            });
          });
        } else {
          setState(() {
            messages.add({
              "role": "bot",
              "message": "⚠️ Image exists but can't be loaded",
              "type": "text",
            });
          });
        }
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "message": "⚠️ Error: Unable to fetch image",
            "type": "text",
          });
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        messages.add({
          "role": "bot",
          "message": "⚠️ Error: ${e.toString()}",
          "type": "text",
        });
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("UI Evolution Chat"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          if (loginPromptMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    loginPromptMessage!,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                if (message["role"] == "bot" && message["type"] == "image") {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      message["message"]!,
                      headers: {
                        "User-Agent": "Mozilla/5.0",
                      }, // حل لبعض الروابط المحمية
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('⚠️ Image can\'t load');
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:
                        message["role"] == "user"
                            ? Colors.blue
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message["message"]!,
                    style: TextStyle(
                      color:
                          message["role"] == "user"
                              ? Colors.white
                              : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promptController,
                    decoration: InputDecoration(
                      hintText: "Enter your prompt here...",
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
