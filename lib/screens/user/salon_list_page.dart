import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/salon_model.dart';
import 'package:salon_kecantikan/screens/user/salon_detail_page.dart';
import 'package:salon_kecantikan/services/salon_service.dart';

class SalonListPage extends StatefulWidget {
  const SalonListPage({super.key});

  @override
  State<SalonListPage> createState() => _SalonListPageState();
}

class _SalonListPageState extends State<SalonListPage> {
  // THEME COLORS
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorRosePink = const Color(0xFFDF8B92);
  final Color colorPeach = const Color(0xFFE7AC98);

  late Future<List<SalonModel>> _futureSalons;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureSalons = SalonService.getSalons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F7), // Background putih kemerahan tipis
      appBar: AppBar(
        title: const Text(
          "Pilih Salon Favorit",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: colorDeepRose,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        color: colorDeepRose,
        child: FutureBuilder<List<SalonModel>>(
          future: _futureSalons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada data salon."));
            }

            final salons = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: salons.length,
              itemBuilder: (context, index) {
                final salon = salons[index];
                
                // Menambahkan Animasi Muncul Satu Per Satu
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + (index * 150)),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildSalonCard(salon),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSalonCard(SalonModel salon) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SalonDetailPage(salon: salon)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorDeepRose.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            // SISI KIRI: Ikon Salon (Pengganti Gambar)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorPeach.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.storefront_rounded, color: colorDeepRose, size: 40),
            ),
            const SizedBox(width: 15),

            // SISI KANAN: Informasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorDeepRose,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          salon.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp ${salon.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorDeepRose,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Pesan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: colorDeepRose),
          const SizedBox(height: 10),
          const Text("Gagal memuat data"),
          TextButton(onPressed: _loadData, child: const Text("Coba Lagi")),
        ],
      ),
    );
  }
}