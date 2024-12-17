import 'package:balinchill/host/screens/addproperty.dart';
import 'package:flutter/material.dart';
import 'package:balinchill/host/models/property.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Add this import
import 'package:balinchill/env.dart'; // Add this import

class HostDashboardPage extends StatefulWidget {
  @override
  _HostDashboardPageState createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  late ApiService apiService;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Get CookieRequest
    apiService = ApiService(baseUrl: '${Env.backendUrl}', request: request); // Initialize ApiService

    return Scaffold(
      appBar: AppBar(
        title: Text('My Properties'),
      ),
      body: FutureBuilder<List<Property>>(
        future: apiService.getHostProperties(), // Use apiService to fetch properties
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final properties = snapshot.data!;
            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return ListTile(
                  title: Text(property.hotel),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${property.category}'),
                      Text('Address: ${property.address}'),
                      Text('Contact: ${property.contact}'),
                      Text('Price: ${property.price}'),
                      Text('Amenities: ${property.amenities}'),
                      Text('Image URL: ${property.imageUrl}'),
                      Text('Location: ${property.location}'),
                      Text('Page URL: ${property.pageUrl}'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPropertyPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}