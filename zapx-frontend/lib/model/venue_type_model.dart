// To parse this JSON data, do
//
//     final venueTypeModel = venueTypeModelFromJson(jsonString);

import 'dart:convert';

VenueTypeModel venueTypeModelFromJson(String str) =>
    VenueTypeModel.fromJson(json.decode(str));

String venueTypeModelToJson(VenueTypeModel data) => json.encode(data.toJson());

class VenueTypeModel {
  List<Venue>? venue;
  int? count;
  dynamic nextFrom;

  VenueTypeModel({this.venue, this.count, this.nextFrom});

  factory VenueTypeModel.fromJson(Map<String, dynamic> json) => VenueTypeModel(
    venue:
        json["venue"] == null
            ? []
            : List<Venue>.from(json["venue"]!.map((x) => Venue.fromJson(x))),
    count: json["count"],
    nextFrom: json["nextFrom"],
  );

  Map<String, dynamic> toJson() => {
    "venue":
        venue == null ? [] : List<dynamic>.from(venue!.map((x) => x.toJson())),
    "count": count,
    "nextFrom": nextFrom,
  };
}

class Venue {
  int? id;
  String? name;

  Venue({this.id, this.name});

  factory Venue.fromJson(Map<String, dynamic> json) =>
      Venue(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
