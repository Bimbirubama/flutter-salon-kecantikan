import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';

class BookingService {
  // GANTI sesuai environment
  static const String baseUrl = 'http://10.85.141.178:8081/api/bookings';

  /// GET ALL BOOKINGS
  static Future<List<Booking>> getBookings() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['success'] == true) {
        return (jsonData['data'] as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to load bookings');
      }
    } else {
      throw Exception('Server error');
    }
  }

  /// GET BOOKING BY ID
  static Future<Booking> getBookingById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['success'] == true) {
        return Booking.fromJson(jsonData['data']);
      } else {
        throw Exception('Booking not found');
      }
    } else {
      throw Exception('Failed to fetch booking');
    }
  }

  /// CREATE BOOKING
  static Future<bool> createBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(booking.toJson()),
    );

    final jsonData = json.decode(response.body);
    return response.statusCode == 201 && jsonData['success'] == true;
  }

  /// UPDATE BOOKING
  static Future<bool> updateBooking(int id, Booking booking) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(booking.toJson()),
    );

    final jsonData = json.decode(response.body);
    return response.statusCode == 200 && jsonData['success'] == true;
  }

  /// DELETE BOOKING
  static Future<bool> deleteBooking(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    final jsonData = json.decode(response.body);
    return response.statusCode == 200 && jsonData['success'] == true;
  }
}
