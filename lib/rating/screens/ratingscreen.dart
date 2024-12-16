import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Rating and Fields model
class Fields {
  final int hotel;
  final int user;
  final int rating;
  final String? review;
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
        review: json["review"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}

class Rating {
  final Fields fields;

  Rating({
    required this.fields,
  });

  factory Rating.fromJson(Map<String, dynamic> json) =>
      Rating(fields: Fields.fromJson(json["fields"]));
}

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({Key? key}) : super(key: key);

  @override
  _RatingsScreenState createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  late Future<List<Rating>> _ratings;

  // Fetch data from Django API
  Future<List<Rating>> fetchRatings() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/ratings/json/')); 

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((rating) => Rating.fromJson(rating)).toList();
    } else {
      throw Exception('Failed to load ratings');
    }
  }

  @override
  void initState() {
    super.initState();
    _ratings = fetchRatings(); // Fetch data when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ratings Test Screen")),
      body: FutureBuilder<List<Rating>>(
        future: _ratings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ratings available.'));
          } else {
            final ratings = snapshot.data!;
            return ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final rating = ratings[index];
                return ListTile(
                  title: Text("Hotel ID: ${rating.fields.hotel}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display stars based on the rating value
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < rating.fields.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24.0,
                          );
                        }),
                      ),
                      if (rating.fields.review != null)
                        Text("Review: ${rating.fields.review!}"),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
