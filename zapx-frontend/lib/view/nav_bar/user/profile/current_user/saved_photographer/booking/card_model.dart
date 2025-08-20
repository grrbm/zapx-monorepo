class CardModel {
  final int id;
  final String paymentMethodId;
  final bool isPrimary;
  final int consumerId;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    required this.id,
    required this.paymentMethodId,
    required this.isPrimary,
    required this.consumerId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      paymentMethodId: json['paymentMethodId'],
      isPrimary: json['isPrimary'],
      consumerId: json['consumerId'],
      deleted: json['deleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
