class ServiceSchedulerType {
  final int id;
  final double? rate; // make nullable
  final Seller seller;
  final List<SchedulerDate>? schedulerDates;
  final double? avgRating;

  ServiceSchedulerType({
    required this.id,
    this.rate, // make optional
    required this.seller,
    this.schedulerDates,
    this.avgRating,
  });

  factory ServiceSchedulerType.fromJson(Map<String, dynamic> json) {
    return ServiceSchedulerType(
      id: json['id'] ?? 0,
      rate: json['rate']?.toDouble(), // can be null
      seller:
          json['Seller'] != null
              ? Seller.fromJson(json['Seller'])
              : Seller(
                id: 0,
                aboutMe: null,
                user: User(id: 0, fullName: ''),
                favorite: false,
                location: '',
              ),
      schedulerDates:
          json['SchedulerDate'] != null
              ? (json['SchedulerDate'] as List)
                  .map((e) => SchedulerDate.fromJson(e))
                  .toList()
              : null,
      avgRating: json['_avg']?['rating']?.toDouble(),
    );
  }
}

class User {
  final int id;
  final String fullName;
  final String? username;
  final String? email;
  final ProfileImage? profileImage;
  final List<Chat>? chats;

  User({
    required this.id,
    required this.fullName,
    this.username,
    this.email,
    this.profileImage,
    this.chats,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      username: json['username'],
      email: json['email'],
      profileImage:
          json['ProfileImage'] != null
              ? ProfileImage.fromJson(json['ProfileImage'])
              : null,
      chats:
          json['Chat'] != null
              ? (json['Chat'] as List).map((e) => Chat.fromJson(e)).toList()
              : null,
    );
  }
}

class Chat {
  final int id;

  Chat({required this.id});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(id: json['id'] ?? 0);
  }
}

class Rating {
  final double average;

  Rating({required this.average});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average:
          json['rating'] != null
              ? double.parse(json['rating'].toString())
              : 0.0,
    );
  }
}

class ProfileImage {
  final int id;
  final String url;
  final String mimeType;

  ProfileImage({required this.id, required this.url, required this.mimeType});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      mimeType: json['mimeType'] ?? '',
    );
  }
}

class ImageScheduler {
  final int id;
  final String url;
  final String mimeType;

  ImageScheduler({required this.id, required this.url, required this.mimeType});

  factory ImageScheduler.fromJson(Map<String, dynamic> json) {
    return ImageScheduler(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      mimeType: json['mimeType'] ?? '',
    );
  }
}

class Seller {
  final int id;
  final String? aboutMe;
  final User user;
  final List<Portfolio>? portfolio;
  final List<Review>? reviews;
  final int? reviewCount;
  final bool? favorite;
  final String location;

  Seller({
    required this.id,
    required this.aboutMe,
    required this.user,
    this.portfolio,
    this.reviews,
    this.reviewCount,
    required this.favorite,
    required this.location,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? 0,
      aboutMe: json['aboutMe'],
      location: json['location'] ?? "",
      user:
          json['User'] != null
              ? User.fromJson(json['User'])
              : User(id: 0, fullName: ''),
      portfolio:
          json['Portfolio'] != null
              ? (json['Portfolio'] as List)
                  .map((e) => Portfolio.fromJson(e))
                  .toList()
              : null,
      reviews:
          json['Review'] != null
              ? (json['Review'] as List).map((e) => Review.fromJson(e)).toList()
              : null,
      reviewCount: json['_count']?['Review'],
      favorite: json['favourite'] ?? false,
    );
  }
}

class Portfolio {
  final int id;
  final String title;
  final List<ImageScheduler> images;

  Portfolio({required this.id, required this.title, required this.images});

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      images:
          (json['Images'] as List?)
              ?.map((e) => ImageScheduler.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SchedulerDate {
  final DateTime date;
  final List<TimeSlot> times;

  SchedulerDate({required this.date, required this.times});

  factory SchedulerDate.fromJson(Map<String, dynamic> json) {
    return SchedulerDate(
      date: DateTime.parse(json['date']),
      times: (json['Time'] as List).map((e) => TimeSlot.fromJson(e)).toList(),
    );
  }
}

class TimeSlot {
  final int id;
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot({required this.id, required this.startTime, required this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}

class Review {
  final int id;
  final int rating;
  final String description;
  final Consumer consumer;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.rating,
    required this.description,
    required this.consumer,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      description: json['description'],
      consumer: Consumer.fromJson(json['Consumer']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Consumer {
  final int id;
  final User user;

  Consumer({required this.id, required this.user});

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(id: json['id'], user: User.fromJson(json['User']));
  }
}
