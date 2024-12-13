import 'dart:convert';  // Import the `dart:convert` package for decoding.

class Profile {
  final int id;
  final Fields fields;

  Profile({required this.id, required this.fields});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fields: Fields.fromJson(json),
    );
  }
}

class Fields {
  final User user;
  final String image;

  Fields({required this.user, required this.image});

  factory Fields.fromJson(Map<String, dynamic> json) {
    String baseUrl = "http://127.0.0.1:8000";
    String imagePath = json['image'];
    print("Image Path: $imagePath");
    // Decode the URL-encoded part
    String decodedImagePath = Uri.decodeFull(imagePath);

    // Check if the decoded image path starts with 'http' or 'https'
    String fullImageUrl = decodedImagePath.startsWith('http') || decodedImagePath.startsWith('https')
        ? decodedImagePath
        : baseUrl + decodedImagePath;

    print("Decoded Image URL: $fullImageUrl");

    return Fields(
      user: User.fromJson(json['user']),
      image: fullImageUrl,
    );
  }
}

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}
