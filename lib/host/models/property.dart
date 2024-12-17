class Property {
  final String id;
  final String hotel;
  final String category;
  final String address;
  final String contact;
  final String price;
  final String amenities;
  final String imageUrl;
  final String location;
  final String pageUrl;

  Property({
    required this.id,
    required this.hotel,
    required this.category,
    required this.address,
    required this.contact,
    required this.price,
    required this.amenities,
    required this.imageUrl,
    required this.location,
    required this.pageUrl,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? '',
      hotel: json['Hotel'] ?? '',
      category: json['Category'] ?? '',
      address: json['Address'] ?? '',
      contact: json['Contact'] ?? '',
      price: json['Price'] ?? '',
      amenities: json['Amenities'] ?? '',
      imageUrl: json['Image_URL'] ?? '',
      location: json['Location'] ?? '',
      pageUrl: json['Page_URL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Hotel': hotel,
      'Category': category,
      'Address': address,
      'Contact': contact,
      'Price': price,
      'Amenities': amenities,
      'Image_URL': imageUrl,
      'Location': location,
      'Page_URL': pageUrl,
    };
  }
}