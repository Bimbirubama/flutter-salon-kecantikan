import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  // Warna Tema (Sesuai Gambar Anda)
  final Color colorCream = const Color(0xFFF7E6CD);
  final Color colorPeach = const Color(0xFFE7AC98);
  final Color colorSoftPink = const Color(0xFFECCABF);
  final Color colorRosePink = const Color(0xFFDF8B92);
  final Color colorDeepRose = const Color(0xFFB55163);

  // Data Dummy Kategori
  final List<Map<String, dynamic>> categories = [
    {"name": "Hair", "icon": Icons.content_cut_rounded},
    {"name": "Spa", "icon": Icons.spa_rounded},
    {"name": "Makeup", "icon": Icons.brush_rounded},
    {"name": "Nails", "icon": Icons.back_hand_rounded},
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorCream, colorSoftPink.withOpacity(0.5), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi, Beautiful!", 
                          style: TextStyle(color: colorDeepRose, fontSize: 16, fontWeight: FontWeight.w500)),
                        Text("Temukan Pesonamu", 
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: colorDeepRose)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: colorDeepRose.withOpacity(0.1), blurRadius: 10)],
                      ),
                      child: Icon(Icons.person_2_outlined, color: colorDeepRose),
                    )
                  ],
                ),
                
                const SizedBox(height: 25),
                // HERO BANNER
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(colors: [colorDeepRose, colorRosePink]),
                    boxShadow: [
                      BoxShadow(color: colorDeepRose.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20, bottom: -20,
                        child: Icon(Icons.auto_awesome, size: 150, color: Colors.white.withOpacity(0.2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Diskon Member 50%", 
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            const Text("Khusus untuk treatment Facial & Spa", 
                              style: TextStyle(color: Colors.white70, fontSize: 14)),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: Text("Ambil Promo", style: TextStyle(color: colorDeepRose, fontWeight: FontWeight.bold, fontSize: 12)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // KATEGORI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Layanan Kami", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorDeepRose)),
                    Text("Lihat Semua", style: TextStyle(color: colorRosePink, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: colorSoftPink),
                              ),
                              child: Icon(categories[index]['icon'] ?? Icons.spa, color: colorRosePink, size: 28),
                            ),
                            const SizedBox(height: 8),
                            Text(categories[index]['name'], style: TextStyle(fontSize: 12, color: colorDeepRose, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                // SALON LIST (DUMMY)
                Text("Rekomendasi Salon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorDeepRose)),
                const SizedBox(height: 15),
                _buildSalonCard("Glow Beauty Studio", "4.8", "Jl. Melati No. 12", "Rp 150rb", "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500"),
                _buildSalonCard("Rose Spa & Wellness", "4.9", "Sudirman Park", "Rp 250rb", "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colorDeepRose,
        unselectedItemColor: colorPeach,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Favorit"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildSalonCard(String name, String rating, String loc, String price, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: colorDeepRose.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(imgUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorDeepRose)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: colorRosePink),
                    const SizedBox(width: 5),
                    Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const Divider(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mulai dari", style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text(price, style: TextStyle(color: colorDeepRose, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorDeepRose,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("Booking", style: TextStyle(color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}