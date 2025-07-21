import 'package:flutter/material.dart';
import 'dart:math';

class PrayerChecklistPage extends StatefulWidget {
  const PrayerChecklistPage({super.key});

  @override
  State<PrayerChecklistPage> createState() => _PrayerChecklistPageState();
}

class _PrayerChecklistPageState extends State<PrayerChecklistPage> {
  final TextEditingController _prayerController = TextEditingController();
  String _selectedCategory = 'Family';
  List<Prayer> _prayers = [];
  int _completedToday = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialPrayers();
  }

  void _loadInitialPrayers() {
    _prayers = [
      Prayer(
        id: '1',
        text: 'nn',
        category: 'Family',
        dateAdded: DateTime(2025, 1, 21),
        isCompleted: false,
      ),
      Prayer(
        id: '2',
        text: 'Wisdom for important decisions at work',
        category: 'Personal',
        dateAdded: DateTime(2025, 1, 18),
        isCompleted: false,
      ),
      Prayer(
        id: '3',
        text: 'Healing for Mom\'s recovery',
        category: 'Family',
        dateAdded: DateTime(2025, 1, 17),
        isCompleted: false,
      ),
      Prayer(
        id: '4',
        text: 'Peace in our community',
        category: 'Community',
        dateAdded: DateTime(2025, 1, 16),
        isCompleted: false,
      ),
      Prayer(
        id: '5',
        text: 'End to hunger and poverty worldwide',
        category: 'World',
        dateAdded: DateTime(2025, 1, 15),
        isCompleted: false,
      ),
    ];
  }

  void _addPrayer() {
    if (_prayerController.text.trim().isEmpty) return;

    final newPrayer = Prayer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _prayerController.text.trim(),
      category: _selectedCategory,
      dateAdded: DateTime.now(),
      isCompleted: false,
    );

    setState(() {
      _prayers.insert(0, newPrayer);
      _prayerController.clear();
    });
  }

  void _togglePrayer(String id) {
    setState(() {
      final index = _prayers.indexWhere((prayer) => prayer.id == id);
      if (index != -1) {
        _prayers[index].isCompleted = !_prayers[index].isCompleted;
        if (_prayers[index].isCompleted) {
          _completedToday++;
        } else {
          _completedToday--;
        }
      }
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Personal':
        return const Color(0xFF4285F4);
      case 'Family':
        return const Color(0xFFE91E63);
      case 'Community':
        return const Color(0xFF9C27B0);
      case 'World':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF4ECDC4);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Personal':
        return Icons.person;
      case 'Family':
        return Icons.favorite;
      case 'Community':
        return Icons.group;
      case 'World':
        return Icons.public;
      default:
        return Icons.circle;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrayers = _prayers.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prayer Checklist',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '0 of 5 completed today',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8E44AD), Color(0xFFE91E63)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Progress',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Keep praying consistently',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Prayers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$_completedToday/$totalPrayers',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Add New Prayer Request
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
                            'Add New Prayer Request',
                            style: TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Category Selection
                          Row(
                            children: [
                              _buildCategoryButton('Personal', Icons.person),
                              const SizedBox(width: 8),
                              _buildCategoryButton('Family', Icons.favorite),
                              const SizedBox(width: 8),
                              _buildCategoryButton('Community', Icons.group),
                              const SizedBox(width: 8),
                              _buildCategoryButton('World', Icons.public),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Prayer Input
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _prayerController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your prayer request...',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (_) => _addPrayer(),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4ECDC4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: _addPrayer,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Your Prayers Section
                    const Text(
                      'Your Prayers',
                      style: TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Prayer List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _prayers.length,
                      itemBuilder: (context, index) {
                        final prayer = _prayers[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2D44),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Checkbox
                              GestureDetector(
                                onTap: () => _togglePrayer(prayer.id),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color:
                                        prayer.isCompleted
                                            ? const Color(0xFF4ECDC4)
                                            : Colors.transparent,
                                    border: Border.all(
                                      color:
                                          prayer.isCompleted
                                              ? const Color(0xFF4ECDC4)
                                              : Colors.white30,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child:
                                      prayer.isCompleted
                                          ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Prayer Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prayer.text,
                                      style: TextStyle(
                                        color:
                                            prayer.isCompleted
                                                ? Colors.white54
                                                : Colors.white,
                                        fontSize: 14,
                                        decoration:
                                            prayer.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getCategoryColor(
                                              prayer.category,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getCategoryIcon(
                                                  prayer.category,
                                                ),
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                prayer.category,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatDate(prayer.dateAdded),
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? _getCategoryColor(category) : Colors.transparent,
            border: Border.all(
              color: isSelected ? _getCategoryColor(category) : Colors.white30,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _prayerController.dispose();
    super.dispose();
  }
}

// Prayer Model
class Prayer {
  final String id;
  final String text;
  final String category;
  final DateTime dateAdded;
  bool isCompleted;

  Prayer({
    required this.id,
    required this.text,
    required this.category,
    required this.dateAdded,
    required this.isCompleted,
  });
}
