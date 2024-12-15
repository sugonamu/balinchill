import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      final List<dynamic> hotelsJson = json.decode(response.body);
      return hotelsJson.map((json) => Hotel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  List<Hotel> _filterAndSortHotels(List<Hotel> hotels) {
    // Filter by search query
    final filtered = hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort by price based on the selectedSortOption
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
    final backgroundColor = const Color(0xFFF5F0E1);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Row: Search bar and Sort dropdown
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
                        const Text(
                          'Sort by Price: ',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
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
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'PlacesInBali',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      itemCount: hotels.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 columns
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                                  child: (hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty)
                                      ? Image.network(
                                          hotel.imageUrl!,
                                          height: 80.0,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/No_image.jpg',
                                              height: 80.0,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/No_image.jpg',
                                          height: 80.0,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Price: ${hotel.price}',
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Rating: ⭐ ${hotel.averageRating ?? '0'}',
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.orange,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                  
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF997A57),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    minimumSize: const Size(double.infinity, 28),
                                  ),
                                  child: const Text(
                                    'Book Now',
                                    style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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

class Hotel {
  final int id;
  final String name;
  final String? imageUrl;
  final String price;
  final String? averageRating;

  Hotel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.averageRating,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    // Clean the price string by removing 'A' if present
    String rawPrice = json['Price'] ?? '';
    String cleanedPrice = rawPrice.replaceAll('A', '');
    
    return Hotel(
      id: json['id'],
      name: json['Hotel'],
      imageUrl: json['Image_URL'],
      price: cleanedPrice.trim(),
      averageRating: json['avg_rating']?.toString(),
    );
  }
}
