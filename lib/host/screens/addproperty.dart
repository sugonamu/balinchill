import 'package:balinchill/env.dart';
import 'package:balinchill/widgets/host_navbar.dart';
import 'package:flutter/material.dart';
import 'package:balinchill/host/models/property.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _hotelController = TextEditingController();
  final _categoryController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _priceController = TextEditingController();
  final _amenitiesController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationController = TextEditingController();
  final _pageUrlController = TextEditingController();

  late ApiService apiService;

  @override
  void dispose() {
    _hotelController.dispose();
    _categoryController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _priceController.dispose();
    _amenitiesController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    _pageUrlController.dispose();
    super.dispose();
  }

  void _submitProperty() async {
    if (_formKey.currentState!.validate()) {
      Property property = Property(
        id: '',
        hotel: _hotelController.text,
        category: _categoryController.text,
        address: _addressController.text,
        contact: _contactController.text,
        price: _priceController.text,
        amenities: _amenitiesController.text,
        imageUrl: _imageUrlController.text,
        location: _locationController.text,
        pageUrl: _pageUrlController.text,
      );

      try {
        await apiService.addProperty(property);
        Navigator.pop(context,true);
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add property: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    apiService = ApiService(baseUrl: '${Env.backendUrl}', request: request);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF997A57), // Tan color
        title: const Text('Add Property', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
        bottomNavigationBar: Navbar(
        apiService: apiService,
        currentIndex: 1, // add
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _hotelController,
                decoration: InputDecoration(labelText: 'Hotel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hotel name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amenitiesController,
                decoration: InputDecoration(labelText: 'Amenities'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amenities';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pageUrlController,
                decoration: InputDecoration(labelText: 'Page URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter page URL';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitProperty,
                child: Text('Add Property'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}