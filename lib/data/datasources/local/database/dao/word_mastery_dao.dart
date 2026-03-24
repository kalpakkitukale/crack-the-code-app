import 'package:sqflite/sqflite.dart';

/// DAO for word mastery records
class WordMasteryDao {
  final Database db;

  WordMasteryDao(this.db);

  static const String tableName = 'word_mastery';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      word_id TEXT NOT NULL,
      word TEXT NOT NULL,
      level TEXT NOT NULL DEFAULT 'newWord',
      correct_streak INTEGER NOT NULL DEFAULT 0,
      total_attempts INTEGER NOT NULL DEFAULT 0,
      correct_attempts INTEGER NOT NULL DEFAULT 0,
      last_attempted_at TEXT,
      next_review_at TEXT,
      ease_factor REAL NOT NULL DEFAULT 2.5,
      interval_days INTEGER NOT NULL DEFAULT 0,
      profile_id TEXT NOT NULL DEFAULT '',
      PRIMARY KEY (word_id, profile_id)
    )
  ''';

  static const String createIndexQuery = '''
    CREATE INDEX IF NOT EXISTS idx_word_mastery_profile ON $tableName(profile_id)
  ''';

  static const String createReviewIndexQuery = '''
    CREATE INDEX IF NOT EXISTS idx_word_mastery_review ON $tableName(next_review_at)
  ''';

  Future<void> upsert(Map<String, dynamic> data) async {
    await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getByWordId(String wordId,
      {String? profileId}) async {
    final results = await db.query(
      tableName,
      where: 'word_id = ? AND profile_id = ?',
      whereArgs: [wordId, profileId ?? ''],
    );
    return results.isEmpty ? null : results.first;
  }

  Future<List<Map<String, dynamic>>> getAll({String? profileId}) async {
    return db.query(
      tableName,
      where: profileId != null ? 'profile_id = ?' : null,
      whereArgs: profileId != null ? [profileId] : null,
    );
  }

  Future<List<Map<String, dynamic>>> getDueForReview(
      {String? profileId}) async {
    final now = DateTime.now().toIso8601String();
    return db.query(
      tableName,
      where: profileId != null
          ? '(next_review_at IS NULL OR next_review_at <= ?) AND profile_id = ? AND level != ?'
          : '(next_review_at IS NULL OR next_review_at <= ?) AND level != ?',
      whereArgs: profileId != null
          ? [now, profileId, 'newWord']
          : [now, 'newWord'],
    );
  }

  Future<List<Map<String, dynamic>>> getByLevel(String level,
      {String? profileId}) async {
    return db.query(
      tableName,
      where: profileId != null
          ? 'level = ? AND profile_id = ?'
          : 'level = ?',
      whereArgs: profileId != null ? [level, profileId] : [level],
    );
  }

  Future<int> getMasteredCount({String? profileId}) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE level = ? ${profileId != null ? 'AND profile_id = ?' : ''}',
      profileId != null ? ['mastered', profileId] : ['mastered'],
    );
    return result.first['count'] as int? ?? 0;
  }
}
