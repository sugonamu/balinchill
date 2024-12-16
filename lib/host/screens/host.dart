import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:balinchill/env.dart';
import 'package:uuid/uuid.dart';
import 'package:balinchill/host/models/property.dart';

class HostDashboardPage extends StatefulWidget {
  final String username;

  const HostDashboardPage({required this.username});

  @override
  _HostDashboardPageState createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  List<Property> propertiesList = [];
  bool isLoading = false;

  // Function to send the data to the server (AJAX-like request)
  Future<void> _addPropertyAJAX(Property property) async {
    setState(() {
      propertiesList.add(property);
      isLoading = true;
    });

    final url = Uri.parse('${Env.backendUrl}/auth/addproperty/');
    final response = await http.post(
      url,
      body: json.encode(property.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      setState(() {
        propertiesList.removeWhere((p) => p.id == property.id);
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add property. Please try again.')),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property added successfully!')),
      );
    }
  }

  // Function to edit property details
  Future<void> _editPropertyAJAX(String propertyId, Property updatedProperty) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('${Env.backendUrl}/editproperty/$propertyId/');
    final response = await http.post(
      url,
      body: json.encode(updatedProperty.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        final index = propertiesList.indexWhere((p) => p.id == propertyId);
        if (index != -1) {
          propertiesList[index] = updatedProperty;
        }
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property updated successfully!')),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update property. Please try again.')),
      );
    }
  }

  // Function to delete property
  Future<void> _deletePropertyAJAX(String propertyId) async {
    setState(() {
      propertiesList.removeWhere((property) => property.id == propertyId);
      isLoading = true;
    });

    final url = Uri.parse('${Env.backendUrl}/auth/property/delete/$propertyId/');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete property. Please try again.')),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property deleted successfully!')),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Host Dashboard'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : propertiesList.isEmpty
              ? Center(child: Text('No properties listed yet.'))
              : ListView.builder(
                  itemCount: propertiesList.length,
                  itemBuilder: (context, index) {
                    final property = propertiesList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.hotelName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("Category: ${property.category}"),
                            Text("Price: ${property.price}"),
                            Text("Location: ${property.location}"),
                            Text("Address: ${property.address}"),
                            Text("Contact: ${property.contact}"),
                            Text("Amenities: ${property.amenities}"),
                            Text("Page URL: ${property.pageUrl}"),
                            Text("Image URL: ${property.imageUrl}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _showEditPropertyModal(property),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deletePropertyAJAX(property.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddPropertyModal,
      backgroundColor: Colors.blue, // Makes the button blue
      child: Icon(Icons.add),
      tooltip: 'Add Property',
    ),
  );
}


  // Show modal to add property
  void _showAddPropertyModal() {
    final _formKey = GlobalKey<FormState>();
    final controllers = {
      'hotelName': TextEditingController(),
      'category': TextEditingController(),
      'address': TextEditingController(),
      'price': TextEditingController(),
      'location': TextEditingController(),
      'contact': TextEditingController(),
      'amenities': TextEditingController(),
      'imageUrl': TextEditingController(),
      'pageUrl': TextEditingController(),
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Property'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: controllers.keys.map((key) {
                  return PropertyFormField(
                    controller: controllers[key]!,
                    label: key.replaceFirst(key[0], key[0].toUpperCase()),
                    validator: (value) => value!.isEmpty ? 'Please enter $key' : null,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newProperty = Property(
                    id: Uuid().v4(),
                    host: widget.username,
                    hotelName: controllers['hotelName']!.text,
                    category: controllers['category']!.text,
                    address: controllers['address']!.text,
                    price: controllers['price']!.text,
                    location: controllers['location']!.text,
                    contact: controllers['contact']!.text,
                    amenities: controllers['amenities']!.text,
                    imageUrl: controllers['imageUrl']!.text,
                    pageUrl: controllers['pageUrl']!.text,
                  );
                  _addPropertyAJAX(newProperty);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Show modal to edit property
  void _showEditPropertyModal(Property property) {
    final _formKey = GlobalKey<FormState>();
    final controllers = {
      'hotelName': TextEditingController(text: property.hotelName),
      'category': TextEditingController(text: property.category),
      'address': TextEditingController(text: property.address),
      'price': TextEditingController(text: property.price),
      'location': TextEditingController(text: property.location),
      'contact': TextEditingController(text: property.contact),
      'amenities': TextEditingController(text: property.amenities),
      'imageUrl': TextEditingController(text: property.imageUrl),
      'pageUrl': TextEditingController(text: property.pageUrl),
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Property'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: controllers.keys.map((key) {
                  return PropertyFormField(
                    controller: controllers[key]!,
                    label: key.replaceFirst(key[0], key[0].toUpperCase()),
                    validator: (value) => value!.isEmpty ? 'Please enter $key' : null,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedProperty = Property(
                    id: property.id,
                    host: widget.username,
                    hotelName: controllers['hotelName']!.text,
                    category: controllers['category']!.text,
                    address: controllers['address']!.text,
                    price: controllers['price']!.text,
                    location: controllers['location']!.text,
                    contact: controllers['contact']!.text,
                    amenities: controllers['amenities']!.text,
                    imageUrl: controllers['imageUrl']!.text,
                    pageUrl: controllers['pageUrl']!.text,
                  );
                  _editPropertyAJAX(property.id, updatedProperty);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// Reusable PropertyFormField widget
class PropertyFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;

  const PropertyFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
