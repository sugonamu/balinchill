import 'package:flutter/material.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:provider/provider.dart'; 
import 'package:balinchill/env.dart';
class AddRatingPage extends StatefulWidget {
  final int hotelId;

  AddRatingPage({required this.hotelId});

  @override
  _AddRatingPageState createState() => _AddRatingPageState();
}

class _AddRatingPageState extends State<AddRatingPage> {
  final _ratingController = TextEditingController();
  final _reviewController = TextEditingController();

  late ApiService apiService; // Declare apiService

  // Function to add rating
  void _submitRating() async {
    final rating = int.tryParse(_ratingController.text) ?? 0;
    final review = _reviewController.text;

    if (rating >= 1 && rating <= 5 && review.isNotEmpty) {
      try {
        // Call addRating from ApiService
        await apiService.addRating(widget.hotelId, rating, review);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rating added successfully')));
        Navigator.pop(context);  // Go back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add rating')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please provide a valid rating and review')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the request (CookieRequest) from the context
    final request = context.watch<CookieRequest>(); 

    // Initialize the ApiService with the baseUrl and request
    apiService = ApiService(baseUrl: '${Env.backendUrl}', request: request);

    return Scaffold(
      appBar: AppBar(title: Text('Add Rating')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Rating (1-5)'),
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(labelText: 'Review'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRating,
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}
