class UserResponse {
  final User user;

  UserResponse({required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(user: User.fromJson(json['User']));
  }

  Map<String, dynamic> toJson() {
    return {'User': user.toJson()};
  }
}

class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String role;
  final Seller seller;
  final ProfileImage? profileImage; // make this nullable
  final dynamic avgRating; // handle _avg.rating

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    required this.seller,
    this.profileImage,
    this.avgRating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // add null safety
      username: json['username'] ?? '', // add null safety
      fullName: json['fullName'] ?? '', // add null safety
      email: json['email'] ?? '', // add null safety
      role: json['role'] ?? '', // add null safety
      seller:
          json['Seller'] != null
              ? Seller.fromJson(json['Seller'])
              : Seller(id: 0, reviewCount: 0), // add null safety
      profileImage:
          json['ProfileImage'] != null
              ? ProfileImage.fromJson(json['ProfileImage'])
              : null,
      avgRating: json['_avg']?['rating'], // safely handle _avg.rating
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'role': role,
      'Seller': seller.toJson(),
      'ProfileImage': profileImage?.toJson(), // safe toJson
      '_avg': {'rating': avgRating}, // include avgRating in toJson
    };
  }
}

class Seller {
  final int id;
  final String? aboutMe; // make nullable
  final String? location; // make nullable
  final int reviewCount; // handle _count.Review

  Seller({
    required this.id,
    this.aboutMe, // make optional
    this.location, // make optional
    required this.reviewCount,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? 0, // add null safety for id
      aboutMe: json['aboutMe'], // can be null
      location: json['location'], // can be null
      reviewCount:
          json['_count']?['Review'] ?? 0, // safely handle _count.Review
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aboutMe': aboutMe, // can be null
      'location': location, // can be null
      '_count': {'Review': reviewCount}, // include reviewCount in toJson
    };
  }
}

class ProfileImage {
  final int id;
  final String url;
  final String mimeType;

  ProfileImage({required this.id, required this.url, required this.mimeType});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'] ?? 0, // add null safety
      url: json['url'] ?? '', // add null safety
      mimeType: json['mimeType'] ?? '', // add null safety
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'mimeType': mimeType};
  }
}
