class VenueResponse {
  final List<Venue> venues;
  final int count;
  final dynamic nextFrom;

  VenueResponse({
    required this.venues,
    required this.count,
    required this.nextFrom,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) {
    return VenueResponse(
      venues: (json['venue'] as List).map((e) => Venue.fromJson(e)).toList(),
      count: json['count'],
      nextFrom: json['nextFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'venue': venues.map((e) => e.toJson()).toList(),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}

class Venue {
  final int id;
  final String name;

  Venue({required this.id, required this.name});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
