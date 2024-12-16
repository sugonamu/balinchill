import 'package:flutter/material.dart';
import 'package:balinchill/host/models/property.dart';
import 'package:uuid/uuid.dart';

class AddPropertyPage extends StatefulWidget {
  final String username; // Logged-in user's username
  final Function(Property) onAddProperty;

  AddPropertyPage({
    required this.username,
    required this.onAddProperty,
  });

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _hotelNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _priceController = TextEditingController();
  final _amenitiesController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController(); // New field for image URL
  final _pageUrlController = TextEditingController();  // New field for page URL

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final newProperty = Property(
        id: Uuid().v4(), // Generate a unique UUID for the property
        host: widget.username, // Use the logged-in user's username
        hotelName: _hotelNameController.text,
        category: _categoryController.text,
        address: _addressController.text,
        contact: _contactController.text,
        price: _priceController.text,
        amenities: _amenitiesController.text,
        imageUrl: _imageUrlController.text,
        location: _locationController.text,
        pageUrl: _pageUrlController.text,
      );

      widget.onAddProperty(newProperty); // Add the new property to the list

      Navigator.pop(context); // Close the form and return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Property"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _hotelNameController,
                decoration: const InputDecoration(labelText: 'Hotel Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a hotel name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amenitiesController,
                decoration: const InputDecoration(labelText: 'Amenities'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pageUrlController,
                decoration: const InputDecoration(labelText: 'Page URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a page URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Add Property"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}