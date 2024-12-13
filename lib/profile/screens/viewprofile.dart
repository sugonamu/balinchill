import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/profile/screens/editprofile.dart';
import 'package:balinchill/profile/models/profile.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ApiService apiService;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    apiService = ApiService(baseUrl: 'http://127.0.0.1:8000', request: request);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        backgroundColor: const Color(0xFFB89576),
        elevation: 4,
      ),
      body: FutureBuilder<List<Profile>>(
        future: apiService.fetchProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profile.fields.image),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Username: ${profile.fields.user.username}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email: ${profile.fields.user.email}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'First Name: ${profile.fields.user.firstName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last Name: ${profile.fields.user.lastName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(profile: profile),
                                ),
                              );
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
