class Property {
  final String id;
  final String host;
  final String hotelName;  
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
    required this.host,
    required this.hotelName,
    required this.category,
    required this.address,
    required this.contact,
    required this.price,
    required this.amenities,
    required this.imageUrl,
    required this.location,
    required this.pageUrl,
  });

  // Factory constructor to create a Property instance from a JSON object
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      host: json['host'],  // Assuming the host is passed from the backend
      hotelName: json['Hotel'],
      category: json['Category'],
      address: json['Address'],
      contact: json['Contact'],
      price: json['Price'],
      amenities: json['Amenities'],
      imageUrl: json['Image_URL'],
      location: json['Location'],
      pageUrl: json['Page_URL'],
    );
  }

  // Method to convert the Property instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host': host,
      'Hotel': hotelName,
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
