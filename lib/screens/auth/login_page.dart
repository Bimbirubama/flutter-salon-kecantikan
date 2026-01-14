import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7E6CD), // Krem
              Color(0xFFECCABF), // Soft Pink
              Color(0xFFE7AC98), // Peach
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // Logo Area (Modern Beauty Icon)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                    ),
                    child: const Icon(
                      Icons.auto_awesome, // Ikon kilauan (Beauty feel)
                      size: 60,
                      color: Color(0xFFB55163), // Rose Tua
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Glow & Grace",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB55163),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    "Your Beauty, Our Passion",
                    style: TextStyle(color: Color(0xFFB55163), fontSize: 14),
                  ),
                  const SizedBox(height: 40),

                  // Card Form
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          label: "Email Address",
                          icon: Icons.alternate_email,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_open_rounded,
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(color: Color(0xFFB55163))
                            : CustomButton(text: "Sign In", onPressed: handleLogin),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: RichText(
                      text: const TextSpan(
                        text: "New here? ",
                        style: TextStyle(color: Color(0xFFB55163)),
                        children: [
                          TextSpan(
                            text: "Create Account",
                            style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleLogin() async {
  setState(() => _isLoading = true);

  final result = await AuthService()
      .login(_emailController.text, _passwordController.text);

  setState(() => _isLoading = false);

  if (result['success'] == true) {
    final role = result['data']['role'];

    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/user-dashboard');
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Login gagal'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

}