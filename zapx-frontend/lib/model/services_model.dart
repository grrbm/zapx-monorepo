class ServiceModel {
  final int id;
  final String name;

  ServiceModel({required this.id, required this.name});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ServicesModel {
  final List<ServiceModel> services;
  final int count;
  final dynamic nextFrom;

  ServicesModel({
    required this.services,
    required this.count,
    required this.nextFrom,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    var list = json['services'] as List;
    List<ServiceModel> servicesList =
        list.map((i) => ServiceModel.fromJson(i)).toList();

    return ServicesModel(
      services: servicesList,
      count: json['count'],
      nextFrom: json['nextFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'services': services.map((service) => service.toJson()).toList(),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}
