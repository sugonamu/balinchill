import 'package:flutter/material.dart';

class HotelDetailsPage extends StatelessWidget {
  final Hotel hotel;
  final List<String> amenitiesList;
  final List<Rating> ratings;
  final List<Hotel> relatedHotels;

  const HotelDetailsPage({
    Key? key,
    required this.hotel,
    required this.amenitiesList,
    required this.ratings,
    required this.relatedHotels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors and styling as per HTML/CSS
    final backgroundColor = const Color(0xFFF5F3E6); // Light Cream Background
    final titleColor = const Color(0xFF997A57); // Rich Tan
    final priceColor = const Color(0xFFB89B7C); // Muted Brown
    final amenitiesColor = const Color(0xFFE7D9C7); // Soft Beige
    final buttonColor = const Color(0xFF997A57); // Rich Tan button color

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Details Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Image
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          hotel.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/No_image.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Hotel Info
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Amenities
                          Row(
                            children: [
                              const Text(
                                'Amenities: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: amenitiesList.map((amenity) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: amenitiesColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(amenity),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Price
                          Text(
                            'Price: Rp ${hotel.price}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: priceColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Payment and Add Review Buttons
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to payment page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                child: const Text(
                                  'Proceed to Payment',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to add rating page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                                child: const Text(
                                  'Add Review',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Ratings Section
                Text(
                  'Ratings & Reviews',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor),
                ),
                const SizedBox(height: 10),
                if (ratings.isNotEmpty)
                  Column(
                    children: ratings.map((rating) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${rating.username}: ',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '⭐ ${rating.rating} - ${rating.review}\n',
                                      style: const TextStyle(),
                                    ),
                                    TextSpan(
                                      text: rating.date,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                else
                  const Text('No ratings yet. Be the first to leave a review!'),
                const SizedBox(height: 50),

                // Related Hotels Section
                Text(
                  'Related Hotels Nearby',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 320, // Adjust height as needed
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: relatedHotels.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 20),
                    itemBuilder: (context, index) {
                      final related = relatedHotels[index];
                      return Container(
                        width: 300,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigate to related hotel detail
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  related.imageUrl ?? '',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/No_image.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      related.name,
                                      style: TextStyle(fontSize: 20, color: titleColor, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Price: ${related.price}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: priceColor),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigate to booking page for related hotel
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                      child: const Text('Book Now'),
                                    ),
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
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Mock Classes for Hotel and Rating (Replace with your actual data models)
class Hotel {
  final int id;
  final String name;
  final String? imageUrl;
  final String price;

  Hotel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class Rating {
  final String username;
  final int rating;
  final String review;
  final String date;

  Rating({
    required this.username,
    required this.rating,
    required this.review,
    required this.date,
  });
}
