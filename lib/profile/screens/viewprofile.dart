import 'package:flutter/material.dart';
import 'package:balinchill/profile/models/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Function to fetch profile data
  Future<Profile> fetchProfile(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/users/json/');
    return Profile.fromJson(response['data']);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Profile>(
        future: fetchProfile(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data found.'));
          } else {
            final profile = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // View Profile
                  ViewProfile(profile: profile),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// View Profile Widget
class ViewProfile extends StatelessWidget {
  final Profile profile;

  const ViewProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fields = profile.fields;

    return Column(
      children: [
        // Displaying the profile image
        fields.image.isNotEmpty
            ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(fields.image),
              )
            : const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50),
              ),
        const SizedBox(height: 16),
        // Displaying the username
        Text(
          "Username: ${profile.model}", // You can change this to display the actual username field
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        // Displaying the email
        Text("Email: ${profile.fields.image}"), // You can change this to display the actual email field
      ],
    );
  }
}
