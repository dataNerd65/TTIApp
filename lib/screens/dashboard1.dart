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

    return Container(
      color: const Color(0xFFF5F3FF),
      child: Stack(
        children: [
          // Main content column
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Greeting at top left
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.waving_hand,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Hello $username!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          // Logout button at top right
                          IconButton(
                            onPressed: onLogout,
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.deepPurple,
                              size: 24,
                            ),
                            tooltip: 'Logout',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    UniversalButton(
                      text: 'Daily Scipture',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      width: double.infinity,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    UniversalButton(
                      text: 'Prayer Checklist',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      width: double.infinity,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    UniversalButton(
                      text: 'Read the Bible',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      width: double.infinity,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    UniversalButton(
                      text: 'Accountability Check-ins',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      width: double.infinity,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    UniversalButton(
                      text: 'Discipleship Modules',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      width: double.infinity,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Leave space for profile at the bottom
              const SizedBox(height: 70),
            ],
          ),
          // Profile section at bottom left
          Positioned(
            left: 24,
            bottom: 24,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
