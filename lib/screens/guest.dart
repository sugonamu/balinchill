import 'package:flutter/material.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.travel_explore,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Guest Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('This is the page for guests only.',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
