import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/review_model.dart';
import 'package:salon_kecantikan/services/review_service.dart';

class ManageReviewPage extends StatefulWidget {
  const ManageReviewPage({super.key});

  @override
  State<ManageReviewPage> createState() => _ManageReviewPageState();
}

class _ManageReviewPageState extends State<ManageReviewPage> {
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorRosePink = const Color(0xFFDF8B92);
  final ReviewService _reviewService = ReviewService();
  
  List<Review> _allReviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminReviews();
  }

  // Ambil semua data review dari server
  Future<void> _fetchAdminReviews() async {
    setState(() => _isLoading = true);
    try {
      final data = await _reviewService.getAllReviews();
      setState(() {
        _allReviews = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Error: $e");
    }
  }

  // Fungsi Moderasi (Hapus Review)
  void _handleDeleteReview(int id) async {
    bool confirm = await _showConfirmDialog();
    if (!confirm) return;

    final success = await _reviewService.deleteReview(id);
    if (success) {
      _showSnackBar("Review berhasil dihapus");
      _fetchAdminReviews(); // Refresh data
    } else {
      _showSnackBar("Gagal menghapus review");
    }
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah anda yakin ingin menghapus ulasan ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("Hapus", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Moderasi Review", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: colorDeepRose,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchAdminReviews),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allReviews.isEmpty
              ? const Center(child: Text("Tidak ada ulasan masuk."))
              : RefreshIndicator(
                  onRefresh: _fetchAdminReviews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _allReviews.length,
                    itemBuilder: (context, index) {
                      final review = _allReviews[index];
                      return _buildAdminReviewCard(review);
                    },
                  ),
                ),
    );
  }

  Widget _buildAdminReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorRosePink.withOpacity(0.2),
                    child: Text(review.customerId[0].toUpperCase(), 
                        style: TextStyle(color: colorDeepRose, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.customerId, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text("Salon ID: ${review.salonId}", 
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _handleDeleteReview(review.id!),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment ?? "Tidak ada ulasan teks.",
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              review.createdAt?.substring(0, 10) ?? "",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}