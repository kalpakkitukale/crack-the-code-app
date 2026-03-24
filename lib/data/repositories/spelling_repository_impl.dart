import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:streamshaala/data/datasources/json/spelling_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/spelling_attempt_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/word_mastery_dao.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/domain/entities/spelling/word_list.dart';
import 'package:streamshaala/domain/entities/spelling/word_mastery.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_attempt.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_statistics.dart';
import 'package:streamshaala/domain/entities/spelling/phonics_pattern.dart';
import 'package:streamshaala/domain/repositories/spelling_repository.dart';

class SpellingRepositoryImpl implements SpellingRepository {
  final SpellingJsonDataSource jsonDataSource;
  final SpellingAttemptDao? attemptDao;
  final WordMasteryDao? masteryDao;

  SpellingRepositoryImpl({
    required this.jsonDataSource,
    this.attemptDao,
    this.masteryDao,
  });

  @override
  Future<Either<Exception, List<WordList>>> getWordLists(
      {int? gradeLevel, String? category}) async {
    try {
      final models = await jsonDataSource.getWordLists(
          gradeLevel: gradeLevel, category: category);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Exception('Failed to load word lists: $e'));
    }
  }

  @override
  Future<Either<Exception, WordList>> getWordListById(String id) async {
    try {
      final model = await jsonDataSource.getWordListById(id);
      if (model == null) return Left(Exception('Word list not found: $id'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(Exception('Failed to load word list: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Word>>> getWordsForList(
      String wordListId) async {
    try {
      final models = await jsonDataSource.getWordsForList(wordListId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Exception('Failed to load words: $e'));
    }
  }

  @override
  Future<Either<Exception, Word>> getWordById(String id) async {
    try {
      final model = await jsonDataSource.getWordById(id);
      if (model == null) return Left(Exception('Word not found: $id'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(Exception('Failed to load word: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Word>>> searchWords(String query) async {
    try {
      final models = await jsonDataSource.searchWords(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Exception('Search failed: $e'));
    }
  }

  @override
  Future<Either<Exception, Word>> getWordOfTheDay() async {
    try {
      // Use date-based seed for consistent daily word
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = Random(seed);

      // Get all words and pick one based on date
      final allWordLists = await jsonDataSource.getWordLists();
      if (allWordLists.isEmpty) {
        return Left(Exception('No word lists available'));
      }

      final allWords = <Word>[];
      for (final wl in allWordLists) {
        final words = await jsonDataSource.getWordsForList(wl.id);
        allWords.addAll(words.map((m) => m.toEntity()));
      }

      if (allWords.isEmpty) return Left(Exception('No words available'));

      final index = random.nextInt(allWords.length);
      return Right(allWords[index]);
    } catch (e) {
      return Left(Exception('Failed to get word of the day: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Word>>> getWordsByGrade(
      int gradeLevel) async {
    try {
      final models = await jsonDataSource.getWordsByGrade(gradeLevel);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Exception('Failed to load words by grade: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Word>>> getWordsByPhonicsPattern(
      String pattern) async {
    try {
      final allWordLists = await jsonDataSource.getWordLists();
      final matchingLists =
          allWordLists.where((wl) => wl.phonicsPattern == pattern);

      final words = <Word>[];
      for (final wl in matchingLists) {
        final wlWords = await jsonDataSource.getWordsForList(wl.id);
        words.addAll(wlWords.map((m) => m.toEntity()));
      }

      return Right(words);
    } catch (e) {
      return Left(Exception('Failed to load words by pattern: $e'));
    }
  }

  @override
  Future<Either<Exception, WordMastery>> getWordMastery(String wordId,
      {String? profileId}) async {
    try {
      if (masteryDao == null) {
        return Right(
            WordMastery(wordId: wordId, word: '', profileId: profileId));
      }
      final data =
          await masteryDao!.getByWordId(wordId, profileId: profileId);
      if (data == null) {
        return Right(
            WordMastery(wordId: wordId, word: '', profileId: profileId));
      }
      return Right(_masteryFromMap(data));
    } catch (e) {
      return Left(Exception('Failed to get word mastery: $e'));
    }
  }

  @override
  Future<Either<Exception, List<WordMastery>>> getAllMasteries(
      {String? profileId}) async {
    try {
      if (masteryDao == null) return const Right([]);
      final data = await masteryDao!.getAll(profileId: profileId);
      return Right(data.map(_masteryFromMap).toList());
    } catch (e) {
      return Left(Exception('Failed to get masteries: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> saveWordMastery(WordMastery mastery) async {
    try {
      if (masteryDao == null) return const Right(null);
      await masteryDao!.upsert(_masteryToMap(mastery));
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to save mastery: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Word>>> getWeakWords(
      {String? profileId, int limit = 20}) async {
    try {
      if (masteryDao == null) return const Right([]);
      final masteries =
          await masteryDao!.getByLevel('learning', profileId: profileId);
      final words = <Word>[];
      for (final m in masteries.take(limit)) {
        final word = await jsonDataSource.getWordById(m['word_id'] as String);
        if (word != null) words.add(word.toEntity());
      }
      return Right(words);
    } catch (e) {
      return Left(Exception('Failed to get weak words: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Word>>> getDueForReview(
      {String? profileId}) async {
    try {
      if (masteryDao == null) return const Right([]);
      final masteries =
          await masteryDao!.getDueForReview(profileId: profileId);
      final words = <Word>[];
      for (final m in masteries) {
        final word = await jsonDataSource.getWordById(m['word_id'] as String);
        if (word != null) words.add(word.toEntity());
      }
      return Right(words);
    } catch (e) {
      return Left(Exception('Failed to get review words: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> saveSpellingAttempt(
      SpellingAttempt attempt) async {
    try {
      if (attemptDao == null) return const Right(null);
      await attemptDao!.insert({
        'id': attempt.id,
        'word_id': attempt.wordId,
        'word': attempt.word,
        'user_input': attempt.userInput,
        'is_correct': attempt.isCorrect ? 1 : 0,
        'activity_type': attempt.activityType,
        'time_spent_ms': attempt.timeSpentMs,
        'attempted_at': attempt.attemptedAt.toIso8601String(),
        'profile_id': attempt.profileId ?? '',
        'attempt_number': attempt.attemptNumber,
      });
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to save attempt: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SpellingAttempt>>> getAttemptsForWord(
      String wordId,
      {String? profileId}) async {
    try {
      if (attemptDao == null) return const Right([]);
      final data =
          await attemptDao!.getByWordId(wordId, profileId: profileId);
      return Right(data.map(_attemptFromMap).toList());
    } catch (e) {
      return Left(Exception('Failed to get attempts: $e'));
    }
  }

  @override
  Future<Either<Exception, SpellingStatistics>> getStatistics(
      {String? profileId}) async {
    try {
      if (attemptDao == null || masteryDao == null) {
        return const Right(SpellingStatistics());
      }

      final attemptStats =
          await attemptDao!.getStatistics(profileId: profileId);
      final masteredCount =
          await masteryDao!.getMasteredCount(profileId: profileId);
      final allMasteries = await masteryDao!.getAll(profileId: profileId);

      return Right(SpellingStatistics(
        totalWordsLearned: allMasteries.length,
        totalWordsMastered: masteredCount,
        totalAttempts: attemptStats['totalAttempts'] as int,
        totalCorrect: attemptStats['totalCorrect'] as int,
      ));
    } catch (e) {
      return Left(Exception('Failed to get statistics: $e'));
    }
  }

  @override
  Future<Either<Exception, List<PhonicsPattern>>> getPhonicsPatterns(
      {int? gradeLevel}) async {
    try {
      final models =
          await jsonDataSource.getPhonicsPatterns(gradeLevel: gradeLevel);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Exception('Failed to load phonics patterns: $e'));
    }
  }

  @override
  Future<Either<Exception, PhonicsPattern>> getPhonicsPatternById(
      String id) async {
    try {
      final models = await jsonDataSource.getPhonicsPatterns();
      final found = models.where((m) => m.id == id);
      if (found.isEmpty) return Left(Exception('Pattern not found: $id'));
      return Right(found.first.toEntity());
    } catch (e) {
      return Left(Exception('Failed to load pattern: $e'));
    }
  }

  // Helper methods for converting between maps and entities
  WordMastery _masteryFromMap(Map<String, dynamic> map) {
    return WordMastery(
      wordId: map['word_id'] as String,
      word: map['word'] as String? ?? '',
      level: MasteryLevel.values.firstWhere(
        (l) => l.name == (map['level'] as String? ?? 'newWord'),
        orElse: () => MasteryLevel.newWord,
      ),
      correctStreak: map['correct_streak'] as int? ?? 0,
      totalAttempts: map['total_attempts'] as int? ?? 0,
      correctAttempts: map['correct_attempts'] as int? ?? 0,
      lastAttemptedAt: map['last_attempted_at'] != null
          ? DateTime.tryParse(map['last_attempted_at'] as String)
          : null,
      nextReviewAt: map['next_review_at'] != null
          ? DateTime.tryParse(map['next_review_at'] as String)
          : null,
      easeFactor: (map['ease_factor'] as num?)?.toDouble() ?? 2.5,
      interval: map['interval_days'] as int? ?? 0,
      profileId: map['profile_id'] as String?,
    );
  }

  Map<String, dynamic> _masteryToMap(WordMastery mastery) {
    return {
      'word_id': mastery.wordId,
      'word': mastery.word,
      'level': mastery.level.name,
      'correct_streak': mastery.correctStreak,
      'total_attempts': mastery.totalAttempts,
      'correct_attempts': mastery.correctAttempts,
      'last_attempted_at': mastery.lastAttemptedAt?.toIso8601String(),
      'next_review_at': mastery.nextReviewAt?.toIso8601String(),
      'ease_factor': mastery.easeFactor,
      'interval_days': mastery.interval,
      'profile_id': mastery.profileId ?? '',
    };
  }

  SpellingAttempt _attemptFromMap(Map<String, dynamic> map) {
    return SpellingAttempt(
      id: map['id'] as String,
      wordId: map['word_id'] as String,
      word: map['word'] as String,
      userInput: map['user_input'] as String,
      isCorrect: (map['is_correct'] as int) == 1,
      activityType: map['activity_type'] as String,
      timeSpentMs: map['time_spent_ms'] as int? ?? 0,
      attemptedAt: DateTime.parse(map['attempted_at'] as String),
      profileId: map['profile_id'] as String?,
      attemptNumber: map['attempt_number'] as int? ?? 1,
    );
  }
}
