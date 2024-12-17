import 'package:balinchill/host/screens/addproperty.dart';
import 'package:balinchill/host/screens/host.dart';
import 'package:flutter/material.dart';
import 'package:balinchill/screens/login.dart';
import 'package:balinchill/profile/profile_screens/viewprofile.dart';
import 'package:balinchill/services/api_service.dart';

class LeftDrawer extends StatelessWidget {
  final ApiService apiService;

  LeftDrawer({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFB89576),
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.hotel),
            title: Text('View Property'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HostDashboardPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Property'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPropertyPage()),
              );
            },
          ),          
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Perform any cleanup actions like clearing tokens or user data
              apiService.logout();  // Assuming you have a logout method in ApiService

              // Redirect user to the login screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,  // Removes all previous routes
              );
            },
          ),
        ],
      ),
    );
  }
}