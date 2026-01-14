import 'package:flutter/material.dart';
import '../../models/salon_model.dart';
import '../../widgets/custom_button.dart';

class SalonDetailPage extends StatelessWidget {
  final SalonModel salon;

  const SalonDetailPage({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(salon.name), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blueAccent.withOpacity(0.1),
              child: const Icon(Icons.image, size: 100, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(salon.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 5),
                      Text(salon.address, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Layanan Kami", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(salon.services),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Harga Estimasi", style: TextStyle(fontSize: 16)),
                      Text("Rp ${salon.price}", 
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CustomButton(text: "Booking Sekarang", onPressed: () {
                    // Logika Booking
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}