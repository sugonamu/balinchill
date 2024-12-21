import 'package:balinchill/env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balinchill/services/api_service.dart';

class PaymentPage extends StatefulWidget {
  final int hotelId;
  final String price;

  const PaymentPage({Key? key, required this.hotelId, required this.price}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _creditCardNumberController = TextEditingController();
  final TextEditingController _validThruController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final apiService = ApiService(baseUrl: Env.backendUrl, request: request);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF997A57), // Tan color
        title: const Text('Payment Page', style: TextStyle(color: Colors.white)),
        centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _mobileNumberController,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            TextField(
              controller: _creditCardNumberController,
              decoration: const InputDecoration(labelText: 'Credit Card Number'),
            ),
            TextField(
              controller: _validThruController,
              decoration: const InputDecoration(labelText: 'Valid Thru (MM/YY)'),
            ),
            TextField(
              controller: _cvvController,
              decoration: const InputDecoration(labelText: 'CVV'),
            ),
            TextField(
              controller: _cardNameController,
              decoration: const InputDecoration(labelText: 'Card Name'),
            ),
            TextField(
              controller: _bookingDateController,
              decoration: const InputDecoration(labelText: 'Booking Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await apiService.processPayment(
                    fullName: _fullNameController.text,
                    email: _emailController.text,
                    mobileNumber: _mobileNumberController.text,
                    creditCardNumber: _creditCardNumberController.text,
                    validThru: _validThruController.text,
                    cvv: _cvvController.text,
                    cardName: _cardNameController.text,
                    bookingDate: _bookingDateController.text,
                    hotelId: widget.hotelId,
                    price: widget.price,
                  );

                  if (response['status'] == 'success') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${response['message']}\nTransaction ID: ${response['transaction_id']}')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to process payment: $e')),
                  );
                }
              },
              child: const Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}