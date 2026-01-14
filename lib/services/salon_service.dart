import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/salon_model.dart';

class SalonService {
  // Ganti IP dengan IP Laptop Anda (10.0.2.2 untuk emulator Android)
  // Ganti path sesuai dengan lokasi file PHP Anda
  static const String baseUrl = 'http://10.0.2.2/salon_api/salons.php';

  Future<List<SalonModel>> getAllSalons() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        if (result['success'] == true) {
          List data = result['data'];
          return data.map((json) => SalonModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}