class Consumer {
  final int id;
  final String? phone;

  Consumer({required this.id, this.phone});

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(
      id: json['id'] as int? ?? 0, // Handle null/type mismatch for ID
      phone: json['phone'] as String?,
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
      id: json['id'] as int,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
    );
  }
}

class UserConsumer {
  final String? username; // Made nullable
  final String? fullName; // Made nullable
  final Consumer? consumer; // Made nullable
  final ProfileImage? profileImage;

  UserConsumer({
    this.username,
    this.fullName,
    this.consumer,
    this.profileImage,
  });

  factory UserConsumer.fromJson(Map<String, dynamic> json) {
    return UserConsumer(
      username: json['username'] as String? ?? 'Anonymous', // Fallback value
      fullName: json['fullName'] as String? ?? 'No Name', // Fallback value
      consumer: json['Consumer'] != null
          ? Consumer.fromJson(json['Consumer'])
          : null, // Handle null Consumer
      profileImage: json['ProfileImage'] != null
          ? ProfileImage.fromJson(json['ProfileImage'])
          : null, // Handle null ProfileImage
    );
  }
}
