import 'package:balinchill/host/screens/addproperty.dart';
import 'package:balinchill/host/screens/edit_property.dart';
import 'package:balinchill/host/screens/property_details.dart'; // Import the PropertyDetailsPage
import 'package:flutter/material.dart';
import 'package:balinchill/host/models/property.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/env.dart';
import 'package:balinchill/widgets/host_navbar.dart'; // Import the LeftDrawer

class HostDashboardPage extends StatefulWidget {
  @override
  _HostDashboardPageState createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  late ApiService apiService;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    apiService = ApiService(baseUrl: '${Env.backendUrl}', request: request);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Properties'),
        backgroundColor: Color(0xFFB89576),
      ),
      bottomNavigationBar: Navbar(
        apiService: apiService,
        currentIndex: 0, // add
      ),
      body: FutureBuilder<List<Property>>(
        future: apiService.getHostProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading properties: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No properties found. Add your first property!',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            final properties = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: properties.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final property = properties[index];
                final proxiedImageUrl = apiService.getProxyImageUrl(property.imageUrl);
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Image
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(proxiedImageUrl),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) {
                                    // Handle the error by setting a placeholder image
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Property Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.hotel,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text('Category: ${property.category}'),
                                  Text('Price: \Rp${property.price}'),
                                  Text('Address: ${property.address}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Amenities and Contact
                        Text('Amenities: ${property.amenities}'),
                        Text('Contact: ${property.contact}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PropertyDetailsPage(propertyId: property.id),
                                  ),
                                );
                              },
                              child: Text('View More Details'),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPropertyPage(propertyId: property.id),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {}); // Refresh the properties list
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text(
                                        'Are you sure you want to delete this property?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  try {
                                    await apiService.deleteProperty(property.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Property deleted successfully!')),
                                    );
                                    setState(() {});
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Unexpected error occurred'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPropertyPage()),
          );
          if (result == true) {
            setState(() {}); // Refresh the properties list
          }
        },
        backgroundColor: Colors.teal,
        tooltip: 'Add Property',
        child: Icon(Icons.add),
      ),
    );
  }
}