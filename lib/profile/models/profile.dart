// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    final String model;
    final String pk;
    final Fields fields;

    Profile({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        model: json["model"],
        pk: json["pk"], 
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String image;

    Fields({
        required this.user,
        required this.image,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"], // Ensure user is an int in the JSON data
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "image": image,
    };
}
