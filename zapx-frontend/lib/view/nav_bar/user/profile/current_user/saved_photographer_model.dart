class SavedPhotographerModel {
  List<SavedUser>? savedUser;

  SavedPhotographerModel({this.savedUser});

  factory SavedPhotographerModel.fromJson(Map<String, dynamic> json) {
    return SavedPhotographerModel(
      savedUser:
          json['SavedUser'] != null
              ? (json['SavedUser'] as List)
                  .map((item) => SavedUser.fromJson(item))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'SavedUser': savedUser?.map((item) => item.toJson()).toList()};
  }
}

class SavedUser {
  int? id;
  Seller? seller;

  SavedUser({this.id, this.seller});

  factory SavedUser.fromJson(Map<String, dynamic> json) {
    return SavedUser(
      id: json['id'],
      seller: json['Seller'] != null ? Seller.fromJson(json['Seller']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'Seller': seller?.toJson()};
  }
}

class Seller {
  int? id;
  String? aboutMe;
  User? user;

  Seller({this.id, this.aboutMe, this.user});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      aboutMe: json['aboutMe'],
      user: json['User'] != null ? User.fromJson(json['User']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'aboutMe': aboutMe, 'User': user?.toJson()};
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

class User {
  int? id;
  String? fullName;
  String? username;
  ProfileImage? profileImage;

  User({this.id, this.fullName, this.username, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
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
      'ProfileImage': profileImage,
    };
  }
}
