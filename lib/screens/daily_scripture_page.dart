import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';

class DailyScripturePage extends StatefulWidget {
  const DailyScripturePage({super.key});

  @override
  State<DailyScripturePage> createState() => _DailyScripturePageState();
}

class _DailyScripturePageState extends State<DailyScripturePage> {
  bool _isLoading = true;
  String _verse = '';
  String _reference = '';
  String _reflection = '';
  String _error = '';
  final TextEditingController _thoughtsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateDailyScripture();
  }

  Future<void> _generateDailyScripture() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Get API key from environment
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        // Fixed: was 'apikey'
        print('API key not found, using fallback scripture');
        _setRandomFallbackScripture();
        return;
      }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      ); // Fixed: now properly null-checked

      final prompt = '''
Generate a daily Bible verse for Christian devotion today. 

Requirements:
1. Choose ONE meaningful Bible verse (complete verse text)
2. Provide the exact Bible reference (Book Chapter:Verse format)
3. Write a 2-3 sentence reflection about how this verse applies to daily Christian life

Format your response EXACTLY like this:
VERSE: [complete verse text in quotes]
REFERENCE: [Book Chapter:Verse]
REFLECTION: [your thoughtful reflection]

Choose from themes like: faith, hope, love, peace, strength, guidance, forgiveness, joy, or trust.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      print('Gemini response: ${response.text}'); // Debug log

      if (response.text != null && response.text!.isNotEmpty) {
        _parseGeminiResponse(response.text!);
      } else {
        print('Empty response from Gemini, using fallback');
        _setRandomFallbackScripture();
      }
    } catch (e) {
      print('Error generating scripture: $e');
      setState(() {
        _error = 'Failed to generate scripture: $e';
        _isLoading = false;
      });

      // Use random fallback instead of always the same verse
      _setRandomFallbackScripture();
    }
  }

  void _parseGeminiResponse(String response) {
    try {
      print('Parsing response: $response'); // Debug log

      String verse = '';
      String reference = '';
      String reflection = '';

      // Split by lines and clean up
      final lines = response.split('\n').map((line) => line.trim()).toList();

      for (String line in lines) {
        if (line.toUpperCase().startsWith('VERSE:')) {
          verse = line.substring(6).trim();
          // Remove quotes if present
          if (verse.startsWith('"') && verse.endsWith('"')) {
            verse = verse.substring(1, verse.length - 1);
          }
        } else if (line.toUpperCase().startsWith('REFERENCE:')) {
          reference = line.substring(10).trim();
        } else if (line.toUpperCase().startsWith('REFLECTION:')) {
          reflection = line.substring(11).trim();
        }
      }

      // Validate we got all parts
      if (verse.isNotEmpty && reference.isNotEmpty && reflection.isNotEmpty) {
        setState(() {
          _verse = '"$verse"'; // Add quotes back for display
          _reference = reference;
          _reflection = reflection;
          _isLoading = false;
        });
        print('Successfully parsed: $reference'); // Debug log
      } else {
        print('Parsing failed - missing parts. Using fallback.');
        _setRandomFallbackScripture();
      }
    } catch (e) {
      print('Parse error: $e');
      _setRandomFallbackScripture();
    }
  }

  void _setRandomFallbackScripture() {
    final scriptures = [
      {
        'verse':
            '"For I know the plans I have for you, declares the Lord, plans for welfare and not for evil, to give you a future and a hope."',
        'reference': 'Jeremiah 29:11',
        'reflection':
            'God\'s plans for us are always good, even when we can\'t see the full picture. In times of uncertainty, we can trust that He is working all things together for our good.',
      },
      {
        'verse':
            '"Trust in the Lord with all your heart, and do not lean on your own understanding."',
        'reference': 'Proverbs 3:5',
        'reflection':
            'When life gets confusing, we can rely on God\'s wisdom rather than our limited perspective. His understanding is perfect and His guidance is trustworthy.',
      },
      {
        'verse': '"I can do all things through him who strengthens me."',
        'reference': 'Philippians 4:13',
        'reflection':
            'This verse reminds us that our strength comes from Christ. Whatever challenges we face today, we can overcome them through His power working in us.',
      },
      {
        'verse':
            '"The Lord your God is with you, the Mighty Warrior who saves. He will take great delight in you; in his love he will no longer rebuke you, but will rejoice over you with singing."',
        'reference': 'Zephaniah 3:17',
        'reflection':
            'God doesn\'t just tolerate us - He delights in us! This beautiful truth can transform how we see ourselves and approach each day with confidence in His love.',
      },
      {
        'verse':
            '"Be strong and courageous. Do not be afraid or terrified because of them, for the Lord your God goes with you; he will never leave you nor forsake you."',
        'reference': 'Deuteronomy 31:6',
        'reflection':
            'Fear often paralyzes us, but God\'s constant presence gives us courage. Whatever we\'re facing, we can move forward boldly knowing He walks alongside us.',
      },
    ];

    final random = Random();
    final selected = scriptures[random.nextInt(scriptures.length)];

    setState(() {
      _verse = selected['verse']!;
      _reference = selected['reference']!;
      _reflection = selected['reflection']!;
      _isLoading = false;
    });
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF4ECDC4),
                    ),
                  ),
                )
                : Column(
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
                                  'Daily Scripture',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _getCurrentDate(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Add refresh button
                          IconButton(
                            onPressed: _generateDailyScripture,
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                            tooltip: 'Get new verse',
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Hope & Trust Badge
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4ECDC4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Hope & Trust',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Scripture Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF4A5AE8),
                                    Color(0xFF8E44AD),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.menu_book,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _verse,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '— $_reference',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Today's Reflection
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C2D44),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Today\'s Reflection',
                                    style: TextStyle(
                                      color: Color(0xFF4ECDC4),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _reflection,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Your Thoughts
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C2D44),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Thoughts',
                                    style: TextStyle(
                                      color: Color(0xFF4ECDC4),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _thoughtsController,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'How does this verse speak to you today? Write your thoughts and prayers...',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white30,
                                        width: 1,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Love functionality
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.favorite_border,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Love',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white30,
                                        width: 1,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Share functionality
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Share',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Mark as Complete Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Mark as complete and navigate back
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4ECDC4),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Mark as Complete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }
}
