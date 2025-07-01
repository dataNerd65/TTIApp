import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _SignUpPanel(),
                  ),
                  Container(height: 200, color: const Color(0xFFA3C64B)),
                ],
              ),
            );
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    color: Colors.white,
                    child: _SignUpPanel(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFA3C64B),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _SignUpPanel extends StatefulWidget {
  @override
  State<_SignUpPanel> createState() => _SignUpPanelState();
}

class _SignUpPanelState extends State<_SignUpPanel> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid(String password) {
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\d)(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
    );
    return regex.hasMatch(password);
  }

  Future<void> _signUp() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      setState(() => _isLoading = false);
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      setState(() => _isLoading = false);
      return;
    }
    if (!_isPasswordValid(password)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Weak Password')));
      setState(() => _isLoading = false);
      return;
    }
    try {
      final usernameQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .limit(1)
              .get();

      if (usernameQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Username already taken')));
        setState(() => _isLoading = false);
        return;
      }
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': email, 'username': username});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')),
      );
      Future.microtask(() {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });

      return;
    } on FirebaseAuthException catch (e) {
      String msg = 'Sign up failed!';
      if (e.code == 'email-already-in-use') {
        msg = 'Email already in use';
      } else if (e.code == 'invalid-email') {
        msg = 'Invalid email address';
      } else if (e.code == 'weak-password') {
        msg = 'Password is too weak';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occured. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/logo.png', height: 100),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'SIGN UP',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 24),
        RoundedTextField(
          icon: Icons.person,
          label: 'Username',
          controller: _usernameController,
        ),
        const SizedBox(height: 16),
        RoundedTextField(
          icon: Icons.email,
          label: 'Email',
          controller: _emailController,
        ),
        const SizedBox(height: 16),
        RoundedTextField(
          icon: Icons.lock,
          label: 'Password',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        RoundedTextField(
          icon: Icons.lock,
          label: 'Confirm Password',
          controller: _confirmPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B4FFF),
              foregroundColor: Colors.white,
              minimumSize: const Size(160, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: Colors.deepPurpleAccent,
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _SocialSignUpButtons(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account? ",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                "Go back to login.",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const RoundedTextField({
    required this.icon,
    required this.label,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F3FF),
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _SocialSignUpButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SocialLink(
          asset: 'assets/google.svg',
          text: 'Sign up with Google',
          onTap: () {
            // TODO: Implement Google sign up logic
          },
        ),
        const SizedBox(height: 10),
        _SocialLink(
          asset: 'assets/microsoft.svg',
          text: 'Sign up with Microsoft',
          onTap: () {
            // TODO: Implement Microsoft sign up logic
          },
        ),
        const SizedBox(height: 10),
        _SocialLink(
          asset: 'assets/apple.svg',
          text: 'Sign up with Apple',
          onTap: () {
            // TODO: Implement Apple sign up logic
          },
        ),
      ],
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String asset;
  final String text;
  final VoidCallback onTap;

  const _SocialLink({
    required this.asset,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(asset, height: 24, width: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
