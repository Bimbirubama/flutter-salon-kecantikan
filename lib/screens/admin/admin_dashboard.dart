import 'package:flutter/material.dart';
import 'package:salon_kecantikan/screens/admin/manage_booking_page.dart';
import 'package:salon_kecantikan/screens/admin/manage_review_page.dart';
import 'package:salon_kecantikan/screens/admin/manage_salon_page.dart';
import 'package:salon_kecantikan/screens/auth/login_page.dart';
import 'package:salon_kecantikan/services/review_service.dart';
// Import Service Anda
import 'package:salon_kecantikan/services/salon_service.dart';
import 'package:salon_kecantikan/services/booking_service.dart';
// import 'package:salon_kecantikan/services/review_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  /// THEME COLORS
  final Color colorPeach = const Color(0xFFE7AC98);
  final Color colorRosePink = const Color(0xFFDF8B92);
  final Color colorDeepRose = const Color(0xFFB55163);

  // Variabel untuk menyimpan jumlah data real
  int _salonCount = 0;
  int _bookingCount = 0;
  int _reviewCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData(); // Ambil data real saat init
  }

  /// FUNGSI UNTUK MENGAMBIL DATA REAL DARI DATABASE
Future<void> _refreshData() async {
  if (!mounted) return;
  setState(() => _isLoading = true);

  try {
    // Ambil data secara bersamaan (Parallel) untuk performa lebih cepat
    final results = await Future.wait([
      SalonService.getSalons(),
      BookingService.getBookings(),
      ReviewService().getAllReviews(), // Memanggil fungsi yang baru dibuat
    ]);

    // results[0] adalah data Salon
    // results[1] adalah data Booking
    // results[2] adalah data Review
    final salons = results[0] as List;
    final bookings = results[1] as List;
    final reviews = results[2] as List;

    if (mounted) {
      setState(() {
        _salonCount = salons.length;
        _bookingCount = bookings.length;
        _reviewCount = reviews.length; // Sekarang real dari database
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() => _isLoading = false);
      debugPrint("Error Dashboard Real Data: $e");
      
      // Opsional: Tampilkan snackbar jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui statistik: $e")),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Panel", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: colorDeepRose,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData, // Tombol untuk refresh data manual
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. WELCOME SECTION & STATS (REAL DATA)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
                decoration: BoxDecoration(
                  color: colorDeepRose,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Halo, Administrator",
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 5),
                    const Text("Ringkasan Bisnis Hari Ini",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    
                    // Statistik Real
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard("Salon", _salonCount.toString(), Icons.storefront),
                        _buildStatCard("Booking", _bookingCount.toString(), Icons.calendar_today),
                        _buildStatCard("Review", _reviewCount.toString(), Icons.rate_review),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 2. MAIN MENU (MANAJEMEN)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Manajemen Data",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorDeepRose)),
                    const SizedBox(height: 15),
                    
                    _buildMenuTile(
                      "Kelola Salon", 
                      "Tambah, Edit, atau Hapus daftar salon", 
                      Icons.store, 
                      colorRosePink,
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageSalonPage()))
                            .then((_) => _refreshData()); // Refresh saat kembali
                      }
                    ),
                    _buildMenuTile(
                      "Daftar Pesanan (Booking)", 
                      "Lihat dan konfirmasi janji temu", 
                      Icons.assignment, 
                      colorPeach,
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBookingPage()))
                            .then((_) => _refreshData()); // Refresh saat kembali
                      }
                    ),
                    _buildMenuTile(
                      "Moderasi Review", 
                      "Pantau feedback dari pelanggan", 
                      Icons.comment, 
                      colorDeepRose,
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageReviewPage()))
                            .then((_) => _refreshData()); // Refresh saat kembali
                      }
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 3. INFO
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Petunjuk",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Data diperbarui secara otomatis dari database.", style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// WIDGET UNTUK KOTAK STATISTIK (Dinamis & Loading Friendly)
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                value, 
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
              ),
          Text(
            label, 
            style: const TextStyle(color: Colors.white70, fontSize: 12)
          ),
        ],
      ),
    );
  }

  /// WIDGET UNTUK MENU LIST
  Widget _buildMenuTile(String title, String subtitle, IconData icon, Color iconBg, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconBg),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colorDeepRose)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}