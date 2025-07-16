import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/responsive_scaffold_body.dart';
import '../widgets/universal_button.dart';

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
    final username = user?.displayName ?? "User";

    return Stack(
      children: [
        // Light purple dashboard area (main content)
        Positioned.fill(
          child: Container(
            color: const Color(0xFFF5F3FF),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80), // Space for greeting/logout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: UniversalButton(
                        text: 'Daily Scripture',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                        width: double.infinity,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: UniversalButton(
                        text: 'Prayer Checklist',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                        width: double.infinity,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: UniversalButton(
                        text: 'Read the Bible',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                        width: double.infinity,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: UniversalButton(
                        text: 'Accountability Check-ins',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                        width: double.infinity,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: UniversalButton(
                        text: 'Discipleship Modules',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                        width: double.infinity,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 100), // Space for profile
                  ],
                ),
              ),
            ),
          ),
        ),
        // Greeting (upper left)
        Positioned(
          top: 24,
          left: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.deepPurple, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.waving_hand, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hello $username!',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Logout button (upper right)
        Positioned(
          top: 24,
          right: 24,
          child: IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, color: Colors.deepPurple, size: 28),
            tooltip: 'Logout',
          ),
        ),
        // Profile (lower left)
        Positioned(
          left: 24,
          bottom: 24,
          child: Tooltip(
            message: 'View profile',
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
