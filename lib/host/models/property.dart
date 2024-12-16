import 'dart:convert';
import 'package:balinchill/booking/models/booking.dart'; 

// Define the Property model that includes Hotel and Bookings
class Property {
  final int id;
  final String name;
  final String? category;
  final String? address;
  final String? contact;
  final String price;
  final String? amenities;
  final String? imageUrl;
  final String? location;
  final String? pageUrl;

  Property({
    required this.id,
    required this.name,
    this.category,
    this.address,
    this.contact,
    required this.price,
    this.amenities,
    this.imageUrl,
    this.location,
    this.pageUrl,
  });

  // Factory constructor to create a Property object from JSON
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['Hotel'] ?? 'Unknown Hotel',
      category: json['Category'],
      address: json['Address'],
      contact: json['Contact'],
      price: json['Price'],
      amenities: json['Amenities'],
      imageUrl: json['Image_URL'],
      location: json['Location'],
      pageUrl: json['Page_URL'],
    );
  }

  // Method to convert a Property object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Hotel': name,
      'Category': category,
      'Address': address,
      'Contact': contact,
      'Price': price,
      'Amenities': amenities,
      'Image_URL': imageUrl,
      'Location': location,
      'Page_URL': pageUrl,
    };
  }
}
