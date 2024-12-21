import 'package:balinchill/host/screens/addproperty.dart';
import 'package:balinchill/host/screens/host.dart';
import 'package:flutter/material.dart';
import 'package:balinchill/auth/screens/login.dart';
import 'package:balinchill/profile/profile_screens/host_viewprofile.dart';
import 'package:balinchill/services/api_service.dart';

class Navbar extends StatelessWidget {
  final ApiService apiService;
  final int currentIndex; // add

  Navbar({required this.apiService, this.currentIndex = 0}); // add

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // add
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work), // changed
          label: 'View Property',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_business), // changed
          label: 'Add Property',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HostDashboardPage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPropertyPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break;
          case 3:
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        apiService.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Logout'),
                    ),
                  ],
                );
              },
            );
            break;
        }
      },
    );
  }
}
