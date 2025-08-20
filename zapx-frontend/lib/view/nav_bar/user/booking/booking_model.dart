// booking_model.dart
class BookingResponse {
  final List<Booking> bookings;

  BookingResponse({required this.bookings});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookings:
          (json['bookings'] as List)
              .map((booking) => Booking.fromJson(booking))
              .toList(),
    );
  }
}

class Booking {
  final int id;
  final DateTime date;
  final DateTime deliveryDate;
  final String notes;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String totalPrice;
  final String status;
  final String location;
  final String bookingReferenceId;
  final Seller seller;
  final Consumer? consumer;
  final String? clientName;
  final List<ExampleImage> exampleImages;

  Booking({
    required this.clientName,
    required this.id,
    required this.date,
    required this.deliveryDate,
    required this.notes,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.location,
    required this.bookingReferenceId,
    required this.seller,
    this.consumer,
    required this.exampleImages,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    DateTime startTime = DateTime.parse(json['startTime']);
    DateTime endTime = DateTime.parse(json['endTime']);
    Consumer? consumer;
    if (json['Consumer'] != null) {
      consumer = Consumer.fromJson(json['Consumer']);
    }
    // Ensure endTime is always after startTime
    if (!endTime.isAfter(startTime)) {
      endTime = startTime.add(
        const Duration(hours: 1),
      ); // Default 1-hour duration
      print('Adjusted endTime for booking ${json['id']}');
    }

    return Booking(
      id: json['id'],
      clientName: json['clientName'],
      date: DateTime.parse(json['date']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      notes: json['notes'],
      description: json['description'],
      startTime: startTime,
      endTime: endTime,
      totalPrice: json['totalPrice'],
      status: json['status'],
      location: json['location'],
      bookingReferenceId: json['bookingReferenceId'],
      seller: Seller.fromJson(json['Seller']),
      consumer: consumer,
      exampleImages:
          (json['ExampleImages'] as List)
              .map((image) => ExampleImage.fromJson(image))
              .toList(),
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

class Consumer {
  final int id;
  final User user;

  Consumer({required this.id, required this.user});

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(
      id: json['id'],
      user: User.fromJson(json['User']), // User should handle its own nulls
    );
  }
}

class User {
  final int id;
  final String fullName;
  final ProfileImage profileImage;

  User({required this.id, required this.fullName, required this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      profileImage:
          json['ProfileImage'] != null
              ? ProfileImage.fromJson(json['ProfileImage'])
              : ProfileImage(
                // Default empty profile image
                id: 0,
                mimeType: '',
                url: 'assets/default_avatar.png', // Add a default asset
              ),
    );
  }
}

class ProfileImage {
  final int id;
  final String mimeType;
  final String url;

  ProfileImage({required this.id, required this.mimeType, required this.url});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'],
      mimeType: json['mimeType'],
      url: json['url'],
    );
  }
}

class ExampleImage {
  final int id;
  final String mimeType;
  final String url;

  ExampleImage({required this.id, required this.mimeType, required this.url});

  factory ExampleImage.fromJson(Map<String, dynamic> json) {
    return ExampleImage(
      id: json['id'] ?? 0,
      mimeType: json['mimeType'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
