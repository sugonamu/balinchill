import 'dart:convert';

// Parse JSON response to a list of Hotel objects
List<Hotel> hotelFromJson(String str) =>
    List<Hotel>.from(json.decode(str).map((x) => Hotel.fromJson(x)));

// Convert a list of Hotel objects to JSON
String hotelToJson(List<Hotel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Hotel {
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
  final double? averageRating;
  final int ratingCount;

  Hotel({
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
    this.averageRating,
    required this.ratingCount,
  });

  // Factory constructor to create a Hotel object from JSON
  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
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
        averageRating: json['avg_rating'] != null
            ? double.tryParse(json['avg_rating'].toString())
            : null,
        ratingCount: json['review_count'] ?? 0,
      );

  // Method to convert a Hotel object to JSON
  Map<String, dynamic> toJson() => {
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
        'avg_rating': averageRating,
        'review_count': ratingCount,
      };
}

// Parse JSON response to a list of Rating objects
List<Rating> ratingFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

// Convert a list of Rating objects to JSON
String ratingToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  final int id;
  final int hotelId;
  final int userId;
  final int rating;
  final String? review;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  // Factory constructor to create a Rating object from JSON
  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json['id'],
        hotelId: json['hotel'],
        userId: json['user'],
        rating: json['rating'],
        review: json['review'],
        createdAt: DateTime.parse(json['created_at']),
      );

  // Method to convert a Rating object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'hotel': hotelId,
        'user': userId,
        'rating': rating,
        'review': review,
        'created_at': createdAt.toIso8601String(),
      };
}