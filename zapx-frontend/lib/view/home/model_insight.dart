class Insight {
  final int totalBookings;
  final int totalHours;
  final int totalRevenue;

  Insight({
    required this.totalBookings,
    required this.totalHours,
    required this.totalRevenue,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      totalBookings: json['totalBookings'] ?? 0,
      totalHours: json['totalHours'] ?? 0,
      totalRevenue: json['totalRevenue'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'totalHours': totalHours,
      'totalRevenue': totalRevenue,
    };
  }
}
