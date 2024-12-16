import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/profile/profile_screens/editprofile.dart';
import 'package:balinchill/profile/models/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Fetch profiles directly from the API
  Future<List<Profile>> fetchProfiles(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/users/profiles/');

    if (response == null) {
      throw Exception('Failed to load profiles');
    }

    // Parse response into Profile objects
    return (response as List).map((data) => Profile.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        backgroundColor: const Color(0xFFB89576), // Retained color
        elevation: 4, // Added elevation for shadow effect
      ),
      body: FutureBuilder(
        future: fetchProfiles(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'No profile data available',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: snapshot.data!.map<Widget>((profile) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                profile.fields.image), // Image loaded here
                            onBackgroundImageError: (exception, stackTrace) {
                              print("Failed to load image: $exception");
                            },
                          ),
                          const SizedBox(height: 16),
                          // Display the user's information (username, email, first name, last name)
                          Text(
                            'Username: ${profile.fields.user.username}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Email: ${profile.fields.user.email.isNotEmpty ? profile.fields.user.email : "N/A"}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'First Name: ${profile.fields.user.firstName.isNotEmpty ? profile.fields.user.firstName : "N/A"}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Last Name: ${profile.fields.user.lastName.isNotEmpty ? profile.fields.user.lastName : "N/A"}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          // Action Button
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(profile: profile),
                                ),
                              );
                              // Trigger a rebuild to refresh data
                              setState(() {});
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFFB89576),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
