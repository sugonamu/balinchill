// hotel.dart
class Hotel {
  final int id;
  final String hotelName;
  final String price;
  final double avgRating;
  final int reviewCount;

  Hotel({required this.id, required this.hotelName, required this.price, required this.avgRating, required this.reviewCount});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      hotelName: json['Hotel'],
      price: json['Price'],
      avgRating: json['avg_rating'] ?? 0.0,
      reviewCount: json['review_count'],
    );
  }
}

// rating.dart
class Rating {
  final int id;
  final String user;
  final int rating;
  final String review;

  Rating({required this.id, required this.user, required this.rating, required this.review});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      user: json['user'],
      rating: json['rating'],
      review: json['review'] ?? '',
    );
  }
}
