import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/profile/models/profile.dart';

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

  final List<String> _availableImages = [
    'profile_pics/image1.jpg',
    'profile_pics/image2.jpg',
    'profile_pics/image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.fields.user.username);
    _emailController = TextEditingController(text: widget.profile.fields.user.email);
    _firstNameController = TextEditingController(text: widget.profile.fields.user.firstName);
    _lastNameController = TextEditingController(text: widget.profile.fields.user.lastName);
    _selectedImage = widget.profile.fields.image;
  }

  Future<void> _updateProfile(CookieRequest request) async {
    final response = await request.post(
      'http://127.0.0.1:8000/users/update_profile_flutter/',
      {
        'username': _usernameController.text,
        'email': _emailController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'image': _selectedImage,
      },
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFB89576),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User information fields
            _buildTextField(_usernameController, 'Username'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_firstNameController, 'First Name'),
            _buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 16),
            // Image selection
            const Text('Select Profile Image:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _availableImages.map((imagePath) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImage = imagePath;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImage == imagePath ? Colors.blue : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://127.0.0.1:8000/media/$imagePath',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Save button
            Center(
              child: ElevatedButton(
                onPressed: () => _updateProfile(request),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFB89576),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}