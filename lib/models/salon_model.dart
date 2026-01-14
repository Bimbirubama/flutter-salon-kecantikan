class SalonModel {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final String services;
  final double price;

  SalonModel({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.services,
    required this.price,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      services: json['services'] ?? '',
      // Menangani konversi price dari string ke double
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
    );
  }
}