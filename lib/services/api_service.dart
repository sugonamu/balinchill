import 'dart:convert';
import 'package:balinchill/payment/models/payment.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/profile/models/profile.dart';
import 'package:balinchill/rating/models/rating.dart' as rating;
import 'package:balinchill/host/models/property.dart';
import 'package:balinchill/booking/models/booking.dart' as booking;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:balinchill/env.dart';

import '../booking/models/booking.dart';  // Import the Env class

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


  // Logout functionality
  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout/'),
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
  Future<List<booking.Hotel>> fetchHotels() async {
    final response = await request.get('${Env.backendUrl}/api/hotels/');

    if (response == null) {
      throw Exception('Failed to load hotels');
    }

    final List<dynamic> hotelsJson = response;
    return hotelsJson.map((json) => booking.Hotel.fromJson(json)).toList();
  }

  // Get proxy image URL
  String getProxyImageUrl(String originalUrl) {
    return '${Env.backendUrl}/proxy-image/?url=${Uri.encodeComponent(originalUrl)}';
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
      '${Env.backendUrl}/add_property/',
      property.toJson(),
    );

    if (response == null) {
      throw Exception('Failed to add property');
    }
  }


    Future<Map<String, dynamic>> deleteProperty(String propertyId) async {
    final url = Uri.parse('${Env.backendUrl}/delete/$propertyId/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Property not found');
      } else if (response.statusCode == 405) {
        throw Exception('Invalid request method');
      } else {
        throw Exception('Failed to delete property');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
    Future<HotelDetail> fetchHotelDetail(int id) async {
    final response = await request.get('${Env.backendUrl}/api/hotels/$id/');
    if (response == null) {
      throw Exception('Failed to load hotel details');
    }
    return HotelDetail.fromJson(response);
  }
    Future<List<Transaction>> fetchBookingHistory() async {
    final response = await request.get('${Env.backendUrl}/payment/booking_history/');
    if (response == null || response.isEmpty) {
      throw Exception('Failed to load booking history');
    }
    return transactionFromJson(response);
  }


  Future<Map<String, dynamic>> processPayment({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String creditCardNumber,
    required String validThru,
    required String cvv,
    required String cardName,
    required String bookingDate,
    required int hotelId,
    required String price,
  }) async {
    final response = await request.post(
      '${Env.backendUrl}/payment/process-payment/',
      {
        'full_name': fullName,
        'email': email,
        'mobile_number': mobileNumber,
        'credit_card_number': creditCardNumber,
        'valid_thru': validThru,
        'cvv': cvv,
        'card_name': cardName,
        'booking_date': bookingDate,
        'hotel_id': hotelId.toString(),
        'price': price,
      },
    );

    if (response == null) {
      throw Exception('Failed to process payment');
    }

    return response;
  }

    Future<List<Rating>> fetchAllRatings() async {
    final response = await request.get('${Env.backendUrl}/ratings/json/');

    if (response == null) {
      throw Exception('Failed to load ratings');
    }

    List<dynamic> data = response;
    return data.map((rating) => Rating.fromJson(rating)).toList();
  }
  Future<Map<String, dynamic>> addRating(int hotelId, int ratingValue, String review) async {
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

    return response;
  }
  Future<Map<String, dynamic>> login(String username, String password) async {
     final response = await request.login(
      '${Env.backendUrl}/auth/login/',
      {
        'username': username,
        'password': password,
      },
    );

    if (response == null) {
      throw Exception('Failed to login');
    }

    return response;
  }

  Future<Map<String, dynamic>> register(String username, String password1, String password2, String role) async {
    final response = await request.postJson(
      "${Env.backendUrl}/auth/register/",
      jsonEncode({
        "username": username,
        "password1": password1,
        "password2": password2,
        "role": role,
      }),
    );

    if (response == null) {
      throw Exception('Failed to register');
    }

    return response;
  }
  Future<Map<String, dynamic>> editProperty(
    String propertyId,
    String hotel,
    String category,
    String address,
    String contact,
    String price,
    String amenities,
    String imageUrl,
    String location,
    String pageUrl,
  ) async {
    final response = await request.postJson(
      "${Env.backendUrl}/edit_property_api/",
      jsonEncode({
        "id": propertyId,
        "Hotel": hotel,
        "Category": category,
        "Address": address,
        "Contact": contact,
        "Price": price,
        "Amenities": amenities,
        "Image_URL": imageUrl,
        "Location": location,
        "Page_URL": pageUrl,
      }),
    );

    if (response == null) {
      throw Exception('Failed to edit property');
    }

    return response;
  }
  Future<Property> getPropertyDetails(String propertyId) async {
    final response = await request.get('${Env.backendUrl}/property/$propertyId/');

    if (response == null) {
      throw Exception('Failed to load property details');
    }

    return Property.fromJson(response);
  }
}