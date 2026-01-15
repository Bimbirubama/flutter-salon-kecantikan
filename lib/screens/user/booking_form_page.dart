import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_kecantikan/models/booking_model.dart';
import 'package:salon_kecantikan/services/booking_service.dart'; // Import service Anda

class BookingFormPage extends StatefulWidget {
  final int salonId;
  final String salonName;

  const BookingFormPage({super.key, required this.salonId, required this.salonName});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final Color colorDeepRose = const Color(0xFFB55163);
  
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false; // Untuk indikator loading

  // Fungsi Pilih Tanggal
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Fungsi Pilih Waktu
  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // LOGIKA KIRIM DATA REAL
  void _submitBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      _showSnackBar("Pilih tanggal dan waktu terlebih dahulu");
      return;
    }

    setState(() => _isLoading = true);

    // Format Tanggal untuk Backend (Contoh: 2023-10-25 14:00)
    final String datePart = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final String timePart = "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";
    final String formattedDateTime = "$datePart $timePart";

    // Buat Objek Booking
    final newBooking = Booking(
      customerId: "User 1", // Idealnya diambil dari Session/Auth ID
      salonId: widget.salonId,
      bookingDate: formattedDateTime,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      status: 'pending',
    );

    // Panggil Service
    bool success = await BookingService.createBooking(newBooking);

    setState(() => _isLoading = false);

    if (success) {
      _showSuccessDialog();
    } else {
      _showSnackBar("Gagal membuat pesanan. Silakan coba lagi.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Berhasil!", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Pesanan Anda telah terkirim dan menunggu konfirmasi admin."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup Dialog
              Navigator.pop(context); // Kembali ke Detail Salon
            },
            child: Text("OK", style: TextStyle(color: colorDeepRose, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Form Booking", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: colorDeepRose,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pesan Layanan di:", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            Text(widget.salonName, 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorDeepRose)),
            const SizedBox(height: 30),
            
            // Pilih Tanggal
            _buildSelectionTile(
              label: _selectedDate == null 
                  ? "Pilih Tanggal" 
                  : DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate!),
              icon: Icons.calendar_month,
              onTap: _pickDate,
            ),
            
            const SizedBox(height: 15),

            // Pilih Waktu
            _buildSelectionTile(
              label: _selectedTime == null 
                  ? "Pilih Waktu" 
                  : _selectedTime!.format(context),
              icon: Icons.access_time,
              onTap: _pickTime,
            ),

            const SizedBox(height: 30),

            // Catatan
            const Text("Catatan untuk Salon (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Contoh: Ingin potong model layer...",
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorDeepRose,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("KONFIRMASI PESANAN", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile({required String label, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      tileColor: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: colorDeepRose.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: colorDeepRose),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}