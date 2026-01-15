import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon_kecantikan/models/review_model.dart'; // Sesuaikan path file class Review anda

class ReviewService {
  // Gunakan 10.0.2.2 untuk emulator, atau IP Laptop untuk HP Fisik
  static const String baseUrl = 'http://10.85.141.178:5000/api';
  // Tambahkan fungsi ini di dalam class ReviewService anda
Future<List<Review>> getAllReviews() async {
  try {
    // Sesuaikan endpoint API admin untuk mengambil semua review
    final response = await http.get(Uri.parse('$baseUrl/reviews'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      List data = body['data'];
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      return [];
    }
  } catch (e) {
    throw Exception('Gagal memuat semua ulasan: $e');
  }
}

Future<bool> deleteReview(int id) async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/reviews/$id'));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

  // Ambil review berdasarkan ID Salon
  Future<List<Review>> getReviewsBySalon(int salonId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reviews/salon/$salonId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        List data = body['data'];
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Gagal menghubungkan ke server: $e');
    }
  }

  // Kirim review baru
  Future<bool> postReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(review.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}