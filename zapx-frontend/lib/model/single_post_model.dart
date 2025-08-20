// To parse this JSON data, do
//
//     final singlePostModel = singlePostModelFromJson(jsonString);

import 'dart:convert';

SinglePostModel singlePostModelFromJson(String str) =>
    SinglePostModel.fromJson(json.decode(str));

String singlePostModelToJson(SinglePostModel data) =>
    json.encode(data.toJson());

class SinglePostModel {
  Post? post;

  SinglePostModel({this.post});

  factory SinglePostModel.fromJson(Map<String, dynamic> json) =>
      SinglePostModel(
        post: json["post"] == null ? null : Post.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {"post": post?.toJson()};
}

class Post {
  int? id;
  String? description;
  String? hourlyRate;
  String? location;
  String? notes;
  List<SingleImagePost>? images;
  List<dynamic>? locationType;
  List<dynamic>? venueType;
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
            : List<SingleImagePost>.from(
              json["Images"]!.map((x) => SingleImagePost.fromJson(x)),
            ),
    locationType:
        json["LocationType"] == null
            ? []
            : List<dynamic>.from(json["LocationType"]!.map((x) => x)),
    venueType:
        json["VenueType"] == null
            ? []
            : List<dynamic>.from(json["VenueType"]!.map((x) => x)),
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
            : List<dynamic>.from(locationType!.map((x) => x)),
    "VenueType":
        venueType == null ? [] : List<dynamic>.from(venueType!.map((x) => x)),
    "Time":
        time == null ? [] : List<dynamic>.from(time!.map((x) => x.toJson())),
    "Review": review == null ? [] : List<dynamic>.from(review!.map((x) => x)),
  };
}

class SingleImagePost {
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

  SingleImagePost({
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

  factory SingleImagePost.fromJson(
    Map<String, dynamic> json,
  ) => SingleImagePost(
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
