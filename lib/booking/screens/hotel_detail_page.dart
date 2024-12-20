import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Placeholder pages (Payment and AddReview) at bottom of file.

class HotelDetailPage extends StatefulWidget {
  final int hotelId;

  const HotelDetailPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  late Future<HotelDetail> _hotelDetailFuture;

  @override
  void initState() {
    super.initState();
    _hotelDetailFuture = fetchHotelDetail(widget.hotelId);
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

  String getProxyImageUrl(String originalUrl) {
    return 'http://127.0.0.1:8000/proxy-image/?url=${Uri.encodeComponent(originalUrl)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Details'),
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
                    hotelDetail.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xFF997A57), // Rich Tan
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Amenities
                  if (hotelDetail.amenities.isNotEmpty) ...[
                    const Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: hotelDetail.amenities
                          .map((amenity) => Chip(
                                label: Text(amenity),
                                backgroundColor: const Color(0xFFE7D9C7), // Soft Beige
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                  ],

                  // Price
                  Text(
                    'Price: Rp ${hotelDetail.price}',
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFFB89B7C), // Muted Brown
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Payment and Review Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF997A57),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(hotelId: hotelDetail.id),
                            ),
                          );
                        },
                        child: const Text('Proceed to Payment'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF997A57),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddReviewPage(hotelId: hotelDetail.id),
                            ),
                          );
                        },
                        child: const Text('Add Review'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),

                  // Ratings & Reviews
                  const Text('Ratings & Reviews',
                      style: TextStyle(fontSize: 24, color: Color(0xFF997A57))),
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(rating.createdAt),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    const Text('No ratings yet. Be the first to leave a review!'),

                  const SizedBox(height: 40.0),

                  // Related Hotels
                  const Text('Related Hotels Nearby',
                      style: TextStyle(fontSize: 24, color: Color(0xFF997A57))),
                  const SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: hotelDetail.relatedHotels.map((relatedHotel) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to this related hotel's detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelDetailPage(hotelId: relatedHotel.id),
                              ),
                            );
                          },
                          child: Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                                  child: Image.network(
                                    getProxyImageUrl(relatedHotel.imageUrl),
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Image.asset('assets/images/No_image.jpg'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        relatedHotel.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF997A57),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        'Price: ${relatedHotel.price}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB89B7C),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF997A57),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HotelDetailPage(hotelId: relatedHotel.id),
                                            ),
                                          );
                                        },
                                        child: const Text('Book Now'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}

// Models and helper classes

class HotelDetail {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final List<String> amenities;
  final List<Rating> ratings;
  final List<HotelBasic> relatedHotels;

  HotelDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.amenities,
    required this.ratings,
    required this.relatedHotels,
  });

  factory HotelDetail.fromJson(Map<String, dynamic> json) {
    return HotelDetail(
      id: json['id'],
      name: json['Hotel'],
      imageUrl: json['Image_URL'],
      price: json['Price'],
      amenities: json['Amenities'] != null
          ? (json['Amenities'].split(',').map((e) => e.trim()).toList())
          : [],
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((r) => Rating.fromJson(r))
              .toList() ??
          [],
      relatedHotels: (json['related_hotels'] as List<dynamic>?)
              ?.map((rh) => HotelBasic.fromJson(rh))
              .toList() ??
          [],
    );
  }
}

class Rating {
  final String username;
  final double rating;
  final String review;
  final String createdAt;

  Rating({
    required this.username,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      username: json['user']['username'],
      rating: (json['rating'] as num).toDouble(),
      review: json['review'],
      createdAt: json['created_at'],
    );
  }
}

class HotelBasic {
  final int id;
  final String name;
  final String imageUrl;
  final String price;

  HotelBasic({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory HotelBasic.fromJson(Map<String, dynamic> json) {
    return HotelBasic(
      id: json['id'],
      name: json['Hotel'],
      imageUrl: json['Image_URL'],
      price: json['Price'],
    );
  }
}

// Placeholder Payment Page
class PaymentPage extends StatelessWidget {
  final int hotelId;
  const PaymentPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for Hotel #$hotelId'),
      ),
      body: const Center(
        child: Text('Payment flow not implemented.'),
      ),
    );
  }
}

// Placeholder Add Review Page
class AddReviewPage extends StatelessWidget {
  final int hotelId;
  const AddReviewPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review for Hotel #$hotelId'),
      ),
      body: const Center(
        child: Text('Add Review page not implemented.'),
      ),
    );
  }
}
