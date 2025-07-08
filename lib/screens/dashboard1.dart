import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/responsive_scaffold_body.dart';

class Dashboard1 extends StatelessWidget {
  const Dashboard1({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out successfully!')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ResponsiveScaffoldBody(
        child: _DashboardPanel(onLogout: () => _logout(context)),
        sideChild: Container(color: const Color(0xFFA3C64B)),
      ),
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  final VoidCallback onLogout;
  const _DashboardPanel({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? user?.email ?? "User";

    return Container(
      color: const Color(0xFFF5F3FF),
      child: Stack(
        children: [
          // "Hello username!" at top right, smaller, modern color
          Positioned(
            top: 16,
            right: 56,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Hello $username!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          // Logout button at very top right
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: onLogout,
              icon: const Icon(
                Icons.logout,
                color: Colors.deepPurple,
                size: 24,
              ),
              tooltip: 'Logout',
            ),
          ),
          // Add buttons and other widgets below as needed
        ],
      ),
    );
  }
}
