import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crack_the_code/data/models/spelling/word_model.dart';
import 'package:crack_the_code/data/models/spelling/word_list_model.dart';
import 'package:crack_the_code/data/models/spelling/phonics_pattern_model.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Data source for loading spelling content from JSON asset files
class SpellingJsonDataSource {
  // Cache
  final Map<String, List<WordModel>> _wordCache = {};
  final Map<String, WordListModel> _wordListCache = {};
  List<PhonicsPatternModel>? _phonicsPatternsCache;
  List<Map<String, dynamic>>? _wordFamiliesCache;
  Map<String, List<String>>? _manifestCache;
  bool _initialized = false;

  /// Load the content manifest that lists all available word list files
  Future<Map<String, List<String>>> _loadManifest() async {
    if (_manifestCache != null) return _manifestCache!;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/spelling/content_manifest.json');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final wordLists = json['wordLists'] as Map<String, dynamic>;
      _manifestCache = wordLists.map(
        (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
      );
    } catch (e) {
      logger.warning('Failed to load content manifest: $e');
      _manifestCache = {};
    }
    return _manifestCache!;
  }

  /// Initialize by scanning available word list files
  Future<void> initialize() async {
    if (_initialized) return;
    logger.info('Initializing SpellingJsonDataSource...');
    await _loadManifest();
    await getPhonicsPatterns();
    _initialized = true;
    logger.info('SpellingJsonDataSource initialized');
  }

  /// Get all word lists for a grade level
  Future<List<WordListModel>> getWordLists(
      {int? gradeLevel, String? category}) async {
    final wordLists = <WordListModel>[];

    // Scan known grade directories
    for (int grade = 1; grade <= 8; grade++) {
      if (gradeLevel != null && grade != gradeLevel) continue;

      try {
        // Try loading known word list files for this grade
        final files = await _getWordListFilesForGrade(grade);
        for (final filePath in files) {
          try {
            final jsonStr = await rootBundle.loadString(filePath);
            final json = jsonDecode(jsonStr) as Map<String, dynamic>;
            final model = WordListModel.fromJson(json);

            if (category != null && model.category != category) continue;

            _wordListCache[model.id] = model;
            wordLists.add(model);
          } catch (e) {
            logger.warning('Failed to load word list: $filePath - $e');
          }
        }
      } catch (e) {
        logger.warning('Failed to scan grade $grade word lists: $e');
      }
    }

    return wordLists;
  }

  /// Get a specific word list by ID
  Future<WordListModel?> getWordListById(String id) async {
    if (_wordListCache.containsKey(id)) return _wordListCache[id];
    // Try loading all and finding
    await getWordLists();
    return _wordListCache[id];
  }

  /// Get all words for a specific word list
  Future<List<WordModel>> getWordsForList(String wordListId) async {
    if (_wordCache.containsKey(wordListId)) return _wordCache[wordListId]!;

    // Find the word list and load its words
    final wordList = await getWordListById(wordListId);
    if (wordList == null) return [];

    // Words are embedded in the word list JSON files
    final grade = wordList.gradeLevel;
    final files = await _getWordListFilesForGrade(grade);

    for (final filePath in files) {
      try {
        final jsonStr = await rootBundle.loadString(filePath);
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        if (json['id'] == wordListId && json['words'] is List) {
          final words = (json['words'] as List<dynamic>)
              .map((w) => WordModel.fromJson(w as Map<String, dynamic>))
              .toList();
          _wordCache[wordListId] = words;
          return words;
        }
      } catch (e) {
        logger.warning('Failed to load words from: $filePath - $e');
      }
    }

    return [];
  }

  /// Get a word by its ID
  Future<WordModel?> getWordById(String wordId) async {
    // Search through cached words
    for (final words in _wordCache.values) {
      final found = words.where((w) => w.id == wordId);
      if (found.isNotEmpty) return found.first;
    }

    // Load all word lists to find the word
    await getWordLists();
    for (final wordListId in _wordListCache.keys) {
      final words = await getWordsForList(wordListId);
      final found = words.where((w) => w.id == wordId);
      if (found.isNotEmpty) return found.first;
    }

    return null;
  }

  /// Search words across all loaded content
  Future<List<WordModel>> searchWords(String query) async {
    final results = <WordModel>[];
    final queryLower = query.toLowerCase();

    // Ensure content is loaded
    await getWordLists();
    for (final wordListId in _wordListCache.keys) {
      final words = await getWordsForList(wordListId);
      results.addAll(words.where((w) =>
          w.word.toLowerCase().contains(queryLower) ||
          w.definition.toLowerCase().contains(queryLower) ||
          w.tags.any((t) => t.toLowerCase().contains(queryLower))));
    }

    // Deduplicate by ID
    final seen = <String>{};
    return results.where((w) => seen.add(w.id)).toList();
  }

  /// Get words by grade level
  Future<List<WordModel>> getWordsByGrade(int gradeLevel) async {
    final allWords = <WordModel>[];
    final wordLists = await getWordLists(gradeLevel: gradeLevel);

    for (final wl in wordLists) {
      final words = await getWordsForList(wl.id);
      allWords.addAll(words);
    }

    // Deduplicate
    final seen = <String>{};
    return allWords.where((w) => seen.add(w.id)).toList();
  }

  /// Get phonics patterns
  Future<List<PhonicsPatternModel>> getPhonicsPatterns(
      {int? gradeLevel}) async {
    if (_phonicsPatternsCache == null) {
      try {
        final jsonStr = await rootBundle
            .loadString('assets/data/spelling/phonics_patterns.json');
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        _phonicsPatternsCache = (json['patterns'] as List<dynamic>)
            .map((p) =>
                PhonicsPatternModel.fromJson(p as Map<String, dynamic>))
            .toList();
      } catch (e) {
        logger.warning('Failed to load phonics patterns: $e');
        _phonicsPatternsCache = [];
      }
    }

    if (gradeLevel != null) {
      return _phonicsPatternsCache!
          .where((p) => p.gradeLevel <= gradeLevel)
          .toList();
    }
    return _phonicsPatternsCache!;
  }

  /// Get word families
  Future<List<Map<String, dynamic>>> getWordFamilies() async {
    if (_wordFamiliesCache == null) {
      try {
        final jsonStr = await rootBundle
            .loadString('assets/data/spelling/word_families.json');
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        _wordFamiliesCache = (json['wordFamilies'] as List<dynamic>)
            .map((f) => f as Map<String, dynamic>)
            .toList();
      } catch (e) {
        logger.warning('Failed to load word families: $e');
        _wordFamiliesCache = [];
      }
    }
    return _wordFamiliesCache!;
  }

  /// Get word list file paths for a grade from the manifest
  Future<List<String>> _getWordListFilesForGrade(int grade) async {
    final manifest = await _loadManifest();
    return manifest['grade_$grade'] ?? [];
  }
}
