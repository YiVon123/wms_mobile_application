import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms_mobile_application/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'signup_page.dart';
import 'profile_page.dart';
import 'forgot_password_page.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final error = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _errorMessage = error;
    });

    if (error == null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),

              // 🔹 Replace FlutterLogo with Local Asset Logo
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: const AssetImage("assets/images/circle_wms_logo.jpg"),
                  backgroundColor: Colors.transparent,
                ),
              ),

              const SizedBox(height: 20),

              // Email Field
              CustomTextField(
                controller: _emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                validator: FieldValidator.validateEmail,
              ),

              // Password Field
              CustomTextField(
                controller: _passwordController,
                label: "Password",
                obscureText: true,
                validator: FieldValidator.validatePassword,
              ),

              // Unified Error Message
              ErrorMessage(message: _errorMessage),

              const SizedBox(height: 20),

              // Login Button
              authProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 16),

              // Sign Up Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text("Haven't created an account? Sign up"),
              ),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                  );
                },
                child: const Text("Forgot password?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
