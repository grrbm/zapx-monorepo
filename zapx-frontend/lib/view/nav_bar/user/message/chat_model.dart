class ChatModel {
  List<Chat> chats;
  int count;
  bool nextFrom;

  ChatModel({required this.chats, required this.count, required this.nextFrom});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chats: List<Chat>.from(json['chats'].map((x) => Chat.fromJson(x))),
      count: json['count'],
      nextFrom: json['nextFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chats': List<dynamic>.from(chats.map((x) => x.toJson())),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}

class Chat {
  int id;
  List<User> users;
  List<Message> messages;

  Chat({required this.id, required this.users, required this.messages});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      users: List<User>.from(json['Users'].map((x) => User.fromJson(x))),
      messages: List<Message>.from(
        json['Message'].map((x) => Message.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Users': List<dynamic>.from(users.map((x) => x.toJson())),
      'Message': List<dynamic>.from(messages.map((x) => x.toJson())),
    };
  }
}

class User {
  int id;
  String? fullName;
  String username;
  String role;
  ProfileImage? profileImage;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      role: json['role'],
      profileImage:
          json['ProfileImage'] != null
              ? ProfileImage.fromJson(json['ProfileImage'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'role': role,
      'ProfileImage': profileImage?.toJson(),
    };
  }
}

class ProfileImage {
  int id;
  String url;
  String mimeType;

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

class Message {
  int id;
  String content;
  int userId;
  int chatId;
  bool deleted;
  DateTime createdAt;
  DateTime updatedAt;

  Message({
    required this.id,
    required this.content,
    required this.userId,
    required this.chatId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      userId: json['userId'],
      chatId: json['chatId'],
      deleted: json['deleted'],
      createdAt: DateTime.parse(json['createdAt']), // Parse String to DateTime
      updatedAt: DateTime.parse(json['updatedAt']), // Parse String to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "userId": userId,
      "chatId": chatId,
      "deleted": deleted,
      "createdAt": createdAt.toIso8601String(), // Convert DateTime to String
      "updatedAt": updatedAt.toIso8601String(), // Convert DateTime to String
    };
  }
}
