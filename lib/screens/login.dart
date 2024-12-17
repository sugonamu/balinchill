import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:balinchill/screens/register.dart';
import 'package:balinchill/host/screens/host.dart';
import 'package:balinchill/screens/guest.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/booking/screens/homepage.dart';
import 'package:balinchill/env.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String? selectedRole; // Field to store the passed role

  const LoginPage({super.key, this.selectedRole}); // Constructor to receive the role

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        color: Color(0xFFF9F9F9), // Light grey background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Bali N Chill',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB89576),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.transparent, // Set the card's background to transparent
                    elevation: 0, // Remove shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: () async {
                              String username = _usernameController.text;
                              String password = _passwordController.text;

                              final response = await request.login(
                                "${Env.backendUrl}/auth/login/",
                                {
                                  'username': username,
                                  'password': password,
                                },  
                              );

                              if (request.loggedIn) {
                                String message = response['message'] ?? 'No message provided';
                                String uname = response['username'] ?? 'Unknown user';
                                String role = response['role'] ?? '';

                                if (context.mounted) {
                                  print("Response: $response");

                                  if (role.isNotEmpty) {
                                    if (role == 'host') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HostDashboardPage()),
                                      );
                                    } else if (role == 'guest') {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomePage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invalid role assigned!')),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Role is missing from the response!')),
                                    );
                                  }

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(content: Text("$message Welcome, $uname. Your role: $role")),
                                    );
                                }
                              } else {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Login Failed'),
                                      content: Text(response['message'] ?? 'Login failed without message'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Color(0xFFB89576),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text('Log in'),
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Color(0xFF8D7052),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Create new account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
