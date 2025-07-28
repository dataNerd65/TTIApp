import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';

class AccountabilityPage extends StatefulWidget {
  const AccountabilityPage({super.key});

  @override
  State<AccountabilityPage> createState() => _AccountabilityPageState();
}

class _AccountabilityPageState extends State<AccountabilityPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Spiritual Growth Tab
  List<AccountabilityQuestion> _spiritualQuestions = [];
  Map<int, String> _spiritualAnswers = {};
  int _completedSpiritual = 0;

  // Sin Accountability Tab
  List<SinAccountability> _sinStruggles = [];
  Map<String, int> _streakData = {};
  String _selectedStruggle = '';

  // Salvation & AI Support
  String _aiGuidance = '';
  List<String> _salvationQuestions = [];
  Map<int, bool> _salvationAnswers = {};

  // Accountability Partners
  List<AccountabilityPartner> _partners = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    _loadSinAccountabilityData();
    _loadSalvationQuestions();
    _loadAccountabilityPartners();
    _generateSpiritualQuestions();
  }

  void _loadSinAccountabilityData() {
    _sinStruggles = [
      SinAccountability(
        id: 'porn',
        name: 'Pornography',
        icon: Icons.visibility_off,
        color: const Color(0xFFE91E63),
        currentStreak: 5,
        longestStreak: 21,
        lastSlip: DateTime.now().subtract(const Duration(days: 5)),
      ),
      SinAccountability(
        id: 'drugs',
        name: 'Substance Use',
        icon: Icons.local_pharmacy,
        color: const Color(0xFFFF5722),
        currentStreak: 12,
        longestStreak: 45,
        lastSlip: DateTime.now().subtract(const Duration(days: 12)),
      ),
      SinAccountability(
        id: 'anger',
        name: 'Anger/Rage',
        icon: Icons.flash_on,
        color: const Color(0xFFF44336),
        currentStreak: 3,
        longestStreak: 15,
        lastSlip: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SinAccountability(
        id: 'gossip',
        name: 'Gossip/Slander',
        icon: Icons.record_voice_over,
        color: const Color(0xFF9C27B0),
        currentStreak: 8,
        longestStreak: 30,
        lastSlip: DateTime.now().subtract(const Duration(days: 8)),
      ),
      SinAccountability(
        id: 'lying',
        name: 'Lying/Deception',
        icon: Icons.person_off,
        color: const Color(0xFF795548),
        currentStreak: 1,
        longestStreak: 10,
        lastSlip: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _loadSalvationQuestions() {
    _salvationQuestions = [
      "Do you believe that Jesus Christ is the Son of God?",
      "Have you acknowledged your need for a Savior?",
      "Do you believe Jesus died for your sins and rose again?",
      "Have you invited Jesus to be Lord of your life?",
      "Are you trusting in Jesus alone for your salvation?",
    ];
  }

  void _loadAccountabilityPartners() {
    _partners = [
      AccountabilityPartner(
        id: '1',
        name: 'Pastor Mike',
        role: 'Mentor',
        lastContact: DateTime.now().subtract(const Duration(days: 2)),
        strugglesShared: ['porn', 'anger'],
        isOnline: true,
      ),
      AccountabilityPartner(
        id: '2',
        name: 'David (Recovery Buddy)',
        role: 'Peer Support',
        lastContact: DateTime.now().subtract(const Duration(hours: 6)),
        strugglesShared: ['drugs'],
        isOnline: true,
      ),
      AccountabilityPartner(
        id: '3',
        name: 'Sarah (Accountability Sister)',
        role: 'Spiritual Support',
        lastContact: DateTime.now().subtract(const Duration(days: 1)),
        strugglesShared: ['gossip'],
        isOnline: false,
      ),
    ];
  }

  Future<void> _generateSpiritualQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        _setFallbackSpiritualQuestions();
        return;
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final prompt = '''
Generate 5 accountability questions for someone struggling with sin and seeking spiritual growth.

Focus on:
- Honest self-reflection about sinful behaviors
- Progress in overcoming temptation
- Spiritual disciplines (prayer, Bible study)
- Reliance on God's grace and strength
- Accountability to others

Format each question exactly like this:
QUESTION: [question_text]

Make questions direct, helpful for accountability, and grace-focused rather than condemning.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        _parseSpiritualQuestions(response.text!);
      } else {
        _setFallbackSpiritualQuestions();
      }
    } catch (e) {
      print('Error generating spiritual questions: $e');
      _setFallbackSpiritualQuestions();
    }
  }

  void _parseSpiritualQuestions(String response) {
    final questions = <AccountabilityQuestion>[];
    final lines = response.split('\n');

    for (String line in lines) {
      if (line.trim().toUpperCase().startsWith('QUESTION:')) {
        final questionText = line.substring(9).trim();
        if (questionText.isNotEmpty) {
          questions.add(
            AccountabilityQuestion(
              id: questions.length + 1,
              question: questionText,
              type: 'accountability',
              isAnswered: false,
            ),
          );
        }
      }
    }

    setState(() {
      _spiritualQuestions = questions.take(5).toList();
      _isLoading = false;
    });

    if (_spiritualQuestions.isEmpty) {
      _setFallbackSpiritualQuestions();
    }
  }

  void _setFallbackSpiritualQuestions() {
    _spiritualQuestions = [
      AccountabilityQuestion(
        id: 1,
        question:
            "What specific temptations did you face this week, and how did you respond?",
        type: "accountability",
        isAnswered: false,
      ),
      AccountabilityQuestion(
        id: 2,
        question:
            "How are you actively pursuing purity in your thoughts and actions?",
        type: "accountability",
        isAnswered: false,
      ),
      AccountabilityQuestion(
        id: 3,
        question:
            "What Scripture verses or prayers helped you resist temptation this week?",
        type: "accountability",
        isAnswered: false,
      ),
      AccountabilityQuestion(
        id: 4,
        question:
            "Have you been honest with your accountability partner about your struggles?",
        type: "accountability",
        isAnswered: false,
      ),
      AccountabilityQuestion(
        id: 5,
        question:
            "How have you experienced God's grace and forgiveness in your failures?",
        type: "accountability",
        isAnswered: false,
      ),
    ];

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _generateAIGuidance(String struggle, int streak) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        _setFallbackGuidance(struggle);
        return;
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final prompt = '''
Provide encouraging, biblical guidance for someone struggling with $struggle.

Current streak: $streak days

Please provide:
1. Encouraging words about their progress
2. A relevant Bible verse with explanation
3. Practical next steps for continued victory
4. Reminder of God's grace and forgiveness

Keep the tone hopeful, grace-filled, and Christ-centered. Focus on identity in Christ and the power of the Gospel.
Format as 2-3 encouraging paragraphs.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _aiGuidance = response.text ?? _getFallbackGuidance(struggle);
        _isLoading = false;
      });
    } catch (e) {
      print('Error generating AI guidance: $e');
      _setFallbackGuidance(struggle);
    }
  }

  void _setFallbackGuidance(String struggle) {
    setState(() {
      _aiGuidance = _getFallbackGuidance(struggle);
      _isLoading = false;
    });
  }

  String _getFallbackGuidance(String struggle) {
    return "God sees your heart and your desire to overcome this struggle. Every day of victory is a testament to His strength working in you, not your own willpower.\n\nRemember that 'No temptation has overtaken you except what is common to mankind. And God is faithful; he will not let you be tempted beyond what you can bear' (1 Corinthians 10:13). His grace is sufficient for you.\n\nStay connected to your accountability partners, keep filling your mind with Scripture, and remember that your identity is not defined by your struggles but by Christ's love for you.";
  }

  void _reportSlip(String struggleId) {
    setState(() {
      final struggle = _sinStruggles.firstWhere((s) => s.id == struggleId);
      struggle.currentStreak = 0;
      struggle.lastSlip = DateTime.now();

      _generateAIGuidance(struggle.name, 0);
    });

    _notifyAccountabilityPartners(struggleId);
  }

  void _notifyAccountabilityPartners(String struggleId) {
    // In a real app, this would send notifications to partners
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accountability partners have been notified'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const Expanded(
                    child: Text(
                      'Accountability Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _generateSpiritualQuestions(),
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2D44),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF4ECDC4),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Sin\nAccountability'),
                  Tab(text: 'Spiritual\nGrowth'),
                  Tab(text: 'Salvation\nCheck'),
                  Tab(text: 'Partners'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSinAccountabilityTab(),
                  _buildSpiritualGrowthTab(),
                  _buildSalvationTab(),
                  _buildPartnersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinAccountabilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Overall Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Victory Streaks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Walking in freedom through Christ',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Struggles',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${_sinStruggles.length}',
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

          // Struggle Cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sinStruggles.length,
            itemBuilder: (context, index) {
              final struggle = _sinStruggles[index];
              return _buildStruggleCard(struggle);
            },
          ),

          // AI Guidance Section
          if (_aiGuidance.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2D44),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF4ECDC4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        color: Color(0xFF4ECDC4),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'AI Spiritual Guidance',
                        style: TextStyle(
                          color: Color(0xFF4ECDC4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _aiGuidance,
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),
                ],
              ),
            ),
          ],

          // Emergency Support Button
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showEmergencySupport(),
            icon: const Icon(Icons.sos, color: Colors.white),
            label: const Text(
              'I Need Help Right Now',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStruggleCard(SinAccountability struggle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2D44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: struggle.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(struggle.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      struggle.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Current streak: ${struggle.currentStreak} days',
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
          const SizedBox(height: 16),

          // Streak Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Current',
                  '${struggle.currentStreak}',
                  'days',
                  const Color(0xFF4ECDC4),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Record',
                  '${struggle.longestStreak}',
                  'days',
                  const Color(0xFF4CAF50),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Last Slip',
                  '${DateTime.now().difference(struggle.lastSlip).inDays}',
                  'days ago',
                  Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => _generateAIGuidance(
                        struggle.name,
                        struggle.currentStreak,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Guidance',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _reportSlip(struggle.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Report Slip',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(unit, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  Widget _buildSpiritualGrowthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spiritual Growth Check-in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Growing in grace and truth',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Completed',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '$_completedSpiritual/${_spiritualQuestions.length}',
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

          // Questions
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _spiritualQuestions.length,
              itemBuilder: (context, index) {
                final question = _spiritualQuestions[index];
                return _buildQuestionCard(question);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(AccountabilityQuestion question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2D44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question.question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle:
            question.isAnswered
                ? const Text(
                  'Answered ✓',
                  style: TextStyle(color: Color(0xFF4ECDC4), fontSize: 12),
                )
                : const Text(
                  'Tap to answer',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
        backgroundColor: const Color(0xFF2C2D44),
        collapsedBackgroundColor: const Color(0xFF2C2D44),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white70,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Share your honest thoughts and reflections...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4ECDC4)),
                    ),
                  ),
                  onChanged: (value) {
                    _spiritualAnswers[question.id] = value;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final answer = _spiritualAnswers[question.id];
                    if (answer != null && answer.trim().isNotEmpty) {
                      setState(() {
                        question.isAnswered = true;
                        if (!question.isAnswered) _completedSpiritual++;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Answer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalvationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Salvation Assurance Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite, color: Colors.white, size: 32),
                SizedBox(height: 16),
                Text(
                  'Salvation Check-In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Confirming your relationship with Jesus',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Salvation Questions
          const Text(
            'Foundation Questions',
            style: TextStyle(
              color: Color(0xFF4ECDC4),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _salvationQuestions.length,
            itemBuilder: (context, index) {
              final question = _salvationQuestions[index];
              final isAnswered = _salvationAnswers[index] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2D44),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isAnswered
                          ? Border.all(color: const Color(0xFF4CAF50), width: 2)
                          : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _salvationAnswers[index] = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isAnswered == true
                                      ? const Color(0xFF4CAF50)
                                      : Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFF4CAF50),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color:
                                    isAnswered == true
                                        ? Colors.white
                                        : const Color(0xFF4CAF50),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _salvationAnswers[index] = false;
                            });
                            _showSalvationHelp();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isAnswered == false
                                      ? const Color(0xFFE91E63)
                                      : Colors.transparent,
                              border: Border.all(
                                color: const Color(0xFFE91E63),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                color:
                                    isAnswered == false
                                        ? Colors.white
                                        : const Color(0xFFE91E63),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Prayer Button
          ElevatedButton.icon(
            onPressed: _showSalvationPrayer,
            icon: const Icon(Icons.favorite, color: Colors.white),
            label: const Text(
              'Pray for Salvation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add Partner Button
          ElevatedButton.icon(
            onPressed: _showAddPartnerDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Accountability Partner',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Partners List
          const Text(
            'Your Accountability Network',
            style: TextStyle(
              color: Color(0xFF4ECDC4),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _partners.length,
            itemBuilder: (context, index) {
              final partner = _partners[index];
              return _buildPartnerCard(partner);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard(AccountabilityPartner partner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2D44),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    partner.isOnline ? const Color(0xFF4CAF50) : Colors.grey,
                radius: 20,
                child: Text(
                  partner.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      partner.role,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                partner.isOnline ? Icons.circle : Icons.circle_outlined,
                color: partner.isOnline ? const Color(0xFF4CAF50) : Colors.grey,
                size: 12,
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'Last contact: ${_formatLastContact(partner.lastContact)}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children:
                partner.strugglesShared.map((struggle) {
                  final struggleData = _sinStruggles.firstWhere(
                    (s) => s.id == struggle,
                    orElse:
                        () => SinAccountability(
                          id: struggle,
                          name: struggle,
                          icon: Icons.circle,
                          color: Colors.grey,
                          currentStreak: 0,
                          longestStreak: 0,
                          lastSlip: DateTime.now(),
                        ),
                  );
                  return Chip(
                    label: Text(
                      struggleData.name,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    backgroundColor: struggleData.color,
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactPartner(partner),
                  icon: const Icon(Icons.message, size: 16),
                  label: const Text('Contact', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _checkIn(partner),
                  icon: const Icon(Icons.check_circle, size: 16),
                  label: const Text('Check-in', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastContact(DateTime lastContact) {
    final difference = DateTime.now().difference(lastContact);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  void _showEmergencySupport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C2D44),
            title: const Text(
              'Emergency Support',
              style: TextStyle(color: Colors.white),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You are not alone. God loves you and there are people who want to help.',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 16),
                Text(
                  '"Cast all your anxiety on him because he cares for you." - 1 Peter 5:7',
                  style: TextStyle(
                    color: Color(0xFF4ECDC4),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Contact Partner'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Call Helpline'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSalvationHelp() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C2D44),
            title: const Text(
              'Let\'s Talk About Salvation',
              style: TextStyle(color: Colors.white),
            ),
            content: const SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'God loves you deeply and wants a relationship with you. Here\'s how you can know Jesus:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Acknowledge your need for God',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '"All have sinned and fall short of the glory of God" - Romans 3:23',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '2. Believe in Jesus Christ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '"For God so loved the world that he gave his one and only Son..." - John 3:16',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '3. Call upon Jesus to save you',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '"Everyone who calls on the name of the Lord will be saved" - Romans 10:13',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSalvationPrayer();
                },
                child: const Text('Pray Now'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Learn More'),
              ),
            ],
          ),
    );
  }

  void _showSalvationPrayer() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C2D44),
            title: const Text(
              'Prayer for Salvation',
              style: TextStyle(color: Colors.white),
            ),
            content: const SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You can pray this prayer or use your own words:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '"Dear Jesus, I know that I am a sinner and need your forgiveness. I believe that you died for my sins and rose from the dead. I want to turn from my sins and invite you to come into my heart and life. I want to trust and follow you as my Lord and Savior. Amen."',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('I Prayed This'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showAddPartnerDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C2D44),
            title: const Text(
              'Add Accountability Partner',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Partner name',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email or phone',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Send Invite'),
              ),
            ],
          ),
    );
  }

  void _contactPartner(AccountabilityPartner partner) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${partner.name}...'),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );
  }

  void _checkIn(AccountabilityPartner partner) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Check-in sent to ${partner.name}'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Models
class AccountabilityQuestion {
  final int id;
  final String question;
  final String type;
  bool isAnswered;

  AccountabilityQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.isAnswered,
  });
}

class SinAccountability {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  int currentStreak;
  final int longestStreak;
  DateTime lastSlip;

  SinAccountability({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastSlip,
  });
}

class AccountabilityPartner {
  final String id;
  final String name;
  final String role;
  final DateTime lastContact;
  final List<String> strugglesShared;
  final bool isOnline;

  AccountabilityPartner({
    required this.id,
    required this.name,
    required this.role,
    required this.lastContact,
    required this.strugglesShared,
    required this.isOnline,
  });
}
