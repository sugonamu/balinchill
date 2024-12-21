import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/env.dart';

class EditPropertyPage extends StatefulWidget {
  final String propertyId;

  const EditPropertyPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
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
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    apiService = ApiService(baseUrl: Env.backendUrl, request: request);
    _loadPropertyDetails();
  }

  Future<void> _loadPropertyDetails() async {
    try {
      final property = await apiService.getPropertyDetails(widget.propertyId);
      _hotelController.text = property.hotel;
      _categoryController.text = property.category;
      _addressController.text = property.address;
      _contactController.text = property.contact;
      _priceController.text = property.price;
      _amenitiesController.text = property.amenities;
      _imageUrlController.text = property.imageUrl;
      _locationController.text = property.location;
      _pageUrlController.text = property.pageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

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

  Future<void> _editProperty() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await apiService.editProperty(
          widget.propertyId,
          _hotelController.text,
          _categoryController.text,
          _addressController.text,
          _contactController.text,
          _priceController.text,
          _amenitiesController.text,
          _imageUrlController.text,
          _locationController.text,
          _pageUrlController.text,
        );
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF997A57), // Tan color
        title: const Text('Edit Property', style: TextStyle(color: Colors.white)),
        centerTitle: true,      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    return 'Please enter contact information';
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editProperty,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}