import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class PaymentPage extends StatefulWidget {

  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // late TextEditingController _phoneNumberController;
  // late TextEditingController _creditCardNumberController;
  // late TextEditingController _validThruController;
  // late TextEditingController _cvvController;
  // late TextEditingController _cardNameController;
  // String? _selectedImage;

  

  @override
  void initState() {
    super.initState();
    // _usernameController = TextEditingController(text: widget.profile.fields.user.username);
    // _emailController = TextEditingController(text: widget.profile.fields.user.email);
    // _firstNameController = TextEditingController(text: widget.profile.fields.user.firstName);
    // _lastNameController = TextEditingController(text: widget.profile.fields.user.lastName);
    // _selectedImage = widget.profile.fields.image;
  }

  // Future<void> _updateProfile(CookieRequest request) async {
  //   final response = await request.post(
  //     'http://127.0.0.1:8000/users/update_profile_flutter/',
  //     {
  //       'username': _usernameController.text,
  //       'email': _emailController.text,
  //       'first_name': _firstNameController.text,
  //       'last_name': _lastNameController.text,
  //       'image': _selectedImage,
  //     },
  //   );

  //   if (response['status'] == 'success') {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Profile updated successfully')),
  //     );
  //     Navigator.pop(context);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${response['message']}')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        backgroundColor: const Color(0xFFB89576),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User information fields
            TextField(
              // controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              // controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              // controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              // controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Credit Card Number'),
            ),
            TextField(
              // controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Valid Thru'),
            ),
            TextField(
              // controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'CVV/CVN'),
            ),
            TextField(
              // controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Name on Card'),
            ),
            const SizedBox(height: 16),
            // Image selection
            // Wrap(
            //   spacing: 8.0,
            //   children: _availableImages.map((imagePath) {
            //     return GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           _selectedImage = imagePath;
            //         });
            //       },
            //       child: Container(
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: _selectedImage == imagePath ? Colors.blue : Colors.grey,
            //           ),
            //         ),
            //         child: Image.network(
            //         'http://127.0.0.1:8000/media/$imagePath',
            //           width: 80,
            //           height: 80,
            //           errorBuilder: (context, error, stackTrace) {
            //             return const Icon(Icons.error);
            //           },
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
            const SizedBox(height: 16),
            // Save button
            ElevatedButton(
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFB89576),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}