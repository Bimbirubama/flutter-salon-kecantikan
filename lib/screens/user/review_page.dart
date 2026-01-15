import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/review_model.dart'; // Pastikan nama file model benar
import 'package:salon_kecantikan/services/review_service.dart'; // Import service Anda

class ReviewPage extends StatefulWidget {
  final int salonId;
  final String salonName;

  const ReviewPage({super.key, required this.salonId, required this.salonName});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Theme Colors
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorRosePink = const Color(0xFFDF8B92);

  final ReviewService _reviewService = ReviewService();
  final _commentController = TextEditingController();
  
  int _selectedRating = 0;
  List<Review> _reviews = []; // Menggunakan class Review dari model Anda
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // Ambil data dari API saat pertama kali buka
  }

  // Fungsi untuk mengambil data ulasan dari server
  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final data = await _reviewService.getReviewsBySalon(widget.salonId);
      setState(() {
        _reviews = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Gagal memuat ulasan: $e");
    }
  }

  // Fungsi untuk mengirim ulasan baru ke server
  void _submitReview() async {
    if (_selectedRating == 0) {
      _showSnackBar("Silakan pilih rating bintang");
      return;
    }

    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Buat objek ulasan
    final newReview = Review(
      customerId: "User 1", // Idealnya diambil dari data login (Session/SharedPrefs)
      salonId: widget.salonId,
      rating: _selectedRating,
      comment: _commentController.text.isEmpty ? null : _commentController.text,
    );

    final success = await _reviewService.postReview(newReview);

    Navigator.pop(context); // Tutup loading dialog

    if (success) {
      _showSnackBar("Ulasan berhasil dikirim!");
      _commentController.clear();
      setState(() => _selectedRating = 0);
      _fetchReviews(); // Refresh daftar ulasan agar yang terbaru muncul
    } else {
      _showSnackBar("Gagal mengirim ulasan. Coba lagi.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ulasan ${widget.salonName}", 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: colorDeepRose,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. INPUT SECTION
          _buildInputSection(),

          const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

          // 2. LIST SECTION
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reviews.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _fetchReviews,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) => _buildReviewItem(_reviews[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Berikan ulasan Anda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          
          // Star Rating Input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => setState(() => _selectedRating = index + 1),
                icon: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 38,
                ),
              );
            }),
          ),
          
          const SizedBox(height: 10),
          
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Tulis pengalaman Anda di sini...",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorDeepRose,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("KIRIM ULASAN", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.customerId, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(review.createdAt?.substring(0, 10) ?? "", 
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            review.comment ?? "Tidak ada komentar.", 
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView( // Gunakan listview agar RefreshIndicator bekerja
      children: const [
        SizedBox(height: 100),
        Center(child: Text("Belum ada ulasan untuk salon ini.")),
      ],
    );
  }
}