import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:balinchill/booking/models/booking.dart'; // Ensure correct import path
import 'package:balinchill/payment/screens/payment_page.dart'; // Ensure correct import path

class HotelDetailPage extends StatefulWidget {
  final int hotelId;

  const HotelDetailPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  late Future<HotelDetail> _hotelDetailFuture;
  late Future<List<Hotel>> _relatedHotelsFuture;

  @override
  void initState() {
    super.initState();
    _hotelDetailFuture = fetchHotelDetail(widget.hotelId);
    _relatedHotelsFuture = fetchHotels();
  }

  Future<HotelDetail> fetchHotelDetail(int id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/hotels/$id/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return HotelDetail.fromJson(data);
    } else {
      throw Exception('Failed to load hotel details');
    }
  }

  Future<List<Hotel>> fetchHotels() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/hotels/'));
    if (response.statusCode == 200) {
      return hotelFromJson(response.body);
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  String getProxyImageUrl(String originalUrl) {
    return 'http://127.0.0.1:8000/proxy-image/?url=${Uri.encodeComponent(originalUrl)}';
  }

  String cleanText(String text) {
    // Remove unwanted characters like Â and trim spaces
    return text.replaceAll('Â', '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E6), // Light beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFF997A57), // Rich tan
        title: const Text('Hotel Details', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<HotelDetail>(
        future: _hotelDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final hotelDetail = snapshot.data!;
          return FutureBuilder<List<Hotel>>(
            future: _relatedHotelsFuture,
            builder: (context, relatedSnapshot) {
              if (relatedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (relatedSnapshot.hasError) {
                return Center(child: Text('Error: ${relatedSnapshot.error}'));
              }

              // Filter related hotels by location
              final relatedHotels = relatedSnapshot.data!
                  .where((hotel) => hotel.location == hotelDetail.location)
                  .toList();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hotel Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          getProxyImageUrl(hotelDetail.imageUrl),
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/No_image.jpg'),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Hotel Name
                      Text(
                        cleanText(hotelDetail.name),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Color(0xFF997A57), // Rich tan
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Amenities
                      if (hotelDetail.amenities.isNotEmpty) ...[
                        const Text(
                          'Amenities:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF997A57), // Rich tan
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          cleanText(hotelDetail.amenities),
                          style: const TextStyle(
                            color: Color(0xFFB89B7C), // Muted brown
                            fontSize: 16.0,
                            height: 1.5, // Adjust line height for readability
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],

                      // Book Hotel Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF997A57), // Rich tan
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          foregroundColor: Colors.white, // Button text white
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                hotelId: hotelDetail.id,
                                price: hotelDetail.price,
                              ),
                            ),
                          );
                        },
                        child: const Text('Book Hotel'),
                      ),
                      const SizedBox(height: 20.0),

                      // Price
                      Text(
                        'Price: Rp ${hotelDetail.price.toInt()}', // Display price as integer
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFFB89B7C), // Muted brown
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Ratings & Reviews
                      const Text(
                        'Ratings & Reviews',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF997A57), // Rich tan
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (hotelDetail.ratings.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: hotelDetail.ratings.length,
                          itemBuilder: (context, index) {
                            final rating = hotelDetail.ratings[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${rating.username}: ⭐ ${rating.rating} - ${rating.review}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF997A57), // Rich tan
                                    ),
                                  ),
                                  Text(
                                    rating.createdAt,
                                    style: const TextStyle(color: Color(0xFFB89B7C)), // Muted brown
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      else
                        const Text(
                          'No ratings yet. Be the first to leave a review!',
                          style: TextStyle(color: Color(0xFFB89B7C)), // Muted brown
                        ),
                      const SizedBox(height: 40.0),

                      // Related Hotels Nearby
                      const Text(
                        'Related Hotels Nearby',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF997A57), // Rich tan
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: relatedHotels.map((relatedHotel) {
                            return Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      getProxyImageUrl(relatedHotel.imageUrl ?? ''),
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset('assets/images/No_image.jpg'),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    cleanText(relatedHotel.name),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF997A57), // Rich tan
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF997A57),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      foregroundColor: Colors.white, // Button text white
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HotelDetailPage(hotelId: relatedHotel.id),
                                        ),
                                      );
                                    },
                                    child: const Text('Book Now'),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
