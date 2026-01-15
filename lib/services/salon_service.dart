import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/salon_model.dart';

class SalonService {
  static const String baseUrl = 'http://10.85.141.178:8086/index.php';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// ===============================
  /// GET ALL SALONS
  /// ===============================
  static Future<List<SalonModel>> getSalons() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          return (jsonData['data'] as List)
              .map((e) => SalonModel.fromJson(e))
              .toList();
        }
        throw jsonData['message'] ?? 'Gagal mengambil data';
      } else {
        throw 'Server Error: ${response.statusCode}';
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// ===============================
  /// CREATE SALON (POST)
  /// ===============================
  static Future<bool> createSalon(SalonModel salon) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: jsonEncode(salon.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return jsonData['success'] == true;
      }
      return false;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// ===============================
  /// UPDATE SALON (PUT)
  /// ===============================
  static Future<bool> updateSalon(int id, SalonModel salon) async {
    try {
      // Endpoint menjadi: index.php/1
      final url = Uri.parse('$baseUrl/$id');
      
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(salon.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['success'] == true;
      }
      return false;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// ===============================
  /// DELETE SALON (DELETE)
  /// ===============================
  static Future<bool> deleteSalon(int id) async {
    try {
      // Endpoint menjadi: index.php/1
      final url = Uri.parse('$baseUrl/$id');

      final response = await http.delete(
        url,
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['success'] == true;
      }
      throw 'Gagal menghapus. Status: ${response.statusCode}';
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// ===============================
  /// ERROR HANDLER HELPER
  /// ===============================
  static String _handleError(dynamic error) {
    if (error is SocketException) {
      return "Tidak ada koneksi internet atau server mati.";
    } else if (error is http.ClientException) {
      return "Gagal terhubung ke server (CORS atau URL salah).";
    } else {
      return error.toString();
    }
  }
}