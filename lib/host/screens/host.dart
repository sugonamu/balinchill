import 'package:flutter/material.dart';
import 'package:balinchill/host/models/property.dart';

class HostDashboardPage extends StatefulWidget {
  @override
  _HostDashboardPageState createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  // Mock data for properties (without fetching from an API)
  final List<Property> propertiesList = [
    Property(
      id: 1,
      name: 'Bali Beach Resort',
      category: 'Resort',
      address: '123 Beach Road, Bali',
      contact: '123-456-7890',
      price: '\$200 per night',
      amenities: 'Pool, Spa, Wi-Fi',
      imageUrl: 'https://example.com/image.jpg',
      location: 'Bali, Indonesia',
      pageUrl: 'https://example.com',
    ),
    Property(
      id: 2,
      name: 'Ubud Luxury Hotel',
      category: 'Hotel',
      address: '456 Jungle Ave, Ubud',
      contact: '987-654-3210',
      price: '\$150 per night',
      amenities: 'Gym, Restaurant, Wi-Fi',
      imageUrl: 'https://example.com/image2.jpg',
      location: 'Ubud, Bali',
      pageUrl: 'https://example.com',

    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Host Property")),
      body: propertiesList.isEmpty
          ? Center(child: Text('No hotels listed.'))
          : ListView.builder(
              itemCount: propertiesList.length,
              itemBuilder: (context, index) {
                Property property = propertiesList[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("Category: ${property.category ?? 'N/A'}"),
                        Text("Price: ${property.price}"),
                        Text("Location: ${property.location ?? 'N/A'}"),
                        Text("Address: ${property.address ?? 'N/A'}"),
                        Text("Contact: ${property.contact ?? 'N/A'}"),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to edit property page
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Implement delete property functionality
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
