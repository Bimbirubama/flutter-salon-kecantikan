import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/salon_model.dart';
import 'package:salon_kecantikan/screens/user/salon_detail_page.dart';
import 'package:salon_kecantikan/screens/user/salon_list_page.dart';
import 'package:salon_kecantikan/screens/user/my_booking_page.dart';
import 'package:salon_kecantikan/screens/user/profile_page.dart'; // Import halaman profil
// Import halaman login Anda di sini
// import 'package:salon_kecantikan/screens/auth/login_page.dart'; 

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  // Warna Tema
  final Color colorPeach = const Color(0xFFE7AC98);
  final Color colorRosePink = const Color(0xFFDF8B92);
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorSoftPink = const Color(0xFFECCABF);
  final Color colorCream = const Color.fromRGBO(247, 230, 205, 1);

  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Data Master Dummy
  final List<Map<String, dynamic>> _allSalonsData = [
    {
      "id": 1,
      "name": "Glow Beauty Studio",
      "address": "Jl. Melati No. 12, Jakarta",
      "phone": "0812345678",
      "services": "Haircut, Facial, Cream Bath",
      "price": 150000.0,
      "image": "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop"
    },
    {
      "id": 3,
      "name": "Lavender Hair Care",
      "address": "Mall Grand Indonesia Lt. 3",
      "phone": "0877556677",
      "services": "Hair Coloring, Smoothing, Keratin",
      "price": 120000.0,
      "image": "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=1000&auto=format&fit=crop"
    },
  ];

  late List<SalonModel> _allSalons;
  List<SalonModel> _filteredSalons = [];

  @override
  void initState() {
    super.initState();
    _allSalons = _allSalonsData.map((data) => SalonModel.fromJson(data)).toList();
    _filteredSalons = _allSalons;
  }

  void _filterSalons(String query) {
    setState(() {
      _filteredSalons = _allSalons
          .where((salon) =>
              salon.name.toLowerCase().contains(query.toLowerCase()) ||
              salon.services.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      const SalonListPage(),
      const MyBookingPage(),
      const ProfilePage (),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 232, 232),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- WIDGET NAVIGATION ---
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: colorDeepRose,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: "List Salon"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  // --- TAB HOME ---
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 25),
          Center(child: _buildSectionTitle("Kategori Layanan")),
          const SizedBox(height: 20),
          _buildCategoryList(),
          const SizedBox(height: 30),
          _buildSectionTitle(_searchController.text.isEmpty ? "Rekomendasi Untukmu" : "Hasil Pencarian"),
          const SizedBox(height: 15),
          _buildSalonList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- HEADER DENGAN GRADASI ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorDeepRose, colorRosePink],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Halo, Cantik!", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text("Temukan Pesonamu", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: IconButton(
                  onPressed: () {
                    // LOGIKA LOGOUT: Kembali ke login dan hapus history route
                    // Ganti 'LoginPage' dengan nama class login Anda
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }, 
                  icon: const Icon(Icons.logout, color: Colors.white, size: 20)
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSalons,
              decoration: InputDecoration(
                hintText: "Cari salon atau treatment...",
                prefixIcon: Icon(Icons.search, color: colorDeepRose),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

 

  // --- KATEGORI DIPOSISIKAN DI TENGAH ---
  Widget _buildCategoryList() {
    final List<Map<String, dynamic>> categories = [
      {"name": "Rambut", "icon": Icons.content_cut, "color": colorCream},
      {"name": "Spa", "icon": Icons.spa, "color": colorSoftPink},
      {"name": "Makeup", "icon": Icons.brush, "color": colorPeach},
      {"name": "Kuku", "icon": Icons.back_hand, "color": colorRosePink.withOpacity(0.6)},
    ];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Membuat kategori di tengah
      children: categories.map((cat) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cat['color'],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                ),
                child: Icon(cat['icon'], color: colorDeepRose, size: 28),
              ),
              const SizedBox(height: 10),
              Text(cat['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSalonList() {
    return _filteredSalons.isEmpty
        ? const Center(child: Text("Opps, salon tidak ditemukan..."))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            itemCount: _filteredSalons.length,
            itemBuilder: (context, index) {
              return _buildSalonCard(_filteredSalons[index]);
            },
          );
  }

  Widget _buildSalonCard(SalonModel salon) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SalonDetailPage(salon: salon))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'salon-${salon.id}',
              child: Container(
                height: 135,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(_allSalonsData.firstWhere((element) => element['id'] == salon.id)['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(salon.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorDeepRose)),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(salon.address, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mulai dari", style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                          Text("Rp ${salon.price.toStringAsFixed(0)}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: colorDeepRose)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(color: colorDeepRose, borderRadius: BorderRadius.circular(15)),
                        child: const Text("Lihat Detail", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorDeepRose)),
    );
  }
}