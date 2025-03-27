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
      http.Response response = await http.post(
        Uri.parse('https://2395-196-129-117-75.ngrok-free.app/home/chat'),
        headers: {
          "Content-Type": "application/json",
          if (authToken != null) "Authorization": "Bearer $authToken",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({"message": userMessage}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String? imageUrl = data['imagePath'];

        if (imageUrl != null && imageUrl.isNotEmpty) {
          setState(() {
            messages.add({"role": "bot", "message": imageUrl, "type": "image"});
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
      appBar: AppBar(centerTitle: true,iconTheme: IconThemeData.fallback().copyWith(color: Colors.white),
        title: const Text("UI Evolution Chat",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
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
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image: message["message"]!,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return const Text('⚠️ Image can"t load');
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
