import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReadBiblePage extends StatefulWidget {
  const ReadBiblePage({super.key});

  @override
  State<ReadBiblePage> createState() => _ReadBiblePageState();
}

class _ReadBiblePageState extends State<ReadBiblePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Old Testament';
  String? _selectedBook;
  int? _selectedChapter;
  List<String> _searchResults = [];
  List<BibleVerse> _currentChapterVerses = [];
  bool _isLoading = false;
  bool _showSearch = false;

  final Map<String, List<String>> _bibleBooks = {
    'Old Testament': [
      'Genesis',
      'Exodus',
      'Leviticus',
      'Numbers',
      'Deuteronomy',
      'Joshua',
      'Judges',
      'Ruth',
      '1 Samuel',
      '2 Samuel',
      '1 Kings',
      '2 Kings',
      '1 Chronicles',
      '2 Chronicles',
      'Ezra',
      'Nehemiah',
      'Esther',
      'Job',
      'Psalms',
      'Proverbs',
      'Ecclesiastes',
      'Song of Solomon',
      'Isaiah',
      'Jeremiah',
      'Lamentations',
      'Ezekiel',
      'Daniel',
      'Hosea',
      'Joel',
      'Amos',
      'Obadiah',
      'Jonah',
      'Micah',
      'Nahum',
      'Habakkuk',
      'Zephaniah',
      'Haggai',
      'Zechariah',
      'Malachi',
    ],
    'New Testament': [
      'Matthew',
      'Mark',
      'Luke',
      'John',
      'Acts',
      'Romans',
      '1 Corinthians',
      '2 Corinthians',
      'Galatians',
      'Ephesians',
      'Philippians',
      'Colossians',
      '1 Thessalonians',
      '2 Thessalonians',
      '1 Timothy',
      '2 Timothy',
      'Titus',
      'Philemon',
      'Hebrews',
      'James',
      '1 Peter',
      '2 Peter',
      '1 John',
      '2 John',
      '3 John',
      'Jude',
      'Revelation',
    ],
  };

  @override
  void initState() {
    super.initState();
    // Start with Genesis Chapter 1 as default
    _selectedBook = 'Genesis';
    _selectedChapter = 1;
    _loadChapter();
  }

  Future<void> _searchBible(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    try {
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        _setFallbackSearchResults(query);
        return;
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final prompt = '''
Search for Bible verses related to: "$query"

Please provide 5-7 relevant Bible verses that relate to this topic or contain these keywords.

Format each result exactly like this:
VERSE: [Book Chapter:Verse] - [Full verse text]

For example:
VERSE: John 3:16 - For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.

Focus on well-known, meaningful verses that directly relate to the search term.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        _parseSearchResults(response.text!);
      } else {
        _setFallbackSearchResults(query);
      }
    } catch (e) {
      print('Search error: $e');
      _setFallbackSearchResults(query);
    }
  }

  void _parseSearchResults(String response) {
    final results = <String>[];
    final lines = response.split('\n');

    for (String line in lines) {
      if (line.trim().toUpperCase().startsWith('VERSE:')) {
        final verse = line.substring(6).trim();
        if (verse.isNotEmpty) {
          results.add(verse);
        }
      }
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
      _showSearch = true;
    });
  }

  void _setFallbackSearchResults(String query) {
    final fallbackResults = [
      'John 3:16 - For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
      'Psalm 23:1 - The Lord is my shepherd, I lack nothing.',
      'Romans 8:28 - And we know that in all things God works for the good of those who love him, who have been called according to his purpose.',
      'Philippians 4:13 - I can do all this through him who gives me strength.',
      'Jeremiah 29:11 - For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, to give you hope and a future.',
    ];

    setState(() {
      _searchResults = fallbackResults;
      _isLoading = false;
      _showSearch = true;
    });
  }

  Future<void> _loadChapter() async {
    if (_selectedBook == null || _selectedChapter == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        _setFallbackChapter();
        return;
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final prompt = '''
Provide the full text of $_selectedBook Chapter $_selectedChapter from the Bible.

Format each verse exactly like this:
VERSE: [verse_number] [verse_text]

For example:
VERSE: 1 In the beginning God created the heavens and the earth.
VERSE: 2 Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.

Provide all verses in the chapter in order.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        _parseChapterVerses(response.text!);
      } else {
        _setFallbackChapter();
      }
    } catch (e) {
      print('Chapter load error: $e');
      _setFallbackChapter();
    }
  }

  void _parseChapterVerses(String response) {
    final verses = <BibleVerse>[];
    final lines = response.split('\n');

    for (String line in lines) {
      if (line.trim().toUpperCase().startsWith('VERSE:')) {
        final verseText = line.substring(6).trim();
        final spaceIndex = verseText.indexOf(' ');

        if (spaceIndex > 0) {
          final verseNumber = verseText.substring(0, spaceIndex);
          final text = verseText.substring(spaceIndex + 1);

          verses.add(
            BibleVerse(
              book: _selectedBook!,
              chapter: _selectedChapter!,
              verse: int.tryParse(verseNumber) ?? verses.length + 1,
              text: text,
            ),
          );
        }
      }
    }

    setState(() {
      _currentChapterVerses = verses;
      _isLoading = false;
      _showSearch = false;
    });
  }

  void _setFallbackChapter() {
    // Fallback for Genesis 1
    final fallbackVerses = [
      BibleVerse(
        book: 'Genesis',
        chapter: 1,
        verse: 1,
        text: 'In the beginning God created the heavens and the earth.',
      ),
      BibleVerse(
        book: 'Genesis',
        chapter: 1,
        verse: 2,
        text:
            'Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.',
      ),
      BibleVerse(
        book: 'Genesis',
        chapter: 1,
        verse: 3,
        text: 'And God said, "Let there be light," and there was light.',
      ),
      BibleVerse(
        book: 'Genesis',
        chapter: 1,
        verse: 4,
        text:
            'God saw that the light was good, and he separated the light from the darkness.',
      ),
      BibleVerse(
        book: 'Genesis',
        chapter: 1,
        verse: 5,
        text:
            'God called the light "day," and the darkness he called "night." And there was evening, and there was morning—the first day.',
      ),
    ];

    setState(() {
      _currentChapterVerses = fallbackVerses;
      _isLoading = false;
      _showSearch = false;
    });
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
              child: Column(
                children: [
                  Row(
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
                          'Read the Bible',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showSearch = !_showSearch;
                          });
                        },
                        icon: Icon(
                          _showSearch ? Icons.close : Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  // Search Bar
                  if (_showSearch) ...[
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2D44),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search verses, topics, or keywords...',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: _searchBible,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Content
            Expanded(
              child: _showSearch ? _buildSearchResults() : _buildBibleReader(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Enter a search term to find Bible verses',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final parts = result.split(' - ');
        final reference = parts.isNotEmpty ? parts[0] : '';
        final text = parts.length > 1 ? parts[1] : result;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2D44),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reference,
                style: const TextStyle(
                  color: Color(0xFF4ECDC4),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBibleReader() {
    return Column(
      children: [
        // Book and Chapter Navigation
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2D44),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Testament Selection
              Row(
                children: [
                  Expanded(child: _buildCategoryButton('Old Testament')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCategoryButton('New Testament')),
                ],
              ),
              const SizedBox(height: 16),

              // Book Selection
              SizedBox(
                height: 100,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _bibleBooks[_selectedCategory]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final book = _bibleBooks[_selectedCategory]![index];
                    return _buildBookButton(book);
                  },
                ),
              ),

              if (_selectedBook != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Chapter: ',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    DropdownButton<int>(
                      value: _selectedChapter,
                      dropdownColor: const Color(0xFF2C2D44),
                      style: const TextStyle(color: Colors.white),
                      items:
                          List.generate(50, (index) => index + 1)
                              .map(
                                (chapter) => DropdownMenuItem(
                                  value: chapter,
                                  child: Text('$chapter'),
                                ),
                              )
                              .toList(),
                      onChanged: (chapter) {
                        setState(() {
                          _selectedChapter = chapter;
                        });
                        _loadChapter();
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Chapter Content
        Expanded(
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4ECDC4),
                      ),
                    ),
                  )
                  : _currentChapterVerses.isEmpty
                  ? const Center(
                    child: Text(
                      'Select a book and chapter to start reading',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _currentChapterVerses.length,
                    itemBuilder: (context, index) {
                      final verse = _currentChapterVerses[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2D44),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${verse.verse} ',
                                style: const TextStyle(
                                  color: Color(0xFF4ECDC4),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: verse.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _selectedBook = null;
          _selectedChapter = null;
          _currentChapterVerses.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECDC4) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.white30,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          category,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBookButton(String book) {
    final isSelected = _selectedBook == book;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBook = book;
          _selectedChapter = 1;
        });
        _loadChapter();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECDC4) : const Color(0xFF1A1B2E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          book,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Bible Verse Model
class BibleVerse {
  final String book;
  final int chapter;
  final int verse;
  final String text;

  BibleVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });
}
