import 'package:flutter/material.dart';

class HostPage extends StatelessWidget {
  const HostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.home,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Host Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('This is the page for hosts only.',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
