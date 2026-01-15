class Booking {
  final int? id;
  final String customerId;
  final int salonId;
  final String bookingDate;
  final String status;
  final String? notes;
  final String? createdAt;

  Booking({
    this.id,
    required this.customerId,
    required this.salonId,
    required this.bookingDate,
    this.status = 'pending',
    this.notes,
    this.createdAt,
  });

  /// FROM JSON (API → Flutter)
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      customerId: json['customer_id'],
      salonId: json['salon_id'],
      bookingDate: json['booking_date'],
      status: json['status'],
      notes: json['notes'],
      createdAt: json['created_at'],
    );
  }

  /// TO JSON (Flutter → API)
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'salon_id': salonId,
      'booking_date': bookingDate,
      'status': status,
      'notes': notes,
    };
  }
}
