class PortfolioResponse {
  final List<PortfolioSeller> portfolio;
  final int count;
  final dynamic nextFrom;

  PortfolioResponse({
    required this.portfolio,
    required this.count,
    required this.nextFrom,
  });

  factory PortfolioResponse.fromJson(Map<String, dynamic> json) {
    return PortfolioResponse(
      portfolio:
          (json['portfolio'] as List)
              .map((item) => PortfolioSeller.fromJson(item))
              .toList(),
      count: json['count'],
      nextFrom: json['nextFrom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'portfolio': portfolio.map((item) => item.toJson()).toList(),
      'count': count,
      'nextFrom': nextFrom,
    };
  }
}

class PortfolioSeller {
  final int id;
  final String title;
  final List<Image> images;

  PortfolioSeller({
    required this.id,
    required this.title,
    required this.images,
  });

  factory PortfolioSeller.fromJson(Map<String, dynamic> json) {
    return PortfolioSeller(
      id: json['id'],
      title: json['title'],
      images:
          (json['Images'] as List).map((item) => Image.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'Images': images.map((item) => item.toJson()).toList(),
    };
  }
}

class Image {
  final int id;
  final String url;
  final String mimeType;
  final int? sellerImageId;
  final int? sellerCardImageId;
  final int? postId;
  final int? portfolioId;
  final int? exampleBookingImageId;
  final int? deliverBookingImageId;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? messageId;

  Image({
    required this.id,
    required this.url,
    required this.mimeType,
    this.sellerImageId,
    this.sellerCardImageId,
    this.postId,
    this.portfolioId,
    this.exampleBookingImageId,
    this.deliverBookingImageId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    this.messageId,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      url: json['url'],
      mimeType: json['mimeType'],
      sellerImageId: json['sellerImageId'],
      sellerCardImageId: json['sellerCardImageId'],
      postId: json['postId'],
      portfolioId: json['portfolioId'],
      exampleBookingImageId: json['exampleBookingImageId'],
      deliverBookingImageId: json['deliverBookingImageId'],
      deleted: json['deleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messageId': messageId,
    };
  }
}
