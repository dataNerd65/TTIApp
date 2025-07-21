import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/responsive_scaffold_body.dart';
import '../screens/daily_scripture_page.dart';
import '../screens/prayer_checklist_page.dart';

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
      backgroundColor: const Color(0xFF1A1B2E),
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
    final username = user?.displayName ?? "Kiarie";

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF1A1B2E),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with greeting and settings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Hello $username!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onLogout,
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Streak',
                      '7 days',
                      Icons.local_fire_department,
                      const Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Modules',
                      '3/12',
                      Icons.school,
                      const Color(0xFF4285F4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bible Reading Progress
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2D44),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bible Reading Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0.68,
                            backgroundColor: const Color(0xFF1A1B2E),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4ECDC4),
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '68%',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButton(
                'Daily Scripture',
                'Today\'s verse and reflection',
                Icons.menu_book,
                const Color(0xFF4ECDC4),
                () {
                  // Navigate to Daily Scripture
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyScripturePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                'Prayer Checklist',
                'Track your prayer requests',
                Icons.favorite,
                const Color(0xFFE91E63),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrayerChecklistPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                'Read the Bible',
                'Continue your reading plan',
                Icons.book,
                const Color(0xFF4CAF50),
                () {
                  // Navigate to Bible Reading
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                'Accountability Check-ins',
                'Weekly accountability questions',
                Icons.group,
                const Color(0xFF9C27B0),
                () {
                  // Navigate to Accountability
                },
              ),
              const SizedBox(height: 12),

              _buildActionButton(
                'Discipleship Modules',
                'Grow in your faith journey',
                Icons.school,
                const Color(0xFFFF9800),
                () {
                  // Navigate to Discipleship
                },
              ),
              const SizedBox(height: 32),

              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF9C27B0),
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : 'K',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Growing in Faith',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2D44),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
