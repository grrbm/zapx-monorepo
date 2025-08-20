class ChatMessages {
  final int id;
  final List<UserModel> users;
  final List<MessageModel> messages;
  final int count;

  ChatMessages({
    required this.id,
    required this.users,
    required this.messages,
    required this.count,
  });

  factory ChatMessages.fromJson(Map<String, dynamic> json) {
    return ChatMessages(
      id: json['chat']['id'],
      users:
          (json['chat']['Users'] as List)
              .map((user) => UserModel.fromJson(user))
              .toList(),
      messages:
          (json['chat']['Message'] as List)
              .map((message) => MessageModel.fromJson(message))
              .toList(),
      count: json['count'],
    );
  }
}

class UserModel {
  final int id;
  final String? fullName;
  final String? role;
  final ProfileImageModel? profileImage;
  final SellerModel? seller;
  final ConsumerModel? consumer;

  UserModel({
    required this.id,
    this.fullName,
    this.role,
    this.profileImage,
    this.seller,
    this.consumer,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      role: json['role'],
      profileImage:
          json['ProfileImage'] != null
              ? ProfileImageModel.fromJson(json['ProfileImage'])
              : null,
      seller:
          json['Seller'] != null ? SellerModel.fromJson(json['Seller']) : null,
      consumer:
          json['Consumer'] != null
              ? ConsumerModel.fromJson(json['Consumer'])
              : null,
    );
  }
}

class ProfileImageModel {
  final int id;
  final String url;
  final String mimeType;

  ProfileImageModel({
    required this.id,
    required this.url,
    required this.mimeType,
  });

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) {
    return ProfileImageModel(
      id: json['id'],
      url: json['url'],
      mimeType: json['mimeType'],
    );
  }
}

class MessageModel {
  final int id;
  final String? content;
  final DateTime createdAt;
  final List<FileModel> files;
  final List<UserModel> seenBy;

  MessageModel({
    required this.id,
    this.content,
    required this.createdAt,
    required this.files,
    required this.seenBy,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      files:
          (json['File'] as List)
              .map((file) => FileModel.fromJson(file))
              .toList(),
      seenBy:
          (json['SeenBy'] as List)
              .map((user) => UserModel.fromJson(user))
              .toList(),
    );
  }
}

class FileModel {
  final int id;
  final String url;
  final String mimeType;
  final bool isLocal;
  FileModel({
    required this.id,
    required this.url,
    required this.mimeType,
    this.isLocal = false,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      url: json['url'],
      mimeType: json['mimeType'],
    );
  }
}

class SellerModel {
  final int id;

  SellerModel({required this.id});

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(id: json['id']);
  }
}

class ConsumerModel {
  final int id;

  ConsumerModel({required this.id});

  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(id: json['id']);
  }
}
