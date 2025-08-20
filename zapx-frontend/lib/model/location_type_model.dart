// To parse this JSON data, do
//
//     final locationTypeModel = locationTypeModelFromJson(jsonString);

import 'dart:convert';

LocationTypeModel locationTypeModelFromJson(String str) =>
    LocationTypeModel.fromJson(json.decode(str));

String locationTypeModelToJson(LocationTypeModel data) =>
    json.encode(data.toJson());

class LocationTypeModel {
  List<Location>? locations;
  int? count;
  dynamic nextFrom;

  LocationTypeModel({this.locations, this.count, this.nextFrom});

  factory LocationTypeModel.fromJson(Map<String, dynamic> json) =>
      LocationTypeModel(
        locations:
            json["locations"] == null
                ? []
                : List<Location>.from(
                  json["locations"]!.map((x) => Location.fromJson(x)),
                ),
        count: json["count"],
        nextFrom: json["nextFrom"],
      );

  Map<String, dynamic> toJson() => {
    "locations":
        locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
    "count": count,
    "nextFrom": nextFrom,
  };
}

class Location {
  int? id;
  String? name;

  Location({this.id, this.name});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
