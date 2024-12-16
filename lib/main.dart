import 'package:flutter/material.dart';
import 'package:balinchill/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';  
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'BaliNChill',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.brown,
          ).copyWith(secondary: const Color(0xFFB89576)),
        ),
        home: LoginPage(),
      ),
    );
  }
}