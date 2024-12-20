import 'package:balinchill/booking/models/booking.dart' as booking;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:balinchill/rating/models/rating.dart' as rating;

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  RatingsScreenState createState() => RatingsScreenState();
}

class RatingsScreenState extends State<RatingsScreen> {
  late Future<List<rating.Rating>> _ratings;

  @override
  void initState() {
    super.initState();
    _ratings = fetchAllRatings() as Future<List<rating.Rating>>; // Fetch data when the screen loads
  }

  Future<List<booking.Rating>> fetchAllRatings() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    return await apiService.fetchAllRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ratings Test Screen")),
      body: FutureBuilder<List<rating.Rating>>(
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