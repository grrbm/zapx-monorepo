class ApiResponseScheduler {
  List<ServiceScheduler> serviceScheduler;
  int count;
  bool nextFrom;

  ApiResponseScheduler({
    required this.serviceScheduler,
    required this.count,
    required this.nextFrom,
  });

  factory ApiResponseScheduler.fromJson(Map<String, dynamic> json) {
    return ApiResponseScheduler(
      serviceScheduler:
          (json['serviceScheduler'] as List?)
              ?.map((item) => ServiceScheduler.fromJson(item))
              .toList() ??
          [],
      count: json['count'] ?? 0,
      nextFrom: json['nextFrom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceScheduler':
          serviceScheduler.map((item) => item.toJson()).toList(),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}

class ServiceScheduler {
  int id;
  int rate;
  Seller seller;
  List<Service> services;
  List<SchedulerDate> schedulerDate;
  double? averageRating;

  ServiceScheduler({
    required this.id,
    required this.rate,
    required this.seller,
    required this.services,
    required this.schedulerDate,
    this.averageRating,
  });

  factory ServiceScheduler.fromJson(Map<String, dynamic> json) {
    return ServiceScheduler(
      id: json['id'] ?? 0,
      rate: json['rate'] ?? 0,
      seller:
          json['Seller'] != null
              ? Seller.fromJson(json['Seller'])
              : Seller(id: 0, reviewCount: 0, user: User(id: 0, fullName: '')),
      services:
          (json['Services'] as List?)
              ?.map((item) => Service.fromJson(item))
              .toList() ??
          [],
      schedulerDate:
          (json['SchedulerDate'] as List?)
              ?.map((item) => SchedulerDate.fromJson(item))
              .toList() ??
          [],
      averageRating:
          (json['_avg'] != null && json['_avg']['rating'] != null)
              ? json['_avg']['rating'].toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'Seller': seller.toJson(),
      'Services': services.map((item) => item.toJson()).toList(),
      'SchedulerDate': schedulerDate.map((item) => item.toJson()).toList(),
      '_avg': {'rating': averageRating},
    };
  }
}

class Seller {
  int id;
  String? aboutMe;
  int reviewCount;
  User user;

  Seller({
    required this.id,
    this.aboutMe,
    required this.reviewCount,
    required this.user,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? 0,
      aboutMe: json['aboutMe'],
      reviewCount: json['_count'] != null ? json['_count']['Review'] ?? 0 : 0,
      user:
          json['User'] != null
              ? User.fromJson(json['User'])
              : User(id: 0, fullName: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aboutMe': aboutMe,
      '_count': {'Review': reviewCount},
      'User': user.toJson(),
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
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      mimeType: json['mimeType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'mimeType': mimeType};
  }
}

class User {
  int id;
  String fullName;
  ProfileImage? profileImage;

  User({required this.id, required this.fullName, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
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
      'ProfileImage': profileImage?.toJson(),
    };
  }
}

class Service {
  int id;
  String name;
  Category category;

  Service({required this.id, required this.name, required this.category});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category:
          json['Category'] != null
              ? Category.fromJson(json['Category'])
              : Category(id: 0, name: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'Category': category.toJson()};
  }
}

class Category {
  int id;
  String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class SchedulerDate {
  String date;
  List<Time> time;

  SchedulerDate({required this.date, required this.time});

  factory SchedulerDate.fromJson(Map<String, dynamic> json) {
    return SchedulerDate(
      date: json['date'] ?? '',
      time:
          (json['Time'] as List?)
              ?.map((item) => Time.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'Time': time.map((item) => item.toJson()).toList()};
  }
}

class Time {
  int id;
  String startTime;
  String endTime;
  int rate;

  Time({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.rate,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      rate: json['rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'startTime': startTime, 'endTime': endTime, 'rate': rate};
  }
}
