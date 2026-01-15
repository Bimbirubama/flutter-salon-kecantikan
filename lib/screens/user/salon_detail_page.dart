import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/salon_model.dart';
import 'package:salon_kecantikan/models/review_model.dart'; // Import model Review
import 'package:salon_kecantikan/services/review_service.dart'; // Import service Review
import 'package:salon_kecantikan/screens/user/booking_form_page.dart';
import 'package:salon_kecantikan/screens/user/review_page.dart';

class SalonDetailPage extends StatelessWidget {
  final SalonModel salon;
  const SalonDetailPage({super.key, required this.salon});

  /// THEME COLORS
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorRosePink = const Color(0xFFDF8B92);

  @override
  Widget build(BuildContext context) {
    List<String> serviceList = salon.services.split(',');

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          /// 1. HEADER (Disederhanakan, Tanpa Gambar/Icon Besar)
          SliverAppBar(
            expandedHeight: 120, // Diperkecil karena tidak ada gambar
            pinned: true,
            backgroundColor: colorDeepRose,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                salon.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorRosePink, colorDeepRose],
                  ),
                ),
              ),
            ),
          ),

          /// 2. KONTEN DETAIL
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Salon & Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          salon.name,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorDeepRose),
                        ),
                      ),
                      Text(
                        "Rp ${salon.price.toStringAsFixed(0)}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: colorDeepRose),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  _buildInfoRow(Icons.location_on, salon.address),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.phone, salon.phone),

                  const Divider(height: 40),

                  const Text(
                    "Layanan Tersedia",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: serviceList
                        .map((s) => Chip(
                              label: Text(s.trim(),
                                  style: const TextStyle(fontSize: 12)),
                              backgroundColor: colorRosePink.withOpacity(0.1),
                              side: BorderSide(
                                  color: colorRosePink.withOpacity(0.5)),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Tentang Salon",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nikmati pengalaman perawatan kecantikan terbaik dengan tenaga profesional kami. Kami mengutamakan kenyamanan dan kualitas produk untuk hasil yang maksimal bagi setiap pelanggan.",
                    style: TextStyle(
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- SECTION REVIEW REAL ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ulasan Pelanggan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(
                                salonId: salon.id ?? 0,
                                salonName: salon.name,
                              ),
                            ),
                          );
                        },
                        child: Text("Lihat Semua",
                            style: TextStyle(color: colorDeepRose)),
                      ),
                    ],
                  ),

                  // Menggunakan FutureBuilder untuk mengambil jumlah review real
                  FutureBuilder<List<Review>>(
                    future: ReviewService().getReviewsBySalon(salon.id ?? 0),
                    builder: (context, snapshot) {
                      int reviewCount = 0;
                      double averageRating = 0;

                      if (snapshot.hasData) {
                        reviewCount = snapshot.data!.length;
                        // Hitung rata-rata jika ada data
                        if (reviewCount > 0) {
                          double totalRating = 0;
                          for (var r in snapshot.data!) {
                            totalRating += r.rating;
                          }
                          averageRating = totalRating / reviewCount;
                        }
                      }

                      return Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 5),
                          Text(
                            averageRating == 0
                                ? "0.0"
                                : averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "($reviewCount Ulasan)",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2))
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingFormPage(
                    salonId: salon.id ?? 0,
                    salonName: salon.name,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorDeepRose,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: const Text(
              "BOOKING SEKARANG",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorRosePink, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}