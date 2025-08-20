// To parse this JSON data, do
//
//     final cardListModel = cardListModelFromJson(jsonString);

import 'dart:convert';

List<CardListModel> cardListModelFromJson(String str) =>
    List<CardListModel>.from(
      json.decode(str).map((x) => CardListModel.fromJson(x)),
    );

String cardListModelToJson(List<CardListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CardListModel {
  String? id;
  String? status;
  PaymentDetails? paymentDetails;

  CardListModel({this.id, this.status, this.paymentDetails});

  factory CardListModel.fromJson(Map<String, dynamic> json) => CardListModel(
    id: json["id"],
    status: json["status"],
    paymentDetails:
        json["paymentDetails"] == null
            ? null
            : PaymentDetails.fromJson(json["paymentDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "paymentDetails": paymentDetails?.toJson(),
  };
}

class PaymentDetails {
  String? cardHolderName;
  String? cardNumber;
  String? expiryDate;
  bool? isPrimaryPaymentMethod;

  PaymentDetails({
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
    this.isPrimaryPaymentMethod,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    cardHolderName: json["cardHolderName"],
    cardNumber: json["cardNumber"],
    expiryDate: json["expiryDate"],
    isPrimaryPaymentMethod: json["isPrimaryPaymentMethod"],
  );

  Map<String, dynamic> toJson() => {
    "cardHolderName": cardHolderName,
    "cardNumber": cardNumber,
    "expiryDate": expiryDate,
    "isPrimaryPaymentMethod": isPrimaryPaymentMethod,
  };
}
