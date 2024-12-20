import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:balinchill/widgets/guest_left_drawer.dart';
import 'package:balinchill/services/api_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balinchill/booking/models/booking.dart';
import 'hotel_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Hotel>> _hotelsFuture;
  String _selectedSortOption = 'Ascending';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _hotelsFuture = fetchHotels();
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

  List<Hotel> _filterAndSortHotels(List<Hotel> hotels) {
    final filtered = hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    filtered.sort((a, b) {
      if (_selectedSortOption == 'Ascending') {
        return a.price.compareTo(b.price);
      } else {
        return b.price.compareTo(a.price);
      }
    });

    return filtered;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Ascending'),
                onTap: () {
                  setState(() {
                    _selectedSortOption = 'Ascending';
                  });
                  Navigator.pop(context);
                },
                leading: _selectedSortOption == 'Ascending'
                    ? const Icon(Icons.check, color: Colors.green)
                    : const SizedBox.shrink(),
              ),
              ListTile(
                title: const Text('Descending'),
                onTap: () {
                  setState(() {
                    _selectedSortOption = 'Descending';
                  });
                  Navigator.pop(context);
                },
                leading: _selectedSortOption == 'Descending'
                    ? const Icon(Icons.check, color: Colors.green)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final backgroundColor = const Color(0xFFF5F0E1);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF997A57), // Tan color
        title: const Text('Home Page', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: LeftDrawer(apiService: ApiService(baseUrl: 'YOUR_BASE_URL', request: request)),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Sort Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Hotels...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF997A57)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12.0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Sort Icon
                  IconButton(
                    icon: const Icon(Icons.tune, color: Color(0xFF997A57)),
                    onPressed: _showSortOptions,
                  ),
                ],
              ),
            ),

            // Hotel List
            Expanded(
              child: FutureBuilder<List<Hotel>>(
                future: _hotelsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hotels found.'));
                  }

                  final hotels = _filterAndSortHotels(snapshot.data!);

                  return ListView.builder(
                    itemCount: hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = hotels[index];
                      final proxiedImageUrl = getProxyImageUrl(hotel.imageUrl ?? '');

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelDetailPage(hotelId: hotel.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 4.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Hotel Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                                  child: Image.network(
                                    proxiedImageUrl,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/images/No_image.jpg',
                                          fit: BoxFit.cover);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Hotel Name
                                      Text(
                                        hotel.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),

                                      // Price
                                      Text(
                                        'Rp ${hotel.price.toInt()}',
                                        style: const TextStyle(
                                          color: Color(0xFF997A57),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Rating (Placeholder)
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            hotel.averageRating?.toStringAsFixed(1) ?? 'N/A',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
