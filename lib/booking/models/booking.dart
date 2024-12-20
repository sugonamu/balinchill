import 'dart:convert';

// Utility function to clean unwanted symbols and parse numeric values
int sanitizeAndParsePrice(String text) {
  final sanitizedText = text.replaceAll('Â', '').replaceAll(RegExp('[^0-9]'), '').trim();
  return int.tryParse(sanitizedText) ?? 0; // Default to 0 if parsing fails
}

// Utility function to clean other text fields
String sanitizeText(String text) {
  return text.replaceAll('Â', '').trim();
}

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
  final int price; // Changed to int
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

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: sanitizeText(json['Hotel'] ?? 'Unknown Hotel'),
      category: json['Category'],
      address: sanitizeText(json['Address'] ?? ''),
      contact: sanitizeText(json['Contact'] ?? ''),
      price: sanitizeAndParsePrice(json['Price']), // Parse price as int
      amenities: sanitizeText(json['Amenities'] ?? ''),
      imageUrl: json['Image_URL'],
      location: sanitizeText(json['Location'] ?? ''),
      pageUrl: json['Page_URL'],
      averageRating: json['avg_rating'] != null
          ? double.tryParse(json['avg_rating'].toString())
          : null,
      ratingCount: json['review_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'Hotel': name,
        'Category': category,
        'Address': address,
        'Contact': contact,
        'Price': price.toString(),
        'Amenities': amenities,
        'Image_URL': imageUrl,
        'Location': location,
        'Page_URL': pageUrl,
        'avg_rating': averageRating,
        'review_count': ratingCount,
      };
}

class HotelDetail {
  final int id;
  final String name;
  final String imageUrl;
  final int price; // Changed from double to int
  final String amenities;
  final String location;
  final List<Rating> ratings;
  final List<HotelBasic> relatedHotels;

  HotelDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.amenities,
    required this.location,
    required this.ratings,
    required this.relatedHotels,
  });

  factory HotelDetail.fromJson(Map<String, dynamic> json) {
    return HotelDetail(
      id: json['id'],
      name: sanitizeText(json['Hotel']),
      imageUrl: json['Image_URL'],
      price: sanitizeAndParsePrice(json['Price']), // Parse price as int
      amenities: sanitizeText(json['Amenities'] ?? ''),
      location: sanitizeText(json['Location'] ?? ''),
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((r) => Rating.fromJson(r))
              .toList() ??
          [],
      relatedHotels: (json['related_hotels'] as List<dynamic>?)
              ?.map((rh) => HotelBasic.fromJson(rh))
              .toList() ??
          [],
    );
  }
}

class Rating {
  final String username;
  final double rating;
  final String review;
  final String createdAt;

  Rating({
    required this.username,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      username: sanitizeText(json['user']['username']),
      rating: (json['rating'] as num).toDouble(),
      review: sanitizeText(json['review']),
      createdAt: sanitizeText(json['created_at']),
    );
  }
}

class HotelBasic {
  final int id;
  final String name;
  final String imageUrl;
  final int price; // Changed from double to int

  HotelBasic({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory HotelBasic.fromJson(Map<String, dynamic> json) {
    return HotelBasic(
      id: json['id'],
      name: sanitizeText(json['Hotel']),
      imageUrl: json['Image_URL'],
      price: sanitizeAndParsePrice(json['Price']), // Parse price as int
    );
  }
}
