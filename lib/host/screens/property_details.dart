import 'package:flutter/material.dart';
import 'package:balinchill/host/models/property.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/env.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  late ApiService apiService;
  late Future<Property> propertyDetails;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    apiService = ApiService(baseUrl: Env.backendUrl, request: request);
    propertyDetails = apiService.getPropertyDetails(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Details'),
        backgroundColor: Color(0xFFB89576),
      ),
      body: FutureBuilder<Property>(
        future: propertyDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final property = snapshot.data!;
            final proxiedImageUrl = apiService.getProxyImageUrl(property.imageUrl);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Image.network(
                    proxiedImageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/No_image.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    property.hotel,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Category: ${property.category}'),
                  Text('Price: \Rp${property.price}'),
                  Text('Address: ${property.address}'),
                  Text('Contact: ${property.contact}'),
                  Text('Amenities: ${property.amenities}'),
                  Text('Location: ${property.location}'),
                  Text('Page URL: ${property.pageUrl}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('Unexpected error occurred'));
          }
        },
      ),
    );
  }
}