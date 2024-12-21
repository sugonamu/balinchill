import 'package:balinchill/env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/profile/models/profile.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  const EditProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  String? _selectedImage;
  String? _usernameError;

  final List<String> _availableImages = [
    'profile_pics/image 1.jpg',
    'profile_pics/image 2.jpg',
    'profile_pics/image 3.jpg',
    'profile_pics/image 4.jpg',
    'profile_pics/image 5.jpg',
    'profile_pics/image 6.jpg',
    'profile_pics/image 7.jpg',
    'profile_pics/image 8.jpg',
    'profile_pics/image 9.jpg',
    'profile_pics/image 10.jpg',
    'profile_pics/image 11.jpg',
    'profile_pics/image 12.jpg',
    'profile_pics/image 13.jpg',
    'profile_pics/image 14.jpg',
    'profile_pics/image 15.jpg',
  ];

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.fields.user.username);
    _emailController = TextEditingController(text: widget.profile.fields.user.email);
    _firstNameController = TextEditingController(text: widget.profile.fields.user.firstName);
    _lastNameController = TextEditingController(text: widget.profile.fields.user.lastName);
    _selectedImage = widget.profile.fields.image;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    apiService = ApiService(baseUrl: '${Env.backendUrl}', request: request);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF997A57), // Tan color
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _updateProfile(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Fields
            _buildTextField(_usernameController, 'Username', _usernameError),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 16),
            _buildTextField(_firstNameController, 'First Name'),
            const SizedBox(height: 16),
            _buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 20),

            // Profile Image Selector
            const Center(
              child: Text('Profile Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: _availableImages.map((imagePath) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = imagePath;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedImage == imagePath ? Colors.blue : Colors.grey,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          '${Env.backendUrl}/media/$imagePath',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () => _updateProfile(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1877F2),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label, [String? errorText]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        errorText: errorText,
      ),
    );
  }

  void _updateProfile() async {
    try {
      final response = await apiService.updateProfile(
        username: _usernameController.text,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        image: _selectedImage,
      );
      if (response.containsKey('message') && response['message'] == 'Profile updated successfully') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
        Navigator.pop(context);
      } else {
        setState(() {
          _usernameError = response['message'] ?? 'Failed to update profile';
        });
      }
    } catch (e) {
      setState(() {
        _usernameError = 'Error: $e';
      });
    }    }
  }
