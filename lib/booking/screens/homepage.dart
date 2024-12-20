import 'package:balinchill/env.dart';
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
  String _selectedSortOption = 'Low to High';
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
      final aPrice = double.tryParse(a.price.replaceAll(RegExp('[^0-9.]'), '')) ?? 0.0;
      final bPrice = double.tryParse(b.price.replaceAll(RegExp('[^0-9.]'), '')) ?? 0.0;
      if (_selectedSortOption == 'Low to High') {
        return aPrice.compareTo(bPrice);
      } else {
        return bPrice.compareTo(aPrice);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final backgroundColor = const Color(0xFFF5F0E1);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: LeftDrawer(apiService: ApiService(baseUrl: '${Env.backendUrl}', request: request)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Hotels',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
                      children: [
                        const Text('Sort by Price: ',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSortOption,
                            items: <String>['Low to High', 'High to Low'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSortOption = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

                  // Adjust crossAxisCount based on screen width
                  final crossAxisCount = MediaQuery.of(context).size.width < 600 ? 1 : 3;

                  return GridView.builder(
                    itemCount: hotels.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final hotel = hotels[index];
                      final proxiedImageUrl = getProxyImageUrl(hotel.imageUrl ?? '');

                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2.0,
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                                child: Image.network(
                                  proxiedImageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/No_image.jpg', fit: BoxFit.cover);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    hotel.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    hotel.price,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotelDetailPage(hotelId: hotel.id),
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
