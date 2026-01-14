import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // State untuk mengontrol sembunyi/tampil teks
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Jika ini adalah field password, mulai dengan kondisi tersembunyi
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB55163).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: widget.controller,
        // Gunakan state _obscureText di sini
        obscureText: _obscureText,
        style: const TextStyle(color: Color(0xFFB55163)),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Color(0xFFE7AC98), fontSize: 14),
          prefixIcon: Icon(widget.icon, color: const Color(0xFFDF8B92), size: 20),
          
          // Tambahkan tombol mata hanya jika widget.isPassword adalah true
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFFDF8B92),
                    size: 20,
                  ),
                  onPressed: () {
                    // Ubah state saat tombol diklik
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null, // Jika bukan password, jangan tampilkan apa-apa di kanan
          
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}