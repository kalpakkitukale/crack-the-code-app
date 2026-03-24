import 'package:sqflite/sqflite.dart';

/// DAO for spelling attempt records
class SpellingAttemptDao {
  final Database db;

  SpellingAttemptDao(this.db);

  static const String tableName = 'spelling_attempts';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      word_id TEXT NOT NULL,
      word TEXT NOT NULL,
      user_input TEXT NOT NULL,
      is_correct INTEGER NOT NULL DEFAULT 0,
      activity_type TEXT NOT NULL,
      time_spent_ms INTEGER NOT NULL DEFAULT 0,
      attempted_at TEXT NOT NULL,
      profile_id TEXT NOT NULL DEFAULT '',
      attempt_number INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String createIndexQuery = '''
    CREATE INDEX IF NOT EXISTS idx_spelling_attempts_word_id ON $tableName(word_id)
  ''';

  static const String createProfileIndexQuery = '''
    CREATE INDEX IF NOT EXISTS idx_spelling_attempts_profile ON $tableName(profile_id)
  ''';

  Future<void> insert(Map<String, dynamic> data) async {
    await db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getByWordId(String wordId,
      {String? profileId}) async {
    final where = profileId != null
        ? 'word_id = ? AND profile_id = ?'
        : 'word_id = ?';
    final args = profileId != null ? [wordId, profileId] : [wordId];
    return db.query(tableName,
        where: where, whereArgs: args, orderBy: 'attempted_at DESC');
  }

  Future<List<Map<String, dynamic>>> getAll(
      {String? profileId, int? limit}) async {
    return db.query(
      tableName,
      where: profileId != null ? 'profile_id = ?' : null,
      whereArgs: profileId != null ? [profileId] : null,
      orderBy: 'attempted_at DESC',
      limit: limit,
    );
  }

  Future<Map<String, dynamic>> getStatistics({String? profileId}) async {
    final where = profileId != null ? 'WHERE profile_id = ?' : '';
    final args = profileId != null ? [profileId] : <dynamic>[];

    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as total, SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) as correct FROM $tableName $where',
      args,
    );

    final total = totalResult.first['total'] as int? ?? 0;
    final correct = totalResult.first['correct'] as int? ?? 0;

    return {'totalAttempts': total, 'totalCorrect': correct};
  }
}
