import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State untuk menyimpan pilihan Role
  String _selectedRole = 'user'; 
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFFF7E6CD),
              Color(0xFFECCABF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFB55163)),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Join Us,",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFFB55163)),
                ),
                const Text(
                  "Let's start your beauty journey",
                  style: TextStyle(fontSize: 16, color: Color(0xFFB55163)),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(controller: _nameController, label: "Full Name", icon: Icons.person_outline),
                      const SizedBox(height: 15),
                      CustomTextField(controller: _emailController, label: "Email Address", icon: Icons.email_outlined),
                      const SizedBox(height: 15),
                      
                      // DROPDOWN ROLE (Pengganti Phone)
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text("Select Role", style: TextStyle(color: Color(0xFFB55163), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRole,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFDF8B92)),
                            style: const TextStyle(color: Color(0xFFB55163), fontSize: 16),
                            items: const [
                              DropdownMenuItem(value: 'user', child: Text("Customer / User")),
                              DropdownMenuItem(value: 'admin', child: Text("Admin")),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 15),
                      CustomTextField(controller: _addressController, label: "Address", icon: Icons.map_outlined),
                      const SizedBox(height: 15),
                      CustomTextField(controller: _passwordController, label: "Secure Password", icon: Icons.lock_outline, isPassword: true),
                      const SizedBox(height: 35),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB55163)))
                          : CustomButton(text: "Register Now", onPressed: handleRegister),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleRegister() async {
    // Validasi sederhana
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password must be at least 6 characters")));
      return;
    }

    setState(() => _isLoading = true);

    UserModel newUser = UserModel(
      name: _nameController.text,
      email: _emailController.text,
      role: _selectedRole, // Menggunakan nilai dari Dropdown
      address: _addressController.text,
      password: _passwordController.text,
    );

    final result = await AuthService().register(newUser);

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account Created! Please Login"), backgroundColor: Color(0xFFB55163)),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Registration Failed"), backgroundColor: Colors.red),
      );
    }
  }
}