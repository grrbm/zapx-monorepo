class SellerReviewModel {
  final List<Review> reviews;

  SellerReviewModel({required this.reviews});

  factory SellerReviewModel.fromJson(Map<String, dynamic> json) {
    return SellerReviewModel(
      reviews:
          (json['reviews'] as List)
              .map((review) => Review.fromJson(review))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'reviews': reviews.map((review) => review.toJson()).toList()};
  }
}

class Review {
  final int rating;
  final String description;
  final DateTime createdAt;
  final Consumer consumer;

  Review({
    required this.rating,
    required this.description,
    required this.createdAt,
    required this.consumer,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      consumer: Consumer.fromJson(json['Consumer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'Consumer': consumer.toJson(),
    };
  }
}

class Consumer {
  final int id;
  final User user;

  Consumer({required this.id, required this.user});

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(id: json['id'], user: User.fromJson(json['User']));
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'User': user.toJson()};
  }
}

class User {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final ProfileImage profileImage;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      profileImage: ProfileImage.fromJson(json['ProfileImage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'ProfileImage': profileImage.toJson(),
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
      id: json['id'],
      url: json['url'],
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'mimeType': mimeType};
  }
}
