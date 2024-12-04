import 'dart:convert';

List<Rating> ratingFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  final String model;
  final int pk;
  final Fields fields;

  Rating({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  final int hotel;
  final int user;
  final int rating;
  final String? review; // Nullable to match your model
  final DateTime createdAt;

  Fields({
    required this.hotel,
    required this.user,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        hotel: json["hotel"],
        user: json["user"],
        rating: json["rating"],
        review: json["review"], // Nullable field
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "hotel": hotel,
        "user": user,
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
      };
}
