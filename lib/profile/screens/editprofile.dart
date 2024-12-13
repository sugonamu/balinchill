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

  final List<String> _availableImages = [
    'profile_pics/image1.jpg',
    'profile_pics/image2.jpg',
    'profile_pics/image3.jpg',
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
    apiService = ApiService(baseUrl: 'http://127.0.0.1:8000', request: request);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFB89576),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_usernameController, 'Username'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_firstNameController, 'First Name'),
            _buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 16),
            const Text('Select Profile Image:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
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
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _updateProfile(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFB89576),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
