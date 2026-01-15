class Review {
  final int? id;
  final String customerId;
  final int salonId;
  final int rating;
  final String? comment;
  final String? createdAt;

  Review({
    this.id,
    required this.customerId,
    required this.salonId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  /// FROM JSON (API → Flutter)
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      customerId: json['customer_id'],
      salonId: json['salon_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }

  /// TO JSON (Flutter → API)
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'salon_id': salonId,
      'rating': rating,
      'comment': comment,
    };
  }
}
