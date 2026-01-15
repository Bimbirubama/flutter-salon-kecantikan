import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Tema Warna (Sesuai dengan dashboard Anda)
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorRosePink = const Color(0xFFDF8B92);
  final Color colorPeach = const Color(0xFFE7AC98);

  @override
  Widget build(BuildContext context) {
    // Simulasi Data User Real yang Login
    // Di aplikasi nyata, data ini diambil dari Provider/Auth Service
    final Map<String, String> userData = {
      "name": "Siska Amelia",
      "username": "siska_beauty",
      "email": "siska.amelia@email.com",
    };

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 232, 232),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil
            _buildProfileHeader(userData),
            
            const SizedBox(height: 20),
            
            // Info Akun Section
            _buildInfoSection(userData),
            
            const SizedBox(height: 20),
            
            // Riwayat Booking Ringkas
            _buildBookingHistoryPreview(),
            
            const SizedBox(height: 30),
            
            // Tombol Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Keluar dari Akun"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorDeepRose,
                    side: BorderSide(color: colorDeepRose),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, String> user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 40),
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
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            user["name"]!,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            "@${user["username"]}",
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, String> user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildInfoTile(Icons.email_outlined, "Email", user["email"]!),
          const Divider(),
          _buildInfoTile(Icons.verified_user_outlined, "Username", user["username"]!),
          const Divider(),
          _buildInfoTile(Icons.phone_android_outlined, "Telepon", "+62 812 3456 7890"),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: colorDeepRose),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBookingHistoryPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Booking Terakhir",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: colorPeach.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.cut, color: colorDeepRose),
            ),
            title: const Text("Glow Beauty Studio", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("24 Okt 2023 - Selesai"),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }
}