class LocationModel {
  final List<Locations> locations;
  final int count;
  final dynamic nextFrom;

  LocationModel({
    required this.locations,
    required this.count,
    required this.nextFrom,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      locations:
          (json['locations'] as List)
              .map((location) => Locations.fromJson(location))
              .toList(),
      count: json['count'],
      nextFrom: json['nextFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locations': locations.map((location) => location.toJson()).toList(),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}

class Locations {
  final int id;
  final String name;

  Locations({required this.id, required this.name});

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
