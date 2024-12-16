import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:balinchill/env.dart';

class HostDashboardPage extends StatefulWidget {
  @override
  _HostDashboardPageState createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  List<Property> propertiesList = [];
  bool isLoading = false;

  // Function to send the data to the server (AJAX-like request)
  Future<void> _addPropertyAJAX(Property property) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    final url = Uri.parse('${Env.backendUrl}/add-property-ajax/'); 
    final response = await http.post(
      url,
      body: json.encode({
        'hotel': property.name,
        'category': property.category,
        'address': property.address,
        'price': property.price,
        'location': property.location,
        'contact': property.contact,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response and update the UI
      setState(() {
        propertiesList.add(property); // Add the property to the list
        isLoading = false; // Hide loading indicator
      });
      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Property added successfully!'),
      ));
    } else {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add property. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Host Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Show the Add Property modal
              _showAddPropertyModal();
            },
          ),
        ],
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
                      Property property = propertiesList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.name,
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPropertyModal();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Function to show the modal for adding a new property
  void _showAddPropertyModal() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _categoryController = TextEditingController();
    final _addressController = TextEditingController();
    final _priceController = TextEditingController();
    final _locationController = TextEditingController();
    final _contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Property'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Hotel Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter hotel name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter contact info';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Create a Property object and call the AJAX-like function
                  Property newProperty = Property(
                    name: _nameController.text,
                    category: _categoryController.text,
                    address: _addressController.text,
                    price: _priceController.text,
                    location: _locationController.text,
                    contact: _contactController.text,
                  );
                  _addPropertyAJAX(newProperty); // Send data to server asynchronously
                  Navigator.of(context).pop(); // Close the modal
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// Property class to model the property data
class Property {
  final String name;
  final String category;
  final String address;
  final String price;
  final String location;
  final String contact;

  Property({
    required this.name,
    required this.category,
    required this.address,
    required this.price,
    required this.location,
    required this.contact,
  });
}
