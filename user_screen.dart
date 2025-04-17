import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'splash_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? name, email, phone, country, imageUrl;
  bool isLoading = false;

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['results'][0];

        setState(() {
          name = '${user['name']['title']} ${user['name']['first']} ${user['name']['last']}';
          email = user['email'];
          phone = user['phone'];
          country = user['location']['country'];
          imageUrl = user['picture']['large'];
          isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User loaded successfully')),
        );
      } else {
        showError();
      }
    } catch (e) {
      showError();
    }
  }

  void showError() {
    setState(() {
      name = null;
      email = null;
      phone = null;
      country = null;
      imageUrl = null;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load user. Please try again.')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random User Info', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pinkAccent, Colors.purpleAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const CircularProgressIndicator()
                else if (name != null)
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (imageUrl != null)
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(imageUrl!),
                            ),
                          const SizedBox(height: 12),
                          buildInfoRow("Name", name!),
                          buildInfoRow("Email", email!),
                          buildInfoRow("Phone", phone!),
                          buildInfoRow("Country", country!),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchUser,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(180, 40),
                  ),
                  child: const Text("Load Another User", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
