import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/booking_model.dart';
import 'package:salon_kecantikan/services/booking_service.dart';

class ManageBookingPage extends StatefulWidget {
  const ManageBookingPage({super.key});

  @override
  State<ManageBookingPage> createState() => _ManageBookingPageState();
}

class _ManageBookingPageState extends State<ManageBookingPage> {
  /// THEME COLORS
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorPeach = const Color(0xFFE7AC98);

  late Future<List<Booking>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Fungsi untuk mengambil data terbaru dari API
  void _refreshData() {
    setState(() {
      _bookingFuture = BookingService.getBookings();
    });
  }

  // Fungsi Update Status Real ke API
  void _updateStatusReal(Booking booking, String newStatus) async {
    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Buat objek booking dengan status baru
    final updatedBooking = Booking(
      id: booking.id,
      customerId: booking.customerId,
      salonId: booking.salonId,
      bookingDate: booking.bookingDate,
      status: newStatus,
      notes: booking.notes,
    );

    bool success = await BookingService.updateBooking(booking.id!, updatedBooking);

    Navigator.pop(context); // Tutup loading dialog

    if (success) {
      _refreshData(); // Ambil data terbaru jika berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pesanan berhasil di-${newStatus.replaceAll('ed', '')}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui status")),
      );
    }
  }

  /// HELPER UNTUK WARNA STATUS
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'completed': return Colors.blue;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text("Manajemen Booking", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: colorDeepRose,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshData,
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Semua Pesanan"),
            ],
          ),
        ),
        body: FutureBuilder<List<Booking>>(
          future: _bookingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada pesanan ditemukan."));
            }

            final allBookings = snapshot.data!;

            return TabBarView(
              children: [
                _buildBookingList(allBookings.where((b) => b.status == 'pending').toList()),
                _buildBookingList(allBookings),
              ],
            );
          },
        ),
      ),
    );
  }

  /// WIDGET LIST BUILDER
  Widget _buildBookingList(List<Booking> list) {
    if (list.isEmpty) {
      return const Center(child: Text("Kosong."));
    }

    return RefreshIndicator(
      onRefresh: () async => _refreshData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(list[index]);
        },
      ),
    );
  }

  /// WIDGET CARD ITEM BOOKING
  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: CircleAvatar(
              backgroundColor: colorPeach.withOpacity(0.3),
              child: Icon(Icons.calendar_month, color: colorDeepRose),
            ),
            title: Text(booking.customerId, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text("📅 Jadwal: ${booking.bookingDate}"),
                Text("🏠 Salon ID: ${booking.salonId}"),
                if (booking.notes != null && booking.notes!.isNotEmpty) 
                  Text("📝 Catatan: ${booking.notes}", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                booking.status.toUpperCase(),
                style: TextStyle(color: _getStatusColor(booking.status), fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ),

          // TAMPILKAN TOMBOL AKSI BERDASARKAN STATUS
          if (booking.status == 'pending')
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => _updateStatusReal(booking, 'cancelled'),
                      child: const Text("Tolak"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => _updateStatusReal(booking, 'confirmed'),
                      child: const Text("Konfirmasi", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          
          if (booking.status == 'confirmed')
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: colorDeepRose),
                  onPressed: () => _updateStatusReal(booking, 'completed'),
                  child: const Text("Tandai Selesai", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}