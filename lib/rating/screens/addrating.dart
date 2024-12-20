import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/env.dart';
import 'package:balinchill/services/api_service.dart';

class AddRatingPage extends StatefulWidget {
  final int hotelId;
  final VoidCallback onRatingAdded; // Add callback

  const AddRatingPage({required this.hotelId, required this.onRatingAdded});

  @override
  _AddRatingPageState createState() => _AddRatingPageState();
}

class _AddRatingPageState extends State<AddRatingPage> {
  int _selectedRating = 0; // Store the selected rating
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(baseUrl: Env.backendUrl, request: context.watch<CookieRequest>());
    return Scaffold(
      appBar: AppBar(title: const Text('Add Rating')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Rating:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _selectedRating
                        ? Colors.amber
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1; // Update selected rating
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(labelText: 'Review'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final review = _reviewController.text;

                if (_selectedRating >= 1 &&
                    _selectedRating <= 5 &&
                    review.isNotEmpty) {
                  try {
                    final response = await apiService.addRating(widget.hotelId, _selectedRating, review);

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rating added successfully')),
                      );
                      widget.onRatingAdded(); // Call the callback
                      Navigator.pop(context); // Go back to the previous screen
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'] ?? 'Failed to add rating')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add rating: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a valid rating and review')),
                  );
                }
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}