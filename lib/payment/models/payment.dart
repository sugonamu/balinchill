import 'dart:convert';

List<Transaction> transactionFromJson(dynamic data) =>
    List<Transaction>.from(data.map((x) => Transaction.fromJson(x)));
String transactionToJson(List<Transaction> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaction {
  final int id;
  final int user;
  final int hotel;
  final double totalPrice;
  final String phoneNumber;
  final String creditCardNumber;
  final String validThru;
  final String cvv;
  final String cardName;
  final String bookingDate;
  final String paymentMethod;
  final String status;

  Transaction({
    required this.id,
    required this.user,
    required this.hotel,
    required this.totalPrice,
    required this.phoneNumber,
    required this.creditCardNumber,
    required this.validThru,
    required this.cvv,
    required this.cardName,
    required this.bookingDate,
    required this.paymentMethod,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        user: json["user"],
        hotel: json["hotel"],
        totalPrice: json["total_price"].toDouble(),
        phoneNumber: json["phone_number"],
        creditCardNumber: json["credit_card_number"],
        validThru: json["valid_thru"],
        cvv: json["cvv"],
        cardName: json["card_name"],
        bookingDate: json["booking_date"],
        paymentMethod: json["payment_method"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "hotel": hotel,
        "total_price": totalPrice,
        "phone_number": phoneNumber,
        "credit_card_number": creditCardNumber,
        "valid_thru": validThru,
        "cvv": cvv,
        "card_name": cardName,
        "booking_date": bookingDate,
        "payment_method": paymentMethod,
        "status": status,
      };
}

class PaymentProfile {
  final int id;
  final String user;
  final String phoneNumber;
  final String creditCardNumber;
  final String validThru;
  final String cvv;
  final String cardName;

  PaymentProfile({
    required this.id,
    required this.user,
    required this.phoneNumber,
    required this.creditCardNumber,
    required this.validThru,
    required this.cvv,
    required this.cardName,
  });

  factory PaymentProfile.fromJson(Map<String, dynamic> json) => PaymentProfile(
        id: json["id"],
        user: json["user"],
        phoneNumber: json["phone_number"],
        creditCardNumber: json["credit_card_number"],
        validThru: json["valid_thru"],
        cvv: json["cvv"],
        cardName: json["card_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "phone_number": phoneNumber,
        "credit_card_number": creditCardNumber,
        "valid_thru": validThru,
        "cvv": cvv,
        "card_name": cardName,
      };
}