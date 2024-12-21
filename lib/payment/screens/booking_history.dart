import 'package:balinchill/env.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/payment.dart';
import '../../booking/models/booking.dart'; // Import the Hotel model
import '../../services/api_service.dart'; // Import ApiService
import 'package:balinchill/widgets/guest_navbar.dart'; // add

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<Transaction> _transactions = [];
  Map<int, String> _hotelNames = {}; // Map to store hotel names
  Map<int, String> _hotelImages = {}; // Map to store hotel images
  late ApiService _apiService;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(baseUrl: Env.backendUrl, request: Provider.of<CookieRequest>(context, listen: false));
    fetchBookingHistory();
  }

  Future<void> fetchBookingHistory() async {
    try {
      final transactions = await _apiService.fetchBookingHistory();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });

      // Fetch hotel names for each transaction
      for (var transaction in _transactions) {
        fetchHotelName(transaction.hotel);
      }
    } catch (e) {
      print('Error fetching booking history: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> fetchHotelName(int id) async {
    try {
      final hotel = await _apiService.fetchHotelDetail(id);
      setState(() {
        _hotelNames[id] = hotel.name;
        _hotelImages[id] = hotel.imageUrl ?? ''; // Store hotel image URL
      });
    } catch (e) {
      print('Error fetching hotel name: $e');
      // Handle error, e.g., show a message to the user
    }
  }

  String getProxyImageUrl(String originalUrl) {
    return _apiService.getProxyImageUrl(originalUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text('No Booking History'))
              : _transactions.isEmpty
                  ? Center(child: Text('No Booking History'))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactions[index];
                          final hotelName = _hotelNames[transaction.hotel] ?? 'Loading...';
                          final hotelImageUrl = _hotelImages[transaction.hotel] ?? '';
                          final proxiedImageUrl = getProxyImageUrl(hotelImageUrl);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  hotelImageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            proxiedImageUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/No_image.jpg', fit: BoxFit.cover, width: 80, height: 80);
                                            },
                                          ),
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.image, color: Colors.grey[400]),
                                        ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hotel: $hotelName',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text('Booking Date: ${transaction.bookingDate}'),
                                        Text('Total Price: ${transaction.totalPrice}'),
                                        Text('Status: ${transaction.status}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      bottomNavigationBar: Navbar(
        apiService: _apiService,
        currentIndex: 1, // example index
      ),
    );
  }
}