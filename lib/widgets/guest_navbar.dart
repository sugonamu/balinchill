import 'package:balinchill/booking/screens/homepage.dart';
import 'package:balinchill/payment/screens/booking_history.dart';
import 'package:flutter/material.dart';
import 'package:balinchill/auth/screens/login.dart';
import 'package:balinchill/profile/profile_screens/guest_viewprofile.dart';
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
          icon: Icon(Icons.home), // changed
          label: 'Homepage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history), // changed
          label: 'History',
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
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingHistoryPage()),
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
