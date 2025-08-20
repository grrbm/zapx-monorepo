// To parse this JSON data, do
//
//     final postListModel = postListModelFromJson(jsonString);

import 'dart:convert';

PostListModel postListModelFromJson(String str) =>
    PostListModel.fromJson(json.decode(str));

String postListModelToJson(PostListModel data) => json.encode(data.toJson());

class PostListModel {
  List<Post> posts;
  int? count;
  dynamic nextFrom;

  PostListModel({this.posts = const [], this.count, this.nextFrom});

  factory PostListModel.fromJson(Map<String, dynamic> json) => PostListModel(
    posts:
        json["posts"] == null
            ? []
            : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
    count: json["count"],
    nextFrom: json["nextFrom"],
  );

  Map<String, dynamic> toJson() => {
    "posts":
        posts.isEmpty ? [] : List<dynamic>.from(posts.map((x) => x.toJson())),
    "count": count,
    "nextFrom": nextFrom,
  };
}

class Post {
  int? id;
  String? description;
  String? hourlyRate;
  String? location;
  String? notes;
  List<ImagePost>? images;
  List<Type>? locationType;
  List<Type>? venueType;
  List<Time>? time;
  List<dynamic>? review;

  Post({
    this.id,
    this.description,
    this.hourlyRate,
    this.location,
    this.notes,
    this.images,
    this.locationType,
    this.venueType,
    this.time,
    this.review,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    description: json["description"],
    hourlyRate: json["hourlyRate"],
    location: json["location"],
    notes: json["notes"],
    images:
        json["Images"] == null
            ? []
            : List<ImagePost>.from(
              json["Images"]!.map((x) => ImagePost.fromJson(x)),
            ),
    locationType:
        json["LocationType"] == null
            ? []
            : List<Type>.from(
              json["LocationType"]!.map((x) => Type.fromJson(x)),
            ),
    venueType:
        json["VenueType"] == null
            ? []
            : List<Type>.from(json["VenueType"]!.map((x) => Type.fromJson(x))),
    time:
        json["Time"] == null
            ? []
            : List<Time>.from(json["Time"]!.map((x) => Time.fromJson(x))),
    review:
        json["Review"] == null
            ? []
            : List<dynamic>.from(json["Review"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "hourlyRate": hourlyRate,
    "location": location,
    "notes": notes,
    "Images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "LocationType":
        locationType == null
            ? []
            : List<dynamic>.from(locationType!.map((x) => x.toJson())),
    "VenueType":
        venueType == null
            ? []
            : List<dynamic>.from(venueType!.map((x) => x.toJson())),
    "Time":
        time == null ? [] : List<dynamic>.from(time!.map((x) => x.toJson())),
    "Review": review == null ? [] : List<dynamic>.from(review!.map((x) => x)),
  };
}

class ImagePost {
  int? id;
  String? url;
  String? mimeType;
  dynamic sellerImageId;
  dynamic sellerCardImageId;
  int? postId;
  dynamic portfolioId;
  dynamic exampleBookingImageId;
  dynamic deliverBookingImageId;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic messageId;

  ImagePost({
    this.id,
    this.url,
    this.mimeType,
    this.sellerImageId,
    this.sellerCardImageId,
    this.postId,
    this.portfolioId,
    this.exampleBookingImageId,
    this.deliverBookingImageId,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.messageId,
  });

  factory ImagePost.fromJson(Map<String, dynamic> json) => ImagePost(
    id: json["id"],
    url: json["url"],
    mimeType: json["mimeType"],
    sellerImageId: json["sellerImageId"],
    sellerCardImageId: json["sellerCardImageId"],
    postId: json["postId"],
    portfolioId: json["portfolioId"],
    exampleBookingImageId: json["exampleBookingImageId"],
    deliverBookingImageId: json["deliverBookingImageId"],
    deleted: json["deleted"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    messageId: json["messageId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "mimeType": mimeType,
    "sellerImageId": sellerImageId,
    "sellerCardImageId": sellerCardImageId,
    "postId": postId,
    "portfolioId": portfolioId,
    "exampleBookingImageId": exampleBookingImageId,
    "deliverBookingImageId": deliverBookingImageId,
    "deleted": deleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "messageId": messageId,
  };
}

class Type {
  int? id;
  String? name;
  int? postId;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  Type({
    this.id,
    this.name,
    this.postId,
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
    postId: json["postId"],
    deleted: json["deleted"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "postId": postId,
    "deleted": deleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Time {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  int? postId;
  dynamic schedulerDateId;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  Time({
    this.id,
    this.startTime,
    this.endTime,
    this.postId,
    this.schedulerDateId,
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    id: json["id"],
    startTime:
        json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
    endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
    postId: json["postId"],
    schedulerDateId: json["schedulerDateId"],
    deleted: json["deleted"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "startTime": startTime?.toIso8601String(),
    "endTime": endTime?.toIso8601String(),
    "postId": postId,
    "schedulerDateId": schedulerDateId,
    "deleted": deleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
