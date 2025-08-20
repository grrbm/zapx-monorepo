class PostModel {
  final List<Post> posts;
  final int count;
  final dynamic nextFrom;

  PostModel({required this.posts, required this.count, required this.nextFrom});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      posts: List<Post>.from(json['posts'].map((x) => Post.fromJson(x))),
      count: json['count'],
      nextFrom: json['nextFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((x) => x.toJson()).toList(),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}

class Post {
  final Seller seller;
  final int id;
  final String description;
  final String hourlyRate;
  final String location;
  final String notes;
  final List<PostImage> images;
  final List<LocationType> locationType;
  final List<VenueType> venueType;
  final List<Time> time;
  final List<dynamic> review;

  Post({
    required this.seller,
    required this.id,
    required this.description,
    required this.hourlyRate,
    required this.location,
    required this.notes,
    required this.images,
    required this.locationType,
    required this.venueType,
    required this.time,
    required this.review,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      seller:
          json['Seller'] != null
              ? Seller.fromJson(json['Seller'])
              : Seller(id: 0, scheduler: Scheduler(id: 0), user: User(id: 0)),
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      hourlyRate: json['hourlyRate'] ?? '',
      location: json['location'] ?? '',
      notes: json['notes'] ?? '',
      images:
          json['Images'] != null
              ? List<PostImage>.from(
                json['Images'].map((x) => PostImage.fromJson(x)),
              )
              : [],
      locationType:
          json['LocationType'] != null
              ? List<LocationType>.from(
                json['LocationType'].map((x) => LocationType.fromJson(x)),
              )
              : [],
      venueType:
          json['VenueType'] != null
              ? List<VenueType>.from(
                json['VenueType'].map((x) => VenueType.fromJson(x)),
              )
              : [],
      time:
          json['Time'] != null
              ? List<Time>.from(json['Time'].map((x) => Time.fromJson(x)))
              : [],
      review: json['Review'] != null ? List<dynamic>.from(json['Review']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Seller': seller.toJson(),
      'id': id,
      'description': description,
      'hourlyRate': hourlyRate,
      'location': location,
      'notes': notes,
      'Images': images.map((x) => x.toJson()).toList(),
      'LocationType': locationType.map((x) => x.toJson()).toList(),
      'VenueType': venueType.map((x) => x.toJson()).toList(),
      'Time': time.map((x) => x.toJson()).toList(),
      'Review': review,
    };
  }
}

class Seller {
  final int id;
  final Scheduler scheduler;
  final User user;

  Seller({required this.id, required this.scheduler, required this.user});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? 0,
      scheduler:
          json['Scheduler'] != null
              ? Scheduler.fromJson(json['Scheduler'])
              : Scheduler(id: 0),
      user: json['User'] != null ? User.fromJson(json['User']) : User(id: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'Scheduler': scheduler.toJson(), 'User': user.toJson()};
  }
}

class Scheduler {
  final int id;

  Scheduler({required this.id});

  factory Scheduler.fromJson(Map<String, dynamic> json) {
    return Scheduler(id: json['id'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class User {
  final int id;

  User({required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class PostImage {
  final int id;
  final String url;
  final String mimeType;
  final dynamic sellerImageId;
  final dynamic sellerCardImageId;
  final int postId;
  final dynamic portfolioId;
  final dynamic exampleBookingImageId;
  final dynamic deliverBookingImageId;
  final bool deleted;
  final String createdAt;
  final String updatedAt;
  final dynamic messageId;

  PostImage({
    required this.id,
    required this.url,
    required this.mimeType,
    this.sellerImageId,
    this.sellerCardImageId,
    required this.postId,
    this.portfolioId,
    this.exampleBookingImageId,
    this.deliverBookingImageId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    this.messageId,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      mimeType: json['mimeType'] ?? '',
      sellerImageId: json['sellerImageId'],
      sellerCardImageId: json['sellerCardImageId'],
      postId: json['postId'] ?? 0,
      portfolioId: json['portfolioId'],
      exampleBookingImageId: json['exampleBookingImageId'],
      deliverBookingImageId: json['deliverBookingImageId'],
      deleted: json['deleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      messageId: json['messageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'mimeType': mimeType,
      'sellerImageId': sellerImageId,
      'sellerCardImageId': sellerCardImageId,
      'postId': postId,
      'portfolioId': portfolioId,
      'exampleBookingImageId': exampleBookingImageId,
      'deliverBookingImageId': deliverBookingImageId,
      'deleted': deleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'messageId': messageId,
    };
  }
}

class LocationType {
  final int id;
  final String name;
  final int postId;
  final bool deleted;
  final String createdAt;
  final String updatedAt;

  LocationType({
    required this.id,
    required this.name,
    required this.postId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) {
    return LocationType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      postId: json['postId'] ?? 0,
      deleted: json['deleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'postId': postId,
      'deleted': deleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class VenueType {
  final int id;
  final String name;
  final int postId;
  final bool deleted;
  final String createdAt;
  final String updatedAt;

  VenueType({
    required this.id,
    required this.name,
    required this.postId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VenueType.fromJson(Map<String, dynamic> json) {
    return VenueType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      postId: json['postId'] ?? 0,
      deleted: json['deleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'postId': postId,
      'deleted': deleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Time {
  final int id;
  final String startTime;
  final String endTime;
  final int postId;
  final dynamic schedulerDateId;
  final bool deleted;
  final String createdAt;
  final String updatedAt;

  Time({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.postId,
    this.schedulerDateId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      postId: json['postId'] ?? 0,
      schedulerDateId: json['schedulerDateId'],
      deleted: json['deleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'postId': postId,
      'schedulerDateId': schedulerDateId,
      'deleted': deleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
