import 'package:dartz/dartz.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/domain/entities/spelling/word_list.dart';
import 'package:streamshaala/domain/entities/spelling/word_mastery.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_attempt.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_statistics.dart';
import 'package:streamshaala/domain/entities/spelling/phonics_pattern.dart';

/// Repository interface for spelling learning features
abstract class SpellingRepository {
  // Word Lists
  Future<Either<Exception, List<WordList>>> getWordLists({int? gradeLevel, String? category});
  Future<Either<Exception, WordList>> getWordListById(String id);

  // Words
  Future<Either<Exception, List<Word>>> getWordsForList(String wordListId);
  Future<Either<Exception, Word>> getWordById(String id);
  Future<Either<Exception, List<Word>>> searchWords(String query);
  Future<Either<Exception, Word>> getWordOfTheDay();
  Future<Either<Exception, List<Word>>> getWordsByGrade(int gradeLevel);
  Future<Either<Exception, List<Word>>> getWordsByPhonicsPattern(String pattern);

  // Mastery
  Future<Either<Exception, WordMastery>> getWordMastery(String wordId, {String? profileId});
  Future<Either<Exception, List<WordMastery>>> getAllMasteries({String? profileId});
  Future<Either<Exception, void>> saveWordMastery(WordMastery mastery);
  Future<Either<Exception, List<Word>>> getWeakWords({String? profileId, int limit = 20});
  Future<Either<Exception, List<Word>>> getDueForReview({String? profileId});

  // Attempts
  Future<Either<Exception, void>> saveSpellingAttempt(SpellingAttempt attempt);
  Future<Either<Exception, List<SpellingAttempt>>> getAttemptsForWord(String wordId, {String? profileId});

  // Statistics
  Future<Either<Exception, SpellingStatistics>> getStatistics({String? profileId});

  // Phonics
  Future<Either<Exception, List<PhonicsPattern>>> getPhonicsPatterns({int? gradeLevel});
  Future<Either<Exception, PhonicsPattern>> getPhonicsPatternById(String id);
}
