import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/profile/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:balinchill/config/env.dart';  // Import the Env class

class ApiService {
  final String baseUrl;
  final CookieRequest request;

  ApiService({
    required this.baseUrl,
    required this.request,
  });

  // Fetch all profiles from the API
  Future<List<Profile>> fetchProfiles() async {
    final response = await request.get('$baseUrl/users/profiles/');

    if (response == null) {
      throw Exception('Failed to load profiles');
    }

    // Parse response into Profile objects
    return (response as List).map((data) => Profile.fromJson(data)).toList();
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
      '$baseUrl/users/update_profile_flutter/',
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
}

