import 'package:balinchill/env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
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
                final response = await request.post(
                  'http://127.0.0.1:8000/payment/process-payment/',
                  {
                    'full_name': _fullNameController.text,
                    'email': _emailController.text,
                    'mobile_number': _mobileNumberController.text,
                    'credit_card_number': _creditCardNumberController.text,
                    'valid_thru': _validThruController.text,
                    'cvv': _cvvController.text,
                    'card_name': _cardNameController.text,
                    'booking_date': _bookingDateController.text,
                    'hotel_id': widget.hotelId.toString(),
                    'price': widget.price,
                  },
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
              },
              child: const Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
