/// JSON data source for loading study tools content from asset files
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crack_the_code/core/constants/asset_constants.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/models/study_tools/flashcard_deck_model.dart';
import 'package:crack_the_code/data/models/study_tools/flashcard_model.dart';
import 'package:crack_the_code/data/models/study_tools/glossary_term_model.dart';
import 'package:crack_the_code/data/models/study_tools/mind_map_node_model.dart';
import 'package:crack_the_code/data/models/study_tools/video_question_model.dart';
import 'package:crack_the_code/data/models/study_tools/video_summary_model.dart';
import 'package:crack_the_code/data/models/study_tools/chapter_summary_model.dart';
import 'package:crack_the_code/data/models/study_tools/chapter_note_model.dart';

/// Data source for reading study tools JSON content files
class StudyToolsJsonDataSource {
  /// Cache for loaded summaries (key: subjectId_chapterId, value: map of videoId -> summary)
  final Map<String, Map<String, VideoSummaryModel>> _summariesCache = {};

  /// Cache for loaded glossary terms (key: subjectId_chapterId)
  final Map<String, List<GlossaryTermModel>> _glossaryCache = {};

  /// Cache for loaded mind map nodes (key: subjectId_chapterId)
  final Map<String, List<MindMapNodeModel>> _mindMapCache = {};

  /// Cache for loaded flashcard decks (key: subjectId_chapterId)
  final Map<String, List<FlashcardDeckModel>> _flashcardDecksCache = {};

  /// Cache for loaded flashcards (key: deckId)
  final Map<String, List<FlashcardModel>> _flashcardsCache = {};

  /// Cache for loaded FAQs (key: subjectId_chapterId, value: map of videoId -> faqs)
  final Map<String, Map<String, List<VideoQuestionModel>>> _faqsCache = {};

  /// Cache for loaded chapter summaries (key: subjectId_chapterId)
  final Map<String, ChapterSummaryModel?> _chapterSummaryCache = {};

  /// Cache for loaded curated notes (key: subjectId_chapterId)
  final Map<String, List<ChapterNoteModel>> _curatedNotesCache = {};

  // ==================== SUMMARIES ====================

  /// Load summaries for a chapter
  Future<List<VideoSummaryModel>> loadSummaries({
    required String subjectId,
    required String chapterId,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check cache
    if (_summariesCache.containsKey(cacheKey)) {
      logger.debug('Summaries for $cacheKey loaded from cache');
      return _summariesCache[cacheKey]!.values.toList();
    }

    try {
      final assetPath = StudyToolsAssets.summaries(subjectId, chapterId);
      logger.info('Loading summaries from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final summariesJson = jsonData['summaries'] as List<dynamic>? ?? [];

      final summaryMap = <String, VideoSummaryModel>{};
      for (final summaryJson in summariesJson) {
        final summary = VideoSummaryModel.fromJson(summaryJson as Map<String, dynamic>);
        summaryMap[summary.videoId] = summary;
      }

      _summariesCache[cacheKey] = summaryMap;
      logger.info('Loaded ${summaryMap.length} summaries for $cacheKey');
      return summaryMap.values.toList();
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No summaries file found for $cacheKey');
        _summariesCache[cacheKey] = {};
        return [];
      }
      logger.error('Failed to load summaries for $cacheKey', e, stackTrace);
      return [];
    }
  }

  /// Get a summary by video ID from cache
  VideoSummaryModel? getSummaryByVideoId({
    required String subjectId,
    required String chapterId,
    required String videoId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    return _summariesCache[cacheKey]?[videoId];
  }

  // ==================== GLOSSARY ====================

  /// Load glossary terms for a chapter
  Future<List<GlossaryTermModel>> loadGlossary({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check cache
    if (_glossaryCache.containsKey(cacheKey)) {
      logger.debug('Glossary for $cacheKey loaded from cache');
      return _glossaryCache[cacheKey]!;
    }

    try {
      final assetPath = StudyToolsAssets.glossary(subjectId, chapterId);
      logger.info('Loading glossary from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final termsJson = jsonData['terms'] as List<dynamic>? ?? [];

      final terms = termsJson
          .map((termJson) => GlossaryTermModel.fromJson(
                termJson as Map<String, dynamic>,
                chapterId,
                segment,
              ))
          .toList();

      _glossaryCache[cacheKey] = terms;
      logger.info('Loaded ${terms.length} glossary terms for $cacheKey');
      return terms;
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No glossary file found for $cacheKey');
        _glossaryCache[cacheKey] = [];
        return [];
      }
      logger.error('Failed to load glossary for $cacheKey', e, stackTrace);
      return [];
    }
  }

  /// Get glossary terms from cache
  List<GlossaryTermModel>? getGlossaryFromCache({
    required String subjectId,
    required String chapterId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    return _glossaryCache[cacheKey];
  }

  // ==================== MIND MAPS ====================

  /// Load mind map nodes for a chapter
  Future<List<MindMapNodeModel>> loadMindMap({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check cache
    if (_mindMapCache.containsKey(cacheKey)) {
      logger.debug('Mind map for $cacheKey loaded from cache');
      return _mindMapCache[cacheKey]!;
    }

    try {
      final assetPath = StudyToolsAssets.mindMap(subjectId, chapterId);
      logger.info('Loading mind map from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final nodesJson = jsonData['nodes'] as List<dynamic>? ?? [];

      final nodes = nodesJson
          .map((nodeJson) => MindMapNodeModel.fromJson(
                nodeJson as Map<String, dynamic>,
                chapterId,
                segment,
              ))
          .toList();

      _mindMapCache[cacheKey] = nodes;
      logger.info('Loaded ${nodes.length} mind map nodes for $cacheKey');
      return nodes;
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No mind map file found for $cacheKey');
        _mindMapCache[cacheKey] = [];
        return [];
      }
      logger.error('Failed to load mind map for $cacheKey', e, stackTrace);
      return [];
    }
  }

  /// Get mind map nodes from cache
  List<MindMapNodeModel>? getMindMapFromCache({
    required String subjectId,
    required String chapterId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    return _mindMapCache[cacheKey];
  }

  // ==================== FLASHCARDS ====================

  /// Load flashcard decks and cards for a chapter
  Future<List<FlashcardDeckModel>> loadFlashcards({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check cache
    if (_flashcardDecksCache.containsKey(cacheKey)) {
      logger.debug('Flashcards for $cacheKey loaded from cache');
      return _flashcardDecksCache[cacheKey]!;
    }

    try {
      final assetPath = StudyToolsAssets.flashcards(subjectId, chapterId);
      logger.info('Loading flashcards from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final decksJson = jsonData['decks'] as List<dynamic>? ?? [];

      final decks = <FlashcardDeckModel>[];

      for (final deckJson in decksJson) {
        final deckMap = deckJson as Map<String, dynamic>;
        final deck = FlashcardDeckModel.fromJson(deckMap, segment);
        decks.add(deck);

        // Parse cards for this deck
        final cardsJson = deckMap['cards'] as List<dynamic>? ?? [];
        final cards = cardsJson
            .map((cardJson) => FlashcardModel.fromJson(
                  cardJson as Map<String, dynamic>,
                  deck.id,
                ))
            .toList();

        _flashcardsCache[deck.id] = cards;
      }

      _flashcardDecksCache[cacheKey] = decks;
      logger.info('Loaded ${decks.length} flashcard decks for $cacheKey');
      return decks;
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No flashcards file found for $cacheKey');
        _flashcardDecksCache[cacheKey] = [];
        return [];
      }
      logger.error('Failed to load flashcards for $cacheKey', e, stackTrace);
      return [];
    }
  }

  /// Get flashcard decks from cache
  List<FlashcardDeckModel>? getFlashcardDecksFromCache({
    required String subjectId,
    required String chapterId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    return _flashcardDecksCache[cacheKey];
  }

  /// Get cards for a specific deck from cache
  List<FlashcardModel> getCardsByDeckId(String deckId) {
    return _flashcardsCache[deckId] ?? [];
  }

  // ==================== FAQs ====================

  /// Load FAQs for a chapter
  Future<List<VideoQuestionModel>> loadFaqs({
    required String subjectId,
    required String chapterId,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check if already loaded (return all FAQs for chapter)
    if (_faqsCache.containsKey(cacheKey)) {
      logger.debug('FAQs for $cacheKey loaded from cache');
      return _faqsCache[cacheKey]!.values.expand((list) => list).toList();
    }

    try {
      final assetPath = StudyToolsAssets.faqs(subjectId, chapterId);
      logger.info('Loading FAQs from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final faqsJson = jsonData['faqs'] as List<dynamic>? ?? [];

      final faqsByVideo = <String, List<VideoQuestionModel>>{};

      for (final faqJson in faqsJson) {
        final faq = VideoQuestionModel.fromJson(faqJson as Map<String, dynamic>);

        if (!faqsByVideo.containsKey(faq.videoId)) {
          faqsByVideo[faq.videoId] = [];
        }
        faqsByVideo[faq.videoId]!.add(faq);
      }

      _faqsCache[cacheKey] = faqsByVideo;
      final totalFaqs = faqsByVideo.values.fold<int>(0, (sum, list) => sum + list.length);
      logger.info('Loaded $totalFaqs FAQs for $cacheKey');

      return faqsByVideo.values.expand((list) => list).toList();
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No FAQs file found for $cacheKey');
        _faqsCache[cacheKey] = {};
        return [];
      }
      logger.error('Failed to load FAQs for $cacheKey', e, stackTrace);
      return [];
    }
  }

  /// Get FAQs for a specific video from cache
  List<VideoQuestionModel> getFaqsByVideoId({
    required String subjectId,
    required String chapterId,
    required String videoId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    return _faqsCache[cacheKey]?[videoId] ?? [];
  }

  // ==================== CHAPTER SUMMARIES ====================

  /// Load chapter summary for a chapter
  Future<ChapterSummaryModel?> loadChapterSummary({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check cache
    if (_chapterSummaryCache.containsKey(cacheKey)) {
      logger.debug('Chapter summary for $cacheKey loaded from cache');
      return _chapterSummaryCache[cacheKey];
    }

    try {
      final assetPath = StudyToolsAssets.chapterContent(subjectId, chapterId);
      logger.info('Loading chapter content from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final summaryJson = jsonData['chapterSummary'] as Map<String, dynamic>?;

      if (summaryJson != null) {
        final summary = ChapterSummaryModel.fromJson(
          summaryJson,
          chapterId,
          subjectId,
          segment,
        );
        _chapterSummaryCache[cacheKey] = summary;
        logger.info('Loaded chapter summary for $cacheKey');
        return summary;
      }

      _chapterSummaryCache[cacheKey] = null;
      logger.info('No chapter summary found for $cacheKey');
      return null;
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No chapter content file found for $cacheKey');
        _chapterSummaryCache[cacheKey] = null;
        return null;
      }
      logger.error('Failed to load chapter summary for $cacheKey', e, stackTrace);
      return null;
    }
  }

  /// Check if chapter has a summary available (without loading full content)
  Future<bool> hasChapterSummary({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    final summary = await loadChapterSummary(
      subjectId: subjectId,
      chapterId: chapterId,
      segment: segment,
    );
    return summary != null;
  }

  // ==================== CURATED NOTES ====================

  /// Load curated notes for a chapter
  Future<List<ChapterNoteModel>> loadCuratedNotes({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    final cacheKey = '${subjectId}_$chapterId';

    // Check cache
    if (_curatedNotesCache.containsKey(cacheKey)) {
      logger.debug('Curated notes for $cacheKey loaded from cache');
      return _curatedNotesCache[cacheKey]!;
    }

    try {
      final assetPath = StudyToolsAssets.chapterContent(subjectId, chapterId);
      logger.info('Loading curated notes from: $assetPath');

      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final notesJson = jsonData['curatedNotes'] as List<dynamic>? ?? [];

      final notes = notesJson
          .map((noteJson) => ChapterNoteModel.fromJson(
                noteJson as Map<String, dynamic>,
                chapterId,
                subjectId,
                segment,
              ))
          .toList();

      _curatedNotesCache[cacheKey] = notes;
      logger.info('Loaded ${notes.length} curated notes for $cacheKey');
      return notes;
    } catch (e, stackTrace) {
      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        logger.debug('No chapter content file found for $cacheKey');
        _curatedNotesCache[cacheKey] = [];
        return [];
      }
      logger.error('Failed to load curated notes for $cacheKey', e, stackTrace);
      return [];
    }
  }

  /// Get curated notes from cache
  List<ChapterNoteModel>? getCuratedNotesFromCache({
    required String subjectId,
    required String chapterId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    return _curatedNotesCache[cacheKey];
  }

  // ==================== BATCH OPERATIONS ====================

  /// Preload all study tools for a chapter
  Future<void> preloadChapter({
    required String subjectId,
    required String chapterId,
    required String segment,
  }) async {
    logger.info('Preloading study tools for $subjectId/$chapterId');

    await Future.wait([
      loadSummaries(subjectId: subjectId, chapterId: chapterId),
      loadGlossary(subjectId: subjectId, chapterId: chapterId, segment: segment),
      loadMindMap(subjectId: subjectId, chapterId: chapterId, segment: segment),
      loadFlashcards(subjectId: subjectId, chapterId: chapterId, segment: segment),
      loadFaqs(subjectId: subjectId, chapterId: chapterId),
      loadChapterSummary(subjectId: subjectId, chapterId: chapterId, segment: segment),
      loadCuratedNotes(subjectId: subjectId, chapterId: chapterId, segment: segment),
    ]);

    logger.info('Finished preloading study tools for $subjectId/$chapterId');
  }

  // ==================== CACHE MANAGEMENT ====================

  /// Clear all caches
  void clearCache() {
    logger.info('Clearing study tools JSON cache');
    _summariesCache.clear();
    _glossaryCache.clear();
    _mindMapCache.clear();
    _flashcardDecksCache.clear();
    _flashcardsCache.clear();
    _faqsCache.clear();
    _chapterSummaryCache.clear();
    _curatedNotesCache.clear();
  }

  /// Clear cache for a specific chapter
  void clearChapterCache({
    required String subjectId,
    required String chapterId,
  }) {
    final cacheKey = '${subjectId}_$chapterId';
    _summariesCache.remove(cacheKey);
    _glossaryCache.remove(cacheKey);
    _mindMapCache.remove(cacheKey);

    // Clear flashcard decks and their cards
    final decks = _flashcardDecksCache.remove(cacheKey);
    if (decks != null) {
      for (final deck in decks) {
        _flashcardsCache.remove(deck.id);
      }
    }

    _faqsCache.remove(cacheKey);
    _chapterSummaryCache.remove(cacheKey);
    _curatedNotesCache.remove(cacheKey);
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'summaries': _summariesCache.length,
      'glossary': _glossaryCache.length,
      'mindMaps': _mindMapCache.length,
      'flashcardDecks': _flashcardDecksCache.length,
      'flashcards': _flashcardsCache.length,
      'faqs': _faqsCache.length,
      'chapterSummaries': _chapterSummaryCache.length,
      'curatedNotes': _curatedNotesCache.length,
    };
  }
}
