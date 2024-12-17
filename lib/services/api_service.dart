import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/profile/models/profile.dart';
import 'package:balinchill/rating/models/rating.dart';
import 'package:balinchill/host/models/property.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:balinchill/env.dart';  // Import the Env class

class ApiService {
  final String baseUrl;
  final CookieRequest request;

  ApiService({
    required this.baseUrl,
    required this.request,
  });

  // Fetch all profiles from the API
  Future<Profile> fetchUserProfile() async {
    final response = await request.get('${Env.backendUrl}/users/api');  // Endpoint for the logged-in user profile

    if (response == null) {
      throw Exception('Failed to load user profile');
    }

    // Parse response into a Profile object
    return Profile.fromJson(response);
  }

  // Update a user's profile
  Future<Map<String, dynamic>> updateProfile({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String? image,
  }) async {
    final response = await request.post(
      '${Env.backendUrl}/users/update_profile_flutter/',
      {
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'image': image,
      },
    );

    if (response == null) {
      throw Exception('Failed to update profile');
    }

    return response;
  }

  // Fetch ratings for a specific hotel
  Future<List<Rating>> fetchRatings(int hotelId) async {
    final response = await request.get('${Env.backendUrl}/api/hotels/$hotelId/ratings/');

    if (response == null || response['ratings'] == null) {
      throw Exception('Failed to load ratings');
    }

    List jsonData = response['ratings'];
    return jsonData.map((rating) => Rating.fromJson(rating)).toList();
  }

  // Add a rating for a specific hotel
  Future<void> addRating(int hotelId, int ratingValue, String review) async {
    final response = await request.post(
      '${Env.backendUrl}/api/hotels/$hotelId/add-rating/',
      {
        'rating': ratingValue.toString(),
        'review': review,
      },
    );

    if (response == null) {
      throw Exception('Failed to add rating');
    }
  }

  // Logout functionality
  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/logout/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // Logout successful
    } else {
      throw Exception('Failed to logout');
    }
  }

  // Fetch all hotels from the API
  Future<List<Hotel>> fetchHotels() async {
    final response = await request.get('${Env.backendUrl}/api/hotels/');

    if (response == null) {
      throw Exception('Failed to load hotels');
    }

    final List<dynamic> hotelsJson = response;
    return hotelsJson.map((json) => Hotel.fromJson(json)).toList();
  }

  // Fetch all properties for the logged-in host
  Future<List<Property>> getHostProperties() async {
    final response = await request.get(
      '${Env.backendUrl}/propertylistview/',  // Endpoint for host's properties
    );

    if (response == null) {
      throw Exception('Failed to load properties');
    }

    List jsonResponse = response;
    return jsonResponse.map((data) => Property.fromJson(data)).toList();
  }

  // Add a property for the logged-in host
  Future<void> addProperty(Property property) async {
    final response = await request.post(
      '${Env.backendUrl}/add_property/',  // Endpoint to add a property
      {
        'Hotel': property.hotel,
        'Category': property.category,
        'Address': property.address,
        'Contact': property.contact,
        'Price': property.price,
        'Amenities': property.amenities,
        'Image_URL': property.imageUrl,
        'Location': property.location,
        'Page_URL': property.pageUrl,
      },
    );

    if (response == null || response['status'] != 'success') {
      throw Exception('Failed to add property');
    }
  }
}