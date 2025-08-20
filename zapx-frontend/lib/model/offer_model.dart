class OfferModel {
  final List<Offer> offers;

  OfferModel({required this.offers});

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing OfferModel from JSON: $json');

    try {
      final offersList = json['offers'] as List;
      print('📋 Found ${offersList.length} offers in response');

      final offers =
          offersList.map((offerJson) {
            print('🔍 Parsing offer: $offerJson');
            return Offer.fromJson(offerJson);
          }).toList();

      print('✅ Successfully parsed ${offers.length} offers');
      return OfferModel(offers: offers);
    } catch (e) {
      print('❌ Error parsing OfferModel: $e');
      rethrow;
    }
  }
}

class Offer {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;
  final String? status;
  final String? price; // This will now be mapped from totalPrice
  final String? description;
  final String? location;
  final String? notes;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? clientName;
  final String? consumerEmail;
  final String? message;
  final String? bookingReferenceId;
  final String? deliveryDate;
  final String? reminderTime;
  final Consumer? consumer;
  final int? sellerId;
  final Seller? seller;

  Offer({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.status,
    this.price,
    this.description,
    this.location,
    this.notes,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    this.clientName,
    this.consumerEmail,
    this.message,
    this.bookingReferenceId,
    this.deliveryDate,
    this.reminderTime,
    this.consumer,
    this.sellerId,
    this.seller,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    print('Offer JSON: $json');
    try {
      print('🔍 Parsing individual offer fields...');
      // Parse all fields robustly, with null checks and fallbacks
      final id = json['id'] ?? json['offerId'] ?? 0;
      final startTime =
          DateTime.tryParse(json['startTime']?.toString() ?? '') ??
          DateTime.now();
      final endTime =
          DateTime.tryParse(json['endTime']?.toString() ?? '') ??
          DateTime.now();
      final date =
          DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now();
      final status = json['status']?.toString();
      final totalPrice = json['totalPrice']?.toString();
      final description = json['description']?.toString();
      final location = json['location']?.toString();
      final notes = json['notes']?.toString();
      final deleted =
          json['deleted'] is bool
              ? json['deleted']
              : (json['deleted']?.toString() == 'true');
      final createdAtStr =
          json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '';
      final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
      final updatedAt =
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now();
      final clientName = json['clientName']?.toString();
      final consumerEmail = json['consumerEmail']?.toString();
      final message = json['message']?.toString();
      final bookingReferenceId = json['bookingReferenceId']?.toString();
      final deliveryDate = json['deliveryDate']?.toString();
      final reminderTime = json['reminderTime']?.toString();
      // Parse consumer info if available
      Consumer? consumer;
      if (json['Consumer'] != null) {
        consumer = Consumer.fromJson(json['Consumer']);
      }

      // Parse seller info if available
      int? sellerId;
      Seller? seller;
      if (json['Seller'] != null) {
        print('🔍 Parsing seller info: ${json['Seller']}');
        seller = Seller.fromJson(json['Seller']);
        sellerId = seller.id;
        print('✅ Seller parsed: ${seller.user.fullName} (ID: ${seller.id})');
      }
      print('✅ Successfully parsed offer ID: $id');
      return Offer(
        id: id is int ? id : int.tryParse(id.toString()) ?? 0,
        startTime: startTime,
        endTime: endTime,
        date: date,
        status: status,
        price: totalPrice, // Use totalPrice for price
        description: description,
        location: location,
        notes: notes,
        deleted: deleted,
        createdAt: createdAt,
        updatedAt: updatedAt,
        clientName: clientName,
        consumerEmail: consumerEmail,
        message: message,
        bookingReferenceId: bookingReferenceId,
        deliveryDate: deliveryDate,
        reminderTime: reminderTime,
        consumer: consumer,
        sellerId: sellerId,
        seller: seller,
      );
    } catch (e) {
      print('❌ Error parsing individual offer: $e');
      print('❌ Problematic JSON: $json');
      // Return a safe fallback Offer
      return Offer(
        id: 0,
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        date: DateTime.now(),
        status: null,
        price: null,
        description: null,
        location: null,
        notes: null,
        deleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        clientName: null,
        consumerEmail: null,
        message: null,
        bookingReferenceId: null,
        deliveryDate: null,
        reminderTime: null,
        consumer: null,
        sellerId: null,
        seller: null,
      );
    }
  }
}

class Consumer {
  final int id;
  final String? phone;
  final String? stripeCustomerId;
  final int userId;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consumer({
    required this.id,
    this.phone,
    this.stripeCustomerId,
    required this.userId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consumer.fromJson(Map<String, dynamic> json) {
    try {
      return Consumer(
        id:
            json['id'] is int
                ? json['id']
                : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        phone: json['phone']?.toString(),
        stripeCustomerId: json['stripeCustomerId']?.toString(),
        userId:
            json['userId'] is int
                ? json['userId']
                : int.tryParse(json['userId']?.toString() ?? '') ?? 0,
        deleted:
            json['deleted'] is bool
                ? json['deleted']
                : (json['deleted']?.toString() == 'true'),
        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
            DateTime.now(),
      );
    } catch (e) {
      print('❌ Error parsing Consumer: $e');
      // Return a safe fallback Consumer
      return Consumer(
        id: 0,
        phone: null,
        stripeCustomerId: null,
        userId: 0,
        deleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
}

class User {
  final int id;
  final String fullName;
  final String? username;
  final String? email;
  final ProfileImage? profileImage;

  User({
    required this.id,
    required this.fullName,
    this.username,
    this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'] ?? 'Unknown User',
      username: json['username'],
      email: json['email'],
      profileImage:
          json['ProfileImage'] != null
              ? ProfileImage.fromJson(json['ProfileImage'])
              : null,
    );
  }
}

class ProfileImage {
  final int id;
  final String url;
  final String mimeType;

  ProfileImage({required this.id, required this.url, required this.mimeType});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'],
      url: json['url'],
      mimeType: json['mimeType'],
    );
  }
}

class Seller {
  final int id;
  final User user;

  Seller({required this.id, required this.user});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(id: json['id'], user: User.fromJson(json['User']));
  }
}
